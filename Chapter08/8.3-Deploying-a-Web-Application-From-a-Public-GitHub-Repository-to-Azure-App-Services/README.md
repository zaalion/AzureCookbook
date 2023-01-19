# Deploying a Web Application From a Public GitHub Repository to Azure App Services


### Configuring Git deployment for an App Service
```
az webapp deployment source config \
  --branch master \
  --manual-integration \
  --name $appServiceName \
  --repo-url https://github.com/Azure-Samples/php-docs-hello-world \
  --resource-group $rgName

```

### Grabbing the App Service URL
```
url="https://"$(az webapp show \
  --resource-group $rgName \
  --name $appServiceName \
  --query defaultHostName \
  -o tsv)"/index.php"

echo $url
```