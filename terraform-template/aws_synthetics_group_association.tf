#---------------------------------------------------------------
# CloudWatch Synthetics Group Association
#---------------------------------------------------------------
#
# Amazon CloudWatch Syntheticsのカナリアをグループに関連付けるリソースです。
# カナリアをグループに関連付けることで、複数のカナリアを論理的に整理し、
# まとめて管理・監視することができます。
#
# AWS公式ドキュメント:
#   - CloudWatch Synthetics概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Canaries.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_group_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_synthetics_group_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # group_name (Required)
  # 設定内容: カナリアを関連付けるグループの名前を指定します。
  # 設定可能な値: 既存のSyntheticsグループの名前
  # 注意: グループは事前に作成されている必要があります（aws_synthetics_groupリソース）
  group_name = aws_synthetics_group.example.name

  # canary_arn (Required)
  # 設定内容: グループに関連付けるカナリアのARNを指定します。
  # 設定可能な値: 有効なSyntheticsカナリアのARN
  # 形式例: "arn:aws:synthetics:region:account-id:canary:canary-name"
  # 注意: カナリアは事前に作成されている必要があります（aws_synthetics_canaryリソース）
  canary_arn = aws_synthetics_canary.example.arn

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ID設定（通常は省略）
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: Terraformリソースの識別子を指定します。
  # 省略時: Terraformが自動的に生成します
  # 注意: 通常は指定不要。インポート時など特殊なケースのみ使用
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - group_name: グループの名前
#
# - group_id: グループのID
#
# - group_arn: グループのAmazon Resource Name (ARN)
#---------------------------------------------------------------
