#---------------------------------------------------------------
# AWS IoT Certificate
#---------------------------------------------------------------
#
# AWS IoTデバイス証明書を作成・管理するリソース。
# IoTデバイスがAWS IoT Coreに接続する際の認証に使用される証明書を
# プロビジョニングします。証明書の作成方法は以下の3パターンがあります：
#
# 1. CSR（証明書署名要求）から証明書を生成
# 2. キーペアと証明書を自動生成
# 3. 既存の証明書を登録（CA証明書の有無に応じて2種類）
#
# AWS公式ドキュメント:
#   - CreateKeysAndCertificate API: https://docs.aws.amazon.com/iot/latest/apireference/API_CreateKeysAndCertificate.html
#   - CreateCertificateFromCsr API: https://docs.aws.amazon.com/iot/latest/apireference/API_CreateCertificateFromCsr.html
#   - RegisterCertificate API: https://docs.aws.amazon.com/iot/latest/apireference/API_RegisterCertificate.html
#   - RegisterCertificateWithoutCA API: https://docs.aws.amazon.com/iot/latest/apireference/API_RegisterCertificateWithoutCA.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_certificate" "example" {
  #---------------------------------------------------------------
  # Required Attributes
  #---------------------------------------------------------------

  # active - (Required) 証明書をアクティブ状態にするかを指定するブール値
  # true: 証明書がアクティブ化され、デバイスの認証に使用可能になります
  # false: 証明書は非アクティブ状態で作成され、認証には使用できません
  # 非アクティブ状態の証明書は後からアクティブ化することが可能です
  active = true

  #---------------------------------------------------------------
  # Optional Attributes
  #---------------------------------------------------------------

  # csr - (Optional) 証明書署名要求（Certificate Signing Request）
  # CSRを指定した場合、このCSRを使用してAWS IoTが証明書を発行します
  # CSRと証明書のどちらも指定しない場合は、2048ビットRSAキーペアと
  # X.509証明書が自動生成されます（CreateKeysAndCertificate API使用）
  # CSRを使用する場合はCreateCertificateFromCsr APIが使用されます
  # csr = file("/path/to/csr.pem")

  # certificate_pem - (Optional) 登録する既存の証明書（PEM形式）
  # ca_pemが未指定の場合、RegisterCertificateWithoutCA APIを使用して
  # CA証明書なしで証明書を登録します
  # ca_pemが指定されている場合、RegisterCertificate APIを使用して
  # CA証明書とともに証明書を登録します
  # 注意: この属性はoptionalかつcomputedのため、明示的に指定しない場合は
  # 自動生成された証明書がこの属性に格納されます
  # certificate_pem = file("/path/to/certificate.pem")

  # ca_pem - (Optional) 証明書を登録する際のCA証明書（PEM形式）
  # certificate_pemと組み合わせて使用し、CA証明書付きで証明書を登録します
  # 注意: このCA証明書は事前にAWS IoTに登録されている必要があります
  # ca_pemを指定する場合は、certificate_pemも必須です
  # 機密情報のため、terraformステート内では暗号化されて保存されます
  # ca_pem = file("/path/to/ca.pem")

  # id - (Optional) 証明書の内部ID
  # 通常はTerraformが自動的に管理するため、明示的な指定は不要です
  # この属性はcomputedでもあるため、指定しない場合は自動的に割り当てられます
  # id = "custom-id"

  # region - (Optional) このリソースを管理するAWSリージョン
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます
  # マルチリージョン構成の場合や、特定リージョンでの証明書管理が必要な場合に指定します
  # 例: "us-east-1", "ap-northeast-1" など
  # region = "ap-northeast-1"

  #---------------------------------------------------------------
  # タグ設定
  # 注意: aws_iot_certificateリソースは直接タグをサポートしていません
  # 証明書にメタデータを関連付ける場合は、Thing TypeやThing Groupの
  # タグ機能を活用することを検討してください
  #---------------------------------------------------------------
}

#---------------------------------------------------------------
# Attributes Reference (Computed Only)
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、参照のみ可能です
#
# - arn
#   証明書のARN（Amazon Resource Name）
#   例: "arn:aws:iot:us-east-1:123456789012:cert/abc123..."
#   他のリソース（ポリシーアタッチメントなど）で証明書を参照する際に使用
#
# - ca_certificate_id
#   証明書に署名したCA証明書のID
#   CA証明書を使用して証明書を登録した場合にのみ設定されます
#
# - private_key (Sensitive)
#   自動生成された秘密鍵（PEM形式）
#   CSRも証明書も指定せずにリソースを作成した場合にのみ生成されます
#   機密情報のため、terraformステート内では暗号化されて保存されます
#   警告: この秘密鍵は最初の作成時にのみ取得可能です。必ず安全な場所に保管してください
#
# - public_key (Sensitive)
#   自動生成された公開鍵（PEM形式）
#   CSRも証明書も指定せずにリソースを作成した場合にのみ生成されます
#   機密情報のため、terraformステート内では暗号化されて保存されます
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: キーペアと証明書を自動生成
# resource "aws_iot_certificate" "auto_generated" {
#   active = true
# }
#
# output "cert_arn" {
#   value = aws_iot_certificate.auto_generated.arn
# }
#
# output "cert_pem" {
#   value     = aws_iot_certificate.auto_generated.certificate_pem
#   sensitive = true
# }
#
# output "private_key" {
#   value     = aws_iot_certificate.auto_generated.private_key
#   sensitive = true
# }

# 例2: CSRから証明書を生成
# resource "aws_iot_certificate" "from_csr" {
#   csr    = file("${path.module}/device.csr")
#   active = true
# }

# 例3: 既存の証明書を登録（CA証明書なし）
# resource "aws_iot_certificate" "existing_without_ca" {
#   certificate_pem = file("${path.module}/device-cert.pem")
#   active          = true
# }

# 例4: 既存の証明書を登録（CA証明書付き）
# resource "aws_iot_certificate" "existing_with_ca" {
#   certificate_pem = file("${path.module}/device-cert.pem")
#   ca_pem          = file("${path.module}/ca-cert.pem")
#   active          = true
# }

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
# - aws_iot_policy: IoTポリシーを定義
# - aws_iot_policy_attachment: 証明書にポリシーをアタッチ
# - aws_iot_thing: IoT Thingを作成
# - aws_iot_thing_principal_attachment: 証明書をThingにアタッチ
# - aws_iot_certificate_authority: CA証明書を管理
#---------------------------------------------------------------
