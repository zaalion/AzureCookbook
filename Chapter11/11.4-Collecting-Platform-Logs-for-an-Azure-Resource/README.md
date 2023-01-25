# Collecting Platform Logs for an Azure Resource


### Creating a Key Vault resource
```
rgName="<resource-group-name>"

kvName="<key-vault-name>"
location="<region>"

az keyvault create \
  --name $kvName \
  --resource-group $rgName \
  --location $location \
  --enabled-for-disk-encryption

vaultID=$(az keyvault show \
    --resource-group $rgName \
    --name $kvName \
    --query "id" \
    -o tsv)
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
    -o tsv)
```

### Configuring Diagnostic Settings for Azure Key Vault
```
az monitor diagnostic-settings create \
    --resource $vaultID  \
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