#---------------------------------------------------------------
# IAM Service-Linked Role
#---------------------------------------------------------------
#
# IAMサービスにリンクされたロール（Service-Linked Role）をプロビジョニングする。
# サービスにリンクされたロールは、特定のAWSサービスに直接リンクされたIAMロールで、
# サービスがアカウントに代わって他のAWSサービスを呼び出すために使用される。
# ロールのポリシーはサービスによって事前定義されており、編集はできないが削除は可能。
#
# AWS公式ドキュメント:
#   - Create a service-linked role: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create-service-linked-role.html
#   - Using service-linked roles: https://docs.aws.amazon.com/IAM/latest/UserGuide/using-service-linked-roles.html
#   - CreateServiceLinkedRole API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateServiceLinkedRole.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_service_linked_role" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # AWSサービス名（必須、変更時に再作成）
  # このロールがアタッチされるAWSサービスを指定する。
  # URL形式に似た文字列を使用するが、先頭の http:// は含めない。
  # 例: "elasticbeanstalk.amazonaws.com"
  # サービスにリンクされたロールをサポートするサービスの完全なリストは以下を参照:
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_aws-services-that-work-with-iam.html
  aws_service_name = "elasticbeanstalk.amazonaws.com"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # カスタムサフィックス（オプション、変更時に再作成）
  # ロール名に追加される文字列。
  # すべてのAWSサービスがカスタムサフィックスをサポートしているわけではない。
  # 例: "my-custom-suffix"
  # custom_suffix = null

  # 説明（オプション）
  # ロールの説明。
  # 作成後も変更可能。
  # description = null

  # タグ（オプション）
  # IAMロールに適用するキー・バリューペアのタグ。
  # プロバイダーの default_tags 設定ブロックが存在する場合、
  # マッチするキーのタグはプロバイダーレベルで定義されたものを上書きする。
  # tags = {}

  #---------------------------------------------------------------
  # Computed-Only Attributes (自動生成される属性)
  #---------------------------------------------------------------
  # 以下の属性は Terraform によって自動的に設定され、読み取り専用です。
  # リソース作成後に参照可能です。
  #
  # - id          : ロールのAmazon Resource Name (ARN)
  # - arn         : ロールを特定するAmazon Resource Name (ARN)
  # - create_date : IAMロールの作成日時
  # - name        : ロールの名前（サービスとサフィックスから自動生成）
  # - path        : ロールのパス
  # - unique_id   : ロールを識別する安定した一意の文字列
  # - tags_all    : リソースに割り当てられたすべてのタグ（provider default_tags を含む）
  #---------------------------------------------------------------
}

#---------------------------------------------------------------
# Outputs (参照例)
#---------------------------------------------------------------

# output "service_linked_role_arn" {
#   description = "Service-linked role ARN"
#   value       = aws_iam_service_linked_role.example.arn
# }
#
# output "service_linked_role_name" {
#   description = "Service-linked role name"
#   value       = aws_iam_service_linked_role.example.name
# }
#
# output "service_linked_role_unique_id" {
#   description = "Service-linked role unique ID"
#   value       = aws_iam_service_linked_role.example.unique_id
# }
