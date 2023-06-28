# Controlling Azure Storage Account Network Access


### Provisioning a new Azure Storage Account
```
storageName="<storage-account-name>"

az storage account create \
    --name $storageName \
    --resource-group $rgName \
    --location $region \
    --sku Standard_LRS \
    --default-action Deny \
    --public-network-access Enabled
```

### Creating a new Azure VNet
```
az network vnet create \
    --resource-group $rgName \
    --name VNet01 \
    --address-prefix 10.0.0.0/16 \
    --subnet-name Subnet01 \
    --subnet-prefix 10.0.0.0/26
```

### Enabling the Storage service endpoint on the subnet
```
az network vnet subnet update \
    --resource-group $rgName \
    --vnet-name VNet01 \
    --name Subnet01 \
    --service-endpoints "Microsoft.Storage"
```

### Configuring Storage Account firewall by allowing traffic from VNet01
```
az storage account network-rule add \
    --resource-group $rgName \
    --account-name $storageName \
    --vnet-name VNet01 \
    --subnet Subnet01 \
    --action Allow
```

### Listing network rules for an Azure Storage Account
```
az storage account network-rule list \
    --account-name $storageName \
    --resource-group $rgName
```

### Clean up
```
az group delete --name $rgName
```