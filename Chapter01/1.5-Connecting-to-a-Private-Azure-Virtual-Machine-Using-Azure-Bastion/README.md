# Connecting to a Private Azure Virtual Machine Using Azure Bastion

### Create a new Resource Group for Azure Bastion
```
rgName="bastion-rg"
location="<region>"

az group create \
  --location $location \
  --name $rgName
```

### Create a new Linux Azure VM
```
az vm create --name MyLinuxVM01 \
  --resource-group $rgName \
  --image UbuntuLTS \
  --vnet-address-prefix 10.0.0.0/16 \
  --admin-username linuxadmin \
  --generate-ssh-keys \
  --authentication-type ssh \
  --public-ip-address "" \
  --nsg-rule SSH \
  --nsg "MyLinuxVM01-NSG"
```

### Get new VNet name
```
vnetName=$(az network vnet list \
  --resource-group $rgName \
  --query "[].name" --output tsv)
```

### Create a new Public IP resource:
```
ipName="BastionPublicIP01"

az network public-ip create \
  --resource-group $rgName \
  --name $ipName \
  --sku Standard
```

### Create a new subnet for Azure Bastion
```
az network vnet subnet create \
  --resource-group $rgName \
  --vnet-name $vnetName \
  --name 'AzureBastionSubnet' \
  --address-prefixes 10.0.1.0/24
```

### Create the Bastion resource:
```
az network bastion create \
  --location $location \
  --name MyBastionHost01 \
  --public-ip-address $ipName \
  --resource-group $rgName \
  --vnet-name $vnetName
```
