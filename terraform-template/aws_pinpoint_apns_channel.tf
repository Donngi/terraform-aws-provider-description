#---------------------------------------------------------------
# Amazon Pinpoint APNs Channel
#---------------------------------------------------------------
#
# Amazon Pinpoint の Apple Push Notification service (APNs) チャンネルを
# プロビジョニングするリソースです。
# APNs チャンネルを使用することで、Amazon Pinpoint から iOS デバイスへ
# プッシュ通知を送信できます。認証方式として証明書認証とトークン認証の
# 2 種類をサポートします。
#
# 注意: 全ての引数（証明書・トークンを含む）は Terraform state に
#       平文で保存されます。センシティブデータの取り扱いに注意してください。
#
# AWS公式ドキュメント:
#   - APNs チャンネル API リファレンス: https://docs.aws.amazon.com/pinpoint/latest/apireference/apps-application-id-channels-apns.html
#   - Pinpoint プッシュ通知チャンネル: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-push.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpoint_apns_channel
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_pinpoint_apns_channel" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # application_id (Required)
  # 設定内容: APNs チャンネルを関連付ける Amazon Pinpoint アプリケーションの ID を指定します。
  # 設定可能な値: 有効な Pinpoint アプリケーション ID 文字列
  application_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

  #-------------------------------------------------------------
  # チャンネル有効化設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: チャンネルを有効にするか無効にするかを指定します。
  # 設定可能な値:
  #   - true: チャンネルを有効化し、APNs 経由でプッシュ通知を送信できます
  #   - false: チャンネルを無効化します
  # 省略時: true
  enabled = true

  #-------------------------------------------------------------
  # 認証方式設定
  #-------------------------------------------------------------

  # default_authentication_method (Optional)
  # 設定内容: APNs への認証に使用するデフォルトの認証方式を指定します。
  #           Amazon Pinpoint コンソールから送信するすべての APNs プッシュ通知に
  #           このデフォルト認証方式が使用されます。
  #           プログラムから送信する場合は Amazon Pinpoint API・AWS CLI・AWS SDK で
  #           上書き可能です。デフォルト認証が失敗した場合、もう一方の認証方式は
  #           試行されません。
  # 設定可能な値:
  #   - "CERTIFICATE": 証明書認証（certificate と private_key を使用）
  #   - "TOKEN": トークン認証（bundle_id、team_id、token_key、token_key_id を使用）
  # 省略時: null（設定なし）
  default_authentication_method = "CERTIFICATE"

  #-------------------------------------------------------------
  # 証明書認証設定
  #-------------------------------------------------------------
  # 証明書認証を使用する場合は certificate と private_key の両方を指定します。
  # default_authentication_method が "CERTIFICATE" の場合、または
  # トークン認証を使用しない場合に必要です。

  # certificate (Optional, Sensitive)
  # 設定内容: Apple から取得した PEM エンコード形式の TLS 証明書を指定します。
  #           .pem ファイルの内容をそのまま文字列として指定します。
  # 設定可能な値: PEM エンコード形式の証明書文字列
  # 注意: この値は Terraform state に平文で保存されます。
  certificate = file("./certificate.pem")

  # private_key (Optional, Sensitive)
  # 設定内容: 証明書に対応する秘密鍵ファイル（.key ファイル）の内容を指定します。
  #           certificate と対になるキーファイルです。
  # 設定可能な値: 秘密鍵ファイルの文字列
  # 注意: この値は Terraform state に平文で保存されます。
  private_key = file("./private_key.key")

  #-------------------------------------------------------------
  # トークン認証設定
  #-------------------------------------------------------------
  # トークン認証を使用する場合は bundle_id・team_id・token_key・token_key_id の
  # 全てを指定します。証明書認証の代替として使用できます。

  # bundle_id (Optional, Sensitive)
  # 設定内容: iOS アプリに割り当てられたバンドル ID を指定します。
  #           Apple Developer アカウントの Certificates, IDs & Profiles の
  #           Identifiers セクションにある App IDs で確認できます。
  # 設定可能な値: iOS アプリのバンドル ID 文字列（例: com.example.myapp）
  # 省略時: null（証明書認証を使用する場合は省略可）
  # 注意: この値は Terraform state に平文で保存されます。
  bundle_id = null

  # team_id (Optional, Sensitive)
  # 設定内容: Apple Developer アカウントのチームに割り当てられた ID を指定します。
  #           Apple Developer アカウントの Membership ページで確認できます。
  # 設定可能な値: Apple Developer チーム ID 文字列（10文字の英数字）
  # 省略時: null（証明書認証を使用する場合は省略可）
  # 注意: この値は Terraform state に平文で保存されます。
  team_id = null

  # token_key (Optional, Sensitive)
  # 設定内容: 認証キーを作成した際に Apple Developer アカウントからダウンロードした
  #           .p8 ファイルの内容を指定します。
  # 設定可能な値: .p8 ファイルの内容文字列
  # 省略時: null（証明書認証を使用する場合は省略可）
  # 注意: この値は Terraform state に平文で保存されます。
  token_key = null

  # token_key_id (Optional, Sensitive)
  # 設定内容: 署名キーに割り当てられた ID を指定します。
  #           Apple Developer アカウントの Certificates, IDs & Profiles の
  #           Keys セクションで確認できます。
  # 設定可能な値: キー ID 文字列（10文字の英数字）
  # 省略時: null（証明書認証を使用する場合は省略可）
  # 注意: この値は Terraform state に平文で保存されます。
  token_key_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1、us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: APNs チャンネルのアプリケーション ID
#---------------------------------------------------------------
