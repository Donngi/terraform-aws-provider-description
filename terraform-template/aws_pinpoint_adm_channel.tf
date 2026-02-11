#---------------------------------------------------------------
# Amazon Pinpoint ADM Channel
#---------------------------------------------------------------
#
# Amazon Pinpoint ADM (Amazon Device Messaging) チャネルをプロビジョニングするリソースです。
# ADMチャネルを使用すると、Kindle Fire タブレットなどのAmazonデバイスで
# 実行されているアプリにプッシュ通知を送信できます。
#
# セキュリティ上の注意:
#   Client IDとClient Secretを含むすべての引数は、Terraformのステートファイルに
#   プレーンテキストとして保存されます。
#   機密情報の取り扱いには十分注意してください。
#   参考: https://www.terraform.io/docs/state/sensitive-data.html
#
# AWS公式ドキュメント:
#   - Amazon Pinpoint プッシュ通知: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-push.html
#   - ADM Channel API リファレンス: https://docs.aws.amazon.com/pinpoint/latest/apireference/apps-application-id-channels-adm.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpoint_adm_channel
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_pinpoint_adm_channel" "example" {
  #-------------------------------------------------------------
  # アプリケーション設定
  #-------------------------------------------------------------

  # application_id (Required)
  # 設定内容: Amazon Pinpoint アプリケーションのIDを指定します。
  # 設定可能な値: 有効なPinpoint アプリケーションID
  # 関連機能: Amazon Pinpoint アプリケーション
  #   ADMチャネルを有効化する対象のPinpointアプリケーションを識別します。
  #   - https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-push.html
  application_id = "example-application-id"

  #-------------------------------------------------------------
  # OAuth認証情報設定
  #-------------------------------------------------------------

  # client_id (Required, Sensitive)
  # 設定内容: Amazon Developer AccountからOAuth認証情報の一部として取得したClient IDを指定します。
  # 設定可能な値: Amazon Developer Accountから取得したClient ID文字列
  # 注意: この値はセンシティブ情報として扱われ、プレーンテキストでstateに保存されます。
  #   詳細: https://www.terraform.io/docs/state/sensitive-data.html
  # 関連機能: Amazon Device Messaging (ADM)
  #   ADMを使用してAmazonデバイスにプッシュ通知を送信するには、
  #   Amazon Developer Accountで取得したOAuth認証情報が必要です。
  #   - https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-push.html
  client_id = "your-adm-client-id"

  # client_secret (Required, Sensitive)
  # 設定内容: Amazon Developer AccountからOAuth認証情報の一部として取得したClient Secretを指定します。
  # 設定可能な値: Amazon Developer Accountから取得したClient Secret文字列
  # 注意: この値はセンシティブ情報として扱われ、プレーンテキストでstateに保存されます。
  #   詳細: https://www.terraform.io/docs/state/sensitive-data.html
  # 関連機能: Amazon Device Messaging (ADM)
  #   ADMを使用してAmazonデバイスにプッシュ通知を送信するには、
  #   Amazon Developer Accountで取得したOAuth認証情報が必要です。
  #   - https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-push.html
  client_secret = "your-adm-client-secret"

  #-------------------------------------------------------------
  # チャネル有効化設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: ADMチャネルを有効化するかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): チャネルを有効化
  #   - false: チャネルを無効化
  # 省略時: true (チャネルは有効化されます)
  # 関連機能: Amazon Pinpoint チャネル管理
  #   チャネルを無効化すると、このチャネルを通じたメッセージ送信が停止します。
  #   - https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-push.html
  enabled = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ADMチャネルのID（通常はapplication_idと同じ値）
#---------------------------------------------------------------
