# Implementing a Web API Using Azure Functions


### Provisioning a new Azure Storage Account
```
rgName="<resource-group-name>"
funcStorageAccountName="<func-app-storage-account-name>"
location="<region>"

az storage account create \
   --name $funcStorageAccountName \
   --resource-group $rgName \
   --location $location \
   --sku Standard_LRS
```

### Provisioning a new Azure Function App
```
functionAppName="<func-app-name>"

az functionapp create \
  --resource-group $rgName \
  --name $functionAppName \
  --storage-account $funcStorageAccountName \
  --functions-version 4 \
  --https-only true \
  --consumption-plan-location $location
```

### HTTP-triggered function body
```
{
    log.LogInformation("C# HTTP trigger function processed a request.");

    int num01 = int.Parse(req.Query["num01"]);
    int num02 = int.Parse(req.Query["num02"]);

    int addition = num01 + num02;

    return new OkObjectResult(addition);
}
```