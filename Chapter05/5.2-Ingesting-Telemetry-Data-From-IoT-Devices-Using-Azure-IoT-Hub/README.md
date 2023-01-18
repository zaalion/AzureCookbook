# Ingesting Telemetry Data From IoT Devices Using Azure IoT Hub


### Provisioning a new Azure IoT Hub
```
rgName="<resource-group-name>"
iotHubName="<iot-hub-name>"

az iot hub create \
  --resource-group $rgName \
  --name $iotHubName \
  --sku S1
```

### Creating a new device identity
```
deviceId="<iot-device-id>"

az iot hub device-identity create \
  --hub-name $iotHubName \
  --device-id $deviceId 
```

### Simulating a connected device
```
az iot device simulate \
  --device $deviceId \
  --hub-name $iotHubName
```

### Sending a device to cloud message
```
az iot device send-d2c-message \
  --hub-name $iotHubName \
  --device-id $deviceId \
  --data 'temperature=112.8'
```