#---------------------------------------------------------------
# Amazon SES Active Receipt Rule Set
#---------------------------------------------------------------
#
# Amazon Simple Email Service (SES) でアクティブな受信ルールセットを
# 管理するリソースです。一度に有効化できる受信ルールセットは1つのみです。
#
# このリソースは既存の受信ルールセット（aws_ses_receipt_rule_set）を
# アクティブに指定するために使用します。
# アカウント内で一度に有効にできるルールセットは1つのみのため、
# 複数のリージョンやアカウントで管理する場合は注意が必要です。
#
# AWS公式ドキュメント:
#   - SES受信ルールセットのアクティブ化: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-managing-receipt-rule-sets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_active_receipt_rule_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ses_active_receipt_rule_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # rule_set_name (Required)
  # 設定内容: アクティブにする受信ルールセットの名前を指定します。
  # 設定可能な値: 既存の aws_ses_receipt_rule_set リソースの rule_set_name に対応する文字列
  # 注意: アカウントとリージョン内で一度に有効にできるルールセットは1つのみです。
  #       Terraform管理外でルールセットが変更された場合、差分が発生することがあります。
  rule_set_name = "primary-rules"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Amazon SESのメール受信機能は一部のリージョンでのみ利用可能です
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: アクティブな受信ルールセットのAmazon Resource Name (ARN)
#        形式: arn:aws:ses:region:account-id:receipt-rule-set/rule-set-name
#
# - id: アクティブな受信ルールセット名（rule_set_nameと同じ値）
#---------------------------------------------------------------
