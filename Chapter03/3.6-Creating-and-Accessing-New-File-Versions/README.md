# Creating and Accessing New File Versions


### Enabling versioning on the Storage Account
```
az storage account blob-service-properties update \
    --account-name $storageName \
    --enable-versioning true 
```

### Uploading a new blob
```
az storage blob upload \
    --account-key $storageKey1 \
    --file <local-file-path> \
    --account-name $storageName \
    --container-name $containerName \
    --name $blobFileName
    --overwrite true
```

### Showing the latest blob version
```
latestVersion=$(az storage blob show \
    --account-name $storageName \
    --account-key $storageKey1 \
    --container-name $containerName \
    --name Myblob01.txt \
    --query versionId \
    --output tsv)
```

### Downloading a specific blob version
```
az storage blob download 
    --account-name $storageName \
    --account-key $storageKey1 \
    --container-name $containerName \
    --name Myblob01.txt \
    --file <downloaded-file-path> 
    --version-id $latestVersion
```