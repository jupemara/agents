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

#### 出力例

```
**原文**: I have been studying English for three years.
**日本語訳**: 私は3年間英語を勉強しています。

**文法解説**:
- 文型: SV (第1文型)
- 時制: 現在完了進行形 (have been + 動詞の現在分詞)
    - 過去のある時点から現在まで継続している動作や状態を表します。
    - 「have/has + been + 動詞のing形」で構成されます。
- 品詞:
    - I (代名詞): 主語
    - have been studying (動詞句): 動詞
    - English (名詞): 目的語
    - for (前置詞): 前置詞
    - three years (名詞句): 期間を表す副詞句
- 構文:
    - 「for + 期間」で「～の間」という意味を表し、継続している期間を示します。

**語彙ノート**:
- study: 勉強する、研究する。ここでは「英語を勉強する」という意味で使用されています。
- for: （期間）の間。ここでは「3年間」という期間を示しています。
```