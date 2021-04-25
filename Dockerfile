FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["RadiationMaker.csproj", "./"]
RUN dotnet restore "RadiationMaker.csproj"
COPY . .
WORKDIR "/src/RadiationMaker"
RUN dotnet build "RadiationMaker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "RadiationMaker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RadiationMaker.dll"]
