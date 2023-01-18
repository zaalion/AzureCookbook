# Securing Azure Virtual Networks With Network Security Groups (NSGs)


### Creating an Azure Network Security Group
```
rgName="<resource-group-name>"

az network nsg create \
    --resource-group $rgName \ 
    --name nsg01
```

### Adding a new Rule to the NSG
```
az network nsg rule create \
    --resource-group $rgName \  
    --nsg-name nsg01 \
    --name allow_http_https \
    --priority 100 \
    --source-address-prefixes Internet \
    --source-port-ranges '*' \
    --destination-address-prefixes '*' \
    --destination-port-ranges 80 443 \
    --access Allow \
    --protocol Tcp \
    --direction Inbound \
    --description "Allow from internet IP addresses on ports 80 and 443."  
```

### Assigning the new NSG to your subnet:
```
az network vnet subnet update \
    --resource-group $rgName \
    --name Subnet02 \
    --vnet-name $vnetName \
    --network-security-group nsg01
```