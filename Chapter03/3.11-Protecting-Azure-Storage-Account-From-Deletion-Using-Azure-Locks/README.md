# Protecting Azure Storage Account From Deletion Using Azure Locks


### Creating a new Azure Storage Account
```
rgName="<resource-group-name>"
storageName="<storage-account-name>"
location="<region>"

az storage account create \
    --name $storageName \
    --resource-group $rgName \
    --location $location \
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