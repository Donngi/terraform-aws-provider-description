#---------------------------------------------------------------
# Amazon SES Receipt Rule Set
#---------------------------------------------------------------
#
# Amazon Simple Email Service (SES) の受信ルールセットをプロビジョニングするリソースです。
# 受信ルールセットは、検証済みドメインに対して受信したメールに対してAmazon SESが
# 実行するアクションを指定する受信ルールのコレクションです。
#
# 一度に有効化できる受信ルールセットは1つのみですが、記録保持やテスト目的で
# 複数のルールセットを作成することができます。
#
# AWS公式ドキュメント:
#   - SES受信ルールセットの作成: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-receipt-rule-set.html
#   - SES受信ルールセットの管理: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-managing-receipt-rule-sets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_receipt_rule_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ses_receipt_rule_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # rule_set_name (Required, Forces new resource)
  # 設定内容: 受信ルールセットの名前を指定します。
  # 設定可能な値: 文字列（1-64文字）。英数字、ハイフン、アンダースコアが使用可能
  # 注意: この属性を変更すると、リソースが再作成されます（Forces new resource）
  # 関連機能: SES受信ルールセット
  #   受信ルールセットは、検証済みドメインに受信したメールに対してSESが実行する
  #   アクションを定義します。一度に1つのルールセットのみをアクティブにできます。
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-receipt-rule-set.html
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
# - arn: SES受信ルールセットのAmazon Resource Name (ARN)
#        形式: arn:aws:ses:region:account-id:receipt-rule-set/rule-set-name
#
# - id: SES受信ルールセット名（rule_set_nameと同じ値）
#---------------------------------------------------------------
