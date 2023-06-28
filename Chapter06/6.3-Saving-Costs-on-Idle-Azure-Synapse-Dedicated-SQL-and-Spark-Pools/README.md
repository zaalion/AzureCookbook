# Saving Costs on Idle Azure Synapse Dedicated SQL and Spark Pools


### Creating a new Synapse Dedicated SQL pool
```
dedicatedSQLPoolName="<dedicated-pool-name>"

az synapse sql pool create \
  --name $dedicatedSQLPoolName \
  --performance-level "DW1000c" \
  --workspace-name $synapseWorkspaceName \
  --resource-group $rgName \
  --collation "SQL_Latin1_General_CP1_CS_AS"
```

### Getting the pool status
```
az synapse sql pool show \
  --name $dedicatedSQLPoolName \
  --workspace-name $synapseWorkspaceName \
  --resource-group $rgName \
  --query status
```

### Pausing the Dedicated SQL pool
```
az synapse sql pool pause \
  --name $dedicatedSQLPoolName \
  --workspace-name $synapseWorkspaceName \
  --resource-group $rgName
```

### Resume/start the pool
```
az synapse sql pool resume \
  --name $dedicatedSQLPoolName \
  --workspace-name $synapseWorkspaceName \
  --resource-group $rgName
```

### Deleting the pool
```
az synapse sql pool delete \
  --name $dedicatedSQLPoolName \
  --workspace-name $synapseWorkspaceName \
  --resource-group $rgName
```

### Creating a new Synapse Spark pool
```
sparkPoolName="<spark-pool-name>"

az synapse spark pool create \
  --name $sparkPoolName \
  --workspace-name $synapseWorkspaceName \
  --resource-group $rgName \
  --spark-version 2.4 \
  --node-count 3 \
  --node-size Small \
  --enable-auto-pause true \
  --delay 10
```

### Getting the Spark pool status
```
az synapse spark pool show \
  --name $sparkPoolName \
  --workspace-name $synapseWorkspaceName \
  --resource-group $rgName \
  --query autoPause
```

### Deleting the Spark pool
```
az synapse spark pool delete \
  --name $sparkPoolName \
  --workspace-name $synapseWorkspaceName \
  --resource-group $rgName
```

### Clean up
```
az group delete --name $rgName
```