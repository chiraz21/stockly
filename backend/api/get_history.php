<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");

$host = "localhost";
$db_name = "stockly";
$username = "root";
$password = "";

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $username, $password);
    
    $userId = $_GET['user_id'] ?? '';

    if(!empty($userId)) {
        // Fetch finished or turned down appointments. DESC shows the newest history first.
        $query = "SELECT * FROM appointments 
                  WHERE user_id = :uid 
                  AND status IN ('Completed', 'Rejected', 'Cancelled') 
                  ORDER BY delivery_date DESC";
                  
        $stmt = $conn->prepare($query);
        $stmt->bindParam(':uid', $userId);
        $stmt->execute();

        $history = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(["success" => true, "data" => $history]);
    } else {
        echo json_encode(["success" => false, "message" => "User ID missing"]);
    }
} catch(PDOException $e) {
    echo json_encode(["success" => false, "message" => $e->getMessage()]);
}
?>