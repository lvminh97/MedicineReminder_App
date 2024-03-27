#if defined(ESP8266)
#include <ESP8266WiFi.h>
#elif defined(ESP32)
#include <WiFi.h>
#endif
#include <Firebase_ESP_Client.h>

#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

#define WIFI_SSID "MINHBKA3"
#define WIFI_PASSWORD "khongcopass"

#define API_KEY "AIzaSyBaZ3Uzjnm7cowFa786c4aXegpZy5cl0N0"
#define DATABASE_URL "medicineremind-2ded0-default-rtdb.asia-southeast1.firebasedatabase.app"
#define EMAIL "medicine@mail.com"
#define FB_PASSWORD "12345678" 

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
int count = 0;

struct ScheduleItem {
  uint8_t hour;
  uint8_t minute;
  uint8_t type;
};
ScheduleItem scheduleList[20];
int scheduleSize = 0;

void setup(){
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  auth.user.email = EMAIL;
  auth.user.password = FB_PASSWORD;
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop(){
  if (millis() - sendDataPrevMillis > 1500){
    Firebase.RTDB.getString(&fbdo, F("medicine/command/cmd"));
    String cmd = fbdo.to<String>();
    if(cmd == "set_rtc") {
      setRTC();
    }
    else if(cmd == "add" || cmd == "edit" || cmd == "delete") {
      getScheduleList();
      Firebase.RTDB.setString(&fbdo, F("medicine/command/cmd"), F(" "));
    }
    sendDataPrevMillis = millis();
  }
}

void getScheduleList() {
  Firebase.RTDB.getInt(&fbdo, F("medicine/schedule/size"));
  scheduleSize = fbdo.to<int>();
  for(int i = 0; i < scheduleSize; i++) {
    Firebase.RTDB.getString(&fbdo, F("medicine/schedule/data/") + String(i) + F("/time"));
    String timestr = fbdo.to<String>();
    scheduleList[i].hour = 10 * (timestr[0] - '0') + (timestr[1] - '0');
    scheduleList[i].minute = 10 * (timestr[3] - '0') + (timestr[4] - '0');
    Firebase.RTDB.getInt(&fbdo, F("medicine/schedule/data/") + String(i) + F("/type_a"));
    scheduleList[i].type = fbdo.to<int>();
    Firebase.RTDB.getInt(&fbdo, F("medicine/schedule/data/") + String(i) + F("/type_b"));
    scheduleList[i].type |= (fbdo.to<int>() << 4);
  }

  for(int i = 0; i < scheduleSize; i++) {
    Serial.print(scheduleList[i].hour);
    Serial.print(":");
    Serial.print(scheduleList[i].minute);
    Serial.print(" ");
    Serial.print(scheduleList[i].type, HEX);
    Serial.println();
  }
}

void setRTC() {
  Firebase.RTDB.getString(&fbdo, F("medicine/command/value"));
  String timestr = fbdo.to<String>();
  uint8_t hour = 10 * (timestr[0] - '0') + (timestr[1] - '0');
  uint8_t minute = 10 * (timestr[3] - '0') + (timestr[4] - '0');
  uint8_t second = 10 * (timestr[6] - '0') + (timestr[7] - '0');
  uint8_t day = 10 * (timestr[9] - '0') + (timestr[10] - '0');
  uint8_t month = 10 * (timestr[12] - '0') + (timestr[13] - '0');
  uint8_t year = 10 * (timestr[17] - '0') + (timestr[18] - '0');
  Firebase.RTDB.setString(&fbdo, F("medicine/command/cmd"), F(" "));
  Serial.print("RTC: ");
  Serial.print(hour);
  Serial.print(":");
  Serial.print(minute);
  Serial.print(":");
  Serial.print(second);
  Serial.print(" ");
  Serial.print(day);
  Serial.print("/");
  Serial.print(month);
  Serial.print("/");
  Serial.print(year);
  Serial.println();
}