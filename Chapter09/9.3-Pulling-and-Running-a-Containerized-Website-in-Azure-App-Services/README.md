# Pulling and Running a Containerized Website in Azure App Services


### Provisioning an Azure App Service Plan
```
rgName="<resource-group-name>"
planName="<plane-name>"

az appservice plan create \
  --name $planName \
  --resource-group $rgName \
  --is-linux
```

### Creating a new App Service which runs a Docker image
```
appName="<app-name>"

az webapp create \
  --resource-group $rgName \
  --plan $planName \
  --name $appName \
  --deployment-container-image-name $acrLoginServer/static-html-image:ver1.0 \
  --docker-registry-server-user $acrAdminUser \
  --docker-registry-server-password $acrAdminPass
```

### Grabbing the App URL
```
appHost=$(az webapp show \
  --resource-group $rgName \
  --name $appName \
  --query defaultHostName \
  -o tsv)

appURL="https://"$appHost"/index.html"

echo $appURL
```