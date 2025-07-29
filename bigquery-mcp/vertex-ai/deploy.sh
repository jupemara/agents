#!/bin/bash

set -e

REGION=${REGION:-us-central1}

CONFIG_NAME=$(gcloud config configurations list --filter="is_active:true" --format="value(name)")
DISPLAY_NAME="${GOOGLE_CLOUD_PROJECT}-${CONFIG_NAME}"
BUCKET_NAME="${GOOGLE_CLOUD_PROJECT}-${CONFIG_NAME}"

echo "Using DISPLAY_NAME: $DISPLAY_NAME"
echo "Using BUCKET_NAME: $BUCKET_NAME"

gcloud builds submit . --config=cloudbuild.yaml --project=$GOOGLE_CLOUD_PROJECT
gcloud run services replace vertex-ai/cloud-run.yaml --region=$REGION --project=$GOOGLE_CLOUD_PROJECT

adk deploy agent_engine . \
  --display_name="$DISPLAY_NAME" \
  --staging_bucket="gs://$BUCKET_NAME" \
  --env_file .env \
  --trace_to_cloud
