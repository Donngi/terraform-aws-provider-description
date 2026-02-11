################################################################################
# AWS Pinpoint APNs Channel Resource
################################################################################
# リソース概要:
# Amazon Pinpoint APNs (Apple Push Notification service) チャネルを作成します。
# このリソースを使用すると、PinpointアプリケーションからiOSデバイスへ
# プッシュ通知を送信できます。
#
# 注意事項:
# - 全ての引数（証明書やトークンを含む）は、プレーンテキストとして
#   raw stateに保存されます。機密情報の取り扱いには注意が必要です。
# - 認証方法は証明書ベースとトークンベースの2種類があります。
#   どちらか一方を選択して設定してください。
#
# ユースケース:
# - iOSアプリへのプッシュ通知送信
# - モバイルマーケティングキャンペーンの配信
# - トランザクション通知の送信
#
# 公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpoint_apns_channel
#
# Provider Version: 6.28.0
################################################################################

resource "aws_pinpoint_apns_channel" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # application_id - (必須) PinpointアプリケーションのアプリケーションID
  # 型: string
  # 説明:
  # - このAPNsチャネルを関連付けるPinpointアプリケーションのIDを指定します
  # - aws_pinpoint_appリソースのapplication_id属性を参照することが一般的です
  # - アプリケーションは事前に作成されている必要があります
  application_id = "your-application-id" # aws_pinpoint_app.example.application_id

  ################################################################################
  # オプションパラメータ - 基本設定
  ################################################################################

  # enabled - (オプション) チャネルの有効/無効を設定
  # 型: bool
  # デフォルト: true
  # 説明:
  # - trueの場合、このチャネルは有効になり、通知を送信できます
  # - falseの場合、チャネルは無効化され、通知は送信されません
  # - 一時的にチャネルを無効化したい場合に便利です
  enabled = true

  # region - (オプション) リソースを管理するAWSリージョン
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  # 説明:
  # - このリソースを管理するAWSリージョンを指定します
  # - 未指定の場合、プロバイダー設定のリージョンが使用されます
  # - 通常は明示的に指定する必要はありません
  # region = "us-east-1"

  # default_authentication_method - (オプション) デフォルトの認証方式
  # 型: string
  # 指定可能な値: "CERTIFICATE" または "TOKEN"
  # 説明:
  # - APNsの認証方式を指定します
  # - "CERTIFICATE": 証明書ベースの認証（従来の方式）
  # - "TOKEN": トークンベースの認証（推奨される新しい方式）
  # - Amazon Pinpointコンソールから送信する全てのAPNsプッシュ通知で
  #   このデフォルト値が使用されます
  # - APIやSDKを使用してプログラムで送信する場合は、この値を上書き可能です
  # - デフォルトの認証方式が失敗した場合、Amazon Pinpointは他の方式を
  #   試行しません
  # default_authentication_method = "TOKEN"

  ################################################################################
  # 証明書ベースの認証 (Certificate Credentials)
  ################################################################################
  # 従来の認証方式。以下の2つのパラメータをセットで使用します。
  # トークンベースの認証と同時に使用できますが、default_authentication_method
  # で指定した方式が優先されます。

  # certificate - (オプション) PEMエンコードされたTLS証明書
  # 型: string
  # 機密情報: はい
  # 説明:
  # - Appleから取得したPEMエンコード形式のTLS証明書を指定します
  # - file()関数を使用して証明書ファイルを読み込むことが一般的です
  # - 証明書ベース認証を使用する場合、private_keyと併せて指定が必須です
  # 例: certificate = file("./certificate.pem")
  # certificate = "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"

  # private_key - (オプション) 証明書の秘密鍵
  # 型: string
  # 機密情報: はい
  # 説明:
  # - 証明書に対応する秘密鍵ファイル（.keyファイル）の内容を指定します
  # - file()関数を使用して秘密鍵ファイルを読み込むことが一般的です
  # - 証明書ベース認証を使用する場合、certificateと併せて指定が必須です
  # 例: private_key = file("./private_key.key")
  # private_key = "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----"

  ################################################################################
  # トークンベースの認証 (Key Credentials) - 推奨
  ################################################################################
  # Appleが推奨する新しい認証方式。以下の4つのパラメータをセットで使用します。
  # 証明書ベースの認証よりもセキュアで管理が容易です。

  # bundle_id - (オプション) iOSアプリのバンドルID
  # 型: string
  # 機密情報: はい
  # 説明:
  # - iOSアプリに割り当てられたバンドルIDを指定します
  # - Apple Developer Centerの「Certificates, IDs & Profiles」セクションの
  #   「App IDs」から確認できます
  # - トークンベース認証を使用する場合、他のトークンパラメータと併せて
  #   指定が必須です
  # 例: com.example.myapp
  # bundle_id = "com.example.myapp"

  # team_id - (オプション) Apple Developer Team ID
  # 型: string
  # 機密情報: はい
  # 説明:
  # - Apple開発者アカウントのチームに割り当てられたIDを指定します
  # - Apple Developer Centerの「Membership」ページで確認できます
  # - トークンベース認証を使用する場合、他のトークンパラメータと併せて
  #   指定が必須です
  # 例: A1B2C3D4E5
  # team_id = "A1B2C3D4E5"

  # token_key - (オプション) APNs認証キーファイル
  # 型: string
  # 機密情報: はい
  # 説明:
  # - Apple Developer Accountで認証キーを作成した際にダウンロードした
  #   .p8ファイルの内容を指定します
  # - file()関数を使用してキーファイルを読み込むことが一般的です
  # - トークンベース認証を使用する場合、他のトークンパラメータと併せて
  #   指定が必須です
  # 例: token_key = file("./AuthKey_ABC123XYZ.p8")
  # token_key = "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----"

  # token_key_id - (オプション) 署名キーのID
  # 型: string
  # 機密情報: はい
  # 説明:
  # - APNs認証キーに割り当てられたキーIDを指定します
  # - Apple Developer Centerの「Certificates, IDs & Profiles」セクションの
  #   「Keys」セクションで確認できます
  # - トークンベース認証を使用する場合、他のトークンパラメータと併せて
  #   指定が必須です
  # 例: ABC123XYZ
  # token_key_id = "ABC123XYZ"

  ################################################################################
  # 補足情報
  ################################################################################
  # 認証方式の選択ガイド:
  #
  # 【証明書ベース認証】
  # - 従来の方式
  # - 証明書の有効期限管理が必要
  # - パラメータ: certificate, private_key
  #
  # 【トークンベース認証（推奨）】
  # - Appleが推奨する新しい方式
  # - トークンに有効期限がなく、管理が容易
  # - より高いセキュリティ
  # - パラメータ: bundle_id, team_id, token_key, token_key_id
  #
  # セキュリティのベストプラクティス:
  # - 機密情報（証明書、鍵、トークン）はバージョン管理システムに
  #   コミットしないでください
  # - AWS Secrets ManagerやSSM Parameter Storeを使用して機密情報を
  #   管理することを推奨します
  # - file()関数を使用する場合、ファイルは.gitignoreに追加してください
  ################################################################################
}

################################################################################
# 使用例: 証明書ベース認証
################################################################################
# resource "aws_pinpoint_apns_channel" "certificate_auth" {
#   application_id = aws_pinpoint_app.app.application_id
#
#   enabled                        = true
#   default_authentication_method  = "CERTIFICATE"
#
#   # 証明書ベースの認証情報
#   certificate = file("./certificate.pem")
#   private_key = file("./private_key.key")
# }

################################################################################
# 使用例: トークンベース認証（推奨）
################################################################################
# resource "aws_pinpoint_apns_channel" "token_auth" {
#   application_id = aws_pinpoint_app.app.application_id
#
#   enabled                        = true
#   default_authentication_method  = "TOKEN"
#
#   # トークンベースの認証情報
#   bundle_id    = "com.example.myapp"
#   team_id      = "A1B2C3D4E5"
#   token_key    = file("./AuthKey_ABC123XYZ.p8")
#   token_key_id = "ABC123XYZ"
# }

################################################################################
# 使用例: Secrets Managerを使用した機密情報管理
################################################################################
# data "aws_secretsmanager_secret_version" "apns_credentials" {
#   secret_id = "apns-credentials"
# }
#
# locals {
#   apns_creds = jsondecode(data.aws_secretsmanager_secret_version.apns_credentials.secret_string)
# }
#
# resource "aws_pinpoint_apns_channel" "secure" {
#   application_id = aws_pinpoint_app.app.application_id
#
#   enabled                        = true
#   default_authentication_method  = "TOKEN"
#
#   bundle_id    = local.apns_creds.bundle_id
#   team_id      = local.apns_creds.team_id
#   token_key    = local.apns_creds.token_key
#   token_key_id = local.apns_creds.token_key_id
# }

################################################################################
# 使用例: 関連するPinpointアプリケーションの作成
################################################################################
# resource "aws_pinpoint_app" "app" {
#   name = "my-mobile-app"
#
#   campaign_hook {
#     lambda_function_name = aws_lambda_function.hook.arn
#     mode                 = "DELIVERY"
#   }
#
#   limits {
#     daily               = 100
#     maximum_duration    = 600
#     messages_per_second = 50
#     total               = 1000
#   }
#
#   quiet_time {
#     start = "00:00"
#     end   = "08:00"
#   }
# }
#
# resource "aws_pinpoint_apns_channel" "app_channel" {
#   application_id = aws_pinpoint_app.app.application_id
#
#   enabled                        = true
#   default_authentication_method  = "TOKEN"
#
#   bundle_id    = "com.example.myapp"
#   team_id      = "A1B2C3D4E5"
#   token_key    = file("./AuthKey.p8")
#   token_key_id = "ABC123XYZ"
# }

################################################################################
# Attributes Reference (読み取り専用属性)
################################################################################
# このリソースは以下の属性をエクスポートします:
#
# - id: APNsチャネルのユニークID（application_idと同じ値）
#
################################################################################

################################################################################
# Import
################################################################################
# 既存のAPNsチャネルは以下のコマンドでインポートできます:
#
# terraform import aws_pinpoint_apns_channel.example application-id
#
# 例:
# terraform import aws_pinpoint_apns_channel.certificate_auth 12345678901234567890123456789012
################################################################################
