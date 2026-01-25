#!/bin/bash
# Step 3: 指定バージョンのTerraform Provider Schemaを準備
#
# 引数: $1=バージョン番号（例: 6.28.0）
# 出力: スキーマファイルのパス
# 終了コード: 0=成功, 1=失敗

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

if [[ $# -ne 1 ]]; then
    log_error "Usage: $0 <version>"
    exit 1
fi

VERSION=$1
PROJECT_ROOT=$(get_project_root)
SCHEMA_DIR="$PROJECT_ROOT/.local/$VERSION"
SCHEMA_FILE="$SCHEMA_DIR/schema.json"

if [[ -f "$SCHEMA_FILE" ]]; then
    log_info "Schema for version $VERSION already exists."
    echo "$SCHEMA_FILE"
    exit 0
fi

log_info "Preparing schema for version $VERSION..."

mkdir -p "$SCHEMA_DIR"

cat > "$SCHEMA_DIR/providers.tf" <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "$VERSION"
    }
  }
}
EOF

cd "$SCHEMA_DIR"
terraform init > /dev/null 2>&1
terraform providers schema -json > schema.json
cd "$PROJECT_ROOT"

log_success "Schema prepared: $SCHEMA_FILE"
echo "$SCHEMA_FILE"
