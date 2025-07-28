---
title: "AI Agents: ADK + MCP Toolbox with BigQuery"
description: "MCP Toolbox を用いて, ADK と BigQuery を接続した AI Agents を作成するチュートリアル"
duration: 60
level: Beginner
tags: [BigQuery, MCP, AI Agents, Python, "MCP Toolbox", "genai-toolbox"]
---

# AI Agents: ADK + MCP Toolbox with BigQuery

MCP Toolbox を用いて, ADK と BigQuery を接続した AI Agents を作成するチュートリアルです.

## Google アカウント認証とプロジェクトの設定

- Google アカウント認証
- プロジェクトの設定
- 必要な API の有効化

## Google アカウント認証

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

## プロジェクトの設定

プロジェクト ID の設定

```bash
gcloud config set project PLEASE_SPECIFY_YOUR_PROJECT_ID
```

正しく設定されているか確認

```bash
gcloud config get-value project
```

今後使用するので project id を環境変数に設定

```bash
export PROJECT_ID=$(gcloud config get-value project)
```

## Python 依存関係のインストール

まず、必要なPython依存関係をインストールします。

```bash
pip install -r requirements.txt
```

## Step 2: エージェントの実行

依存関係がインストールできたら、BigQuery MCP エージェントを実行してみましょう。

```bash
adk run .
```

## Step 3: BigQuery データの探索

このエージェントは Google Cloud のリリースノートデータにアクセスできます。以下のような質問を試してみてください：

- 「BigQuery の最新機能について教えて」
- 「2024年の AI/ML 関連リリースを検索して」
- 「Cloud SQL の最近の改善点は？」

## Step 4: MCP ツールの確認

エージェントは以下のツールを使用してBigQueryと連携します：

- **execute_sql**: SQLクエリの実行
- **get_table_info**: テーブルスキーマの取得
- **list_dataset_ids**: データセット一覧の表示
- **list_table_ids**: テーブル一覧の表示

これらのツールにより、Google Cloud の公開リリースノートデータセット `bigquery-public-data.google_cloud_release_notes.release_notes` にアクセスできます。
