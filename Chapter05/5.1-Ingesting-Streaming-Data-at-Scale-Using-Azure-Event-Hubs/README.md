# Ingesting Streaming Data at Scale Using Azure Event Hubs 


### Provisioning a new Azure Event Hubs namespace
```
rgName="<resource-group-name>"
eventHubNamespaceName="<ehub-namespace-name>"

az eventhubs namespace create \
  --resource-group $rgName \
  --name $eventHubNamespaceName \
  --sku Standard \
  --enable-auto-inflate \
  --maximum-throughput-units 5
```

### Creating a new hub in the Event Hubs
```
az eventhubs eventhub create \
  --resource-group $rgName \
  --namespace-name $eventHubNamespaceName \
  --name hub01 \
  --message-retention 1 \
  --partition-count 2
```

### Obtaining the Event Hubs key
```
nsKey1=$(az eventhubs namespace \
  authorization-rule keys list \
  --resource-group $rgName \
  --namespace-name $eventHubNamespaceName \
  --name RootManageSharedAccessKey \
  --query primaryKey)
```

### Posting a new event to Azure Event Hubs using cURL
```
endpoint=\
  "https://$eventHubNamespaceName.servicebus.windows.net/hub01/messages"

event=\
  '{"Name": "John Smith","Email": "john@contoso.com", "Type": "Create"}'

curl -X POST \
  -H "Authorization: \
  SharedAccessSignature \
  sr=$eventHubNamespaceName.servicebus.windows.net\
  &sig=$nsKey1&se=1735693200\
  &skn=RootManageSharedAccessKey" \
  -d "$event" \
  $endpoint \
  --verbose
```