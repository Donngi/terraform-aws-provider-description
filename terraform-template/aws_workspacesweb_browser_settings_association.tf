#---------------------------------------------------------------
# AWS WorkSpaces Web Browser Settings Association
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure Browserのブラウザ設定をWebポータルに関連付ける
# リソースです。ブラウザ設定には、ストリーミングセッション中のブラウザ動作を
# 制御するChrome Enterpriseポリシーなどが含まれます。
#
# AWS公式ドキュメント:
#   - AssociateBrowserSettings API: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_AssociateBrowserSettings.html
#   - BrowserSettings: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_BrowserSettings.html
#   - ブラウザポリシーの管理: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/browser-policies.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_browser_settings_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_browser_settings_association" "example" {
  #-------------------------------------------------------------
  # 関連付け設定
  #-------------------------------------------------------------

  # browser_settings_arn (Required, Forces new resource)
  # 設定内容: ポータルに関連付けるブラウザ設定のARNを指定します。
  # 設定可能な値: 有効なブラウザ設定リソースのARN
  #   - 形式: arn:aws:workspaces-web:<region>:<account-id>:browserSettings/<browser-settings-id>
  # 注意: 変更すると新しいリソースが作成されます（強制的な再作成）
  # 参考: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_BrowserSettings.html
  browser_settings_arn = aws_workspacesweb_browser_settings.example.browser_settings_arn

  # portal_arn (Required, Forces new resource)
  # 設定内容: ブラウザ設定を関連付けるWebポータルのARNを指定します。
  # 設定可能な値: 有効なWebポータルリソースのARN
  #   - 形式: arn:aws:workspaces-web:<region>:<account-id>:portal/<portal-id>
  # 注意: 変更すると新しいリソースが作成されます（強制的な再作成）
  # 関連機能: WorkSpaces Secure Browser Webポータル
  #   Webポータルは、ユーザーがブラウザベースでセキュアにアクセスできる
  #   エントリーポイントです。1つのポータルに対して1つのブラウザ設定のみ
  #   関連付けることができます。
  #   - https://docs.aws.amazon.com/workspaces-web/latest/adminguide/getting-started-step1.html
  portal_arn = aws_workspacesweb_portal.example.portal_arn

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
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは入力属性以外の追加エクスポート属性を持ちません。
# browser_settings_arnおよびportal_arnが設定値としてエクスポートされます。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 以下は、browser_settings_associationで参照するリソースの定義例です。
#
# resource "aws_workspacesweb_portal" "example" {
#   display_name = "example-portal"
# }
#
# resource "aws_workspacesweb_browser_settings" "example" {
#   browser_policy = jsonencode({
#     chromePolicies = {
#       DefaultDownloadDirectory = {
#         value = "/home/as2-streaming-user/MyFiles/TemporaryFiles1"
#       }
#     }
#   })
# }
#---------------------------------------------------------------
