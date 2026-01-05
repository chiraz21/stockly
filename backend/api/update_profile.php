<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");

$host = "localhost";
$db_name = "stockly";
$username = "root";
$password = "";

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $username, $password);
    
    $json = file_get_contents('php://input');
    $data = json_decode($json);

    if(!empty($data->user_id)) {
        $query = "UPDATE users SET name = :name, email = :email, phone = :phone WHERE id = :uid";
        $stmt = $conn->prepare($query);
        
        $stmt->bindParam(':name', $data->full_name);
        $stmt->bindParam(':email', $data->email);
        $stmt->bindParam(':phone', $data->phone);
        $stmt->bindParam(':uid', $data->user_id);

        if($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Profile updated!"]);
        } else {
            echo json_encode(["success" => false, "message" => "Update failed."]);
        }
    }
} catch(PDOException $e) {
    echo json_encode(["success" => false, "message" => $e->getMessage()]);
}
?>