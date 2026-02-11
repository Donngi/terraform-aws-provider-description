#---------------------------------------------------------------
# AWS WorkSpaces Web Session Logger Association
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure BrowserのポータルとSession Loggerを関連付けるリソースです。
# Session Loggerはユーザーのセッションアクティビティ（ログイン/ログアウト、
# キーボード/マウス入力、アプリケーション起動、ネットワークトラフィック等）を
# キャプチャし、指定されたAmazon S3バケットにログを配信します。
#
# AWS公式ドキュメント:
#   - User activity logging: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/monitoring-logging.html
#   - Setting up Session Logger: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/session-logger.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_session_logger_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_session_logger_association" "example" {
  #-------------------------------------------------------------
  # ポータル設定
  #-------------------------------------------------------------

  # portal_arn (Required)
  # 設定内容: Session Loggerを関連付けるWorkSpaces Webポータルの
  #          Amazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なWorkSpaces Webポータルの ARN
  # 注意: この関連付けにより、指定したポータルでのユーザーセッション
  #       アクティビティがSession Loggerによってキャプチャされます。
  portal_arn = "arn:aws:workspaces-web:ap-northeast-1:123456789012:portal/example-portal-id"

  #-------------------------------------------------------------
  # Session Logger設定
  #-------------------------------------------------------------

  # session_logger_arn (Required)
  # 設定内容: ポータルに関連付けるSession LoggerのAmazon Resource Name (ARN)を
  #          指定します。
  # 設定可能な値: 有効なSession LoggerのARN
  # 関連機能: WorkSpaces Secure Browser Session Logger
  #   Session Loggerはユーザーセッションイベント（ログイン/ログアウト、
  #   キーボード/マウス入力、アプリケーション起動、ネットワークトラフィック、
  #   システムコマンド等）をキャプチャし、15分ごとまたはセッション終了時に
  #   Amazon S3バケットにログファイルを書き込みます。SIEMプラットフォームとの
  #   統合に適しています。
  #   - https://docs.aws.amazon.com/workspaces-web/latest/adminguide/session-logger.html
  # 注意: Session Loggerを有効にすると、一部のChrome機能（シークレットモード、
  #       開発者ツール、プロファイル切り替え）が無効になります。
  session_logger_arn = "arn:aws:workspaces-web:ap-northeast-1:123456789012:sessionLogger/example-session-logger-id"

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
# このリソースは入力属性以外に追加でエクスポートする属性はありません。
#---------------------------------------------------------------
