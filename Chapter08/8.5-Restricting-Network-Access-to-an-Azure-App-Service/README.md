# Restricting Network Access to an Azure App Service


### Grabbing the App Service URL
```
url="https://"$(az webapp show \
  --resource-group $rgName \
  --name $appServiceName \
  --query defaultHostName \
  -o tsv)

echo $url
```

### Creating a new Azure VNet
```
vnetName="<vnet-name>"

az network vnet create \
    --resource-group $rgName \
    --name $vnetName \
    --address-prefix 10.0.0.0/16 \
    --subnet-name Subnet01 \
    --subnet-prefix 10.0.0.0/26
```

### Configuring network access restrictions for App Service (VNet)
```
az webapp config access-restriction add \
  --resource-group $rgName \
  --name $appServiceName \
  --rule-name vNetClients \
  --action Allow \
  --vnet-name $vnetName \
  --subnet Subnet01 \
  --priority 100
```

### Configuring network access restrictions for App Service (public IP)
```
myPublicIPv4="<my-public-ip>"

az webapp config access-restriction add \
  --resource-group $rgName \
  --name $appServiceName \
  --rule-name myself \
  --action Allow \
  --ip-address $myPublicIPv4 \
  --priority 110

```

### Showing access restriction rules for your App Service
```
az webapp config access-restriction show \
  --resource-group $rgName \
  --name $appServiceName
```

### Clean up
```
az group delete --name $rgName
```