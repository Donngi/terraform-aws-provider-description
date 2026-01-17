#!/bin/bash
# Step 5: 削除されたリソースのテンプレートファイルをアーカイブ
#
# 引数: $1=削除リソースのJSON配列（例: '["aws_old_service"]'）
# 終了コード: 0=成功

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

if [[ $# -ne 1 ]]; then
    log_error "Usage: $0 <removed_resources_json>"
    exit 1
fi

REMOVED_JSON=$1
PROJECT_ROOT=$(get_project_root)

# JSON配列から要素を取得
REMOVED_COUNT=$(echo "$REMOVED_JSON" | jq -r 'length')

if [[ "$REMOVED_COUNT" -eq 0 ]]; then
    log_info "No resources to archive."
    exit 0
fi

log_warning "Following resources were removed:"
echo "$REMOVED_JSON" | jq -r '.[]' >&2

log_info "Archiving removed resources..."

mkdir -p "$PROJECT_ROOT/terraform-template/archived"

echo "$REMOVED_JSON" | jq -r '.[]' | while IFS= read -r resource; do
    TEMPLATE_FILE="$PROJECT_ROOT/terraform-template/${resource}.tf"
    
    if [[ -f "$TEMPLATE_FILE" ]]; then
        mv "$TEMPLATE_FILE" "$PROJECT_ROOT/terraform-template/archived/${resource}.tf"
        log_success "Archived: $resource"
    fi
done
