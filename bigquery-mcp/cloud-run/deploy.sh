#!/bin/bash

set -e

PROJECT_ID=$(gcloud config get-value project)
REGION=${REGION:-asia-northeast1}

gcloud builds submit . --config=cloudbuild.yaml
gcloud run services replace cloud-run/cloud-run.yaml --region=$REGION --project=$PROJECT_ID
