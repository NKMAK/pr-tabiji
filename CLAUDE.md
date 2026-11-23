# pr-tabiji

PR をレビューする人が、変更を速く理解するための OSS ツール。読む量を削るのではなく、「データの旅」を軸に抽象 → 具体の順で示し、理解に至るまでの時間を短くする。
現在は要件定義の段階 (思想まで合意済み)。現在地は [docs/roadmap.md](docs/roadmap.md)。

## 詳細ドキュメント (AI はまずここを読む)

- **docs の入口は [docs/index.md](docs/index.md) だけ。** 分類ごとの地図と「作業別: まず読むもの」がある。index → 必要なファイルの順で、**作業に要るものだけ読む** (全部を読まない)。docs を足す・動かす・消すときは `docs-index` skill。
- **意思決定記録: [docs/decision-log.md](docs/decision-log.md)**。重大な決定 (技術選定、仕様の変更、方針の転換) をしたら 1 行で追記する (理由と見送った案。覆したら行を消さずに新しい行を足す)。
- **ブロッカーと再開メモ: [.claude/todo/progress.md](.claude/todo/progress.md)**。進捗の正は GitHub の Issue と PR。
- やることの一覧: [.claude/todo/todo.md](.claude/todo/todo.md)
- **`.claude/` は git 管理外** (skills・todo・settings は手元だけ)。消えても `my-workflow/setup.sh -p core,web` で入れ直せる。プロジェクト固有に変えた点 (commit / pr の英語化、`docs-index` skill) は下の「プロジェクト固有の変更」に残す。

## 技術スタック

未定。Web アプリになる見込み (提供形態は未決。[roadmap](docs/roadmap.md) の未決事項 5)。決めたらここと下の表を埋める。

| 用途 | コマンド |
| --- | --- |
| 開発サーバー / 起動 | |
| lint | |
| format (触ったファイル) | |
| 型チェック | |
| テスト | |

- lint と formatter が無ければ `lint-format` skill で整える。**コミット前に触ったファイルだけ整形する。**

## 開発ルール (要点。手順は skill に置く)

### 確認の基準 (自律的に進める)

- 基本は**聞かずに進める**。小さな判断は既定値で決め、Issue / PR / discussion に 1 行で記録する。迷ったら推奨案を 1 つ選んで進める。
- 人に聞くのは次だけ: **セキュリティ** (鍵・認可・個人情報)、**コスト** (課金が発生する選択)、**技術的に大きな決断** (DB・フレームワークの変更)、**取り消しにくい外部操作** (force push、リポジトリ設定の変更、ブランチの削除、本番データの変更)。聞いている間も、関係のない作業は進める。
- 操作が権限の確認で拒否されたら、言い換えて繰り返さない。何をしたかったかと理由を `progress.md` のブロッカーに書き、最後に報告する。

### Issue 駆動とブランチ

- **すべての作業は Issue から始める。** なければ先に起票する (`.claude/skills/autopilot/new-issue.sh`)。本文には目的、完了の定義、関連パス (REQ-ID、設計、使う skill)、触るファイル範囲、依存を書く。
- ブランチは `feat/* → main`。`origin/main` から `feat/xxx` `fix/xxx` `chore/xxx` `docs/xxx` を切り、PR は `main` 向け。
- コミットは `commit` skill、PR は `pr` skill。**`git add -A` と `git add .` は使わず、`git add <パス>` で指定する。**
- 日本語でコミュニケーションする。ただし OSS として公開するため、**コミットメッセージ・PR のタイトルと本文は英語**で書く。

### 自動ワークフロー (autopilot)

「起票 → 設計 → 実装 → 検証 → PR → 確認して `main` へ自動マージ → Issue を閉じる → 進捗更新」を、人の確認なしで回す。**手順とチェックリストは [.claude/skills/autopilot/SKILL.md](.claude/skills/autopilot/SKILL.md)**。

- `main` 向けの PR は、検証が通っていれば**親が自動マージ** (`--merge` のマージコミット) する。
- 人のコードレビューは行わない。代わりに、親がマージ前に、差分の範囲・秘密情報・検証の結果を見る。

### 検証 (最重要)

- **「ビルドが通った」は検証ではない。** 変更したものを実際に動かして確かめる。手順は `web-verify` skill。
- PR の「動作確認」には、実行した確認と結果を書く。画面・見た目の変更は、スクリーンショットを最低 1 枚は目で見る。
- 実装はまだない。起動コマンド・ポート・スモークで見る流れは、実装を始めたらここに書く。

### テスト (最低限だけ書く)

- 書くのは**コアなドメインの純粋な関数**だけ。正常系と、ビジネス上大事な境界を 1 関数あたり数ケースまで。
- 画面や外部連携の網羅的なテストは書かず、上の検証で正常系を確かめる。詳細は [docs/architecture.md](docs/architecture.md) の「テスト方針」。

### ルールと skill を自分で育てる

- 進め方で新しく決まったことは、聞かれなくても**自分でこのファイルに追記する**。ここには要点とリンクだけを書き、手順は `.claude/skills/` か `docs/` に置く。
- 同じ手順を 2 回以上やった、または今後も繰り返す作業は `.claude/skills/{name}/SKILL.md` にする (既存の skill で足りるならそれを更新する)。作ったら、名前と用途を一言で報告する。
- **タスク・波の終わりと、ユーザーに指摘・訂正されたときは `retro` skill で振り返る。** 繰り返した手順は skill に、落とし穴は skill の記録に、トークン節約のコツは [token-tips](.claude/skills/retro/references/token-tips.md) に、その場で反映する。
- トークンを節約する: 必要な範囲だけ読む、編集後に読み直さない、テストは変えた範囲から、スクショは要所だけ (詳細は token-tips)。
- 汎用的に使える改善は、[my-workflow](https://github.com/NKMAK/my-workflow) にも反映する (`setup.sh` で他のプロジェクトへ配る)。

## プロジェクト固有の変更 (`.claude/` を入れ直したときに戻す)

- `commit` / `pr` skill: メッセージ・PR は英語 (OSS のため)。
- `docs-index` skill を追加 (docs の index 運用と `check.sh`)。`commit` skill から docs 変更時に呼ぶ。
