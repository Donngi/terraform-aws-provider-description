#---------------------------------------------------------------
# Amazon Inspector2 Organization Configuration
#---------------------------------------------------------------
#
# Amazon Inspector Organization Configurationは、AWS Organizationsと統合された
# Amazon Inspectorの組織全体の自動有効化設定を管理するリソースです。
# 新規メンバーアカウントに対して、EC2、ECR、Lambda、Lambda Code、
# Code Repository（コードリポジトリ）のスキャンを自動的に有効化する設定を行います。
#
# 【前提条件】
# - このリソースを使用するには、アカウントがInspector Delegated Admin Account
#   （委任管理者アカウント）である必要があります
# - AWS Organizationsとの統合が有効化されている必要があります
#
# 【注意事項】
# - このリソースを削除すると、新規メンバーアカウントに対するEC2、ECR、Lambda、
#   Lambda Codeスキャンの自動有効化が停止されます
# - Lambda code scanningを有効化する場合、Lambda standard scanningも
#   有効化する必要があります（lambda = true の設定が必須）
#
# AWS公式ドキュメント:
#   - Managing multiple accounts in Amazon Inspector: https://docs.aws.amazon.com/inspector/latest/user/managing-multiple-accounts.html
#   - Amazon Inspector and AWS Organizations: https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-inspector2.html
#   - Automated scan types in Amazon Inspector: https://docs.aws.amazon.com/inspector/latest/user/scanning-resources.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector2_organization_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_inspector2_organization_configuration" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # (Optional) このリソースを管理するAWSリージョン
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます
  # Amazon Inspectorはリージョナルサービスのため、各リージョンで個別に設定が必要です
  #
  # 例: "us-east-1", "ap-northeast-1"など
  # region = "us-east-1"

  #---------------------------------------------------------------
  # 自動有効化設定 (Required Block)
  #---------------------------------------------------------------

  # (Required) 新規メンバーアカウントに対する各スキャンタイプの自動有効化設定
  # このブロックは必須で、ec2とecrの設定は必ず指定する必要があります
  auto_enable {
    # (Required) Amazon EC2スキャンの自動有効化
    # trueに設定すると、新規メンバーアカウントでEC2インスタンスの脆弱性スキャンが
    # 自動的に有効化されます
    # EC2スキャンは、インスタンスの一般的な脆弱性、ネットワーク露出の問題、
    # OSパッケージの脆弱性をチェックします
    ec2 = true

    # (Required) Amazon ECRスキャンの自動有効化
    # trueに設定すると、新規メンバーアカウントでECRコンテナイメージの
    # 脆弱性スキャンが自動的に有効化されます
    # ECRスキャンは、過去30日以内にプッシュされたイメージ、または過去90日以内に
    # プルされたイメージを対象にスキャンを実行します
    ecr = false

    # (Optional) Code Repositoryスキャンの自動有効化
    # trueに設定すると、新規メンバーアカウントでコードリポジトリの
    # セキュリティスキャンが自動的に有効化されます
    # Code Security for Amazon Inspectorは、ファーストパーティのアプリケーションコード、
    # サードパーティの依存関係、Infrastructure as Codeの脆弱性をスキャンします
    code_repository = false

    # (Optional) AWS Lambda Functionスキャン（Lambda standard scanning）の自動有効化
    # trueに設定すると、新規メンバーアカウントでLambda関数とレイヤーの
    # 脆弱性スキャンが自動的に有効化されます
    # Lambda standard scanningは、すべてのLambda関数とレイヤーを検出し、
    # 脆弱性をスキャンします
    #
    # 注意: lambda_code = true を設定する場合、この値も true にする必要があります
    lambda = true

    # (Optional) AWS Lambda Codeスキャンの自動有効化
    # trueに設定すると、新規メンバーアカウントでLambdaアプリケーションコードの
    # セキュリティスキャンが自動的に有効化されます
    # Lambda code scanningは、Lambda関数のアプリケーションパッケージの依存関係を
    # 評価し、データリーク、インジェクションの欠陥、暗号化の欠落、弱い暗号化などを
    # 検出します
    #
    # 重要: Lambda code scanningを有効化するには、Lambda standard scanningも
    # 有効化する必要があります（lambda = true の設定が必須）
    lambda_code = true
  }

  #---------------------------------------------------------------
  # タイムアウト設定 (Optional)
  #---------------------------------------------------------------

  # (Optional) リソース操作のタイムアウト設定
  # timeouts {
  #   # (Optional) リソース作成時のタイムアウト
  #   # デフォルト値が使用されます
  #   # 例: "15m"（15分）
  #   create = "15m"
  #
  #   # (Optional) リソース更新時のタイムアウト
  #   # デフォルト値が使用されます
  #   # 例: "15m"（15分）
  #   update = "15m"
  #
  #   # (Optional) リソース削除時のタイムアウト
  #   # デフォルト値が使用されます
  #   # 例: "15m"（15分）
  #   delete = "15m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Read-Only)
#---------------------------------------------------------------
# 以下の属性は、リソース作成後に参照可能な読み取り専用の属性です。
# Terraformコード内で明示的に設定することはできません。
#
# - id (string)
#     リソースの一意識別子
#     形式: AWS region
#     例: "us-east-1"
#
# - max_account_limit_reached (bool)
#     設定が最大アカウント制限に達したかどうか
#     委任管理者アカウントが管理できる最大メンバー数は10,000アカウントです
#     この制限に達した場合、trueが返されます
#
#---------------------------------------------------------------
# 出力例
#---------------------------------------------------------------
# output "inspector_org_config_id" {
#   description = "Inspector Organization Configuration ID"
#   value       = aws_inspector2_organization_configuration.example.id
# }
#
# output "max_limit_reached" {
#   description = "Whether max account limit has been reached"
#   value       = aws_inspector2_organization_configuration.example.max_account_limit_reached
# }
#---------------------------------------------------------------
