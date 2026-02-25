#---------------------------------------------------------------
# AWS IAM Identity Center Identity Store グループメンバーシップ
#---------------------------------------------------------------
#
# AWS IAM Identity Center（旧AWS SSO）のIdentity Storeにおいて、
# ユーザーをグループに追加するグループメンバーシップをプロビジョニングするリソースです。
# グループメンバーシップを通じて、ユーザーはグループに割り当てられた
# AWSアカウントやアプリケーションへのアクセス権限を継承します。
#
# AWS公式ドキュメント:
#   - グループへのユーザー追加: https://docs.aws.amazon.com/singlesignon/latest/userguide/adduserstogroups.html
#   - Identity Store API リファレンス: https://docs.aws.amazon.com/singlesignon/latest/IdentityStoreAPIReference/API_CreateGroupMembership.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group_membership
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_identitystore_group_membership" "example" {
  #-------------------------------------------------------------
  # Identity Store設定
  #-------------------------------------------------------------

  # identity_store_id (Required)
  # 設定内容: AWS SSOインスタンスに関連付けられたIdentity StoreのIDを指定します。
  # 設定可能な値: 有効なIdentity Store ID文字列（例: d-1234567890）
  # 参考: https://docs.aws.amazon.com/singlesignon/latest/userguide/manage-your-identity-source-sso.html
  identity_store_id = "d-1234567890"

  #-------------------------------------------------------------
  # グループ設定
  #-------------------------------------------------------------

  # group_id (Required)
  # 設定内容: ユーザーを追加するIdentity Store内のグループIDを指定します。
  # 設定可能な値: 有効なグループID文字列（aws_identitystore_groupリソースのgroup_id属性等）
  # 参考: https://docs.aws.amazon.com/singlesignon/latest/IdentityStoreAPIReference/API_CreateGroupMembership.html
  group_id = "1234a5b6-78cd-90e1-f23g-456h7890ij12"

  #-------------------------------------------------------------
  # メンバー設定
  #-------------------------------------------------------------

  # member_id (Required)
  # 設定内容: グループに追加するIdentity Store内のユーザーIDを指定します。
  # 設定可能な値: 有効なユーザーID文字列（aws_identitystore_userリソースのuser_id属性等）
  # 参考: https://docs.aws.amazon.com/singlesignon/latest/IdentityStoreAPIReference/API_CreateGroupMembership.html
  member_id = "1234a5b6-78cd-90e1-f23g-456h7890ij12"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - membership_id: Identity Store内に新規作成されたグループメンバーシップの識別子
#---------------------------------------------------------------
