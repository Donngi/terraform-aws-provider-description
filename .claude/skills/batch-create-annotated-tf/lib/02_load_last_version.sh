#!/bin/bash
# Step 2: processed_provider_version.jsonから前回処理バージョンを読み込み
#
# 出力: 前回バージョン番号（存在しない場合は空文字列）
# 終了コード: 0=成功

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

PROJECT_ROOT=$(get_project_root)
VERSION_FILE="$PROJECT_ROOT/processed_provider_version.json"

if [[ ! -f "$VERSION_FILE" ]]; then
    log_info "No previous version file found. This is the first run."
    echo ""
    exit 0
fi

# JSON検証
if ! jq empty "$VERSION_FILE" 2>/dev/null; then
    log_warning "processed_provider_version.json is corrupted."
    
    if [[ -f "${VERSION_FILE}.backup" ]]; then
        log_info "Restoring from backup..."
        cp "${VERSION_FILE}.backup" "$VERSION_FILE"
    else
        log_info "Initializing new version file..."
        echo '{"format_version": "1.0"}' > "$VERSION_FILE"
        echo ""
        exit 0
    fi
fi

LAST_VERSION=$(jq -r '.last_processed.version // empty' "$VERSION_FILE" 2>/dev/null || echo "")

if [[ -n "$LAST_VERSION" ]]; then
    log_info "Last processed version: $LAST_VERSION"
else
    log_info "No previous version found in file."
fi

echo "$LAST_VERSION"
