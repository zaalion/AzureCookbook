# Queuing Newly Uploaded Blobs for Further Processing Using Azure Event Grid


### Provisioning a new Azure Storage Account
```
storageName="<storage-account-name>"

az storage account create \
  --name $storageName \
  --resource-group $rgName \
  --sku Standard_LRS \
  --location $region \
  --kind StorageV2
```

### Obtaining the Storage Account Key
```
storageKey=$(az storage account keys list \
  --resource-group $rgName \
  --account-name $storageName \
  --query [0].value --output tsv)
```

### Creating a new container
```
containerName="uploadcontainer"

az storage container create \
  --name $containerName \
  --account-name $storageName \
  --account-key $storageKey
```

### Creating a new storage queue
```
queueName="blobsqueue"

az storage queue create \
  --name $queueName \
  --account-name $storageName \
  --account-key $storageKey
```

### Obtaining the Storage Account resource Id
```
storageResId=$(az storage account show \
  --name $storageName \
  --resource-group $rgName \
  --query id --output tsv)

storageQueueId=\
  "$storageResId/queueservices/default/queues/"$queueName
```

### Creating an Event Grid system topic
```
topicName="<system-topic-name>"

MSYS_NO_PATHCONV=1 az eventgrid system-topic create \
  --resource-group $rgName \
  --name $topicName \
  --topic-type microsoft.storage.storageaccounts \
  --source $storageResId \
  --location $region
```

### Creating a subscription for the Event Grid topic
```
subscriptionName="<eg-subscription-name>"

MSYS_NO_PATHCONV=1 az eventgrid system-topic \
  event-subscription create \
  --name $subscriptionName \
  --resource-group $rgName \
  --system-topic-name $topicName \
  --endpoint-type storagequeue \
  --endpoint $storageQueueId
```

### Uploading a new blob to Azure blob Storage Account
```
blobName="<blob-file-name>"
localPath="<local-path>"

az storage blob upload \
  --account-key $storageKey \
  --name $blobName \
  --file $localPath \
  --account-name $storageName \
  --container-name $containerName
```

### Confirming that the new message has arrived at the Storage Account queue:
```
az storage message get \
  --queue-name $queueName \
  --account-name $storageName \
  --account-key $storageKey
```

### Clean up
```
az group delete --name $rgName
```