#---------------------------------------------------------------
# VPC IPAM Organization Admin Account
#---------------------------------------------------------------
#
# VPC IPAMサービスを有効化し、委任管理者（Delegated Administrator）を
# 設定するためのリソースです。AWS OrganizationsにおけるIPAM管理の
# 委任を行い、指定したメンバーアカウントにIPAM管理権限を付与します。
#
# AWS公式ドキュメント:
#   - IPAM とは: https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
#   - IPAM の委任管理者: https://docs.aws.amazon.com/vpc/latest/ipam/enable-integ-ipam.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_organization_admin_account
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_ipam_organization_admin_account" "example" {
  #---------------------------------------------------------------
  # 委任管理者設定
  #---------------------------------------------------------------

  # delegated_admin_account_id (Required)
  # 設定内容: IPAM管理を委任するAWS OrganizationsメンバーアカウントのIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 関連機能: IPAM 委任管理者
  #   指定されたアカウントがIPAMサービスの委任管理者として設定され、
  #   組織全体のIPAMリソース（プール、スコープ等）を管理可能になります。
  #   委任管理者は組織内の全アカウントのIPアドレス使用状況を可視化し、
  #   IPAM監査機能を利用できます。
  #   - https://docs.aws.amazon.com/vpc/latest/ipam/enable-integ-ipam.html
  # 注意: 1つのOrganizationにつき、IPAM委任管理者は1アカウントのみ設定可能です。
  delegated_admin_account_id = "123456789012"

  #---------------------------------------------------------------
  # リソースID設定（通常は指定不要）
  #---------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースのIDを明示的に指定します。
  # 省略時: delegated_admin_account_idと同じ値が自動的に設定されます。
  # 注意: 通常はTerraformによる自動管理を推奨します。明示的な指定は特殊なケースでのみ使用してください。
  # id = "123456789012"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性を出力します（computed）:
#
# - arn: 委任管理者アカウントのOrganizations ARN
#   例: arn:aws:organizations::123456789012:account/o-xxxxxxxxxxxx/123456789012
#
# - id: 委任管理者として設定されたAWSアカウントID
#   delegated_admin_account_idと同じ値
#
# - email: 委任管理者アカウントのOrganizationsメールアドレス
#
# - name: 委任管理者アカウントのOrganizations名
#
# - service_principal: AWSサービスプリンシパル
#   固定値: ipam.amazonaws.com
#
#---------------------------------------------------------------
# Usage Notes
#---------------------------------------------------------------
#
# 1. 前提条件:
#    - AWS Organizationsが有効化されていること
#---------------------------------------------------------------
