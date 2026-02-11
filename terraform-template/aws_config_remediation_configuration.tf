################################################################################
# AWS Config Remediation Configuration - Annotated Template
################################################################################
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# 注意:
# - このテンプレートは生成時点(2026-01-19)の情報に基づいています
# - 最新の仕様や詳細については、必ず公式ドキュメントを確認してください
# - AWS Provider Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_remediation_configuration
################################################################################

resource "aws_config_remediation_configuration" "example" {
  ################################################################################
  # 必須パラメータ (Required Parameters)
  ################################################################################

  # AWS Config ルールの名前
  # 既存のAWS Config Ruleに対してremediation configurationを設定する必要があります
  # 参考: https://docs.aws.amazon.com/config/latest/developerguide/remediation.html
  config_rule_name = "example-config-rule"

  # ターゲットID（修復アクションを実行するドキュメントの名前）
  # SSM Documentの名前を指定します（例: AWS-EnableS3BucketEncryption）
  # AWS提供のマネージド自動化ドキュメント、またはカスタムドキュメントを使用できます
  # 参考: https://docs.aws.amazon.com/config/latest/developerguide/remediation.html
  target_id = "AWS-ConfigureS3BucketPublicAccessBlock"

  # ターゲットのタイプ
  # 修復を実行するターゲットのタイプ（例: SSM_DOCUMENT）
  # 有効な値: SSM_DOCUMENT
  # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_RemediationConfiguration.html
  target_type = "SSM_DOCUMENT"

  ################################################################################
  # オプションパラメータ (Optional Parameters)
  ################################################################################

  # 自動修復の有効化
  # trueに設定すると、非準拠リソースに対して自動的に修復が実行されます
  # 最後に確認された準拠データスナップショットに基づき、準拠リソースに対しても自動修復が開始される場合があります
  # 参考: https://docs.aws.amazon.com/config/latest/developerguide/setup-autoremediation.html
  automatic = true

  # リソースタイプ
  # 修復対象のAWSリソースタイプを指定します（例: AWS::S3::Bucket）
  # CloudFormationのリソースタイプ形式で指定します
  # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_RemediationConfiguration.html
  resource_type = "AWS::S3::Bucket"

  # 自動修復の最大試行回数
  # 自動修復の失敗時の最大再試行回数
  # 指定しない場合、デフォルトは5回です
  # 有効範囲: 1-25
  # 参考: https://docs.aws.amazon.com/config/latest/developerguide/setup-autoremediation.html
  maximum_automatic_attempts = 5

  # 再試行間隔（秒）
  # AWS Configが自動修復を実行する最大時間（秒単位）
  # 指定しない場合、デフォルトは60秒です
  # 有効範囲: 60-2592000（最大30日）
  # 参考: https://docs.aws.amazon.com/config/latest/developerguide/setup-autoremediation.html
  retry_attempt_seconds = 60

  # ターゲットバージョン
  # ターゲットのバージョン（例: SSMドキュメントのバージョン）
  # 特定のバージョンまたは$DEFAULTを指定できます
  # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_RemediationConfiguration.html
  target_version = "1"

  # リージョン
  # このリソースが管理されるAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ID（オプション）
  # Terraformによって管理されるリソースID
  # 通常は明示的に設定する必要はありません（computedフィールド）
  # id = "example-config-rule:example"

  ################################################################################
  # ネストブロック: execution_controls
  ################################################################################
  # 実行制御の設定
  # SSM Automation実行時の並列実行率やエラー率を制御します
  # 最大1つのexecution_controlsブロックを指定可能
  # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_RemediationConfiguration.html

  execution_controls {
    # SSM制御設定
    # AWS Systems Manager Automationの実行制御パラメータ
    # 最大1つのssm_controlsブロックを指定可能（必須）
    ssm_controls {
      # 並列実行率（パーセンテージ）
      # そのルールの非準拠リソースに対して並列実行が許可される修復アクションの最大パーセンテージ
      # デフォルトは10%です
      # 有効範囲: 1-100
      # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_SsmControls.html
      concurrent_execution_rate_percentage = 10

      # エラー率（パーセンテージ）
      # SSMが特定のルールの非準拠リソースに対する自動化の実行を停止するまでに許容されるエラーのパーセンテージ
      # デフォルトは50%です
      # 有効範囲: 1-100
      # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_SsmControls.html
      error_percentage = 50
    }
  }

  ################################################################################
  # ネストブロック: parameter（複数指定可能）
  ################################################################################
  # 修復パラメータの設定
  # SSMドキュメントに渡すパラメータを定義します
  # 最大25個のparameterブロックを指定可能
  # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_RemediationParameterValue.html

  # パラメータ例1: 自動化実行ロール（通常必須）
  parameter {
    # パラメータ名（必須）
    # SSMドキュメントで定義されているパラメータ名
    name = "AutomationAssumeRole"

    # 静的な値
    # 実行時に変化しない固定値
    # AutomationAssumeRoleには、SSMがアクションを実行するために引き受けるIAMロールのARNを指定します
    static_value = "arn:aws:iam::123456789012:role/AutomationExecutionRole"
  }

  # パラメータ例2: リソース値を動的に使用
  parameter {
    # パラメータ名（必須）
    name = "BucketName"

    # リソース値（動的）
    # 実行時に動的に変化する値
    # 有効な値: RESOURCE_ID（非準拠リソースのIDが自動的に渡されます）
    resource_value = "RESOURCE_ID"
  }

  # パラメータ例3: 静的な値（単一）
  parameter {
    # パラメータ名（必須）
    name = "PublicAccessBlockConfiguration"

    # 静的な値
    # 実行時に変化しない固定値
    static_value = "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
  }

  # パラメータ例4: 静的な値のリスト
  # parameter {
  #   # パラメータ名（必須）
  #   name = "AllowedActions"
  #
  #   # 静的な値のリスト
  #   # 複数の静的な値を配列として指定する場合に使用
  #   # 注意: static_valuesはcomputedフィールドでもあるため、設定後に値が追加される可能性があります
  #   static_values = ["s3:GetObject", "s3:PutObject"]
  # }

  # 注意事項:
  # - parameter内では、static_value、resource_value、static_valuesのいずれか1つのみを指定してください
  # - 複数指定した場合、動作が保証されません
  # - AutomationAssumeRoleパラメータは、自動修復を使用する場合に必須です
}

################################################################################
# 属性リファレンス (Computed Attributes)
################################################################################
# 以下の属性は、リソース作成後にTerraformによって自動的に設定されます:
#
# - arn: Config Remediation ConfigurationのARN
#   型: string
#   例: arn:aws:config:us-east-1:123456789012:remediation-configuration/example-config-rule
#
################################################################################

################################################################################
# 関連リソース・参考リンク
################################################################################
# - AWS Config Remediation Documentation:
#   https://docs.aws.amazon.com/config/latest/developerguide/remediation.html
#
# - AWS Config API - RemediationConfiguration:
#   https://docs.aws.amazon.com/config/latest/APIReference/API_RemediationConfiguration.html
#
# - AWS Config API - PutRemediationConfigurations:
#   https://docs.aws.amazon.com/config/latest/APIReference/API_PutRemediationConfigurations.html
#
# - Setting Up Auto Remediation:
#   https://docs.aws.amazon.com/config/latest/developerguide/setup-autoremediation.html
#
# - SSM Automation Documents:
#   https://docs.aws.amazon.com/systems-manager-automation-runbooks/latest/userguide/automation-runbook-reference.html
#
# - Terraform AWS Provider Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_remediation_configuration
#
################################################################################
