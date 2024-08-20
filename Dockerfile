FROM mcr.microsoft.com/dotnet/runtime-deps:7.0-alpine AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build
ARG TARGETARCH
ARG BUILDPLATFORM

WORKDIR /src
COPY ["DOCKERASPNET.API/DOCKERASPNET.API.csproj", "DOCKERASPNET.API/"]
RUN dotnet restore "DOCKERASPNET.API/DOCKERASPNET.API.csproj"
COPY . .
WORKDIR "/src/DOCKERASPNET.API"
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
WORKDIR /app

COPY --from=publish /app/publish .
ENTRYPOINT ["./DOCKERASPNET.API"]
