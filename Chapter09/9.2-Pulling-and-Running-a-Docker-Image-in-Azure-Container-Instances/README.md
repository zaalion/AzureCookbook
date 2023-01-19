# Pulling and Running a Docker Image in Azure Container Instances


### Provisioning an Azure Container Instances resource
```
aciName="<aci-name>"

az container create \
  --resource-group $rgName \
  --name $aciName \
  --image $acrLoginServer/static-html-image:ver1.0 \
  --cpu 2 \
  --memory 2 \
  --registry-username $acrAdminUser \
  --registry-password $acrAdminPass \
  --ip-address Public \
  --ports 80 443
```

### Grabbing the Container IP/URL
```
aciIP=$(az container show \
  --name $aciName \
  --resource-group $rgName \
  --query ipAddress.ip \
  -o tsv)

aciURL="http://"$aciIP"/index.html"

echo $aciURL

```