# Creating a New Custom Role for Our User



subscriptionId="/subscriptions/"$(az account show \
  --query "id" -o tsv)

echo $subscriptionId

az role definition create \
  --role-definition CustomStorageDataReader.json

az role assignment create \
  --assignee "developer@<aad-tenant-name>" \
  --role "Custom Storage Data Reader" \
  --scope $subscriptionId

