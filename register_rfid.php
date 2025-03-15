<?php
require 'config.php';

if (isset($_POST['rfid']) && isset($_POST['locker_number']) && isset($_POST['led_pin'])) {
    $rfidTag = $conn->real_escape_string($_POST['rfid']);
    $lockerNumber = (int)$_POST['locker_number'];
    $ledPin = (int)$_POST['led_pin'];

    $sql = "INSERT INTO solenoid_locks (rfid_tag, locker_number, led_pin) 
            VALUES ('$rfidTag', '$lockerNumber', '$ledPin')";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["success" => "RFID registered successfully"]);
    } else {
        echo json_encode(["error" => "Failed to register RFID"]);
    }
} else {
    echo json_encode(["error" => "Incomplete data provided"]);
}
$conn->close();
?>
