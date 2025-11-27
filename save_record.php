<?php
session_start();
include 'db.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    if (!isset($_SESSION['username'])) {
        header("Location: index.php");
        exit;
    }

    $user_id = $_SESSION['username'];
    $record_type_id = $_POST['record_type_id'];

    $checkUser = $conn->prepare("SELECT * FROM users WHERE username = ?");
    $checkUser->execute([$user_id]);
    if ($checkUser->rowCount() === 0) {
        die("Error: User does not exist in the database.");
    }

    $checkPending = $conn->prepare("
        SELECT * FROM record_requests 
        WHERE user_id = ? AND record_type_id = ? AND status = 'Pending'
    ");
    $checkPending->execute([$user_id, $record_type_id]);

    if ($checkPending->rowCount() > 0) {
        header("Location: records.php?pending=1");
        exit;
    }

    $sql = "INSERT INTO record_requests 
            (request_id, user_id, record_type_id, status, date_requested) 
            VALUES (UUID(), ?, ?, 'Pending', NOW())";

    $stmt = $conn->prepare($sql);

    if ($stmt->execute([$user_id, $record_type_id])) {
        header("Location: records.php?success=1");
        exit;
    } else {
        echo "Database Error";
    }
}
?>
