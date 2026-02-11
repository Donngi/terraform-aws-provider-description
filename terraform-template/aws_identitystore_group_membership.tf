#---------------------------------------------------------------
# IAM Identity Center (IdC) Group Membership
#---------------------------------------------------------------
#
# AWS IAM Identity Center (旧AWS SSO) のIdentity Storeでグループメンバーシップを作成・管理します。
# ユーザーをグループに追加することで、グループベースのアクセス制御を実現し、
# 組織内のアクセス権限管理を効率化できます。
#
# AWS公式ドキュメント:
#   - Add users to groups:
#     https://docs.aws.amazon.com/singlesignon/latest/userguide/adduserstogroups.html
#   - CreateGroupMembership API Reference:
#     https://docs.aws.amazon.com/singlesignon/latest/IdentityStoreAPIReference/API_CreateGroupMembership.html
#   - DescribeGroupMembership API Reference:
#     https://docs.aws.amazon.com/singlesignon/latest/IdentityStoreAPIReference/API_DescribeGroupMembership.html
#   - IAM Identity Center User Guide:
#     https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group_membership
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_identitystore_group_membership" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # Identity Storeの一意識別子
  # IAM Identity Centerインスタンスに関連付けられたIdentity Storeのグローバル一意識別子です。
  # data.aws_ssoadmin_instances リソースから取得できます。
  # グループとユーザーは同じIdentity Storeに存在する必要があります。
  #
  # 例: "d-1234567890"
  identity_store_id = "IDENTITY_STORE_ID"

  # グループID
  # ユーザーを追加するグループのIdentity Store内での一意識別子です。
  # aws_identitystore_group リソースの group_id 属性から取得できます。
  # 指定したグループが存在しない場合、エラーになります。
  #
  # 例: "12345678-abcd-1234-abcd-123456789012"
  group_id = "GROUP_ID"

  # メンバーID（ユーザーID）
  # グループに追加するユーザーのIdentity Store内での一意識別子です。
  # aws_identitystore_user リソースの user_id 属性から取得できます。
  # 指定したユーザーが存在しない場合、エラーになります。
  #
  # 例: "87654321-dcba-4321-dcba-210987654321"
  member_id = "MEMBER_ID"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # リージョン指定
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # IAM Identity Centerはグローバルサービスですが、Identity Store IDと同じリージョンを指定してください。
  #
  # 例: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
#
# この設定後、以下の属性が参照可能になります:
#
# - membership_id
#   Identity Store内で新しく作成されたグループメンバーシップの一意識別子
#   このメンバーシップを直接参照する際に使用します。
#   例: aws_identitystore_group_membership.example.membership_id
#
# - id
#   Terraformリソースの内部識別子
#   形式: "{identity_store_id}/{membership_id}"
#   Terraformのstate管理に使用されます。
#   例: aws_identitystore_group_membership.example.id
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Example Usage
#---------------------------------------------------------------
#
# # IAM Identity CenterのインスタンスIDとIdentity Store IDを取得
# data "aws_ssoadmin_instances" "example" {}
#
# # ユーザーを作成
# resource "aws_identitystore_user" "john" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
#   user_name         = "john.doe@example.com"
#   display_name      = "John Doe"
#
#   name {
#     family_name = "Doe"
#     given_name  = "John"
#   }
# }
#
# # グループを作成
# resource "aws_identitystore_group" "developers" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
#   display_name      = "Developers"
#   description       = "Development team members"
# }
#
# # ユーザーをグループに追加
# resource "aws_identitystore_group_membership" "john_developers" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
#   group_id          = aws_identitystore_group.developers.group_id
#   member_id         = aws_identitystore_user.john.user_id
# }
#
# # 複数ユーザーをグループに追加する例
# locals {
#   user_emails = [
#     "alice@example.com",
#     "bob@example.com",
#     "carol@example.com"
#   ]
# }
#
# resource "aws_identitystore_user" "team_members" {
#   for_each = toset(local.user_emails)
#
#   identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
#   user_name         = each.value
#   display_name      = split("@", each.value)[0]
#
#   name {
#     family_name = split("@", each.value)[0]
#     given_name  = split("@", each.value)[0]
#   }
# }
#
# resource "aws_identitystore_group_membership" "team_members" {
#   for_each = aws_identitystore_user.team_members
#
#   identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
#   group_id          = aws_identitystore_group.developers.group_id
#   member_id         = each.value.user_id
# }
#
# # メンバーシップIDの出力
# output "membership_id" {
#   value       = aws_identitystore_group_membership.john_developers.membership_id
#   description = "The membership ID for John in the Developers group"
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
#
# 既存のグループメンバーシップは以下の形式でインポートできます:
#
# terraform import aws_identitystore_group_membership.example <identity_store_id>/<membership_id>
#
# 例:
# terraform import aws_identitystore_group_membership.john_developers d-1234567890/12345678-1234-1234-1234-123456789012
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Notes
#---------------------------------------------------------------
#
# - 同じユーザーを複数のグループに追加することができます
# - ユーザーが既にグループのメンバーである場合、ConflictExceptionエラーが発生します
# - メンバーシップを削除すると、ユーザーはグループから削除されます
# - グループまたはユーザーを削除すると、関連するメンバーシップも自動的に削除されます
# - メンバーシップの変更はCloudTrailで自動的に記録されます
#
#---------------------------------------------------------------
