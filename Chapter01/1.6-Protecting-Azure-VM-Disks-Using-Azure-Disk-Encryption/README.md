# Protecting Azure VM Disks Using Azure Disk Encryption

rgName="<resource-group-name>"
vmName="MyWinVM01"

az vm create \
    --resource-group $rgName \
    --name $vmName \
    --image win2016datacenter \
    --admin-username cookbookuser \
    --admin-password <vm-password>

kvName="<key-vault-name>"

az keyvault create \
  --name $kvName \
  --resource-group <resource-group-name> \
  --location eastus \
  --enabled-for-disk-encryption


az vm encryption enable \
  --resource-group <resource-group-name> \
  --name $vmName \
  --disk-encryption-keyvault $kvName


az vm encryption show \
  --name $vmName \
  --resource-group <resource-group-name>



