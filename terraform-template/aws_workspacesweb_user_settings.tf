#---------------------------------------------------------------
# AWS WorkSpaces Secure Browser User Settings
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure Browser（旧称: Amazon WorkSpaces Web）の
# ユーザー設定をプロビジョニングするリソースです。
# ウェブポータルに関連付けると、ストリーミングセッションとローカルデバイス間の
# データ転送方法（コピー、ペースト、ダウンロード、アップロード、印刷等）を制御します。
#
# AWS公式ドキュメント:
#   - WorkSpaces Secure Browser概要: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/what-is-workspaces-secure-browser.html
#   - ユーザー設定の構成: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/user-settings.html
#   - ツールバーコントロール: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/toolbar-controls.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_user_settings
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_user_settings" "example" {
  #-------------------------------------------------------------
  # クリップボード設定（必須）
  #-------------------------------------------------------------

  # copy_allowed (Required)
  # 設定内容: ストリーミングセッションからローカルデバイスへのテキストコピーを許可するかを指定します。
  # 設定可能な値:
  #   - "Enabled": コピーを許可
  #   - "Disabled": コピーを禁止
  # 関連機能: クリップボード制御
  #   セッションとローカルデバイス間のクリップボード操作を細かく制御できます。
  #   コピーのみ、ペーストのみ、または両方を個別に設定可能。
  #   - https://docs.aws.amazon.com/workspaces-web/latest/adminguide/toolbar-controls.html
  copy_allowed = "Enabled"

  # paste_allowed (Required)
  # 設定内容: ローカルデバイスからストリーミングセッションへのテキストペーストを許可するかを指定します。
  # 設定可能な値:
  #   - "Enabled": ペーストを許可
  #   - "Disabled": ペーストを禁止
  # 関連機能: クリップボード制御
  #   - https://docs.aws.amazon.com/workspaces-web/latest/adminguide/toolbar-controls.html
  paste_allowed = "Enabled"

  #-------------------------------------------------------------
  # ファイル転送設定（必須）
  #-------------------------------------------------------------

  # download_allowed (Required)
  # 設定内容: ストリーミングセッションからローカルデバイスへのファイルダウンロードを許可するかを指定します。
  # 設定可能な値:
  #   - "Enabled": ダウンロードを許可
  #   - "Disabled": ダウンロードを禁止
  # 関連機能: ファイル転送制御
  #   アップロードのみ、ダウンロードのみ、または両方を個別に設定可能。
  #   データ漏洩防止のため、機密データを扱う環境ではダウンロードを禁止することが推奨されます。
  #   - https://docs.aws.amazon.com/workspaces-web/latest/adminguide/toolbar-controls.html
  download_allowed = "Enabled"

  # upload_allowed (Required)
  # 設定内容: ローカルデバイスからストリーミングセッションへのファイルアップロードを許可するかを指定します。
  # 設定可能な値:
  #   - "Enabled": アップロードを許可
  #   - "Disabled": アップロードを禁止
  # 関連機能: ファイル転送制御
  #   - https://docs.aws.amazon.com/workspaces-web/latest/adminguide/toolbar-controls.html
  upload_allowed = "Enabled"

  #-------------------------------------------------------------
  # 印刷設定（必須）
  #-------------------------------------------------------------

  # print_allowed (Required)
  # 設定内容: ストリーミングセッションからローカルデバイスへの印刷を許可するかを指定します。
  # 設定可能な値:
  #   - "Enabled": 印刷を許可
  #   - "Disabled": 印刷を禁止
  # 参考: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/user-settings.html
  print_allowed = "Enabled"

  #-------------------------------------------------------------
  # ディープリンク設定
  #-------------------------------------------------------------

  # deep_link_allowed (Optional)
  # 設定内容: セッション接続時に自動的に開くディープリンクの使用を許可するかを指定します。
  # 設定可能な値:
  #   - "Enabled": ディープリンクを許可
  #   - "Disabled": ディープリンクを禁止
  # 省略時: プロバイダーによって自動設定されます
  # 関連機能: ディープリンク
  #   ウェブポータルへの直接アクセスリンクを許可します。
  #   - https://docs.aws.amazon.com/workspaces-web/latest/adminguide/deep-links.html
  deep_link_allowed = "Enabled"

  #-------------------------------------------------------------
  # セッションタイムアウト設定
  #-------------------------------------------------------------

  # disconnect_timeout_in_minutes (Optional)
  # 設定内容: ユーザーが切断された後、ストリーミングセッションがアクティブなままになる時間（分）を指定します。
  # 設定可能な値: 1〜600の整数
  # 省略時: プロバイダーのデフォルト値
  # 注意: この時間内に再接続すると、前のセッションに復帰します。
  #       時間を超えると新しいセッションが開始されます。
  #       ユーザーが明示的にセッションを終了した場合、このタイムアウトは適用されません。
  # 参考: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/user-settings.html
  disconnect_timeout_in_minutes = 30

  # idle_disconnect_timeout_in_minutes (Optional)
  # 設定内容: ユーザーがアイドル状態（非アクティブ）でいられる時間（分）を指定します。
  #           この時間を超えるとセッションから切断され、disconnect_timeout_in_minutesのカウントが開始されます。
  # 設定可能な値: 0〜60の整数
  # 省略時: プロバイダーのデフォルト値
  # 注意: 0に設定するとアイドルタイムアウトが無効になり、非アクティブによる切断は行われません。
  #       キーボード・マウス入力のみがアクティビティとしてカウントされます。
  #       ファイル転送、オーディオ、画面変更はアクティビティとしてカウントされません。
  # 参考: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/user-settings.html
  idle_disconnect_timeout_in_minutes = 15

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # customer_managed_key (Optional)
  # 設定内容: ユーザー設定の暗号化に使用するカスタマーマネージドKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: AWSマネージドキーが使用されます
  # 関連機能: カスタマーマネージドキー暗号化
  #   データの暗号化にカスタマーマネージドキーを使用することで、
  #   暗号化キーのライフサイクルを完全に制御できます。
  customer_managed_key = null

  # additional_encryption_context (Optional)
  # 設定内容: 暗号化コンテキストに追加するキーと値のペアを指定します。
  # 設定可能な値: 文字列のマップ
  # 省略時: 追加の暗号化コンテキストなし
  # 注意: customer_managed_keyを指定した場合に使用されます。
  #       暗号化コンテキストは、暗号化操作の追加認証データとして機能します。
  additional_encryption_context = {
    Environment = "production"
  }

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
  # ツールバー設定
  #-------------------------------------------------------------

  # toolbar_configuration (Optional)
  # 設定内容: セッション中のツールバーの表示と動作を設定します。
  # 関連機能: ツールバーコントロール
  #   ツールバーのテーマ、状態、アイコンの表示、最大解像度を設定できます。
  #   未設定の場合、エンドユーザーがこれらのオプションを自由に制御できます。
  #   - https://docs.aws.amazon.com/workspaces-web/latest/adminguide/toolbar-controls.html
  toolbar_configuration {
    # toolbar_type (Optional)
    # 設定内容: セッション中に表示されるツールバーのタイプを指定します。
    # 設定可能な値:
    #   - "Docked": ツールバーを画面端に固定表示
    #   - "Detached": ツールバーをフローティング表示
    # 省略時: エンドユーザーが制御可能
    # 注意: 設定するとエンドユーザーはツールバー状態を変更できなくなります。
    toolbar_type = "Docked"

    # visual_mode (Optional)
    # 設定内容: ツールバーのビジュアルモード（テーマ）を指定します。
    # 設定可能な値:
    #   - "Dark": ダークモード
    #   - "Light": ライトモード
    # 省略時: エンドユーザーが制御可能
    # 注意: 設定するとエンドユーザーはテーマを変更できなくなります。
    visual_mode = "Dark"

    # max_display_resolution (Optional)
    # 設定内容: セッションで許可される最大表示解像度を指定します。
    # 設定可能な値:
    #   - "size1280X720": HD解像度 (1280x720)
    #   - "size1920X1080": フルHD解像度 (1920x1080)
    #   - "size3840X2160": 4K解像度 (3840x2160)
    # 省略時: 制限なし
    # 注意: ユーザーはこの解像度以下のみ選択可能になります。
    #   - https://docs.aws.amazon.com/workspaces-web/latest/adminguide/toolbar-controls.html
    max_display_resolution = "size1920X1080"

    # hidden_toolbar_items (Optional)
    # 設定内容: ツールバーから非表示にする項目のリストを指定します。
    # 設定可能な値:
    #   - "Webcam": ウェブカメラアイコンを非表示
    #   - "Microphone": マイクアイコンを非表示
    #   - "DualMonitor": デュアルモニターアイコンを非表示
    #   - "FullScreen": フルスクリーンアイコンを非表示
    #   - "Windows": ウィンドウ切り替えアイコンを非表示
    # 省略時: すべてのアイコンが表示されます
    # 参考: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/toolbar-controls.html
    hidden_toolbar_items = ["Webcam", "Microphone"]
  }

  #-------------------------------------------------------------
  # Cookie同期設定
  #-------------------------------------------------------------

  # cookie_synchronization_configuration (Optional)
  # 設定内容: エンドユーザーのローカルブラウザからリモートブラウザに同期するCookieを指定します。
  # 関連機能: Cookie同期
  #   シングルサインオン（SSO）やセッション管理のために、
  #   特定のCookieをローカルブラウザからリモートセッションに同期できます。
  #   allowlistは最大10項目、blocklistは最大10項目まで設定可能です。
  #   - https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_CookieSynchronizationConfiguration.html
  cookie_synchronization_configuration {
    # allowlist (Required within block)
    # 設定内容: リモートブラウザへの同期を許可するCookieのリストを指定します。
    # 注意: 最大10項目まで指定可能です。
    allowlist {
      # domain (Required)
      # 設定内容: Cookieのドメインを指定します。
      # 設定可能な値: 有効なドメイン名
      domain = "example.com"

      # name (Optional)
      # 設定内容: Cookieの名前を指定します。
      # 省略時: 指定したドメインのすべてのCookieが対象
      name = null

      # path (Optional)
      # 設定内容: Cookieのパスを指定します。
      # 省略時: すべてのパスが対象
      path = "/app"
    }

    # blocklist (Optional)
    # 設定内容: リモートブラウザへの同期をブロックするCookieのリストを指定します。
    # 注意: allowlistで許可されたCookieのうち、特定のものを除外する場合に使用します。
    #       最大10項目まで指定可能です。
    blocklist {
      # domain (Required)
      # 設定内容: Cookieのドメインを指定します。
      domain = "blocked.example.com"

      # name (Optional)
      # 設定内容: Cookieの名前を指定します。
      name = null

      # path (Optional)
      # 設定内容: Cookieのパスを指定します。
      path = null
    }
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
    Name        = "example-user-settings"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - user_settings_arn: ユーザー設定リソースのAmazon Resource Name (ARN)
#
# - associated_portal_arns: このユーザー設定に関連付けられたウェブポータルのARNリスト
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
