# Granting Function Apps Access to Cosmos DB Using RBAC 


### Provisioning a new Azure Cosmos DB Account
```
cosmosAccountName="<cosmos-account-name>"

az cosmosdb create \
  --name $cosmosAccountName \
  --resource-group $rgName
```

### Provisioning an Azure Function App
```
funcStorageAccount="<_func-storage-account-name_>"
planName="<appservice-plan-name>"
funcAppName="<function-app-name>"

az storage account create \
  --name $funcStorageAccount \
  --resource-group $rgName \
  --location $region \
  --sku Standard_LRS

az appservice plan create \
  --resource-group $rgName \
  --name $planName \
  --sku S1 \
  --location $region

az functionapp create \
  --resource-group $rgName \
  --name $funcAppName \
  --storage-account $funcStorageAccount \
  --assign-identity [system] \
  --functions-version 3 \
  --plan $planName 
```

### Storing the Cosmos DB account Id and Function App identity object Id
```
cosmosAccountId=$(az cosmosdb show \
  --name $cosmosAccountName \
  --resource-group $rgName \
  --query id \
  --output tsv)

funcObjectId=$(az functionapp show \
  --name $funcAppName \
  --resource-group $rgName \
  --query identity.principalId \
  --output tsv)
```

### The custom RBAC rule definition
```
{
    "RoleName": "MyCosmosDBReadWriteRole",
    "Type": "CustomRole",
    "AssignableScopes": ["/"],
    "Permissions": 
    [
      {
        "DataActions": [
            "Microsoft.DocumentDB/databaseAccounts/readMetadata",
            "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*",
            "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*"            
        ]
      }
    ]
}
```

### Creating the new custom role definition
```
az cosmosdb sql role definition create \
  --account-name $cosmosAccountName \
  --resource-group $rgName \
  --body <path-to-MyCosmosDBReadWriteRole.json>
```

### Assigning the new role definition to your Function App
```
MSYS_NO_PATHCONV=1 az cosmosdb sql role assignment create \
  --account-name $cosmosAccountName \
  --resource-group $rgName \
  --role-definition-name MyCosmosDBReadWriteRole \
  --principal-id $funcObjectId \
  --scope "/dbs"
```

### Confirming that the role definition is created
```
# Assuming there is only one role assignment in this Cosmos DB account
roleDefinitionId=$(az cosmosdb sql role assignment list \
  --account-name $cosmosAccountName \
  --resource-group $rgName \
  --query [0].roleDefinitionId --output tsv)

# The last 36 characters will be the role definition ID (GUID)
roleDefinitionGUID=${roleDefinitionId: -36}

az cosmosdb sql role definition show \
  --account-name $cosmosAccountName \
  --resource-group $rgName \
  --id $roleDefinitionGUID
```

### Clean up
```
az group delete --name $rgName
```