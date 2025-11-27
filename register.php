<?php
include 'db.php';
session_start();

function generateStudentNumber($length = 6) {
    return 'S' . substr(str_shuffle('0123456789'), 0, $length);
}

if(isset($_POST['first_name'], $_POST['last_name'], $_POST['email'], $_POST['password'])){
    $first_name = $_POST['first_name'];
    $last_name = $_POST['last_name'];
    $email = $_POST['email'];
    $password = password_hash($_POST['password'], PASSWORD_DEFAULT);
    $student_number = generateStudentNumber();

    $stmt_check = $conn->prepare("SELECT * FROM users WHERE username = :username");
    $stmt_check->bindParam(':username', $student_number);
    $stmt_check->execute();
    while($stmt_check->rowCount() > 0){
        $student_number = generateStudentNumber();
        $stmt_check->bindParam(':username', $student_number);
        $stmt_check->execute();
    }

    $course_stmt = $conn->query("SELECT id FROM courses ORDER BY RAND() LIMIT 1");
    $course_id = $course_stmt->fetchColumn();

    $stmt = $conn->prepare("
        INSERT INTO users (username, first_name, last_name, email, password, course_id)
        VALUES (:username, :first_name, :last_name, :email, :password, :course_id)
    ");
    $stmt->bindParam(':username', $student_number);
    $stmt->bindParam(':first_name', $first_name);
    $stmt->bindParam(':last_name', $last_name);
    $stmt->bindParam(':email', $email);
    $stmt->bindParam(':password', $password);
    $stmt->bindParam(':course_id', $course_id);

    if($stmt->execute()){
        $_SESSION['student_number'] = $student_number;
        $_SESSION['first_name'] = $first_name;
        header("Location: register_success.php");
        exit;
    } else {
        echo "Error registering user.";
    }
}

?>
