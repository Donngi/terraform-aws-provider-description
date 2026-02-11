#---------------------------------------------------------------
# AWS Certificate Manager Private Certificate Authority Certificate
#---------------------------------------------------------------
#
# AWS Certificate Manager Private Certificate Authority (ACM PCA) の認証局に証明書を
# 関連付けるリソースです。ACM PCA認証局は証明書が関連付けられるまで証明書を発行
# できません。ルートレベルのACM PCA認証局は自己署名ルート証明書を作成できます。
#
# AWS公式ドキュメント:
#   - Installing the CA certificate: https://docs.aws.amazon.com/privateca/latest/userguide/PCACertInstall.html
#   - AWS Private Certificate Authority: https://docs.aws.amazon.com/privateca/latest/userguide/PcaWelcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acmpca_certificate_authority_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_acmpca_certificate_authority_certificate" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # certificate (Required)
  # 設定内容: 認証局用のPEMエンコードされた証明書を指定します。
  # 設定可能な値: PEMフォーマットの証明書文字列
  # 関連機能: CA証明書のインストール
  #   ルートCA証明書または従属CA証明書をAWS Private CAに関連付けます。
  #   ルートCAの場合は自己署名証明書、従属CAの場合は親CAから発行された証明書を使用します。
  #   - https://docs.aws.amazon.com/privateca/latest/userguide/PCACertInstall.html
  certificate = aws_acmpca_certificate.example.certificate

  # certificate_authority_arn (Required)
  # 設定内容: 証明書を関連付ける認証局のARNを指定します。
  # 設定可能な値: 有効なACM PCA認証局のARN
  #   形式例: arn:aws:acm-pca:region:account-id:certificate-authority/CA_ID
  # 関連機能: ACM PCA認証局
  #   証明書を関連付ける対象の認証局を識別します。
  #   認証局は事前に作成されている必要があります。
  certificate_authority_arn = aws_acmpca_certificate_authority.example.arn

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # certificate_chain (Optional)
  # 設定内容: 中間証明書を含みルートCAまでチェーンするPEMエンコードされた証明書チェーンを指定します。
  # 設定可能な値: PEMフォーマットの証明書チェーン文字列
  # 関連機能: 証明書チェーン
  #   従属認証局の場合は必須です。ルート認証局の場合は許可されません。
  #   中間証明書とルートCAまでの証明書パスを含める必要があります。
  #   - https://docs.aws.amazon.com/privateca/latest/userguide/PCACertInstall.html
  # 注意:
  #   - 従属CA (SUBORDINATE) の場合は必須
  #   - ルートCA (ROOT) の場合は設定不可
  certificate_chain = aws_acmpca_certificate.example.certificate_chain

  # id (Optional, Computed)
  # 設定内容: リソースの識別子を指定します。
  # 設定可能な値: 文字列
  # 省略時: 自動的に計算されます (通常はcertificate_authority_arnの値)
  # 注意: 通常は明示的に設定する必要はありません
  id = null

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: リージョナルエンドポイント
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースには読み取り専用属性はエクスポートされません。
# certificate_authority_arnをリソースIDとして使用します。
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# 【ルートCA証明書の自己署名例】
# resource "aws_acmpca_certificate_authority_certificate" "root" {
#   certificate_authority_arn = aws_acmpca_certificate_authority.root.arn
#   certificate               = aws_acmpca_certificate.root.certificate
#   certificate_chain         = aws_acmpca_certificate.root.certificate_chain
# }
#
# resource "aws_acmpca_certificate" "root" {
#   certificate_authority_arn   = aws_acmpca_certificate_authority.root.arn
#   certificate_signing_request = aws_acmpca_certificate_authority.root.certificate_signing_request
#   signing_algorithm           = "SHA512WITHRSA"
#   template_arn                = "arn:aws:acm-pca:::template/RootCACertificate/V1"
#
#   validity {
#     type  = "YEARS"
#     value = 10
#---------------------------------------------------------------
