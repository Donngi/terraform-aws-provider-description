#---------------------------------------------------------------
# Amazon Inspector2 メンバーアカウント関連付け
#---------------------------------------------------------------
#
# Amazon Inspector の委任管理者アカウントに対して、別の AWS アカウントを
# メンバーとして関連付けるリソースです。AWS Organizations と連携し、
# 複数アカウントにまたがる脆弱性スキャンを一元管理するために使用します。
#
# AWS公式ドキュメント:
#   - メンバーアカウントの管理: https://docs.aws.amazon.com/inspector/latest/user/adding-member-accounts.html
#   - 委任管理者とメンバーアカウントの関係: https://docs.aws.amazon.com/inspector/latest/user/admin-member-relationship.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector2_member_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_inspector2_member_association" "example" {
  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Required)
  # 設定内容: Amazon Inspector の委任管理者アカウントに関連付けるメンバーアカウントの ID を指定します。
  # 設定可能な値: 12桁の AWS アカウント ID
  # 注意: このリソースを実行するアカウントが委任管理者アカウントである必要があります。
  #       また、対象アカウントが同一 AWS Organizations 組織内に存在する必要があります。
  # 参考: https://docs.aws.amazon.com/inspector/latest/user/managing-multiple-accounts.html
  account_id = "123456789012"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定で指定されたリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30m" や "1h" などの Go の時間表記形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    create = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30m" や "1h" などの Go の時間表記形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - delegated_admin_account_id: 委任管理者アカウントのアカウント ID
#
# - relationship_status: メンバー関係のステータス
#
# - updated_at: 関係の最終更新日時
#---------------------------------------------------------------
