# Restricting Network Access to Azure Function Apps 


### Provisioning an Azure VNet
```
rgName="<resource-group-id>"
vnetName="<vnet-name>"

az network vnet create \
    --resource-group $rgName \
    --name $vnetName \
    --address-prefix 10.0.0.0/16 \
    --subnet-name Subnet01 \
    --subnet-prefix 10.0.0.0/26
```

### Grab the name of your running Function App
```
functionAppName="<function-app-name>"
```

### Configuring network access restrictions for your Function App (allowing public IP)
```
az functionapp config access-restriction add \
  --resource-group $rgName \
  --name $functionAppName \
  --rule-name allowMyIP \
  --action Allow \
  --ip-address <ip-address> \
  --priority 100
```

### Configuring network access restrictions for your Function App (VNet)
```
az functionapp config access-restriction add \
  --resource-group $rgName \
  --name $functionAppName \
  --rule-name app_gateway \
  --action Allow \
  --vnet-name $vnetName \
  --subnet Subnet01 \
  --priority 200
```