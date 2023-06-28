# Using AZCopy to Upload Multiple Files to Azure Storage File Shares


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

az storage share create \
    --name "myfileshare" \
    --account-name $storageName \
    --account-key $storageKey1
```

### Setting the localPath variable
```
localPath="<local-folder-path>"
```

### Creating a SAS token with File Share access (--services f)
```
expiryDate=`date -u -d "60 minutes" '+%Y-%m-%dT%H:%MZ'`

sasToken=$(az storage account generate-sas \
    --account-name $storageName \
    --account-key $storageKey1 \
    --expiry $expiryDate \
    --permissions rw \
    --resource-types co \
    --services f \
    --https-only \
    --output tsv)
```

### Copying local files to Azure Storage File Share using AZCOPY
```
fileshareURL=$(az storage account show \
    --resource-group $rgName \
    --name $storageName \
    --query primaryEndpoints.file
    --output tsv)"myfileshare/?"$sasToken

azcopy copy $localPath $fileshareURL \
    --recursive=true
```

### Confirming that files exist on the File Share
```
az storage file list \
    --account-name $storageName \
    --account-key $storageKey1 \
    --share-name "myfileshare" \
    --query [].name
```

### Clean up
```
az group delete --name $rgName
```