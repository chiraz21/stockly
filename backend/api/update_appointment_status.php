<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");

$host = "localhost";
$db_name = "stockly";
$username = "root";
$password = "";

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name;charset=utf8mb4", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['id']) || !isset($data['status'])) {
        echo json_encode(["success" => false, "message" => "Missing input"]);
        exit;
    }

    $appId = $data['id'];
    $newStatus = $data['status'];

    $conn->beginTransaction();

    // 1. Update Appointment Status
    $stmt = $conn->prepare("UPDATE appointments SET status = ? WHERE id = ?");
    $stmt->execute([$newStatus, $appId]);

    // 2. STRIKE LOGIC: Only runs if status is 'Not Completed'
    if ($newStatus === 'Not Completed') {
        // Change: Using 'user_id' to match your specific table structure
        $stmt = $conn->prepare("SELECT user_id FROM appointments WHERE id = ?");
        $stmt->execute([$appId]);
        $uId = $stmt->fetchColumn();

        if ($uId) {
            // Increment strike
            $stmt = $conn->prepare("UPDATE users SET no_show_count = no_show_count + 1 WHERE id = ?");
            $stmt->execute([$uId]);

            // Check for suspension
            $stmt = $conn->prepare("SELECT no_show_count FROM users WHERE id = ?");
            $stmt->execute([$uId]);
            $count = $stmt->fetchColumn();

            if ($count >= 3) {
                $stmt = $conn->prepare("UPDATE users SET status = 'suspended' WHERE id = ?");
                $stmt->execute([$uId]);
            }
        }
    }

    $conn->commit();
    echo json_encode(["success" => true, "message" => "Update successful"]);

} catch (Exception $e) {
    if (isset($conn)) $conn->rollBack();
    echo json_encode(["success" => false, "message" => $e->getMessage()]);
}
?>