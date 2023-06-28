# Collecting Platform Logs for an Azure Resource


### Creating a Key Vault resource
```
kvName="<key-vault-name>"

az keyvault create \
  --name $kvName \
  --resource-group $rgName \
  --location $region \
  --enabled-for-disk-encryption

vaultID=$(az keyvault show \
  --resource-group $rgName \
  --name $kvName \
  --query "id" \
  --output tsv)
```

### Provisioning a new Log Analytics Workspace
```
workspaceName="<log-analytics-ws-name>"

az monitor log-analytics workspace create \
    --resource-group $rgName \
    --name $workspaceName \
    --retention-time 31

workspaceID=$(az monitor log-analytics workspace show \
  --resource-group $rgName \
  --workspace-name $workspaceName \
  --query "id" \
  --output tsv)
```

### Configuring Diagnostic Settings for Azure Key Vault
```
az monitor diagnostic-settings create \
  --resource $vaultID \
  --name myKeyVault-logs \
  --workspace $workspaceID \
  --logs '[{"category": "AuditEvent","enabled": true}]' \
  --metrics '[{"category": "AllMetrics","enabled": true}]'
```

### Creating a new Secret to Generate Some Audit Logs
```
az keyvault secret set \
  --name "MySecret" \
  --vault-name $kvName \
  --value "MySecretValue"
```

### Clean up
```
az group delete --name $rgName
```