$resourceGroup = "rgIskaAKS";
$cluster = "IskaAKSCluster";
$acrName = "IskaAKSAcr";

# Maak een Azure Resource Group aan
az group create --name $resourceGroup --location westeurope

# Maak een Azure Container Registry aan & login
az acr create --resource-group $resourceGroup --name $acrName --sku Basic
az acr login --name $acrName

# Set AKS feature flag op subscription
az provider register -n Microsoft.ContainerService

# Maak het Kubernetes cluster aan
az aks create --resource-group $resourceGroup --name $cluster --node-count 1 --generate-ssh-keys

# Installeer kubectl-cli lokaal
az aks install-cli

# Download de AKS credentials
az aks get-credentials --resource-group=$resourceGroup --name=$cluster

# Toon het aantal nodes in het Kubernetes cluster
kubectl get nodes

# Maak rechten aan voor AKS om bij ACR een image te pullen
$CLIENT_ID=$(az aks show --resource-group $resourceGroup --name $cluster --query "servicePrincipalProfile.clientId" --output tsv)
$ACR_ID=$(az acr show --name $acrName --resource-group $resourceGroup --query "id" --output tsv)
az role assignment create --assignee $CLIENT_ID --role Contributor --scope $ACR_ID