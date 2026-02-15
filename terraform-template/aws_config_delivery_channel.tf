#-------
# AWS Config Delivery Channel
#-------
# AWS Configの設定変更履歴とスナップショットを配信するチャネルを設定するリソース
# S3バケットやSNSトピックへの配信先を指定し、定期的なスナップショット配信頻度を制御します
# Recorderと併せて使用することで、リソース構成の継続的な記録と配信を実現します
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
#
# NOTE:
# - 配信チャネルを使用するには、Configuration Recorderが必要です
# - S3バケットには適切なバケットポリシーの設定が必須です
# - SNS通知を使用する場合、SNSトピックポリシーの設定が必要です
# - KMS暗号化を使用する場合、KMSキーポリシーでConfig Serviceを許可してください
#
# ユースケース:
# - AWS Configの設定変更履歴をS3に保存して長期保管
# - SNS経由でリアルタイムに設定変更を通知
# - KMS暗号化を使用したセキュアなデータ配信
# - 定期的なスナップショットによるコンプライアンス監査
#
# 関連リソース:
# - aws_config_configuration_recorder: 構成レコーダー（配信チャネルと対で使用）
# - aws_s3_bucket: 配信先S3バケット
# - aws_sns_topic: 配信先SNSトピック
# - aws_kms_key: S3暗号化用のKMSキー
#
# 参考ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/config_delivery_channel
#-------

#-------
# 基本設定
#-------
resource "aws_config_delivery_channel" "example" {
  # 配信チャネル名
  # 設定内容: AWS Config配信チャネルの識別名
  # 省略時: デフォルトの配信チャネル名が使用されます
  name = "example-delivery-channel"

  #-------
  # S3配信設定
  #-------
  # S3バケット名（必須）
  # 設定内容: 設定変更履歴とスナップショットを保存するS3バケット名
  # 注意事項: バケットには適切なバケットポリシーが必要です
  s3_bucket_name = "example-config-bucket"

  # S3キープレフィックス
  # 設定内容: S3バケット内のオブジェクトキーのプレフィックス
  # 省略時: バケットのルートディレクトリに保存されます
  s3_key_prefix = "config/"

  # S3暗号化用KMSキーARN
  # 設定内容: S3に保存するデータを暗号化するKMS CMKのARN
  # 省略時: S3のデフォルト暗号化（SSE-S3）が使用されます
  # 形式: arn:aws:kms:region:account-id:key/key-id
  s3_kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-------
  # SNS通知設定
  #-------
  # SNSトピックARN
  # 設定内容: 設定変更通知を送信するSNSトピックのARN
  # 省略時: SNS通知は行われません
  # 形式: arn:aws:sns:region:account-id:topic-name
  sns_topic_arn = "arn:aws:sns:us-east-1:123456789012:config-topic"

  #-------
  # スナップショット配信設定
  #-------
  snapshot_delivery_properties {
    # スナップショット配信頻度
    # 設定内容: 定期的なスナップショット配信の実行頻度
    # 設定可能な値:
    #   - One_Hour: 1時間ごと
    #   - Three_Hours: 3時間ごと
    #   - Six_Hours: 6時間ごと
    #   - Twelve_Hours: 12時間ごと
    #   - TwentyFour_Hours: 24時間ごと
    # 省略時: TwentyFour_Hoursが使用されます
    delivery_frequency = "TwentyFour_Hours"
  }

  #-------
  # リージョン設定
  #-------
  # デプロイ先リージョン
  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用されます
  region = "us-east-1"
}

#-------
# Attributes Reference（参照可能な属性）
#-------
# このリソースから参照可能な属性:
#
# - id: 配信チャネルのID（通常はname属性と同じ値）
# - name: 配信チャネル名
# - region: リソースが管理されているリージョン
# - s3_bucket_name: 配信先S3バケット名
# - s3_key_prefix: S3キープレフィックス
# - s3_kms_key_arn: S3暗号化用KMSキーARN
# - sns_topic_arn: SNSトピックARN
# - snapshot_delivery_properties: スナップショット配信設定
#   - delivery_frequency: 配信頻度
#
# 参照例:
# output "delivery_channel_id" {
#   value = aws_config_delivery_channel.example.id
# }
#-------
