#---------------------------------------------------------------
# AWS Chime SDK Voice Global Settings
#---------------------------------------------------------------
#
# Amazon Chime SDK Voice のグローバル設定を管理するリソースです。
# このリソースを使用して、AWSアカウント全体のVoice Connector に関する
# 通話詳細記録（CDR: Call Detail Records）の保存先S3バケットを設定します。
#
# AWS公式ドキュメント:
#   - Managing global settings: https://docs.aws.amazon.com/chime-sdk/latest/ag/manage-global.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chimesdkvoice_global_settings
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_chimesdkvoice_global_settings" "example" {
  #-------------------------------------------------------------
  # Voice Connector設定
  #-------------------------------------------------------------

  # voice_connector (Required)
  # 設定内容: Voice Connectorに関するグローバル設定を指定します。
  # 注意: このブロックは必須です（min_items: 1, max_items: 1）
  voice_connector {
    # cdr_bucket (Optional)
    # 設定内容: Voice Connectorの通話詳細記録（CDR）を保存するS3バケット名を指定します。
    # 設定可能な値: 有効なS3バケット名
    # 関連機能: Amazon Chime SDK Call Detail Records
    #   CDRには通話のメタデータ（発信元・宛先番号、通話時間、ステータス等）が含まれます。
    #   設定すると、Voice Connectorからの通話詳細記録が指定したS3バケットに
    #   JSON形式で自動的に保存されます。
    #   保存パス例: Amazon-Chime-Voice-Connector-CDRs/json/{voiceConnectorID}/{year}/{month}/{day}/
    #   - https://docs.aws.amazon.com/chime-sdk/latest/ag/manage-global.html
    # 注意: S3バケットは事前に作成しておく必要があります。
    #       Amazon Chime SDKがバケットへの読み書きアクセス権を持つ必要があります。
    cdr_bucket = "example-cdr-bucket"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: この設定が適用されているAWSアカウントID
#---------------------------------------------------------------
