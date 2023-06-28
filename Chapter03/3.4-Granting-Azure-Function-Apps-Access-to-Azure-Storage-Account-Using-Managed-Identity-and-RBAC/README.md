# Granting Azure Function Apps Access to Azure Storage Account Using Managed Identity and RBAC 


### Provisioning a new Azure Storage Account
```
storageName="<storage-account-name>"

az storage account create \
    --name $storageName \
    --resource-group $rgName \
    --location $region \
    --sku Standard_LRS
```

### Provisioning a second Storage Account for the Function App
```
funcStorageName="<func-storage-account-name>"

az storage account create \
    --name $funcStorageName \
    --resource-group $rgName \
    --location $region \
    --sku Standard_LRS
```

### Creating a new Azure Function App
```
planName="<appservice-plan-name>"
funcAppName="<function-app-name>"

az appservice plan create \
    --resource-group $rgName \
    --name $planName \
    --sku S1 \
    --location $region

az functionapp create \
    --resource-group $rgName \
    --name $funcAppName \
    --storage-account $funcStorageName \
    --assign-identity [system] \
    --functions-version 4 \
    --plan $planName \
    --runtime dotnet \
    --runtime-version 6 \
    --os-type Windows
```

### Storing the Storage Account resource Id and Function App identity object Id
```
storageResourceId=$(az storage account show \
    --name $storageName \
    --resource-group $rgName \
    --query id \
    --output tsv)

funcIdentityObjectId=$(az functionapp show \
    --name $funcAppName \
    --resource-group $rgName \
    --query identity.principalId \
    --output tsv)
```

### Getting the desired built-in RBAC role definition id
```
roleDefinitionId=$(az role definition list \
    --name "Storage Blob Data Contributor" \
    --query [].id --output tsv)
```

### Assigning the desired role definition to the Function App, over the Storage Account scope
```
MSYS_NO_PATHCONV=1 az role assignment create \
    --assignee $funcIdentityObjectId \
    --role $roleDefinitionId \
    --scope $storageResourceId
```

### Clean up
```
az group delete --name $rgName
```