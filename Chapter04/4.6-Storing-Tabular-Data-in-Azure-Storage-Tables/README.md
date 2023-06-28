# Storing Tabular Data in Azure Storage Tables


### Provisioning a new Azure Storage Account
```
storageName="<storage-account-name>"

az storage account create \
  --name $storageName \
  --resource-group $rgName \
  --location $region \
  --sku Standard_LRS
```

### Getting the Storage Account key
```
storageKey1=$(az storage account keys list \
  --resource-group $rgName \
  --account-name $storageName \
  --query [0].value \
  --output tsv)
```

### Creating a table in the Storage Account and inserting two data rows
```
# creating a table
az storage table create \
  --account-name $storageName \
  --account-key $storageKey1 \
  --name People

# inserting a new row
az storage entity insert \
  --account-name $storageName \
  --account-key $storageKey1 \
  --table-name People \
  --entity PartitionKey=Canada RowKey=reza@contoso.com Name=Reza

# inserting another new row
az storage entity insert \
  --account-name $storageName \
  --account-key $storageKey1 \
  --table-name People \
  --entity PartitionKey=U.S.A. RowKey=john@contoso.com Name=John Last=Smith
```

### Query the Storage Account table
```
az storage entity query \
  --table-name People \
  --account-name $storageName \
  --account-key $storageKey1
```

### Clean up
```
az group delete --name $rgName
```