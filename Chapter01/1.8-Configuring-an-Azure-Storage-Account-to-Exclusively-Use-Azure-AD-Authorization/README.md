# Configuring an Azure Storage Account to Exclusively Use Azure AD Authorization

### Create a new Azure Storage Account:
```
storageName="<storage-account-name>"
location=<region>

az storage account create \
  --name $storageName \
  --resource-group <resource-group-name> \   
  --location $location \
  --sku Standard_LRS \
  --allow-shared-key-access false
```

### Disabling key-based access for Storage Account:
```
az storage account update \
  --name $storageName \
  --resource-group <resource-group-name> \ 
  --allow-shared-key-access false  
```