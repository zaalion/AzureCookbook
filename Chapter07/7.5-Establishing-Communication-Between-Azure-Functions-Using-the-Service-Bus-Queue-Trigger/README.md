# Establishing Communication Between Azure Functions Using the Service Bus Queue Trigger


### Adding the Service Bus connection string to the Function App Configuration settings
```
serviceBusConnectionString=$(az servicebus namespace \
  authorization-rule keys list \
  --resource-group $rgName \
  --namespace-name $namespaceName \
  --name RootManageSharedAccessKey \
  --query primaryConnectionString \
  --output tsv)

az functionapp config appsettings set \
  --name $functionAppName \
  --resource-group $rgName \
  --settings "ServiceBusConnection=$serviceBusConnectionString"
```

### Deploying the function code using ZipDeploy
```
az functionapp deployment source config-zip \
  --resource-group $rgName \
  --name $functionAppName \
  --src deploymentPackage.zip
```

### Sender.cs
```
[FunctionName("Sender")]
[return: ServiceBus("ordersqueue", Connection = "ServiceBusConnection")]
public static string Run(
    [HttpTrigger(AuthorizationLevel.Function, 
    "get", Route = null)] HttpRequest req,
    ILogger log)
{
    log.LogInformation("C# HTTP trigger function processed a request.");

    var output = new
    {
        Kind=req.Query["kind"],
        Count = req.Query["count"]
    }; 

    string queueMessage = JsonConvert.SerializeObject(output);
    return queueMessage;
}
```

### Receiver.cs
```
[FunctionName("Receiver")]
public void Run([ServiceBusTrigger
    ("ordersqueue", Connection = "ServiceBusConnection")]
    string myQueueItem, ILogger log)
{
    log.LogInformation
        ($"Recieved from queue >>>> " +
        $"{myQueueItem}");
}
```

### Clean up
```
az group delete --name $rgName
```