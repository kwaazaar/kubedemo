$acrName = "IskaAKSAcr";

#Login bij ACR
az acr login --name $acrName

cd VotingApi

#Maak een nieuwe docker image
docker build -t iskaaksacr.azurecr.io/kubedemoaks-votingapi:latest .

#Push image naar ACR
docker push iskaaksacr.azurecr.io/kubedemoaks-votingapi:latest

cd ..

kubectl apply -f votingapi.iskaaks.deploy.yml