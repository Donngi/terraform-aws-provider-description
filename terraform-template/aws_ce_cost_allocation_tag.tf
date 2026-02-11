#---------------------------------------------------------------
# AWS CE Cost Allocation Tag
#---------------------------------------------------------------
#
# AWS Cost Explorerのコスト配分タグをプロビジョニングするリソースです。
# コスト配分タグを有効化（Active）または無効化（Inactive）することで、
# AWS Cost and Usage ReportやCost Explorerでコストをタグ別に
# 追跡・分析できるようになります。
#
# AWS公式ドキュメント:
#   - コスト配分タグの概要: https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/cost-alloc-tags.html
#   - ユーザー定義タグの使用: https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/custom-tags.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ce_cost_allocation_tag
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ce_cost_allocation_tag" "example" {
  #-------------------------------------------------------------
  # タグキー設定
  #-------------------------------------------------------------

  # tag_key (Required)
  # 設定内容: コスト配分タグのキー名を指定します。
  # 設定可能な値: 既存のAWSリソースタグのキー名
  # 注意: タグキーはAWSリソースに事前に適用されている必要があります。
  #       タグが存在しない場合、コスト配分タグとして有効化できません。
  # 関連機能: AWSコスト配分タグ
  #   リソースにタグを適用後、Billing and Cost Managementコンソールで
  #   コスト配分タグとして有効化することで、コストレポートで使用可能になります。
  #   - https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/cost-alloc-tags.html
  tag_key = "Environment"

  #-------------------------------------------------------------
  # ステータス設定
  #-------------------------------------------------------------

  # status (Required)
  # 設定内容: コスト配分タグのステータスを指定します。
  # 設定可能な値:
  #   - "Active": タグをコスト配分に使用可能にします。
  #               Cost Explorer、AWS Budgets、コスト配分レポートで使用できます。
  #   - "Inactive": タグをコスト配分から除外します。
  #                 有効化されていないタグはコストレポートに表示されません。
  # 注意: ステータス変更後、Cost Explorerやレポートに反映されるまで
  #       最大24時間かかる場合があります。
  # 関連機能: コスト配分タグの有効化
  #   管理アカウントまたは単独アカウントのみがコスト配分タグを
  #   管理できます。組織のメンバーアカウントには権限がありません。
  #   - https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/custom-tags.html
  status = "Active"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: コスト配分タグのキー名（tag_keyと同じ値）
#
# - type: コスト配分タグのタイプ
#         "AWSGenerated"（AWS生成タグ）または"UserDefined"（ユーザー定義タグ）
#         を返します。
#---------------------------------------------------------------
