#---------------------------------------------------------------
# Amazon Pinpoint Baidu Channel
#---------------------------------------------------------------
#
# Amazon Pinpoint Baidu Channelをプロビジョニングするリソースです。
# Baidu Cloud Pushは中国のモバイルデバイス向けのプッシュ通知サービスで、
# PinpointアプリケーションとBaidu Cloud Pushを統合することで、
# Android端末へのプッシュ通知を中国市場に配信できます。
#
# AWS公式ドキュメント:
#   - Amazon Pinpoint概要: https://docs.aws.amazon.com/pinpoint/latest/userguide/welcome.html
#   - Baidu Cloud Push統合: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-mobile-baidu.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpoint_baidu_channel
#
# Provider Version: 6.28.0
# Generated: 2026-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_pinpoint_baidu_channel" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # application_id (Required)
  # 設定内容: Pinpointアプリケーションの識別子を指定します。
  # 設定可能な値: 有効なPinpointアプリケーションID
  # 注意: aws_pinpoint_appリソースのapplication_id属性を参照するのが一般的です
  # 関連リソース: aws_pinpoint_app
  application_id = "your-application-id"

  #-------------------------------------------------------------
  # Baidu認証情報 (必須)
  #-------------------------------------------------------------

  # api_key (Required, Sensitive)
  # 設定内容: Baidu Cloud Pushから取得したプラットフォーム認証情報のAPIキーを指定します。
  # 設定可能な値: Baiduコンソールで発行されたAPIキー文字列
  # 注意: この値は機密情報であり、Terraformのステートファイルに平文で保存されます。
  #       AWS Secrets Managerやその他のシークレット管理ツールの使用を検討してください。
  # セキュリティ: https://www.terraform.io/docs/state/sensitive-data.html
  api_key = "your-baidu-api-key"

  # secret_key (Required, Sensitive)
  # 設定内容: Baidu Cloud Pushから取得したプラットフォーム認証情報のシークレットキーを指定します。
  # 設定可能な値: Baiduコンソールで発行されたシークレットキー文字列
  # 注意: この値は機密情報であり、Terraformのステートファイルに平文で保存されます。
  #       AWS Secrets Managerやその他のシークレット管理ツールの使用を検討してください。
  # セキュリティ: https://www.terraform.io/docs/state/sensitive-data.html
  secret_key = "your-baidu-secret-key"

  #-------------------------------------------------------------
  # チャネル有効化設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: Baiduチャネルを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: チャネルを有効化（プッシュ通知を送信可能）
  #   - false: チャネルを無効化（プッシュ通知を送信不可）
  # 省略時: true（デフォルトで有効）
  # 用途: テストや一時的な無効化が必要な場合にfalseに設定できます
  enabled = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Amazon Pinpointは一部のリージョンでのみ利用可能です。
  # 参考:
  #   - リージョナルエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #   - Pinpoint利用可能リージョン: https://docs.aws.amazon.com/general/latest/gr/pinpoint.html
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Pinpointアプリケーション識別子（application_idと同じ値）
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# resource "aws_pinpoint_app" "app" {
#   name = "example-pinpoint-app"
# }
#
# resource "aws_pinpoint_baidu_channel" "channel" {
#   application_id = aws_pinpoint_app.app.application_id
#   api_key        = var.baidu_api_key
#   secret_key     = var.baidu_secret_key
#   enabled        = true
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# セキュリティに関する重要な注意事項
#---------------------------------------------------------------
#---------------------------------------------------------------
