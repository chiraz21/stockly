<?php
header("Content-Type: application/json");
require_once "../config/db.php";

$data = json_decode(file_get_contents("php://input"), true);

$email    = $data['email'];
$password = hash("sha256", $data['password']);

$stmt = $pdo->prepare(
 "SELECT id,name,email,phone,role
  FROM users
  WHERE email=? AND password=?"
);
$stmt->execute([$email,$password]);

$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    echo json_encode(["success"=>false]);
    exit;
}

echo json_encode(["success"=>true,"user"=>$user]);
