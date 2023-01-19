# Invoking an Azure Function on Blob Upload Using the Blob Trigger


### Creating a new Azure Storage Account container and grabbing the connection string
```
storageAccountName="<storage-account-name>"

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
    --name "newblobs" \
    --account-name $storageAccountName \
    --account-key $storageKey

storageConnectionString=$(az storage account \
  show-connection-string \
  --resource-group $rgName \
  --name $storageAccountName \
  --output tsv)
```

### Configuring the Function App Settings
```
az functionapp config appsettings set \
  --name $functionAppName \
  --resource-group $rgName \
  --settings "StorageToMonitor=$storageConnectionString"
```

### Blob-triggered function body
```
public static void Run(Stream myBlob, string name, ILogger log)
{
    log.LogInformation
       ($"C# Blob trigger function Processed blob\n Name:{name} \n Size: 
       {myBlob.Length} Bytes");
}
```

### Uploading a blob
```
az storage blob upload \
    --account-key $storageKey \
    --file <local-file-path> \
    --account-name $storageAccountName \
    --container-name "newblobs" \
    --name <blob-name>
```