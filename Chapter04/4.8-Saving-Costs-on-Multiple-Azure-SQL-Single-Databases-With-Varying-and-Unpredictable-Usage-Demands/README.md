# Saving Costs on Multiple Azure SQL Single Databases With Varying and Unpredictable Usage Demands


### Provisioning a new Azure logical SQL Server
```
rgName="<resource-group-name>"
logicalServerName="<logical-sql-server-name>"
sqlAdminUser="<admin-user>"

# Use a complex password with numbers, upper case characters and symbols.
sqlAdminPass="<admin-pass>"

az sql server create \
  --resource-group $rgName \
  --name $logicalServerName \
  --admin-user $sqlAdminUser \
  --admin-password $sqlAdminPass
```

### Creating a new SQL Pool
```
sqlPoolName="MyPool01"

az sql elastic-pool create \
  --resource-group $rgName \
  --server $logicalServerName \
  --name $sqlPoolName \
  --edition GeneralPurpose \
  --family Gen5 \
  --capacity 2
```

### Creating two new SQL databases into the pool
```
az sql db create \
  --resource-group $rgName \
  --server $logicalServerName \
  --name db01 \
  --elastic-pool $sqlPoolName

az sql db create \
  --resource-group $rgName \
  --server $logicalServerName \
  --name db02 \
  --elastic-pool $sqlPoolName
```

### List the databases in the pool
```
az sql elastic-pool list-dbs \
  --resource-group $rgName \
  --name $sqlPoolName \
  --server $logicalServerName \
  --query [].name
```