const WebSocket = require('ws');
const mysql = require('mysql');

// WebSocket Server Configuration
const wss = new WebSocket.Server({ port: 8080 });

// Database Configuration
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'led_test'
});

db.connect(err => {
    if (err) {
        console.error('Database connection failed:', err);
        return;
    }
    console.log('Connected to MySQL database.');
});

// WebSocket Handling
wss.on('connection', ws => {
    console.log('New client connected.');

    ws.on('message', message => {
        console.log(`Received: ${message}`);

        if (message.startsWith('rfid_scan:')) {
            const rfidTag = message.split(':')[1];

            // Check RFID in Database
            const query = `SELECT led_pin FROM led WHERE rfid_tag = ?`;
            db.query(query, [rfidTag], (err, results) => {
                if (err) {
                    console.error('Database error:', err);
                    ws.send('error: Database error');
                    return;
                }

                if (results.length > 0) {
                    const ledPin = results[0].led_pin;
                    ws.send(`identify_led:${ledPin}`);
                } else {
                    ws.send('error: Unregistered RFID tag');
                }
            });
        }
    });

    ws.on('close', () => {
        console.log('Client disconnected.');
    });
});

console.log('WebSocket server running on ws://localhost:8080');
