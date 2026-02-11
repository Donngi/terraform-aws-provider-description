#---------------------------------------------------------------
# AWS API Gateway Client Certificate
#---------------------------------------------------------------
#
# API Gatewayのクライアント証明書をプロビジョニングするリソースです。
# クライアント証明書は、API Gatewayからバックエンドシステムへのリクエストを
# 認証するために使用されます。バックエンドサーバーはこの証明書の公開鍵を使用して、
# リクエストがAPI Gatewayから発信されたものであることを検証できます。
#
# AWS公式ドキュメント:
#   - バックエンド認証用SSL証明書の生成と設定: https://docs.aws.amazon.com/apigateway/latest/developerguide/getting-started-client-side-ssl-authentication.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_client_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_client_certificate" "example" {
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
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: クライアント証明書の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: 証明書の用途や関連するAPIの識別に使用
  description = "My client certificate for backend authentication"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-api-client-certificate"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: クライアント証明書の識別子
#
# - arn: クライアント証明書のAmazon Resource Name (ARN)
#
# - created_date: クライアント証明書が作成された日付
#
# - expiration_date: クライアント証明書の有効期限
#
# - pem_encoded_certificate: クライアント証明書のPEMエンコードされた公開鍵
#        この公開鍵をバックエンドサーバーに設定することで、
#        API Gatewayからのリクエストを認証できます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
