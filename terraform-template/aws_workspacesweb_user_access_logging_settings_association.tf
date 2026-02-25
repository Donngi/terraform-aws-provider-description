#---------------------------------------------------------------
# AWS WorkSpaces Secure Browser User Access Logging Settings Association
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure Browser（旧WorkSpaces Web）のユーザーアクセス
# ログ設定をWebポータルに関連付けるリソースです。
# 関連付けを行うと、ポータルでのユーザーセッション開始・終了やURL訪問などの
# アクセスイベントが、ユーザーアクセスログ設定で指定したKinesisデータストリームに
# リアルタイムで記録されます。
# セキュリティ監査やコンプライアンス要件への対応に活用できます。
#
# AWS公式ドキュメント:
#   - User Access Loggingの設定: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/user-access-logging.html
#   - AssociateUserAccessLoggingSettings API: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_AssociateUserAccessLoggingSettings.html
#   - セッションイベント: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/session-events-logging.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_user_access_logging_settings_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_user_access_logging_settings_association" "example" {
  #-------------------------------------------------------------
  # 関連付け設定
  #-------------------------------------------------------------

  # portal_arn (Required, Forces new resource)
  # 設定内容: ユーザーアクセスログ設定を関連付けるWebポータルのARNを指定します。
  # 設定可能な値: 有効なWorkSpaces Secure BrowserポータルのARN
  #   - 形式: arn:aws:workspaces-web:{region}:{account-id}:portal/{portal-id}
  #   - 最小長: 20文字、最大長: 2048文字
  # 注意: この値を変更すると、リソースが再作成されます。
  # 参考: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_AssociateUserAccessLoggingSettings.html
  portal_arn = "arn:aws:workspaces-web:ap-northeast-1:123456789012:portal/12345678-1234-1234-1234-123456789012"

  # user_access_logging_settings_arn (Required, Forces new resource)
  # 設定内容: ポータルに関連付けるユーザーアクセスログ設定のARNを指定します。
  # 設定可能な値: 有効なWorkSpaces Secure Browserユーザーアクセスログ設定のARN
  #   - 形式: arn:aws:workspaces-web:{region}:{account-id}:userAccessLoggingSettings/{settings-id}
  #   - 最小長: 20文字、最大長: 2048文字
  # 関連機能: ユーザーアクセスログ設定
  #   ユーザーアクセスログ設定は、Kinesisデータストリームへのログ配信設定を含み、
  #   aws_workspacesweb_user_access_logging_settingsリソースで作成します。
  #   ストリーム名は "amazon-workspaces-web-" で始まる必要があります。
  #   - https://docs.aws.amazon.com/workspaces-web/latest/adminguide/user-access-logging.html
  # 注意: この値を変更すると、リソースが再作成されます。
  user_access_logging_settings_arn = "arn:aws:workspaces-web:ap-northeast-1:123456789012:userAccessLoggingSettings/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは入力として指定した属性以外の追加属性をエクスポートしません。
# 以下の属性は入力として指定した値がそのまま返されます:
#
# - portal_arn: 関連付けたWebポータルのARN
# - user_access_logging_settings_arn: 関連付けたユーザーアクセスログ設定のARN
# - region: リソースを管理するリージョン（computedとして自動設定）
#---------------------------------------------------------------
