#include <WiFi.h>
#include <Servo.h>

const char* ssid = "MUTHU";
const char* password = "Ravenclaw";

WiFiServer server(80);
Servo servo1;  // Red
Servo servo2;  // Green
Servo servo3;  // Blue

void setup() {
  Serial.begin(115200);
  
  servo1.attach(21);  // Servo 1 
  servo2.attach(22);  // Servo 2
  servo3.attach(24);  // Servo 3

  
  servo1.write(0);
  servo2.write(0);
  servo3.write(0);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());
  
  server.begin();
}

void loop() {
  WiFiClient client = server.available();
  if (client) {
    String request = client.readStringUntil('\r');
    client.flush();
    
    Serial.println(request);
    
    if (request.indexOf("/color/red") != -1) {
      activateServo(servo1, 50);
    } else if (request.indexOf("/color/green") != -1) {
      activateServo(servo2, 50);
    } else if (request.indexOf("/color/blue") != -1) {
      activateServo(servo3, 50);
    }

    client.println("HTTP/1.1 200 OK");
    client.println("Content-type:text/html");
    client.println();
    client.println("Command received");
    client.stop();
  }
}

void activateServo(Servo& servo, int angle) {
  servo.write(angle); 
  delay(3000);        
  servo.write(0);
}