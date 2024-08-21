<<<<<<< HEAD
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
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
=======
FROM mcr.microsoft.com/dotnet/runtime-deps:7.0-alpine AS base
>>>>>>> 0d437451e93e82db327d27fc7659e632f3654662
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build
ARG TARGETARCH
ARG BUILDPLATFORM

<<<<<<< HEAD
# Usar a imagem base do .NET SDK para build
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
=======
>>>>>>> 0d437451e93e82db327d27fc7659e632f3654662
WORKDIR /src
COPY ["DOCKERASPNET.API/DOCKERASPNET.API.csproj", "DOCKERASPNET.API/"]
RUN dotnet restore "DOCKERASPNET.API/DOCKERASPNET.API.csproj"
COPY . .
WORKDIR "/src/DOCKERASPNET.API"
<<<<<<< HEAD
RUN dotnet build "DOCKERASPNET.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DOCKERASPNET.API.csproj" -c Release -o /app/publish

# Imagem final
FROM base AS final
=======
RUN dotnet build "DOCKERASPNET.API.csproj" -c Release -o /app/build -a $TARGETARCH

FROM build AS publish
RUN dotnet publish "DOCKERASPNET.API.csproj" -c Release -o /app/publish \
    #--runtime alpine-x64 \
    --self-contained true \
    /p:PublishTrimmed=true \
    /p:PublishSingleFile=true \
    -a $TARGETARCH

FROM --platform=$BUILDPLATFORM base AS final
ARG TARGETARCH
ARG BUILDPLATFORM

# create a new user and change directory ownership
RUN adduser --disabled-password \
  --home /app \
  --gecos '' dotnetuser && chown -R dotnetuser /app

# impersonate into the new user
USER dotnetuser
>>>>>>> 0d437451e93e82db327d27fc7659e632f3654662
WORKDIR /app

COPY --from=publish /app/publish .
<<<<<<< HEAD
ENTRYPOINT ["dotnet", "DOCKERASPNET.API.dll"]
=======
ENTRYPOINT ["./DOCKERASPNET.API"]
>>>>>>> 0d437451e93e82db327d27fc7659e632f3654662
