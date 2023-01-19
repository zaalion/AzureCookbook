# Inserting Function App Output Into Azure Cosmos DB


### Creating a new Azure Cosmos DB account, a database and a container
```
cosmosDBAccountName="<cosmos-account-name>"

az cosmosdb create \
  --name $cosmosDBAccountName \
  --resource-group $rgName

az cosmosdb sql database create \
  --account-name $cosmosDBAccountName \
  --name MyDB \
  --throughput 1000 \
  --resource-group $rgName

MSYS_NO_PATHCONV=1 az cosmosdb sql container create \
  --name UploadedBlobs \
  --partition-key-path "/name" \
  --throughput 400 \
  --database-name MyDB \
  --account-name $cosmosDBAccountName \
  --resource-group $rgName
```

### Configuring the Function App Settings with the Cosmos DB connection string
```
cosmosConnectionString=$(az cosmosdb keys list \
  --name $cosmosDBAccountName \
  --resource-group $rgName \
  --type connection-strings \
  --query connectionStrings[0].connectionString \
  --output tsv)

az functionapp config appsettings set \
  --name $functionAppName \
  --resource-group $rgName \
  --settings "CosmosConnection=$cosmosConnectionString"
```

### run.csx
```
public static void Run(Stream myBlob, string name
    , out object outputCosmos, ILogger log)
{
    log.LogInformation
    ($"C# Blob trigger function Processed blob\n Name:{name} \n 
        Size: {myBlob.Length} Bytes");

    outputCosmos = new
    {
        name,
        myBlob.Length
    };
}
```

### Uploading a blob file
```
az storage blob upload \
    --account-key $storageKey \
    --file <local-file-path> \
    --account-name $storageAccountName \
    --container-name "newblobs" \
    --name <blob-name>
```