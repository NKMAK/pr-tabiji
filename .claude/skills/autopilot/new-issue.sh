#!/usr/bin/env bash
# Issue を起票する。gh が無いときは .claude/todo/issues.md に L 番号で記録する。
# 使い方: new-issue.sh "タイトル" 本文ファイル [ラベル]
# 送り先のリポジトリは origin から自動で決める (WORKFLOW_REPO=owner/name で上書きできる)。
set -euo pipefail
T="${1:?タイトルを指定してください}"; BODY="${2:?本文ファイルを指定してください}"; LABEL="${3:-}"
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  R="${WORKFLOW_REPO:-$(gh repo view --json nameWithOwner -q .nameWithOwner)}"
  args=(-R "$R" --title "$T" --body-file "$BODY")
  [ -n "$LABEL" ] && args+=(--label "$LABEL")
  gh issue create "${args[@]}" | tail -1
  exit 0
fi
ROOT=$(git rev-parse --show-toplevel)
LIST="$ROOT/.claude/todo/issues.md"
if [ ! -f "$LIST" ]; then
  mkdir -p "$(dirname "$LIST")"
  printf '# Issue (ローカル)\n\ngh が使えない間の Issue の記録。gh が使えるようになったら GitHub に起票し直す。\n\n| ID | タイトル | 状態 | マージ | 本文 |\n| --- | --- | --- | --- | --- |\n' > "$LIST"
fi
N=$( (grep -oE '^\| L[0-9]+' "$LIST" || true) | sed 's/| L//' | sort -n | tail -1)
N=$(( ${N:-0} + 1 ))
SLUG=$(basename "$BODY" .md | sed 's/^L[0-9]*-//')
DEST="$ROOT/.claude/todo/issues/L$N-$SLUG.md"
mkdir -p "$ROOT/.claude/todo/issues"
{ echo "# L$N: $T"; echo; cat "$BODY"; } > "$DEST"
echo "| L$N | $T | 未着手 | - | [本文](issues/L$N-$SLUG.md) |" >> "$LIST"
echo "gh が無いため、ローカルに記録しました: $DEST"
