################################################################################
# AWS Serverless Application Repository CloudFormation Stack
################################################################################
# リソース概要:
# - Serverless Application Repository からアプリケーション CloudFormation スタックをデプロイします
# - AWS Serverless Application Repository に公開されているサーバーレスアプリケーションを
#   CloudFormation スタックとしてデプロイし、管理することができます
# - スタック名には自動的に 'serverlessrepo-' プレフィックスが付与されます
#
# ユースケース:
# - Secrets Manager のローテーション関数などの SAR アプリケーションをデプロイ
# - サードパーティが公開しているサーバーレスアプリケーションの利用
# - AWS が提供する参照実装アプリケーションのデプロイ
#
# 公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/serverlessapplicationrepository_cloudformation_stack
################################################################################

resource "aws_serverlessapplicationrepository_cloudformation_stack" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # スタック名
  # - AWS にデプロイされるリソースには 'serverlessrepo-' プレフィックスが自動付与されます
  # - 例: name = "postgres-rotator" → 実際のスタック名は "serverlessrepo-postgres-rotator"
  name = "postgres-rotator"

  # アプリケーション ID
  # - Serverless Application Repository のアプリケーション ARN を指定
  # - 形式: arn:aws:serverlessrepo:<region>:<account-id>:applications/<app-name>
  # - SAR コンソールまたは AWS CLI で確認可能
  application_id = "arn:aws:serverlessrepo:us-east-1:297356227824:applications/SecretsManagerRDSPostgreSQLRotationSingleUser"

  # ケイパビリティ
  # - CloudFormation スタックに必要な権限を明示的に承認
  # - 有効な値:
  #   - CAPABILITY_IAM: IAM リソースの作成を許可
  #   - CAPABILITY_NAMED_IAM: カスタム名の IAM リソース作成を許可
  #   - CAPABILITY_RESOURCE_POLICY: リソースポリシーの作成を許可
  #   - CAPABILITY_AUTO_EXPAND: マクロやネストされたスタックの展開を許可
  capabilities = [
    "CAPABILITY_IAM",
    "CAPABILITY_RESOURCE_POLICY",
  ]

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # パラメータ
  # - アプリケーションに渡す入力パラメータ
  # - アプリケーションの CloudFormation テンプレートで定義されたパラメータを指定
  # - 各アプリケーションによって必要なパラメータは異なります
  parameters = {
    functionName = "func-postgres-rotator"
    endpoint     = "secretsmanager.us-east-1.amazonaws.com"
  }

  # セマンティックバージョン
  # - デプロイするアプリケーションのバージョンを指定
  # - 指定しない場合は最新バージョンがデプロイされます
  # - 形式: "1.0.0" (セマンティックバージョニング)
  # semantic_version = "1.0.0"

  # リージョン
  # - このリソースを管理するリージョンを指定
  # - 指定しない場合はプロバイダー設定のリージョンが使用されます
  # - 注意: アプリケーションが利用可能なリージョンを確認してください
  # region = "us-east-1"

  # タグ
  # - スタックに関連付けるタグ
  # - プロバイダーの default_tags と組み合わせて使用可能
  tags = {
    Name        = "postgres-rotator-stack"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  ################################################################################
  # タイムアウト設定
  ################################################################################

  # CloudFormation スタックの操作タイムアウト
  timeouts {
    # 作成タイムアウト (デフォルト: 30分)
    create = "30m"

    # 更新タイムアウト (デフォルト: 30分)
    update = "30m"

    # 削除タイムアウト (デフォルト: 30分)
    delete = "30m"
  }
}

################################################################################
# 参照用データソース (例)
################################################################################

# 現在のパーティション情報 (aws, aws-cn, aws-us-gov など)
data "aws_partition" "current" {}

# 現在のリージョン情報
data "aws_region" "current" {}

################################################################################
# 出力例
################################################################################

# スタック ID
output "stack_id" {
  description = "CloudFormation スタックの一意な識別子"
  value       = aws_serverlessapplicationrepository_cloudformation_stack.example.id
}

# スタック出力
output "stack_outputs" {
  description = "CloudFormation スタックからの出力値のマップ"
  value       = aws_serverlessapplicationrepository_cloudformation_stack.example.outputs
}

# すべてのタグ
output "all_tags" {
  description = "プロバイダーの default_tags を含むすべてのタグ"
  value       = aws_serverlessapplicationrepository_cloudformation_stack.example.tags_all
}

################################################################################
# 属性リファレンス
################################################################################
# このリソースは以下の属性をエクスポートします:
#
# - id: スタックの一意な識別子
# - outputs: スタックからの出力値のマップ (CloudFormation の Outputs セクション)
# - tags_all: リソースに割り当てられたすべてのタグ
#             (プロバイダーの default_tags を含む)
################################################################################

################################################################################
# インポート
################################################################################
# 既存の Serverless Application Repository CloudFormation スタックをインポート:
# terraform import aws_serverlessapplicationrepository_cloudformation_stack.example stack-name
################################################################################

################################################################################
# 使用上の注意事項
################################################################################
# 1. アプリケーションの確認:
#    - SAR コンソールでアプリケーションの詳細、パラメータ、権限を確認
#    - 必要な capabilities を事前に把握
#
# 2. パラメータの設定:
#    - アプリケーションの CloudFormation テンプレートで定義されたパラメータを確認
#    - 必須パラメータは必ず指定
#
# 3. 権限の管理:
#    - アプリケーションが作成するリソースと必要な権限を確認
#    - 適切な capabilities を指定
#
# 4. バージョン管理:
#    - semantic_version を指定して特定バージョンに固定することを推奨
#    - 自動アップデートを避けることで予期しない変更を防止
#
# 5. リージョンの制約:
#    - すべてのアプリケーションがすべてのリージョンで利用可能ではありません
#    - デプロイ前に対象リージョンでの利用可能性を確認
#
# 6. スタック名:
#    - 実際のスタック名には 'serverlessrepo-' プレフィックスが付与されます
#    - CloudFormation コンソールではこのプレフィックス付きで表示されます
#
# 7. 更新と削除:
#    - スタックの更新は CloudFormation の変更セットとして実行されます
#    - 削除時はスタックとそのすべてのリソースが削除されます
################################################################################

################################################################################
# 実践例: Secrets Manager RDS ローテーション関数のデプロイ
################################################################################
# resource "aws_serverlessapplicationrepository_cloudformation_stack" "rds_rotation" {
#   name           = "rds-postgres-rotation"
#   application_id = "arn:aws:serverlessrepo:us-east-1:297356227824:applications/SecretsManagerRDSPostgreSQLRotationSingleUser"
#   semantic_version = "1.1.0"
#
#   capabilities = [
#     "CAPABILITY_IAM",
#     "CAPABILITY_RESOURCE_POLICY",
#   ]
#
#   parameters = {
#     functionName = "SecretsManagerRDSPostgreSQLRotation"
#     endpoint     = "secretsmanager.${data.aws_region.current.name}.${data.aws_partition.current.dns_suffix}"
#   }
#
#   tags = {
#     Name        = "rds-rotation-function"
#     Purpose     = "secrets-rotation"
#     Database    = "postgresql"
#   }
# }
################################################################################
