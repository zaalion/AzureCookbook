# Creating a Network Layout in Azure Virtual Networks Using Subnets


### Listing existing subnets within a VNet
```
rgName="<resource-group-name>"
vnetName="<vnet-name>"

az network vnet subnet list \
    --resource-group $rgName \
    --vnet-name $vnetName \
    --query "[].name"
```

### Creating a new subnet
```
az network vnet subnet create \
    --resource-group $rgName \
    --vnet-name $vnetName \
    --name Subnet02 \
    --address-prefixes 10.0.0.128/25
```