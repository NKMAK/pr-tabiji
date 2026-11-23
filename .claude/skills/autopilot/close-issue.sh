#!/usr/bin/env bash
# マージ後に Issue を閉じる。L 番号ならローカルの記録 (.claude/todo/issues.md) を完了にする。
# 使い方: close-issue.sh <N または LN> "コメント (例: PR #3 でマージ / マージコミット abc1234)"
set -euo pipefail
N="${1:?Issue 番号を指定してください}"; MSG="${2:-マージ済み}"
case "$N" in
  L*)
    ROOT=$(git rev-parse --show-toplevel)
    LIST="$ROOT/.claude/todo/issues.md"
    # | LN | タイトル | 状態 | マージ | 本文 | の 状態 と マージ 列を書き換える
    awk -v id="$N" -v msg="$MSG" 'BEGIN{FS=OFS="|"} $2==" " id " " {$4=" 完了 "; $5=" " msg " "} {print}' "$LIST" > "$LIST.tmp" && mv "$LIST.tmp" "$LIST"
    echo "$N → 完了 ($MSG)";;
  *)
    R="${WORKFLOW_REPO:-$(gh repo view --json nameWithOwner -q .nameWithOwner)}"
    STATE=$(gh issue view "$N" -R "$R" --json state -q .state)
    if [ "$STATE" = CLOSED ]; then echo "#$N はすでに閉じています"; exit 0; fi
    gh issue close "$N" -R "$R" -c "$MSG";;
esac
