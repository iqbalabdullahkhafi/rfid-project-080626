#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>
#include <SPI.h>
#include <MFRC522.h>
#include <Wire.h>
#include <LiquidCrystal_PCF8574.h>

#define SS_PIN D8
#define RST_PIN D4
#define RELAY_PIN D3
#define I2C_SDA D2
#define I2C_SCL D1

#define DEVICE_PROFILE 1

const char* WIFI_SSID = "rfid";
const char* WIFI_PASS = "meja12345";
const char* SERVER_BASE = "http://10.200.243.38/rfid-project";

#if DEVICE_PROFILE == 1
const char* DEVICE_ID = "door_1";
const char* DEVICE_NAME = "RUANG NOC";
const char* API_KEY = "3995b8c904f162ec234131664e06d61b";
const char* LOCAL_UIDS[] = {"13E824D3", "BD9BD421", "AD6DD321"};
#else
const char* DEVICE_ID = "door_2";
const char* DEVICE_NAME = "RUANG MEETING";
const char* API_KEY = "64a89d158064ba7dba7488e375d6fbe9";
const char* LOCAL_UIDS[] = {"66E84306", "AD629121", "AD6DD321"};
#endif

WiFiClient client;
MFRC522 rfid(SS_PIN, RST_PIN);
LiquidCrystal_PCF8574 lcd(0x27);

String systemMode = "online";
uint32_t lastCommandPoll = 0;
uint32_t lastModePoll = 0;
uint32_t doorCloseAt = 0;
bool doorOpen = false;

String tempMsg1;
String tempMsg2;
uint32_t tempMsgUntil = 0;
uint32_t lastLcdRefresh = 0;

String apiUrl(const String& endpoint) {
  return String(SERVER_BASE) + "/api/" + endpoint;
}

String encode(const String& value) {
  String out;
  const char* hex = "0123456789ABCDEF";
  for (size_t i = 0; i < value.length(); i++) {
    char c = value[i];
    if (isalnum(c) || c == '_' || c == '-' || c == '.') out += c;
    else { out += '%'; out += hex[(c >> 4) & 0x0F]; out += hex[c & 0x0F]; }
  }
  return out;
}

String httpGet(const String& url, int* codeOut = nullptr) {
  HTTPClient http;
  http.setTimeout(2500);
  if (!http.begin(client, url)) return "";
  int code = http.GET();
  if (codeOut) *codeOut = code;
  String body = code > 0 ? http.getString() : "";
  http.end();
  return body;
}

void showPermanentStatus(const String& line1, const String& line2) {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print(line1.substring(0, 16));
  lcd.setCursor(0, 1);
  lcd.print(line2.substring(0, 16));
}

void showTemporaryMessage(const String& line1, const String& line2, uint32_t duration) {
  tempMsg1 = line1;
  tempMsg2 = line2;
  tempMsgUntil = millis() + duration;
  showPermanentStatus(tempMsg1, tempMsg2);
}

void connectWifi() {
  if (WiFi.status() == WL_CONNECTED) return;
  Serial.println("[WiFi] Connecting...");
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  showPermanentStatus("WiFi", "Connecting...");
  uint32_t start = millis();
  while (WiFi.status() != WL_CONNECTED && millis() - start < 12000) { delay(250); }
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("[WiFi] Connected");
    Serial.println("[WiFi] IP Address : " + WiFi.localIP().toString());
    showPermanentStatus("WiFi Online", DEVICE_NAME);
  } else {
    showPermanentStatus("WiFi Offline", DEVICE_NAME);
  }
}

String uidHex() {
  String uid;
  for (byte i = 0; i < rfid.uid.size; i++) {
    if (rfid.uid.uidByte[i] < 0x10) uid += "0";
    uid += String(rfid.uid.uidByte[i], HEX);
  }
  uid.toUpperCase();
  return uid;
}

bool localAllowed(const String& uid) {
  for (size_t i = 0; i < sizeof(LOCAL_UIDS) / sizeof(LOCAL_UIDS[0]); i++) {
    if (uid == LOCAL_UIDS[i]) return true;
  }
  return false;
}

void openDoor() {
  digitalWrite(RELAY_PIN, LOW);
  doorOpen = true;
  doorCloseAt = millis() + 5000;
  showTemporaryMessage("ACCESS GRANTED", "Door Unlocked", 2000);
  Serial.println("[Door] Unlock");
}

void closeDoorIfNeeded() {
  if (doorOpen && millis() >= doorCloseAt) {
    digitalWrite(RELAY_PIN, HIGH);
    doorOpen = false;
    Serial.println("[Door] Lock");
  }
}

void pollMode() {
  if (WiFi.status() != WL_CONNECTED) return;
  String url = apiUrl("settings.php") + "?device_id=" + encode(DEVICE_ID) + "&api_key=" + encode(API_KEY);
  int code = 0;
  String body = httpGet(url, &code);
  // Hanya perbarui mode jika server memberikan respons yang valid (HTTP 2xx).
  // Jika server tidak dapat dijangkau, pertahankan mode terakhir yang diketahui.
  if (code >= 200 && code < 300 && body.length() > 0) {
    String upper = body;
    upper.toUpperCase();
    systemMode = upper.indexOf("HYBRID") >= 0 ? "hybrid" : "online";
    if (systemMode == "hybrid") {
      Serial.println("[Mode] HYBRID");
    } else {
      Serial.println("[Mode] ONLINE");
    }
  } else if (code < 0) {
    Serial.println("[Mode] Server unreachable");
    String tempMode = systemMode;
    tempMode.toUpperCase();
    Serial.println("[Mode] Using previous mode : " + tempMode);
  }
}

void pollCommand() {
  if (WiFi.status() != WL_CONNECTED) return;
  String url = apiUrl("commands.php") + "?device_id=" + encode(DEVICE_ID) + "&api_key=" + encode(API_KEY);
  String body = httpGet(url);
  String upper = body;
  upper.toUpperCase();
  if (upper.indexOf("\"COMMAND\":\"OPEN\"") >= 0) {
    Serial.println("[Command] OPEN received");
    openDoor();
  }
}

bool validateOnline(const String& uid, String& outDecision) {
  if (WiFi.status() != WL_CONNECTED) return false; // Server cannot be reached
  Serial.println("[Access] Sending request...");
  String url = apiUrl("access.php") + "?device_id=" + encode(DEVICE_ID) + "&uid=" + encode(uid) + "&api_key=" + encode(API_KEY);
  int code = 0;
  String body = httpGet(url, &code);
  if (code < 200 || code >= 300) {
    return false; // Server did not respond with success
  }
  if (body.indexOf("\"DECISION\":\"GRANTED\"") >= 0) {
    outDecision = "GRANTED";
    Serial.println("[Access] Status : GRANTED");
    return true; // Server responded
  }
  if (body.indexOf("\"DECISION\":\"DENIED\"") >= 0) {
    outDecision = "DENIED";
    Serial.println("[Access] Status : DENIED");
    return true; // Server responded
  }
  return false; // Server response was unclear
}

void scanCard() {
  if (!rfid.PICC_IsNewCardPresent() || !rfid.PICC_ReadCardSerial()) return;
  String uid = uidHex();
  Serial.println("\n[RFID] Card detected");
  Serial.println("[RFID] UID : " + uid);
  bool granted = false;
  String decision = "";
  bool serverResponded = validateOnline(uid, decision);
  if (serverResponded) {
    granted = (decision == "GRANTED");
  } else if (systemMode == "hybrid") {
    granted = localAllowed(uid); // Fallback to local list only if server did not respond
  }

  if (granted) openDoor();
  else showTemporaryMessage("ACCESS DENIED", uid, 5000);

  rfid.PICC_HaltA();
  rfid.PCD_StopCrypto1();
}

void setup() {
  Serial.begin(115200);
  Serial.println("\n\n====================================");
  Serial.println("     SMART DOOR SECURITY SYSTEM");
  Serial.println("====================================");
  Serial.println("Device ID   : " + String(DEVICE_ID));
  Serial.println("Device Name : " + String(DEVICE_NAME));
  Serial.println("Initializing system...");

  pinMode(RELAY_PIN, OUTPUT);
  digitalWrite(RELAY_PIN, HIGH);
  Wire.begin(I2C_SDA, I2C_SCL);
  lcd.begin(16, 2);
  lcd.setBacklight(255);
  SPI.begin();
  rfid.PCD_Init();
  showPermanentStatus("Smart Door", "Starting...");
  connectWifi();
  pollMode();
}

void loop() {
  connectWifi();
  closeDoorIfNeeded();
  uint32_t now = millis();
  if (now - lastCommandPoll > 1000) { lastCommandPoll = now; pollCommand(); }
  if (now - lastModePoll > 5000) { lastModePoll = now; pollMode(); }

  if (now - lastLcdRefresh > 500) {
    lastLcdRefresh = now;
    if (tempMsgUntil == 0 || now >= tempMsgUntil) {
      showPermanentStatus(doorOpen ? "Door Unlocked" : "Door Locked", DEVICE_NAME);
      tempMsgUntil = 0;
    }
  }
  scanCard();
}
