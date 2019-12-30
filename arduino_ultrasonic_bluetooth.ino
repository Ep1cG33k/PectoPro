// Ultrasonic 

#include <NewPing.h>

#define TRIGGER_PIN 16
#define ECHO_PIN 5
#define MAX_DISTANCE 200

NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);

// BLE

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"


class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      BLEDevice::startAdvertising();
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};

long duration;
int distance;

long prev_distance = 40;

//Bluetooth Init
void initBT(){
  // Create the BLE Device
  BLEDevice::init("ESP32 Ultrasonic Range");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );

  // https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml
  // Create a BLE Descriptor
  pCharacteristic->addDescriptor(new BLE2902());

  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);  // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}

void setup() {
  // put your setup code here, to run once:

  Serial.begin(9600);
  /*
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  */
  initBT();
}

void loop() {
  /*
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH);

  //determine why this constant/what the ultrasonic is actually measuring
  distance = microsecondsTocentimeters(duration);

  Serial.print("Ultrasonic Distance : " );
  Serial.print(distance);
  Serial.println(" CM");
  */
  delay(50);

  unsigned int uS = sonar.ping();

  pinMode(ECHO_PIN, OUTPUT);
  digitalWrite(ECHO_PIN, LOW);
  pinMode(ECHO_PIN, INPUT);

  if(uS == 0){
    distance = prev_distance;
  } else {
    distance = microsecondsTocentimeters(uS);
  }
  
  Serial.print("Ultrasonic Distance : " );
  Serial.print(distance);
  Serial.println(" CM");
  
  updateDistance(distance);
  
  if (!deviceConnected && oldDeviceConnected) {
      delay(500); // give the bluetooth stack the chance to get things ready
      pServer->startAdvertising(); // restart advertising
      Serial.println("start advertising");
      oldDeviceConnected = deviceConnected;
  }
  // connecting
  if (deviceConnected && !oldDeviceConnected) {
      // do stuff here on connecting
      oldDeviceConnected = deviceConnected;
  }
}

void updateDistance(long distance){
  if(prev_distance != distance){
    prev_distance = distance;

    if (deviceConnected) {

      String str = "";
      str += (int)distance;
      
      pCharacteristic->setValue((char*)str.c_str());
      pCharacteristic->notify();
    }
  }
}

long microsecondsTocentimeters(long duration){
  return duration /29 / 2;
}
