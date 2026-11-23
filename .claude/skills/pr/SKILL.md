---
name: pr
description: 機能ごとのブランチから既定ブランチ (通常 main) 向けの PR を作成する。「PR 作って」「プルリク出して」といった依頼で使う。簡潔さを最優先にする。
---

# pr

現在のブランチから、既定ブランチ向けの PR を作る。説明は**短く**。

## ルール

- 1 PR = 1 Issue = 1 機能。既定ブランチへ直接 push しない (`gh` が無いときのマージは `autopilot` の「gh がないとき」)。
- PR のベースは**既定ブランチ** (`git symbolic-ref --short refs/remotes/origin/HEAD` の `origin/` を除いた名前。CLAUDE.md に別の指定があればそれに従う)。聞き返さずに作ってよい。
- ブランチ名: `feat/xxx`, `fix/xxx`, `chore/xxx`, `docs/xxx`, `refactor/xxx`
- タイトル: `{type}: {概要}` (`commit` skill の type と同じ。**英語**、70 字以内)
- 本文は次の 3 項目だけ。OSS として公開するため**英語**で書く。各 1〜5 行、箇条書き可。

```
## What
## Why
## Verification
```

- **動作確認 (Verification) は一番大事な項目。** 「何を操作して、何を見て、何が出たか」を書く (手順は CLAUDE.md の「検証」に書いた skill)。テストを変えた・足したときは、実行したコマンドと通った件数も書く。「ビルドが通った」「型チェックが通った」だけでは書いたことにならない。画面の変更なら、見たスクリーンショットを 1 枚以上。
- **Issue 駆動なので `Closes #N` (gh が無いときは `L<N>`) を必ず入れる。** (既定ブランチ以外へのマージでは自動で閉じないので、マージ後に親が `close-issue.sh` で閉じる。)

## 手順

1. `git status` と `git diff origin/<既定ブランチ> --stat` で、PR に含まれる変更を確認する (範囲外のファイル、`.env`、鍵がないこと)。
2. 未コミットがあれば先に `commit` skill でコミットする。
3. `git remote -v` で送り先を確かめ、`git push -u origin <branch>` する。
4. `gh pr create --base <既定ブランチ>` を実行する。`gh` が無いときは、本文を Issue の本文ファイル (`.claude/todo/issues/L<N>-*.md`) の「PR」節に書く。
5. PR の URL (またはブランチ名) を報告する。**サブエージェントはここまで** (マージ、`.claude/todo/` には触らない)。
6. 親エージェントは、`autopilot` skill の「5. PR と自動マージ」の確認をしてからマージする。

## 注意

- push と PR 作成は外部に公開される操作。ユーザーが頼んだとき、`autopilot` の実行中、または親エージェントのプロンプトで許可されたときに実行する。
- コミットメッセージと PR 本文の末尾の署名行は、システムの指示に従う。
