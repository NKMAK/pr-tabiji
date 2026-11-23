---
name: lint-format
description: プロジェクトの基本の lint と formatter を入れる・揃える・実行する。スタック (JS/TS、Python、C#/Unity、シェル) を見て既存の設定を活かし、無ければ標準の構成を入れる。「lint を整備して」「フォーマッタ入れて」「整形して」「lint エラーを直して」、初回セットアップのあと、コミット前の整形で使う。
---

# lint-format

**整形と単純な指摘は道具に任せ、レビューと会話で扱わない。** 初回に一度整え、以後はコミット前に触ったファイルだけを整形・検査する。

## A. 整備 (初回・足りないとき)

1. **今あるものを調べる** (あれば活かし、別の道具に乗り換えない):
   - JS/TS: `package.json` の scripts と devDependencies、`biome.json`、`eslint.config.*` / `.eslintrc*`、`.prettierrc*`
   - Python: `pyproject.toml` の `[tool.ruff]` / `[tool.black]`、`setup.cfg`
   - C#/Unity: `.editorconfig`、`*.csproj` / `*.sln`
   - 共通: `.editorconfig`、`.gitattributes`
2. **無ければ標準を入れる** (依存の追加は 1 本の PR にまとめる):

   | スタック | 標準 | 入れるもの |
   | --- | --- | --- |
   | JS/TS (新規・設定なし) | Biome | `@biomejs/biome` と `biome.json` (`npx @biomejs/biome init`)。scripts: `"check": "biome check ."`、`"format": "biome check --write ."` |
   | JS/TS (ESLint・Prettier が既にある) | そのまま | 足りない scripts だけ足す: `"lint"`, `"format": "prettier --write ."`, `"format:check": "prettier --check ."`。ESLint と Prettier の衝突は `eslint-config-prettier` で止める |
   | Python | Ruff | `pyproject.toml` に `[tool.ruff]` (line-length と target-version)。`ruff check --fix` と `ruff format` |
   | C#/Unity | .editorconfig | `.editorconfig` (インデント・改行・`dotnet_` の基本ルール)。`dotnet format` は sln がある場合だけ。Unity の自動生成ファイル (`Library/`、`*.csproj`) は対象外 |
   | シェル | shellcheck | 入っていれば `shellcheck` で検査するだけ (入れるのは人に任せる) |

3. **型チェックも 1 コマンドにまとめる** (TS なら `tsc --noEmit`)。CLAUDE.md の「技術スタック」に、lint・format・型チェック・テストのコマンドを 1 行ずつ書く。
4. **既存のコードを一括整形するとき**は、整形だけのコミットを分ける (`style: ...`)。機能の変更と混ぜない。差分が大きいときは、その旨を PR に書く。
5. 確認: lint・format の検査がエラー 0 で通ること。直せないものは理由をコメントで残して無効化する (`biome-ignore` / `eslint-disable-next-line` / `# noqa`)。

## B. 毎回 (コミット前)

- **触ったファイルだけ**を整形・検査する (全体は PR の前に 1 回):
  - Biome: `npx biome check --write <パス...>`
  - ESLint + Prettier: `npx prettier --write <パス...> && npx eslint --fix <パス...>`
  - Ruff: `ruff check --fix <パス...> && ruff format <パス...>`
- 整形で増えた差分も同じコミットに入れる (`git add <パス>`)。

## C. CI (任意)

- GitHub Actions で `lint`・`format:check`・型チェック・テストを PR ごとに回すと、人も AI も見落とさない。private リポジトリは Actions の分数を使うので、入れる前にユーザーに確認する (コスト)。

## 落とし穴

- 道具を 2 つ重ねない (Biome と Prettier の両方で整形すると、差分が往復する)。
- 自動生成ファイル・ビルド成果物 (`dist/`、`Library/`、ロックファイル) を対象から外す (ignore に入れる)。
- 一括整形の PR と機能の PR を同時に開くと競合する。一括整形は波の前に親が入れる。
