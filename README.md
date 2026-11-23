# pr-tabiji

データの旅路をたどって、PRを速く理解するためのOSSツール。

AIによってコードを書く速度は上がったが、人間がそれを理解してマージの責任を持つ速度は上がっていない。
pr-tabiji は、読む時間を削るのではなく、**理解に至るまでの時間を短くする**ことを目指す。

> 現在は要件定義の段階。実装はまだない。

## 考え方（要約）

- 理解とは、仮説を立てて検証すること。**抽象**で何を理解するかを先に示し、**具体**（コードとデータ）で確かめる。
- 人間の頭の容量は小さい。情報は足すより削る。
- 読む軸は「データの旅」1本にする。同じコードを二度読ませない。
- AIは、コードか根拠資料から分かることだけを書く。分からないことは「要確認」として示す。
- 判断は人間が下す。

## ドキュメント

| ファイル | 内容 |
|---|---|
| [docs/01-background.md](docs/01-background.md) | 背景と課題 |
| [docs/02-philosophy.md](docs/02-philosophy.md) | 目的・思想・やらないこと |
| [docs/03-concept.md](docs/03-concept.md) | コンセプト（路線図とデータの旅） |
| [docs/04-senior-perspective.md](docs/04-senior-perspective.md) | シニア視点との照合と、足りない視点 |
| [docs/05-existing-tools.md](docs/05-existing-tools.md) | 既存ツールの調査と差別化 |
| [docs/06-requirements-roadmap.md](docs/06-requirements-roadmap.md) | 要件定義の進め方・現在地・未決事項 |
| [docs/07-decision-log.md](docs/07-decision-log.md) | 決めたこと・採用しなかったことの記録 |
| [docs/08-team-practices.md](docs/08-team-practices.md) | 付録: ツール以外の打ち手（チーム運用） |
| [docs/references.md](docs/references.md) | 出典と根拠 |

## 名前について

「旅路（たびじ）」から。データがコードの中を通っていく旅をたどる、という意味。
