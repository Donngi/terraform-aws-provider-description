#!/bin/bash
# TaskOutput結果からJSON抽出 → content取得 → ファイル書き込み
# 引数: <output_file> <target_file> <resource_name>

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
    echo "ERROR: output_file_not_found" >&2
    exit 8
fi

# Pythonで堅牢にJSON抽出（複数行対応）
EXTRACTED=$(jq -r '.message.content[]?.text // empty' "$OUTPUT_FILE" 2>/dev/null | python3 -c "
import sys, json, re

text = sys.stdin.read()

match = re.search(r'\{\"status\":\"(success|error)\",\"resource\":\"aws_[^\"]+\".*', text, re.DOTALL)
if not match:
    sys.exit(1)

json_str = match.group(0)

for end_pos in range(len(json_str), 0, -1):
    try:
        obj = json.loads(json_str[:end_pos])
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

# ファイル書き込み
echo "$CONTENT" > "$TARGET_FILE"

if [[ $? -eq 0 ]]; then
    echo "SUCCESS: $RESOURCE" >&2
    exit 0
else
    echo "ERROR: write_failed" >&2
    exit 6
fi
