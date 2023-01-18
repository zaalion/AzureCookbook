# Protecting Azure VM Disks Using Azure Disk Encryption

### Create a new Azure Virtual Machine (VM):
```
rgName="<resource-group-name>"
vmName="MyWinVM01"

az vm create \
    --resource-group $rgName \
    --name $vmName \
    --image win2016datacenter \
    --admin-username cookbookuser \
    --admin-password <vm-password>
```

### Create a new Azure Key Vault
```
kvName="<key-vault-name>"

az keyvault create \
  --name $kvName \
  --resource-group <resource-group-name> \
  --location eastus \
  --enabled-for-disk-encryption
```

### Enable Azure VM encryption:
```
az vm encryption enable \
  --resource-group <resource-group-name> \
  --name $vmName \
  --disk-encryption-keyvault $kvName
```

### Show VM encryption settings:
```
az vm encryption show \
  --name $vmName \
  --resource-group <resource-group-name>
```