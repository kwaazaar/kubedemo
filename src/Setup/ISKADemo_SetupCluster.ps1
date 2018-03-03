# 0. Voorbereidingen: 
# 0.1 Voer deze variables uit;
# rgIskaAKS = "rgIskaAKS";
# IskaAKSCluster = "IskaAKSCluster";
# 0.2 Zorg ervoor dat er geen kubernetes cluster uitgerold is
# 0.3 Zorg ervoor dat de subscription correct is ingesteld
az account set --subscription 8ca2a0e2-44f1-4bbf-8b9d-b2e466eac74c
# 0.4 Zorg ervoor dat powershell is gestart (geen Powershell Integrated)
# 0.5 Zorg ervoor dat votingapi.iskaaks.deploy.yml klaar (open) staat
# 0.6 Maak het Kubernetes cluster aan
az aks create --resource-group rgIskaAKS --name IskaAKSCluster --node-count 2 --generate-ssh-keys
# 0.7 Start de azure portal op (in edge oid)

# 1. Vertel dat het commando hierboven het AKS cluster heeft aangemaakt (uitgevoerd omdat het > 5 minuten duurt)

# 2. Toon LoadBalancer in votingapi.iskaaks.deploy.yml

# 3. Zodra aanmaken Kubernets cluster klaar is; 
# 3.1 Download de AKS credentials
az aks get-credentials --resource-group=rgIskaAKS --name=IskaAKSCluster
# 3.2 Toon het aantal nodes in het Kubernetes cluster
# 3.2.1 (Indien deze acties mis gaat (loggin mislukt, verwijderd .kube\config))
kubectl get nodes

# 4. Toon de nodes in de azure portal

# 5. Maakt een deployment set aan zodat de containers gestart kunnen worden
kubectl create -f votingapi.iskaaks.deploy.yml

# 6.1 Maak een proxy aan om bij het Kubernetes dashboard te komen
az aks browse --resource-group rgIskaAKS --name IskaAKSCluster
# 6.2 Toon de features van het dashboard:
# - Deployments - schalen
# - Een work actie uitvoeren    