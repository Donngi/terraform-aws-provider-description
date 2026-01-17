#!/bin/bash
# Step 6: processed_provider_version.jsonを更新
#
# 引数: $1=バージョン, $2=総リソース数, $3=処理済みリソース数, $4=スキーマチェックサム
# 終了コード: 0=成功

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

if [[ $# -ne 4 ]]; then
    log_error "Usage: $0 <version> <total_resources> <processed_count> <schema_checksum>"
    exit 1
fi

VERSION=$1
TOTAL_RESOURCES=$2
PROCESSED_COUNT=$3
SCHEMA_CHECKSUM=$4

PROJECT_ROOT=$(get_project_root)
VERSION_FILE="$PROJECT_ROOT/processed_provider_version.json"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

log_info "Updating version file..."

# バックアップ
if [[ -f "$VERSION_FILE" ]]; then
    cp "$VERSION_FILE" "${VERSION_FILE}.backup"
fi

# 更新（既存ファイルがあればそれを基に、なければ新規作成）
if [[ -f "$VERSION_FILE" ]]; then
    jq --arg version "$VERSION" \
       --arg timestamp "$TIMESTAMP" \
       --arg total "$TOTAL_RESOURCES" \
       --arg processed "$PROCESSED_COUNT" \
       --arg checksum "$SCHEMA_CHECKSUM" \
       '.last_processed = {
         version: $version,
         timestamp: $timestamp,
         total_resources: ($total | tonumber),
         processed_resources: ($processed | tonumber),
         schema_checksum: $checksum
       }' \
       "$VERSION_FILE" > "${VERSION_FILE}.tmp"
else
    jq -n \
       --arg version "$VERSION" \
       --arg timestamp "$TIMESTAMP" \
       --arg total "$TOTAL_RESOURCES" \
       --arg processed "$PROCESSED_COUNT" \
       --arg checksum "$SCHEMA_CHECKSUM" \
       '{
         format_version: "1.0",
         last_processed: {
           version: $version,
           timestamp: $timestamp,
           total_resources: ($total | tonumber),
           processed_resources: ($processed | tonumber),
           schema_checksum: $checksum
         }
       }' > "${VERSION_FILE}.tmp"
fi

mv "${VERSION_FILE}.tmp" "$VERSION_FILE"

log_success "Version file updated: $VERSION_FILE"
