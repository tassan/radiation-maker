FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS publish
WORKDIR /src
COPY RadiationMaker.csproj ./

RUN dotnet restore "./RadiationMaker.csproj" --runtime alpine-x64
COPY . .
RUN dotnet publish "RadiationMaker.csproj" -c Release -o /app/publish \
  --no-restore \
  --runtime alpine-x64 \
  --self-contained true \
  /p:PublishTrimmed=true \
  /p:PublishSingleFile=true
  
FROM mcr.microsoft.com/dotnet/runtime:5.0-alpine AS final

RUN adduser --disabled-password \
  --home /app \
  --gecos '' dotnetuser && chown -R dotnetuser /app

RUN apk upgrade musl

USER dotnetuser
WORKDIR /app
EXPOSE 6388
COPY --from=publish /app/publish .

ENTRYPOINT ["./RadiationMaker", "--urls", "http://localhost:6388"]
