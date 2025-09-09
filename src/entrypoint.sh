#!/bin/bash

set -euo pipefail

ARGOCD_USER=${ARGOCD_USER:-'admin'}
INSECURE_OPTIONS=${INSECURE_OPTIONS:-'--insecure'}
SYNC_OPTIONS=${SYNC_OPTIONS:-'--prune'}

APPLICATION_NAME=$(yq e '.metadata.name' "$APP_YAML_PATH")
if [ -z "$APPLICATION_NAME" ]; then
  echo "Error: Unable to extract application name from $APP_YAML_PATH"
  exit 1
fi
echo "🚀Got application: $APPLICATION_NAME"

echo "Logging in to ArgoCD server: $ARGOCD_SERVER"

argocd login $INSECURE_OPTIONS --username $ARGOCD_USER $ARGOCD_SERVER --password $ARGOCD_TOKEN
echo "🥳 Logined the ArgoCD server."

echo "Syncing application: $APPLICATION_NAME"
argocd app sync $APPLICATION_NAME $SYNC_OPTIONS

echo "Waiting for sync to complete..."
argocd app wait $APPLICATION_NAME --health-check --timeout 300

echo "Checking application status..."
argocd app get $APPLICATION_NAME

echo "🎉 Application '$APPLICATION_NAME' synced successfully."