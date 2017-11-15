# Sample from: https://github.com/dotnet/dotnet-docker-samples/blob/master/dotnetapp-prod/Dockerfile
FROM microsoft/dotnet:2.0-sdk AS build-env
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# build runtime image
FROM microsoft/aspnetcore:latest 
WORKDIR /app
COPY --from=build-env /app/out ./
ENTRYPOINT ["dotnet", "VotingApi.dll"]