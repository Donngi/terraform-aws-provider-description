#---------------------------------------------------------------
# AWS WorkSpaces Web IP Access Settings Association
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure BrowserのウェブポータルにIPアクセス設定を
# 関連付けるリソースです。IPアクセス設定はバーチャルファイアウォールとして機能し、
# 信頼済みIPアドレス（IPv4のみ）からのみポータルへのアクセスを許可します。
# 認証前にユーザーのIPアドレスを検出し、信頼済みネットワークからの
# 接続を継続的に監視します。
#
# AWS公式ドキュメント:
#   - IPアクセス設定の関連付け: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/associate-ip-access-controls.html
#   - IPアクセス制御の管理: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/ip-access-controls.html
#   - AssociateIpAccessSettings API: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_AssociateIpAccessSettings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_ip_access_settings_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_ip_access_settings_association" "example" {
  #-------------------------------------------------------------
  # 関連付け設定
  #-------------------------------------------------------------

  # ip_access_settings_arn (Required, Forces new resource)
  # 設定内容: ポータルに関連付けるIPアクセス設定のARNを指定します。
  # 設定可能な値: 有効なaws_workspacesweb_ip_access_settingsリソースのARN
  # 注意: 変更するとリソースが再作成されます。
  # 参考: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_AssociateIpAccessSettings.html
  ip_access_settings_arn = aws_workspacesweb_ip_access_settings.example.ip_access_settings_arn

  # portal_arn (Required, Forces new resource)
  # 設定内容: IPアクセス設定を関連付けるウェブポータルのARNを指定します。
  # 設定可能な値: 有効なaws_workspacesweb_portalリソースのARN
  # 注意: 変更するとリソースが再作成されます。
  # 参考: https://docs.aws.amazon.com/workspaces-web/latest/APIReference/API_AssociateIpAccessSettings.html
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
# このリソースは以下の属性をエクスポートします:
#
# - id: 関連付けのID（portal_arnと同一の値）
#---------------------------------------------------------------
