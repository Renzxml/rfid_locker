#include <WiFi.h>
#include <WebSocketsClient.h>
#include <MFRC522v2.h>
#include <MFRC522DriverSPI.h>
#include <MFRC522DriverPinSimple.h>
#include <SPI.h>

#define SS_PIN 5      // RFID SDA Pin (GPIO 5)
#define RST_PIN 27    // RFID Reset Pin (GPIO 27)

#define LED1_PIN 4    // GPIO 4
#define LED2_PIN 12   // GPIO 12
#define LED3_PIN 13   // GPIO 13

const char* ssid = "Nothing Happened";
const char* password = "Semicolon123*";

const char* websocketServer = "192.168.1.14"; // WebSocket Server IP
const int websocketPort = 8080;                // WebSocket Server Port

WebSocketsClient webSocket;

// RFID Module
MFRC522DriverPinSimple ss_pin(SS_PIN);
MFRC522DriverSPI driver{ss_pin};
MFRC522 mfrc522{driver};

// WebSocket Event Handler
void webSocketEvent(WStype_t type, uint8_t * payload, size_t length) {
    switch(type) {
        case WStype_CONNECTED:
            Serial.println("Connected to WebSocket server!");
            webSocket.sendTXT("ESP32 connected");
            break;

        case WStype_TEXT: {
            String message = String((char*)payload);
            Serial.println("Received: " + message);

            if (message.startsWith("identify_led:")) {
                String ledPin = message.substring(13); // Extract LED Pin
                if (ledPin == "4") digitalWrite(LED1_PIN, HIGH);
                else if (ledPin == "12") digitalWrite(LED2_PIN, HIGH);
                else if (ledPin == "13") digitalWrite(LED3_PIN, HIGH);

                delay(5000); // LED stays on for 5 seconds
                digitalWrite(LED1_PIN, LOW);
                digitalWrite(LED2_PIN, LOW);
                digitalWrite(LED3_PIN, LOW);
            }
        }
        break;

        case WStype_DISCONNECTED:
            Serial.println("Disconnected from WebSocket server.");
            break;
    }
}

void setup() {
    Serial.begin(115200);
    SPI.begin();

    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.println("Connecting to WiFi...");
    }
    Serial.println("WiFi connected!");

    webSocket.begin(websocketServer, websocketPort, "/");
    webSocket.onEvent(webSocketEvent);

    mfrc522.PCD_Init();

    pinMode(LED1_PIN, OUTPUT);
    pinMode(LED2_PIN, OUTPUT);
    pinMode(LED3_PIN, OUTPUT);

    digitalWrite(LED1_PIN, LOW);
    digitalWrite(LED2_PIN, LOW);
    digitalWrite(LED3_PIN, LOW);

    Serial.println("Setup complete. Ready to scan RFID cards.");
}

void loop() {
    webSocket.loop();

    // Check for RFID presence
    if (mfrc522.PICC_IsNewCardPresent() && mfrc522.PICC_ReadCardSerial()) {
        String scannedRFID = "";

        // Convert UID to string
        for (byte i = 0; i < mfrc522.uid.size; i++) {
            scannedRFID += String(mfrc522.uid.uidByte[i], HEX);
        }

        scannedRFID.toUpperCase(); // Convert to uppercase for consistency
        Serial.println("RFID Scanned: " + scannedRFID);

        // Send scanned RFID to WebSocket server
        webSocket.sendTXT("rfid_scan:" + scannedRFID);

        delay(1000); // Small delay for stability
    }
}
