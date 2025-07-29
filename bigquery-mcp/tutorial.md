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

## Step 1-3. 必要な API の有効化

(どれが本当に必要なのか戻ってから確認する)

### BigQuery API の有効化

```bash
gcloud services enable bigquery.googleapis.com
```

### Vertex AI API の有効化 ( Agent Engine 用 )

```bash
gcloud services enable aiplatform.googleapis.com
gcloud services enable generativelanguage.googleapis.com
gcloud services enable discoveryengine.googleapis.com
```

### Cloud Run API の有効化 ( デプロイ用 )

```bash
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable artifactregistry.googleapis.com
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
cd ../ && adk web --port 8080
```

### プロンプトの入力

これで local から BigQuery へ自然言語を問い合わせるための Agent ができたはずなので, このような質問をしてみてください

- BigQuery の最新機能 10 件
- 2025年5月の Vertex AI 関連リリース
- テーブル構造教えて
- 最近の DB 周りのアプデ
- どんなデータが格納されてるの??

## Step 3. Vertex AI Agent Engine へデプロイ

### 作業ディレクトリの移動

```bash
cd -
```

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
