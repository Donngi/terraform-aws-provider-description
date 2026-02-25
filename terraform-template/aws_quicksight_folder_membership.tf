#---------------------------------------------------------------
# AWS QuickSight Folder Membership
#---------------------------------------------------------------
#
# Amazon QuickSightのフォルダメンバーシップをプロビジョニングするリソースです。
# ダッシュボード・分析・データセットといったアセットをフォルダに関連付けることで、
# コンテンツの整理とアクセス管理を統合的に行えます。
#
# AWS公式ドキュメント:
#   - QuickSight フォルダの操作: https://docs.aws.amazon.com/quicksight/latest/user/folders.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_folder_membership
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_folder_membership" "example" {
  #-------------------------------------------------------------
  # フォルダ設定
  #-------------------------------------------------------------

  # folder_id (Required, Forces new resource)
  # 設定内容: メンバーシップを追加するフォルダの識別子を指定します。
  # 設定可能な値: 既存のQuickSightフォルダのフォルダIDを示す文字列
  # 参考: https://docs.aws.amazon.com/quicksight/latest/user/folders.html
  folder_id = "example-folder-id"

  #-------------------------------------------------------------
  # メンバー設定
  #-------------------------------------------------------------

  # member_type (Required, Forces new resource)
  # 設定内容: フォルダに追加するアセットの種別を指定します。
  # 設定可能な値:
  #   - "ANALYSIS"  : 分析（Analysis）をフォルダに追加します
  #   - "DASHBOARD" : ダッシュボード（Dashboard）をフォルダに追加します
  #   - "DATASET"   : データセット（DataSet）をフォルダに追加します
  member_type = "DATASET"

  # member_id (Required, Forces new resource)
  # 設定内容: フォルダに追加するアセット（ダッシュボード・分析・データセット）のIDを指定します。
  # 設定可能な値: member_typeに対応するアセットのIDを示す文字列
  #   - member_type = "ANALYSIS"  の場合: 分析のanalysis_id
  #   - member_type = "DASHBOARD" の場合: ダッシュボードのdashboard_id
  #   - member_type = "DATASET"   の場合: データセットのdata_set_id
  member_id = "example-dataset-id"

  #-------------------------------------------------------------
  # アカウント・リージョン設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: リソースを作成するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: TerraformのAWSプロバイダーが自動判定したアカウントIDを使用します。
  aws_account_id = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWSアカウントID・フォルダID・メンバー種別・メンバーIDをカンマ区切りで
#       結合した文字列（例: 123456789012,folder-id,DATASET,dataset-id）
#---------------------------------------------------------------
