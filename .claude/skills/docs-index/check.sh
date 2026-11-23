#!/usr/bin/env bash
# docs の index 漏れと切れた相対リンクを出す。何も出なければ OK (終了コード 0)。
# 使い方: check.sh [リポジトリのルート]
set -euo pipefail
ROOT="${1:-$(git rev-parse --show-toplevel)}"
python3 -I - "$ROOT" <<'PY'
import pathlib, re, sys
root = pathlib.Path(sys.argv[1]).resolve()
docs = root / "docs"
bad = 0
link = re.compile(r"\]\(([^)#\s]+)(?:#[^)]*)?\)")
# 1. 各フォルダの index.md に、そのフォルダの .md とサブフォルダが載っているか
if docs.is_dir():
    for d in [docs, *[p for p in docs.rglob("*") if p.is_dir()]]:
        mds = [p for p in d.glob("*.md") if p.name != "index.md"]
        subs = [p for p in d.iterdir() if p.is_dir() and any(p.rglob("*.md"))]
        if not mds and not subs:
            continue
        idx = d / "index.md"
        if not idx.exists():
            print(f"index なし: {idx.relative_to(root)}"); bad += 1; continue
        text = idx.read_text()
        for p in mds:
            if f"({p.name})" not in text and f"({p.name}#" not in text:
                print(f"index に載っていない: {p.relative_to(root)}"); bad += 1
        for p in subs:
            if f"({p.name}/" not in text:
                print(f"index に載っていない: {p.relative_to(root)}/"); bad += 1
# 2. 相対リンク切れ
# 雛形 (templates/) は置き先からの相対リンクなので対象外
files = [root / "README.md", root / "CLAUDE.md", *docs.rglob("*.md"), *(root / ".claude" / "skills").glob("*/SKILL.md")]
for f in files:
    if not f.exists() or "worktrees" in f.parts:
        continue
    in_code = False
    for n, line in enumerate(f.read_text().splitlines(), 1):
        if line.lstrip().startswith("```"):
            in_code = not in_code
        if in_code:
            continue
        for target in link.findall(line):
            if re.match(r"^[a-z]+:", target) or "{" in target or "<" in target:
                continue
            if not (f.parent / target).exists():
                print(f"リンク切れ: {f.relative_to(root)}:{n} → {target}"); bad += 1
sys.exit(1 if bad else 0)
PY
