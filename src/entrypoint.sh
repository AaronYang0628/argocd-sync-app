#!/bin/bash

set -euo pipefail

ARGOCD_USER=${ARGOCD_USER:-'admin'}
INSECURE_OPTIONS=${INSECURE_OPTIONS:-'--insecure'}
SYNC_OPTIONS=${SYNC_OPTIONS:-'--prune --force'}

if [[ "$SYNC_OPTIONS" != *"--force"* ]]; then
  SYNC_OPTIONS="$SYNC_OPTIONS --force"
fi

echo "📋 Step 1: Reading application configuration..."
APPLICATION_NAME=$(yq e '.metadata.name' "$APP_YAML_PATH")
if [ -z "$APPLICATION_NAME" ]; then
  echo "❌ Error: Unable to extract application name from $APP_YAML_PATH"
  exit 1
fi
echo "✅ Found application name: $APPLICATION_NAME"

echo "📋 Step 2: Authenticating with ArgoCD..."
echo "→ Connecting to server: $ARGOCD_SERVER"
argocd login $INSECURE_OPTIONS --username $ARGOCD_USER $ARGOCD_SERVER --password $ARGOCD_TOKEN
echo "✅ Successfully authenticated with ArgoCD"

echo "📋 Step 3: Creating/Updating application..."
echo "→ Processing manifest: $APP_YAML_PATH"
argocd app create --upsert $APPLICATION_NAME --file $APP_YAML_PATH
echo "✅ Application configuration applied"

echo "📋 Step 4: Syncing application..."
echo "→ Syncing with options: $SYNC_OPTIONS"

MAX_RETRIES=3
RETRY_COUNT=0
SYNC_SUCCESS=false

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if argocd app sync $APPLICATION_NAME $SYNC_OPTIONS; then
        SYNC_SUCCESS=true
        break
    else
        RETRY_COUNT=$((RETRY_COUNT + 1))
        if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
            echo "⚠️ Sync failed, retrying in 5 seconds... (Attempt $RETRY_COUNT of $MAX_RETRIES)"
            sleep 5
        fi
    fi
done

if [ "$SYNC_SUCCESS" = true ]; then
    echo "✅ Application sync completed successfully"
else
    echo "❌ Failed to sync application after $MAX_RETRIES attempts"
    exit 1
fi
