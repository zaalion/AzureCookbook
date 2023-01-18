# Assigning Allowed Azure Resource Types in a Subscription

policyName=$(az policy definition list \
  --query "[?displayName == 'Allowed resource types'].name" -o tsv)


az policy definition list \
  --query "[].{Name: name, DisplayName: displayName}"


az policy assignment create \
  --name 'Allowed resource types in my subscription' \ 
  --enforcement-mode Default \
  --policy $policyName \
  --params allowedResourcesParams.json


az policy assignment delete \
  --name 'Allowed resource types in my subscription'