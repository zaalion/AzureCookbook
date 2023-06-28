# Configuring Azure Cosmos DB Firewall


### Provisioning a new Azure Cosmos DB Account
```
cosmosAccountName="<cosmos-account-name>"

az cosmosdb create \
  --name $cosmosAccountName \
  --resource-group $rgName
```

### Configuring Cosmos DB firewall to only allow specific IPs
```
allowedIPRange="<allowed-ip-range>"

az cosmosdb update \
  --resource-group $rgName \
  --name $cosmosAccountName \
  --ip-range-filter $allowedIPRange
```

### Creating a new Azure VNet
```
vnetName="<vnet-name>"

az network vnet create \
  --resource-group $rgName \
  --name $vnetName \
  --address-prefix 10.0.0.0/16 \
  --subnet-name Subnet01 \
  --subnet-prefix 10.0.0.0/26
```

### Enabling the Cosmos DB service endpoint to the subnet
```
az network vnet subnet update \
  --resource-group $rgName \
  --name Subnet01 \
  --vnet-name $vnetName \
  --service-endpoints Microsoft.AzureCosmosDB
```

### Enabling VNet rules for Cosmos DB
```
az cosmosdb update \
  --resource-group $rgName \
  --name $cosmosAccountName \
  --enable-virtual-network true 
```

### Configuring Cosmos DB firewall to allow traffic from your subnet
```
az cosmosdb network-rule add \
  --resource-group $rgName \
  --virtual-network $vnetName \
  --subnet Subnet01 \
  --name $cosmosAccountName
```

### List Cosmos DB firewall rules
```
az cosmosdb network-rule list \
  --name $cosmosAccountName \
  --resource-group $rgName
```

### Clean up
```
az group delete --name $rgName
```