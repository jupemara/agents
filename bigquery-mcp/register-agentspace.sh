#!/bin/bash

PROJECT_NUMBER=$(gcloud projects describe $GOOGLE_CLOUD_PROJECT --format="value(projectNumber)")

curl -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  -H "X-Goog-User-Project: $GOOGLE_CLOUD_PROJECT" \
  "https://discoveryengine.googleapis.com/v1alpha/projects/$PROJECT_NUMBER/locations/global/collections/default_collection/engines/$AGENTSPACE_APP_ID/assistants/default_assistant/agents" \
  -d "{
    \"displayName\": \"bigquery-mcp\",
    \"description\": \"BigQuery public data as AI Agent\",
    \"adk_agent_definition\": {
      \"tool_settings\": {
        \"tool_description\": \"BigQuery + MCP Toolbox + ADK\"
      },
      \"provisioned_reasoning_engine\": {
        \"reasoning_engine\": \"projects/$PROJECT_NUMBER/locations/$GOOGLE_CLOUD_LOCATION/reasoningEngines/$AGENT_ENGINE_REASONING_ENGINE_ID\"
      }
    }
  }"
