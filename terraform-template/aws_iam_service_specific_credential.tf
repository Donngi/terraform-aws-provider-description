#---------------------------------------------------------------
# IAM Service Specific Credential
#---------------------------------------------------------------
#
# IAMユーザーに紐付くサービス固有の認証情報を生成する。
# 特定のAWSサービス（Amazon Bedrock、CodeCommit、Amazon Keyspaces）専用の
# ユーザー名とパスワード/APIキーを生成し、アクセス範囲を制限できる。
#
# 主な用途:
#   - CodeCommit用のGit認証情報
#   - Amazon Bedrock用のAPIキー（有効期限設定可能）
#   - Amazon Keyspaces用の認証情報
#
# 注意事項:
#   - 各サービスごとにユーザーあたり最大2セットまで作成可能
#   - パスワード/シークレットは作成時のみ取得可能（再取得不可）
#   - Bedrock APIキーは有効期限を設定可能（credential_age_days）
#   - 作成後はResetServiceSpecificCredentialでパスワードをリセット可能
#
# AWS公式ドキュメント:
#   - CreateServiceSpecificCredential API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateServiceSpecificCredential.html
#   - Service-specific credentials: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_service-specific-creds.html
#   - API keys for Amazon Bedrock: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_bedrock.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_specific_credential
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_service_specific_credential" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # service_name - (Required) サービス固有認証情報を関連付けるAWSサービスの名前
  #
  # 指定したサービスのみがこの認証情報でアクセス可能になる。
  #
  # サポートされているサービス:
  #   - "codecommit.amazonaws.com"     : CodeCommit用のGit認証情報
  #   - "bedrock.amazonaws.com"        : Bedrock用のAPIキー
  #   - "cassandra.amazonaws.com"      : Keyspaces用の認証情報
  #
  # 例:
  #   service_name = "codecommit.amazonaws.com"
  #   service_name = "bedrock.amazonaws.com"
  #
  # Type: string
  service_name = "codecommit.amazonaws.com"

  # user_name - (Required) サービス固有認証情報を関連付けるIAMユーザーの名前
  #
  # 新しいサービス固有認証情報は関連付けられたユーザーと同じ権限を持つが、
  # 指定されたサービスへのアクセスのみに使用できる。
  #
  # 制約:
  #   - 長さ: 1〜64文字
  #   - 許可文字: 英数字、_+=,.@-
  #   - スペース不可
  #
  # パターン: [\w+=,.@-]+
  #
  # 例:
  #   user_name = "developer-user"
  #   user_name = aws_iam_user.example.name
  #
  # Type: string
  user_name = "example-user"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # credential_age_days - (Optional) サービス固有認証情報が期限切れになるまでの日数
  #
  # このフィールドはBedrock APIキーに対してのみ有効。
  # 指定しない場合、認証情報は期限切れにならない。
  #
  # 用途:
  #   - Bedrock APIキーの自動失効による定期的なローテーション
  #   - セキュリティポリシーに基づく有効期限管理
  #
  # 制約:
  #   - 正の整数である必要がある
  #   - 最小値: 1
  #   - 最大値: 36600（約100年）
  #
  # 例:
  #   credential_age_days = 30   # 30日後に期限切れ
  #   credential_age_days = 90   # 90日後に期限切れ
  #
  # ※ CodeCommitやKeyspacesでは使用不可
  #
  # Type: number
  # credential_age_days = 30

  # status - (Optional) サービス固有認証情報のステータス
  #
  # 認証情報の有効/無効を制御する。
  #
  # 有効な値:
  #   - "Active"   : 認証情報が有効（デフォルト）
  #   - "Inactive" : 認証情報が無効（使用不可）
  #
  # 用途:
  #   - 認証情報のローテーション時に旧認証情報を一時的に無効化
  #   - セキュリティインシデント時の緊急停止
  #   - アプリケーション更新前の検証期間中の無効化
  #
  # 推奨ローテーション手順:
  #   1. 新しい認証情報を作成
  #   2. アプリケーションを更新
  #   3. 旧認証情報のstatusを"Inactive"に変更
  #   4. 動作確認後、旧認証情報を削除
  #
  # 例:
  #   status = "Active"
  #   status = "Inactive"
  #
  # Type: string
  # status = "Active"

  # id - (Optional) リソースID
  #
  # 明示的に指定することは通常不要。
  # Terraformが自動的に生成する。
  #
  # フォーマット: "service_name:user_name:service_specific_credential_id"
  #
  # 例: "codecommit.amazonaws.com:example-user:ACCA12345ABCDEXAMPLE"
  #
  # Type: string
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference (Computed Only)
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能（computed）です。
# Terraformコード内で設定することはできません。
#
# - create_date
#   タイプ: string
#   説明: サービス固有認証情報が作成された日時（RFC3339形式）
#   例: "2016-11-01T17:47:22.382Z"
#
# - expiration_date
#   タイプ: string
#   説明: サービス固有認証情報が期限切れになる日時（RFC3339形式）
#        credential_age_daysを指定したBedrock APIキーのみに存在
#   例: "2026-02-26T17:47:22.382Z"
#
# - service_credential_alias
#   タイプ: string
#   説明: Bedrock APIキーの公開部分。IAMユーザー名とバージョン・作成情報を含むサフィックスで構成される
#        Bedrock APIキー専用のフィールド
#   例: "example-user-v1-20260127"
#
# - service_credential_secret (Sensitive)
#   タイプ: string
#   説明: Bedrock APIキーの秘密部分。API呼び出しの認証に使用する
#        作成時のみ取得可能で、後から再取得できない
#        Bedrock APIキー専用のフィールド
#   注意: 機密情報のため安全に保管すること
#
# - service_password (Sensitive)
#   タイプ: string
#   説明: サービス固有認証情報用に生成されたパスワード
#        作成時のみ取得可能で、後から再取得できない
#        ResetServiceSpecificCredential APIでリセット可能
#   例: "xTBAr/czp+D3EXAMPLE47lrJ6/43r2zqGwR3EXAMPLE="
#   注意: 機密情報のため安全に保管すること
#
# - service_specific_credential_id
#   タイプ: string
#   説明: サービス固有認証情報の一意な識別子
#   例: "ACCA12345ABCDEXAMPLE"
#
# - service_user_name
#   タイプ: string
#   説明: サービス固有認証情報用に生成されたユーザー名
#        IAMユーザー名とAWSアカウントIDを組み合わせて生成される
#   フォーマット: "{iam_user_name}+{suffix}-at-{account_id}"
#   例: "jane-at-123456789012", "anika+1-at-123456789012"
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Output Examples
#---------------------------------------------------------------
#
# サービス固有認証情報を他のリソースやモジュールで参照する例:
#
# output "service_user_name" {
#   description = "Generated service user name for Git operations"
#   value       = aws_iam_service_specific_credential.example.service_user_name
# }
#
# output "service_password" {
#   description = "Generated service password (sensitive)"
#   value       = aws_iam_service_specific_credential.example.service_password
#   sensitive   = true
# }
#
# output "service_credential_alias" {
#   description = "Bedrock API key alias (public portion)"
#   value       = aws_iam_service_specific_credential.example.service_credential_alias
# }
#
# output "service_credential_secret" {
#   description = "Bedrock API key secret (sensitive)"
#   value       = aws_iam_service_specific_credential.example.service_credential_secret
#   sensitive   = true
# }
#
# output "credential_id" {
#   description = "Service specific credential ID"
#   value       = aws_iam_service_specific_credential.example.service_specific_credential_id
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Usage Examples
#---------------------------------------------------------------
#
# Example 1: CodeCommit用のGit認証情報
#
# resource "aws_iam_user" "developer" {
#   name = "developer"
# }
#
# resource "aws_iam_service_specific_credential" "codecommit" {
#   service_name = "codecommit.amazonaws.com"
#   user_name    = aws_iam_user.developer.name
# }
#
# output "git_username" {
#   value = aws_iam_service_specific_credential.codecommit.service_user_name
# }
#
# output "git_password" {
#   value     = aws_iam_service_specific_credential.codecommit.service_password
#   sensitive = true
# }
#
#---------------------------------------------------------------
#
# Example 2: Amazon Bedrock APIキー（30日間有効）
#
# resource "aws_iam_user" "bedrock_user" {
#   name = "bedrock-developer"
# }
#
# resource "aws_iam_service_specific_credential" "bedrock" {
#   service_name        = "bedrock.amazonaws.com"
#   user_name           = aws_iam_user.bedrock_user.name
#   credential_age_days = 30  # 30日後に自動失効
# }
#
# output "bedrock_api_key_alias" {
#   value = aws_iam_service_specific_credential.bedrock.service_credential_alias
# }
#
# output "bedrock_api_key_secret" {
#   value     = aws_iam_service_specific_credential.bedrock.service_credential_secret
#   sensitive = true
# }
#
#---------------------------------------------------------------
#
# Example 3: 認証情報のローテーション（新旧2セット運用）
#
# # 既存の認証情報（無効化）
# resource "aws_iam_service_specific_credential" "old" {
#   service_name = "codecommit.amazonaws.com"
#   user_name    = aws_iam_user.example.name
#   status       = "Inactive"  # 検証後に無効化
# }
#
# # 新しい認証情報（有効）
# resource "aws_iam_service_specific_credential" "new" {
#   service_name = "codecommit.amazonaws.com"
#   user_name    = aws_iam_user.example.name
#   status       = "Active"
# }
#
#---------------------------------------------------------------
