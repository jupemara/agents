# agents

ADK AI Agents samples

## all of us

### my first agent

English Grammar Analysis and Japanese Translation Agent

`./my-first-agent`

このエージェントは与えられた英文を解析し、文法解説と日本語翻訳を提供します。

#### 機能

- **文法解説**: 文型、時制、品詞、構文の詳細な解説
- **日本語翻訳**: 自然で正確な日本語訳
- **慣用句・句動詞の解説**: 見つかった場合の意味と使い方の説明
- **語彙ノート**: 重要な語彙や表現の補足説明

#### 使用方法

```bash
cd /path/to/agents  # agentsディレクトリに移動
adk run my-first-agent
```

インタラクティブモードが開始されるので、英文を入力してください：

```
[user]: I have been studying English for three years.
```

単発テストの場合：

```bash
echo "She broke down when she heard the news." | adk run my-first-agent
```

### simple function calling

function calling の例

`./simple-function-calling`

ここに四則計算を置いときました

### MCP Tools ( playwright )

localhost:8931 で待ち構える playwright MCP サーバに対して指示が出せるエージェント

`./playwright-mcp`

#### how to use

1. **MCPサーバーの起動**:
```bash
cd ./playwright-mcp/server
npm install
npm run start  # localhost:8931でサーバー起動
```

2. **エージェントの実行**:
```bash
cd /path/to/agents  # agentsディレクトリに移動
adk run playwright-mcp
```

### MCP ToolBox