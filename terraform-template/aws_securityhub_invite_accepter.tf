#---------------------------------------------------------------
# Security Hub招待受諾
#---------------------------------------------------------------
#
# AWS Security Hubの管理者アカウントからの招待を受諾するリソースです。
# このリソースを使用することで、メンバーアカウントが管理者アカウントからの
# 監視招待を承認し、Security Hubの統合管理下に参加できます。
#
# 重要な注意事項:
# - AWSアカウントは1つのSecurity Hub管理者アカウントとのみ関連付け可能です
# - このリソースを削除すると、メンバーアカウントは管理者アカウントから切り離されます
# - AWS Organizationsで管理されていないアカウント向けの機能です
# - 招待を受諾する前に、メンバーアカウント側でSecurity Hubを有効化する必要があります
#
# AWS公式ドキュメント:
#   - Security Hub招待への応答: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-invitation-respond.html
#   - AcceptAdministratorInvitation API: https://docs.aws.amazon.com/securityhub/1.0/APIReference/API_AcceptAdministratorInvitation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_invite_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_invite_accepter" "example" {
  #---------------------------------------------------------------
  # 管理者アカウント設定
  #---------------------------------------------------------------

  # master_id (Required)
  # 設定内容: Security Hubの管理者(マスター)アカウントのAWSアカウントIDを指定します。
  # 設定可能な値: 12桁の数値文字列
  # 関連機能: Security Hub招待受諾
  #   このアカウントから送信された招待を受諾し、メンバーアカウントとして
  #   管理者アカウントの監視下に入ります。管理者アカウントは、メンバーアカウントで
  #   生成された検出結果を閲覧する権限を得ます。
  #   - https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-invitation-respond.html
  # 注意: AWS Organizationsで管理されていないアカウント向けの機能です
  master_id = "123456789012"

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: リージョナルリソース管理
  #   Security Hubは各リージョンで個別に有効化・管理されるため、
  #   クロスリージョンの招待受諾を行う場合はこのパラメータで明示的に指定します。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  #---------------------------------------------------------------
  # Terraform管理設定
  #---------------------------------------------------------------

  # id (Optional)
  # 設定内容: このリソースのTerraform識別子です。
  # 設定可能な値: 任意の文字列
  # 省略時: 自動計算されます
  # 注意: 通常は明示的に指定する必要はありませんが、インポート時などに使用できます
  # id = "unique-identifier"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Terraform管理用の一意識別子
#       参照例: aws_securityhub_invite_accepter.example.id
#
# - invitation_id: 受諾した招待のID
#                  管理者アカウントが発行した招待の一意識別子です。
#                  参照例: aws_securityhub_invite_accepter.example.invitation_id
#---------------------------------------------------------------
