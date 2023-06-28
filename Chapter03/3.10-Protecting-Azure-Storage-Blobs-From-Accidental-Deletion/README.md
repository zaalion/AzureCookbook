# Protecting Azure Storage Blobs From Accidental Deletion


### Enabling soft-delete on Azure Storage Account
```
az storage account blob-service-properties update \
    --account-name $storageName \
    --enable-delete-retention true \
    --delete-retention-days 14
```

### Deleting a blob
```
az storage blob delete \
    --account-name $storageName \
    --account-key $storageKey1 \
    --container-name $containerName \
    --name MyBlob $blobFileName
```

### Listing blobs in the container
```
az storage blob list \
    --account-name $storageName \
    --account-key $storageKey1 \
    --container-name $containerName \
    --query [].name
```

### un-delete a soft-deleted blob file
```
az storage blob undelete \
    --account-name $storageName \
    --account-key $storageKey1 \
    --container-name $containerName \
    --name MyBlob $blobFileName
```

### Confirming that the deleted blob is restored
```
az storage blob list \
    --account-name $storageName \
    --account-key $storageKey1 \
    --container-name $containerName \
    --query [].name
```

### Clean up
```
az group delete --name $rgName
```