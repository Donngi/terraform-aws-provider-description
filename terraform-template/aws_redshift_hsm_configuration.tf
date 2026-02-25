#---------------------------------------------------------------
# Amazon Redshift HSM 設定
#---------------------------------------------------------------
#
# Amazon RedshiftクラスターがHardware Security Module (HSM) に
# データベース暗号化キーを保存・使用するために必要な情報を含む
# HSM設定をプロビジョニングするリソースです。
# HSMはオンプレミスまたはAWS CloudHSM Classicを使用できます。
#
# AWS公式ドキュメント:
#   - Amazon Redshift データベース暗号化: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-db-encryption.html
#   - CreateHsmConfiguration API: https://docs.aws.amazon.com/redshift/latest/APIReference/API_CreateHsmConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_hsm_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_hsm_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # hsm_configuration_identifier (Required, Forces new resource)
  # 設定内容: 新しいHSM構成に割り当てる一意の識別子を指定します。
  # 設定可能な値: 英数字とハイフンのみを含む文字列
  # 参考: https://docs.aws.amazon.com/redshift/latest/APIReference/API_CreateHsmConfiguration.html
  hsm_configuration_identifier = "example-hsm-config"

  # description (Required, Forces new resource)
  # 設定内容: 作成するHSM構成のテキスト説明を指定します。
  # 設定可能な値: 任意の文字列
  description = "Example HSM configuration for Redshift cluster"

  #-------------------------------------------------------------
  # HSM接続設定
  #-------------------------------------------------------------

  # hsm_ip_address (Required, Forces new resource)
  # 設定内容: Amazon RedshiftクラスターがHSMにアクセスするために使用する
  #           IPアドレスを指定します。
  # 設定可能な値: 有効なIPv4アドレス
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-db-encryption.html
  hsm_ip_address = "10.0.0.1"

  # hsm_partition_name (Required, Forces new resource)
  # 設定内容: Amazon Redshiftクラスターがデータベース暗号化キーを保存する
  #           HSM内のパーティション名を指定します。
  # 設定可能な値: HSMで設定されたパーティション名の文字列
  hsm_partition_name = "aws_redshift_partition"

  # hsm_partition_password (Required, Forces new resource)
  # 設定内容: HSMパーティションへのアクセスに必要なパスワードを指定します。
  # 設定可能な値: HSMパーティションに設定されたパスワード文字列
  # 注意: このフィールドはsensitive（機密）として扱われます。
  #       Terraform stateファイルに暗号化せずに保存されるため、
  #       状態ファイルの適切な保護が必要です。
  hsm_partition_password = "example-partition-password"

  # hsm_server_public_certificate (Required, Forces new resource)
  # 設定内容: HSMサーバーの公開証明書を指定します。
  #           AWS CloudHSMを使用する場合、ファイル名はserver.pemです。
  # 設定可能な値: HSMサーバーの公開証明書の文字列（PEM形式）
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-db-encryption.html
  hsm_server_public_certificate = "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定で指定されたリージョンを使用
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
    Name        = "example-hsm-config"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: HSM設定のAmazon Resource Name (ARN)
#
# - hsm_configuration_public_key: Amazon RedshiftクラスターがHSMへの接続に使用する公開鍵。
#                                  この公開鍵はHSMに登録する必要があります。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
