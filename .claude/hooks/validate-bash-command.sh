#!/bin/bash
set -uo pipefail
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  exit 0
fi

# git コマンドは常に許可（commit, add, status, diff, log 等）
if echo "$COMMAND" | grep -qE '^\s*git\s'; then
  exit 0
fi

# terraform providers schema -json > schema.json は許可
if echo "$COMMAND" | grep -qE 'terraform\s+providers\s+schema\s+-json\s*>'; then
  exit 0
fi

# Bashでのファイル書き込み（リダイレクト）をブロック
# ファイルへの出力リダイレクト（1> 2> >> ）と tee を検出
# ただし heredoc（<<）や比較演算子は除外
if echo "$COMMAND" | grep -qE '\s+>{1,2}\s+|^>{1,2}\s+|[^<]>\s*/|[^<]>\s*[a-zA-Z_.~]|\btee\s'; then
  echo '{"decision":"block","reason":"Bashでのファイル書き込みは禁止です。Writeツールを使用してください。"}' >&2
  exit 2
fi

# Python/Node実行をブロック
if echo "$COMMAND" | grep -qiE '\bpython[23]?\b|\bnode\b|\bnpm\b|\bnpx\b'; then
  echo '{"decision":"block","reason":"Python/Nodeの実行は禁止です。"}' >&2
  exit 2
fi

exit 0
