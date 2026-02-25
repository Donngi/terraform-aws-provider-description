#---------------------------------------------------------------
# Amazon QuickSight Group Membership
#---------------------------------------------------------------
#
# Amazon QuickSightのグループメンバーシップをプロビジョニングするリソースです。
# 指定したグループにユーザーを追加し、グループベースのアクセス制御を実現します。
#
# AWS公式ドキュメント:
#   - Amazon QuickSightグループ管理: https://docs.aws.amazon.com/quicksight/latest/user/working-with-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_group_membership
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_group_membership" "example" {
  #-------------------------------------------------------------
  # グループ設定
  #-------------------------------------------------------------

  # group_name (Required, Forces new resource)
  # 設定内容: メンバーを追加するグループの名前を指定します。
  # 設定可能な値: 既存のQuickSightグループ名（文字列）
  group_name = "all-access-users"

  #-------------------------------------------------------------
  # メンバー設定
  #-------------------------------------------------------------

  # member_name (Required, Forces new resource)
  # 設定内容: グループに追加するユーザーの名前を指定します。
  # 設定可能な値: 既存のQuickSightユーザー名（文字列）
  member_name = "john_smith"

  #-------------------------------------------------------------
  # アカウント・名前空間設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: グループメンバーシップを管理するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーが自動的に判定したアカウントIDを使用
  aws_account_id = null

  # namespace (Optional, Forces new resource)
  # 設定内容: ユーザーが所属する名前空間を指定します。
  # 設定可能な値: 有効なQuickSight名前空間名（文字列）
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
# - arn: グループメンバーシップのAmazon Resource Name (ARN)
# - id: グループメンバーシップの識別子
#---------------------------------------------------------------
