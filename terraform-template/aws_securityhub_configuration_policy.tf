#---------------------------------------------------------------
# AWS Security Hub Configuration Policy
#---------------------------------------------------------------
#
# AWS Security Hubの設定ポリシーをプロビジョニングするリソースです。
# 設定ポリシーは、委任された管理者アカウントが組織全体でSecurity Hubサービス、
# セキュリティ標準、セキュリティコントロールの設定を一元管理するために使用します。
# このリソースを使用するには、aws_securityhub_organization_configurationが
# CENTRAL設定タイプで構成されている必要があります。
#
# AWS公式ドキュメント:
#   - 設定ポリシーの概要: https://docs.aws.amazon.com/securityhub/latest/userguide/configuration-policies-overview.html
#   - 中央設定について: https://docs.aws.amazon.com/securityhub/latest/userguide/central-configuration-intro.html
#   - 設定ポリシーの更新: https://docs.aws.amazon.com/securityhub/latest/userguide/update-policy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_configuration_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_configuration_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 設定ポリシーの名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "example-configuration-policy"

  # description (Optional)
  # 設定内容: 設定ポリシーの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "設定ポリシーの説明"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Security Hub設定ポリシー
  #-------------------------------------------------------------

  # configuration_policy (Required)
  # 設定内容: Security Hubの設定内容を定義するブロックです。
  # 注意: このブロックは必ず1つ指定する必要があります（min_items=1, max_items=1）
  configuration_policy {

    # service_enabled (Required)
    # 設定内容: ポリシーでSecurity Hubを有効にするかどうかを指定します。
    # 設定可能な値:
    #   - true: Security Hubを有効化
    #   - false: Security Hubを無効化（無効化ポリシーとして機能）
    # 注意: falseの場合、security_controls_configurationおよびenabled_standard_arnsは指定不要
    service_enabled = true

    # enabled_standard_arns (Optional)
    # 設定内容: 設定ポリシーで有効化するセキュリティ標準のARNリストを指定します。
    # 設定可能な値: 有効なSecurity Hubセキュリティ標準のARNのセット
    #   - AWS基礎セキュリティベストプラクティス: arn:aws:securityhub:<region>::standards/aws-foundational-security-best-practices/v/1.0.0
    #   - CIS AWS Foundations Benchmark v1.2.0: arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0
    #   - CIS AWS Foundations Benchmark v1.4.0: arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.4.0
    #   - NIST SP 800-53 Rev. 5: arn:aws:securityhub:<region>::standards/nist-800-53/v/5.0.0
    # 省略時: 標準が有効化されません
    # 注意: service_enabledがtrueの場合に指定します
    # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/standards-reference.html
    enabled_standard_arns = [
      "arn:aws:securityhub:us-east-1::standards/aws-foundational-security-best-practices/v/1.0.0",
      "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0",
    ]

    #-----------------------------------------------------------
    # セキュリティコントロール設定
    #-----------------------------------------------------------

    # security_controls_configuration (Optional)
    # 設定内容: 設定ポリシーで有効化するセキュリティコントロールと
    #           パラメータカスタマイズを定義するブロックです。
    # 注意: max_items=1のためブロックは1つまで指定可能
    # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-controls-reference.html
    security_controls_configuration {

      # enabled_control_identifiers (Optional)
      # 設定内容: 設定ポリシーで有効化するセキュリティコントロールの識別子リストを指定します。
      # 設定可能な値: セキュリティコントロール識別子の文字列セット（例: "APIGateway.1", "IAM.7"）
      # 省略時: 全コントロールが有効化されます（enabled_standard_arnsで有効化した標準に含まれるもの）
      # 注意: disabled_control_identifiersと排他的（どちらか一方のみ指定可能）
      #       このリストにないコントロールはSecurity Hubが無効化します
      # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/enable-controls-overview.html
      enabled_control_identifiers = [
        "APIGateway.1",
        "IAM.7",
      ]

      # disabled_control_identifiers (Optional)
      # 設定内容: 設定ポリシーで無効化するセキュリティコントロールの識別子リストを指定します。
      # 設定可能な値: セキュリティコントロール識別子の文字列セット（例: "CloudWatch.1", "S3.1"）
      # 省略時: コントロールの無効化なし（enabled_standard_arnsで有効化した標準の全コントロールが有効）
      # 注意: enabled_control_identifiersと排他的（どちらか一方のみ指定可能）
      #       このリストにないコントロールはSecurity Hubが有効化します（新規リリースコントロールも含む）
      # disabled_control_identifiers = ["CloudWatch.1", "S3.1"]

      #---------------------------------------------------------
      # セキュリティコントロールのカスタムパラメータ設定
      #---------------------------------------------------------

      # security_control_custom_parameter (Optional)
      # 設定内容: 設定ポリシーに含めるコントロールパラメータのカスタマイズを定義するブロックです。
      # 注意: 複数のコントロールに対してカスタマイズする場合は複数ブロックを記述
      security_control_custom_parameter {

        # security_control_id (Required)
        # 設定内容: パラメータをカスタマイズするセキュリティコントロールのIDを指定します。
        # 設定可能な値: 有効なセキュリティコントロール識別子（例: "APIGateway.1", "IAM.7"）
        # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-controls-reference.html
        security_control_id = "APIGateway.1"

        # parameter (Required)
        # 設定内容: コントロールのパラメータ値を定義するブロックです。
        # 注意: min_items=1のため少なくとも1つ指定が必要。複数パラメータは複数ブロックで記述
        parameter {

          # name (Required)
          # 設定内容: カスタマイズするパラメータの名前を指定します。
          # 設定可能な値: 対象コントロールで定義されているパラメータ名
          name = "loggingLevel"

          # value_type (Required)
          # 設定内容: パラメータの値の種類を指定します。
          # 設定可能な値:
          #   - "CUSTOM": カスタム値を使用（boolやenumなどのブロックで値を指定）
          #   - "DEFAULT": コントロールのデフォルト値を使用
          value_type = "CUSTOM"

          # bool (Optional)
          # 設定内容: ブール型のパラメータ値を指定するブロックです。
          # 注意: max_items=1。value_typeが"CUSTOM"の場合に使用。
          #       bool/double/enum/enum_list/int/int_list/string/string_list のいずれか1つを使用
          # bool {
          #   # value (Required)
          #   # 設定内容: ブール値を指定します。
          #   # 設定可能な値: true / false
          #   value = true
          # }

          # double (Optional)
          # 設定内容: 浮動小数点型のパラメータ値を指定するブロックです。
          # 注意: max_items=1。value_typeが"CUSTOM"の場合に使用
          # double {
          #   # value (Required)
          #   # 設定内容: 浮動小数点数値を指定します。
          #   value = 1.5
          # }

          # enum (Optional)
          # 設定内容: 列挙型（単一選択）のパラメータ値を指定するブロックです。
          # 注意: max_items=1。value_typeが"CUSTOM"の場合に使用
          enum {
            # value (Required)
            # 設定内容: 列挙型の値を文字列で指定します。
            # 設定可能な値: 対象コントロールのパラメータで許容される値
            value = "INFO"
          }

          # enum_list (Optional)
          # 設定内容: 列挙型（複数選択）のパラメータ値を指定するブロックです。
          # 注意: max_items=1。value_typeが"CUSTOM"の場合に使用
          # enum_list {
          #   # value (Required)
          #   # 設定内容: 列挙型の値リストを指定します。
          #   # 設定可能な値: 対象コントロールのパラメータで許容される値のリスト
          #   value = ["value1", "value2"]
          # }

          # int (Optional)
          # 設定内容: 整数型のパラメータ値を指定するブロックです。
          # 注意: max_items=1。value_typeが"CUSTOM"の場合に使用
          # int {
          #   # value (Required)
          #   # 設定内容: 整数値を指定します。
          #   value = 60
          # }

          # int_list (Optional)
          # 設定内容: 整数型の複数値のパラメータを指定するブロックです。
          # 注意: max_items=1。value_typeが"CUSTOM"の場合に使用
          # int_list {
          #   # value (Required)
          #   # 設定内容: 整数値のリストを指定します。
          #   value = [1, 2, 3]
          # }

          # string (Optional)
          # 設定内容: 文字列型のパラメータ値を指定するブロックです。
          # 注意: max_items=1。value_typeが"CUSTOM"の場合に使用
          # string {
          #   # value (Required)
          #   # 設定内容: 文字列値を指定します。
          #   value = "example-string"
          # }

          # string_list (Optional)
          # 設定内容: 文字列型の複数値のパラメータを指定するブロックです。
          # 注意: max_items=1。value_typeが"CUSTOM"の場合に使用
          # string_list {
          #   # value (Required)
          #   # 設定内容: 文字列値のリストを指定します。
          #   value = ["value1", "value2"]
          # }
        }
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 設定ポリシーのUUID
# - arn: 設定ポリシーのARN
#        形式: arn:partition:securityhub:region:delegated-admin-account-id:configuration-policy/UUID
#---------------------------------------------------------------
