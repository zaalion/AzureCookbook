# Enabling Web Application Firewall (WAF) With Azure Application Gateway

### Creating a NEW Azure App Service
```
rgName="<resource-group-name>"
appName="<web-app-name>"
planName=$appName"-plan"

az appservice plan create \
  --resource-group $rgName \
  --name $planName

az webapp create \
  --resource-group $rgName \
  --plan $planName \
  --name $appName
```

### Getting the App URL
```
appURL=$(az webapp show \
  --name $appName \
  --resource-group $rgName \
  --query "defaultHostName" \
  -o tsv)
```

### Creating a new Azure VNet
```
vnetName="AppGWVnet"

az network vnet create \
  --resource-group $rgName \
  --name $vnetName \
  --address-prefix 10.0.0.0/16 \
  --subnet-name Default \
  --subnet-prefix 10.0.0.0/24
```

### Creating the App Gateway
```
appGWName="<app-gateway-name>"

az network application-gateway create \
  --resource-group $rgName \
  --name $appGWName \
  --capacity 1 \
  --sku WAF_v2 \  
  --vnet-name $vnetName \
  --subnet Default \
  --servers $appURL
```