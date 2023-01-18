# Assigning Allowed Locations for Azure Resources

### Get the policy id/name:
```
policyName=$(az policy definition list \
  --query "[?displayName == 'Allowed locations'].name" -o tsv)
```

### Assign the policy to the subscription:
```
az policy assignment create \
  --name 'Allowed regions for my resources' \ 
  --enforcement-mode Default \
  --policy $policyName \
  --params allowedLocationParams.json
```

### Get available Azure locations
```
az account list-locations --query "[].name"
```

### Delete the policy assignment
```
az policy assignment delete \
  --name 'Allowed regions for my resources'
```