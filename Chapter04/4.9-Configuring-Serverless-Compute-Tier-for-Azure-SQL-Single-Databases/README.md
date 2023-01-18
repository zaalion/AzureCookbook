# Configuring Serverless Compute Tier for Azure SQL Single Databases


### Provisioning a new Azure logical SQL Server
```
rgName="<resource-group-name>"
logicalServerName="<logical-sql-server-name>"
sqlAdminUser="<admin-user>"
sqlAdminPass="<admin-pass>"

az sql server create \
  --resource-group $rgName \
  --name $logicalServerName \
  --admin-user $sqlAdminUser \
  --admin-password $sqlAdminPass

```

### Creating a new SQL database
```
# The minimum vCore limit is 1 and the maximum is 4.

az sql db create \
  --resource-group $rgName \
  --server $logicalServerName \
  --name db01 \
  --compute-model Serverless \
  --edition GeneralPurpose \
  --family Gen5 \
  --auto-pause-delay 120 \
  --min-capacity 1 \
  --capacity 4
```

### Getting sql db details
```
az sql db show \
  --resource-group $rgName \
  --server $logicalServerName \
  --name db01 \
  --query \
  "{Name: name, Sku: currentSku, Edition: edition, MinCapacity: minCapacity}"
```