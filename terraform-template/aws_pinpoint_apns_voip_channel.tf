#---------------------------------------------------------------
# AWS Pinpoint APNs VoIP Channel
#---------------------------------------------------------------
#
# Amazon Pinpoint の APNs VoIP チャネルを管理するリソースです。
# APNs (Apple Push Notification service) VoIP チャネルを使用すると、iOS アプリケーションに
# VoIP (Voice over IP) プッシュ通知を送信できます。
#
# VoIP プッシュ通知は通常のプッシュ通知と異なり、以下の特徴があります:
#   - デバイスがスリープ状態でもアプリをバックグラウンドで起動可能
#   - より高い優先度で配信される
#   - 着信通話などのリアルタイム通信に最適
#
# 認証方法には2つのタイプがあります:
#   1. 証明書ベース認証: PEM形式の証明書と秘密鍵を使用
#   2. トークンベース認証: Apple Developer アカウントの .p8 トークンキーを使用
#
# 注意事項:
#   - すべての認証情報(証明書、秘密鍵、トークン)はTerraform stateに平文で保存されます
#   - state ファイルの適切な暗号化とアクセス制御が必要です
#   - Amazon Pinpoint は 2026年10月30日にサポート終了予定です
#
# AWS公式ドキュメント:
#   - APNs VoIP Channel API: https://docs.aws.amazon.com/pinpoint/latest/apireference/apps-application-id-channels-apns_voip.html
#   - Pinpoint 概要: https://docs.aws.amazon.com/pinpoint/latest/userguide/welcome.html
#   - APNs プッシュ通知: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-mobile.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpoint_apns_voip_channel
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_pinpoint_apns_voip_channel" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # application_id (Required)
  # 設定内容: APNs VoIP チャネルを有効化する Pinpoint アプリケーションのIDを指定します。
  # 設定可能な値: Pinpoint アプリケーションの一意な識別子
  # 関連リソース: aws_pinpoint_app リソースで作成されたアプリケーションID
  # 関連機能: Amazon Pinpoint アプリケーション
  #   Pinpoint アプリケーションは、プッシュ通知、メール、SMS などの
  #   メッセージングキャンペーンを管理する基本単位です。
  #   - https://docs.aws.amazon.com/pinpoint/latest/apireference/apps.html
  application_id = aws_pinpoint_app.example.application_id

  #-------------------------------------------------------------
  # チャネル有効化設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: APNs VoIP チャネルを有効化するかどうかを指定します。
  # 設定可能な値:
  #   - true: チャネルを有効化 (デフォルト)
  #   - false: チャネルを無効化
  # 省略時: true (有効化)
  # 用途: チャネルを一時的に無効化する場合や、設定後に段階的に有効化する場合に使用
  # 注意: 無効化してもリソース自体は削除されません
  enabled = true

  #-------------------------------------------------------------
  # 認証方法の設定
  #-------------------------------------------------------------

  # default_authentication_method (Optional)
  # 設定内容: APNs に対して使用するデフォルトの認証方法を指定します。
  # 設定可能な値:
  #   - "CERTIFICATE": 証明書ベースの認証を使用
  #   - "TOKEN": トークンベースの認証を使用
  # 省略時: 設定した認証情報に基づいて自動決定
  # 注意事項:
  #   - Amazon Pinpoint コンソールから送信する全てのプッシュ通知でこの設定が使用されます
  #   - API、AWS CLI、SDK からプログラム的に送信する場合はこの設定を上書き可能です
  #   - デフォルト認証が失敗した場合、別の認証方法は試行されません
  # 関連機能: APNs 認証方式
  #   トークンベース認証は証明書認証と比較して以下の利点があります:
  #   - 有効期限がないため定期的な更新が不要
  #   - 1つのトークンで複数のアプリケーションに対応可能
  #   - https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-mobile-manage.html
  default_authentication_method = "CERTIFICATE"

  #-------------------------------------------------------------
  # 証明書ベース認証の設定
  #-------------------------------------------------------------
  # 証明書ベース認証を使用する場合、以下の2つのパラメータが必須です。
  # Apple Developer Portal から取得した証明書と秘密鍵を使用します。

  # certificate (Optional, Sensitive)
  # 設定内容: Apple から取得した PEM エンコード形式の TLS 証明書を指定します。
  # 設定可能な値: PEM 形式の証明書データ (BEGIN CERTIFICATE と END CERTIFICATE を含む)
  # 用途: 証明書ベース認証を使用する場合に private_key と組み合わせて必須
  # 取得方法:
  #   1. Apple Developer Portal にアクセス
  #   2. Certificates, Identifiers & Profiles を選択
  #   3. VoIP Services Certificate を作成してダウンロード
  # 注意: 機密情報のため、Terraform state に平文で保存されます
  # セキュリティ推奨事項:
  #   - file() 関数を使用してファイルから読み込むことを推奨
  #   - 証明書ファイルは適切にアクセス制御されたストレージに保管
  #   - state ファイルの暗号化を有効化 (S3 backend の暗号化など)
  # 関連機能: APNs 証明書
  #   - https://docs.aws.amazon.com/pinpoint/latest/apireference/apps-application-id-channels-apns_voip.html
  # 例: certificate = file("./certificates/apns_voip_certificate.pem")
  certificate = file("./certificates/apns_voip_certificate.pem")

  # private_key (Optional, Sensitive)
  # 設定内容: 証明書に対応する PEM 形式の秘密鍵ファイル (.key) を指定します。
  # 設定可能な値: PEM 形式の秘密鍵データ (BEGIN PRIVATE KEY と END PRIVATE KEY を含む)
  # 用途: 証明書ベース認証を使用する場合に certificate と組み合わせて必須
  # 注意: 非常に機密性の高い情報のため、厳重な管理が必要です
  # セキュリティ推奨事項:
  #   - file() 関数を使用してファイルから読み込むことを推奨
  #   - 秘密鍵ファイルは暗号化されたストレージに保管
  #   - ファイルパーミッションを 600 (所有者のみ読み書き) に設定
  #   - バージョン管理システム (Git など) には絶対にコミットしない
  #   - .gitignore に秘密鍵ファイルのパターンを追加
  # 関連機能: APNs 秘密鍵
  #   - https://docs.aws.amazon.com/pinpoint/latest/apireference/apps-application-id-channels-apns_voip.html
  # 例: private_key = file("./certificates/apns_voip_private_key.key")
  private_key = file("./certificates/apns_voip_private_key.key")

  #-------------------------------------------------------------
  # トークンベース認証の設定
  #-------------------------------------------------------------
  # トークンベース認証を使用する場合、以下の4つのパラメータが必須です。
  # Apple Developer アカウントで作成した認証キーを使用します。

  # bundle_id (Optional, Sensitive)
  # 設定内容: iOS アプリに割り当てられた Bundle ID を指定します。
  # 設定可能な値: iOS アプリケーションの一意な識別子 (例: com.example.myapp)
  # 用途: トークンベース認証を使用する場合に必須
  # 取得方法:
  #   1. Apple Developer Portal にアクセス
  #   2. Certificates, IDs & Profiles を選択
  #   3. Identifiers セクションで App IDs を選択
  #   4. 対象のアプリケーションを選択して Bundle ID を確認
  # 注意: 機密情報として扱われ、Terraform state に保存されます
  # 関連機能: iOS Bundle ID
  #   - https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleidentifier
  # 例: bundle_id = "com.example.myvoipapp"
  bundle_id = null

  # team_id (Optional, Sensitive)
  # 設定内容: Apple Developer アカウントのチームに割り当てられた Team ID を指定します。
  # 設定可能な値: 10文字の英数字文字列 (例: A1B2C3D4E5)
  # 用途: トークンベース認証を使用する場合に必須
  # 取得方法:
  #   1. Apple Developer Portal にアクセス
  #   2. Membership ページを開く
  #   3. Team ID を確認
  # 注意: 機密情報として扱われ、Terraform state に保存されます
  # 関連機能: Apple Developer Team
  #   - https://developer.apple.com/account/
  # 例: team_id = "A1B2C3D4E5"
  team_id = null

  # token_key (Optional, Sensitive)
  # 設定内容: Apple Developer アカウントで作成した認証キーの .p8 ファイルの内容を指定します。
  # 設定可能な値: .p8 形式のトークンキーファイルの内容
  # 用途: トークンベース認証を使用する場合に必須
  # 取得方法:
  #   1. Apple Developer Portal にアクセス
  #   2. Certificates, IDs & Profiles を選択
  #   3. Keys セクションを選択
  #   4. 新しいキーを作成するか、既存のキーをダウンロード
  #   5. APNs サービスを有効化してキーを生成
  # 注意事項:
  #   - .p8 ファイルは一度しかダウンロードできません
  #   - 紛失した場合は新しいキーを作成する必要があります
  #   - 非常に機密性の高い情報のため、厳重な管理が必要です
  # セキュリティ推奨事項:
  #   - file() 関数を使用してファイルから読み込むことを推奨
  #   - .p8 ファイルは暗号化されたストレージに保管
  #   - バージョン管理システムには絶対にコミットしない
  # 関連機能: APNs 認証トークン
  #   - https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/establishing_a_token-based_connection_to_apns
  # 例: token_key = file("./certificates/AuthKey_ABC123DEFG.p8")
  token_key = null

  # token_key_id (Optional, Sensitive)
  # 設定内容: 署名キーに割り当てられた Key ID を指定します。
  # 設定可能な値: 10文字の英数字文字列 (例: ABC123DEFG)
  # 用途: トークンベース認証を使用する場合に必須
  # 取得方法:
  #   1. Apple Developer Portal にアクセス
  #   2. Certificates, IDs & Profiles を選択
  #   3. Keys セクションでキーを選択
  #   4. Key ID を確認 (ファイル名にも含まれています: AuthKey_<KeyID>.p8)
  # 注意: 機密情報として扱われ、Terraform state に保存されます
  # 関連機能: APNs Key ID
  #   - https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/establishing_a_token-based_connection_to_apns
  # 例: token_key_id = "ABC123DEFG"
  token_key_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-east-1, ap-northeast-1, eu-west-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 用途: マルチリージョン環境で特定のリージョンにリソースを配置する場合に使用
  # 注意: リージョン変更はリソースの再作成が必要になる場合があります
  # 関連機能: AWS リージョナルエンドポイント
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id (Optional, Computed)
  # 設定内容: リソースの ID
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  # 用途: インポート時やデータソース参照時に使用
  id = null
}

#---------------------------------------------------------------
# resource "aws_pinpoint_apns_voip_channel" "certificate_auth" {
#   application_id                = aws_pinpoint_app.app.application_id
#   enabled                       = true
#   default_authentication_method = "CERTIFICATE"
#   certificate                   = file("./certificates/apns_voip_certificate.pem")
#   private_key                   = file("./certificates/apns_voip_private_key.key")
# }
#
# resource "aws_pinpoint_app" "app" {
#   name = "my-voip-app"
# }

#---------------------------------------------------------------
# resource "aws_pinpoint_apns_voip_channel" "token_auth" {
#   application_id                = aws_pinpoint_app.app.application_id
#   enabled                       = true
#   default_authentication_method = "TOKEN"
#   bundle_id                     = "com.example.myvoipapp"
#   team_id                       = "A1B2C3D4E5"
#   token_key                     = file("./certificates/AuthKey_ABC123DEFG.p8")
#   token_key_id                  = "ABC123DEFG"
# }
#
# resource "aws_pinpoint_app" "app" {
#   name = "my-voip-app"
# }

#---------------------------------------------------------------
# セキュリティのベストプラクティス
#---------------------------------------------------------------
# 1. 認証情報の管理
#    - 証明書、秘密鍵、トークンは Git リポジトリにコミットしない
#    - .gitignore に証明書ファイルのパターンを追加
#    - AWS Secrets Manager や HashiCorp Vault などのシークレット管理サービスの利用を検討
#
# 2. State ファイルの保護
#    - S3 バックエンドを使用し、暗号化を有効化
#    - State ファイルへのアクセスを最小限の権限に制限
#    - State ファイルのバージョニングを有効化してロールバックに備える
#
# 3. 認証方式の選択
#    - 長期運用の場合は、有効期限のないトークンベース認証を推奨
#    - 証明書ベース認証を使用する場合は、有効期限の管理を自動化
#
# 4. チャネルの監視
#    - CloudWatch メトリクスで配信成功率を監視
#    - 配信失敗時のアラート設定
#
# .gitignore の例:
# *.pem
# *.key
# *.p8
# certificates/
# secrets/

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの一意な識別子 (通常は application_id と同じ値)
#
# - application_id: APNs VoIP チャネルが関連付けられている Pinpoint アプリケーションの ID
#
# - enabled: チャネルが有効化されているかどうかの真偽値
#
# - default_authentication_method: 設定されているデフォルトの認証方法
#   ("CERTIFICATE" または "TOKEN")
#
# 注意: 証明書、秘密鍵、トークンなどの機密情報は属性として
#       エクスポートされませんが、Terraform state には平文で保存されます。
#---------------------------------------------------------------

#---------------------------------------------------------------
# インポート
#---------------------------------------------------------------
# 既存の APNs VoIP チャネルを Terraform 管理下に置くには、
# application_id を使用してインポートできます:
#
# terraform import aws_pinpoint_apns_voip_channel.example application-id
#---------------------------------------------------------------
