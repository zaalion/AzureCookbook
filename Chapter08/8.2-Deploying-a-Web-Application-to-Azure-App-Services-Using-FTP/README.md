# Deploying a Web Application to Azure App Services Using FTP


### Provisioning a new Azure App Service Plan
```
rgName="<resource_group_name>"
planName="<appservice-plan-name>"

az appservice plan create \
  --resource-group $rgName \
  --name $planName \
  --is-linux \
  --number-of-workers 2 \
  --sku S1
```

### Creating a new App Service
```
appServiceName="<appservice-name>"

az webapp create \
  --resource-group $rgName \
  --plan $planName \
  --name $appServiceName \
  --runtime "PHP:8.0"

```

### index.php
```
<html>
<body>
  <h1>
    <?php echo "Trying FTP Deployment..." ?>
  <h1>
</body>
</html>
```

### Grabbing the FTP details for the App Service
```
ftpDetails=($(az webapp deployment list-publishing-profiles \
  --name $appServiceName \
  --resource-group $rgName \
  --query "[?contains(publishMethod, 'FTP')].[publishUrl,userName,userPWD]" \
  -o tsv))
```

### Using cURL tp FTP content
```
curl -T index.php -u ${ftpDetails[1]}:${ftpDetails[2]} ${ftpDetails[0]}/
```

### Grabbing the webapp URL
```
url="https://"$(az webapp show \
  --resource-group $rgName \
  --name $appServiceName \
  --query defaultHostName \
  -o tsv)"/index.php"

echo $url
```