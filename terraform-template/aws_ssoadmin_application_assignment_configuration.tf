#---------------------------------------------------------------
# SSO Admin Application Assignment Configuration
#---------------------------------------------------------------
#
# AWS IAM Identity Center（旧 AWS SSO）のアプリケーションに対する
# アサインメント設定を管理するリソース。
#
# アプリケーションへのアクセスにユーザーの明示的なアサインメントが
# 必要かどうかを制御します。デフォルトでは、アプリケーションへの
# アクセスには明示的なアサインメントが必要です（assignment_required = true）。
#
# このリソースを削除すると、アプリケーションのアサインメント設定は
# デフォルトのAWS動作（assignment_required = true）に戻ります。
#
# AWS公式ドキュメント:
#   - PutApplicationAssignmentConfiguration API: https://docs.aws.amazon.com/singlesignon/latest/APIReference/API_PutApplicationAssignmentConfiguration.html
#   - GetApplicationAssignmentConfiguration API: https://docs.aws.amazon.com/singlesignon/latest/APIReference/API_GetApplicationAssignmentConfiguration.html
#   - IAM Identity Center ユーザーガイド: https://docs.aws.amazon.com/singlesignon/latest/userguide/assignuserstoapp.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_application_assignment_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_application_assignment_configuration" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # application_arn - (Required) アプリケーションのARN
  #
  # IAM Identity Centerで管理されているアプリケーションのARNを指定します。
  #
  # 形式: arn:aws(-[a-z]{1,5}){0,3}:sso::123456789012:application/(sso)?ins-[a-zA-Z0-9-.]{16}/apl-[a-zA-Z0-9]{16}
  # 長さ: 10〜1224文字
  #
  # 例:
  #   application_arn = aws_ssoadmin_application.example.arn
  #   application_arn = "arn:aws:sso::123456789012:application/ssoins-1234567890abcdef/apl-1234567890abcdef"
  application_arn = null

  # assignment_required - (Required) アサインメントが必要かどうか
  #
  # ユーザーがアプリケーションにアクセスするために明示的な
  # アサインメントが必要かどうかを指定します。
  #
  # - true（デフォルト値）: ユーザーは CreateApplicationAssignment API を使用して
  #   アサインメントが作成されない限り、アプリケーションにアクセスできません。
  #   アサインメントが作成されたユーザーは、この設定がtrueの場合でも
  #   アクセスを保持します。
  #
  # - false: すべてのユーザーがアプリケーションにアクセスできます。
  #   個別のアサインメントは不要です。
  #
  # 型: bool
  #
  # 注意:
  #   - グループへの直接アサインメントが推奨されます（管理が容易なため）
  #   - ネストされたグループはサポートされていません
  #   - ユーザーは所属する直接のグループに対してアサインされる必要があります
  #
  # 例:
  #   assignment_required = true   # デフォルト: 明示的なアサインメントが必要
  #   assignment_required = false  # すべてのユーザーがアクセス可能
  assignment_required = null

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # region - (Optional) このリソースが管理されるリージョン
  #
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定で指定されたリージョンが使用されます。
  #
  # 型: string
  # Computed: true（省略時は自動的に設定される）
  #
  # 参考:
  #   - AWSリージョナルエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #   - プロバイダー設定: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # 例:
  #   region = "us-east-1"
  #   region = "ap-northeast-1"
  region = null
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします（参照のみ、入力不可）:
#
# - id - アプリケーションのARN（非推奨: Deprecatedのため将来的に削除される可能性があります）
#
# 使用例:
#   output "application_assignment_config_id" {
#     value = aws_ssoadmin_application_assignment_configuration.example.id
#   }
#
#---------------------------------------------------------------
