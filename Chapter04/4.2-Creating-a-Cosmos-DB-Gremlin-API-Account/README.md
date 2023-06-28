# Creating a Cosmos DB Gremlin (Graph) API Account


### Provisioning a new Azure Cosmos DB Account with Gremlin capability
```
cosmosAccountName="<cosmos-account-name>"

az cosmosdb create \
  --name $cosmosAccountName \
  --resource-group $rgName \
  --capabilities EnableGremlin
```

### Creating a new database
```
az cosmosdb gremlin database create \
  --account-name $cosmosAccountName \
  --resource-group $rgName \
  --name MyGraphDB
```

### Creating a new graph in the database
```
MSYS_NO_PATHCONV=1 az cosmosdb gremlin graph create \
  --resource-group $rgName \
  --account-name $cosmosAccountName \
  --database-name MyGraphDB \
  --name People \
  --partition-key-path "/age"
```

### Clean up
```
az group delete --name $rgName
```