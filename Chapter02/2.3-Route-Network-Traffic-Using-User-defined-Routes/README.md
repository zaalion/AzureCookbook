# Route Network Traffic Using User-defined Routes


### Listing all subnets within a VNet
```
rgName="<resource-group-name>"
vnetName="<vnet-name>"

az network vnet subnet list \
    --resource-group $rgName \
    --vnet-name $vnetName \
    --query "[].name"
```

### Creating a new Route Table
```
routeTableName="<route-table-name>"

az network route-table create \
    --resource-group $rgName \
    --name $routeTableName
```

### Creating a new route in the Route Table
```
routeName="<custom-route-name>"

az network route-table route create \
    --resource-group $rgName \
    --route-table-name $routeTableName \
    --name $routeName \
    --next-hop-type Internet \
    --address-prefix 0.0.0.0/0 
```

### Assigning a Route Table to a subnet
```
az network vnet subnet update \
    --resource-group $rgName \
    --name Subnet01 \
    --vnet-name $vnetName \
    --route-table $routeTableName
```

### Clean up
```
az group delete --name $rgName
```