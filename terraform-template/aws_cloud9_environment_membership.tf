#---------------------------------------------------------------
# AWS Cloud9 Environment Membership
#---------------------------------------------------------------
#
# AWS Cloud9開発環境に対してメンバーを追加するリソースです。
# 環境メンバーは、Cloud9環境を共有して共同作業を行うユーザーを定義します。
# メンバーには読み取り専用または読み書きの権限を付与できます。
#
# NOTE: AWS Cloud9は新規顧客には提供されなくなりました。
#       既存のお客様は引き続きサービスを利用できます。
#
# AWS公式ドキュメント:
#   - Cloud9 環境共有: https://docs.aws.amazon.com/cloud9/latest/user-guide/share-environment.html
#   - メンバーアクセス権変更: https://docs.aws.amazon.com/cloud9/latest/user-guide/share-environment-change-access.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloud9_environment_membership
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloud9_environment_membership" "example" {
  #-------------------------------------------------------------
  # 環境設定
  #-------------------------------------------------------------

  # environment_id (Required)
  # 設定内容: メンバーを追加するCloud9環境のIDを指定します。
  # 設定可能な値: 有効なCloud9環境ID
  # 関連機能: AWS Cloud9 環境
  #   開発環境はEC2インスタンスまたはSSH接続で作成されます。
  #   aws_cloud9_environment_ec2リソースで作成した環境のIDを指定します。
  environment_id = aws_cloud9_environment_ec2.example.id

  #-------------------------------------------------------------
  # メンバー設定
  #-------------------------------------------------------------

  # user_arn (Required)
  # 設定内容: 環境に追加するメンバーのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: IAMユーザーまたはAssumed RoleユーザーのARN
  # 例:
  #   - IAMユーザー: arn:aws:iam::123456789012:user/username
  #   - Assumed Role: arn:aws:sts::123456789012:assumed-role/role-name/session-name
  # 関連機能: AWS Cloud9 環境共有
  #   環境を共有することで、複数のユーザーがリアルタイムで共同作業できます。
  #   - https://docs.aws.amazon.com/cloud9/latest/user-guide/share-environment.html
  user_arn = aws_iam_user.example.arn

  #-------------------------------------------------------------
  # 権限設定
  #-------------------------------------------------------------

  # permissions (Required)
  # 設定内容: 環境メンバーに付与する権限のタイプを指定します。
  # 設定可能な値:
  #   - "read-only": 読み取り専用。環境を表示できますが、編集はできません。
  #   - "read-write": 読み書き可能。環境を表示・編集できます。
  # 注意: read-writeメンバーは環境オーナーのAWS認証情報を使用してAWSサービスと
  #       やり取りできる可能性があります。信頼できるユーザーにのみ付与してください。
  # 関連機能: AWS Cloud9 アクセスロール
  #   メンバーのアクセスロールは後から変更することも可能です。
  #   - https://docs.aws.amazon.com/cloud9/latest/user-guide/share-environment-change-access.html
  permissions = "read-only"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
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
# - id: 環境メンバーシップのID
#
# - user_id: 環境メンバーのAWS Identity and Access Management (IAM)における
#            ユーザーID
#---------------------------------------------------------------
