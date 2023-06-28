# Using a Lifecycle Management Policy to Save Storage Account Costs


### Creating a new Storage Account
```
storageName="<storage-account-name>"

az storage account create \
  --name $storageName \
  --access-tier Hot \
  --resource-group $rgName \
  --location $region \
  --sku Standard_LRS \
  --default-action Allow
```

### Sample life-cycle rule definition
```
{
  "rules": [
    {
      "enabled": true,
      "name": "sample-rule",
      "type": "Lifecycle",
      "definition": {
        "actions": {
          "baseBlob": {
            "tierToCool": {
              "daysAfterModificationGreaterThan": 60
            },
            "tierToArchive": {
              "daysAfterModificationGreaterThan": 120,
              "daysAfterLastTierChangeGreaterThan": 60
            },
            "delete": {
              "daysAfterModificationGreaterThan": 2920
            }
          }
        }
      },
      "filters": {
          "blobTypes": [
            "blockBlob"
          ]
       }
    }
  ]
}
```

### Creating a new life-cycle policy for Azure Storage Account
```
az storage account management-policy create \
  --resource-group $rgName \
  --account-name $storageName \
  --policy <path-to-folder/ACCESS_POLICY.JSON>
```

### Clean up
```
az group delete --name $rgName
```