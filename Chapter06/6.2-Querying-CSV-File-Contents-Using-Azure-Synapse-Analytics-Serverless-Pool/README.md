# Querying CSV File Contents Using Azure Synapse Analytics Serverless Pool


### Creating a new Azure Storage Account
```
rgName="<resource-group-name>"
storageAccountName="<storage-account-name>"

az storage account create \
   --name $storageAccountName \
   --resource-group $rgName \
   --sku Standard_LRS \
   --enable-hierarchical-namespace true
```

### Creating a new container
```
storageKey=$(az storage account keys list \
    --resource-group $rgName \
    --account-name $storageAccountName \
    --query [0].value \
    --output tsv)

az storage container create \
    --name "rawdata" \
    --account-name $storageAccountName \
    --account-key $storageKey
```

### Uploading the source CSV file
```
az storage blob upload \
    --account-key $storageKey \
    --file <local-path> \
    --account-name $storageAccountName \
    --container-name "rawdata" \
    --name "cars.csv"
```

### Provisioning an Azure Synapse Analytics workspace
```
synapseWorkspaceName="<synapse-workspace-name>"
sqlUser="<sql-username>"
sqlPassword="<sql-password>"

az synapse workspace create \
  --name $synapseWorkspaceName \
  --resource-group $rgName \
  --storage-account $storageAccountName \
  --file-system "rawdata" \
  --sql-admin-login-user $sqlUser \
  --sql-admin-login-password $sqlPassword
```

### Grabbing the workspace URL
```
workspaceURL=$(az synapse workspace show \
  --name $synapseWorkspaceName \
  --resource-group $rgName \
  | jq -r '.connectivityEndpoints | .web')

echo $workspaceURL
```

### Configuring the Synapse firewall to allow your IP address
```
clientIP="<your-public-ip-address>"

az synapse workspace firewall-rule create \
  --end-ip-address $clientIP \
  --start-ip-address $clientIP \
  --name "Allowing My IP" \
  --resource-group $rgName \
  --workspace-name $synapseWorkspaceName

```

### SQL command to create a new database
```
CREATE DATABASE electricCarsDB
    COLLATE Latin1_General_100_BIN2_UTF8
```

### Creating an external table in the Synapse database using SQL
```
CREATE EXTERNAL DATA SOURCE csvfiles
WITH (
    LOCATION = 'https://synapsecookdl01.blob.core.windows.net/rawdata/'
)


CREATE EXTERNAL FILE FORMAT CsvFileFormat
    WITH (
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS(
            FIELD_TERMINATOR = ',',
            STRING_DELIMITER = '"',
            FIRST_ROW  = 2
        )
    );


CREATE EXTERNAL TABLE dbo.electricHybridCars
(
    VIN VARCHAR(11),
    Country VARCHAR(20),
    City VARCHAR(20),
    [State] VARCHAR(2),
    [Postal Code] VARCHAR(5),
    [Model Year] VARCHAR(4),
    Make VARCHAR(20)
)
WITH
(
    DATA_SOURCE = csvfiles,
    LOCATION = '*.csv',
    FILE_FORMAT = CsvFileFormat
);
```

### Querying the external table using SQL
```
-- Find the number of registered cars per make

SELECT Make, COUNT(*) as Sold FROM dbo.electricHybridCars
GROUP BY Make
ORDER BY Sold DESC

```