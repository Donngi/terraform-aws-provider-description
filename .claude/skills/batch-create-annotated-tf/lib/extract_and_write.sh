#!/bin/bash
#---------------------------------------------------------------
# extract_and_write.sh
#---------------------------------------------------------------
# TaskOutput結果からJSON抽出 → content取得 → ファイル書き込み
#
# 引数: <output_file> <target_file> <resource_name>
#
# 終了コード:
#   0: 成功
#   1: no_json_output / no_text_content
#   2: invalid_json
#   3: subagent_error
#   4: unknown_status
#   5: empty_content
#   6: write_failed
#   7: invalid_arguments
#   8: output_file_not_found
#---------------------------------------------------------------

OUTPUT_FILE="$1"
TARGET_FILE="$2"
RESOURCE="$3"

# 引数チェック
if [[ -z "$OUTPUT_FILE" || -z "$TARGET_FILE" || -z "$RESOURCE" ]]; then
    echo "ERROR: invalid_arguments" >&2
    exit 7
fi

# output_fileの存在確認
if [[ ! -f "$OUTPUT_FILE" ]]; then
    echo "ERROR: output_file_not_found: $OUTPUT_FILE" >&2
    exit 8
fi

# JSONL形式のTaskOutput結果からassistantメッセージのテキストを抽出
# 複数のtext contentがある場合があるため、すべて連結
ALL_TEXT=$(jq -r '
    select(.type == "assistant") |
    .message.content[]? |
    select(.type == "text") |
    .text
' "$OUTPUT_FILE" 2>/dev/null)

if [[ -z "$ALL_TEXT" ]]; then
    echo "ERROR: no_text_content" >&2
    exit 1
fi

# Pythonで堅牢にJSON抽出（複数行対応、末尾探索アルゴリズム）
EXTRACTED=$(echo "$ALL_TEXT" | python3 -c "
import sys
import json
import re

text = sys.stdin.read()

# サブエージェントの出力から {\"status\": で始まるJSONを検索
# 複数行にまたがる場合も対応
match = re.search(r'\{\"status\":\s*\"(success|error)\"\s*,\s*\"resource\":\s*\"aws_[^\"]+\".*', text, re.DOTALL)
json_str = None

if match:
    json_str = match.group(0)
else:
    # フォールバック1: \`\`\`json で囲まれたJSONブロックを検索
    match = re.search(r'\`\`\`json?\s*(\{\"status\".*?\})\s*\`\`\`', text, re.DOTALL)
    if match:
        json_str = match.group(1)
    else:
        # フォールバック2: {\"status\":\"success\" または {\"status\":\"error\" を検索（厳密なマッチ）
        match = re.search(r'\{\"status\":\"(success|error)\".*', text, re.DOTALL)
        if match:
            json_str = match.group(0)

if not json_str:
    sys.exit(1)

# 末尾から逆方向に削りながら有効なJSONを探索
for end_pos in range(len(json_str), 0, -1):
    try:
        obj = json.loads(json_str[:end_pos])
        # 必要なフィールドが存在することを確認
        if 'status' not in obj:
            continue
        print('STATUS=' + obj.get('status', ''))
        print('CONTENT_START')
        print(obj.get('content', ''))
        print('CONTENT_END')
        if obj.get('status') == 'error':
            print('ERROR_MSG=' + obj.get('error_message', ''))
        sys.exit(0)
    except json.JSONDecodeError:
        continue

sys.exit(2)
")

EXTRACT_EXIT=$?

if [[ $EXTRACT_EXIT -eq 1 ]]; then
    echo "ERROR: no_json_output" >&2
    exit 1
fi

if [[ $EXTRACT_EXIT -eq 2 ]]; then
    echo "ERROR: invalid_json" >&2
    exit 2
fi

# STATUS取得
STATUS=$(echo "$EXTRACTED" | grep '^STATUS=' | cut -d= -f2)

if [[ "$STATUS" == "error" ]]; then
    ERROR_MSG=$(echo "$EXTRACTED" | grep '^ERROR_MSG=' | cut -d= -f2-)
    echo "ERROR: subagent_error: $ERROR_MSG" >&2
    exit 3
fi

if [[ "$STATUS" != "success" ]]; then
    echo "ERROR: unknown_status: $STATUS" >&2
    exit 4
fi

# CONTENT取得（CONTENT_STARTとCONTENT_ENDの間）
CONTENT=$(echo "$EXTRACTED" | sed -n '/^CONTENT_START$/,/^CONTENT_END$/p' | sed '1d;$d')

if [[ -z "$CONTENT" ]]; then
    echo "ERROR: empty_content" >&2
    exit 5
fi

# ターゲットディレクトリの作成
TARGET_DIR=$(dirname "$TARGET_FILE")
mkdir -p "$TARGET_DIR"

# ファイル書き込み
echo "$CONTENT" > "$TARGET_FILE"

if [[ $? -eq 0 ]]; then
    echo "SUCCESS: $RESOURCE" >&2
    exit 0
else
    echo "ERROR: write_failed" >&2
    exit 6
fi
