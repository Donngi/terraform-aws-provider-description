#---------------------------------------------------------------
# AWS Redshift Serverless Custom Domain Association
#---------------------------------------------------------------
#
# Amazon Redshift Serverlessのワークグループにカスタムドメイン名を関連付けるリソースです。
# ACM証明書を使用して、ワークグループへの接続に使用するカスタムドメイン名を設定します。
# クライアント接続用のカスタムドメイン名を設定することで、シンプルで覚えやすいURLで
# ワークグループに接続できるようになります。
#
# AWS公式ドキュメント:
#   - カスタムドメイン名の設定: https://docs.aws.amazon.com/redshift/latest/mgmt/connecting-connection-CNAME.html
#   - CreateCustomDomainAssociation API: https://docs.aws.amazon.com/redshift-serverless/latest/APIReference/API_CreateCustomDomainAssociation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_custom_domain_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshiftserverless_custom_domain_association" "example" {
  #-------------------------------------------------------------
  # ワークグループ設定
  #-------------------------------------------------------------

  # workgroup_name (Required)
  # 設定内容: カスタムドメインを関連付けるワークグループの名前を指定します。
  # 設定可能な値: 3〜64文字の英数字とハイフンのみで構成された文字列
  # 参考: https://docs.aws.amazon.com/redshift-serverless/latest/APIReference/API_CreateCustomDomainAssociation.html
  workgroup_name = "example-workgroup"

  #-------------------------------------------------------------
  # カスタムドメイン設定
  #-------------------------------------------------------------

  # custom_domain_name (Required)
  # 設定内容: ワークグループに関連付けるカスタムドメイン名を指定します。
  # 設定可能な値: 1〜253文字のドメイン名文字列
  # 注意: カスタムドメイン名を使用してワークグループに接続するには、
  #       DNSプロバイダーにCNAMEレコードを作成する必要があります。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/connecting-connection-CNAME.html
  custom_domain_name = "example.com"

  # custom_domain_certificate_arn (Required)
  # 設定内容: カスタムドメイン名の証明書ARNを指定します。
  # 設定可能な値: 20〜2048文字の有効なACM証明書のARN
  # 注意: 指定する証明書はカスタムドメイン名と一致している必要があります。
  #       また、証明書はAWS Certificate Manager (ACM)で管理されている必要があります。
  # 参考: https://docs.aws.amazon.com/redshift-serverless/latest/APIReference/API_CreateCustomDomainAssociation.html
  custom_domain_certificate_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

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
# - id: リソースの識別子
#
# - custom_domain_certificate_expiry_time: カスタムドメイン証明書の有効期限。
#                                          タイムスタンプ形式で返されます。
#---------------------------------------------------------------
