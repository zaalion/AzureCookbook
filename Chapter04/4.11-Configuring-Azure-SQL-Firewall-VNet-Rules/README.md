# Configuring Azure SQL Firewall VNet Rules


### Provisioning a new Azure VNet
```
vnetName="<vnet-name>"

az network vnet create \
  --resource-group $rgName \
  --name $vnetName \
  --address-prefix 10.0.0.0/16 \
  --subnet-name Subnet01 \
  --subnet-prefix 10.0.0.0/26
```

### Adding Azure SQL service endpoint to the subnet
```
az network vnet subnet update \
  --resource-group $rgName \
  --name Subnet01 \
  --vnet-name $vnetName \
  --service-endpoints Microsoft.Sql
```

### Adding a VNet access rule to the Azure SQL firewall
```
az sql server vnet-rule create \
  --resource-group $rgName \
  --server $logicalServerName \
  --name allowTrustedSubnet \
  --vnet-name $vnetName \
  --subnet Subnet01
```

### Clean up
```
az group delete --name $rgName
```