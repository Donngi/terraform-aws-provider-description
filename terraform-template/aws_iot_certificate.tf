#---------------------------------------------------------------
# AWS IoT 証明書
#---------------------------------------------------------------
#
# AWS IoT Core でデバイスの認証に使用する X.509 証明書を
# プロビジョニングするリソースです。
# 証明書は以下の3つの方法で作成できます:
#
#   1. AWS IoT が自動生成する方法:
#      csr、certificate_pem、ca_pem をすべて省略することで、
#      AWS IoT が秘密鍵・公開鍵・証明書を自動生成します。
#
#   2. CSR（Certificate Signing Request）から作成する方法:
#      csr に既存の CSR を指定することで、
#      AWS IoT がその CSR に署名して証明書を発行します。
#
#   3. 既存の証明書を登録する方法:
#      certificate_pem と ca_pem の両方を指定することで、
#      既存の証明書をAWS IoTに登録します。
#
# AWS公式ドキュメント:
#   - X.509 証明書を使用したデバイスの認証:
#       https://docs.aws.amazon.com/iot/latest/developerguide/x509-client-certs.html
#   - 証明書の作成と登録:
#       https://docs.aws.amazon.com/iot/latest/developerguide/device-certs-your-own.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_certificate" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # active (Required)
  # 設定内容: 証明書をアクティブ状態にするかを指定します。
  # 設定可能な値:
  #   - true: 証明書をアクティブ化。デバイスはこの証明書を使って認証できます
  #   - false: 証明書を非アクティブ化。デバイスはこの証明書を使って認証できません
  # 注意: 証明書を削除する前に false に設定してから REVOKED 状態にする必要があります。
  active = true

  #-------------------------------------------------------------
  # 証明書ソース設定
  #-------------------------------------------------------------

  # csr (Optional)
  # 設定内容: AWS IoT に署名させる CSR（Certificate Signing Request）を
  #           PEM 形式で指定します。
  # 設定可能な値: PEM 形式の CSR 文字列
  # 省略時: certificate_pem と ca_pem も省略した場合、AWS IoT が自動で証明書を生成します
  # 注意: csr を指定した場合、certificate_pem と ca_pem は指定できません。
  #       このフィールドはセンシティブ属性として扱われません。
  csr = null

  # certificate_pem (Optional)
  # 設定内容: 既存の証明書を AWS IoT に登録する場合に PEM 形式で指定します。
  # 設定可能な値: PEM 形式の X.509 証明書文字列
  # 省略時: csr を指定した場合は CSR に基づいて証明書が生成されます。
  #         csr も省略した場合は AWS IoT が自動で証明書を生成します
  # 注意: certificate_pem を指定する場合は ca_pem も必須です。
  #       このフィールドはセンシティブ属性です（Terraform state に保存されますが表示は秘匿化されます）。
  certificate_pem = null

  # ca_pem (Optional)
  # 設定内容: certificate_pem を署名した CA（認証局）の証明書を PEM 形式で指定します。
  # 設定可能な値: PEM 形式の CA 証明書文字列
  # 省略時: certificate_pem を指定しない場合は省略できます
  # 注意: certificate_pem を指定する場合は必須です。
  #       このフィールドはセンシティブ属性です（Terraform state に保存されますが表示は秘匿化されます）。
  ca_pem = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 証明書の Amazon Resource Name (ARN)
#
# - ca_certificate_id: この証明書を署名した CA 証明書の ID
#
# - certificate_pem: 発行された証明書の PEM 形式の文字列。
#                    AWS IoT が自動生成した場合にのみ値が設定されます（センシティブ属性）。
#
# - private_key: AWS IoT が自動生成した場合の秘密鍵の PEM 形式の文字列（センシティブ属性）。
#               CSR または既存証明書で作成した場合は空になります。
#
# - public_key: AWS IoT が自動生成した場合の公開鍵の PEM 形式の文字列（センシティブ属性）。
#              CSR または既存証明書で作成した場合は空になります。
#---------------------------------------------------------------
