<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");

// Database configuration
$host = "localhost";
$db_name = "stockly";
$username = "root";
$password = "";

try {
    // Establishing connection
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $username, $password);
    // Set error mode to exception
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Get the user_id from the URL
    $userId = isset($_GET['user_id']) ? $_GET['user_id'] : '';

    if(!empty($userId)) {
        /**
         * SQL Logic:
         * 1. Filter by user_id to ensure the farmer only sees THEIR data.
         * 2. Filter by status 'Pending' or 'Approved' (Scheduled).
         * 3. Sort by delivery_date ASC so the next upcoming appointment is at the top.
         */
        $query = "SELECT * FROM appointments 
                  WHERE user_id = :uid 
                  AND status IN ('Pending', 'Approved') 
                  ORDER BY delivery_date ASC";
                  
        $stmt = $conn->prepare($query);
        
        // Bind the ID and execute
        $stmt->execute(['uid' => $userId]);

        $appointments = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Send results
        echo json_encode([
            "success" => true, 
            "data" => $appointments
        ]);
    } else {
        // Error if no user_id is provided in the Flutter URL
        echo json_encode([
            "success" => false, 
            "message" => "User ID missing in request"
        ]);
    }

} catch(PDOException $e) {
    // Catch any database errors
    echo json_encode([
        "success" => false, 
        "message" => "Database Error: " . $e->getMessage()
    ]);
}
?>