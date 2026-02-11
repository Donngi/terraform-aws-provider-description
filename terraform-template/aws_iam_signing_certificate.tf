#---------------------------------------------------------------
# IAM Signing Certificate
#---------------------------------------------------------------
#
# IAMユーザーに対してX.509署名証明書をアップロードし、関連付けるためのリソース。
# 一部のAWSサービスでは、対応する秘密鍵で署名されたリクエストの検証に証明書が必要。
#
# AWS公式ドキュメント:
#   - UploadSigningCertificate API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_UploadSigningCertificate.html
#   - IAM CLI Examples: https://docs.aws.amazon.com/IAM/latest/UserGuide/iam_example_iam_UploadSigningCertificate_section.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_signing_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_signing_certificate" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # 署名証明書の内容（PEMエンコード形式）
  # X.509証明書の全体をPEM形式で指定する。
  # file()関数を使用してファイルから読み込むか、ヒアドキュメントで直接記述可能。
  # 証明書の内容はプレーンテキストとしてステート内に保存されるため注意。
  # 例: file("self-ca-cert.pem") または <<EOF...EOF 形式
  certificate_body = "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"

  # 署名証明書を関連付けるIAMユーザー名
  # 既存のIAMユーザー名を指定する。
  # 大文字小文字の英数字、+、=、,、.、@、-、_ が使用可能。
  # 例: "john.doe", "service-account-user"
  user_name = "example-user"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # 証明書に割り当てるステータス
  # "Active": 証明書をAWSへのプログラム呼び出しに使用可能
  # "Inactive": 証明書を使用不可に設定
  # 指定しない場合、デフォルトは "Active"
  # 例: "Active", "Inactive"
  # status = "Active"

  # リソースID（通常は指定不要）
  # Terraformが自動的に管理するため、通常は設定しない。
  # フォーマット: certificate_id:user_name
  # 例: "APKA1234567890EXAMPLE:example-user"
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（読み取り専用）:
#
# - certificate_id (string)
#   署名証明書のID。AWSが自動的に割り当てる一意の識別子。
#   例: "APKA1234567890EXAMPLE"
#
# - id (string)
#   リソースの識別子。フォーマット: certificate_id:user_name
#   例: "APKA1234567890EXAMPLE:example-user"
#
#---------------------------------------------------------------
# 参照方法の例:
#   aws_iam_signing_certificate.example.certificate_id
#   aws_iam_signing_certificate.example.id
#---------------------------------------------------------------
