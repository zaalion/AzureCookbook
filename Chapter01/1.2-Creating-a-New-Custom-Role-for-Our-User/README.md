# Creating a New Custom Role for Our User

### Get the subscription id
```
subscriptionId=$(az account show \
  --query "id" --output tsv)

subscriptionScope="/subscriptions/"$subscriptionId

echo $subscriptionScope
```

### Create a new custom RBAC role definition:
```
az role definition create \
  --role-definition CustomStorageDataReader.json
```

### Assign the new role definition to user account
```
MSYS_NO_PATHCONV=1 az role assignment create \
  --assignee "developer@<aad-tenant-name>" \
  --role "Custom Storage Data Reader" \
  --scope $subscriptionScope
```