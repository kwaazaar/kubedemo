docker login -u kubedemo -p =O1CicSshvxwuVlEemfphqDF8u1LZzsr kubedemo.azurecr.io
docker build . -t kubedemo.azurecr.io/kubedemo/votingapi:v2
docker push kubedemo.azurecr.io/kubedemo/votingapi:v2



