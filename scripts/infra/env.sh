#!/usr/bin/env bash
##############################################################################
# Usage: source env.sh
# Set all environment variables needed for the project.
##############################################################################
# Dependencies: Azure CLI
##############################################################################

echo "Exporting environment variables..." 

export PROJECT="java-runtimes"
export RESOURCE_GROUP="rg-$PROJECT"
export LOCATION="eastus"
export TAG="$PROJECT"

export LOG_ANALYTICS_WORKSPACE="log-$PROJECT"
export CONTAINERAPPS_ENVIRONMENT="cae-$PROJECT"

export UNIQUE_IDENTIFIER=${UNIQUE_IDENTIFIER:-${GITHUB_USER:-$(whoami)}}

echo "Using unique identifier is: $UNIQUE_IDENTIFIER"
echo "You can override it by setting it manually before running this script:"
echo "export UNIQUE_IDENTIFIER=<your-unique-identifier>"

export REGISTRY="crjavaruntimes${UNIQUE_IDENTIFIER}"
export IMAGES_TAG="1.0"

export POSTGRES_DB_ADMIN="javaruntimesadmin"
export POSTGRES_DB_PWD="java-runtimes-p#ssw0rd-12046"
export POSTGRES_DB_VERSION="14"
export POSTGRES_SKU="Standard_B1ms"
export POSTGRES_TIER="Burstable"
export POSTGRES_DB="psql-stats-$UNIQUE_IDENTIFIER"
export POSTGRES_DB_SCHEMA="stats"
export POSTGRES_DB_CONNECT_STRING="jdbc:postgresql://${POSTGRES_DB}.postgres.database.azure.com:5432/${POSTGRES_DB_SCHEMA}?ssl=true&sslmode=require"

export QUARKUS_APP="quarkus-app"
export MICRONAUT_APP="micronaut-app"
export SPRING_APP="springboot-app"

export LOG_ANALYTICS_WORKSPACE_CLIENT_ID=$(az monitor log-analytics workspace show  \
  --resource-group "$RESOURCE_GROUP" \
  --workspace-name "$LOG_ANALYTICS_WORKSPACE" \
  --query customerId  \
  --output tsv \
  2>/dev/null | tr -d '[:space:]' \
)

export LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET=$(az monitor log-analytics workspace get-shared-keys \
  --resource-group "$RESOURCE_GROUP" \
  --workspace-name "$LOG_ANALYTICS_WORKSPACE" \
  --query primarySharedKey \
  --output tsv \
  2>/dev/null | tr -d '[:space:]' \
)

export REGISTRY_URL=$(az acr show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$REGISTRY" \
  --query "loginServer" \
  --output tsv \
  2>/dev/null \
)

export QUARKUS_HOST=$(
  az containerapp show \
    --name "$QUARKUS_APP" \
    --resource-group "$RESOURCE_GROUP" \
    --query "properties.configuration.ingress.fqdn" \
    --output tsv \
    2>/dev/null \
)

export MICRONAUT_HOST=$(
  az containerapp show \
    --name "$MICRONAUT_APP" \
    --resource-group "$RESOURCE_GROUP" \
    --query "properties.configuration.ingress.fqdn" \
    --output tsv \
    2>/dev/null \
)

export SPRING_HOST=$(
  az containerapp show \
    --name "$SPRING_APP" \
    --resource-group "$RESOURCE_GROUP" \
    --query "properties.configuration.ingress.fqdn" \
    --output tsv \
    2>/dev/null \
)

echo "Exported environment variables for project '${PROJECT}'."
