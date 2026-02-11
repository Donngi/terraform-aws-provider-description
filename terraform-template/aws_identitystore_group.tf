#---------------------------------------------------------------
# IAM Identity Center (IdC) Group
#---------------------------------------------------------------
#
# AWS IAM Identity Center (旧AWS SSO) のIdentity Storeでグループを作成・管理します。
# グループを作成することで、ユーザーをまとめて管理し、AWSアカウントやアプリケーションへの
# アクセス権限を効率的に割り当てることができます。
#
# AWS公式ドキュメント:
#   - Add groups to your Identity Center directory:
#     https://docs.aws.amazon.com/singlesignon/latest/userguide/addgroups.html
#   - CreateGroup API Reference:
#     https://docs.aws.amazon.com/singlesignon/latest/IdentityStoreAPIReference/API_CreateGroup.html
#   - IAM Identity Center User Guide:
#     https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_identitystore_group" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # Identity Storeの一意識別子
  # IAM Identity Centerインスタンスに関連付けられたIdentity Storeのグローバル一意識別子です。
  # data.aws_ssoadmin_instances リソースから取得できます。
  #
  # 例: "d-1234567890"
  identity_store_id = "IDENTITY_STORE_ID"

  # グループの表示名
  # グループが参照されるときに一般的に表示される名前を含む文字列です。
  # この名前はIdentity Center内でグループを識別するために使用されます。
  #
  # 例: "Developers", "Administrators", "ReadOnlyUsers"
  display_name = "GROUP_DISPLAY_NAME"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # グループの説明
  # グループの目的や役割を説明する文字列です。
  # このグループにどのような権限が割り当てられているか、または割り当てられる予定かを
  # 記述することが推奨されます。
  #
  # 例: "Development team members with full access to dev environments"
  # description = "GROUP_DESCRIPTION"

  # リージョン指定
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # IAM Identity Centerはグローバルサービスですが、データはリージョンに保存されます。
  #
  # 例: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"

  # リソースID（上級者向け）
  # 外部IDプロバイダーによってこのリソースに発行された識別子です。
  # 通常は指定不要で、Terraformが自動的に管理します。
  # 既存のグループをインポートする場合などに使用することがあります。
  # Computed属性としても機能するため、指定しない場合は自動生成されます。
  # id = "GROUP_ID"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
#
# この設定後、以下の属性が参照可能になります:
#
# - arn
#   グループのAmazon Resource Name (ARN)
#   例: aws_identitystore_group.example.arn
#
# - group_id
#   Identity Store内で新しく作成されたグループの識別子
#   グループメンバーシップの管理など、他のリソースで参照する際に使用します。
#   例: aws_identitystore_group.example.group_id
#
# - external_ids
#   外部IDプロバイダーによって発行された識別子のリスト
#   各要素は以下の属性を持ちます:
#   - id: 外部IDプロバイダーによって発行されたID
#   - issuer: 外部識別子の発行者
#   例: aws_identitystore_group.example.external_ids
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Example Usage
#---------------------------------------------------------------
#
# # IAM Identity CenterのインスタンスIDとIdentity Store IDを取得
# data "aws_ssoadmin_instances" "example" {}
#
# # グループの作成
# resource "aws_identitystore_group" "developers" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
#   display_name      = "Developers"
#   description       = "Development team with access to dev/staging environments"
# }
#
# # グループIDの出力
# output "developers_group_id" {
#   value       = aws_identitystore_group.developers.group_id
#   description = "The ID of the Developers group"
# }
#
#---------------------------------------------------------------
