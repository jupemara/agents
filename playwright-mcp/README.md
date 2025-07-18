# playwright-mcp

localhost:8931 で待ち構える playwright MCP サーバに対して指示が出せるエージェント

## 使用方法

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
