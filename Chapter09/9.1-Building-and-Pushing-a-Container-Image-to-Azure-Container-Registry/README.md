# Building and Pushing a Container Image to Azure Container Registry


### index.html
```
<html>
  <body>
    <h1>
      This page is served from a Docker container!
    </h1>
  </body>
</html>
```

### Dockerfile
```
FROM nginx:alpine
COPY . /usr/share/nginx/html
```

### Building a Docker image
```
docker build -t static-html-image -f Dockerfile .
```

### Provisioning a new Azure Container Registry (ACR)
```
rgName="<resource-group-name>"
registryName="<registry-name>"

az acr create \
  --resource-group $rgName \
  --name $registryName \
  --sku Basic \
  --admin-enabled true
```

### Grabbing the ACR login information
```
acrLoginServer=$(az acr show \
  --resource-group $rgName \
  --name $registryName \
  --query loginServer \
  -o tsv)

acrAdminUser=$(az acr credential show \
  --name $registryName \
  --query username \
  -o tsv)

acrAdminPass=$(az acr credential show \
  --name $registryName \
  --query passwords[0].value \
  -o tsv)
```

### Tagging your Docker image (creating a new version)
```
docker tag <IMAGE-ID> $acrLoginServer/static-html-image:ver1.0
```

### Logging in to ACR
```
docker login $acrLoginServer \
  --username $acrAdminUser \
  --password $acrAdminPass
```

### Pushing your tagged Docker image to Azure ACR
```
docker push $acrLoginServer/static-html-image:ver1.0
```

### listing images (repositories) in the ACR
```
az acr repository list \
  --resource-group $rgName \
  --name $registryName
```