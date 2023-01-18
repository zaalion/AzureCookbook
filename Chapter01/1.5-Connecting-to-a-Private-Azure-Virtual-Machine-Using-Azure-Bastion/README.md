# Connecting to a Private Azure Virtual Machine Using Azure Bastion

rgName="bastion-rg"

az group create \
  --location eastus \
  --name $rgName


az vm create --name MyLinuxVM01 \
  --resource-group $rgName \
  --image UbuntuLTS \
  --admin-username linuxadmin \
  --admin-password <vm-password> \
  --authentication-type all \
  --public-ip-address "" --nsg ""


vnetName=$(az network vnet list \
  --resource-group $rgName \
  --query "[].name" -o tsv)


ipName="BastionPublicIP01"

az network public-ip create \
  --resource-group $rgName \
  --name $ipName \
  --sku Standard

az network vnet subnet create \
  --resource-group $rgName \ 
  --vnet-name $vnetName \
  --name 'AzureBastionSubnet'  \
  --address-prefixes 10.0.1.0/24 

az network bastion create \
  --location eastus \
  --name MyBastionHost01 \ 
  --public-ip-address $ipName \
  --resource-group $rgName \
  --vnet-name $vnetName


