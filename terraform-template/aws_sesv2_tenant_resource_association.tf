#---------------------------------------------------------------
# AWS SESv2 Tenant Resource Association
#---------------------------------------------------------------
#
# Amazon SES (Simple Email Service) v2のテナントリソース関連付けを管理するリソースです。
# SESリソース（設定セットなど）をテナントに関連付けることで、
# テナント内でのメール送信時に使用するリソースを制御できます。
# テナントを活用したマルチテナントメール送信環境において、
# 各テナントが利用できるリソースの範囲を定義する際に使用します。
#
# AWS公式ドキュメント:
#   - SESテナント管理: https://docs.aws.amazon.com/ses/latest/dg/tenants.html
#   - CreateTenantResourceAssociation API: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_CreateTenantResourceAssociation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_tenant_resource_association
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sesv2_tenant_resource_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # tenant_name (Required, Forces new resource)
  # 設定内容: 関連付け先のSESテナント名を指定します。
  # 設定可能な値: 既存のSESテナント名の文字列
  # 注意: テナント名を変更すると、既存の関連付けが削除され新しい関連付けが作成されます。
  # 参考: https://docs.aws.amazon.com/ses/latest/dg/tenants.html
  tenant_name = "my-tenant"

  # resource_arn (Required, Forces new resource)
  # 設定内容: テナントに関連付けるSESリソースのARNを指定します。
  # 設定可能な値: 有効なSESリソースのARN（例: 設定セットのARN）
  # 注意: リソースARNを変更すると、既存の関連付けが削除され新しい関連付けが作成されます。
  # 参考: https://docs.aws.amazon.com/ses/latest/dg/tenants.html
  resource_arn = "arn:aws:ses:us-east-1:123456789012:configuration-set/example"

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
# - tenant_name: 関連付けられたテナントの名前。
#
# - resource_arn: 関連付けられたSESリソースのARN。
#
# - region: リソースが管理されているリージョン。
#---------------------------------------------------------------
