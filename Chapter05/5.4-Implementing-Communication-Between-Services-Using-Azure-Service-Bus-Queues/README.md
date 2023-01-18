# Implementing Communication Between Services Using Azure Service Bus Queues


### Provisioning a new Azure Service Bus Namespace
```
rgName="<resource-group-name>"
namespaceName="<servicebus-namespace-name>"

az servicebus namespace create \
  --resource-group $rgName \
  --name $namespaceName \
  --sku Standard
```

### Creating a new Service Bus queue
```
az servicebus queue create \
  --resource-group $rgName \
  --namespace-name $namespaceName \
  --name ordersqueue
```