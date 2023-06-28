# Granting Limited Access to Azure Storage Accounts Using SAS Tokens


### Provisioning a new Azure Storage Account
```
storageName="<storage-account-name>"

az storage account create \
    --name $storageName \
    --resource-group $rgName \
    --location $region \
    --sku Standard_LRS
```

### Setting the expiry date variable
```
expiryDate=`date -u -d "15 minutes" '+%Y-%m-%dT%H:%MZ'`
```

### Obtaining the Storage Account key
```
storageKey=$(az storage account keys list \
    --resource-group $rgName \
    --account-name $storageName \
    --query [0].value \
    --output tsv)
```

### Generating a new SAS token for the Storage Account
```
sasToken=$(az storage account generate-sas \
    --account-name $storageName \
    --account-key $storageKey \
    --expiry $expiryDate \
    --permissions r \
    --resource-types co \
    --services bq \
    --https-only \
    --output tsv)

echo $sasToken
```

### Clean up
```
az group delete --name $rgName
```