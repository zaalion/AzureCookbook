# Configuring Auto-scale for an Azure Cosmos DB SQL API Container


### Provisioning a new Azure Cosmos DB Account
```
cosmosAccountName="<cosmos-account-name>"

az cosmosdb create \
  --name $cosmosAccountName \
  --resource-group $rgName
```

### Creating a new database
```
az cosmosdb sql database create \
  --account-name $cosmosAccountName \
  --resource-group $rgName \
  --name db01
```

### Creating a new container in the database
```
MSYS_NO_PATHCONV=1 az cosmosdb sql container create \
  --resource-group $rgName \
  --account-name $cosmosAccountName \
  --database-name db01 \
  --name People \
  --partition-key-path "/id" \
  --throughput "1000"
```

### Getting the container throughput details
```
az cosmosdb sql container throughput show \
  --resource-group $rgName \
  --account-name $cosmosAccountName \
  --database-name db01 \
  --name People
```

### Migrating the container from provisioned to auto-scale throughput
```
az cosmosdb sql container throughput migrate \
  --resource-group $rgName \
  --account-name $cosmosAccountName \
  --database-name db01 \
  --name People \
  --throughput "autoscale"
```

### Confirming the new throughput settings
```
az cosmosdb sql container throughput show \
  --resource-group $rgName \
  --account-name $cosmosAccountName \
  --database-name db01 \
  --name People
```

### Updating container throughput
```
az cosmosdb sql container throughput update \
  --resource-group $rgName \
  --account-name $cosmosAccountName \
  --database-name db01 \
  --name People \
  --max-throughput 2000
```

### Clean up
```
az group delete --name $rgName
```