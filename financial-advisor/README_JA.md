# Financial Advisor エージェント (日本語版)

金融アドバイスを提供する包括的なマルチエージェントシステムです。市場分析、トレーディング戦略の提案、実行計画、リスク評価を行います。

## 概要

このエージェントは以下の4つのサブエージェントを組み合わせて動作します:

1. **Data Analyst**: Google検索を使用して市場データを収集・分析
2. **Trading Analyst**: ユーザーのリスク態度と投資期間に基づいてトレーディング戦略を提案
3. **Execution Analyst**: トレーディング戦略の最適な実行計画を策定
4. **Risk Analyst**: 提案された計画の総合的なリスク評価を実施

## Cloud Shellでのセットアップ

### 1. リポジトリのクローン

```bash
cd ~
git clone <YOUR_REPO_URL>
cd financial-advisor
```

### 2. uvのインストール

uvは高速なPythonパッケージマネージャです。pipを使ってインストールします:

```bash
# uvのインストール
pip install uv

# インストール確認
uv --version
```

### 3. Python環境のセットアップ

```bash
# Python 3.11以上が必要
python3 --version

# 依存関係のインストール
uv sync
```

### 4. 環境変数の設定

`.env`ファイルを編集して、GCPプロジェクト情報を設定してください:

```bash
vi .env
```

以下の値を設定:
```
GOOGLE_GENAI_USE_VERTEXAI=1
GOOGLE_CLOUD_PROJECT=<YOUR_PROJECT_ID>
GOOGLE_CLOUD_LOCATION=us-central1
```

### 5. GCP認証の設定

```bash
gcloud auth application-default login
gcloud config set project <YOUR_PROJECT_ID>
```

### 6. 必要なAPIの有効化

```bash
gcloud services enable aiplatform.googleapis.com
gcloud services enable customsearch.googleapis.com
```

## エージェントの実行

### 方法1: adk run (CLIモード)

```bash
adk run .
```

インタラクティブモードで以下のステップを進めます:
1. 分析したい株式ティッカーシンボルを入力 (例: AAPL, GOOGL, MSFT)
2. リスク態度を選択 (保守的/中程度/積極的)
3. 投資期間を選択 (短期/中期/長期)
4. 実行設定を指定

### 方法2: adk web (ブラウザUI)

```bash
adk web
```

Cloud Shell Web Previewを使用してブラウザでアクセス:
1. 上部メニューの「ウェブでプレビュー」をクリック
2. ポート8080を選択
3. ブラウザでUIが開きます

### 方法3: adk api_server (APIサーバー)

```bash
adk api_server
```

REST APIとして動作します。別のターミナルから:

```bash
curl -X POST http://localhost:8080/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "AAPLを分析してください"}'
```

## プロジェクト構造

```
financial-advisor/
├── financial_advisor/
│   ├── __init__.py
│   ├── agent.py          # メインエージェント
│   ├── prompt.py         # 日本語プロンプト
│   └── sub_agents/
│       ├── data_analyst/     # 市場データ分析
│       ├── trading_analyst/  # トレーディング戦略
│       ├── execution_analyst/ # 実行計画
│       └── risk_analyst/     # リスク評価
├── pyproject.toml
├── .env                  # 環境変数設定
└── README_JA.md         # このファイル
```

## 使用例

```bash
# エージェントを起動
adk run .

# プロンプトに従って入力:
# > 分析したいティッカーシンボルは? GOOGL
# > リスク態度は? 中程度
# > 投資期間は? 中期
```

エージェントは以下を提供します:
- 最新の市場分析レポート
- 5つ以上のカスタマイズされたトレーディング戦略
- 詳細な実行計画
- 包括的なリスク評価

## トラブルシューティング

### Google Search APIエラー

Google Search APIキーが必要な場合は、以下で設定:

```bash
export GOOGLE_API_KEY=<YOUR_API_KEY>
export GOOGLE_CSE_ID=<YOUR_SEARCH_ENGINE_ID>
```

### Vertex AI APIエラー

プロジェクトでVertex AI APIが有効化されているか確認:

```bash
gcloud services list --enabled | grep aiplatform
```

### 依存関係のエラー

依存関係を再インストール:

```bash
uv sync --reinstall
```

## 重要な注意事項

このツールは教育および情報提供のみを目的としています。
- AIモデルが生成する情報は金融アドバイスではありません
- 投資判断の前に必ず専門家に相談してください
- 過去の実績は将来の結果を保証しません
- すべての投資にはリスクが伴います

## ライセンス

Apache License 2.0

## サポート

問題が発生した場合は、以下を確認してください:
1. すべての環境変数が正しく設定されているか
2. 必要なGCP APIが有効化されているか
3. 認証情報が正しく設定されているか
