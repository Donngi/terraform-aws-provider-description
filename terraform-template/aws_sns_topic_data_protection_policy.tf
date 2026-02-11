#---------------------------------------------------------------
# Amazon SNS Topic Data Protection Policy
#---------------------------------------------------------------
#
# Amazon SNSトピックのデータ保護ポリシーをプロビジョニングするリソースです。
# データ保護ポリシーを使用すると、トピックで送受信されるメッセージ内の
# 機密データ（個人識別情報、クレジットカード番号等）を検出し、
# 保護アクションを適用できます。
#
# AWS公式ドキュメント:
#   - SNS データ保護ポリシー: https://docs.aws.amazon.com/sns/latest/dg/sns-message-data-protection.html
#   - データ識別子: https://docs.aws.amazon.com/sns/latest/dg/sns-message-data-protection-data-identifiers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_data_protection_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sns_topic_data_protection_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # arn (Required)
  # 設定内容: データ保護ポリシーを適用するSNSトピックのARNを指定します。
  # 設定可能な値: 有効なSNSトピックのARN
  # 注意: ポリシーを適用する対象トピックを明確に指定する必要があります
  arn = "arn:aws:sns:ap-northeast-1:123456789012:example-topic"

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: SNSトピックのARNが自動的に設定されます
  # 注意: 通常は省略してTerraformに自動設定させることを推奨します
  id = null

  # policy (Required)
  # 設定内容: データ保護ポリシーの内容をJSON形式で指定します。
  # 設定可能な値: JSON形式のデータ保護ポリシードキュメント
  # ポリシー構造:
  #   - Name: ポリシーの名前（"__"で始まる必要があります）
  #   - Description: ポリシーの説明
  #   - Version: ポリシーのバージョン（現在は"2021-06-01"）
  #   - Statement: データ保護ステートメントの配列
  #     - Sid: ステートメントID
  #     - DataDirection: データの方向（"Inbound"または"Outbound"）
  #     - Principal: プリンシパル（通常は["*"]）
  #     - DataIdentifier: 検出するデータ識別子のARN配列
  #       例: "arn:aws:dataprotection::aws:data-identifier/EmailAddress"
  #     - Operation: 適用する保護アクション
  #       - Deny: データを拒否（メッセージをブロック）
  #       - Deidentify: データを匿名化
  # 関連機能: SNS データ保護ポリシー
  #   マネージドデータ識別子を使用して機密データを自動検出し、
  #   保護アクションを適用します。
  #   - https://docs.aws.amazon.com/sns/latest/dg/sns-message-data-protection.html
  # 参考: IAMポリシードキュメントの構築
  #   - https://learn.hashicorp.com/terraform/aws/iam-policy
  policy = jsonencode({
    Description = "Example data protection policy"
    Name        = "__example_data_protection_policy"
    Statement = [
      {
        DataDirection = "Inbound"
        DataIdentifier = [
          "arn:aws:dataprotection::aws:data-identifier/EmailAddress",
          "arn:aws:dataprotection::aws:data-identifier/CreditCardNumber",
        ]
        Operation = {
          Deny = {}
        }
        Principal = [
          "*",
        ]
        Sid = "__deny_statement_inbound"
      },
      {
        DataDirection = "Outbound"
        DataIdentifier = [
          "arn:aws:dataprotection::aws:data-identifier/EmailAddress",
        ]
        Operation = {
          Deidentify = {
            MaskConfig = {
              MaskWithCharacter = "*"
            }
          }
        }
        Principal = [
          "*",
        ]
        Sid = "__deidentify_statement_outbound"
      },
    ]
    Version = "2021-06-01"
  })

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
# - id: SNSトピックのARN
#---------------------------------------------------------------
