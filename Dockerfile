# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app
COPY . ./
RUN dotnet restore
RUN dotnet publish -c Release -o output

# Serve Stage
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/output .
ENTRYPOINT [ "dotnet", "DOCKERASPNET.API.dll" ]
