#---------------------------------------------------------------
# AWS SSO Admin Account Assignment
#---------------------------------------------------------------
#
# AWS IAM Identity Center（旧 AWS SSO）のアカウント割り当てをプロビジョニングするリソースです。
# アカウント割り当てとは、指定したプリンシパル（ユーザーまたはグループ）に対して、
# 特定の AWS アカウントへのアクセス権限セットを割り当てる設定です。
#
# 主なユースケース:
#   - 開発チームのグループに開発アカウントへのアクセスを許可する
#   - 管理者ユーザーに本番アカウントへの管理権限を付与する
#   - 監査チームに複数アカウントへの読み取り専用アクセスを付与する
#   - 自動化スクリプト用ユーザーに特定アカウントへのアクセスを付与する
#
# 重要な注意事項:
#   - instance_arn、permission_set_arn、principal_id、target_id は全て変更不可（Forces new resource）です。
#     変更する場合は既存リソースを削除し再作成する必要があります。
#   - aws_ssoadmin_managed_policy_attachment と組み合わせて使用する場合、
#     depends_on を明示的に設定して削除順序を制御してください。
#   - principal_id は Identity Store のグループIDまたはユーザーID（GUID形式）です。
#
# AWS公式ドキュメント:
#   - IAM Identity Center アカウント割り当て:
#       https://docs.aws.amazon.com/singlesignon/latest/userguide/manage-your-accounts.html
#   - IAM Identity Center とは:
#       https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ssoadmin_account_assignment
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_account_assignment" "example" {
  #---------------------------------------------------------------
  # SSO インスタンス設定
  #---------------------------------------------------------------

  # instance_arn (Required, Forces new resource)
  # 設定内容: SSO インスタンスの ARN を指定します。
  # 設定可能な値: IAM Identity Center インスタンスの ARN 文字列
  # 省略時: 設定必須
  #
  # 取得方法: data "aws_ssoadmin_instances" を使用して ARN を取得できます。
  #   例: tolist(data.aws_ssoadmin_instances.example.arns)[0]
  instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef"

  #---------------------------------------------------------------
  # 権限セット設定
  #---------------------------------------------------------------

  # permission_set_arn (Required, Forces new resource)
  # 設定内容: プリンシパルに付与する権限セットの ARN を指定します。
  # 設定可能な値: aws_ssoadmin_permission_set リソースまたは data "aws_ssoadmin_permission_set" で取得した ARN
  # 省略時: 設定必須
  permission_set_arn = "arn:aws:sso:::permissionSet/ssoins-1234567890abcdef/ps-1234567890abcdef"

  #---------------------------------------------------------------
  # プリンシパル設定
  #---------------------------------------------------------------

  # principal_id (Required, Forces new resource)
  # 設定内容: アクセスを付与するプリンシパルの ID を指定します。
  # 設定可能な値: Identity Store のユーザー ID またはグループ ID（GUID形式）
  # 省略時: 設定必須
  #
  # 取得方法:
  #   - グループ: data "aws_identitystore_group" の group_id 属性
  #   - ユーザー: data "aws_identitystore_user" の user_id 属性
  #   例（GUID形式）: "f81d4fae-7dec-11d0-a765-00a0c91e6bf6"
  principal_id = "f81d4fae-7dec-11d0-a765-00a0c91e6bf6"

  # principal_type (Required, Forces new resource)
  # 設定内容: プリンシパルのエンティティタイプを指定します。
  # 設定可能な値: "USER" / "GROUP"
  # 省略時: 設定必須
  principal_type = "GROUP"

  #---------------------------------------------------------------
  # ターゲット設定
  #---------------------------------------------------------------

  # target_id (Required, Forces new resource)
  # 設定内容: アクセスを付与する AWS アカウント ID を指定します。
  # 設定可能な値: 12桁の AWS アカウント ID 文字列
  # 省略時: 設定必須
  target_id = "123456789012"

  # target_type (Required, Forces new resource)
  # 設定内容: ターゲットのエンティティタイプを指定します。
  # 設定可能な値: "AWS_ACCOUNT"
  # 省略時: 設定必須
  target_type = "AWS_ACCOUNT"

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: AWS リージョンコード文字列（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンが使用されます
  region = null

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: Goの時間形式文字列（例: "5m", "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = "5m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: Goの時間形式文字列（例: "5m", "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id
#     アカウント割り当ての識別子。principal_id、principal_type、target_id、
#     target_type、permission_set_arn、instance_arn をカンマ区切りで結合した文字列。
#     例: "f81d4fae-7dec-11d0-a765-00a0c91e6bf6,GROUP,123456789012,AWS_ACCOUNT,
#          arn:aws:sso:::permissionSet/ssoins-xxx/ps-xxx,arn:aws:sso:::instance/ssoins-xxx"
#
