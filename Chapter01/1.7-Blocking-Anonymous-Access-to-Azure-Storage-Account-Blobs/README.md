# Blocking Anonymous Access to Azure Storage Account Blobs

### Create a new Azure Storage Account
```
storageName="<storage-account-name>"
location="<region>"

az storage account create \
  --name $storageName \
  --resource-group <resource-group-name> \
  --location $location \
  --sku Standard_LRS \
  --allow-blob-public-access false
```

### Disallowing public blob access:
```
az storage account update \
  --name $storageName \
  --resource-group <resource-group-name> \
  --allow-blob-public-access false
```