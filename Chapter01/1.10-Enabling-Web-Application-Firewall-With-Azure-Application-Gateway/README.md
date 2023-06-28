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
  --output tsv)
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

### Creating a public IP
```
gwIPName="appgatewayPublicIP"

az network public-ip create \
  --resource-group $rgName \
  --name $gwIPName \
  --sku Standard
```

### Creating a WAF Policy reosurce
```
wafPolicyName="appgatewayWAFPolicy"

az network application-gateway waf-policy create \
  --name $wafPolicyName \
  --resource-group $rgName
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
  --servers $appURL \
  --public-ip-address $ipName \
  --priority 1001 \
  --waf-policy $policyName
```

### Getting the public IP address of the Application Gateway
```
IPAddress=$(az network public-ip show \
  --resource-group $rgName \
  --name $gwIPName \
  --query ipAddress \
  --output tsv)

echo $IPAddress
```

### Clean up
```
az group delete --name $rgName
```