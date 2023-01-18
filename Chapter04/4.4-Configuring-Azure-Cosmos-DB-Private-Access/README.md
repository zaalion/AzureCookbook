# Configuring Azure Cosmos DB Private Access


### Provisioning a new Azure Cosmos DB Account
```
rgName="<resource-group-name>"
cosmosAccountName="<cosmos-account-name>"

az cosmosdb create \
  --name $cosmosAccountName \
  --resource-group $rgName
```

### Provisioning an Azure VNet
```
vnetName="<vnet-name>"

az network vnet create \
  --resource-group $rgName \
  --name $vnetName \
  --address-prefix 10.0.0.0/20 \
  --subnet-name PLSubnet \
  --subnet-prefix 10.0.0.0/26
```

### Grabbing the Cosmos DB account Id
```
cosmosAccountId=$(az cosmosdb show \
  --name $cosmosAccountName \
  --resource-group $rgName \
  --query id -o tsv)
```

### Creating a private endpoint for Cosmos DB
```
MSYS_NO_PATHCONV=1 az network private-endpoint create \
    --name MyCosmosPrivateEndpoint \
    --resource-group $rgName \
    --vnet-name $vnetName  \
    --subnet PLSubnet \
    --connection-name MyEndpointConnection \
    --private-connection-resource-id $cosmosAccountId \
    --group-id Sql
```

### Disabling public network access for Cosmos DB
```
az cosmosdb update \
  --resource-group $rgName \
  --name $cosmosAccountName \
  --enable-public-network false
```