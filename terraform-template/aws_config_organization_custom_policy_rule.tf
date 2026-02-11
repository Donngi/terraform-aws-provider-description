#---------------------------------------------------------------
# AWS Config Organization Custom Policy Rule
#---------------------------------------------------------------
#
# AWS Config Organization Custom Policy Ruleをプロビジョニングするリソースです。
# AWS Organizations内の全アカウントに対してカスタムポリシールールを適用し、
# Guard DSLを使用してリソースの設定をコンプライアンスチェックできます。
#
# AWS公式ドキュメント:
#   - AWS Config Organization Rules: https://docs.aws.amazon.com/config/latest/developerguide/config-rule-multi-account-deployment.html
#   - AWS Config Custom Policy Rules: https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_develop-rules_cfn-guard.html
#   - OrganizationCustomPolicyRuleMetadata API: https://docs.aws.amazon.com/config/latest/APIReference/API_OrganizationCustomPolicyRuleMetadata.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_organization_custom_policy_rule
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_config_organization_custom_policy_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須項目）
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Config Ruleの名前を指定します。
  # 設定可能な値: 1-256文字の文字列
  # 注意: このリソースはOrganizationのマスターアカウントで作成する必要があります。
  #       また、excluded_accountsに明示的に追加しない限り、マスターアカウントも
  #       ルールの対象に含まれます。
  name = "example-custom-policy-rule"

  # policy_runtime (Required)
  # 設定内容: ポリシールールのランタイムシステムを指定します。
  # 設定可能な値: "guard-2.x.x"
  # 説明: Guardはポリシーアズコード言語で、AWS Config Custom Policy Ruleで
  #       強制するポリシーを記述できます。
  # 参考: Guard GitHub Repository - https://github.com/aws-cloudformation/cloudformation-guard
  policy_runtime = "guard-2.x.x"

  # policy_text (Required)
  # 設定内容: ルールのロジックを含むポリシー定義をGuard DSLで記述します。
  # 設定可能な値: 0-10000文字のGuard DSL形式の文字列
  # 説明: AWS CloudFormation GuardのDSLを使用してルールの評価ロジックを定義します。
  #       リソースの設定チェック、必須プロパティの検証、条件付き評価などが可能です。
  # 参考: https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_develop-rules_cfn-guard.html
  policy_text = <<-EOF
    let status = ['ACTIVE']

    rule tableisactive when
        resourceType == "AWS::DynamoDB::Table" {
        configuration.tableStatus == %status
    }

    rule checkcompliance when
        resourceType == "AWS::DynamoDB::Table"
        tableisactive {
            let pitr = supplementaryConfiguration.ContinuousBackupsDescription.pointInTimeRecoveryDescription.pointInTimeRecoveryStatus
            %pitr == "ENABLED"
        }
  EOF

  # trigger_types (Required)
  # 設定内容: AWS Configがルールの評価を実行するトリガーとなる通知タイプを指定します。
  # 設定可能な値:
  #   - "ConfigurationItemChangeNotification": リソース変更時に設定アイテムが配信された際に評価を開始
  #   - "OversizedConfigurationItemChangeNotification": リソース変更時に設定アイテムが
  #     Amazon SNSの最大サイズを超えた場合に評価を開始
  # 説明: Custom Policy Ruleは変更トリガー型の通知タイプをサポートします。
  trigger_types = ["ConfigurationItemChangeNotification"]

  #-------------------------------------------------------------
  # 説明・メタデータ設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ルールの説明を指定します。
  # 設定可能な値: 0-256文字の文字列
  # 説明: ルールの目的や動作を記述します。
  description = "Checks if DynamoDB tables have Point-in-Time Recovery enabled"

  #-------------------------------------------------------------
  # アカウント範囲設定
  #-------------------------------------------------------------

  # excluded_accounts (Optional)
  # 設定内容: ルールから除外するAWSアカウントIDのリストを指定します。
  # 設定可能な値: 12桁のAWSアカウントIDのセット
  # 説明: 指定したアカウントはルールの評価対象から除外されます。
  #       デフォルトではマスターアカウントも評価対象に含まれるため、
  #       除外する場合は明示的に指定する必要があります。
  excluded_accounts = []

  # debug_log_delivery_accounts (Optional)
  # 設定内容: デバッグログを有効化できるアカウントのリストを指定します。
  # 設定可能な値: 12桁のAWSアカウントIDのセット（最大1000アカウント）
  # 説明: 指定したアカウントでデバッグログを有効化できます。
  #       nullの場合、全アカウントでデバッグログが有効化されます。
  debug_log_delivery_accounts = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 入力パラメータ設定
  #-------------------------------------------------------------

  # input_parameters (Optional)
  # 設定内容: ルールに渡すパラメータをJSON形式で指定します。
  # 設定可能な値: 1-2048文字のJSON形式文字列
  # 説明: ルールの評価に使用するカスタムパラメータを定義します。
  #       ポリシーテキスト内で参照可能です。
  input_parameters = null

  #-------------------------------------------------------------
  # 実行頻度設定
  #-------------------------------------------------------------

  # maximum_execution_frequency (Optional)
  # 設定内容: AWS Configがルールの評価を実行する最大頻度を指定します。
  # 設定可能な値:
  #   - "One_Hour": 1時間ごと
  #   - "Three_Hours": 3時間ごと
  #   - "Six_Hours": 6時間ごと
  #   - "Twelve_Hours": 12時間ごと
  #   - "TwentyFour_Hours": 24時間ごと（デフォルト）
  # 説明: ルールが定期的な頻度でトリガーされる場合に適用されます。
  #       AWS Configが設定スナップショットを配信したときにルールがトリガーされます。
  # 省略時: "TwentyFour_Hours"
  maximum_execution_frequency = "TwentyFour_Hours"

  #-------------------------------------------------------------
  # リソーススコープ設定
  #-------------------------------------------------------------

  # resource_types_scope (Optional)
  # 設定内容: 評価対象のAWSリソースタイプのリストを指定します。
  # 設定可能な値: AWSリソースタイプの配列（最大100個）。
  #               各リソースタイプは1-256文字。
  #               例: ["AWS::DynamoDB::Table", "AWS::S3::Bucket"]
  # 説明: 指定したリソースタイプのみがルールの評価対象となります。
  #       省略した場合、全てのリソースタイプが対象となります。
  resource_types_scope = ["AWS::DynamoDB::Table"]

  # resource_id_scope (Optional)
  # 設定内容: 評価対象の特定のAWSリソースIDを指定します。
  # 設定可能な値: 1-768文字のリソースID文字列
  # 説明: 特定のリソースIDのみを評価対象とする場合に指定します。
  resource_id_scope = null

  # tag_key_scope (Optional)
  # 設定内容: 評価対象のAWSリソースのタグキーを指定します。
  # 設定可能な値: 1-128文字のタグキー文字列
  # 説明: tag_value_scopeと併せて、特定のタグを持つリソースのみを評価対象とします。
  # 注意: tag_value_scopeを設定する場合、この項目は必須です。
  tag_key_scope = null

  # tag_value_scope (Optional)
  # 設定内容: 評価対象のAWSリソースのタグ値を指定します。
  # 設定可能な値: 1-256文字のタグ値文字列
  # 説明: tag_key_scopeと併せて、特定のタグを持つリソースのみを評価対象とします。
  tag_value_scope = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional Block)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 説明: create、update、delete操作のタイムアウト時間をカスタマイズできます。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用の出力属性）
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - arn
#     説明: Config Ruleの Amazon Resource Name (ARN)
#     タイプ: string
