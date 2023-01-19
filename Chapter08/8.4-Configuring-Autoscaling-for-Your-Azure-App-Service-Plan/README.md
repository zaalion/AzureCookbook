# Configuring Autoscaling for Your Azure App Service Plan


### Grabbing the App Service Plan is
```
appPlanId=$(az appservice plan show \
  --name $planName \
  --resource-group $rgName \
  --query id -o tsv)
```

### Creating an auto-scale rule
```
az monitor autoscale create \
  --resource-group $rgName \
  --name MyAutoScale \
  --resource $appPlanId \
  --min-count 1 \
  --max-count 4 \
  --count 2
```

### Configuring auto-scaling for App Service Plan (scale out)
```
az monitor autoscale rule create \
  --resource-group $rgName \
  --autoscale-name MyAutoScale \
  --scale out 1 \
  --condition "CpuPercentage > 60 avg 10m" \ 
  --cooldown 7
```

### Configuring auto-scaling for App Service Plan (scale in)
```
az monitor autoscale rule create \
  --resource-group $rgName \
  --autoscale-name MyAutoScale \
  --scale in 1 \
  --condition "CpuPercentage < 30 avg 5m" 
```

### Listing auto-scale rule details
```
az monitor autoscale rule list \
  --resource-group $rgName \
  --autoscale-name MyAutoScale
```