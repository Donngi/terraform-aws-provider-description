# ===================================================================================================
# Terraform Template: aws_cognito_user_in_group
# ===================================================================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-19)の AWS Provider v6.28.0 の仕様に基づいています
# - 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください
# - Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_in_group
# - AWS API Reference: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminAddUserToGroup.html
# ===================================================================================================

# ---------------------------------------------------------------------------------------------------
# Resource: aws_cognito_user_in_group
# ---------------------------------------------------------------------------------------------------
# Description:
#   Amazon Cognito User Pool内のユーザーを指定されたグループに追加します。
#   ユーザーがグループに所属すると、アイデンティティプールにpreferred-roleクレームを提示でき、
#   アクセストークンとIDトークンに`cognito:groups`クレームが含まれるようになります。
#
# AWS Documentation:
#   - User Pools API Reference: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminAddUserToGroup.html
#   - Terraform Resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_in_group
# ---------------------------------------------------------------------------------------------------

resource "aws_cognito_user_in_group" "example" {
  # -------------------------------------------------------------------------------------------------
  # Required Parameters
  # -------------------------------------------------------------------------------------------------

  # user_pool_id (必須)
  # Type: string
  # Description:
  #   ユーザーとグループを含むUser Pool ID。
  #   aws_cognito_user_poolリソースのidを参照します。
  # Example: "us-east-1_abcdefghi"
  # AWS Documentation: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminAddUserToGroup.html
  user_pool_id = "us-east-1_XXXXXXXXX"

  # group_name (必須)
  # Type: string
  # Description:
  #   ユーザーを追加するグループの名前。
  #   aws_cognito_user_groupリソースのnameを参照します。
  # Constraints:
  #   - 最小長: 1文字
  #   - 最大長: 128文字
  # AWS Documentation: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminAddUserToGroup.html
  group_name = "example-group"

  # username (必須)
  # Type: string
  # Description:
  #   グループに追加するユーザーのユーザー名またはエイリアス。
  #   aws_cognito_userリソースのusernameを参照します。
  # Constraints:
  #   - 最小長: 1文字
  #   - 最大長: 128文字
  # AWS Documentation: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminAddUserToGroup.html
  username = "example-user"

  # -------------------------------------------------------------------------------------------------
  # Optional Parameters
  # -------------------------------------------------------------------------------------------------

  # id (オプション)
  # Type: string
  # Description:
  #   リソースの識別子。指定しない場合は自動的に生成されます。
  #   通常は明示的に設定する必要はありません。
  # Computed: true (自動計算される属性)
  # id = "example-id"

  # region (オプション)
  # Type: string
  # Description:
  #   このリソースが管理されるAWSリージョン。
  #   指定しない場合、プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # Example: "us-east-1", "ap-northeast-1"
  # Computed: true (デフォルトはプロバイダー設定から取得)
  # AWS Documentation: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

# ===================================================================================================
# 使用例
# ===================================================================================================
# この例では、User Pool、ユーザー、グループを作成し、ユーザーをグループに追加します。
#
# resource "aws_cognito_user_pool" "example" {
#   name = "example-pool"
#
#   password_policy {
#     temporary_password_validity_days = 7
#     minimum_length                   = 6
#     require_uppercase                = false
#     require_symbols                  = false
#     require_numbers                  = false
#   }
# }
#
# resource "aws_cognito_user" "example" {
#   user_pool_id = aws_cognito_user_pool.example.id
#   username     = "example-user"
# }
#
# resource "aws_cognito_user_group" "example" {
#   user_pool_id = aws_cognito_user_pool.example.id
#   name         = "example-group"
# }
#
# resource "aws_cognito_user_in_group" "example" {
#   user_pool_id = aws_cognito_user_pool.example.id
#   group_name   = aws_cognito_user_group.example.name
#   username     = aws_cognito_user.example.username
# }
# ===================================================================================================

# ===================================================================================================
# 補足情報
# ===================================================================================================
# - ユーザーがグループに所属すると、JWTトークンに`cognito:groups`クレームが含まれます
# - これにより、アプリケーション側でロールベースのアクセス制御(RBAC)を実装できます
# - IAM認証情報を使用してこの操作を実行する必要があり、対応するIAM権限がポリシーで
#   付与されている必要があります
# - グループメンバーシップの変更は即座に反映され、次回のトークン生成時に適用されます
# ===================================================================================================
