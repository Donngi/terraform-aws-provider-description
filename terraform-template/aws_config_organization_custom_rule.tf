################################################################################
# AWS Config Organization Custom Rule
# Terraform Resource: aws_config_organization_custom_rule
#
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-19)の AWS Provider 6.28.0 に
#       基づいています。最新の仕様や詳細については、必ず公式ドキュメントを
#       ご確認ください。
#
# AWS公式ドキュメント:
# - Organization Custom Rules: https://docs.aws.amazon.com/config/latest/developerguide/config-rule-multi-account-deployment.html
# - API Reference: https://docs.aws.amazon.com/config/latest/APIReference/API_PutOrganizationConfigRule.html
# - Lambda Functions for Custom Rules: https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_develop-rules_lambda-functions.html
#
# Terraform公式ドキュメント:
# - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/config_organization_custom_rule
################################################################################

resource "aws_config_organization_custom_rule" "example" {
  #==============================================================================
  # 必須パラメータ (Required Parameters)
  #==============================================================================

  # Lambda関数のARN (Amazon Resource Name)
  # AWS Config がルール評価時に呼び出すLambda関数を指定します。
  # この関数には、リソースのコンプライアンスを評価するカスタムロジックを実装します。
  #
  # 注意事項:
  # - Lambda関数は管理アカウントまたは委任管理者アカウントに作成する必要があります
  # - 関数には適切な Lambda Permission が設定されている必要があります
  #   (principal: "config.amazonaws.com", action: "lambda:InvokeFunction")
  #
  # 関連ドキュメント:
  # - https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_develop-rules_lambda-functions.html
  lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:config-rule-evaluator"

  # ルールの名前
  # Organization Config ルールを識別するための一意の名前を指定します。
  # この名前は組織全体で一意である必要があります。
  name = "example-organization-custom-rule"

  # トリガータイプのリスト
  # AWS Config がルールの評価を実行するトリガーとなる通知タイプを指定します。
  #
  # 設定可能な値:
  # - ConfigurationItemChangeNotification: リソース設定変更時にトリガー
  # - OversizedConfigurationItemChangeNotification: 大きな設定変更時にトリガー
  # - ScheduledNotification: 定期的な評価スケジュールでトリガー
  #
  # 注意: ScheduledNotification を使用する場合、maximum_execution_frequency の設定が必要です
  #
  # 関連ドキュメント:
  # - https://docs.aws.amazon.com/config/latest/APIReference/API_OrganizationCustomRuleMetadata.html
  trigger_types = ["ConfigurationItemChangeNotification"]

  #==============================================================================
  # オプションパラメータ (Optional Parameters)
  #==============================================================================

  # ルールの説明
  # このルールの目的や評価内容を説明するテキストを指定します。
  # 組織内のユーザーがルールの意図を理解するのに役立ちます。
  description = "Custom rule to evaluate resource compliance"

  # 除外するAWSアカウントIDのリスト
  # このルールの評価対象から除外するAWSアカウントのIDを指定します。
  #
  # 注意:
  # - このリソースは組織の管理アカウントで作成する必要があります
  # - デフォルトでは管理アカウントも評価対象に含まれます
  # - 管理アカウントを除外したい場合は、そのIDをここに追加してください
  excluded_accounts = [
    # "123456789012",  # 例: 管理アカウント
    # "210987654321",  # 例: 開発環境アカウント
  ]

  # Lambda関数に渡すパラメータ (JSON形式)
  # Lambda関数のカスタムロジックで使用するパラメータをJSON文字列として指定します。
  # 例: コンプライアンス基準の閾値、許可/拒否リストなど
  #
  # 例:
  # input_parameters = jsonencode({
  #   maxSize = 100
  #   allowedRegions = ["us-east-1", "us-west-2"]
  # })
  input_parameters = null

  # 最大実行頻度
  # 定期的な評価の実行頻度を指定します。
  # trigger_types に "ScheduledNotification" を含める場合に設定します。
  #
  # 設定可能な値:
  # - One_Hour: 1時間ごと
  # - Three_Hours: 3時間ごと
  # - Six_Hours: 6時間ごと
  # - Twelve_Hours: 12時間ごと
  # - TwentyFour_Hours: 24時間ごと (デフォルト)
  #
  # 注意: 定期的なトリガーを使用する場合のみ有効です
  maximum_execution_frequency = null

  # 評価対象のリソースIDスコープ
  # 特定のリソースIDに評価範囲を絞り込みたい場合に指定します。
  # 例: "vpc-1234567890abcdef0"
  #
  # 注意: このパラメータを設定すると、指定されたリソースIDのみが評価対象になります
  resource_id_scope = null

  # 評価対象のリソースタイプスコープ
  # 評価するAWSリソースのタイプを指定します。
  # 指定したリソースタイプのみが評価対象となります。
  #
  # 例:
  # resource_types_scope = [
  #   "AWS::EC2::Instance",
  #   "AWS::S3::Bucket",
  #   "AWS::RDS::DBInstance"
  # ]
  #
  # リソースタイプの一覧:
  # - https://docs.aws.amazon.com/config/latest/developerguide/resource-config-reference.html
  resource_types_scope = null

  # タグキーのスコープ
  # 特定のタグキーを持つリソースのみを評価対象とする場合に指定します。
  #
  # 注意: tag_value_scope と組み合わせて使用することで、
  #       特定のタグキーと値のペアを持つリソースのみを評価できます
  #
  # 例: "Environment"
  tag_key_scope = null

  # タグ値のスコープ
  # tag_key_scope と組み合わせて、特定のタグ値を持つリソースのみを評価対象とします。
  #
  # 注意: tag_key_scope が設定されていない場合、このパラメータは無視されます
  #
  # 例: "Production"
  tag_value_scope = null

  # リソースID (オプション)
  # Terraform がリソースを識別するために使用するIDです。
  # 通常、Terraform が自動的に管理するため、明示的に設定する必要はありません。
  #
  # 注意: 特別な理由がない限り、この値は設定しないでください
  # id = null

  # リージョン指定 (オプション)
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  #
  # 注意: Organization Config ルールは指定されたリージョンで管理されますが、
  #       評価自体は組織内の全リージョンで実行される可能性があります
  #
  # 関連ドキュメント:
  # - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #==============================================================================
  # タイムアウト設定 (Timeouts)
  #==============================================================================

  # リソース作成・更新・削除時のタイムアウト設定
  # Organization Config ルールの作成・更新・削除には時間がかかる場合があります。
  # 必要に応じてタイムアウト値を調整してください。
  timeouts {
    # 作成時のタイムアウト (デフォルト: なし)
    # 例: "10m" (10分)
    create = null

    # 削除時のタイムアウト (デフォルト: なし)
    # 例: "10m" (10分)
    delete = null

    # 更新時のタイムアウト (デフォルト: なし)
    # 例: "10m" (10分)
    update = null
  }
}

################################################################################
# 出力値 (Outputs)
################################################################################

# output "config_organization_custom_rule_arn" {
#   description = "The ARN of the Config Organization Custom Rule"
#   value       = aws_config_organization_custom_rule.example.arn
# }

################################################################################
# 使用例 (Usage Examples)
################################################################################

# 例1: 基本的な設定変更トリガー型のカスタムルール
# resource "aws_config_organization_custom_rule" "basic_example" {
#   lambda_function_arn = aws_lambda_function.config_rule.arn
#   name                = "check-ec2-instance-tags"
#   trigger_types       = ["ConfigurationItemChangeNotification"]
#   description         = "Checks if EC2 instances have required tags"
#
#   resource_types_scope = ["AWS::EC2::Instance"]
#
#   depends_on = [
#     aws_lambda_permission.config,
#     aws_organizations_organization.example,
#   ]
# }

# 例2: 定期的な評価を行うカスタムルール
# resource "aws_config_organization_custom_rule" "periodic_example" {
#   lambda_function_arn        = aws_lambda_function.config_rule.arn
#   name                       = "periodic-compliance-check"
#   trigger_types              = ["ScheduledNotification"]
#   maximum_execution_frequency = "TwentyFour_Hours"
#   description                = "Performs daily compliance checks"
#
#   input_parameters = jsonencode({
#     threshold = 90
#     alertEmail = "compliance@example.com"
#   })
# }

# 例3: 特定のタグを持つリソースのみを評価するカスタムルール
# resource "aws_config_organization_custom_rule" "tagged_resources_example" {
#   lambda_function_arn = aws_lambda_function.config_rule.arn
#   name                = "check-production-resources"
#   trigger_types       = ["ConfigurationItemChangeNotification"]
#   description         = "Evaluates production resources compliance"
#
#   tag_key_scope   = "Environment"
#   tag_value_scope = "Production"
#
#   excluded_accounts = ["123456789012"]  # 管理アカウントを除外
# }

################################################################################
# 前提条件と注意事項
################################################################################

# 1. Organization の有効化
#    - AWS Organizations でこの機能を使用するには、組織のすべての機能が
#      有効になっている必要があります
#    - 組織サービスアクセスの有効化が必要です:
#      aws_service_access_principals = ["config-multiaccountsetup.amazonaws.com"]

# 2. Lambda Permission の設定
#    - Lambda関数には AWS Config からの呼び出しを許可する権限が必要です
#    - 例:
#      resource "aws_lambda_permission" "config" {
#        action        = "lambda:InvokeFunction"
#        function_name = aws_lambda_function.config_rule.arn
#        principal     = "config.amazonaws.com"
#        statement_id  = "AllowExecutionFromConfig"
#      }

# 3. Lambda関数の実装
#    - Lambda関数は AWS Config からのイベントを処理し、評価結果を返す
#      必要があります
#    - 詳細な実装ガイド:
#      https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_develop-rules_lambda-functions.html

# 4. デプロイメント順序
#    - Lambda関数とその権限を先に作成してから、Config ルールを作成してください
#    - depends_on を使用して依存関係を明示的に指定することを推奨します

# 5. 組織全体への影響
#    - このルールは組織内の全アカウント(excluded_accounts で除外したものを除く)
#      に適用されます
#    - 管理アカウントもデフォルトで評価対象に含まれます
