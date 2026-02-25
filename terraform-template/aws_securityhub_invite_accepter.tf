#---------------------------------------------------------------
# AWS Security Hub 招待承認
#---------------------------------------------------------------
#
# Security Hubの管理者アカウントから送られた招待を承認し、
# メンバーアカウントとして関連付けるリソースです。
# AWS Organizationsを使わず、招待方式でSecurity Hubのマルチアカウント管理を
# 行う場合に使用します。このリソースを削除すると、メンバーアカウントは
# 管理者アカウントから切り離されます。
#
# 注意: AWSアカウントは単一のSecurity Hub管理者アカウントにのみ関連付け可能です。
#       AWS Organizationsによるメンバー管理が推奨される方法です。
#
# AWS公式ドキュメント:
#   - Security Hub招待への応答: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-invitation-respond.html
#   - メンバーアカウントの追加と招待: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-accounts-add-invite.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_invite_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_invite_accepter" "example" {
  #-------------------------------------------------------------
  # 管理者アカウント設定
  #-------------------------------------------------------------

  # master_id (Required)
  # 設定内容: 招待を送信したSecurity Hub管理者アカウントのAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-accounts-add-invite.html
  master_id = "123456789012"

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
# - invitation_id: 管理者アカウントから送られた招待のID
#---------------------------------------------------------------
