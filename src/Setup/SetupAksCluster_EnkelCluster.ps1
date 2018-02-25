$resourceGroup = "rgIskaAKS";
$cluster = "IskaAKSCluster";

# Maak het Kubernetes cluster aan
az aks create --resource-group $resourceGroup --name $cluster --node-count 1 --generate-ssh-keys

# Download de AKS credentials
az aks get-credentials --resource-group=$resourceGroup --name=$cluster

# Toon het aantal nodes in het Kubernetes cluster
kubectl get nodes