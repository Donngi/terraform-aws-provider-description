#---------------------------------------------------------------
# AWS IoT Thing Principal Attachment
#---------------------------------------------------------------
#
# AWS IoT ThingにPrincipal（X.509証明書またはAmazon Cognito Identity）を
# アタッチするリソース。これにより、物理デバイスがAWS IoTと通信できるように
# なります。
#
# AWS公式ドキュメント:
#   - Attach a principal to a thing: https://docs.aws.amazon.com/iot/latest/developerguide/attach-thing-principal.html
#   - AttachThingPrincipal API Reference: https://docs.aws.amazon.com/iot/latest/apireference/API_AttachThingPrincipal.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_thing_principal_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_thing_principal_attachment" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (Required) PrincipalのARN
  # X.509証明書のARN、またはAmazon Cognito IdentityのIDを指定します。
  # 例: "arn:aws:iot:us-east-1:123456789012:cert/a1b2c3d4e5f6..."
  principal = "arn:aws:iot:us-east-1:123456789012:cert/certificate-id"

  # (Required) アタッチ先のThingの名前
  # AWS IoT Thingリソースの名前を指定します。
  # 最小長: 1文字、最大長: 128文字
  thing = "example-iot-thing"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (Optional) リソースID
  # TerraformリソースのID。通常は自動的に計算されるため、明示的な設定は不要です。
  # computed: true（自動計算される）
  # id = null

  # (Optional) リージョン設定
  # このリソースを管理するリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 例: "us-west-2"
  # region = null

  # (Optional) PrincipalとThingの関係性タイプ
  # PrincipalをThingにアタッチする際の関係性のタイプを指定します。
  #
  # 有効な値:
  #   - "EXCLUSIVE_THING": 証明書は指定されたThingにのみ関連付けられます
  #                       （1つの証明書は1つのThingにのみアタッチ可能）
  #   - "NON_EXCLUSIVE_THING": 証明書は複数のThingに関連付けることができます
  #                           （デフォルト値）
  #
  # デフォルト: "NON_EXCLUSIVE_THING"
  #
  # 注意: この機能を使用できるのはX.509証明書のみです。
  #       Amazon Cognito Identityには使用できません。
  # thing_principal_type = "NON_EXCLUSIVE_THING"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - id: Terraform内部で使用されるリソースID（optional + computed）
#       形式は実装依存ですが、通常は "thing:principal" の形式です
#       明示的に設定することも可能ですが、通常は自動計算されます
#
# - region: リソースが管理されるリージョン（optional + computed）
#           明示的に設定しない場合、プロバイダー設定のリージョンが使用されます
#
# - thing_principal_type: Principal関係性タイプ（optional + computed）
#                        設定しない場合、デフォルト値 "NON_EXCLUSIVE_THING" が使用されます
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# # IoT Thingの作成
# resource "aws_iot_thing" "example" {
#   name = "example-device"
# }
#
# # IoT証明書の作成
# resource "aws_iot_certificate" "cert" {
#   csr    = file("csr.pem")
#   active = true
# }
#
# # PrincipalをThingにアタッチ
# resource "aws_iot_thing_principal_attachment" "example" {
#   principal = aws_iot_certificate.cert.arn
#   thing     = aws_iot_thing.example.name
# }
#
#---------------------------------------------------------------
