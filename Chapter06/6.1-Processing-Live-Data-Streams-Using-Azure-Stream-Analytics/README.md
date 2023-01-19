# Processing Live Data Streams Using Azure Stream Analytics


### Provisioning a new Azure Event Hubs namespace and a hub
```
rgName="<resource-group-name>"
eventHubNamespaceName="<ehub-namespace-name>"

az eventhubs namespace create \
  --resource-group $rgName \
  --name $eventHubNamespaceName \
  --sku Standard \
  --enable-auto-inflate \
  --maximum-throughput-units 5

az eventhubs eventhub create \
  --resource-group $rgName \
  --namespace-name $eventHubNamespaceName \
  --name inputHub \
  --message-retention 1 \
  --partition-count 2

eventHubprimaryConnectionString=$(az eventhubs namespace \
  authorization-rule keys list \
  --resource-group $rgName \
  --namespace-name $eventHubNamespaceName \
  --name RootManageSharedAccessKey \
  --query primaryConnectionString)
```

### Creating a new Storage Account and a container for Stream Analytics output
```
storageAccountName="<storage-account-name>"
containerName="outputcontainer"

az storage account create \
   --name $storageAccountName \
   --resource-group $rgName \
   --sku Standard_LRS

storageKey=$(az storage account keys list \
    --resource-group $rgName \
    --account-name $storageAccountName \
    --query [0].value \
    --output tsv)

az storage container create \
    --name $containerName \
    --account-name $storageAccountName \
    --account-key $storageKey
```

### Creating a new Stream Analytics job
```
streamJobName="myTemperatureJob"

az stream-analytics job create \
    --resource-group $rgName \
    --name $streamJobName \
    --output-error-policy "Drop" \
    --out-of-order-policy "Drop" \
    --data-locale "en-US"
```

### Azure Stream Analytics input definition file (inputProperties.json)
```
{
  "type": "Stream",
  "datasource": {
    "type": "Microsoft.ServiceBus/EventHub",
    "properties": {
      "eventHubName": "<event-hub-name>",
      "serviceBusNamespace": "<event-hub-namespace>",
      "sharedAccessPolicyKey": "<event-hub-key>",
      "sharedAccessPolicyName": "RootManageSharedAccessKey"
    }
  },
  "serialization": { "type": "Json", "properties": { "encoding": "UTF8" } }
}
```

### Creating Stream Analytics Input
```
az stream-analytics input create \
  --input-name "temperatureInput" \
  --job-name $streamJobName \
  --resource-group "$rgName" \
  --properties /path/to/inputProperties.json
```

### Azure Stream Analytics output definition file (outputProperties.json)
```
{
    "type": "Microsoft.Storage/Blob",
    "properties": {
        "storageAccounts": [
            {
                "accountName": "<storage-account-name>",
                "accountKey": "<storage-account-key>"
            }
        ],
        "container": "outputcontainer",
        "pathPattern": "{date}/{time}",
        "dateFormat": "yyyy/MM/dd",
        "timeFormat": "HH"
    }
}
```

### Encoding definition file (encoding.json)
```
{
     "type": "Json",
     "properties": {
         "encoding": "UTF8"
     }
}
```

### Creating Stream Analytics output
```
az stream-analytics output create \
    --resource-group $rgName \
    --job-name $streamJobName \
    --name temperatureOutput \
    --datasource /path/to/outputProperties.json \
    --serialization /path/to/encoding.json
```

### Creating the transformation logic/query
```
az stream-analytics transformation create \
    --resource-group $rgName \
    --job-name $streamJobName \
    --name AnomalyDetection \
    --streaming-units "1" \
    --saql \
    "SELECT * INTO temperatureOutput FROM temperatureInput WHERE Temperature > 100"
```

### Starting the Stream Analytics Job
```
az stream-analytics job start \
    --resource-group $rgName \
    --job-name $streamJobName \
    --output-start-mode JobStartTime
```

### Conform that the Stream Analytics job created output blobs
```
az storage blob list \
    --account-name $storageAccountName \
    --account-key $storageKey \
    --container-name $containerName \
    --query [].name

```

### Stopping the job
```
az stream-analytics job stop \
  --job-name $streamJobName \
  --resource-group $rgName
```