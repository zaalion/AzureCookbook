# Managing Azure Resource Tags


### Creating a Storage Account and an Azure VNet
```
rgName="<resource-group-name>"
location="<region>"

vnetName="<vnet-name>"
az network vnet create \
    --location $location \
    --resource-group $rgName \
    --name $vnetName \
    --address-prefix 10.0.0.0/16 \
    --subnet-name Subnet01 \
    --subnet-prefix 10.0.0.0/26

storageName="<storage-account-name>"
az storage account create \
   --name $storageName \
   --resource-group $rgName \
   --location $location \
   --sku Standard_LRS
```

### Grabbing the resource IDs
```
storageId=$(az storage account show \
    --resource-group $rgName \
    --name $storageName \
    --query "id" \
    -o tsv)

vnetId=$(az network vnet show \
    --resource-group $rgName \
    --name $vnetName \
    --query "id" \
    -o tsv)

echo $storageId

echo $vnetId
```

### Adding tags to the VNet
```
az tag create \
    --resource-id $vnetId \
    --tags Department=Finance Project=TravelPortal
```

### Adding tags to the Storage Account
```
az tag create \
    --resource-id $storageId \
    --tags Department=Finance Project=TravelPortal
```

### Listing tags for a resource (VNet)
```
az tag list \
    --resource-id $vnetId
```

### List all resources with a specific tag value
```
az resource list \
    --tag Project=TravelPortal \
    --query [].name
```

### Removing a tag
```
az tag update --resource-id $vnetId \
    --operation Delete \
    --tags Project=TravelPortal
```

### Confirming the removed tag
```
az resource list \
    --tag Project=TravelPortal \
    --query [].name
```