#---------------------------------------------------------------
# AWS QuickSight Role Membership
#---------------------------------------------------------------
#
# Amazon QuickSightの既存グループを既存ロールに追加するリソースです。
# ロールへのメンバーシップを管理し、グループに対してAdmin・Author・Reader等の
# アクセス権限を付与します。
#
# 注意: ロールメンバーシップAPIはQuickSightが管理するIDには使用できません。
#       このリソースはQuickSightアカウントのサブスクリプションがActive Directory
#       またはIAM Identity Center認証方式を使用している場合にのみ利用可能です。
#
# AWS公式ドキュメント:
#   - CreateRoleMembership API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateRoleMembership.html
#   - ListRoleMemberships API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ListRoleMemberships.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_role_membership
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_role_membership" "example" {
  #-------------------------------------------------------------
  # メンバー設定
  #-------------------------------------------------------------

  # member_name (Required)
  # 設定内容: ロールに追加するグループの名前を指定します。
  # 設定可能な値: QuickSightアカウント内に存在するグループ名
  member_name = "example-group"

  #-------------------------------------------------------------
  # ロール設定
  #-------------------------------------------------------------

  # role (Required)
  # 設定内容: グループを追加する対象のロールを指定します。
  # 設定可能な値:
  #   - "ADMIN": 管理者ロール。QuickSightのすべての機能にアクセス可能
  #   - "AUTHOR": 作成者ロール。データソースへの接続、ビジュアライゼーション作成、ダッシュボード公開が可能
  #   - "READER": 閲覧者ロール。インタラクティブなダッシュボードの閲覧のみ可能
  #   - "ADMIN_PRO": 管理者Proロール。Amazon Q in QuickSightなどの生成AI機能を含む管理者権限
  #   - "AUTHOR_PRO": 作成者Proロール。Amazon Q in QuickSightなどの生成AI機能を含む作成者権限
  #   - "READER_PRO": 閲覧者Proロール。Amazon Q in QuickSightなどの生成AI機能を含む閲覧者権限
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateRoleMembership.html
  role = "READER"

  #-------------------------------------------------------------
  # アカウント・名前空間設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: QuickSightロールメンバーシップを管理するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: TerraformのAWSプロバイダーが自動的に使用しているアカウントIDを使用
  aws_account_id = null

  # namespace (Optional)
  # 設定内容: ロールメンバーシップを管理する名前空間の名前を指定します。
  # 設定可能な値: QuickSightアカウント内に存在する名前空間名
  # 省略時: "default" 名前空間を使用
  namespace = "default"

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
# - id: リソースの識別子。aws_account_id, namespace, role, member_name
#       をカンマで結合した文字列
#---------------------------------------------------------------
