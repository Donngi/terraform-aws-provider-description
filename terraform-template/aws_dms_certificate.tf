#---------------------------------------------------------------
# AWS DMS (Database Migration Service) Certificate
#---------------------------------------------------------------
#
# AWS Database Migration Service (DMS) の証明書をリクエストおよび管理するリソースです。
# DMS証明書は、レプリケーションインスタンスとソース/ターゲットエンドポイント間の
# SSL/TLS接続を確立するために使用されます。
#
# 証明書は以下の2つの形式で提供できます:
#   1. PEM形式: X.509証明書の標準的なテキスト形式
#   2. Oracle Wallet: Oracle データベース接続用の証明書コンテナ
#
# 注意: 証明書の内容（PEMおよびWallet）はTerraform stateに平文で保存されます。
# 機密データの取り扱いについては、Terraformの機密データに関するドキュメントを参照してください。
#   - https://www.terraform.io/docs/state/sensitive-data.html
#
# AWS公式ドキュメント:
#   - DMS 概要: https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html
#   - DMS SSL の使用: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.SSL.html
#   - DMS API リファレンス: https://docs.aws.amazon.com/dms/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dms_certificate" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # certificate_id (Required)
  # 設定内容: 証明書の識別子を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む一意の文字列
  # 用途: DMS証明書を一意に識別するための名前
  # 関連機能: DMS 証明書管理
  #   証明書はエンドポイントでSSL接続を有効にする際に参照されます。
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.SSL.html
  certificate_id = "example-dms-certificate"

  #-------------------------------------------------------------
  # 証明書の内容 (certificate_pem または certificate_wallet のいずれかが必須)
  #-------------------------------------------------------------

  # certificate_pem (Optional, Sensitive)
  # 設定内容: PEM形式のX.509証明書ファイルの内容を指定します。
  # 設定可能な値: PEMエンコードされた証明書データ (-----BEGIN CERTIFICATE-----で始まる文字列)
  # 用途: 一般的なデータベース（MySQL, PostgreSQL, SQL Server等）へのSSL接続に使用
  # 注意: certificate_pem または certificate_wallet のいずれかを設定する必要があります
  # 関連機能: DMS SSL 証明書
  #   PEM形式はほとんどのデータベースエンジンで広くサポートされています。
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.SSL.html
  certificate_pem = file("path/to/certificate.pem")

  # certificate_wallet (Optional, Sensitive)
  # 設定内容: Oracle Wallet証明書の内容をBase64エンコードされた文字列で指定します。
  # 設定可能な値: Base64エンコードされたOracle Walletデータ
  # 用途: Oracle データベースへのSSL接続に使用
  # 注意: certificate_pem または certificate_wallet のいずれかを設定する必要があります
  # 関連機能: DMS Oracle Wallet
  #   Oracle Walletは、Oracleデータベースへの安全な接続に必要な証明書と秘密鍵を含むコンテナです。
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.SSL.html
  certificate_wallet = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-dms-certificate"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はcertificate_idと同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - certificate_arn: 証明書のAmazon Resource Name (ARN)
#   形式: arn:aws:dms:{region}:{account-id}:cert:{certificate_id}
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のDMS証明書は証明書IDを使用してインポートできます:
#
#   terraform import aws_dms_certificate.example example-dms-certificate
#
#---------------------------------------------------------------
