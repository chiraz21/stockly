<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");

$host = "localhost";
$db_name = "stockly";
$username = "root";
$password = "";

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $username, $password);
    
    // Get userId from the URL parameter (e.g., get_appointments.php?user_id=5)
    $userId = $_GET['user_id'];

    if(!empty($userId)) {
        $query = "SELECT * FROM appointments WHERE user_id = :uid ORDER BY delivery_date DESC";
        $stmt = $conn->prepare($query);
        $stmt->bindParam(':uid', $userId);
        $stmt->execute();

        $appointments = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(["success" => true, "data" => $appointments]);
    } else {
        echo json_encode(["success" => false, "message" => "User ID missing"]);
    }
} catch(PDOException $e) {
    echo json_encode(["success" => false, "message" => $e->getMessage()]);
}
?>