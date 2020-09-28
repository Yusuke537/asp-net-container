FROM  mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app/publish

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY . ./
RUN ls -a && \
    dotnet restore && \
    #dotnet test && \
    dotnet build -c Release -o /app/build

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ARG VERSION="0.0.0.0-local"
ARG CREATED=unknown
ENV ECHO_APP_NAME=default
ENV ASPNETCORE_URLS=http://+:80
ENV DOTNET_RUNNING_IN_CONTAINER=true

LABEL org.opencontainers.image.created="${CREATED}"
LABEL org.opencontainers.image.authors="https://github.com/asizikov"
LABEL org.opencontainers.image.source="https://github.com/asizikov/asp-net-container"
LABEL org.opencontainers.image.version="${VERSION}"

EXPOSE 80

WORKDIR /app
ENTRYPOINT ["dotnet", "Echo.Api.dll"]