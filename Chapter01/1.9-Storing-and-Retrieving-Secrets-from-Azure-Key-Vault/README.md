# Storing and Retrieving Secrets from Azure Key Vault

### Create a new Azure Key Vault
```
rgName="<resource-group-name"
kvName="<key-vault-name>"

az keyvault create --name $kvName \
  --resource-group $rgName \
  --location $region
```

### Adding a new secret
```
az keyvault secret set \
  --name MyDatabasePassword \
  --vault-name $kvName \
  --value P@$$w0rd
```

### Getting the secret
```
az keyvault secret show \
  --name MyDatabasePassword \
  --vault-name $kvName
```

### Clean up
```
az group delete --name $rgName
```