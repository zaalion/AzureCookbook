# Using AZCopy to Upload Multiple Files to Azure Storage Blobs


### Creating a new Storage Account and child container
```
storageName="<storage-account-name>"

az storage account create \
    --name $storageName \
    --resource-group $rgName \
    --location $region \
    --sku Standard_LRS \
    --default-action Allow

storageKey1=$(az storage account keys list \
    --resource-group $rgName \
    --account-name $storageName \
    --query [0].value \
    --output tsv)

az storage container create \
    --name "mycontainer" \
    --account-name $storageName \
    --account-key $storageKey1
```

### Setting the localPath variable
```
localPath="<local-folder-path>"
```

### Creating a new SAS token
```
expiryDate=`date -u -d "60 minutes" '+%Y-%m-%dT%H:%MZ'`

sasToken=$(az storage account generate-sas \
    --account-name $storageName \
    --account-key $storageKey1 \
    --expiry $expiryDate \
    --permissions rw \
    --resource-types co \
    --services b \
    --https-only \
    --output tsv)
```

### Uploading local files to Azure Storage using AZCOPY
```
containerURL=$(az storage account show \
    --resource-group $rgName \
    --name $storageName \
    --query primaryEndpoints.blob \
    --output tsv)"mycontainer/?"$sasToken

azcopy copy $localPath"/*" $containerURL
```

### Confirm that the blobs are uploaded
```
az storage blob list \
    --account-name $storageName \
    --account-key $storageKey1 \
    --container-name "mycontainer" \
    --query [].name
```

### Clean up
```
az group delete --name $rgName
```