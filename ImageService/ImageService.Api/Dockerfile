FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY ["ImageService.Api/ImageService.Api.csproj", "ImageService.Api/"]
RUN dotnet restore "ImageService.Api/ImageService.Api.csproj"

COPY . .
WORKDIR "/src/ImageService.Api"
RUN dotnet publish "ImageService.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "ImageService.Api.dll"]
