#---------------------------------------------------------------
# AWS IAM Identity Center (SSO) Account Assignment
#---------------------------------------------------------------
#
# AWS IAM Identity Center（旧AWS SSO）のアカウント割り当てをプロビジョニングします。
# このリソースは、特定のユーザーまたはグループに対して、指定したAWSアカウントへの
# アクセス権限（Permission Set）を付与します。
#
# AWS公式ドキュメント:
#   - IAM Identity Center Account Assignment: https://docs.aws.amazon.com/singlesignon/latest/userguide/useraccess.html
#   - CreateAccountAssignment API: https://docs.aws.amazon.com/singlesignon/latest/APIReference/API_CreateAccountAssignment.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_account_assignment" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # instance_arn - (必須) SSO インスタンスのARN
  # IAM Identity CenterインスタンスのAmazon Resource Name (ARN)を指定します。
  # このインスタンスARNは、aws_ssoadmin_instancesデータソースから取得できます。
  # 変更すると新しいリソースが作成されます（Forces new resource）。
  #
  # 例: "arn:aws:sso:::instance/ssoins-0123456789abcdef"
  instance_arn = null

  # permission_set_arn - (必須) Permission SetのARN
  # 管理者がプリンシパル（ユーザーまたはグループ）に付与したいPermission SetのARNを指定します。
  # Permission Setは、AWSアカウントへのアクセス権限を定義します。
  # 変更すると新しいリソースが作成されます（Forces new resource）。
  #
  # 例: "arn:aws:sso:::permissionSet/ssoins-0123456789abcdef/ps-0123456789abcdef"
  permission_set_arn = null

  # principal_id - (必須) プリンシパルID
  # IAM Identity Centerのオブジェクト（ユーザーまたはグループ）の識別子を指定します。
  # プリンシパルIDはGUID形式です（例: f81d4fae-7dec-11d0-a765-00a0c91e6bf6）。
  # aws_identitystore_userまたはaws_identitystore_groupデータソースから取得できます。
  # 変更すると新しいリソースが作成されます（Forces new resource）。
  #
  # 例: "f81d4fae-7dec-11d0-a765-00a0c91e6bf6"
  principal_id = null

  # principal_type - (必須) プリンシパルタイプ
  # 割り当てを作成するエンティティタイプを指定します。
  # 有効な値: USER（ユーザー）、GROUP（グループ）
  # 変更すると新しいリソースが作成されます（Forces new resource）。
  #
  # 例: "GROUP"
  principal_type = null

  # target_id - (必須) ターゲットID
  # AWSアカウント識別子を指定します。通常は10-12桁の数字です。
  # このアカウントに対してプリンシパルがアクセス権限を持つことになります。
  # 変更すると新しいリソースが作成されます（Forces new resource）。
  #
  # 例: "123456789012"
  target_id = null

  # target_type - (必須) ターゲットタイプ
  # 割り当てを作成するエンティティタイプを指定します。
  # 有効な値: AWS_ACCOUNT
  # 変更すると新しいリソースが作成されます（Forces new resource）。
  #
  # 例: "AWS_ACCOUNT"
  target_type = null

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # id - (オプション) リソース識別子
  # Account Assignmentの識別子。以下の値がカンマ（,）で区切られた形式で自動生成されます：
  # principal_id, principal_type, target_id, target_type, permission_set_arn, instance_arn
  # 通常は明示的に指定する必要はありません。
  # Computed属性でもあるため、指定しない場合は自動的に設定されます。
  #
  # 例: "f81d4fae-7dec-11d0-a765-00a0c91e6bf6,GROUP,123456789012,AWS_ACCOUNT,arn:aws:sso:::permissionSet/...,arn:aws:sso:::instance/..."
  # id = null

  # region - (オプション) リージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # Computed属性でもあるため、指定しない場合は自動的に設定されます。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # 例: "us-east-1"
  # region = null

  #---------------------------------------------------------------
  # タイムアウト設定（オプション）
  #---------------------------------------------------------------

  # timeouts {
  #   # create - (オプション) 作成時のタイムアウト
  #   # Account Assignmentの作成操作に対するタイムアウトを指定します。
  #   # デフォルトは適切な値が設定されています。
  #   #
  #   # 例: "10m"（10分）
  #   # create = null
  #
  #   # delete - (オプション) 削除時のタイムアウト
  #   # Account Assignmentの削除操作に対するタイムアウトを指定します。
  #   # デフォルトは適切な値が設定されています。
  #   #
  #   # 例: "10m"（10分）
  #   # delete = null
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# このリソースが作成された後、以下の属性を参照できます：
#
# - id: Account Assignmentの一意の識別子
#   形式: principal_id,principal_type,target_id,target_type,permission_set_arn,instance_arn
#
# - region: リソースが管理されているAWSリージョン
#
#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# # 基本的な使用例
# data "aws_ssoadmin_instances" "example" {}
#
# data "aws_ssoadmin_permission_set" "example" {
#   instance_arn = tolist(data.aws_ssoadmin_instances.example.arns)[0]
#   name         = "AWSReadOnlyAccess"
# }
#
# data "aws_identitystore_group" "example" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
#
#   alternate_identifier {
#     unique_attribute {
#       attribute_path  = "DisplayName"
#       attribute_value = "ExampleGroup"
#     }
#   }
# }
#
# resource "aws_ssoadmin_account_assignment" "example" {
#   instance_arn       = tolist(data.aws_ssoadmin_instances.example.arns)[0]
#   permission_set_arn = data.aws_ssoadmin_permission_set.example.arn
#
#   principal_id   = data.aws_identitystore_group.example.group_id
#   principal_type = "GROUP"
#
#   target_id   = "123456789012"
#   target_type = "AWS_ACCOUNT"
# }
#
#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
#
# 1. Forces new resource: 以下のパラメータを変更すると、リソースが削除され再作成されます：
#    - instance_arn
#    - permission_set_arn
#    - principal_id
#    - principal_type
#    - target_id
#    - target_type
#
# 2. Managed Policy Attachment との依存関係:
#    aws_ssoadmin_managed_policy_attachmentリソースと併用する場合、
#    明示的な依存関係（depends_on）を設定することで、安全な削除順序を保証できます。
#
# 3. プリンシパルIDの取得:
#    ユーザーIDやグループIDは、aws_identitystore_userまたは
#    aws_identitystore_groupデータソースを使用して取得します。
#
# 4. Permission Setの事前作成:
#    Account Assignmentを作成する前に、Permission Setが存在している必要があります。
#    aws_ssoadmin_permission_setリソースまたはデータソースを使用してください。
#
#---------------------------------------------------------------
