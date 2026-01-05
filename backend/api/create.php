<?php
// 1. Set headers to JSON and allow access
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");

// 2. Database Connection
$host = "localhost";
$db_name = "stockly";
$username = "root";
$password = "";

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // 3. Get the JSON body from Flutter
    $json = file_get_contents('php://input');
    $data = json_decode($json);

    if(!empty($data->user_id) && !empty($data->grain_type)) {
        $query = "INSERT INTO appointments (user_id, grain_type, quantity_kg, delivery_date, preferred_time) 
                  VALUES (:uid, :gt, :qty, :dd, :pt)";
        
        $stmt = $conn->prepare($query);
        
        $stmt->bindParam(':uid', $data->user_id);
        $stmt->bindParam(':gt', $data->grain_type);
        $stmt->bindParam(':qty', $data->quantity_kg);
        $stmt->bindParam(':dd', $data->delivery_date);
        $stmt->bindParam(':pt', $data->preferred_time);

        if($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Appointment created."]);
        } else {
            echo json_encode(["success" => false, "message" => "SQL Execution failed."]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Incomplete data."]);
    }

} catch(PDOException $e) {
    // If there is an error, send it as JSON, not HTML!
    echo json_encode(["success" => false, "message" => "Connection error: " . $e->getMessage()]);
}
?>