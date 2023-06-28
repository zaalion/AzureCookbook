# Creating and Storing Snapshots of Your Blob Objects


### Provisioning a new Azure Storage Account
```
storageName="<storage-account-name>"

az storage account create \
    --name $storageName \
    --resource-group $rgName \
    --location $region \
    --sku Standard_LRS \
    --default-action Allow
```

### Storing Storage Account key
```
storageKey1=$(az storage account keys list \
    --resource-group $rgName \
    --account-name $storageName \
    --query [0].value \
    --output tsv)
```

### Creating a new child container
```
containerName="mycontainer"

az storage container create \
    --name $containerName \
    --account-name $storageName \
    --account-key $storageKey1
```

### Uploading a new blob text file to the container
```
blobFileName="Myblob01.txt"

az storage blob upload \
    --account-key $storageKey1 \
    --file <local-file-path> \
    --account-name $storageName \
    --container-name $containerName \
    --name $blobFileName
```

### Creating a new blob snapshot
```
az storage blob snapshot \
    --account-key $storageKey1 \
    --account-name $storageName \
    --container-name $containerName \
    --name $blobFileName
```

### Clean up
```
az group delete --name $rgName
```