#!/bin/bash

set -e

REGION=${REGION:-us-central1}

CONFIG_NAME=$(gcloud config configurations list --filter="is_active:true" --format="value(name)")
DISPLAY_NAME="${GOOGLE_CLOUD_PROJECT}-${CONFIG_NAME}"
BUCKET_NAME="${GOOGLE_CLOUD_PROJECT}-${CONFIG_NAME}"

echo "Using DISPLAY_NAME: $DISPLAY_NAME"
echo "Using BUCKET_NAME: $BUCKET_NAME"

gcloud builds submit . --config=cloudbuild.yaml --ignore-file=.gcloudignore --project=$GOOGLE_CLOUD_PROJECT
gcloud run services replace vertex-ai/cloud-run.yaml --region=$REGION --project=$GOOGLE_CLOUD_PROJECT

CLOUD_RUN_URL=$(gcloud run services describe bigquery-mcp-toolbox --region=$REGION --format="value(status.url)" --project=$GOOGLE_CLOUD_PROJECT)
echo "TOOLBOX_URL=$CLOUD_RUN_URL" >> .env

adk deploy agent_engine . \
  --project="$GOOGLE_CLOUD_PROJECT" \
  --region="$REGION" \
  --staging_bucket="gs://$BUCKET_NAME" \
  --display_name="$DISPLAY_NAME" \
  --adk_app agent.py \
  --env_file .env \
  --trace_to_cloud
