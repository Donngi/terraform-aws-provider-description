#---------------------------------------------------------------
# AWS IAM Identity Center IdentityStore Group
#---------------------------------------------------------------
#
# AWS IAM Identity Center（旧AWS SSO）のIdentity Storeにグループを
# プロビジョニングするリソースです。グループはユーザーをまとめて管理し、
# AWSアカウントやアプリケーションへのアクセス権限を一括して割り当てるために使用します。
#
# AWS公式ドキュメント:
#   - IAM Identity Center グループの追加: https://docs.aws.amazon.com/singlesignon/latest/userguide/addgroups.html
#   - IAM Identity Center の概念: https://docs.aws.amazon.com/singlesignon/latest/userguide/organization-instances-identity-center.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_identitystore_group" "example" {
  #-------------------------------------------------------------
  # Identity Store 設定
  #-------------------------------------------------------------

  # identity_store_id (Required)
  # 設定内容: グループを作成するIdentity StoreのグローバルユニークIDを指定します。
  # 設定可能な値: IAM Identity Centerのインスタンスに関連付けられたIdentity Store ID
  # 参考: data.aws_ssoadmin_instances を使用して取得可能
  #   例: tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
  identity_store_id = "d-1234567890"

  #-------------------------------------------------------------
  # グループ基本設定
  #-------------------------------------------------------------

  # display_name (Required)
  # 設定内容: グループの表示名を指定します。グループを参照する際に表示される名前です。
  # 設定可能な値: 文字列
  display_name = "example-group"

  # description (Optional)
  # 設定内容: グループの説明文を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なしでグループが作成されます。
  description = "Example group for managing access to AWS resources"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: グループのAmazon Resource Name (ARN)
#
# - group_id: Identity Store内で新しく作成されたグループの識別子
#
# - external_ids: 外部IDプロバイダーによってこのリソースに付与された識別子のリスト。
#                 各エントリは以下のフィールドを持ちます:
#                 - id: 外部IDプロバイダーから発行された識別子
#                 - issuer: 外部識別子の発行者
#---------------------------------------------------------------
