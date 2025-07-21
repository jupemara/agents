# BigQuery MCP Agent ハンズオンガイド

## ハンズオン概要

**対象者**: Google Cloud初心者〜中級者
**所要時間**: 60分
**学習目標**: BigQuery + MCP + ADKエージェントの実践的な使い方を習得

## 準備

### 必要なもの
- Google Cloudアカウント
- ローカル環境（macOS/Linux/Windows）
- ターミナルアクセス
- インターネット接続

### 事前確認
```bash
# Python 3.8+があることを確認
python3 --version

# gcloudコマンドが利用可能か確認
gcloud --version
```

---

## Step 1: Google Cloud環境準備（20分）

### 1.1 プロジェクト設定（5分）

```bash
# 新しいプロジェクト作成（または既存プロジェクト使用）
export PROJECT_ID="virtual-gcp"  # または自分のプロジェクトID
gcloud config set project $PROJECT_ID

# 現在のプロジェクト確認
gcloud config get-value project
```

**確認ポイント**: プロジェクトIDが正しく設定されていること

### 1.2 課金アカウント確認（2分）

```bash
# 課金アカウント設定確認
gcloud beta billing projects describe $PROJECT_ID

# 課金が有効でない場合は、Google Cloud Consoleで設定
echo "課金設定: https://console.cloud.google.com/billing"
```

### 1.3 必要なAPI有効化（5分）

```bash
# BigQuery API有効化
gcloud services enable bigquery.googleapis.com

# IAM API有効化（権限設定用）
gcloud services enable iam.googleapis.com

# Cloud Resource Manager API有効化
gcloud services enable cloudresourcemanager.googleapis.com

# API有効化確認
gcloud services list --enabled --filter="name:bigquery OR name:iam OR name:cloudresourcemanager"
```

**期待結果**: 3つのAPIが有効化されていることを確認

### 1.4 認証・権限設定（8分）

```bash
# A. Application Default Credentials設定
gcloud auth application-default login
# → ブラウザが開くので、Googleアカウントでログイン

# B. 現在のユーザー確認
gcloud auth list
echo "現在のアカウント: $(gcloud config get-value account)"

# C. BigQuery権限付与
EMAIL=$(gcloud config get-value account)
PROJECT_ID=$(gcloud config get-value project)

# BigQuery ユーザー権限
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="user:$EMAIL" \
    --role="roles/bigquery.user"

# BigQuery データビューアー権限
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="user:$EMAIL" \
    --role="roles/bigquery.dataViewer"

# 権限確認
gcloud projects get-iam-policy $PROJECT_ID \
    --flatten="bindings[].members" \
    --format='table(bindings.role)' \
    --filter="bindings.members:$EMAIL"
```

**期待結果**: `roles/bigquery.user` と `roles/bigquery.dataViewer` が表示される

---

## Step 2: BigQuery接続テスト（10分）

### 2.1 基本接続確認（5分）

```bash
# 公開データセット接続テスト
bq query --use_legacy_sql=false \
'SELECT COUNT(*) as total_records
FROM `bigquery-public-data.google_cloud_release_notes.release_notes`
LIMIT 1'
```

**期待結果**: 数千件のレコード数が表示される（例: total_records: 5432）

### 2.2 テーブルスキーマ確認（5分）

```bash
# release_notesテーブルの構造確認
bq show bigquery-public-data:google_cloud_release_notes.release_notes

# 実際のデータサンプル確認
bq query --use_legacy_sql=false \
'SELECT title, date, product_name
FROM `bigquery-public-data.google_cloud_release_notes.release_notes`
ORDER BY date DESC
LIMIT 5'
```

**期待結果**: 最新のGoogle Cloudリリース情報が5件表示される

---

## Step 3: MCP Toolbox セットアップ（10分）

### 3.1 MCP Toolbox ダウンロード（3分）

```bash
# bigquery-mcpディレクトリに移動
cd bigquery-mcp

# MCP Toolbox バイナリダウンロード
export VERSION=0.9.0
curl -O https://storage.googleapis.com/genai-toolbox/v$VERSION/linux/amd64/toolbox
chmod +x toolbox

# バイナリ確認
./toolbox --version
```

### 3.2 環境変数設定（2分）

```bash
# 環境変数設定（通常はデフォルト値で動作）
export TOOLBOX_URL="http://127.0.0.1:5000"

# 確認
echo "TOOLBOX_URL: $TOOLBOX_URL"
```

### 3.3 MCP Toolbox起動（5分）

```bash
# バックグラウンドでToolbox起動
./toolbox --tools-file tools.yaml &

# 少し待ってから接続確認
sleep 5
curl -s http://127.0.0.1:5000/health || echo "Toolbox起動中..."

# プロセス確認
ps aux | grep toolbox
```

**期待結果**: Toolboxプロセスが起動していること

---

## Step 4: ADKエージェント実行（15分）

### 4.1 依存関係インストール（3分）

```bash
# Python依存関係インストール
pip install -r requirements.txt

# インストール確認
pip list | grep -E "(google-adk|toolbox-core)"
```

### 4.2 エージェント起動（2分）

```bash
# エージェント実行
adk run .
```

**期待結果**: エージェントが起動し、インタラクティブモードになる

### 4.3 基本動作確認（10分）

以下の演習を順番に実行：

#### 演習1: 基本検索（3分）
```
入力: BigQueryの最新機能を教えて
```
**期待結果**: BigQueryの最新リリース情報が日本語で表示される

#### 演習2: 期間指定検索（3分）
```
入力: 2024年のCloud SQLアップデートを表示して
```
**期待結果**: 2024年のCloud SQL関連リリースが表示される

#### 演習3: 製品別分析（4分）
```
入力: 機械学習関連の新機能をまとめて
```
**期待結果**: AI/ML関連の新機能情報がまとめて表示される

---

## Step 5: 応用演習・振り返り（15分）

### 5.1 カスタムクエリ演習（10分）

参加者が自由に検索条件を設定：

**提案例:**
- "セキュリティ強化に関するリリースを検索して"
- "今月追加された新サービスは何？"
- "コスト削減に関連する機能改善を教えて"
- "特定の製品（例：Cloud Run）の全リリース履歴"

### 5.2 技術解説・振り返り（5分）

**講師向け解説ポイント:**
1. **エージェントの動作原理**
   - ADK ↔ MCP Toolbox ↔ BigQuery の連携
   - 自然言語 → SQL変換の仕組み

2. **MCP Toolboxの役割**
   - データベース接続の抽象化
   - ツール管理とセキュリティ

3. **BigQuery公開データセットの活用**
   - 豊富なパブリックデータの活用方法
   - 自社データとの組み合わせ可能性

4. **質疑応答**

---

## 参加者向けチェックリスト

実習中に以下の項目を確認してください：

- [ ] Google Cloudプロジェクト作成・設定完了
- [ ] BigQuery API有効化完了
- [ ] 認証設定（ADC）完了
- [ ] IAM権限付与完了
- [ ] BigQuery接続テスト成功
- [ ] MCP Toolbox起動・動作確認完了
- [ ] エージェント実行成功
- [ ] 基本検索（演習1）実行成功
- [ ] 期間指定検索（演習2）実行成功
- [ ] 製品別分析（演習3）実行成功
- [ ] カスタムクエリ実行成功

---

## トラブルシューティング

### よくある問題と解決方法

**Q1: "BigQuery API has not been used in project" エラー**
```bash
# 解決方法
gcloud services enable bigquery.googleapis.com
# 少し待ってから再実行
```

**Q2: "Application Default Credentials are not available" エラー**
```bash
# 解決方法
gcloud auth application-default login
# ブラウザでの認証を完了させる
```

**Q3: "Could not connect to MCP Toolbox" エラー**
```bash
# 解決方法
ps aux | grep toolbox  # プロセス確認
./toolbox --tools-file tools.yaml &  # 再起動
```

**Q4: 権限エラー（403 Forbidden）**
```bash
# 解決方法
EMAIL=$(gcloud config get-value account)
PROJECT_ID=$(gcloud config get-value project)
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="user:$EMAIL" \
    --role="roles/bigquery.user"
```

---

## 講師向けノート

### 時間配分のポイント
- **Setup（30分）**: 参加者のスキルレベルに応じて調整
- **演習（20分）**: 基本演習は必須、応用演習は時間次第
- **解説（10分）**: 技術的背景の理解促進

### デモ用サンプルクエリ
```sql
-- 最新リリース（講師用）
SELECT title, date, product_name
FROM `bigquery-public-data.google_cloud_release_notes.release_notes`
WHERE date >= '2024-01-01'
ORDER BY date DESC
LIMIT 10

-- 製品別件数（講師用）
SELECT product_name, COUNT(*) as release_count
FROM `bigquery-public-data.google_cloud_release_notes.release_notes`
WHERE date >= '2024-01-01'
GROUP BY product_name
ORDER BY release_count DESC
LIMIT 10
```

### 緊急対応
- **ネットワーク障害**: ローカルでのSQLite例を用意
- **権限問題**: 講師のプロジェクトでの共有アクセス
- **時間超過**: 基本演習のみに絞る
