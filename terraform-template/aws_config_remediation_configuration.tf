#---------------------------------------
# AWS Config Remediation Configuration
#---------------------------------------
# AWS Configルールに対する自動修復アクションを定義するリソース
# コンプライアンス違反を検出した際に、SSM Automation Documentを使用して
# リソースを自動的に修復できます
#
# 主な用途:
# - セキュリティベストプラクティスの自動適用
# - コンプライアンス違反の自動修正
# - 設定ドリフトの自動是正
# - 運用負荷の軽減
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/config_remediation_configuration
#
# NOTE: このテンプレートはAWS Provider 6.28.0のスキーマに基づいて生成されています。
#       実際の環境に合わせて適切な値を設定してください。
#---------------------------------------

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_config_remediation_configuration" "example" {
  # 設定内容: 修復対象となるAWS Configルールの名前
  # 省略時: 省略不可（必須）
  config_rule_name = "example-config-rule"

  # 設定内容: 修復に使用するSSM Automation Documentのターゲット識別子（ARNまたはドキュメント名）
  # 設定可能な値: SSM Automation DocumentのARNまたは名前（例: AWS-PublishSNSNotification）
  # 省略時: 省略不可（必須）
  target_id = "AWS-PublishSNSNotification"

  # 設定内容: 修復ターゲットのタイプ
  # 設定可能な値: SSM_DOCUMENT
  # 省略時: 省略不可（必須）
  target_type = "SSM_DOCUMENT"

  #---------------------------------------
  # 自動修復設定
  #---------------------------------------

  # 設定内容: コンプライアンス違反を検出した際に自動的に修復を実行するかどうか
  # 省略時: false（手動実行のみ）
  automatic = true

  # 設定内容: 自動修復の最大試行回数
  # 設定可能な値: 1～25の整数
  # 省略時: 5回
  maximum_automatic_attempts = 5

  # 設定内容: 修復失敗時の再試行間隔（秒）
  # 設定可能な値: 60～2678400（1分～31日）の整数
  # 省略時: 60秒
  retry_attempt_seconds = 60

  #---------------------------------------
  # リソース設定
  #---------------------------------------

  # 設定内容: 修復対象となるAWSリソースタイプ
  # 設定可能な値: AWS::EC2::Instance, AWS::S3::Bucket等のAWSリソースタイプ
  # 省略時: 全てのリソースタイプが対象
  resource_type = "AWS::EC2::Instance"

  # 設定内容: SSM Automation Documentのバージョン
  # 省略時: $DEFAULT（最新バージョン）
  target_version = "1"

  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョン
  region = "ap-northeast-1"

  #---------------------------------------
  # 実行制御設定
  #---------------------------------------

  execution_controls {
    ssm_controls {
      # 設定内容: 同時実行可能な修復アクションの割合（%）
      # 設定可能な値: 1～100の整数
      # 省略時: 10%
      concurrent_execution_rate_percentage = 10

      # 設定内容: 許容されるエラー発生率（%）、この割合を超えると修復実行が停止
      # 設定可能な値: 1～100の整数
      # 省略時: 50%
      error_percentage = 50
    }
  }

  #---------------------------------------
  # パラメータ設定
  #---------------------------------------

  parameter {
    # 設定内容: SSM Automation Documentに渡すパラメータ名
    # 省略時: 省略不可（必須）
    name = "AutomationAssumeRole"

    # 設定内容: 静的な文字列値
    # 注意事項: static_value, static_values, resource_valueのいずれか1つのみ指定可能
    # 省略時: resource_valueまたはstatic_valuesを使用
    static_value = "arn:aws:iam::123456789012:role/AutomationRole"
  }

  parameter {
    name = "InstanceId"

    # 設定内容: AWS Config評価結果から取得する動的リソース値
    # 設定可能な値: RESOURCE_ID（リソースID）
    # 省略時: static_valueまたはstatic_valuesを使用
    resource_value = "RESOURCE_ID"
  }

  parameter {
    name = "Tags"

    # 設定内容: 複数の静的文字列値のリスト
    # 注意事項: 最大100個まで指定可能
    # 省略時: static_valueまたはresource_valueを使用
    static_values = ["Environment:Production", "ManagedBy:Config"]
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# arn - 修復設定のARN
# id - 修復設定の識別子（config_rule_name）
# region - 修復設定が管理されているリージョン
#---------------------------------------
