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

# Installeer kubectl-cli lokaal
az aks install-cli

# Maak het cluster daadwerkelijk aan
.\Setup\SetupAksCluster_EnkelCluster_ISKA.ps1
# # Maak het Kubernetes cluster aan
# az aks create --resource-group $resourceGroup --name $cluster --node-count 1 --generate-ssh-keys
# # Download de AKS credentials
# az aks get-credentials --resource-group=$resourceGroup --name=$cluster
# # Toon het aantal nodes in het Kubernetes cluster
# kubectl get nodes