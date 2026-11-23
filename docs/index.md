# docs の地図

**AI はここから読む。** 作業に関係する分類の index だけを開き、そこから必要なファイルだけを読む。全部を読まない。
置き方・更新のルールは [`docs-index` skill](../.claude/skills/docs-index/SKILL.md)。

## 分類

| 場所 | 何があるか | いつ読むか |
| --- | --- | --- |
| [roadmap.md](roadmap.md) | 要件定義の段階・現在地・未決事項・次の一歩 | **作業を始めるとき** (今どこにいるか) |
| [decision-log.md](decision-log.md) | 決めたこと・採用しなかったこと (1 行ずつ) | 方針に関わる判断をする前。決めたら追記する |
| [concept/](concept/index.md) | 背景・思想・コンセプト・既存ツール調査・出典 | 「なぜ」「何を目指すか」が判断に要るとき |
| [architecture.md](architecture.md) | 構成・フォルダ・テスト方針・ブランチ | 実装・フォルダを足すとき (実装前はほぼ空) |
| specs/ (未作成) | 要件ごとの仕様 (`new-spec` skill が作る) | その要件を設計・実装するとき |
| impl-plan/ (未作成) | 設計と実装計画 (`impl-plan` skill が作る) | その計画を実装するとき |

## 作業別: まず読むもの

| 作業 | 読む | 読まなくてよい |
| --- | --- | --- |
| 要件定義を進める | roadmap → concept/02-philosophy → 関係する concept | concept/references, 06-team-practices |
| 仕様・設計を書く | roadmap → decision-log → concept/02, 03 → specs/ | concept/01, 04, 05 |
| 実装する | 該当の impl-plan → architecture | concept/ の大半 |
| 出典・根拠を確かめる | concept/references | — |
