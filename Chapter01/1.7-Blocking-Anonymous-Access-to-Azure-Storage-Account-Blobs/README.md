# Blocking Anonymous Access to Azure Storage Account Blobs

storageName="<storage-account-name>"

az storage account create \
  --name $storageName \
  --resource-group <resource-group-name> \
  --location eastus \
  --sku Standard_LRS \
  --allow-blob-public-access false

az storage account update \
  --name $storageName \
  --resource-group <resource-group-name> \
  --allow-blob-public-access false

