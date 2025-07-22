#!/bin/bash

set -e

PROJECT_ID=$(gcloud config get-value project)
REGION=${REGION:-asia-northeast1}

gcloud builds submit . --config=cloudbuild.yaml --project=$PROJECT_ID
gcloud run services replace vertex-ai/cloud-run.yaml --region=$REGION --project=$PROJECT_ID

adk deploy agent_engine . \
  --display_name=PLEASE_SPECIFY_AGENT_DISPLAY_NAME \
  --staging_bucket="gs://PLEASE_SPECIFY_STAGING_BUCKET" \
  --env_file .env
