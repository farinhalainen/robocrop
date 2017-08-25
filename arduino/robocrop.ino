#include <SPI.h>
#include <WiFi101.h>
#include <WiFiUdp.h>

// ID
// ----------------------------------------
byte PLANT_ID = B00001;


// WIFI NETWORK SETTINGS
// ----------------------------------------
char ssid[] = "X"; //  your network SSID (name) 
char pass[] = "X";    // your network password (use for WPA, or use as key for WEP)


// UDP SERVER ADDRESS
// ----------------------------------------
IPAddress remote_ip(192,168,1,X);
unsigned int remote_port = 2390;


// SETTINGS
// ----------------------------------------
int INTERVAL = 1000 * 60 * 5;

int SENSE_PIN = 0; // Soil Sensor input at Analog PIN A0
unsigned int value = 0;
byte buf[3]; // 3 byte array used for our simple format -> 1 byte for ID, 2 bytes for value(Big Endian)

int status = WL_IDLE_STATUS;
WiFiUDP Udp;


// SETUP
// ----------------------------------------
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);

  //Initialize serial and wait for port to open:
  Serial.begin(9600);
  Serial.println("ROBOCROP SOIL MOISTURE SENSOR");
  Serial.println("-----------------------------");
  delay(1000);
  //while (!Serial) {
  //  ; // wait for serial port to connect.
  //}

  // check for the presence of the shield:
  if (WiFi.status() == WL_NO_SHIELD) {
    Serial.println("WiFi shield not present"); 
    // don't continue:
    while(true);
  } 

  // attempt to connect to Wifi network:
  while ( status != WL_CONNECTED) {
    Serial.print("Attempting to connect to WPA SSID: ");
    Serial.println(ssid);
    // Connect to WPA/WPA2 network:    
    status = WiFi.begin(ssid, pass);
    // wait 10 seconds for connection:
    delay(1000);
  }

  // you're connected now, so print out the data:
  Serial.print("You're connected to the network");
  delay(10000);
  printWifiStatus();

  Serial.println("\nStarting connection to server...");
  // Open socket connection
  Udp.begin(44);

  digitalWrite(LED_BUILTIN, LOW);
}


// LOOP
// ----------------------------------------
void loop() {
  value = analogRead(SENSE_PIN);
  buf[0] = PLANT_ID; // first byte: plant id
  buf[1] = highByte(value); // second byte: most significant byte of 2 byte int
  buf[2] = lowByte(value); // third byte, least significant byte
  Udp.beginPacket(remote_ip, remote_port);
  Udp.write(buf, 3);
  Udp.endPacket();
  Serial.println(PLANT_ID);
  Serial.println(value);
  Serial.println("---");
  delay(INTERVAL);
}


// FUNCTIONS
// ----------------------------------------
void printWifiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
}
