---
title: "AI Agents: BigQuery with MCP Toolbox"
description: "BigQuery MCP エージェントを使用してデータベース操作を行うチュートリアル"
duration: 15
level: Beginner
tags: [BigQuery, MCP, AI Agents, Python]
---

# AI Agents: BigQuery with MCP Toolbox

このチュートリアルでは、BigQuery MCP (Model Context Protocol) エージェントを使用してデータベース操作を行う方法を学習します。

## Step 1: 依存関係のインストール

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
