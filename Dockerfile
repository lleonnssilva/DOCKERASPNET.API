
##See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.
#
#FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
#WORKDIR /app
#EXPOSE 80
#
#FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
#ARG BUILD_CONFIGURATION=Release
#WORKDIR /src
#COPY ["DOCKERASPNET.API.csproj", "."]
#RUN dotnet restore "./DOCKERASPNET.API.csproj"
#COPY . .
#WORKDIR "/src/."
#RUN dotnet build "./DOCKERASPNET.API.csproj" -c $BUILD_CONFIGURATION -o /app/build
#
#FROM build AS publish
#ARG BUILD_CONFIGURATION=Release
#RUN dotnet publish "./DOCKERASPNET.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false
#
#FROM base AS final
#WORKDIR /app
#COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "DOCKERASPNET.API.dll"]
# Usar a imagem base do .NET SDK

# Usar a imagem base do .NET SDK
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

# Usar a imagem base do .NET SDK para build
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["./DOCKERASPNET.API.csproj", "."]
RUN dotnet restore "./DOCKERASPNET.API.csproj"
COPY . .
WORKDIR "/src/DOCKERASPNET.API"
RUN dotnet build "./DOCKERASPNET.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "./DOCKERASPNET.API.csproj" -c Release -o /app/publish

# Imagem final
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DOCKERASPNET.API.dll"]
