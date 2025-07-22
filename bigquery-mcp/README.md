# BigQuery MCP Agent

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.png)](https://ssh.cloud.google.com/cloudshell/open?cloudshell_git_repo=https://github.com/jupemara/agents&cloudshell_tutorial=tutorial.md&cloudshell_workspace=bigquery-mcp&cloudshell_git_branch=main&cloudshell_open_in_editor=hands-on.md)

Google Cloud リリースノート検索のADKエージェント実装

- [MCP Toolbox](https://github.com/googleapis/genai-toolbox)を経由
- BigQueryの公開データセット `bigquery-public-data.google_cloud_release_notes.release_notes` を利用

## 機能概要

- **製品別リリース検索**: BigQuery、Cloud SQL、AI/ML等の特定製品のリリース情報
- **期間指定検索**: 特定期間内のリリース情報の取得
- **機能別分析**: 新機能、改善、バグ修正等の種類別分析
- **最新情報取得**: 最新のGoogle Cloudリリース情報の要約

## インストール・セットアップ

- `python 3.9`

### 1. 依存関係のインストール

```bash
$ pip install -r requirements.txt
```

### 2. 必要なAPI有効化

```bash
$ gcloud services enable bigquery.googleapis.com
```

### 3. MCP Toolbox セットアップ

```bash
export VERSION=0.9.0
# linix
$ curl -O https://storage.googleapis.com/genai-toolbox/v$VERSION/linux/amd64/toolbox
# mac
$ curl -O https://storage.googleapis.com/genai-toolbox/v$VERSION/darwin/arm64/toolbox
# win
$ curl -O https://storage.googleapis.com/genai-toolbox/v$VERSION/windows/amd64/toolbox
$ chmod +x toolbox

# Toolbox起動
$ ./toolbox --tools-file tools.yaml --address 127.0.0.1 --port 5000
```

### 4. 環境変数設定

```zsh
# or .env ファイルを作成
$ export GOOGLE_GENAI_USE_VERTEXAI=TRUE
$ export GOOGLE_CLOUD_PROJECT=$(gcloud config get project)
$ export GOOGLE_CLOUD_LOCATION=us-central1
```

## 使用方法

### 基本実行

```zsh
# 先に toolbox を立ち上げておく
$ ./toolbox --tools-file tools.yaml --address 127.0.0.1 --port 5000
# terminal 上で実行するなら
$ adk run .
# web を起動するなら
$ adk web
```

## deploy to Cloud Run

```zsh
$ ./cloud-run/deploy.sh
```
