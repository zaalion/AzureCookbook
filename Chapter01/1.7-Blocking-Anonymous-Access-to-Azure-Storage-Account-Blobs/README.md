# Blocking Anonymous Access to Azure Storage Account Blobs

### Create a new Azure Storage Account
```
storageName="<storage-account-name>"
location="<region>"

az storage account create \
  --name $storageName \
  --resource-group $rgName \
  --location $region \
  --sku Standard_LRS \
  --allow-blob-public-access false
```

### Disallowing public blob access:
```
az storage account update \
  --name $storageName \
  --resource-group $rgName \
  --allow-blob-public-access false
```

### Clean up:
```
az group delete --name $rgName
```