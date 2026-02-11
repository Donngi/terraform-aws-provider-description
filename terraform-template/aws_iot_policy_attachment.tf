#---------------------------------------------------------------
# AWS IoT Policy Attachment
#---------------------------------------------------------------
#
# IoTポリシーをプリンシパル（証明書やその他の認証情報）にアタッチする
# リソース。IoTデバイスがAWS IoT Coreと通信するには、証明書に対して
# 適切な権限を持つポリシーをアタッチする必要があります。
#
# AWS公式ドキュメント:
#   - Attach a thing or policy to a client certificate: https://docs.aws.amazon.com/iot/latest/developerguide/attach-to-cert.html
#   - AttachPolicy API: https://docs.aws.amazon.com/iot/latest/apireference/API_AttachPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_policy_attachment" "example" {
  #---------------------------------------------------------------
  # ポリシー設定
  #---------------------------------------------------------------

  # policy (Required)
  # 設定内容: アタッチするIoTポリシーの名前を指定します。
  # 設定可能な値: 既存のIoTポリシー名（文字列）
  # 関連機能: AWS IoT Policy
  #   IoTポリシーは、デバイスがAWS IoT Coreで実行できるアクションを定義します。
  #   ポリシーはJSON形式で記述され、AWS IAMポリシーと似た構造を持ちます。
  #   デバイスが接続、パブリッシュ、サブスクライブできるリソースとアクションを制御します。
  #   - https://docs.aws.amazon.com/iot/latest/developerguide/iot-policies.html
  policy = "PubSubToAnyTopic"

  #---------------------------------------------------------------
  # ターゲット設定
  #---------------------------------------------------------------

  # target (Required)
  # 設定内容: ポリシーをアタッチする対象のプリンシパル（identity）を指定します。
  # 設定可能な値: IoT証明書のARN、Amazon Cognito Identity、またはその他の認証情報
  # 形式: arn:aws:iot:region:account-id:cert/certificate-id
  # 関連機能: AWS IoT Certificate
  #   証明書はデバイスとAWS IoT Core間の安全な接続を確立するために使用されます。
  #   各デバイスは一意のX.509証明書を持ち、その証明書に対してポリシーをアタッチすることで
  #   適切な権限を付与します。証明書とポリシーの両方がアクティブである必要があります。
  #   - https://docs.aws.amazon.com/iot/latest/developerguide/attach-to-cert.html
  target = "arn:aws:iot:us-east-1:123456789012:cert/abc123..."

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, eu-west-1, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトで使用されます
  # 注意: AWS IoTはリージョナルサービスであり、リソースは特定のリージョンに作成されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシーアタッチメントの一意識別子。
#       形式: "policy-name:target-arn"
#       例: "PubSubToAnyTopic:arn:aws:iot:us-east-1:123456789012:cert/abc123..."
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Example Usage
#---------------------------------------------------------------
# 以下は、IoTポリシー、証明書、およびポリシーアタッチメントを組み合わせた
# 完全な使用例です:
#
# data "aws_iam_policy_document" "pubsub" {
#   statement {
#     effect    = "Allow"
#     actions   = ["iot:*"]
#     resources = ["*"]
#   }
# }
#
# resource "aws_iot_policy" "pubsub" {
#   name   = "PubSubToAnyTopic"
#   policy = data.aws_iam_policy_document.pubsub.json
# }
#
# resource "aws_iot_certificate" "cert" {
#   csr    = file("csr.pem")
#   active = true
# }
#
# resource "aws_iot_policy_attachment" "att" {
#   policy = aws_iot_policy.pubsub.name
#   target = aws_iot_certificate.cert.arn
# }
#
#---------------------------------------------------------------
