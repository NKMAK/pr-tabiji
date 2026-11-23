---
name: commit
description: プロジェクト共通のコミット規約（feat/fix/chore等の接頭辞+英語メッセージ）に沿ってgitコミットを作成する。「コミットして」「ここまでをコミットして」といった依頼で使う。いつ・どの単位でコミットするか（タスク単位か等）は呼び出し側が決める。
---

# commit

指示された範囲の変更を、プロジェクト共通のコミット規約に沿ってコミットするスキル。何を1コミットの単位とするか（タスク単位、機能単位など）は呼び出し側が判断し、このスキルには「与えられた範囲を正しくコミットする」ことだけを担わせる。

## コミットメッセージ規約

先頭行: `{type}: {summary in English}`

OSS として公開するため、`{type}` もメッセージも本文も**英語**で書く。先頭行は命令形・小文字始まり・末尾ピリオドなし。

| type | 用途 |
| --- | --- |
| feat | 新機能の追加 |
| fix | バグ修正 |
| docs | ドキュメントのみの変更 |
| refactor | 挙動を変えないコードの整理 |
| test | テストの追加・修正のみ |
| style | フォーマットなど動作に影響しない変更 |
| perf | パフォーマンス改善 |
| chore | 上記に当てはまらない雑務的な変更（設定・依存関係の更新など） |

本文（1行空けて記載）には「何を」ではなく「なぜ」を英語で簡潔に書く（コードを見れば分かる内容は書かない）。

```
feat: add token usage monitoring

Needed to decide when to suggest a break once usage over a
period exceeds the threshold.
```

## 手順

1. `git status` / `git diff` で、コミット対象として指示された範囲の変更内容を確認する。
2. 対象ファイルを `git add <path>` で個別に指定する。**`git add -A` / `git add .` は使わない**（`.claude/worktrees/` などを誤ってコミットしないため）。
   - lint / formatter があれば、**触ったファイルだけ**整形・検査してから add する (コマンドは `lint-format` skill の「B. 毎回」と CLAUDE.md)。
   - `docs/` や `.md` を足す・動かす・消したときは、index を同じコミットで直し、`.claude/skills/docs-index/check.sh` を通す (`docs-index` skill)。
3. `git diff --staged` でステージ済みの内容が指示された範囲と一致するか確認する。
4. 変更内容から適切な `type` を選び、上記フォーマットでコミットメッセージを作成する。
5. `git commit` を実行する。
6. `git status` で完了を確認する。

## 注意

- 何をコミット単位にするか（タスクごと、機能ごと等）はこのスキルの管轄外。呼び出し側（例: `impl-plan` skill）の指示に従う。
- コミット前に、指示された範囲外の変更が混ざっていないか必ず確認する。
- `git add a b c` は、1 つでも存在しないパスがあると**全体が失敗して何も追加されない**。`&&` で次に進まず、`git diff --staged --stat` で中身を確かめてからコミットする (2026-11-22、移動だけのコミットを push してしまった)。
- push はこのスキルではしない。`pr` skill、`autopilot`、または呼び出し側の指示に従う。
