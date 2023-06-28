# Analyzing Azure Monitor Platform Logs


### Listing Tables in a Log Analytics Workspace
```
workspaceName="<log-analytics-ws-name>"

az monitor log-analytics workspace table list \
    --resource-group $rgName \
    --workspace-name $workspaceName \
    --query "[].name"
```

### Grabbing the Log Analytics Workspace GUID (customerID)
```
wsGUID=$(az monitor log-analytics workspace show \
    --resource-group $rgName \
    --name $workspaceName \
    --query customerId \
    --output tsv)
```

### Querying the AzureMetrics Table
```
kvName="<key-vault-resource-name>"

az monitor log-analytics query \
    --workspace $wsGUID \
    --analytics-query \
    "AzureMetrics | where ResourceId has \"$kvName\""
```

### Sample Record from AzureMetrics Table
```
{
    "Average": "15",
    "Count": "2",
    "DurationMs": "None",
    "Maximum": "16",
    "MetricName": "ServiceApiLatency",
    "Minimum": "14",
    "RemoteIPLatitude": "None",
    "RemoteIPLongitude": "None",
    "Resource": "MYCOOK2551KV",
    "ResourceGroup": "CH11",
    "ResourceId": ".../MYCOOK2551KV",
    "ResourceProvider": "MICROSOFT.KEYVAULT",
    "Severity": "None",
    "SourceSystem": "Azure",
    "TableName": "PrimaryResult",
    "TenantId": "00000000-0000-0000-0000-000000000000",
    "TimeGenerated": "2023-01-25T16:14:00Z",
    "TimeGrain": "PT1M",
    "Total": "30",
    "Type": "AzureMetrics",
    "UnitName": "Milliseconds",
    "_ResourceId": ".../microsoft.keyvault/vaults/mycook2551kv"
}
```

### Querying the AzureDiagnostics Table
```
az monitor log-analytics query \
    --workspace $wsGUID \
    --analytics-query \
    "AzureDiagnostics | where ResourceId has \"$kvName\""
```

### Sample Record from AzureDiagnostics Table
```
{
    "CallerIPAddress": "<xx.xx.xx.xx>",
    "Category": "AuditEvent",
    "DurationMs": "16",
    "OperationName": "VaultGet",
    "OperationVersion": "2021-10-01",
    "Resource": "MYCOOK2551KV",
    "ResourceGroup": "CH11",
    "ResourceId": ".../VAULTS/MYCOOK2551KV",
    "ResourceProvider": "MICROSOFT.KEYVAULT",
    "ResourceType": "VAULTS",
    "ResultSignature": "OK",
    "ResultType": "Success",
    "SubscriptionId": "00000000-0000-0000-0000-000000000000",
    "TableName": "PrimaryResult",
    "TenantId": "d61fb72d-c32d-4ea9-b242-9b0a3c99a153",
    "TimeGenerated": "2023-01-25T12:32:50.1285329Z",
    "Type": "AzureDiagnostics",
    "_ResourceId": ".../vaults/mycook2551kv",
    "clientPort_d": "None",
    "httpStatusCode_d": "200",
    "id_s": "https://mycook2551kv.vault.azure.net/",
    "identity_claim_appid_g": "00000000-0000-0000-0000-000000000000",
    "identity_claim": "live.com#zaalion@outlook.com",
    "properties_enableSoftDelete_b": "True",
    "properties_enabledForDeployment_b": "False",
    "properties_enabledForDiskEncryption_b": "True",
    "properties_enabledForTemplateDeployment_b": "None",
    "properties_sku_Family_s": "A",
    "properties_sku_Name_s": "standard",
    "properties_softDeleteRetentionInDays_d": "90"
}
```

### Clean up
```
az group delete --name $rgName
```