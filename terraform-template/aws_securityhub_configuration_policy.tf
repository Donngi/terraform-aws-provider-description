#---------------------------------------------------------------
# Security Hub 構成ポリシー
#---------------------------------------------------------------
#
# AWS Security Hubの組織全体の構成を管理するポリシーを定義します。
# このリソースを使用することで、Security Hubの有効化、セキュリティ標準の選択、
# セキュリティコントロールの有効化/無効化、およびコントロールパラメーターの
# カスタマイズを組織単位で一元管理できます。
#
# 前提条件:
# - aws_securityhub_organization_configurationがCENTRALタイプで構成されている必要があります
# - 委任された管理者アカウントから実行する必要があります
#
# AWS公式ドキュメント:
#   - How configuration policies work: https://docs.aws.amazon.com/securityhub/latest/userguide/configuration-policies-overview.html
#   - Creating and associating configuration policies: https://docs.aws.amazon.com/securityhub/latest/userguide/create-associate-policy.html
#   - API Reference: https://docs.aws.amazon.com/securityhub/1.0/APIReference/API_SecurityHubPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_configuration_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_configuration_policy" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # ポリシー名（必須）
  # 構成ポリシーの識別名を指定します
  # 組織内で一意の名前を設定してください
  name = "example-policy"

  # ポリシーの説明（任意）
  # 構成ポリシーの目的や適用範囲を記述します
  # 管理者が内容を理解しやすい説明を記載することを推奨します
  description = "Example Security Hub configuration policy"

  # リージョン指定（任意）
  # このリソースを管理するAWSリージョンを指定します
  # 未指定の場合、プロバイダー設定のリージョンが使用されます
  # 設定後は自動的に計算されます（computed: true）
  # ホームリージョンと全てのリンクされたリージョンに影響します
  # region = "us-east-1"

  #---------------------------------------------------------------
  # 構成ポリシー設定
  #---------------------------------------------------------------

  configuration_policy {
    # Security Hub有効化フラグ（必須）
    # trueの場合、Security Hubを有効化します
    # falseの場合、Security Hubを無効化します
    # 注意: 委任管理者アカウントに対してfalseを設定したポリシーは適用されません
    service_enabled = true

    # 有効化するセキュリティ標準のARNリスト（任意）
    # service_enabled = true の場合、このフィールドの定義を推奨します
    # 複数の標準を同時に有効化できます
    # 利用可能な標準:
    #   - AWS Foundational Security Best Practices (FSBP)
    #   - CIS AWS Foundations Benchmark
    #   - PCI DSS
    #   - NIST 800-53 等
    # ARN形式: arn:aws:securityhub:[region]::standards/[standard-id]/v/[version]
    enabled_standard_arns = [
      "arn:aws:securityhub:us-east-1::standards/aws-foundational-security-best-practices/v/1.0.0",
      # "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0",
    ]

    #---------------------------------------------------------------
    # セキュリティコントロール設定
    #---------------------------------------------------------------

    security_controls_configuration {
      # 無効化するコントロール識別子のリスト（任意）
      # このリストに指定されたコントロール以外の全てのコントロール（新規リリースを含む）が有効化されます
      # enabled_control_identifiers との同時指定はできません（Conflicts）
      # コントロールID形式: "ServiceName.ControlNumber" (例: "IAM.7", "EC2.1")
      disabled_control_identifiers = []

      # 有効化するコントロール識別子のリスト（任意）
      # このリストに指定されたコントロールのみが有効化されます
      # リストに含まれないコントロール（新規リリースを含む）は全て無効化されます
      # disabled_control_identifiers との同時指定はできません（Conflicts）
      # コントロールID形式: "ServiceName.ControlNumber" (例: "APIGateway.1", "Lambda.1")
      # enabled_control_identifiers = [
      #   "APIGateway.1",
      #   "IAM.7",
      # ]

      #---------------------------------------------------------------
      # カスタムパラメーター設定
      #---------------------------------------------------------------

      # 特定のコントロールに対するパラメーターのカスタマイズ（任意）
      # 複数のコントロールをカスタマイズする場合、複数のブロックを定義します
      # カスタマイズ可能なパラメーターはコントロールごとに異なります
      # 詳細は公式ドキュメントの各コントロールリファレンスを参照してください

      # security_control_custom_parameter {
      #   # コントロールID（必須）
      #   # カスタマイズ対象のセキュリティコントロールIDを指定します
      #   security_control_id = "APIGateway.1"
      #
      #   # パラメーター設定（必須、最低1つ）
      #   # コントロールに対する具体的なパラメーター値を設定します
      #   parameter {
      #     # パラメーター名（必須）
      #     # カスタマイズするパラメーターの名前
      #     name = "loggingLevel"
      #
      #     # 値のタイプ（必須）
      #     # "DEFAULT" または "CUSTOM" を指定
      #     # "CUSTOM" の場合、以下のいずれかの値ブロックが必要です
      #     value_type = "CUSTOM"
      #
      #     # 列挙型の値（value_type = "CUSTOM" の場合に使用）
      #     # 文字列の単一値を設定します
      #     enum {
      #       value = "INFO"
      #     }
      #   }
      # }

      # security_control_custom_parameter {
      #   security_control_id = "IAM.7"
      #
      #   # ブール型パラメーター
      #   parameter {
      #     name       = "RequireLowercaseCharacters"
      #     value_type = "CUSTOM"
      #
      #     # ブール型の値（value_type = "CUSTOM" の場合に使用）
      #     # true または false を設定します
      #     bool {
      #       value = false
      #     }
      #   }
      #
      #   # 整数型パラメーター
      #   parameter {
      #     name       = "MaxPasswordAge"
      #     value_type = "CUSTOM"
      #
      #     # 整数型の値（value_type = "CUSTOM" の場合に使用）
      #     # 数値を設定します
      #     int {
      #       value = 60
      #     }
      #   }
      # }

      # その他の値ブロックタイプ（value_type = "CUSTOM" の場合に使用可能）:
      #
      # double {
      #   # 浮動小数点数の値
      #   value = 0.5
      # }
      #
      # enum_list {
      #   # 文字列のリスト値
      #   value = ["value1", "value2"]
      # }
      #
      # int_list {
      #   # 整数のリスト値
      #   value = [1, 2, 3]
      # }
      #
      # string {
      #   # 文字列の値
      #   value = "example"
      # }
      #
      # string_list {
      #   # 文字列のリスト値
      #   value = ["item1", "item2"]
      # }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (computed only)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（入力不可）
#
# arn        - 構成ポリシーのARN
#              形式: arn:aws:securityhub:[region]:[account-id]:configuration-policy/[uuid]
#
# id         - 構成ポリシーのUUID（自動生成）
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: デフォルト標準を有効化したシンプルなポリシー
# resource "aws_securityhub_configuration_policy" "default_standards" {
#   name        = "Default Standards Policy"
#   description = "Enable Security Hub with default standards"
#
#   configuration_policy {
#     service_enabled = true
#     enabled_standard_arns = [
#       "arn:aws:securityhub:us-east-1::standards/aws-foundational-security-best-practices/v/1.0.0",
#       "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0",
#     ]
#     security_controls_configuration {
#       disabled_control_identifiers = []
#     }
#   }
# }

# 例2: Security Hubを無効化するポリシー
# resource "aws_securityhub_configuration_policy" "disabled" {
#   name        = "Disabled Policy"
#   description = "Disable Security Hub for specific OUs"
#
#   configuration_policy {
#     service_enabled = false
#   }
# }

# 例3: カスタムコントロール設定を含むポリシー
# resource "aws_securityhub_configuration_policy" "custom_controls" {
#   name        = "Custom Controls Policy"
#   description = "Policy with custom control parameters"
#
#   configuration_policy {
#     service_enabled = true
#     enabled_standard_arns = [
#       "arn:aws:securityhub:us-east-1::standards/aws-foundational-security-best-practices/v/1.0.0",
#     ]
#     security_controls_configuration {
#       enabled_control_identifiers = [
#         "APIGateway.1",
#         "IAM.7",
#       ]
#       security_control_custom_parameter {
#         security_control_id = "APIGateway.1"
#         parameter {
#           name       = "loggingLevel"
#           value_type = "CUSTOM"
#           enum {
#             value = "INFO"
#           }
#         }
#       }
#       security_control_custom_parameter {
#         security_control_id = "IAM.7"
#         parameter {
#           name       = "RequireLowercaseCharacters"
#           value_type = "CUSTOM"
#           bool {
#             value = false
#           }
#         }
#         parameter {
#           name       = "MaxPasswordAge"
#           value_type = "CUSTOM"
#           int {
#             value = 60
#           }
#         }
#       }
#     }
#   }
# }

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
# - aws_securityhub_account
# - aws_securityhub_finding_aggregator
# - aws_securityhub_organization_admin_account
# - aws_securityhub_organization_configuration
# - aws_securityhub_standards_subscription
#---------------------------------------------------------------
