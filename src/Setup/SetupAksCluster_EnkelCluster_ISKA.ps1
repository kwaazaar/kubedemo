$resourceGroup = "rgIskaAKS";
$cluster = "IskaAKSCluster";

# Maak het Kubernetes cluster aan
az aks create --resource-group $resourceGroup --name $cluster --node-count 1 --generate-ssh-keys

# Download de AKS credentials
az aks get-credentials --resource-group=$resourceGroup --name=$cluster

# Toon het aantal nodes in het Kubernetes cluster
kubectl get nodes

# Maak rechten aan voor AKS om bij ACR een image te pullen
# $CLIENT_ID=$(az aks show --resource-group $resourceGroup --name $cluster --query "servicePrincipalProfile.clientId" --output tsv)
# $ACR_ID=$(az acr show --name $acrName --resource-group $resourceGroup --query "id" --output tsv)
# az role assignment create --assignee $CLIENT_ID --role Contributor --scope $ACR_ID

# Deploy de nodes
kubectl apply -f votingapi.iskaaks.deploy.yml

# Maak een proxy aan om bij het Kubernetes dashboard te komen
az aks browse --resource-group $resourceGroup --name $cluster