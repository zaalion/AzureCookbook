# Assigning Allowed Azure Resource Types in a Subscription

### Get the desired policy id/name:
```
policyName=$(az policy definition list \
  --query "[?displayName == 'Allowed resource types'].name" -o tsv)
```

### Get the list of available policy definitions
```
az policy definition list \
  --query "[].{Name: name, DisplayName: displayName}"
```

### Assign the policy to the subscription:
```
az policy assignment create \
  --name 'Allowed resource types in my subscription' \ 
  --enforcement-mode Default \
  --policy $policyName \
  --params allowedResourcesParams.json
```

### Delete the policy assignment
```
az policy assignment delete \
  --name 'Allowed resource types in my subscription'
```