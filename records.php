<?php
session_start();

ini_set('display_errors', 1);
error_reporting(E_ALL);

include 'db.php';

if (!isset($_SESSION['username'])) {
    header("Location: index.php");
    exit;
}

$user_id = $_SESSION['username'];

$types_stmt = $conn->prepare("SELECT * FROM record_types");
$types_stmt->execute();
$types = $types_stmt->fetchAll(PDO::FETCH_ASSOC);

$currentCourseStmt = $conn->prepare("
    SELECT c.course_name, c.id 
    FROM users u
    JOIN courses c ON u.course_id = c.id
    WHERE u.username = ?
");
$currentCourseStmt->execute([$user_id]);
$currentCourse = $currentCourseStmt->fetch(PDO::FETCH_ASSOC);

$otherCoursesStmt = $conn->prepare("
    SELECT id, course_name 
    FROM courses 
    WHERE id != ?
    ORDER BY course_name ASC
");
$otherCoursesStmt->execute([$currentCourse['id']]);
$otherCourses = $otherCoursesStmt->fetchAll(PDO::FETCH_ASSOC);

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Records - Smart Campus Hub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="shortcut icon" type="image/png" href="cake.png"/>
    <link rel="stylesheet" href="styles.css">
</head>
<body>

<nav class="navbar sticky-top navbar-dark" style="background-color: #06326b;">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">
      <img src="cake.png" alt="" width="30" height="24" class="d-inline-block align-text-top">
      <u style="font-size: 25px">Smart Campus App</u>
    </a>
  </div>
</nav>

<div class="main-container">
    <div class="sidebar text-white p-3">        
        <a href="profile.php" class="text-white d-block mb-3">Profile</a>
        <a href="subjects.php" class="text-white d-block mb-3">Subjects</a>
        <a href="records.php" class="text-warning fw-bold d-block mb-3">Records</a>
        <a href="ecd.php" class="text-white d-block mb-3">ECD</a>
        <a href="about.php" class="text-white d-block mb-3">About</a>
        <a href="index.php" class="btn btn-danger mt-5">Sign Out</a>
    </div>

    <div class="flex-grow-1 p-4">

        <h3 class="mb-4">Records</h3>

        <?php if (isset($_GET['pending'])): ?>
        <div class="alert alert-warning">You already have a pending request for this record.</div>
        <?php endif; ?>

        <?php if (isset($_GET['success'])): ?>
            <div class="alert alert-success">Your request has been submitted successfully.</div>
        <?php endif; ?>

        <ul class="nav nav-tabs" id="recordTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="request-tab" data-bs-toggle="tab" 
                        data-bs-target="#request" type="button" role="tab">
                    Submit Request
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="history-tab" data-bs-toggle="tab" 
                        data-bs-target="#history" type="button" role="tab">
                    Request History
                </button>
            </li>
        </ul>

        <div class="tab-content mt-4">

            <div class="tab-pane fade show active" id="request" role="tabpanel">
                <div class="card p-4 shadow-sm mb-4">
                    <form action="save_record.php" method="POST">
                        <label class="form-label fw-bold">Select Request Type</label>
                        <select class="form-select mb-3" name="record_type_id" required>
                            <option value="">-- Choose --</option>
                            <?php foreach ($types as $row): ?>
                                <option value="<?= $row['id']; ?>">
                                    <?= $row['record_name']; ?>
                                </option>
                            <?php endforeach; ?>
                        </select>

                        <button type="submit" class="btn btn-primary">Submit Request</button>
                    </form>
                </div>

                <div id="shiftingForm" class="mt-3 p-3 border rounded bg-light" style="display:none;">
                    <h5 class="mb-3">Shifting Program Form</h5>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Current Program</label>
                        <input type="text" class="form-control" value="<?= htmlspecialchars($currentCourse['course_name']); ?>" disabled>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Choose New Program</label>
                        <select class="form-select">
                            <option value="">-- Select Program --</option>
                            <?php foreach ($otherCourses as $course): ?>
                                <option value="<?= $course['id']; ?>"><?= htmlspecialchars($course['course_name']); ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                </div>
            </div>

            <div class="tab-pane fade" id="history" role="tabpanel">
                <h4>Your Request History</h4>
                <table class="table table-bordered table-striped mt-3 bg-white shadow-sm">
                    <thead>
                        <tr>
                            <th>Reference ID</th>
                            <th>Type</th>
                            <th>Status</th>
                            <th>Date Requested</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        $sql = "
                            SELECT rr.*, rt.record_name
                            FROM record_requests rr
                            JOIN record_types rt ON rr.record_type_id = rt.id
                            WHERE rr.user_id = ?
                            ORDER BY rr.date_requested DESC
                        ";
                        $stmt = $conn->prepare($sql);
                        $stmt->execute([$user_id]);

                        foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $row):
                        ?>
                        <tr>
                            <td><?= $row['request_id']; ?></td>
                            <td><?= $row['record_name']; ?></td>
                            <td><?= $row['status']; ?></td>
                            <td><?= $row['date_requested']; ?></td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function() {
    const dropdown = document.querySelector("select[name='record_type_id']");
    const shiftingForm = document.getElementById("shiftingForm");

    dropdown.addEventListener("change", function() {
        if (this.value == "1") { 
            shiftingForm.style.display = "block";
        } else {
            shiftingForm.style.display = "none";
            resetShiftingForm();
        }
    });

    document.querySelectorAll('[data-bs-toggle="tab"]').forEach(tab => {
        tab.addEventListener("shown.bs.tab", function() {
            shiftingForm.style.display = "none";
            dropdown.value = "";
            resetShiftingForm();
        });
    });

    function resetShiftingForm() {
        const newProgramDropdown = shiftingForm.querySelector("select");
        if (newProgramDropdown) {
            newProgramDropdown.value = "";
        }
    }
});
</script>

</body>
</html>
