FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 
ARG source=./out

WORKDIR /app

COPY ${source} .
ENTRYPOINT ["dotnet", "VotingApi.dll"]