# Protecting Azure Container Registry By Limiting Public Network Access


### Upgrading the ACR to the Premium tier
```
rgName="<resource-group-name>"
registryName="<acr-name>"

az acr update \
  --name $registryName \
  --resource-group $rgName \
  --sku Premium
```

### Grabbing the ACR resource id
```
acrId=$(az acr show \
  --name $registryName \
  --resource-group $rgName \
  --query id \
  -o tsv)
```

### Disabling public network access in ACR
```
az acr update \
  --name $registryName \
  --resource-group $rgName \
  --public-network-enabled false
```

### Creating a user-assigned identity
```
aciIdentityName="<identity-name>"

az identity create \
  --resource-group $rgName \
  --name $aciIdentityName
```

### Grabbing the identity id and identity principal object id
```
identityId=$(az identity show \
  --resource-group $rgName \
  --name $aciIdentityName \
  --query id \
  --output tsv)

identitySpId=$(az identity show \
  --resource-group $rgName \
  --name $aciIdentityName \
  --query principalId \
  --output tsv)
```

### Granting acrPull access over ACR 
```
acrId=$(az acr show \
  --name $registryName \
  --resource-group $rgName \
  --query id \
  -o tsv)

az role assignment create \
  --assignee $identitySpId \
  --scope $acrId \
  --role acrpull
```

### Updating the ACR resource to allow trusted resources
```
az acr update \
  --name $registryName \
  --resource-group $rgName \
  --allow-trusted-services true
```

### Creating a new trusted Azure Container Instances resource
```
aciName="<container-instance-name>"

az container create \
  --name $aciName \
  --resource-group $rgName \
  --image $acrLoginServer/static-html-image:ver1.0 \
  --cpu 2 \
  --memory 2 \
  --assign-identity $identityId \
  --acr-identity $identityId \  
  --ip-address Public \
  --ports 80 443
```

### Grabbing the container URL
```
aciIP=$(az container show \
  --name $aciName \
  --resource-group $rgName \
  --query ipAddress.ip \
  -o tsv)

aciURL="http://"$aciIP"/index.html"

echo $aciURL
```