# Configuring an Azure Storage Account to Exclusively Use Azure AD Authorization

storageName="<storage-account-name>"

az storage account create \
  --name $storageName \
  --resource-group <resource-group-name> \   
  --location eastus \
  --sku Standard_LRS \
  --allow-shared-key-access false


az storage account update \
  --name $storageName \
  --resource-group <resource-group-name> \ 
  --allow-shared-key-access false  


