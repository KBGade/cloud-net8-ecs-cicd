# Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ./src/WeatherApi/*.csproj ./src/WeatherApi/
RUN dotnet restore ./src/WeatherApi/WeatherApi.csproj
COPY ./src/WeatherApi/ ./src/WeatherApi/
RUN dotnet publish ./src/WeatherApi/WeatherApi.csproj -c Release -o /app/publish /p:UseAppHost=false

# Run
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENTRYPOINT ["dotnet","WeatherApi.dll"]
