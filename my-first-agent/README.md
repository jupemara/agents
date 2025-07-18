# my-first-agent

English Grammar Analysis and Japanese Translation Agent

このエージェントは与えられた英文を解析し、文法解説と日本語翻訳を提供します。

## 機能

- **文法解説**: 文型、時制、品詞、構文の詳細な解説
- **日本語翻訳**: 自然で正確な日本語訳
- **慣用句・句動詞の解説**: 見つかった場合の意味と使い方の説明
- **語彙ノート**: 重要な語彙や表現の補足説明

## 使用方法

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
