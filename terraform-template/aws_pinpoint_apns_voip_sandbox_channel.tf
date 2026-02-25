#---------------------------------------------------------------
# Amazon Pinpoint APNs VoIP Sandbox Channel
#---------------------------------------------------------------
#
# Amazon PinpointアプリケーションのAPNs VoIP Sandboxチャネルをプロビジョニングするリソースです。
# Apple Push Notification service (APNs) のサンドボックス環境向けに
# VoIP通知メッセージを送信するためのチャネル設定を管理します。
# 証明書認証またはトークン認証の2つの認証方式をサポートします。
#
# 注意: 2026年10月30日にAWSはAmazon Pinpointのサポートを終了する予定です。
#       SMS、音声、モバイルプッシュ、OTP、電話番号検証に関連するAPIは
#       AWS End User Messagingとしてサポートが継続されます。
#
# AWS公式ドキュメント:
#   - APNs VoIP Sandbox Channel: https://docs.aws.amazon.com/pinpoint/latest/apireference/apps-application-id-channels-apns_voip_sandbox.html
#   - Amazon Pinpointプッシュ通知: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-push.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpoint_apns_voip_sandbox_channel
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_pinpoint_apns_voip_sandbox_channel" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # application_id (Required)
  # 設定内容: このチャネルを関連付けるAmazon PinpointアプリケーションのIDを指定します。
  # 設定可能な値: 有効なPinpointアプリケーションID文字列
  application_id = "example-application-id"

  #-------------------------------------------------------------
  # チャネル有効化設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: チャネルを有効または無効にするかを指定します。
  # 設定可能な値:
  #   - true: チャネルを有効化（デフォルト）
  #   - false: チャネルを無効化
  # 省略時: true（チャネルは有効）
  enabled = true

  #-------------------------------------------------------------
  # 認証方式設定
  #-------------------------------------------------------------

  # default_authentication_method (Optional)
  # 設定内容: APNsに使用するデフォルト認証方式を指定します。
  # 設定可能な値:
  #   - "CERTIFICATE": 証明書認証を使用。certificate と private_key の指定が必要
  #   - "TOKEN": トークン認証を使用。bundle_id、team_id、token_key、token_key_id の指定が必要
  # 省略時: Amazon Pinpointコンソールで設定された認証方式を使用
  # 注意: デフォルト認証タイプが失敗した場合、Pinpointは他の認証タイプを試みません。
  #       プログラムによるメッセージ送信時はAPIやCLIでデフォルトを上書き可能です。
  default_authentication_method = "CERTIFICATE"

  #-------------------------------------------------------------
  # 証明書認証設定
  #-------------------------------------------------------------
  # 証明書認証を使用する場合、certificate と private_key の両方が必要です。

  # certificate (Optional, Sensitive)
  # 設定内容: AppleのPEMエンコードされたTLS証明書を指定します。
  # 設定可能な値: PEM形式の証明書文字列
  # 省略時: トークン認証を使用する場合は省略可能
  # 注意: この値はTerraformのstateにプレーンテキストで保存されます。
  #       センシティブな値の取り扱いに注意してください。
  certificate = null

  # private_key (Optional, Sensitive)
  # 設定内容: 証明書の秘密鍵ファイル（.keyファイル）の内容を指定します。
  # 設定可能な値: PEM形式の秘密鍵文字列
  # 省略時: トークン認証を使用する場合は省略可能
  # 注意: この値はTerraformのstateにプレーンテキストで保存されます。
  #       センシティブな値の取り扱いに注意してください。
  private_key = null

  #-------------------------------------------------------------
  # トークン認証設定
  #-------------------------------------------------------------
  # トークン認証を使用する場合、bundle_id、team_id、token_key、token_key_id の全てが必要です。

  # bundle_id (Optional, Sensitive)
  # 設定内容: iOSアプリに割り当てられたバンドルIDを指定します。
  # 設定可能な値: AppleデベロッパーアカウントのアプリバンドルID文字列
  # 省略時: 証明書認証を使用する場合は省略可能
  # 参考: Apple Developer Consoleの「Certificates, IDs & Profiles」>「App IDs」から確認可能
  # 注意: この値はTerraformのstateにプレーンテキストで保存されます。
  bundle_id = null

  # team_id (Optional, Sensitive)
  # 設定内容: Appleデベロッパーアカウントのチームに割り当てられたIDを指定します。
  # 設定可能な値: AppleデベロッパーアカウントのチームID文字列
  # 省略時: 証明書認証を使用する場合は省略可能
  # 参考: Apple Developer Consoleの「Membership」ページから確認可能
  # 注意: この値はTerraformのstateにプレーンテキストで保存されます。
  team_id = null

  # token_key (Optional, Sensitive)
  # 設定内容: 認証キー作成時にAppleデベロッパーアカウントからダウンロードした.p8ファイルの内容を指定します。
  # 設定可能な値: .p8ファイルのテキスト内容
  # 省略時: 証明書認証を使用する場合は省略可能
  # 注意: この値はTerraformのstateにプレーンテキストで保存されます。
  token_key = null

  # token_key_id (Optional, Sensitive)
  # 設定内容: 署名キーに割り当てられたIDを指定します。
  # 設定可能な値: Appleデベロッパーアカウントの署名キーID文字列
  # 省略時: 証明書認証を使用する場合は省略可能
  # 参考: Apple Developer Consoleの「Certificates, IDs & Profiles」>「Keys」から確認可能
  # 注意: この値はTerraformのstateにプレーンテキストで保存されます。
  token_key_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
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
# - id: PinpointアプリケーションのID（application_idと同値）
#---------------------------------------------------------------
