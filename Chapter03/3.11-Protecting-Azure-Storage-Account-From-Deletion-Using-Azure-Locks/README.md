# Protecting Azure Storage Account From Deletion Using Azure Locks


### Creating a new Azure Storage Account
```
storageName="<storage-account-name>"

az storage account create \
    --name $storageName \
    --resource-group $rgName \
    --location $region \
    --sku Standard_LRS
```

### Creating a new lock for the Storage Account
```
az lock create \
    --name MyStorageDeleteLock \
    --lock-type CanNotDelete \
    --resource-group $rgName \
    --resource $storageName \
    --resource-type "Microsoft.Storage/storageAccounts"
```

### Removing the lock
```
az lock delete \
    --name MyStorageDeleteLock \
    --resource-group $rgName \
    --resource $storageName \
    --resource-type "Microsoft.Storage/storageAccounts"
```

### Clean up
```
az group delete --name $rgName
```