#---------------------------------------------------------------
# AWS Pinpoint GCM Channel
#---------------------------------------------------------------
#
# Amazon Pinpoint GCM（Google Cloud Messaging）チャネルを設定するリソースです。
# このリソースにより、PinpointアプリケーションからAndroidデバイスにプッシュ通知を
# 送信するためのGCM/FCM（Firebase Cloud Messaging）チャネルを設定します。
#
# 認証方式:
#   - TOKEN方式: Service Account JSON（推奨）
#   - KEY方式: APIキー（レガシー）
#
# 注意: 認証情報（Service Account JSONおよびAPIキー）はTerraformの
# stateファイルにプレーンテキストとして保存されます。
# 機密データの取り扱いについて: https://www.terraform.io/docs/state/sensitive-data.html
#
# AWS公式ドキュメント:
#   - Amazon Pinpoint プッシュ通知: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-push.html
#   - Firebase Cloud Messaging: https://firebase.google.com/docs/cloud-messaging
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpoint_gcm_channel
#
# Provider Version: 6.28.0
# Generated: 2026-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_pinpoint_gcm_channel" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # application_id (Required)
  # 設定内容: PinpointアプリケーションIDを指定します。
  # 設定可能な値: 有効なPinpointアプリケーションID
  # 関連リソース: aws_pinpoint_app
  # 注意: このチャネルを作成する前にPinpointアプリケーションが存在している必要があります。
  application_id = aws_pinpoint_app.app.application_id

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # default_authentication_method (Required)
  # 設定内容: デフォルトの認証方式を指定します。
  # 設定可能な値:
  #   - "TOKEN": Service Account JSON方式（推奨）
  #   - "KEY": APIキー方式（レガシー）
  # 注意:
  #   - TOKEN方式を使用する場合は service_json が必須です。
  #   - KEY方式を使用する場合は api_key が必須です。
  #   - Googleは新規プロジェクトでのAPIキー方式を非推奨としており、
  #     TOKEN方式の使用を推奨しています。
  default_authentication_method = "TOKEN"

  # service_json (Optional)
  # 設定内容: Firebase Service Account JSONファイルの内容を指定します。
  # 適用条件: default_authentication_method = "TOKEN" の場合に必須
  # セキュリティ注意:
  #   - この値はstateファイルにプレーンテキストで保存されます。
  #   - ファイルパスから読み込む場合は file() 関数を使用します。
  #   - Firebase Consoleからダウンロードしたサービスアカウントキーを指定します。
  # 例: service_json = file("path/to/service-account.json")
  service_json = file("${path.module}/firebase-service-account.json")

  # api_key (Optional)
  # 設定内容: Google Cloud ConsoleからのGCM/FCM APIキーを指定します。
  # 適用条件: default_authentication_method = "KEY" の場合に必須
  # セキュリティ注意:
  #   - この値はstateファイルにプレーンテキストで保存されます。
  #   - Secrets ManagerやParameter Storeからの取得を推奨します。
  # 非推奨: Googleは新規プロジェクトでのAPIキー方式を非推奨としています。
  # api_key = "YOUR_GCM_API_KEY"
  api_key = null

  #-------------------------------------------------------------
  # チャネル制御
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: チャネルの有効/無効を制御します。
  # 設定可能な値:
  #   - true: チャネルを有効化（デフォルト）
  #   - false: チャネルを無効化
  # 省略時: true（有効）
  # 用途:
  #   - メンテナンス時やテスト時に一時的にプッシュ通知を停止する場合に使用します。
  #   - 無効化してもリソース自体は削除されません。
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
# 関連リソース例: Pinpoint アプリケーション
#---------------------------------------------------------------
# GCMチャネルを設定するために必要なPinpointアプリケーション

resource "aws_pinpoint_app" "app" {
  name = "example-pinpoint-app"

  # アプリケーション名のタグ
  tags = {
    Name        = "example-pinpoint-app"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# resource "aws_pinpoint_gcm_channel" "token_auth" {
#   application_id                = aws_pinpoint_app.app.application_id
#   default_authentication_method = "TOKEN"
#   service_json                  = file("${path.module}/firebase-service-account.json")
#   enabled                       = true
# }

#---------------------------------------------------------------
# resource "aws_pinpoint_gcm_channel" "key_auth" {
#   application_id                = aws_pinpoint_app.app.application_id
#   default_authentication_method = "KEY"
#   api_key                       = var.gcm_api_key
#   enabled                       = true
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースID（application_idと同じ値）
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のPinpoint GCMチャネルは以下の形式でインポート可能です:
#
# terraform import aws_pinpoint_gcm_channel.example application-id
#
# 例:
# terraform import aws_pinpoint_gcm_channel.example 12345678901234567890123456789012
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 1. 認証方式の選択:
#    - 新規プロジェクトではTOKEN方式（Service Account JSON）を使用してください。
#    - API Key方式はGoogleが非推奨としているため、既存プロジェクトでのみ使用してください。
#---------------------------------------------------------------
