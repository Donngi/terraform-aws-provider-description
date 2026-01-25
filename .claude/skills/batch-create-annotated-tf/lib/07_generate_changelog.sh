#!/bin/bash
# Step 7: 変更ログを生成
#
# 引数: $1=新バージョン, $2=旧バージョン, $3=差分JSON
# 出力: 変更ログファイルのパス
# 終了コード: 0=成功

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

if [[ $# -ne 3 ]]; then
    log_error "Usage: $0 <new_version> <old_version> <changes_json>"
    exit 1
fi

NEW_VERSION=$1
OLD_VERSION=${2:-"(initial)"}
CHANGES_JSON=$3

PROJECT_ROOT=$(get_project_root)
CHANGE_LOG="$PROJECT_ROOT/.local/$NEW_VERSION/change_log.txt"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

log_info "Generating change log..."

# JSON から情報抽出
ADDED=$(echo "$CHANGES_JSON" | jq -r '.added[]' | sort)
CHANGED=$(echo "$CHANGES_JSON" | jq -r '.changed[]' | sort)
REMOVED=$(echo "$CHANGES_JSON" | jq -r '.removed[]' | sort)

ADDED_COUNT=$(echo "$CHANGES_JSON" | jq -r '.added | length')
CHANGED_COUNT=$(echo "$CHANGES_JSON" | jq -r '.changed | length')
REMOVED_COUNT=$(echo "$CHANGES_JSON" | jq -r '.removed | length')
TOTAL_PROCESSED=$((ADDED_COUNT + CHANGED_COUNT))

# 変更ログ生成
cat > "$CHANGE_LOG" <<EOF
Provider Version Update: ${OLD_VERSION} → ${NEW_VERSION}
Generated: ${TIMESTAMP}

=== Summary ===
New Resources: ${ADDED_COUNT}
Changed Resources: ${CHANGED_COUNT}
Removed Resources: ${REMOVED_COUNT}
Total Processed: ${TOTAL_PROCESSED}

=== New Resources ===
${ADDED}

=== Changed Resources ===
${CHANGED}

=== Removed Resources (Archived) ===
${REMOVED}
EOF

log_success "Change log generated: $CHANGE_LOG"
echo "$CHANGE_LOG"
