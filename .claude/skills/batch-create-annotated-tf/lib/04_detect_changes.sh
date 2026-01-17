#!/bin/bash
# Step 4: スキーマ差分を検出（新規・変更・削除リソース）
#
# 引数: $1=現在のスキーマファイル, $2=前回のスキーマファイル（オプション）
# 出力: JSON形式の差分情報
# 終了コード: 0=成功

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

if [[ $# -lt 1 ]]; then
    log_error "Usage: $0 <current_schema> [last_schema]"
    exit 1
fi

CURRENT_SCHEMA=$1
LAST_SCHEMA=${2:-""}

# リソースリスト取得関数
get_resource_list() {
    local schema_file=$1
    jq -r '.provider_schemas["registry.terraform.io/hashicorp/aws"].resource_schemas | keys[]' "$schema_file" | sort
}

CURRENT_RESOURCES=$(get_resource_list "$CURRENT_SCHEMA")

# 前回スキーマがない場合（初回実行）
if [[ -z "$LAST_SCHEMA" ]] || [[ ! -f "$LAST_SCHEMA" ]]; then
    log_warning "Previous schema not found. All resources will be processed."
    
    jq -n \
        --arg added "$CURRENT_RESOURCES" \
        --arg changed "" \
        --arg removed "" \
        '{
            added: ($added | split("\n") | map(select(length > 0))),
            changed: [],
            removed: []
        }'
    exit 0
fi

log_info "Detecting changes between schemas..."

LAST_RESOURCES=$(get_resource_list "$LAST_SCHEMA")

# 新規リソース
ADDED=$(comm -13 <(echo "$LAST_RESOURCES") <(echo "$CURRENT_RESOURCES"))

# 削除リソース
REMOVED=$(comm -23 <(echo "$LAST_RESOURCES") <(echo "$CURRENT_RESOURCES"))

# 共通リソース
COMMON=$(comm -12 <(echo "$LAST_RESOURCES") <(echo "$CURRENT_RESOURCES"))

# 変更リソース検出
CHANGED=""
while IFS= read -r resource; do
    [[ -z "$resource" ]] && continue
    
    CURRENT_HASH=$(jq -c ".provider_schemas[\"registry.terraform.io/hashicorp/aws\"].resource_schemas[\"$resource\"]" "$CURRENT_SCHEMA" | sha256sum | cut -d' ' -f1)
    LAST_HASH=$(jq -c ".provider_schemas[\"registry.terraform.io/hashicorp/aws\"].resource_schemas[\"$resource\"]" "$LAST_SCHEMA" | sha256sum | cut -d' ' -f1)
    
    if [[ "$CURRENT_HASH" != "$LAST_HASH" ]]; then
        CHANGED="${CHANGED}${resource}\n"
    fi
done <<< "$COMMON"

# JSON形式で出力
jq -n \
    --arg added "$ADDED" \
    --arg changed "$(echo -e "$CHANGED" | grep -v '^$')" \
    --arg removed "$REMOVED" \
    '{
        added: ($added | split("\n") | map(select(length > 0))),
        changed: ($changed | split("\n") | map(select(length > 0))),
        removed: ($removed | split("\n") | map(select(length > 0)))
    }'

ADDED_COUNT=$(echo "$ADDED" | grep -v '^$' | wc -l | tr -d ' ')
CHANGED_COUNT=$(echo -e "$CHANGED" | grep -v '^$' | wc -l | tr -d ' ')
REMOVED_COUNT=$(echo "$REMOVED" | grep -v '^$' | wc -l | tr -d ' ')

log_success "Changes detected: +$ADDED_COUNT ~$CHANGED_COUNT -$REMOVED_COUNT"
