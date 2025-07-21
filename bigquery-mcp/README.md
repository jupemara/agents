# BigQuery MCP Agent

Google Cloudリリースノート検索専用のADKエージェント実装。MCP Toolboxを経由してBigQueryの公開データセット `bigquery-public-data.google_cloud_release_notes.release_notes` にアクセスし、Google Cloud製品のリリース情報を自然言語で検索できます。

## 概要

このエージェントは以下の機能を提供します：

- **製品別リリース検索**: BigQuery、Cloud SQL、AI/ML等の特定製品のリリース情報
- **期間指定検索**: 特定期間内のリリース情報の取得
- **機能別分析**: 新機能、改善、バグ修正等の種類別分析
- **最新情報取得**: 最新のGoogle Cloudリリース情報の要約

## 前提条件

### 必要なソフトウェア

- Python 3.8+
- Google Cloud CLI (gcloud)
- MCP Toolbox バイナリ

### Google Cloudの準備

- Google Cloudプロジェクト（課金有効）
- BigQuery API有効化
- 適切なIAM権限

## インストール・セットアップ

### 1. 依存関係のインストール

```bash
cd bigquery-mcp
pip install -r requirements.txt
```

### 2. Google Cloud認証設定

```bash
# Application Default Credentials設定
gcloud auth application-default login

# プロジェクト設定
gcloud config set project YOUR_PROJECT_ID
```

### 3. 必要なAPI有効化

```bash
# BigQuery API有効化
gcloud services enable bigquery.googleapis.com

# IAM API有効化
gcloud services enable iam.googleapis.com
```

### 4. IAM権限設定

```bash
# 現在のユーザーに権限付与
EMAIL=$(gcloud config get-value account)
PROJECT_ID=$(gcloud config get-value project)

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="user:$EMAIL" \
    --role="roles/bigquery.user"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="user:$EMAIL" \
    --role="roles/bigquery.dataViewer"
```

### 5. MCP Toolbox セットアップ

```bash
# バイナリダウンロード
export VERSION=0.9.0
# linix
curl -O https://storage.googleapis.com/genai-toolbox/v$VERSION/linux/amd64/toolbox
# mac
curl -O https://storage.googleapis.com/genai-toolbox/v$VERSION/darwin/arm64/toolbox
# win
curl -O https://storage.googleapis.com/genai-toolbox/v$VERSION/windows/amd64/toolbox
chmod +x toolbox

# Toolbox起動
./toolbox --tools-file tools.yaml
```

### 6. 環境変数設定

```bash
# .envファイル作成（オプション）
cp .env.example .env

# 必要に応じて編集（通常はデフォルト設定で動作）
```

## 使用方法

### 基本実行

```bash
# MCP Toolboxを別ターミナルで起動
./toolbox --tools-file tools.yaml

# エージェント実行
adk run .
```

## 利用例

```bash
# BigQueryの最新機能について質問
BigQueryの最新機能を教えて

# 期間指定でのリリース検索
2024年のCloud SQLアップデートを表示して

# 製品別の新機能検索
機械学習関連の新機能をまとめて

# セキュリティ関連のリリース情報
セキュリティ強化に関するリリースを検索して
```

## アーキテクチャ

```
[ADK Agent] ←→ [MCP Toolbox] ←→ [BigQuery API] ←→ [Public Dataset]
```

- **ADK Agent**: Google ADKフレームワークによるエージェント
- **MCP Toolbox**: データベース接続とツール管理
- **BigQuery API**: Google Cloud BigQuery接続
- **Public Dataset**: `bigquery-public-data.google_cloud_release_notes.release_notes`

## トラブルシューティング

### よくある問題

**1. MCP Toolbox接続エラー**
```
Warning: Could not connect to MCP Toolbox at http://127.0.0.1:5000
```
→ MCP Toolboxが起動していることを確認: `./toolbox --tools-file tools.yaml`

**2. BigQuery権限エラー**
```
403 Forbidden: BigQuery API has not been used in project
```
→ API有効化: `gcloud services enable bigquery.googleapis.com`

**3. 認証エラー**
```
Application Default Credentials are not available
```
→ 認証設定: `gcloud auth application-default login`

### ログとデバッグ

詳細なログ情報が必要な場合：
```bash
# MCP Toolboxのログレベル調整
./toolbox --tools-file tools.yaml --log-level debug
```

## 技術仕様

### 使用フレームワーク
- **Google ADK**: エージェント開発フレームワーク
- **MCP Toolbox**: データベースツール管理
- **BigQuery**: データクエリエンジン

### データソース
- **プロジェクト**: `bigquery-public-data`
- **データセット**: `google_cloud_release_notes`
- **テーブル**: `release_notes`

### 利用可能ツール
- `execute_sql`: SQLクエリ実行
- `get_table_info`: テーブルスキーマ取得
- `list_dataset_ids`: データセット一覧
- `list_table_ids`: テーブル一覧

## 参考資料

- [Google ADK Documentation](https://github.com/googleapis/agent-development-kit)
- [MCP Toolbox Documentation](https://googleapis.github.io/genai-toolbox/)
- [BigQuery Public Datasets](https://cloud.google.com/bigquery/public-data)
- [Google Cloud Release Notes Dataset](https://console.cloud.google.com/bigquery?p=bigquery-public-data&d=google_cloud_release_notes)

## ライセンス

このプロジェクトは MIT ライセンスの下で公開されています。
