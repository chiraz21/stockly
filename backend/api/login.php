<?php
// ================= HEADERS =================
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// ================= DB CONNECTION =================
require_once "../config/db.php";

// ================= READ JSON INPUT =================
$input = file_get_contents("php://input");
$data = json_decode($input, true);

// ================= VALIDATION =================
if (!isset($data['email']) || !isset($data['password'])) {
    echo json_encode([
        "success" => false,
        "message" => "Email and password are required"
    ]);
    exit;
}

$email = trim($data['email']);
$password = hash("sha256", $data['password']); // SAME HASH USED IN DB

try {
    // ================= QUERY USER =================
    $stmt = $pdo->prepare("
        SELECT 
            id,
            name,
            email,
            phone,
            role,
            status
        FROM users
        WHERE email = ? AND password = ?
        LIMIT 1
    ");

    $stmt->execute([$email, $password]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    // ================= CHECK USER =================
    if (!$user) {
        echo json_encode([
            "success" => false,
            "message" => "Invalid email or password"
        ]);
        exit;
    }

    // ================= CHECK STATUS =================
    if ($user['status'] !== 'active') {
        echo json_encode([
            "success" => false,
            "message" => "Account is suspended"
        ]);
        exit;
    }

    // ================= SUCCESS RESPONSE =================
    echo json_encode([
        "success" => true,
        "user" => [
            "id"    => (int)$user['id'],
            "name"  => $user['name'],
            "email" => $user['email'],
            "phone" => $user['phone'],
            "role"  => $user['role'],   // farmer | admin | system
            "status"=> $user['status']
        ]
    ]);

} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "message" => "Database error"
    ]);
}
