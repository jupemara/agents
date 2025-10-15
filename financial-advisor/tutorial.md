---
title: "AI Agents: Financial Advisor with ADK"
description: "ADK を用いて金融アドバイスを提供する AI Agents を作成するチュートリアル"
duration: 45
level: Beginner
tags: [AI Agents, ADK, Python, "Financial Advisor", Gemini]
---

# AI Agents: Financial Advisor with ADK

ADK (Agent Development Kit) を用いて, 市場分析から投資戦略, リスク評価まで提供する金融アドバイザー AI Agents を作成するチュートリアルです.

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

を実行してログインを行います (ログイン URL が出てくるので, URL をクリック, verification code を入力しましょう).

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
gcloud services enable aiplatform.googleapis.com
gcloud services enable customsearch.googleapis.com
```

## Step 2. uv のインストール

uv は高速な Python パッケージマネージャです. pip を使ってインストールします.

```bash
pip install uv
```

インストール確認

```bash
uv --version
```

## Step 3. 環境変数の設定

`.env` ファイルにプロジェクト情報を設定します

```bash
cat > .env <<EOF
GOOGLE_GENAI_USE_VERTEXAI=1
GOOGLE_CLOUD_PROJECT=${GOOGLE_CLOUD_PROJECT}
GOOGLE_CLOUD_LOCATION=${GOOGLE_CLOUD_LOCATION}
EOF
```

設定内容を確認

```bash
cat .env
```

## Step 4. Python 依存関係のインストール

uv を使って依存関係をインストールします.

```bash
uv sync
```

## Step 5. ローカル環境で Agent を動かしてみる

### CLI モードで起動

```bash
adk run .
```

以下のようなプロンプトが表示されるので, 順番に入力していきます:

1. 分析したい市場ティッカーシンボルを入力 (例: `AAPL`, `GOOGL`, `MSFT`)
2. リスク態度を選択 (例: `保守的`, `中程度`, `積極的`)
3. 投資期間を選択 (例: `短期`, `中期`, `長期`)

Agent が以下を提供します:
- 最新の市場分析レポート
- カスタマイズされたトレーディング戦略
- 詳細な実行計画
- 包括的なリスク評価

### Web ブラウザを使って起動

```bash
adk web . --port 8080
```

Cloud Shell の Web Preview 機能を使ってアクセスします:
1. 上部メニューの「ウェブでプレビュー」をクリック
2. ポート 8080 を選択
3. ブラウザで UI が開きます.

### プロンプトの入力例

以下のような質問をしてみてください:

- "AAPLを分析してください。リスク態度は中程度、投資期間は中期でお願いします"
- "GOOGLの最新情報を教えて"
- "MSFTのトレーディング戦略を提案して"

## Step 6. エージェントの仕組み

このエージェントは4つのサブエージェントで構成されています:

### 1. Data Analyst
- Google検索を使用して市場データを収集
- SEC filings、ニュース、アナリストレポートを分析
- 包括的な市場分析レポートを生成

### 2. Trading Analyst
- 市場分析に基づいてトレーディング戦略を提案
- ユーザーのリスク態度と投資期間を考慮
- 5つ以上の異なる戦略オプションを提供

### 3. Execution Analyst
- トレーディング戦略の実行計画を策定
- エントリー/エグジットのタイミング、注文タイプを提案
- ポジションサイジングとリスク管理を含む

### 4. Risk Analyst
- 提案された計画の総合的なリスク評価
- 市場リスク、流動性リスク、心理的リスクを分析
- 具体的なリスク軽減策を提案

## Step 7. カスタマイズ

### プロンプトの編集

日本語プロンプトは以下のファイルに記載されています:

```bash
cloudshell edit financial_advisor/prompt.py
```

### サブエージェントのカスタマイズ

各サブエージェントのプロンプトを編集できます:

```bash
cloudshell edit financial_advisor/sub_agents/data_analyst/prompt.py
cloudshell edit financial_advisor/sub_agents/trading_analyst/prompt.py
cloudshell edit financial_advisor/sub_agents/execution_analyst/prompt.py
cloudshell edit financial_advisor/sub_agents/risk_analyst/prompt.py
```

## トラブルシューティング

### Google Search API エラーが出る場合

Google Search API キーが必要な場合は、以下で設定:

```bash
export GOOGLE_API_KEY=<YOUR_API_KEY>
export GOOGLE_CSE_ID=<YOUR_SEARCH_ENGINE_ID>
```

### Vertex AI API エラーが出る場合

プロジェクトで API が有効化されているか確認:

```bash
gcloud services list --enabled | grep aiplatform
```

### 依存関係のエラーが出る場合

依存関係を再インストール:

```bash
uv sync --reinstall
```

## 重要な注意事項

このツールは教育および情報提供のみを目的としています:

- AIモデルが生成する情報は金融アドバイスではありません
- 投資判断の前に必ず専門家に相談してください
- 過去の実績は将来の結果を保証しません
- すべての投資にはリスクが伴います

## おめでとうございます!

これで Financial Advisor Agent の構築が完了しました.

次のステップ:
- 異なる銘柄で試してみる
- プロンプトをカスタマイズする
- 独自のサブエージェントを追加する
