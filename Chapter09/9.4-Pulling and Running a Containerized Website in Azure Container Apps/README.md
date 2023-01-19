# Pulling and Running a Containerized Website in Azure Container Apps


### Installing the containerapp CLI extension
```
az extension add --name containerapp --upgrade
```

### Registering Microsoft.App and Microsoft.OperationalInsights providers
```
az provider register --namespace Microsoft.App
az provider register --namespace Microsoft.OperationalInsights
```

### Provisioning a new Azure Container App Environment
```
rgName="<resource-group-name>"
envName="cookbook-env"

az containerapp env create \
  --name $envName \
  --resource-group $rgName 
```

### Creating a new Azure Container App
```
registryName="<acr-name>"
appName="cookbook-container-app01"

az containerapp create \
  --name $appName \
  --resource-group $rgName \
  --image $acrLoginServer"/static-html-image:ver1.0" \
  --environment $envName \
  --ingress external \
  --target-port 80 \
  --registry-server $acrLoginServer \
  --registry-username $acrAdminUser \
  --registry-password $acrAdminPass
```

### Grabbing the Container App URL
```
appHost=$(az containerapp show \
  --name $appName \
  --resource-group $rgName \
  --query properties.configuration.ingress.fqdn \
  --output tsv)

 appURL="http://"$appHost

echo $appURL
```

### Deleting the Container App
```
az containerapp delete \
  --resource-group $rgName \
  --name $appName
```

### Deleting the Container App Environment
```
az containerapp env delete \
  --name $envName \
  --resource-group $rgName
```