#---------------------------------------------------------------
# Amazon QuickSight ユーザーカスタム権限
#---------------------------------------------------------------
#
# Amazon QuickSightのユーザーにカスタム権限プロファイルを割り当てるリソースです。
# カスタム権限プロファイルをユーザーに紐付けることで、ユーザーのデフォルトロールを
# 超えない範囲で機能へのアクセスを制限・調整できます。
#
# AWS公式ドキュメント:
#   - カスタム権限プロファイルの作成: https://docs.aws.amazon.com/quicksight/latest/user/create-custom-permisions-profile.html
#   - UpdateUser API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_UpdateUser.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_user_custom_permission
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_user_custom_permission" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # user_name (Required, Forces new resource)
  # 設定内容: カスタム権限プロファイルを割り当てるQuickSightユーザーのユーザー名を指定します。
  # 設定可能な値: 既存のQuickSightユーザーのユーザー名（文字列）
  user_name = "example-user"

  # custom_permissions_name (Required, Forces new resource)
  # 設定内容: ユーザーに割り当てるカスタム権限プロファイル名を指定します。
  # 設定可能な値: 既存のカスタム権限プロファイル名（1〜64文字の文字列）
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CustomPermissions.html
  custom_permissions_name = "example-custom-permissions"

  #-------------------------------------------------------------
  # アカウント・名前空間設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: QuickSightユーザーが所属するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID（文字列）
  # 省略時: Terraform AWSプロバイダーに設定されたアカウントIDを自動使用します。
  aws_account_id = null

  # namespace (Optional, Forces new resource)
  # 設定内容: ユーザーが所属するQuickSightの名前空間を指定します。
  # 設定可能な値: 既存のQuickSight名前空間名（文字列）
  # 省略時: "default" 名前空間を使用します。
  namespace = null

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
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースを一意に識別するID
#---------------------------------------------------------------
