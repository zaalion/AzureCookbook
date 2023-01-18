# Creating a New Custom Role for Our User

### Get the subscription id
```
subscriptionId="/subscriptions/"$(az account show \
  --query "id" -o tsv)

echo $subscriptionId
```

### Create a new custom RBAC role definition:
```
az role definition create \
  --role-definition CustomStorageDataReader.json
```

### Assign the new role definition to user account
```
az role assignment create \
  --assignee "developer@<aad-tenant-name>" \
  --role "Custom Storage Data Reader" \
  --scope $subscriptionId
```