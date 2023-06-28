# Securing Azure Virtual Networks With Azure Firewall


### Creating a new Azure VNet subnet
```
rgName="<resource-group-name>"
vnetName="<vnet-name>"

az network vnet subnet create \
    --resource-group $rgName \
    --vnet-name $vnetName \
    --name AzureFirewallSubnet \
    --address-prefixes 10.0.1.0/26
```

### Creating a new Azure Firewall resource
```
firewallName="<firewall-name>"

az network firewall create \
    --resource-group $rgName \
    --name $firewallName \
    --tier Standard
```

### Assigning a public IP address to the Firewall
```
pIPName="<public-ip-name>"

az network public-ip create \
    --resource-group $rgName \ 
    --name $pIPName \
    --sku Standard


az network firewall ip-config create \
    --resource-group $rgName \
    --name fwIPConfiguration01
    --firewall-name $firewallName \
    --public-ip-address $pIPName \
    --vnet-name $vnetName
```

### Creating a new application rule in the Firewall
```
az network firewall application-rule create \
    --resource-group $rgName \
    --collection-name Application_Rule_Collection \
    --firewall-name $firewallName \
    --name Allow_Contoso \
    --protocols Https=443 \
    --action Allow \
    --target-fqdns www.contoso.com \
    --priority 1000  
```

### Creating a Route Table to redirect all traffic to the Firewall
```
routeTableName="<fw-route-table-name>"

az network route-table create \
    --resource-group $rgName \
    --name $routeTableName
```

### Getting the Firewall resource private IP address:
```
firewallPrivateIP=$(az network firewall show \
    --name $firewallName \
    --resource-group $rgName \
    --query "ipConfigurations[0].privateIpAddress" \
    --output tsv)
```

### Adding a custom route to the Route Table
```
routeName="<custom-route-name>"

az network route-table route create \
    --resource-group $rgName \
    --route-table-name $routeTableName \
    --name $routeName \
    --next-hop-type VirtualAppliance \
    --address-prefix 0.0.0.0/0 \
    --next-hop-ip-address $firewallPrivateIP
```

### Associate the Route Table to your subnet:
```
az network vnet subnet update \
    --resource-group $rgName \
    --name Subnet02 \
    --vnet-name $vnetName \
    --route-table $routeTableName
```

### Clean up:
```
az group delete --name $rgName
```