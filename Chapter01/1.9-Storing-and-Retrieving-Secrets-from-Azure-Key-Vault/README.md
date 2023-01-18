# Storing and Retrieving Secrets from Azure Key Vault

rgName="<resource-group-name"
kvName="<key-vault-name>"

az keyvault create --name $kvName \
  --resource-group $rgName \
  --location eastus 

az keyvault secret set \
  --name MyDatabasePassword \
  --vault-name $kvName \
  --value P@$$w0rd

az keyvault secret show \
  --name MyDatabasePassword \
  --vault-name $kvName 


