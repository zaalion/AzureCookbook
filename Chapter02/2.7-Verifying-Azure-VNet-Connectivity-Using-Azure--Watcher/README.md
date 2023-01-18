# Verifying Azure VNet Connectivity Using Azure Network Watcher


### Creating a new Azure VNet
```
rgName="<resource-group-name>"

az network vnet create \
    --resource-group $rgName \
    --name VNet03 \
    --address-prefix 10.0.0.0/16 \
    --subnet-name VMSubnet \
    --subnet-prefix 10.0.0.0/26
```

### Creating a new Azure VM
```
az vm create \
    --resource-group $rgName \
    --name vm001 \
    --image win2016datacenter \
    --vnet-name VNet03 \
    --subnet VMSubnet \
    --public-ip-sku Standard \
    --admin-username cookbookuser \
    --admin-password <vm-password>
```

### Installing the Network Watcher agent on the VM
```
az vm extension set \
    --name NetworkWatcherAgentWindows \
    --version 1.4.2331.0 \
    --resource-group $rgName \
    --vm-name vm001 \
    --publisher Microsoft.Azure.NetworkWatcher
```

### Testing connectivity from the VM to a public IP address using Network Watcher
```
az network watcher test-connectivity \
    --resource-group $rgName \
    --source-resource vm001 \
    --dest-address 13.107.21.200 \
    --dest-port 80  \
    --query "connectionStatus"
```

### Deleting the VM
```
az vm delete \
    --resource-group $rgName \
    --name vm001 \
    --yes 
```