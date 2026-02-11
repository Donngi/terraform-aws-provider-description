#---------------------------------------------------------------
# AWS WorkSpaces Secure Browser User Settings Association
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure Browser（旧WorkSpaces Web）のユーザー設定を
# ウェブポータルに関連付けるリソースです。
# ユーザー設定は、ストリーミングセッションとローカルデバイス間の
# データ転送機能（コピー/ペースト、ダウンロード、アップロード、印刷など）を
# 制御します。この関連付けにより、ポータルにアクセスするユーザーに対して
# 特定のユーザー設定が適用されます。
#
# AWS公式ドキュメント:
#   - WorkSpaces Secure Browser概要: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/what-is-workspaces-web.html
#   - ユーザー設定の構成: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/user-settings.html
#   - AssociateUserSettings API: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_AssociateUserSettings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_user_settings_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_user_settings_association" "example" {
  #-------------------------------------------------------------
  # 関連付け設定（必須）
  #-------------------------------------------------------------

  # portal_arn (Required, Forces new resource)
  # 設定内容: ユーザー設定を関連付けるウェブポータルのARNを指定します。
  # 設定可能な値: 有効なWorkSpaces Secure BrowserポータルのARN
  #   - 形式: arn:aws:workspaces-web:{region}:{account-id}:portal/{portal-id}
  #   - 最小長: 20文字、最大長: 2048文字
  # 注意: この値を変更すると、リソースが再作成されます。
  # 参考: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_AssociateUserSettings.html
  portal_arn = "arn:aws:workspaces-web:ap-northeast-1:123456789012:portal/12345678-1234-1234-1234-123456789012"

  # user_settings_arn (Required, Forces new resource)
  # 設定内容: ポータルに関連付けるユーザー設定のARNを指定します。
  # 設定可能な値: 有効なWorkSpaces Secure Browserユーザー設定のARN
  #   - 形式: arn:aws:workspaces-web:{region}:{account-id}:userSettings/{user-settings-id}
  #   - 最小長: 20文字、最大長: 2048文字
  # 関連機能: ユーザー設定
  #   ユーザー設定では、コピー/ペースト、ダウンロード/アップロード、印刷の許可、
  #   セッションタイムアウト、ツールバーの構成、WebAuthn（パスワードレスログイン）の許可などを
  #   制御できます。aws_workspacesweb_user_settingsリソースで作成します。
  #   - https://docs.aws.amazon.com/workspaces-web/latest/adminguide/user-settings.html
  # 注意: この値を変更すると、リソースが再作成されます。
  user_settings_arn = "arn:aws:workspaces-web:ap-northeast-1:123456789012:userSettings/12345678-1234-1234-1234-123456789012"

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
#
# # ウェブポータルの作成
# resource "aws_workspacesweb_portal" "example" {
#   display_name = "example-portal"
# }
#
# # ユーザー設定の作成
# resource "aws_workspacesweb_user_settings" "example" {
#   copy_allowed     = "Enabled"
#   download_allowed = "Enabled"
#   paste_allowed    = "Enabled"
#   print_allowed    = "Enabled"
#   upload_allowed   = "Enabled"
# }
#
# # ユーザー設定の関連付け
# resource "aws_workspacesweb_user_settings_association" "example" {
#   portal_arn        = aws_workspacesweb_portal.example.portal_arn
#   user_settings_arn = aws_workspacesweb_user_settings.example.user_settings_arn
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは入力として指定した属性以外の追加属性をエクスポートしません。
# 以下の属性は入力として指定した値がそのまま返されます:
#
# - portal_arn: 関連付けたウェブポータルのARN
# - user_settings_arn: 関連付けたユーザー設定のARN
# - region: リソースを管理するリージョン（computedとして自動設定）
#---------------------------------------------------------------
