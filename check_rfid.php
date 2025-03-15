<?php

require 'config.php';


if (isset($_GET['rfid'])) {
    $scannedRFID = $conn->real_escape_string($_GET['rfid']);
    $sql = "SELECT locker_number FROM solenoid_locks WHERE rfid_tag = '$scannedRFID'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        echo json_encode(["success" => true, "locker" => $row['locker_number']]);
    } else {
        echo json_encode(["error" => "Access Denied"]);
    }
} else {
    echo json_encode(["error" => "No RFID provided"]);
}
$conn->close();
?>
