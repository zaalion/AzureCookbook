# Hosting Static Websites in Azure Storage


### Creating a new Storage Account and grabbing its key
```
storageName="<storage-account-name>"

az storage account create \
    --name $storageName \
    --resource-group $rgName \
    --sku Standard_LRS \
    --default-action Allow

storageKey01=$(az storage account keys list \
    --resource-group $rgName \
    --account-name $storageName \
    --query [0].value \
    --output tsv)
```

### Enabling the static-website feature on Azure Storage Account
```
az storage blob service-properties update \
  --account-name $storageName \
  --account-key $storageKey01 \
  --static-website \
  --404-document notfound.html \
  --index-document index.html
```

### Uploading all files within a folder to Azure Storage Account
```
az storage blob upload-batch \
  --account-name $storageName \
  --destination '$web' \
  --source <path-to-local-folder>
```

### Grabbing the website URL
```
webURL=$(az storage account show \
  --name $storageName \
  --resource-group $rgName \
  --query "primaryEndpoints.web" \
  --output tsv)

echo $webURL
```

### Clean up
```
az group delete --name $rgName
```