# Backing up Azure SQL Single Database into Azure Storage Blobs


### Provisioning a new Azure SQL database
```
logicalServerName="<logical-sql-server-name>"
sqlAdminUser="<admin-user>"
sqlAdminPass="<admin-pass>"

az sql server create \
  --resource-group $rgName \
  --name $logicalServerName \
  --admin-user $sqlAdminUser \
  --admin-password $sqlAdminPass

az sql db create \
  --resource-group $rgName \
  --server $logicalServerName \
  --name db01 \
  --compute-model Serverless \
  --edition GeneralPurpose \
  --family Gen5 \
  --auto-pause-delay 60 \
  --min-capacity 0.5 \
  --capacity 2 \
  --sample-name AdventureWorksLT
```

### Allowing Azure services to see your Azure SQL resource
```
az sql server firewall-rule create \
  --resource-group $rgName \
  --server $logicalServerName \
  --name allowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0
```

### Creating an Azure Storage Account and a blob container to store the SQL backups
```
storageName="<storage-account-name>"
bakContainerName="sqlbackups"

# we chose the Locally redundant storage (LRS) sku but you may need 
# to choose a better redundancy for your Azure SQL backups.

az storage account create \
   --name $storageName \
   --resource-group $rgName \
   --sku Standard_LRS

storageKey1=$(az storage account keys list \
  --resource-group $rgName \
  --account-name $storageName \
  --query [0].value \
  --output tsv)

MSYS_NO_PATHCONV=1 az storage container create \
  --name $bakContainerName \
  --account-name $storageName \
  --account-key $storageKey1
```

### Creating a SQL backup and save it in the storage container
```
storageURL= \
"https://$storageName.blob.core.windows.net/\$bakContainerName/sqlbackup01.bacpac"

MSYS_NO_PATHCONV=1 az sql db export \
  --resource-group $rgName \
  --server $logicalServerName \
  --name db01 \
  --admin-user $sqlAdminUser \
  --admin-password $sqlAdminPass \  
  --storage-key $storageKey1 \
  --storage-key-type StorageAccessKey \
  --storage-uri $storageURL 
```

### Conforming that the SQL backup file exists in the Storage Account
```
MSYS_NO_PATHCONV=1 az storage blob list \
  --container-name $bakContainerName \
  --account-key $storageKey1 \
  --account-name $storageName \
  --query "[].{Name: name, Length: properties.contentLength}"
```

### Clean up
```
az group delete --name $rgName
```