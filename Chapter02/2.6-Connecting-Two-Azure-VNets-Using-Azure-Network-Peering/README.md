# Connecting Two Azure VNets Using Azure Network Peering


### Creating the first Azure VNet
```
rgName="<resource-group-name>"

az network vnet create \
    --resource-group $rgName \
    --name VNet01 \
    --address-prefix 10.0.0.0/16 \
    --subnet-name Subnet01 \
    --subnet-prefix 10.0.0.0/26
```

### Creating the second Azure VNet
```
az network vnet create \
    --resource-group $rgName \
    --name VNet02 \
    --address-prefix 10.1.0.0/16 \
    --subnet-name Subnet01 \
    --subnet-prefix 10.1.0.0/26
```

### Creating the first peering (vnet1 => vnet2)
```
az network vnet peering create \
    --resource-group $rgName \
    --name peering01 \
    --vnet-name VNet01 \
    --remote-vnet VNet02 \
    --allow-vnet-access
```

### Creating the second peering (vnet2 => vnet1)
```
az network vnet peering create \
    --resource-group $rgName \
    --name peering02 \
    --vnet-name VNet02 \
    --remote-vnet VNet01 \
    --allow-vnet-access
```