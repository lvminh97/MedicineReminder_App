#if defined(ESP8266)
#include <ESP8266WiFi.h>
#elif defined(ESP32)
#include <WiFi.h>
#endif
#include <Firebase_ESP_Client.h>

#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

#define DEBUG false

#define WIFI_SSID "Minh BKA - 2.4G"
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
char inBuff[50], outBuff[50];
int inBuffCnt = 0;

struct ScheduleItem {
  uint8_t hour;
  uint8_t minute;
  uint8_t type;
};
ScheduleItem scheduleList[20];
int scheduleSize = 0;

void setup(){
  Serial.begin(115200);
  delay(500);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  int connectTmout = 0;
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
    connectTmout++;
    if(connectTmout == 10) {
      connectTmout = 0;
      WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    }
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
  // check there is any command from STM32
  checkReceiveCommand();
  // check there is any update from Firebase
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
    outBuff[3 * i + 2] = scheduleList[i].hour;
    outBuff[3 * i + 3] = scheduleList[i].minute;
    outBuff[3 * i + 4] = scheduleList[i].type;
#if DEBUG  
    Serial.print(scheduleList[i].hour);
    Serial.print(":");
    Serial.print(scheduleList[i].minute);
    Serial.print(" ");
    Serial.print(scheduleList[i].type, HEX);
    Serial.println();
#endif
  }
  outBuff[0] = 0x82;
  outBuff[1] = scheduleSize;
  sendCommand(outBuff, 3 * scheduleSize + 1);
}

void setRTC() {
  Firebase.RTDB.getString(&fbdo, F("medicine/command/value"));
  String timestr = fbdo.to<String>();
  outBuff[1] = 10 * (timestr[0] - '0') + (timestr[1] - '0');
  outBuff[2] = 10 * (timestr[3] - '0') + (timestr[4] - '0');
  outBuff[3] = 10 * (timestr[6] - '0') + (timestr[7] - '0');
  outBuff[4] = 10 * (timestr[9] - '0') + (timestr[10] - '0');
  outBuff[5] = 10 * (timestr[12] - '0') + (timestr[13] - '0');
  outBuff[6] = 10 * (timestr[17] - '0') + (timestr[18] - '0');
  Firebase.RTDB.setString(&fbdo, F("medicine/command/cmd"), F(" "));

  outBuff[0] = 0x81;
  sendCommand(outBuff, 7);

#if DEBUG
  Serial.print("RTC: "); Serial.print(outBuff[1]);
  Serial.print(":"); Serial.print(outBuff[2]);
  Serial.print(":"); Serial.print(outBuff[3]);
  Serial.print(" ");
  Serial.print(outBuff[4]);
  Serial.print("/"); Serial.print(outBuff[5]);
  Serial.print("/"); Serial.print(outBuff[6]);
  Serial.println();
#endif
}

void sendCommand(char cmd[], int len){
  // start condition
  Serial.print((char) 0x84);
  Serial.print((char) 0xF0);
  // command
  for(int i = 0; i < len; i++){
    Serial.print(cmd[i]);
  }
  // end condition
  Serial.print((char) 0x84);
  Serial.print((char) 0xF1);
}

void checkReceiveCommand(){
  unsigned char c;
  if(Serial.available()){
    while(Serial.available()){
      c = (unsigned char) Serial.read();
      if(c == 0xF0 && inBuffCnt > 1 && inBuff[inBuffCnt - 1] == 0x85){
        inBuff[0] = 0x85;
        inBuff[1] = 0xF0;
        inBuffCnt = 2;
      }
      else if(c == 0xF1 && inBuffCnt > 3 && inBuff[inBuffCnt - 1] == 0x85){
        processCommand();
        inBuffCnt = 0;
      }
      else{
        inBuff[inBuffCnt++] = c;
      }
    }
  }
}

void processCommand(){
#if DEBUG
    for(int i = 0; i < inBuffCnt; i++){
      Serial.print(inBuff[i], HEX);
      Serial.print(" ");
    }
    Serial.println();
#endif
  if(inBuff[0] == 0x85 && inBuff[1] == 0xF0){
    switch(inBuff[2]){
      case 0x81:
        if(inBuff[3] == 0x81){  // start Wifi config mode
          //
        }
        else if(inBuff[3] == 0x83){   // Reset ESP
#if defined(ESP8266)
          ESP.reset();
#elif defined(ESP32)
          ESP.restart();
#endif
        }
        break;
    }
  }
}
