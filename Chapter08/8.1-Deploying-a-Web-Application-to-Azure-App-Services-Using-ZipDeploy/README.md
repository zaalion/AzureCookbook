# Deploying a Web Application to Azure App Services Using ZipDeploy


### Provisioning a new Azure App Service Plan
```
rgName="<resource_group_name>"
planName="<appservice-plan-name>"

az appservice plan create \
  --resource-group $rgName \
  --name $planName \
  --number-of-workers 2 \
  --sku S1
```

### Creating a new Azure App Service Web App
```
appServiceName="<appservice-name>"

az webapp create \
  --resource-group $rgName \
  --plan $planName \
  --name $appServiceName \
  --runtime "dotnet:6"
```

### Deploying a ZIP file
```
az webapp deployment source config-zip \
    --resource-group $rgName \
    --name $appServiceName \
    --src "<path-to-downloaded-wwwroot.zip>"
```

### Grabbing the website URL
```
url="https://"$(az webapp show \
  --resource-group $rgName \
  --name $appServiceName \
  --query defaultHostName \
  -o tsv)

echo $url
```