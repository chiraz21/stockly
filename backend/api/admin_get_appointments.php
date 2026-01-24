<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");

require_once "../config/db.php";

try {
    $stmt = $pdo->query("
        SELECT 
            a.id,
            a.grain_type,
            a.quantity_kg,
            a.delivery_date,
            a.preferred_time,
            a.status,
            u.name AS farmer_name
        FROM appointments a
        JOIN users u ON a.user_id = u.id
        ORDER BY a.created_at DESC
    ");

    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        "success" => true,
        "data" => $data
    ]);
} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "message" => "DB Error"
    ]);
}
