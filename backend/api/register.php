<?php
header("Content-Type: application/json");
require_once "../config/db.php";

$data = json_decode(file_get_contents("php://input"), true);

$name     = $data['name'];
$email    = $data['email'];
$phone    = $data['phone'];
$password = hash("sha256", $data['password']);

$stmt = $pdo->prepare("SELECT id FROM users WHERE email=?");
$stmt->execute([$email]);

if ($stmt->rowCount() > 0) {
    echo json_encode(["success"=>false,"message"=>"Email already exists"]);
    exit;
}

$stmt = $pdo->prepare(
  "INSERT INTO users (name,email,phone,password,role)
   VALUES (?,?,?,?, 'farmer')"
);

$stmt->execute([$name,$email,$phone,$password]);

echo json_encode(["success"=>true]);
