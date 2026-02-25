#---------------------------------------------------------------
# AWS Redshift HSM Client Certificate
#---------------------------------------------------------------
#
# Amazon RedshiftクラスターがHSM（ハードウェアセキュリティモジュール）に
# 接続するために使用するHSMクライアント証明書をプロビジョニングするリソースです。
# クライアント証明書は、クラスターのデータベースを暗号化するキーを
# HSMに保存・取得するために使用されます。
#
# AWS公式ドキュメント:
#   - Amazon Redshiftデータベース暗号化: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-db-encryption.html
#   - CreateHsmClientCertificate API: https://docs.aws.amazon.com/redshift/latest/APIReference/API_CreateHsmClientCertificate.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_hsm_client_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_hsm_client_certificate" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # hsm_client_certificate_identifier (Required, Forces new resource)
  # 設定内容: HSMクライアント証明書の一意な識別子を指定します。
  # 設定可能な値: 任意の文字列
  hsm_client_certificate_identifier = "example-hsm-client-cert"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-hsm-client-cert"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: HSMクライアント証明書のAmazon Resource Name (ARN)
#
# - hsm_client_certificate_public_key: Amazon Redshiftクラスターがに接続するために
#                                      使用する公開鍵。HSMにこの公開鍵を登録する必要があります。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
