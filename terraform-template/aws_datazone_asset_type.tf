# ===================================================================
# Terraform AWS Provider - aws_datazone_asset_type
# ===================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# このテンプレートは生成時点の情報です。
# 最新の仕様は公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datazone_asset_type
# ===================================================================

# -------------------------------------------------------------------
# Resource: aws_datazone_asset_type
# -------------------------------------------------------------------
# Terraform resource for managing an AWS DataZone Asset Type.
# AWS DataZone Asset Typeは、データカタログ内のアセットの構造と
# メタデータスキーマを定義するためのカスタムアセットタイプです。
#
# AWS公式ドキュメント:
# - CreateAssetType API: https://docs.aws.amazon.com/datazone/latest/APIReference/API_CreateAssetType.html
# - Create custom asset types: https://docs.aws.amazon.com/datazone/latest/userguide/create-asset-types.html
# -------------------------------------------------------------------

resource "aws_datazone_asset_type" "example" {
  # ===================================================================
  # Required Arguments
  # ===================================================================

  # domain_identifier - (Required) string
  # DataZoneドメインの一意な識別子。
  # このカスタムアセットタイプが作成されるAmazon DataZoneドメインのIDを指定します。
  domain_identifier = "dzd-1234567890abcdef"

  # name - (Required) string
  # カスタムアセットタイプの名前。
  # 長さ: 1-128文字
  # パターン: 特定の命名規則に従う必要があります。
  name = "CustomDataAsset"

  # owning_project_identifier - (Required) string
  # このカスタムアセットタイプを所有するAmazon DataZoneプロジェクトの一意な識別子。
  owning_project_identifier = "abc123"

  # ===================================================================
  # Optional Arguments
  # ===================================================================

  # description - (Optional) string
  # カスタムアセットタイプの説明。
  # このフィールドを使用して、アセットタイプの目的や用途を説明できます。
  description = "Custom asset type for storing and cataloging specific data assets"

  # region - (Optional) string (Computed)
  # このリソースが管理されるAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # AWS Regional Endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ===================================================================
  # Block: forms_input (Optional)
  # ===================================================================
  # カスタムアセットタイプに添付されるメタデータフォーム。
  # メタデータフォームは、アセットにビジネスコンテキストを追加し、
  # カタログでのデータ検索と一貫性を向上させます。
  # 最小: 0個、最大: 10個のフォームを設定可能
  #
  # AWS公式ドキュメント:
  # - FormEntryInput: https://docs.aws.amazon.com/datazone/latest/APIReference/API_FormEntryInput.html
  # - Create metadata forms: https://docs.aws.amazon.com/datazone/latest/userguide/create-metadata-form.html
  # ===================================================================

  forms_input {
    # map_block_key - (Required) string
    # フォームエントリのマップキー。
    # このキーはフォームを識別するために使用されます。
    # formsInputマップ内で一意である必要があります。
    map_block_key = "BusinessMetadata"

    # type_identifier - (Required) string
    # フォームエントリのタイプID。
    # 長さ: 1-385文字
    # パターン: (?!\.)[\w\.]*\w
    # 既存のメタデータフォームタイプの識別子を指定します。
    type_identifier = "amazon.datazone.BusinessMetadataFormType"

    # type_revision - (Required) string
    # フォームエントリのタイプリビジョン。
    # 長さ: 1-64文字
    # メタデータフォームのバージョンを指定します。
    type_revision = "1"

    # required - (Optional) bool
    # フォームエントリが必須かどうかを指定します。
    # true: このメタデータフォームはアセット作成時に必須
    # false または未設定: オプション
    required = true
  }

  # 複数のメタデータフォームを添付する例
  forms_input {
    map_block_key   = "TechnicalMetadata"
    type_identifier = "amazon.datazone.TechnicalMetadataFormType"
    type_revision   = "2"
    required        = false
  }

  # ===================================================================
  # Block: timeouts (Optional)
  # ===================================================================
  # リソース操作のタイムアウト設定。
  # Terraformがリソース操作の完了を待機する最大時間を指定します。
  # ===================================================================

  timeouts {
    # create - (Optional) string
    # リソース作成操作のタイムアウト。
    # 形式: Goの duration 形式（例: "30s", "5m", "2h45m"）
    # 単位: "s" (秒), "m" (分), "h" (時間)
    # デフォルト: プロバイダーのデフォルト値が使用されます
    create = "30m"
  }
}

# ===================================================================
# Computed Attributes (Read-Only)
# ===================================================================
# 以下の属性はTerraformによって自動的に計算され、
# リソース作成後に参照可能です。設定することはできません。
#
# - created_at (string)
#   カスタムアセットタイプが作成されたタイムスタンプ
#   参照例: aws_datazone_asset_type.example.created_at
#
# - created_by (string)
#   カスタムアセットタイプを作成したユーザー
#   参照例: aws_datazone_asset_type.example.created_by
#
# - revision (string)
#   アセットタイプのリビジョン
#   参照例: aws_datazone_asset_type.example.revision
# ===================================================================

# ===================================================================
# Output Examples
# ===================================================================
# 作成されたリソースの属性を出力する例

# output "asset_type_created_at" {
#   description = "Timestamp when the asset type was created"
#   value       = aws_datazone_asset_type.example.created_at
# }

# output "asset_type_created_by" {
#   description = "User who created the asset type"
#   value       = aws_datazone_asset_type.example.created_by
# }

# output "asset_type_revision" {
#   description = "Revision of the asset type"
#   value       = aws_datazone_asset_type.example.revision
# }
