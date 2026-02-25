#!/bin/bash
# 処理済みリソースをcompleted_resources.txtに追記する
#
# 引数: $1=バージョン（例: 6.28.0）, $2=リソース名（例: aws_s3_bucket）
# 終了コード: 0=成功（追記または重複スキップ）, 1=引数エラー

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# 引数バリデーション
if [[ $# -ne 2 ]]; then
    log_error "Usage: $0 <version> <resource_name>"
    exit 1
fi

VERSION="$1"
RESOURCE_NAME="$2"

# バージョン形式バリデーション（X.Y.Z）
if ! echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    log_error "Invalid version format: $VERSION (expected: X.Y.Z)"
    exit 1
fi

# リソース名バリデーション（英小文字・数字・アンダースコア）
if ! echo "$RESOURCE_NAME" | grep -qE '^[a-z][a-z0-9_]+$'; then
    log_error "Invalid resource name: $RESOURCE_NAME"
    exit 1
fi

PROJECT_ROOT=$(get_project_root)
COMPLETED_FILE="$PROJECT_ROOT/.local/$VERSION/completed_resources.txt"

# ディレクトリが存在しない場合は作成
if [[ ! -d "$PROJECT_ROOT/.local/$VERSION" ]]; then
    mkdir -p "$PROJECT_ROOT/.local/$VERSION"
fi

# ファイルが存在しない場合は空ファイルを作成
if [[ ! -f "$COMPLETED_FILE" ]]; then
    touch "$COMPLETED_FILE"
fi

# 重複チェック：既に登録済みならスキップ
if grep -qxF "$RESOURCE_NAME" "$COMPLETED_FILE" 2>/dev/null; then
    log_info "Already completed (skipped): $RESOURCE_NAME"
    exit 0
fi

# 追記（スクリプト内部のリダイレクトはフック検査対象外）
echo "$RESOURCE_NAME" >> "$COMPLETED_FILE"
log_success "Appended: $RESOURCE_NAME -> .local/$VERSION/completed_resources.txt"
