# Using Azure Key Vault Keys to Configure Azure Storage Account Encryption at Rest


### Provisioning a new Azure Key Vault
```
rgName="<resource-group-name>"
kvName="<kv-Name>"

az keyvault create --name $kvName \
    --resource-group $rgName \
    --location $region \
    --enable-purge-protection
```

### Creating a new encryption key
```
az keyvault key create \
    --name storage-cmk-key \
    --vault-name $kvName \
    --kty RSA \
    --size 4096  
```

### Creating a new Azure Storage Account
```
storageName="<storage-account-name>"

az storage account create \
    --name $storageName \
    --resource-group $rgName \
    --location $region \
    --sku Standard_LRS
```

### Enabling managed identity for Azure Storage Account and store the identity object Id
```
az storage account update \
    --name $storageName \
    --resource-group $rgName \
    --assign-identity

storageObjectId=$(az storage account show \
    --name $storageName \
    --query "identity.principalId" \
    --output tsv)
```

### Configuring KV access policy to allow Storage Account to access the encryption key
```
az keyvault set-policy --name $kvName \
    --object-id $storageObjectId \
    --key-permissions get unwrapKey wrapKey
```

### Updating Azure Storage Account to use CMK
```
kvURL=$(az keyvault show \
    --name $kvName \
    --resource-group $rgName \
    --query properties.vaultUri \
    --output tsv)

az storage account update \
    --name $storageName \
    --resource-group $rgName \
    --encryption-key-source Microsoft.Keyvault \
    --encryption-services blob \
    --encryption-key-vault $kvURL \
    --encryption-key-name storage-cmk-key
```

### Clean up
```
az group delete --name $rgName
```