#!/bin/bash
# Step 1: Terraform Registry APIから最新のAWS Providerバージョンを取得
#
# 出力: 最新バージョン番号（例: 6.28.0）
# 終了コード: 0=成功, 1=失敗

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

log_info "Fetching latest AWS Provider version from Terraform Registry..."

LATEST_VERSION=$(curl --max-time 10 -s "https://registry.terraform.io/v1/providers/hashicorp/aws" | jq -r '.version' 2>/dev/null || echo "")

if [[ -z "$LATEST_VERSION" ]]; then
    log_error "Failed to fetch latest version from Terraform Registry."
    exit 1
fi

log_success "Latest version: $LATEST_VERSION"
echo "$LATEST_VERSION"
