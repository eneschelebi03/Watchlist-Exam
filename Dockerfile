#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Watchlist/Watchlist.csproj", "Watchlist/"]
COPY ["Watchlist.Data/Watchlist.Data.csproj", "Watchlist.Data/"]
RUN dotnet restore "Watchlist/Watchlist.csproj"
COPY . .
WORKDIR "/src/Watchlist"
RUN dotnet build "Watchlist.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Watchlist.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Watchlist.dll"]