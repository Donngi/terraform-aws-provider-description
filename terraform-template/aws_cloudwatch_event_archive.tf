#---------------------------------------------------------------
# AWS CloudWatch Event Archive (EventBridge Archive)
#---------------------------------------------------------------
#
# Amazon EventBridgeのイベントアーカイブをプロビジョニングするリソースです。
# イベントアーカイブは、イベントバスで受信したイベントを保存し、後で再生
# するために使用されます。エラー復旧や新機能の検証に活用できます。
#
# Note: EventBridgeは以前CloudWatch Eventsとして知られていました。
#       機能は同一です。
#
# AWS公式ドキュメント:
#   - EventBridgeアーカイブ概要: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-archive.html
#   - アーカイブの作成: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-archive-event.html
#   - アーカイブの暗号化: https://docs.aws.amazon.com/eventbridge/latest/userguide/encryption-archives.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_archive
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_event_archive" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: アーカイブの名前を指定します。
  # 設定可能な値: 48文字以内の文字列
  # 注意: アーカイブ名は48文字を超えることはできません。
  name = "my-event-archive"

  # event_source_arn (Required, Forces new resource)
  # 設定内容: アーカイブに関連付けるイベントバスのARNを指定します。
  # 設定可能な値: 有効なEventBridge Event BusのARN
  # 注意: このイベントバスから受信したイベントのみがアーカイブに送信されます。
  event_source_arn = "arn:aws:events:ap-northeast-1:123456789012:event-bus/my-event-bus"

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
  # アーカイブ設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: アーカイブの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: アーカイブの目的や用途を記述するために使用
  description = "Event archive for error recovery and replay"

  # event_pattern (Optional)
  # 設定内容: アーカイブに送信するイベントをフィルタリングするためのイベントパターンを指定します。
  # 設定可能な値: 有効なEventBridgeイベントパターン（JSON形式）
  # 省略時: event_source_arnで指定したイベントバスで受信した全てのイベントをアーカイブ
  # 関連機能: EventBridgeイベントパターン
  #   イベントパターンを使用して、特定の条件に一致するイベントのみをアーカイブできます。
  #   - https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-event-patterns.html
  event_pattern = jsonencode({
    source      = ["my-application"]
    detail-type = ["OrderCreated", "OrderUpdated"]
  })

  # retention_days (Optional)
  # 設定内容: アーカイブ内のイベントを保持する最大日数を指定します。
  # 設定可能な値: 正の整数（日数）
  # 省略時: 無期限にアーカイブ
  # 関連機能: アーカイブ保持期間
  #   保持期間を設定することで、古いイベントを自動的に削除し、
  #   ストレージコストを最適化できます。
  #   - https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-archive.html
  retention_days = 30

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_identifier (Optional)
  # 設定内容: アーカイブの暗号化に使用するAWS KMSカスタマーマネージドキーの識別子を指定します。
  # 設定可能な値:
  #   - キーARN: arn:aws:kms:region:account-id:key/key-id
  #   - キーID: key-id
  #   - キーエイリアス: alias/key-alias
  #   - キーエイリアスARN: arn:aws:kms:region:account-id:alias/key-alias
  # 省略時: AWS所有キーで暗号化（AES-256）
  # 関連機能: EventBridgeアーカイブの暗号化
  #   カスタマーマネージドキーを使用して、アーカイブに保存されるイベントと
  #   イベントパターン（存在する場合）を暗号化できます。
  #   ソースイベントバスがカスタマーマネージドキーで暗号化されている場合は、
  #   アーカイブにもカスタマーマネージドキーを使用することが推奨されます。
  #   - https://docs.aws.amazon.com/eventbridge/latest/userguide/encryption-archives.html
  kms_key_identifier = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: アーカイブのAmazon Resource Name (ARN)
#
#---------------------------------------------------------------
