#---------------------------------------------------------------
# AWS Chime SDK Voice Profile Domain
#---------------------------------------------------------------
#
# Amazon Chime SDK の Voice Profile Domain をプロビジョニングするリソースです。
# Voice Profile Domain は、話者認識（Speaker Search）機能で使用される
# ボイスプロファイル（声紋）のコレクションを管理するためのコンテナです。
#
# Voice Profile Domain を使用する前に、該当する法律と AWS サービス規約に基づき、
# 発話者から生体情報の収集・使用・保管・保持に関する同意を得る必要があります。
#
# AWS公式ドキュメント:
#   - Voice Profile Domain概要: https://docs.aws.amazon.com/chime-sdk/latest/ag/manage-voice-profile-domains.html
#   - Voice Profile Domain API: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_VoiceProfileDomain.html
#   - Voice Analytics アーキテクチャ: https://docs.aws.amazon.com/chime-sdk/latest/dg/va-architecture.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chimesdkvoice_voice_profile_domain
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_chimesdkvoice_voice_profile_domain" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Voice Profile Domain の名前を指定します。
  # 設定可能な値: 1-256文字の文字列（英数字、スペース、アンダースコア、ハイフン、ピリオド使用可能）
  name = "example-voice-profile-domain"

  # description (Optional)
  # 設定内容: Voice Profile Domain の説明を指定します。
  # 設定可能な値: 0-1024文字の文字列
  # 省略時: 説明なし
  description = "My Voice Profile Domain for speaker search"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: Amazon Chime SDK Voice は利用可能なリージョンが限定されています
  region = null

  #-------------------------------------------------------------
  # サーバーサイド暗号化設定
  #-------------------------------------------------------------

  # server_side_encryption_configuration (Required)
  # 設定内容: サーバーサイド暗号化の設定を指定します。
  # 関連機能: AWS KMS を使用した暗号化
  #   Voice Profile Domain に保存される声紋データを暗号化するために
  #   AWS KMS キーを使用します。
  server_side_encryption_configuration {
    # kms_key_arn (Required)
    # 設定内容: 暗号化に使用する KMS キーの ARN を指定します。
    # 設定可能な値: 有効な KMS キー ARN
    # 注意: KMS キーは Voice Profile Domain と同じリージョンに存在する必要があります
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-voice-profile-domain"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "60m", "30s" などの時間文字列
    # 省略時: デフォルトのタイムアウト時間
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "60m", "30s" などの時間文字列
    # 省略時: デフォルトのタイムアウト時間
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "60m", "30s" などの時間文字列
    # 省略時: デフォルトのタイムアウト時間
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Voice Profile Domain の Amazon Resource Name (ARN)
#
# - id: Voice Profile Domain の ID
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# resource "aws_kms_key" "voice_profile" {
#   description             = "KMS Key for Voice Profile Domain"
#   deletion_window_in_days = 7
# }
#
# resource "aws_chimesdkvoice_voice_profile_domain" "example" {
#   name = "ExampleVoiceProfileDomain"
#   server_side_encryption_configuration {
#     kms_key_arn = aws_kms_key.voice_profile.arn
#   }
#---------------------------------------------------------------
