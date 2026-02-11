#---------------------------------------------------------------
# AWS Chime SDK Voice SIP Media Application
#---------------------------------------------------------------
#
# Amazon Chime SDK VoiceのSIPメディアアプリケーションをプロビジョニングするリソースです。
# SIPメディアアプリケーションは、SIPルールからの値をターゲットのAWS Lambda関数に
# 渡すマネージドオブジェクトです。SIPベースの音声通話処理をLambda関数で
# カスタマイズするために使用されます。
#
# AWS公式ドキュメント:
#   - Amazon Chime SDK Voice概要: https://docs.aws.amazon.com/chime-sdk/latest/dg/pstn-sip.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chimesdkvoice_sip_media_application
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_chimesdkvoice_sip_media_application" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: SIPメディアアプリケーションの名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "example-sip-media-application"

  # aws_region (Required)
  # 設定内容: AWS Chime SDK Voice SIPメディアアプリケーションを作成するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2）
  # 注意: Amazon Chime SDK Voiceが利用可能なリージョンを指定する必要があります。
  aws_region = "us-east-1"

  #-------------------------------------------------------------
  # エンドポイント設定
  #-------------------------------------------------------------

  # endpoints (Required)
  # 設定内容: SIPメディアアプリケーションに関連付けるエンドポイント（Lambda関数）を指定します。
  # 注意: 現在、1つのエンドポイントのみサポートされています（min=1, max=1）。
  endpoints {
    # lambda_arn (Required)
    # 設定内容: Lambda関数、バージョン、またはエイリアスの有効なAmazon Resource Name (ARN)を指定します。
    # 設定可能な値: 有効なLambda関数ARN
    # 注意: Lambda関数はSIPメディアアプリケーションと同じAWSリージョンに作成されている必要があります。
    lambda_arn = "arn:aws:lambda:us-east-1:123456789012:function:my-sip-handler"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-sip-media-application"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AWS Chime SDK Voice SIPメディアアプリケーションのAmazon Resource Name (ARN)
#
# - id: SIPメディアアプリケーションのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
