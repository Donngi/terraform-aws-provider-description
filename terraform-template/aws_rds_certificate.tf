#---------------------------------------------------------------
# AWS RDS Certificate (デフォルトSSL/TLS証明書の上書き設定)
#---------------------------------------------------------------
#
# 現在のAWSリージョンにおける新規DBインスタンス向けのシステムデフォルト
# SSL/TLS証明書を上書きするリソースです。
# このリソースを削除すると上書きが解除され、新規DBインスタンスは
# 対象リージョンのシステムデフォルト証明書を使用するようになります。
#
# AWS公式ドキュメント:
#   - RDS SSL/TLS証明書の使用: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html
#   - SSL/TLS証明書のローテーション: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL-certificate-rotation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_certificate" "example" {
  #-------------------------------------------------------------
  # 証明書設定
  #-------------------------------------------------------------

  # certificate_identifier (Required)
  # 設定内容: 新規DBインスタンスのデフォルトとして設定するCA証明書の識別子を指定します。
  # 設定可能な値:
  #   - "rds-ca-rsa2048-g1": RSA 2048ビット証明書
  #   - "rds-ca-rsa4096-g1": RSA 4096ビット証明書
  #   - "rds-ca-ecc384-g1": ECC 384ビット証明書
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html#UsingWithRDS.SSL.CertificateIdentifier
  certificate_identifier = "rds-ca-rsa4096-g1"

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
# - id: 証明書識別子（certificate_identifier と同じ値）
#---------------------------------------------------------------
