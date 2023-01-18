# Creating a New User in Your Azure Account


### Create a new user in your Azure Active Directory:
```
az ad user create \
  --display-name developer \
  --password P@ssw0rd6 \
  --user-principal-name developer@<aad-tenant-name>
```

### Get the subscription id:
```
subscriptionId="/subscriptions/"$(az account show --query "id" -o tsv)
```

### Create a new RBAC role assignment:
```
az role assignment create \
  --assignee "developer@<aad-tenant-name>" \
  --role "Contributor" \
  --scope $subscriptionId
```

### List the RBAC roles assigned to account:
```
az role assignment list \
  --assignee developer@<aad-tenant-name> 
```

# Cleanup

Deleting the RBAC role assignment:
```
az role assignment delete \
  --assignee "developer@<aad-tenant-name>" \
  --role "Contributor"
```