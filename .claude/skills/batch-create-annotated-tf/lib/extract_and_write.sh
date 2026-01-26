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

# JSON行を抽出（{"status": で始まる行）
JSON_LINE=$(grep -o '{"status":"[^"]*".*}' "$OUTPUT_FILE" | head -n1)

if [[ -z "$JSON_LINE" ]]; then
    echo "ERROR: no_json_output" >&2
    exit 1
fi

# statusを確認
STATUS=$(echo "$JSON_LINE" | jq -r '.status' 2>/dev/null)

if [[ $? -ne 0 ]]; then
    echo "ERROR: invalid_json" >&2
    exit 2
fi

if [[ "$STATUS" == "error" ]]; then
    ERROR_MSG=$(echo "$JSON_LINE" | jq -r '.error_message')
    echo "ERROR: subagent_error: $ERROR_MSG" >&2
    exit 3
fi

if [[ "$STATUS" != "success" ]]; then
    echo "ERROR: unknown_status: $STATUS" >&2
    exit 4
fi

# contentを抽出
CONTENT=$(echo "$JSON_LINE" | jq -r '.content')

if [[ -z "$CONTENT" || "$CONTENT" == "null" ]]; then
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
