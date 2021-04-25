FROM mcr.microsoft.com/dotnet/runtime:5.0-alpine-x64 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine-x64 AS build
WORKDIR /src
COPY ["RadiationMaker.csproj", "./"]
RUN dotnet restore "RadiationMaker.csproj" --runtime alpine-x64
COPY . .
WORKDIR "/src/RadiationMaker"
RUN dotnet build "RadiationMaker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "RadiationMaker.csproj" -c Release -o /app/publish \
    --no-restore \
    --runtime alpine-x64 \
    --self-contained true \
    /p:PublishTrimmed=true \
    /p:PublishSingleFile=true

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RadiationMaker.dll"]
