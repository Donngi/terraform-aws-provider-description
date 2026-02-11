#---------------------------------------------------------------
# AWS SSO Admin Application Assignment
#---------------------------------------------------------------
#
# AWS IAM Identity Center (旧AWS SSO) のアプリケーションに対するユーザーまたは
# グループの割り当てをプロビジョニングするリソースです。
# これにより、Identity Centerで管理されるアプリケーションへのアクセス権限を
# 特定のユーザーやグループに付与できます。
#
# AWS公式ドキュメント:
#   - IAM Identity Center概要: https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html
#   - アプリケーション割り当ての管理: https://docs.aws.amazon.com/singlesignon/latest/userguide/assignuserstoapp.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_application_assignment
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_application_assignment" "example" {
  #-------------------------------------------------------------
  # アプリケーション設定
  #-------------------------------------------------------------

  # application_arn (Required)
  # 設定内容: アクセス権限を付与するアプリケーションのARNを指定します。
  # 設定可能な値: 有効なIAM Identity Centerアプリケーション ARN
  # 関連機能: IAM Identity Center アプリケーション
  #   Identity Centerで管理されるアプリケーションのリソース識別子です。
  #   aws_ssoadmin_applicationリソースから取得可能です。
  #   - https://docs.aws.amazon.com/singlesignon/latest/userguide/manage-your-applications.html
  application_arn = "arn:aws:sso::123456789012:application/ssoins-1234567890abcdef/apl-1234567890abcdef"

  #-------------------------------------------------------------
  # プリンシパル設定
  #-------------------------------------------------------------

  # principal_id (Required)
  # 設定内容: IAM Identity Centerのオブジェクト識別子を指定します。
  # 設定可能な値: IAM Identity Centerのユーザーまたはグループの一意のID
  #   - ユーザーの場合: aws_identitystore_userリソースのuser_id
  #   - グループの場合: aws_identitystore_groupリソースのgroup_id
  # 関連機能: IAM Identity Center Identity Store
  #   Identity Centerで管理されるユーザーとグループの識別子です。
  #   Identity Storeから取得したIDを使用します。
  #   - https://docs.aws.amazon.com/singlesignon/latest/userguide/manage-your-identity-source.html
  principal_id = "12345678-1234-1234-1234-123456789012"

  # principal_type (Required)
  # 設定内容: 割り当て対象のエンティティタイプを指定します。
  # 設定可能な値:
  #   - "USER": ユーザーに対する割り当て
  #   - "GROUP": グループに対する割り当て
  # 注意: principal_idで指定したIDのタイプと一致している必要があります
  principal_type = "USER"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: グローバルリソースのリージョナル管理
  #   IAM Identity Centerはグローバルサービスですが、
  #   リソースの管理はリージョナルで行われます。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: application_arn、principal_id、principal_typeをカンマ区切りで
#       連結した文字列。
#---------------------------------------------------------------
