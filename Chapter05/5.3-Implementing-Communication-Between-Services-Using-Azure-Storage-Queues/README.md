# Implementing Communication Between Services Using Azure Storage Queues


### Provisioning a new Azure Storage Account
```
rgName="<resource-group-name>"
storageName="<storage-account-name>"
queueName="ordersqueue"
location="<region>"

az storage account create \
   --name $storageName \
   --resource-group $rgName \
   --location $location \
   --sku Standard_LRS \
   --kind StorageV2
```

### Obtaining the Storage Account key
```
storageKey=$(az storage account keys list \
    --resource-group $rgName \
    --account-name $storageName \
    --query [0].value \
    --output tsv)
```

### Creating a queue in the Storage Account
```
az storage queue create \
  --name $queueName \
  --account-name $storageName \
  --account-key $storageKey
```

### Adding two messages to the queue
```
az storage message put \
  --queue-name $queueName \
  --content '{"order": "1 small pizza"}' \
  --account-name $storageName \
  --account-key $storageKey

az storage message put \
  --queue-name $queueName \
  --content '{"order": "2 large cheese pizzas"}' \
  --account-name $storageName \
  --account-key $storageKey
```

### Getting a message from the queue
```
az storage message get \
  --queue-name $queueName \
  --account-name $storageName \
  --account-key $storageKey
```