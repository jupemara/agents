# BigQuery MCP Toolbox Agent ハンズオンガイド

## 事前準備

- billing account の設定
- 新規プロジェクトの設定
- プロジェクトの owner/editor 権限

## 事前確認

```bash
# python 3.9+
$ python --version
# gcloud
$ gcloud --version
```

## 1. プロジェクト設定

```zsh
export PROJECT_ID="PLEASE_REPLASE_WITH_YOUR_PROJECT_ID"
gcloud config set project $PROJECT_ID
gcloud config get-value project
```

## 2. BigQuery 接続確認

```bash
$ bq query --use_legacy_sql=false \
'SELECT description, published_at, product_name
FROM `bigquery-public-data.google_cloud_release_notes.release_notes`
ORDER BY published_at DESC
LIMIT 5'
```

## 3. MCP Toolbox

```zsh
# ダウンロード
$ cd bigquery-mcp
$ export VERSION=0.9.0
# 各種 platfoam に合わせて
$ curl -O https://storage.googleapis.com/genai-toolbox/v$VERSION/linux/amd64/toolbox
$ chmod +x toolbox
$ ./toolbox --version
# 起動
$ ./toolbox --tools-file tools.yaml --address 127.0.0.1 --port 5000
$ curl -s http://127.0.0.1:5000/
```

## 4. ADKエージェント実行

```zsh
# install dependencies
$ pip install -r requirements.txt
$ adk run .
```

## 5. 実際にクエリを投げたり, エラーを修正したりする

### 5-1 基本検索

- `BigQuery の最新機能を教えて`

### 5-2 期間指定検索

- `2024年のCloud SQLアップデートを表示して`

### 5-3 製品別分析

- `機械学習関連の新機能をまとめて`

### troubleshooting

- `tools.yaml` の `sources.my-bigquery.project` が書き換わっているか
- カラムが存在しない系のエラーを踏んだときは AI にテーブル構造を教えてあげる必要があるので
  - 1. "テーブル一覧" っていう
  - 2. "release_notes のテーブル構造" って言って, AI にテーブルのカラムの構造を理解させて, 次回以降のクエリの組み立てを正確に行わせる

## 6. Cloud Run にデプロイ

- `cloud-run/deploy.sh` の中身を見て適宜変数を変更確認
- `cloudbuild.yaml` の中身を見て適宜変数を変更
- `cloud-run/cloud-run.yaml` の中身を見て適宜変数を変更

## 7. Vertex AI Agent + Agentspace にデプロイ

- `vertex-ai/deploy.sh` の中身を見て適宜変数を変更
