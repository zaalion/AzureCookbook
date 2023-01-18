# Implement a Publish-Subscribe Pattern Using Azure Service Bus Topics


### Provisioning a new Azure Service Bus Namespace
```
rgName="<resource-group-name>"
namespaceName="<servicebus-namespace-name>"

az servicebus namespace create \
  --resource-group $rgName \
  --name $namespaceName \
  --sku Standard
```

### Creating a new Service Bus topic
```
az servicebus topic create \
  --resource-group $rgName \
  --namespace-name $namespaceName \
  --name notificationsTopic   

```

### Creating two subscriptions for the topic
```
az servicebus topic subscription create \
  --resource-group $rgName \
  --namespace-name $namespaceName \
  --topic-name notificationsTopic \
  --name subscription01

az servicebus topic subscription create \
  --resource-group $rgName \
  --namespace-name $namespaceName \
  --topic-name notificationsTopic \
  --name subscription02
```