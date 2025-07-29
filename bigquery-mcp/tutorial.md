---
title: "AI Agents: ADK + MCP Toolbox with BigQuery"
description: "MCP Toolbox を用いて, ADK と BigQuery を接続した AI Agents を作成するチュートリアル"
duration: 60
level: Beginner
tags: [BigQuery, MCP, AI Agents, Python, "MCP Toolbox", "genai-toolbox"]
---

# AI Agents: ADK + MCP Toolbox with BigQuery

MCP Toolbox を用いて, ADK と BigQuery を接続した AI Agents を作成するチュートリアルです.

## Step 1. Google アカウント認証とプロジェクトの設定

- Google アカウント認証
- プロジェクトの設定
- 必要な API の有効化

## Step 1-1. Google アカウント認証

認証しているかどうかアカウントの確認です

```bash
gcloud auth list
```

認証済みアカウントが正しくコンフィグに設定されているか確認します

```bash
gcloud config get-value account
```

もし

```
Credentialed Accounts

ACTIVE: *
ACCOUNT: hogehoge@example.com
```

のようにログイン済みのアカウントがうまく出ていない場合は,

```bash
gcloud auth application-default login --no-launch-browser
```

を実行してログインを行います (ログイン URL が出てくるので, URL をクリック, verification code を入力しましょう)

## Step 1-2. プロジェクトの設定

### プロジェクト ID の設定

```bash
gcloud config set project PLEASE_SPECIFY_YOUR_PROJECT_ID
```

### 正しく設定されているか確認

```bash
gcloud config get-value project
```

後ほど使用するので project id を環境変数に設定

```bash
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)
```

ついでにデフォの location も後ほど使用するので設定

```bash
export GOOGLE_CLOUD_LOCATION=us-central1
```

## Step 1-3. 必要な API の有効化

今回利用する API の一覧です

```bash
gcloud services enable bigquery.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable aiplatform.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable discoveryengine.googleapis.com
```

### Cloud Build 用サービスアカウント権限の設定

デプロイに使用するサービスアカウントに編集者権限を付与

```bash
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
    --member="serviceAccount:$(gcloud projects describe $GOOGLE_CLOUD_PROJECT \
    --format="value(projectNumber)")-compute@developer.gserviceaccount.com" \
    --role="roles/editor"
```


## Step 2. ローカル環境で Agent を動かしてみる

### Python のセットアップ

お行儀よく venv します

```bash
python -m venv .venv
```

```bash
source .venv/bin/activate
```

### Python 依存関係のインストール

必要な Python 依存関係をインストールします

```bash
pip install -r requirements.txt
```

## Step 2. ローカル環境で Agent を動かしてみる

### MCP Toolbox のダウンロード

```bash
curl -O https://storage.googleapis.com/genai-toolbox/v0.9.0/linux/amd64/toolbox && chmod +x toolbox
```

### Toolbox のコンフィグファイルの編集 ( tools.yaml )

プロジェクト ID を `tools.yaml` に設定する必要があるのでエディタで編集するか, コマンドラインで編集します (以下のいずれかを行います)

#### by editor

```bash
cloudshell edit tools.yaml
```

#### by CLI

```bash
sed -i "s/project: PLEASE_SPECIFY_YOUR_PROJECT_ID/project: $GOOGLE_CLOUD_PROJECT/" tools.yaml
```

## Step 2. ローカル環境で Agent を動かしてみる

### toolbox の起動

```bash
./toolbox --tools-file tools.yaml --address 127.0.0.1 --port 5000 &
```

### CLI AI Agents の起動

```bash
adk run .
```

- "どんなことができますか??" とか聞いてみてください

### web ブラウザを使って起動

```bash
adk web ../ --port 8080
```

### プロンプトの入力

これで local から BigQuery へ自然言語を問い合わせるための Agent ができたはずなので, このような質問をしてみてください

- BigQuery の最新機能 10 件
- 2025年5月の Vertex AI 関連リリース
- テーブル構造教えて
- 最近の DB 周りのアプデ
- どんなデータが格納されてるの??

## Step 3. Vertex AI Agent Engine へデプロイ

### デプロイ用設定ファイルの編集

デプロイ用の設定ファイルを現在利用中の Project ID で置換します。

#### by editor

```bash
cloudshell edit cloudbuild.yaml
```

```bash
cloudshell edit vertex-ai/cloud-run.yaml
```

#### by cli

```bash
sed -i "s/PLEASE_SPECIFY_YOUR_PROJECT_ID/$GOOGLE_CLOUD_PROJECT/g" cloudbuild.yaml
```

```bash
sed -i "s/PLEASE_SPECIFY_YOUR_PROJECT_ID/$GOOGLE_CLOUD_PROJECT/g" vertex-ai/cloud-run.yaml
```

### deploy to Vertex AI Agent Engine

```bash
./vertex-ai/deploy.sh
```

## Step 4. Vertex AI Agent Engine を ADK から呼び出す

Agent Engine の ID ( `reasoningEngine` ) をコピーしておく

```bash
cloudshell open-url https://console.cloud.google.com/vertex-ai/agents/agent-engines
```

```bash
export AGENT_ENGINE_REASONING_ENGINE_ID=xxxxxxxxxxxxxxxxxxx
```

`--session_service_uri` を使って, Agent Engine にデプロイした Agent を起動する

```bash
adk web ../ --session_service_uri "agentengine://${AGENT_ENGINE_REASONING_ENGINE_ID}"
```

## Step 5. Vertex AI Agent Engine の Agent を Agentspace とリンクさせる

### 必要な変数の設定

```bash
# プロジェクト番号を取得（重要：プロジェクトIDではなく番号）
PROJECT_NUMBER=$(gcloud projects describe $GOOGLE_CLOUD_PROJECT --format="value(projectNumber)")

# Agentspace のアプリID（事前に作成された値）
export AGENTSPACE_APP_ID="your-agentspace-app-id"
```

### Agent を Agentspace に登録

```bash
curl -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  -H "X-Goog-User-Project: $GOOGLE_CLOUD_PROJECT" \
  "https://discoveryengine.googleapis.com/v1alpha/projects/$GOOGLE_CLOUD_PROJECT/locations/global/collections/default_collection/engines/PLEASE_SPECIFY_YOUR_AGENTSPACE_APP_ID/assistants/default_assistant/agents" \
  -d "{
    \"displayName\": \"bigquery-mcp\",
    \"description\": \"BigQuery + Google Cloud Release\",
    \"adk_agent_definition\": {
      \"tool_settings\": {
        \"tool_description\": \"BigQuery を MCP Tools 化してみた\"
      },
      \"provisioned_reasoning_engine\": {
        \"reasoning_engine\": \"projects/$GOOGLE_CLOUD_PROJECT/locations/$GOOGLE_CLOUD_LOCATION/reasoningEngines/$AGENT_ENGINE_REASONING_ENGINE_ID\"
      }
    }
  }"
```
