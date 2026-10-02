#include <Wire.h>
#include <SPI.h>
#include <MFRC522.h>
#include <RTClib.h>

// Sanctum IQ browser bridge expects 115200 baud and a newline-delimited JSON
// request/reply. Adjust these pins to match your actual wiring before upload.
constexpr uint32_t SERIAL_BAUD = 115200;
constexpr uint8_t ULTRASONIC_TRIG_PIN = 7;
constexpr uint8_t ULTRASONIC_ECHO_PIN = 8;
constexpr uint8_t RFID_SS_PIN = 10;
constexpr uint8_t RFID_RST_PIN = 9;
constexpr uint8_t MOISTURE_ANALOG_PIN = A0;
constexpr uint8_t RTC_I2C_ADDRESS = 0x68;
constexpr uint8_t OLED_I2C_ADDRESS_A = 0x3C;
constexpr uint8_t OLED_I2C_ADDRESS_B = 0x3D;

MFRC522 rfid(RFID_SS_PIN, RFID_RST_PIN);
RTC_DS3231 rtc;
char requestLine[128];
size_t requestLength = 0;

bool i2cAcknowledges(uint8_t address) {
  Wire.beginTransmission(address);
  return Wire.endTransmission() == 0;
}

bool ultrasonicResponds() {
  pinMode(ULTRASONIC_TRIG_PIN, OUTPUT);
  pinMode(ULTRASONIC_ECHO_PIN, INPUT);

  // Require a plausible echo from at least one of three attempts.
  for (uint8_t attempt = 0; attempt < 3; ++attempt) {
    digitalWrite(ULTRASONIC_TRIG_PIN, LOW);
    delayMicroseconds(3);
    digitalWrite(ULTRASONIC_TRIG_PIN, HIGH);
    delayMicroseconds(10);
    digitalWrite(ULTRASONIC_TRIG_PIN, LOW);

    const unsigned long duration = pulseIn(ULTRASONIC_ECHO_PIN, HIGH, 28000UL);
    const float distanceCm = duration * 0.0343f / 2.0f;
    if (duration > 0 && distanceCm >= 2.0f && distanceCm <= 400.0f) {
      return true;
    }
    delay(30);
  }
  return false;
}

const char* rfidHealth() {
  rfid.PCD_Init();
  delay(5);
  const byte version = rfid.PCD_ReadRegister(MFRC522::VersionReg);
  // Common MFRC522 revisions return 0x91 or 0x92. Clones may use another
  // nonzero/non-0xFF value, so report them as present rather than rejecting.
  if (version == 0x00 || version == 0xFF) return "MISSING";
  return "HEALTHY";
}

const char* rtcHealth() {
  if (!rtc.begin(&Wire)) return "MISSING";
  if (rtc.lostPower()) return "WARNING";
  return "HEALTHY";
}

const char* oledHealth() {
  if (i2cAcknowledges(OLED_I2C_ADDRESS_A) ||
      i2cAcknowledges(OLED_I2C_ADDRESS_B)) {
    return "HEALTHY";
  }
  return "MISSING";
}

void sendDiagnostics() {
  const char* ultrasonic = ultrasonicResponds() ? "HEALTHY" : "MISSING";
  const char* moisture = "NOT TESTED";
  const char* rfidState = rfidHealth();
  const char* servo = "NOT TESTED";
  const char* rtcState = rtcHealth();
  const char* oled = oledHealth();

  // A one-wire analog moisture probe has no reliable presence signature. A
  // disconnected analog input can look like a valid dry/wet reading. Likewise,
  // a servo without position feedback cannot confirm that it physically moved.
  // Keep both NOT TESTED instead of reporting a false HEALTHY/MISSING result.
  (void)MOISTURE_ANALOG_PIN;

  char response[256];
  snprintf(response, sizeof(response),
    "{\"protocol\":\"sanctum-iq/1\",\"components\":{" 
    "\"arduino\":\"HEALTHY\",\"ultrasonic\":\"%s\","
    "\"moisture\":\"%s\",\"rfid\":\"%s\",\"servo\":\"%s\","
    "\"rtc\":\"%s\",\"oled\":\"%s\"}}",
    ultrasonic, moisture, rfidState, servo, rtcState, oled);
  Serial.println(response);
}

void handleRequest(const char* line) {
  if (strstr(line, "sanctum-iq/1") && strstr(line, "diagnostics")) {
    sendDiagnostics();
  }
}

void setup() {
  Serial.begin(SERIAL_BAUD);
  Wire.begin();
  SPI.begin();
  pinMode(ULTRASONIC_TRIG_PIN, OUTPUT);
  digitalWrite(ULTRASONIC_TRIG_PIN, LOW);
  pinMode(MOISTURE_ANALOG_PIN, INPUT);
  rfid.PCD_Init();
}

void loop() {
  while (Serial.available() > 0) {
    const char incoming = static_cast<char>(Serial.read());
    if (incoming == '\r') continue;
    if (incoming == '\n') {
      requestLine[requestLength] = '\0';
      handleRequest(requestLine);
      requestLength = 0;
    } else if (requestLength < sizeof(requestLine) - 1) {
      requestLine[requestLength++] = incoming;
    } else {
      // Drop an oversized/malformed line and wait for the next line ending.
      requestLength = 0;
    }
  }
}
