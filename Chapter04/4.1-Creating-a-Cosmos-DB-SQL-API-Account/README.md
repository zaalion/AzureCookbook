# Creating a Cosmos DB SQL API Account


### Provisioning a new Azure Cosmos DB Account
```
cosmosAccountName="<cosmos-account-name>"

az cosmosdb create \
  --name $cosmosAccountName \
  --resource-group $rgName \
  --backup-policy-type Periodic \
  --backup-interval 240 \
  --backup-retention 12
```

### Creating a new database in the account
```
az cosmosdb sql database create \
  --account-name $cosmosAccountName \
  --name MyCompanyDB \
  --throughput 1000 \
  --resource-group $rgName
```

### Creating a new container in the database
```
MSYS_NO_PATHCONV=1 az cosmosdb sql container create \
  --name People \
  --partition-key-path "/id" \
  --throughput 400 \
  --database-name MyCompanyDB \
  --account-name $cosmosAccountName \
  --resource-group $rgName
```

### Clean up
```
az group delete --name $rgName
```