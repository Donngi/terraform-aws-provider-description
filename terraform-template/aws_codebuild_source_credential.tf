# ============================================================================
# Terraform AWS Resource Template: aws_codebuild_source_credential
# ============================================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-19)の情報に基づいています
# - 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください
# - AWS Provider Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential
# - AWS API Reference: https://docs.aws.amazon.com/codebuild/latest/APIReference/API_SourceCredentialsInfo.html
# ============================================================================

resource "aws_codebuild_source_credential" "example" {
  # ============================================================================
  # 必須パラメータ (Required Parameters)
  # ============================================================================

  # auth_type - (Required) 認証タイプ
  # リポジトリへの接続に使用する認証方式を指定します。
  #
  # 有効な値:
  # - BASIC_AUTH: ベーシック認証（Bitbucket用）
  # - PERSONAL_ACCESS_TOKEN: 個人アクセストークン（GitHub, GitHub Enterprise用）
  # - CODECONNECTIONS: AWS CodeStar Connections（旧CodeConnections）
  # - SECRETS_MANAGER: AWS Secrets Managerに保存された認証情報
  #
  # 注意: OAUTH接続はAPIでサポートされていません
  #
  # 参考:
  # - https://docs.aws.amazon.com/codebuild/latest/APIReference/API_SourceCredentialsInfo.html
  # - https://docs.aws.amazon.com/codebuild/latest/userguide/access-tokens-github.html
  auth_type = "PERSONAL_ACCESS_TOKEN"

  # server_type - (Required) ソースプロバイダーのタイプ
  # ソースコードリポジトリのホスティングサービスを指定します。
  #
  # 有効な値:
  # - GITHUB: GitHub
  # - GITHUB_ENTERPRISE: GitHub Enterprise Server
  # - GITLAB: GitLab
  # - GITLAB_SELF_MANAGED: GitLab Self Managed
  # - BITBUCKET: Bitbucket
  #
  # 参考:
  # - https://docs.aws.amazon.com/codebuild/latest/APIReference/API_SourceCredentialsInfo.html
  server_type = "GITHUB"

  # token - (Required) 認証トークン（センシティブ）
  # 認証に使用するトークンまたは認証情報を指定します。
  #
  # auth_typeによる違い:
  # - PERSONAL_ACCESS_TOKEN: GitHubまたはGitHub Enterpriseの個人アクセストークン
  # - BASIC_AUTH: Bitbucketのアプリパスワード
  # - CODECONNECTIONS: AWS CodeStar Connection ARN
  #   形式: arn:aws:codestar-connections:us-east-1:123456789012:connection/guid-string
  # - SECRETS_MANAGER: AWS Secrets Manager内のシークレットの参照
  #
  # GitHubトークンに必要なスコープ（参考）:
  # - repo: リポジトリへのフルアクセス
  # - repo:status: コミットステータスへのアクセス
  # - admin:repo_hook: リポジトリフックの管理
  # - admin:org_hook: 組織フックの管理
  #
  # Bitbucketトークンに必要なスコープ（参考）:
  # - repository:read: リポジトリの読み取り
  # - pullrequest:read: プルリクエストの読み取り
  # - webhook: Webhookの管理
  #
  # 注意: この値はTerraformのstateファイルに保存されますが、sensitiveとしてマークされています
  #
  # 参考:
  # - https://docs.aws.amazon.com/codebuild/latest/userguide/access-tokens-github.html
  # - https://docs.aws.amazon.com/codebuild/latest/userguide/access-tokens-bitbucket.html
  # - https://docs.aws.amazon.com/codebuild/latest/userguide/multiple-access-tokens.html
  token = "your-personal-access-token-here"

  # ============================================================================
  # オプションパラメータ (Optional Parameters)
  # ============================================================================

  # user_name - (Optional) ユーザー名
  # Bitbucketのベーシック認証時に使用するユーザー名を指定します。
  #
  # 注意:
  # - auth_type = "BASIC_AUTH" の場合のみ有効
  # - 他の認証タイプでは無視されます
  #
  # 参考:
  # - https://docs.aws.amazon.com/codebuild/latest/userguide/access-tokens-bitbucket.html
  user_name = "bitbucket-username"

  # id - (Optional) リソースID
  # Terraformが内部的に使用するリソース識別子です。
  # 通常は指定する必要はありません。指定しない場合、ARNが自動的に使用されます。
  #
  # 注意: 明示的に指定しない限り、Terraformが自動的に管理します
  # id = "example-id"

  # region - (Optional) リージョン
  # このリソースが管理されるAWSリージョンを指定します。
  #
  # デフォルト: プロバイダー設定で指定されたリージョン
  #
  # 注意:
  # - CodeBuildは特定のリージョンでのみソース認証情報を1つしか許可しません
  # - 同じserver_typeの認証情報は、リージョンごとに1つのみ保持できます
  #
  # 参考:
  # - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  # region = "us-east-1"
}

# ============================================================================
# 出力例 (Output Example)
# ============================================================================
# 以下の属性は自動的に計算され、Terraform stateに保存されます:
#
# - id: ソース認証情報のARN
# - arn: ソース認証情報のARN
#
# 使用例:
# output "codebuild_source_credential_arn" {
#   value       = aws_codebuild_source_credential.example.arn
#   description = "The ARN of the CodeBuild source credential"
# }

# ============================================================================
# 重要な注意事項
# ============================================================================
# 1. リージョン制限:
#    CodeBuildは、指定されたserver_typeに対して、リージョンごとに1つの認証情報のみを許可します。
#    同じリージョンで同じserver_typeの認証情報を複数作成することはできません。
#
#    参考: https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_codebuild.GitHubSourceCredentials.html
#
# 2. 認証情報の自動使用:
#    aws_codebuild_source_credentialを定義すると、同じモジュール内のaws_codebuild_projectリソースが
#    自動的にこの認証情報を使用します。
#
# 3. セキュリティのベストプラクティス:
#    - tokenパラメータには機密情報が含まれるため、変数やSecrets Managerの使用を推奨します
#    - 最小権限の原則に従い、必要最小限のスコープのみをトークンに付与してください
#    - 定期的なトークンのローテーションを検討してください
#
# 4. 複数の認証情報の管理:
#    複数のアクセストークンを使用する場合は、Secrets ManagerまたはCodeConnectionsの使用を検討してください。
#
#    参考: https://docs.aws.amazon.com/codebuild/latest/userguide/multiple-access-tokens.html
#
# 5. CodeConnectionsの可用性:
#    CodeConnections (旧CodeConnections) は、CodeBuildよりも利用可能なリージョンが少ない点に注意してください。
#    オプトインリージョンで作成された接続は、他のリージョンでは使用できません。
#
#    参考: https://docs.aws.amazon.com/codebuild/latest/userguide/connections-bitbucket-app.html
