#---------------------------------------------------------------
# AWS IAM 署名証明書
#---------------------------------------------------------------
#
# IAMユーザーに署名証明書をアップロードするリソースです。
# 署名証明書はAWSのSOAP APIへのリクエストに署名するために使用されます。
# 各IAMユーザーは最大2枚の署名証明書を保持できます。
#
# 注意: certificate_body の内容を含むすべての引数がプレーンテキストとして
# Terraformのステートに保存されます。機密データの取り扱いに注意してください。
# 参考: https://www.terraform.io/docs/state/sensitive-data.html
#
# AWS公式ドキュメント:
#   - IAM署名証明書の管理: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_server-certs.html
#   - UploadSigningCertificate API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_UploadSigningCertificate.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_signing_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_signing_certificate" "example" {
  #-------------------------------------------------------------
  # 証明書設定
  #-------------------------------------------------------------

  # certificate_body (Required)
  # 設定内容: PEMエンコード形式の署名証明書の内容を指定します。
  # 設定可能な値: PEMエンコードされたX.509証明書の文字列。
  #              file() 関数でファイルから読み込むか、ヒアドキュメントで直接指定します。
  # 注意: 証明書はプレーンテキストとしてTerraformのステートに保存されます。
  certificate_body = file("signing-cert.pem")

  # user_name (Required)
  # 設定内容: 署名証明書を関連付けるIAMユーザーの名前を指定します。
  # 設定可能な値: 既存のIAMユーザー名の文字列。
  user_name = "example-user"

  #-------------------------------------------------------------
  # ステータス設定
  #-------------------------------------------------------------

  # status (Optional)
  # 設定内容: 証明書に割り当てるステータスを指定します。
  # 設定可能な値:
  #   - "Active"   : 証明書をAWSへのプログラム的な呼び出しに使用できます。
  #   - "Inactive" : 証明書はAWSへのプログラム的な呼び出しに使用できません。
  # 省略時: "Active" として扱われます。
  status = "Active"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - certificate_id: AWSが割り当てた署名証明書のID
#
# - id: `certificate_id:user_name` 形式の複合識別子
#---------------------------------------------------------------
