# Creating a New User in Your Azure Account


### Create a new user in your Azure Active Directory:
```
password="<password>"

az ad user create \
  --display-name developer \
  --password $password \
  --user-principal-name developer@<aad-tenant-name>
```

### Get the subscription id:
```
subscriptionId=$(az account show \
  --query "id" --output tsv)

subscriptionScope="/subscriptions/"$subscriptionId
```

### Create a new RBAC role assignment:
```
MSYS_NO_PATHCONV=1 az role assignment create \
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