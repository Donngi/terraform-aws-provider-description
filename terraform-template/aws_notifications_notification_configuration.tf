#---------------------------------------------------------------
# AWS User Notifications Notification Configuration
#---------------------------------------------------------------
#
# AWS User Notificationsの通知設定（Notification Configuration）をプロビジョニングするリソースです。
# 通知設定は、AWSサービスのイベントに基づいて通知を生成するためのコンテナです。
# イベントルール、集約設定、配信チャネル（メール、Amazon Q Developer、
# AWSコンソールモバイルアプリ等）を管理します。
#
# AWS公式ドキュメント:
#   - 通知設定の管理: https://docs.aws.amazon.com/notifications/latest/userguide/managing-notifications.html
#   - はじめての通知設定: https://docs.aws.amazon.com/notifications/latest/userguide/getting-started.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/notifications_notification_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_notifications_notification_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 通知設定の名前を指定します。
  # 設定可能な値: 1〜64文字の文字列。RFC 3986の予約されていない文字をサポート。
  #              使用可能パターン: [A-Za-z0-9_\-]+
  name = "example-notification"

  # description (Required)
  # 設定内容: 通知設定の説明を指定します。
  # 設定可能な値: 0〜256文字の文字列
  description = "Example notification configuration"

  #-------------------------------------------------------------
  # 集約設定
  #-------------------------------------------------------------

  # aggregation_duration (Optional)
  # 設定内容: 通知の集約設定を指定します。指定した時間内に発生した類似通知をまとめます。
  #           大量のイベントが短時間に発生する場合の通知過剰を防ぐために使用します。
  # 設定可能な値:
  #   - "LONG": 12時間単位で通知を集約します
  #   - "SHORT": 5分単位で通知を集約します
  #   - "NONE": 通知を集約しません
  # 省略時: "NONE"（集約なし）
  # 参考: https://docs.aws.amazon.com/notifications/latest/userguide/getting-started.html
  aggregation_duration = "NONE"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値の文字列ペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-notification"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 通知設定のAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
