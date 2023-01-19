# Processing Data Files Using Azure Databricks


### Creating a new Azure Storage Account and blob container
```
rgName="<resource-group-name>"
storageAccountName="<storage-account-name>"

az storage account create \
   --name $storageAccountName \
   --resource-group $rgName \
   --sku Standard_LRS \
   --enable-hierarchical-namespace true

storageKey=$(az storage account keys list \
    --resource-group $rgName \
    --account-name $storageAccountName \
    --query [0].value \
    --output tsv)

az storage container create \
    --name "bigdata" \
    --account-name $storageAccountName \
    --account-key $storageKey

```

### Creating a new SAS token
```
expiryDate=`date -u -d "120 minutes" '+%Y-%m-%dT%H:%MZ'`

sasToken=$(az storage account generate-sas \
    --account-name $storageAccountName \
    --account-key $storageKey \
    --expiry $expiryDate \
    --permissions rwcul \
    --resource-types sco \
    --services b \
    --https-only \
    --output tsv)

echo $sasToken
```

### Uploading the country_list.json file to the blob container
```
blobName="country_list.json"

az storage blob upload \
    --account-key $storageKey \
    --file <local-path>/country_list.json \
    --account-name $storageAccountName \
    --container-name bigdata \
    --name $blobName
```

### Creating a new Azure Databricks workspace
```
databricksWorkspaceName="<databricks-workspace>"
location="<region>"

az databricks workspace create \
  --resource-group $rgName \
  --name $databricksWorkspaceName \
  --location $location \
  --sku standard
```

### Cell 1
```
// cell #1
val storageAccountName = "<storage-account-name>"
val fileSystemName = "{file_system_name}"
val SAS = "{SAS_token}"
```

### Cell 2
```
// cell #2
spark.conf.set("fs.azure.account.auth.type." 
  + storageAccountName + ".dfs.core.windows.net", "SAS")

spark.conf.set("fs.azure.sas.token.provider.type." 
  + storageAccountName + ".dfs.core.windows.net", 
  "org.apache.hadoop.fs.azurebfs.sas.FixedSASTokenProvider")

spark.conf.set("fs.azure.sas.fixed.token." 
  + storageAccountName + ".dfs.core.windows.net", SAS)
```

### Cell 3
```
// cell #3
val df = spark.read.option("multiLine", true)
  .json("abfss://" 
        + fileSystemName + "@" + storageAccountName 
        + ".dfs.core.windows.net/country_list.json")
```

### Cell 4
```
// cell #4
df.show()
```

### Cell 5
```
// cell #5
val selectColDf = df.select("name", "capital", "currency.code")
selectColDf.show()
```

### Cell 6
```
// cell #6
val renameColDF = selectColDf.withColumnRenamed("code", "currency_code")
  .withColumnRenamed("name", "country_name")
renameColDF.show()
```

### Cell 7
```
// cell #7
renameColDF.write.json("/tmp/processed_country.json")
dbutils.fs.ls ("/tmp/")
```