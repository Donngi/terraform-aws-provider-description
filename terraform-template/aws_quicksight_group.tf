#---------------------------------------------------------------
# AWS QuickSight Group
#---------------------------------------------------------------
#
# Amazon QuickSightのグループを管理するリソースです。
# グループを使用することで、複数のQuickSightユーザーをまとめて
# 管理し、ダッシュボードやデータセットへのアクセス権限を
# グループ単位で制御できます。
#
# AWS公式ドキュメント:
#   - CreateGroup APIリファレンス: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateGroup.html
#   - QuickSight グループ管理: https://docs.aws.amazon.com/quicksight/latest/user/creating-quicksight-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_group" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # group_name (Required)
  # 設定内容: 作成するQuickSightグループの名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  # 省略時: 設定必須のため省略不可。
  group_name = "example-group"

  #-------------------------------------------------------------
  # アカウント・ネームスペース設定
  #-------------------------------------------------------------

  # aws_account_id (Optional)
  # 設定内容: グループを作成するAWSアカウントIDを指定します。
  # 設定可能な値: 有効な12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーが自動的に判定したアカウントIDを使用します。
  aws_account_id = null

  # namespace (Optional)
  # 設定内容: グループを作成するQuickSightネームスペースを指定します。
  # 設定可能な値: 既存のQuickSightネームスペース名（例: "default"）
  # 省略時: "default" ネームスペースが使用されます。
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateGroup.html
  namespace = "default"

  #-------------------------------------------------------------
  # グループ詳細設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: グループの説明文を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なしでグループが作成されます。
  description = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

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
# - arn: グループのARN（Amazon Resource Name）
# - id: リソースのID（aws_account_id, namespace, group_name を連結した値）
#---------------------------------------------------------------
