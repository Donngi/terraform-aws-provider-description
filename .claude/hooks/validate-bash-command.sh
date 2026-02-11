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

# terraform コマンドは許可（init, providers schema）
if echo "$COMMAND" | grep -qE '^\s*terraform\s+(init|providers)'; then
  exit 0
fi

# jq（JSON解析）は許可
if echo "$COMMAND" | grep -qE '^\s*jq\s'; then
  exit 0
fi

# validate_template.sh は常に許可（絶対パス・相対パス両対応）
if echo "$COMMAND" | grep -qE 'validate_template\.sh'; then
  exit 0
fi

# 読み取り専用コマンド（リダイレクトなし）は許可
# sed, cat, grep, wc, sort, comm, ls, head, tail, find
if echo "$COMMAND" | grep -qE '^\s*(sed|cat|grep|wc|sort|comm|ls|head|tail|find)\s'; then
  # ただしリダイレクトが含まれている場合は次のチェックへ
  if ! echo "$COMMAND" | grep -qE '\s+>{1,2}\s+|^>{1,2}\s+|[^<]>\s*/|[^<]>\s*[a-zA-Z_.~]|\btee\s'; then
    exit 0
  fi
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
