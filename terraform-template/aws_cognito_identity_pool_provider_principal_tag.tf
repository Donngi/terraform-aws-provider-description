# Terraform AWS Provider Resource: aws_cognito_identity_pool_provider_principal_tag
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cognito_identity_pool_provider_principal_tag
# NOTE: AWS Cognito Identity Pool Provider の Principal Tag マッピング設定
#       IDプロバイダー経由のユーザー属性をIAMロールのセッションタグにマッピング
#       SAML/OIDC IDプロバイダーのクレームをAWSリソースのタグベースアクセス制御(ABAC)に利用可能
#       各IDプロバイダーごとに個別の Principal Tag 設定を管理
# Provider Version: 6.28.0

#-----------------------------------------------------------------------
# Identity Pool 設定
#-----------------------------------------------------------------------

variable "identity_pool_id" {
  type        = string
  description = "Cognito Identity Pool の ID"
  # 設定内容: IDプールの一意識別子
  # 設定可能な値:
  #   - リージョン別のIDプール識別子形式 (例: us-east-1:12345678-1234-1234-1234-123456789012)
  # 省略時: 指定必須 (リソース作成には必須)
}

variable "identity_provider_name" {
  type        = string
  description = "Identity Provider の名前"
  # 設定内容: プリンシパルタグをマッピングするIDプロバイダーの識別子
  # 設定可能な値:
  #   - SAMLプロバイダー名
  #   - OIDCプロバイダー名
  #   - プロバイダー固有の識別子形式
  # 省略時: 指定必須 (リソース作成には必須)
}

#-----------------------------------------------------------------------
# Principal Tag マッピング設定
#-----------------------------------------------------------------------

variable "principal_tags" {
  type        = map(string)
  description = "IDプロバイダーの属性とIAMプリンシパルタグのマッピング"
  default     = null
  # 設定内容: IDプロバイダーのクレーム/属性名をキー、IAMセッションタグ名を値として指定
  # 設定可能な値:
  #   - キー: IDプロバイダーが提供するクレーム名 (例: "department", "email", "custom:role")
  #   - 値: IAMロールセッションに設定されるタグキー名 (例: "Department", "Email", "AppRole")
  # 省略時: デフォルトのタグマッピングが使用される (use_defaults 設定に依存)
  # 注意事項:
  #   - タグキーは128文字以内、値は256文字以内の制限あり
  #   - タグベースアクセス制御(ABAC)ポリシーで利用可能
}

variable "use_defaults" {
  type        = bool
  description = "デフォルトのマッピング設定を使用するかどうか"
  default     = null
  # 設定内容: Cognitoが提供するデフォルトのプリンシパルタグマッピングを適用
  # 設定可能な値:
  #   - true: デフォルトマッピングを使用
  #   - false: principal_tags で指定したカスタムマッピングのみを使用
  # 省略時: デフォルト動作が適用される
}

#-----------------------------------------------------------------------
# リージョン設定
#-----------------------------------------------------------------------

variable "region" {
  type        = string
  description = "リソースが管理されるAWSリージョン"
  default     = null
  # 設定内容: このリソースを作成・管理するリージョン
  # 設定可能な値:
  #   - AWSリージョンコード (例: us-east-1, ap-northeast-1, eu-west-1)
  # 省略時: プロバイダー設定のデフォルトリージョンが使用される
}

#-----------------------------------------------------------------------
# リソース定義
#-----------------------------------------------------------------------

resource "aws_cognito_identity_pool_provider_principal_tag" "this" {
  identity_pool_id       = var.identity_pool_id
  identity_provider_name = var.identity_provider_name
  principal_tags         = var.principal_tags
  use_defaults           = var.use_defaults
  region                 = var.region
}

#-----------------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#-----------------------------------------------------------------------

output "id" {
  value       = aws_cognito_identity_pool_provider_principal_tag.this.id
  description = "リソースの一意識別子 (identity_pool_id:identity_provider_name 形式)"
}

output "identity_pool_id_output" {
  value       = aws_cognito_identity_pool_provider_principal_tag.this.identity_pool_id
  description = "Cognito Identity Pool ID (入力値の確認用)"
}

output "identity_provider_name_output" {
  value       = aws_cognito_identity_pool_provider_principal_tag.this.identity_provider_name
  description = "Identity Provider 名 (入力値の確認用)"
}

output "principal_tags_output" {
  value       = aws_cognito_identity_pool_provider_principal_tag.this.principal_tags
  description = "適用されたプリンシパルタグマッピング"
}

output "use_defaults_output" {
  value       = aws_cognito_identity_pool_provider_principal_tag.this.use_defaults
  description = "デフォルト設定の使用状況"
}

output "region_output" {
  value       = aws_cognito_identity_pool_provider_principal_tag.this.region
  description = "リソースが管理されているAWSリージョン"
}
