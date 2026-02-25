#---------------------------------------------------------------
# AWS Pinpoint APNs Sandbox Channel
#---------------------------------------------------------------
#
# Amazon Pinpoint の APNs サンドボックスチャネルを管理するリソースです。
# APNs (Apple Push Notification service) サンドボックス環境を使用して、
# 開発・テスト中の iOS アプリケーションにプッシュ通知を送信できます。
#
# 認証方法には2つのタイプがあります:
#   1. 証明書ベース認証: PEM 形式の証明書と秘密鍵を使用
#   2. トークンベース認証: Apple Developer アカウントの .p8 トークンキーを使用
#
# 注意事項:
#   - すべての認証情報 (証明書、秘密鍵、トークン) は Terraform state に
#     平文で保存されます。state ファイルの適切な暗号化とアクセス制御が必要です。
#   - Amazon Pinpoint は 2026年10月30日にサポート終了予定です
#
# AWS公式ドキュメント:
#   - APNs Sandbox Channel API: https://docs.aws.amazon.com/pinpoint/latest/apireference/apps-application-id-channels-apns_sandbox.html
#   - Pinpoint モバイルチャネル: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-mobile.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpoint_apns_sandbox_channel
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_pinpoint_apns_sandbox_channel" "example" {
  #-------------------------------------------------------------
  # アプリケーション設定
  #-------------------------------------------------------------

  # application_id (Required)
  # 設定内容: APNs サンドボックスチャネルを有効化する Pinpoint アプリケーションの ID を指定します。
  # 設定可能な値: Pinpoint アプリケーションの一意な識別子
  # 関連機能: Amazon Pinpoint アプリケーション
  #   Pinpoint アプリケーションは、プッシュ通知やメッセージングキャンペーンを
  #   管理する基本単位です。
  #   - https://docs.aws.amazon.com/pinpoint/latest/apireference/apps.html
  application_id = aws_pinpoint_app.example.application_id

  #-------------------------------------------------------------
  # チャネル有効化設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: APNs サンドボックスチャネルを有効化するかどうかを指定します。
  # 設定可能な値:
  #   - true: チャネルを有効化 (デフォルト)
  #   - false: チャネルを無効化
  # 省略時: true (有効化)
  enabled = true

  #-------------------------------------------------------------
  # 認証方式設定
  #-------------------------------------------------------------

  # default_authentication_method (Optional)
  # 設定内容: APNs サンドボックスに対して使用するデフォルトの認証方法を指定します。
  # 設定可能な値:
  #   - "CERTIFICATE": 証明書ベースの認証を使用
  #   - "TOKEN": トークンベースの認証を使用
  # 省略時: 設定した認証情報に基づいて自動決定
  # 注意: Amazon Pinpoint コンソールから送信する全てのプッシュ通知でこの設定が使用されます。
  #       API、AWS CLI、SDK からプログラム的に送信する場合はこの設定を上書き可能ですが、
  #       デフォルト認証が失敗した場合、別の認証方法は試行されません。
  # 関連機能: APNs 認証方式
  #   - https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-mobile-manage.html
  default_authentication_method = "CERTIFICATE"

  #-------------------------------------------------------------
  # 証明書ベース認証設定
  #-------------------------------------------------------------
  # 証明書ベース認証を使用する場合、certificate と private_key の両方が必須です。
  # Apple Developer Portal から取得した証明書と秘密鍵を使用します。

  # certificate (Optional, Sensitive)
  # 設定内容: Apple から取得した PEM エンコード形式の TLS 証明書を指定します。
  # 設定可能な値: PEM 形式の証明書データ (BEGIN CERTIFICATE と END CERTIFICATE を含む文字列)
  # 省略時: null (証明書ベース認証を使用しない場合は省略可能)
  # 注意: 機密情報のため Terraform state に平文で保存されます。state ファイルの暗号化を推奨します。
  # 参考: https://docs.aws.amazon.com/pinpoint/latest/apireference/apps-application-id-channels-apns_sandbox.html
  certificate = file("./certificates/apns_sandbox_certificate.pem")

  # private_key (Optional, Sensitive)
  # 設定内容: 証明書に対応する PEM 形式の秘密鍵ファイル (.key) の内容を指定します。
  # 設定可能な値: PEM 形式の秘密鍵データ (BEGIN PRIVATE KEY と END PRIVATE KEY を含む文字列)
  # 省略時: null (証明書ベース認証を使用しない場合は省略可能)
  # 注意: 非常に機密性の高い情報のため、バージョン管理システムにはコミットしないこと。
  #       Terraform state に平文で保存されます。
  # 参考: https://docs.aws.amazon.com/pinpoint/latest/apireference/apps-application-id-channels-apns_sandbox.html
  private_key = file("./certificates/apns_sandbox_private_key.key")

  #-------------------------------------------------------------
  # トークンベース認証設定
  #-------------------------------------------------------------
  # トークンベース認証を使用する場合、bundle_id / team_id / token_key / token_key_id の
  # 4つのパラメータが必須です。Apple Developer アカウントで作成した認証キーを使用します。

  # bundle_id (Optional, Sensitive)
  # 設定内容: iOS アプリに割り当てられた Bundle ID を指定します。
  # 設定可能な値: iOS アプリケーションの一意な識別子 (例: com.example.myapp)
  # 省略時: null (トークンベース認証を使用しない場合は省略可能)
  # 取得方法: Apple Developer Portal の Certificates, IDs & Profiles >
  #           Identifiers > App IDs から確認できます。
  # 注意: 機密情報として扱われ、Terraform state に保存されます。
  bundle_id = null

  # team_id (Optional, Sensitive)
  # 設定内容: Apple Developer アカウントのチームに割り当てられた Team ID を指定します。
  # 設定可能な値: 10文字の英数字文字列 (例: A1B2C3D4E5)
  # 省略時: null (トークンベース認証を使用しない場合は省略可能)
  # 取得方法: Apple Developer Portal の Membership ページから確認できます。
  # 注意: 機密情報として扱われ、Terraform state に保存されます。
  team_id = null

  # token_key (Optional, Sensitive)
  # 設定内容: Apple Developer アカウントで作成した認証キーの .p8 ファイルの内容を指定します。
  # 設定可能な値: .p8 形式のトークンキーファイルの内容
  # 省略時: null (トークンベース認証を使用しない場合は省略可能)
  # 取得方法: Apple Developer Portal の Certificates, IDs & Profiles > Keys セクションから
  #           取得します。.p8 ファイルはダウンロード後に再取得できないため注意が必要です。
  # 注意: 非常に機密性の高い情報のため、バージョン管理システムにはコミットしないこと。
  #       Terraform state に平文で保存されます。
  token_key = null

  # token_key_id (Optional, Sensitive)
  # 設定内容: 署名キーに割り当てられた Key ID を指定します。
  # 設定可能な値: 10文字の英数字文字列 (例: ABC123DEFG)
  # 省略時: null (トークンベース認証を使用しない場合は省略可能)
  # 取得方法: Apple Developer Portal の Certificates, IDs & Profiles > Keys セクションで
  #           キーを選択して確認できます (ファイル名 AuthKey_<KeyID>.p8 にも含まれます)。
  # 注意: 機密情報として扱われ、Terraform state に保存されます。
  token_key_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの一意な識別子 (通常は application_id と同じ値)
#---------------------------------------------------------------
