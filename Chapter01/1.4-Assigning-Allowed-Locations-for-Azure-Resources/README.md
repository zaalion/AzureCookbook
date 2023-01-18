# Assigning Allowed Locations for Azure Resources

policyName=$(az policy definition list \
  --query "[?displayName == 'Allowed locations'].name" -o tsv)


az policy definition list \
  --query "[].{Name: name, DisplayName: displayName}"


az policy assignment create \
  --name 'Allowed regions for my resources' \ 
  --enforcement-mode Default \
  --policy $policyName \
  --params allowedLocationParams.json


az account list-locations --query "[].name"



az policy assignment delete \
  --name 'Allowed regions for my resources'