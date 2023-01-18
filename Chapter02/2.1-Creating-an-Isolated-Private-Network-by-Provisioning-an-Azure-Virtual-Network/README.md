# Creating an Isolated Private Network by Provisioning an Azure Virtual Network


### Creating a new Azure VNet
```
rgName="<resource-group-name>"
vnetName="<vnet-name>"

az network vnet create \
    --resource-group $rgName \
    --name $vnetName \
    --address-prefix 10.0.0.0/16 \
    --subnet-name Subnet01 \
    --subnet-prefix 10.0.0.0/26
```

### Getting VNet details
```
az network vnet show \
    --resource-group $rgName \
    --name $vnetName
```