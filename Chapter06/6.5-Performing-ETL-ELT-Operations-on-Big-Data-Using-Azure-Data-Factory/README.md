# Performing ETL/ELT Operations on Big Data Using Azure Data Factory (ADF)


### Creating a new Azure Storage Account and blob container
```
rgName="<resource-group-name>"
storageAccountName="<storage-account-name>"

az storage account create \
   --name $storageAccountName \
   --resource-group $rgName \
   --sku Standard_LRS

storageKey=$(az storage account keys list \
    --resource-group $rgName \
    --account-name $storageAccountName \
    --query [0].value \
    --output tsv)

az storage container create \
    --name "datasource" \
    --account-name $storageAccountName \
    --account-key $storageKey

az storage container create \
    --name "datasink" \
    --account-name $storageAccountName \
    --account-key $storageKey
```

### Uploading country_list.json
```
blobName="country_list.json"

az storage blob upload \
    --account-key $storageKey \
    --file <local-path>/country_list.json \
    --account-name $storageAccountName \
    --container-name datasource \
    --name $blobName
```

### Provisioning a new Azure Data Factory
```
adfName="<datafactory-name>"

az datafactory create \
  --resource-group $rgName \
  --factory-name $adfName
```

### Grabbing the Storage Account connection string
```
storageConnection=$(az storage account show-connection-string \
  --resource-group $rgName \
  --name $storageAccountName \
  --key key1 \
  --output tsv)
```

### StorageLinkedService.json
```
{
    "type": "AzureBlobStorage",
    "typeProperties": {
        "connectionString": "{connection_string}"
    }
}
```

### Creating a linked-service
```
az datafactory linked-service create \
  --resource-group $rgName \
  --factory-name $adfName \
  --linked-service-name SourceSinkStorageLinkedService \
  --properties <path-to-StorageLinkedService.json>
```

### InputDataset.json
```
{
  "linkedServiceName": {
    "referenceName": "SourceSinkStorageLinkedService",
    "type": "LinkedServiceReference"
  },
  "annotations": [],
  "type": "Json",
  "typeProperties": {
    "location": {
      "type": "AzureBlobStorageLocation",
      "fileName": "country_list.json",
      "folderPath": "",
      "container": "datasource"
    }
  },
  "schema": {
    "type": "object",
    "properties": {
      "name": { "type": "string" },
      "code": { "type": "string" },
      "capital": { "type": "string" },
      "region": { "type": "string" },
      "currency": {
        "type": "object",
        "properties": {
          "code": { "type": "string" },
          "name": { "type": "string" },
          "symbol": { "type": "string" }
        }
      },
      "language": {
        "type": "object",
        "properties": {
          "code": { "type": "string" },
          "name": { "type": "string" }
        }
      },
      "flag": { "type": "string" }
    }
  }
}
```

### Creating the ADF dataset
```
az datafactory dataset create \
  --resource-group $rgName \
  --dataset-name SourceDataset \
  --factory-name $adfName \
  --properties <path-to-InputDataset.json>
```

### SinkDataset.json
```
{
  "linkedServiceName": {
    "referenceName": "SourceSinkStorageLinkedService",
    "type": "LinkedServiceReference"
  },
  "annotations": [],
  "type": "DelimitedText",
  "typeProperties": {
    "location": {
      "type": "AzureBlobStorageLocation",
      "fileName": "country_list.csv",
      "folderPath": "",
      "container": "datasink"
    },
    "columnDelimiter": ",",
    "escapeChar": "\\",
    "quoteChar": "\""
  }
}
```

### Creating the sink dataset
```
az datafactory dataset create \
  --resource-group $rgName \
  --dataset-name SinkDataset \
  --factory-name $adfName \
  --properties <path-to-SinkDataset.json>
```

### MoveJsonToCSVPipeline.json
```
{
    "name": "JsonToCSVPipeline",
    "properties": {
        "activities": [
            {
                "name": "CopyFromJsonToCSV",
                "type": "Copy",
                "dependsOn": [],
                "policy": {
                    "timeout": "0.12:00:00",
                    "retry": 0,
                    "retryIntervalInSeconds": 30,
                    "secureOutput": false,
                    "secureInput": false
                },
                "userProperties": [],
                "typeProperties": {
                    "source": {
                        "type": "JsonSource",
                        "storeSettings": {
                            "type": "AzureBlobStorageReadSettings",
                            "recursive": true,
                            "wildcardFileName": "country_list.json",
                            "enablePartitionDiscovery": false
                        },
                        "formatSettings": { "type": "JsonReadSettings" }
                    },
                    "sink": {
                        "type": "DelimitedTextSink",
                        "storeSettings": { "type": "AzureBlobStorageWriteSettings" },
                        "formatSettings": {
                            "type": "DelimitedTextWriteSettings",
                            "quoteAllText": true,
                            "fileExtension": ".csv"
                        }
                    },
                    "enableStaging": false,
                    "translator": {
                        "type": "TabularTranslator",
                        "mappings": [
                            {
                                "source": { "path": "$['name']" },
                                "sink": {
                                    "type": "String",
                                    "ordinal": 1
                                }
                            },
                            {
                                "source": { "path": "$['capital']" },
                                "sink": {
                                    "type": "String",
                                    "ordinal": 2
                                }
                            },
                            {
                                "source": { "path": "$['flag']" },
                                "sink": {
                                    "type": "String",
                                    "ordinal": 3
                                }
                            }
                        ]
                    }
                },
                "inputs": [
                    {
                        "referenceName": "SourceDataset",
                        "type": "DatasetReference",
                        "parameters": {}
                    }
                ],
                "outputs": [
                    {
                        "referenceName": "SinkDataset",
                        "type": "DatasetReference",
                        "parameters": {}
                    }
                ]
            }
        ],
        "annotations": []
    }
}

```

### Creating ADF pipeline
```
az datafactory pipeline create \
  --resource-group $rgName \
  --factory-name $adfName \
  --name CopyFromJsonToCSVPipeline \
  --pipeline <path-to-MoveJsonToCSVPipeline.json>
```

### Grabbing the pipeline run id
```
runID=$(az datafactory pipeline create-run \
  --resource-group $rgName \
  --factory-name $adfName \
  --name CopyFromJsonToCSVPipeline \
  --output tsv)
```

### Getting the status of the pipeline execution
```
az datafactory pipeline-run show \
  --resource-group $rgName \
  --factory-name $adfName \
  --run-id $runID \
  --query Status
```

### Confirming that the new blob is created
```
az storage blob list \
    --account-name $storageAccountName \
    --account-key $storageKey \
    --container-name "datasink" \
    --query [].name
```