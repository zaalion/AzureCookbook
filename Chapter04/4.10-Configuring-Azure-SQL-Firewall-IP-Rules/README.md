# Configuring Azure SQL Firewall IP Rules


### Provisioning a new Azure logical SQL Server and a child SQL database
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
  --min-capacity 1 \
  --capacity 2

```

### Configuring Azure SQL Server firewall by adding an IP rule
```
az sql server firewall-rule create \
  --resource-group $rgName \
  --server $logicalServerName \
  --name allowTrustedClients \
  --start-ip-address 99.0.0.0 \
  --end-ip-address 99.0.0.255
```

### Configuring Azure SQL Server firewall (allowing Azure services)
```
az sql server firewall-rule create \
  --resource-group $rgName \
  --server $logicalServerName \
  --name allowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0
```

### List Azure Sql firewall rules
```
az sql server firewall-rule list \
  --resource-group $rgName \
  --server $logicalServerName
```

### Clean up
```
az group delete --name $rgName
```