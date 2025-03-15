<?php
require 'config.php';

if (isset($_GET['rfid'])) {
    $scannedRFID = $conn->real_escape_string($_GET['rfid']);
    $sql = "SELECT led_pin FROM solenoid_locks WHERE rfid_tag = '$scannedRFID'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        echo json_encode(["success" => true, "led_pin" => $row['led_pin']]);
    } else {
        echo json_encode(["error" => "RFID not registered"]);
    }
} else {
    echo json_encode(["error" => "No RFID provided"]);
}
$conn->close();
?>
