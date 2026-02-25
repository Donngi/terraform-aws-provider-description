#---------------------------------------------------------------
# AWS IAM Outbound Web Identity Federation
#---------------------------------------------------------------
#
# IAM アウトバウンド Web Identity Federation を管理するリソースです。
# このリソースを作成すると IAM Outbound Web Identity Federation が有効化され、
# 削除すると無効化されます。
#
# IAM Outbound Web Identity Federation を有効にすることで、
# AWSアカウントに固有のOpenID Connect (OIDC) 発行者URLが付与されます。
# このURLはOIDC互換の外部サービスとの信頼関係を構築する際に使用できます。
#
# 注意: このリソースは設定引数を持たず、AWSアカウントにつき
#       1つのみ作成できます。
#
# AWS公式ドキュメント:
#   - IAM Outbound Web Identity Federation: https://docs.aws.amazon.com/IAM/latest/UserGuide/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_outbound_web_identity_federation
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_outbound_web_identity_federation" "example" {
  # このリソースには設定可能な引数はありません。
  # 設定内容: リソースを作成するだけで IAM Outbound Web Identity Federation が有効化されます。
  #           削除するとIAM Outbound Web Identity Federationが無効化されます。
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子
# - issuer_identifier: AWSアカウントにホストされたOpenID Connect (OIDC)
#                      ディスカバリエンドポイントの一意な発行者URL
#---------------------------------------------------------------
