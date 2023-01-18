# Enabling Web Application Firewall (WAF) With Azure Application Gateway

rgName="<resource-group-name>"
appName="<web-app-name>"
planName=$appName"-plan"

az apprentice plan create \
  --resource-group $rgName \
  --name $planName

az webapp create \
  --resource-group $rgName \
  --plan $planName \
  --name $appName

appURL=$(az webapp show \
  --name $appName \
  --resource-group $rgName \
  --query "defaultHostName" \
  -o tsv)

vnetName="AppGWVnet"

az network vnet create \
  --resource-group $rgName \
  --name $vnetName \
  --address-prefix 10.0.0.0/16 \
  --subnet-name Default \
  --subnet-prefix 10.0.0.0/24

appGWName="<app-gateway-name>"

az network application-gateway create \
  --resource-group $rgName \
  --name $appGWName \
  --capacity 1 \
  --sku WAF_v2 \  
  --vnet-name $vnetName \
  --subnet Default \
  --servers $appURL




