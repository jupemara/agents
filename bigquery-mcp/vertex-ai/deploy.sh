#!/bin/bash

set -e

GOOGLE_CLOUD_LOCATION=${GOOGLE_CLOUD_LOCATION:-us-central1}

CONFIG_NAME=$(gcloud config configurations list --filter="is_active:true" --format="value(name)")
DISPLAY_NAME="${GOOGLE_CLOUD_PROJECT}-${CONFIG_NAME}"
BUCKET_NAME="${GOOGLE_CLOUD_PROJECT}-${CONFIG_NAME}"

echo "Using DISPLAY_NAME: $DISPLAY_NAME"
echo "Using BUCKET_NAME: $BUCKET_NAME"

gcloud builds submit . \
  --config=cloudbuild.yaml \
  --ignore-file=.gcloudignore \
  --project=$GOOGLE_CLOUD_PROJECT

gcloud run services replace vertex-ai/cloud-run.yaml --region=$GOOGLE_CLOUD_LOCATION --project=$GOOGLE_CLOUD_PROJECT
CLOUD_RUN_URL=$(gcloud run services describe bigquery-mcp-toolbox --region=$GOOGLE_CLOUD_LOCATION --format="value(status.url)" --project=$GOOGLE_CLOUD_PROJECT)

cat > .env << EOF
GOOGLE_CLOUD_PROJECT=$GOOGLE_CLOUD_PROJECT
GOOGLE_CLOUD_LOCATION=$GOOGLE_CLOUD_LOCATION
GOOGLE_GENAI_USE_VERTEXAI=TRUE
TOOLBOX_URL=$CLOUD_RUN_URL
EOF

cp .env ../.env

export GOOGLE_CLOUD_PROJECT="$GOOGLE_CLOUD_PROJECT"
export GOOGLE_CLOUD_LOCATION="$GOOGLE_CLOUD_LOCATION"
export GOOGLE_GENAI_USE_VERTEXAI="TRUE"
export TOOLBOX_URL="$CLOUD_RUN_URL"

adk deploy agent_engine . \
  --project="$GOOGLE_CLOUD_PROJECT" \
  --region="$GOOGLE_CLOUD_LOCATION" \
  --staging_bucket="gs://$BUCKET_NAME" \
  --display_name="$DISPLAY_NAME" \
  --trace_to_cloud
