#---------------------------------------------------------------
# AWS AppStream 2.0 Stack
#---------------------------------------------------------------
#
# Amazon AppStream 2.0のスタックをプロビジョニングするリソースです。
# スタックは、フリート、ユーザーアクセスポリシー、およびストレージ設定を含み、
# ユーザーへのアプリケーションストリーミングを開始するために設定します。
#
# AWS公式ドキュメント:
#   - AppStream 2.0概要: https://docs.aws.amazon.com/appstream2/latest/developerguide/what-is-appstream.html
#   - スタックとフリート: https://docs.aws.amazon.com/appstream2/latest/developerguide/managing-stacks-fleets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_stack
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appstream_stack" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: AppStreamスタックの一意な名前を指定します。
  # 設定可能な値: 文字列
  name = "my-appstream-stack"

  # description (Optional)
  # 設定内容: AppStreamスタックの説明を指定します。
  # 設定可能な値: 文字列
  description = "My AppStream 2.0 stack for application streaming"

  # display_name (Optional)
  # 設定内容: 表示用のスタック名を指定します。
  # 設定可能な値: 文字列
  # 用途: ユーザーに表示される名前として使用
  display_name = "My Application Stack"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # URL設定
  #-------------------------------------------------------------

  # redirect_url (Optional)
  # 設定内容: ストリーミングセッション終了後にユーザーがリダイレクトされるURLを指定します。
  # 設定可能な値: 有効なURL文字列
  redirect_url = "https://example.com/session-ended"

  # feedback_url (Optional)
  # 設定内容: ユーザーが「フィードバックを送信」リンクをクリックした際にリダイレクトされるURLを指定します。
  # 設定可能な値: 有効なURL文字列
  # 注意: URLを指定しない場合、「フィードバックを送信」リンクは表示されません
  feedback_url = "https://example.com/feedback"

  #-------------------------------------------------------------
  # 埋め込みホストドメイン設定
  #-------------------------------------------------------------

  # embed_host_domains (Optional)
  # 設定内容: AppStream 2.0ストリーミングセッションをiframeに埋め込むことができるドメインを指定します。
  # 設定可能な値: ドメイン名のセット
  # 関連機能: 埋め込みAppStreamストリーミング
  #   AppStream 2.0ストリーミングセッションを承認されたドメインのWebページに埋め込むことができます。
  embed_host_domains = [
    "example.com",
    "app.example.com"
  ]

  #-------------------------------------------------------------
  # アクセスエンドポイント設定
  #-------------------------------------------------------------

  # access_endpoints (Optional, max 4)
  # 設定内容: インターフェースVPCエンドポイントの設定を定義します。
  # 用途: スタックのユーザーは指定されたエンドポイントを通じてのみAppStream 2.0に接続できます。
  # 関連機能: VPCエンドポイント
  #   - https://docs.aws.amazon.com/appstream2/latest/APIReference/API_AccessEndpoint.html
  access_endpoints {
    # endpoint_type (Required)
    # 設定内容: インターフェースエンドポイントのタイプを指定します。
    # 設定可能な値: AccessEndpoint APIドキュメントで定義された有効な値
    endpoint_type = "STREAMING"

    # vpce_id (Optional)
    # 設定内容: インターフェースエンドポイントが使用されるVPCのIDを指定します。
    # 設定可能な値: 有効なVPCエンドポイントID
    vpce_id = "vpce-0123456789abcdef0"
  }

  #-------------------------------------------------------------
  # アプリケーション設定の永続化
  #-------------------------------------------------------------

  # application_settings (Optional)
  # 設定内容: アプリケーション設定の永続化を構成します。
  # 用途: ユーザーのアプリケーション設定をセッション間で保持
  application_settings {
    # enabled (Required)
    # 設定内容: アプリケーション設定を永続化するかどうかを指定します。
    # 設定可能な値:
    #   - true: アプリケーション設定を永続化
    #   - false: アプリケーション設定を永続化しない
    enabled = true

    # settings_group (Optional)
    # 設定内容: 設定グループの名前を指定します。
    # 設定可能な値: 最大100文字の文字列
    # 注意: enabledがtrueの場合は必須
    settings_group = "MySettingsGroup"
  }

  #-------------------------------------------------------------
  # ストレージコネクタ設定
  #-------------------------------------------------------------

  # storage_connectors (Optional)
  # 設定内容: 有効にするストレージコネクタの設定を定義します。
  # 用途: ユーザーがストリーミングセッション中にファイルを保存・アクセスできるようにする
  storage_connectors {
    # connector_type (Required)
    # 設定内容: ストレージコネクタのタイプを指定します。
    # 設定可能な値:
    #   - "HOMEFOLDERS": ホームフォルダ（Amazon S3バケット）
    #   - "GOOGLE_DRIVE": Google Drive
    #   - "ONE_DRIVE": Microsoft OneDrive
    connector_type = "HOMEFOLDERS"

    # domains (Optional)
    # 設定内容: アカウントのドメイン名を指定します。
    # 設定可能な値: ドメイン名のリスト
    # 用途: GOOGLE_DRIVEまたはONE_DRIVEの場合に使用
    domains = null

    # resource_identifier (Optional)
    # 設定内容: ストレージコネクタのARNを指定します。
    # 設定可能な値: 有効なARN文字列
    resource_identifier = null
  }

  storage_connectors {
    connector_type = "GOOGLE_DRIVE"
    domains        = ["example.com"]
  }

  #-------------------------------------------------------------
  # ユーザー設定
  #-------------------------------------------------------------

  # user_settings (Optional)
  # 設定内容: ストリーミングセッション中にユーザーが利用可能または無効にされるアクションを定義します。
  # 注意: 指定しない場合、AWSによって自動的に構成されます。
  #       指定する場合は、構成可能な各アクションのブロックを含める必要があります。

  # タイムゾーン自動リダイレクト
  user_settings {
    # action (Required)
    # 設定内容: 有効または無効にするアクションを指定します。
    # 設定可能な値:
    #   - "AUTO_TIME_ZONE_REDIRECTION": タイムゾーン自動リダイレクト
    #   - "CLIPBOARD_COPY_FROM_LOCAL_DEVICE": ローカルデバイスからのクリップボードコピー
    #   - "CLIPBOARD_COPY_TO_LOCAL_DEVICE": ローカルデバイスへのクリップボードコピー
    #   - "DOMAIN_PASSWORD_SIGNIN": ドメインパスワードサインイン
    #   - "DOMAIN_SMART_CARD_SIGNIN": ドメインスマートカードサインイン
    #   - "FILE_UPLOAD": ファイルアップロード
    #   - "FILE_DOWNLOAD": ファイルダウンロード
    #   - "PRINTING_TO_LOCAL_DEVICE": ローカルデバイスへの印刷
    action = "AUTO_TIME_ZONE_REDIRECTION"

    # permission (Required)
    # 設定内容: アクションを有効にするか無効にするかを指定します。
    # 設定可能な値:
    #   - "ENABLED": アクションを有効化
    #   - "DISABLED": アクションを無効化
    permission = "ENABLED"
  }

  # クリップボード（ローカルデバイスから）
  user_settings {
    action     = "CLIPBOARD_COPY_FROM_LOCAL_DEVICE"
    permission = "ENABLED"
  }

  # クリップボード（ローカルデバイスへ）
  user_settings {
    action     = "CLIPBOARD_COPY_TO_LOCAL_DEVICE"
    permission = "ENABLED"
  }

  # ドメインパスワードサインイン
  user_settings {
    action     = "DOMAIN_PASSWORD_SIGNIN"
    permission = "ENABLED"
  }

  # ドメインスマートカードサインイン
  user_settings {
    action     = "DOMAIN_SMART_CARD_SIGNIN"
    permission = "DISABLED"
  }

  # ファイルアップロード
  user_settings {
    action     = "FILE_UPLOAD"
    permission = "ENABLED"
  }

  # ファイルダウンロード
  user_settings {
    action     = "FILE_DOWNLOAD"
    permission = "ENABLED"
  }

  # ローカルデバイスへの印刷
  user_settings {
    action     = "PRINTING_TO_LOCAL_DEVICE"
    permission = "ENABLED"
  }

  #-------------------------------------------------------------
  # ストリーミングエクスペリエンス設定
  #-------------------------------------------------------------

  # streaming_experience_settings (Optional)
  # 設定内容: スタックが優先するストリーミングプロトコルを指定します。
  # 用途: ストリーミングパフォーマンスの最適化
  streaming_experience_settings {
    # preferred_protocol (Optional)
    # 設定内容: 優先するストリーミングプロトコルを指定します。
    # 設定可能な値:
    #   - "TCP": TCPプロトコル
    #   - "UDP": UDPプロトコル（現在Windowsネイティブクライアントでのみサポート）
    preferred_protocol = "TCP"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-appstream-stack"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AppStreamスタックのAmazon Resource Name (ARN)
#
# - created_time: スタックが作成された日時（UTCおよび拡張RFC 3339形式）
#
# - id: AppStreamスタックの一意なID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
