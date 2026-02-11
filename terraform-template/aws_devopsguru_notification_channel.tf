#---------------------------------------------------------------
# AWS DevOps Guru Notification Channel
#---------------------------------------------------------------
#
# Amazon DevOps Guruの通知チャネルを管理するリソースです。
# DevOps Guruがインサイトを生成した際に、Amazon SNSを通じて
# 通知を受け取るためのチャネルを設定します。
#
# DevOps Guruは、機械学習を使用してAWSリソースの運用パフォーマンスと
# 可用性を向上させるサービスです。アノマリーを検出し、インサイトとして
# 通知することで、問題の早期発見と解決を支援します。
#
# AWS公式ドキュメント:
#   - DevOps Guru概要: https://docs.aws.amazon.com/devops-guru/latest/userguide/welcome.html
#   - 通知チャネルの設定: https://docs.aws.amazon.com/devops-guru/latest/userguide/update-notifications.html
#   - API リファレンス: https://docs.aws.amazon.com/devops-guru/latest/APIReference/API_NotificationChannel.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/devopsguru_notification_channel
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_devopsguru_notification_channel" "example" {
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
  # SNS通知チャネル設定 (Required)
  #-------------------------------------------------------------
  # DevOps Guruからの通知を受け取るSNSトピックの設定です。
  # DevOps Guruは、インサイト生成時にこのトピックに通知を送信します。
  # 注意: SNSトピックが別のアカウントにある場合、DevOps Guruに通知送信の
  #       権限を付与するポリシーをトピックにアタッチする必要があります。
  #       また、トピックがAWS KMSカスタマー管理キー（CMK）で暗号化されている場合は、
  #       CMKにも適切な権限を追加する必要があります。
  # 参考: https://docs.aws.amazon.com/devops-guru/latest/APIReference/API_SnsChannelConfig.html

  sns {
    # topic_arn (Required)
    # 設定内容: 通知を送信するAmazon SNSトピックのARNを指定します。
    # 設定可能な値: 有効なSNSトピックARN
    # 注意: 標準SNSトピックがサポートされています。FIFOトピックはサポートされていません。
    topic_arn = aws_sns_topic.example.arn
  }

  #-------------------------------------------------------------
  # 通知フィルター設定 (Optional)
  #-------------------------------------------------------------
  # 通知を受け取るイベントの種類や重大度をフィルタリングできます。
  # フィルターを設定しない場合、すべての通知を受け取ります。
  # 参考: https://docs.aws.amazon.com/devops-guru/latest/APIReference/API_NotificationFilterConfig.html

  filters {
    # message_types (Optional)
    # 設定内容: 通知を受け取るイベントの種類を指定します。
    # 設定可能な値:
    #   - "NEW_INSIGHT": 新しいインサイトが生成された場合
    #   - "CLOSED_INSIGHT": インサイトがクローズされた場合
    #   - "NEW_ASSOCIATION": 新しいアノマリーがインサイトに関連付けられた場合
    #   - "SEVERITY_UPGRADED": インサイトの重大度がアップグレードされた場合
    #   - "NEW_RECOMMENDATION": 新しい推奨事項が生成された場合
    # 省略時: すべてのメッセージタイプの通知を受け取ります
    # 注意: 最大5つまで指定可能
    message_types = [
      "NEW_INSIGHT",
      "CLOSED_INSIGHT",
      "NEW_ASSOCIATION",
      "SEVERITY_UPGRADED",
      "NEW_RECOMMENDATION",
    ]

    # severities (Optional)
    # 設定内容: 通知を受け取るインサイトの重大度レベルを指定します。
    # 設定可能な値:
    #   - "LOW": 低重大度のインサイト
    #   - "MEDIUM": 中重大度のインサイト
    #   - "HIGH": 高重大度のインサイト
    # 省略時: すべての重大度レベルの通知を受け取ります
    # 注意: 最大3つまで指定可能
    severities = [
      "LOW",
      "MEDIUM",
      "HIGH",
    ]
  }
}

#---------------------------------------------------------------
# 依存リソースの例
#---------------------------------------------------------------
# DevOps Guru通知チャネルで使用するSNSトピックの例です。
# 実際の使用時は、適切なアクセスポリシーを設定してください。

# resource "aws_sns_topic" "example" {
#   name = "devopsguru-notifications"
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 通知チャネルの一意の識別子
#       36文字の英数字で構成されます
#---------------------------------------------------------------
