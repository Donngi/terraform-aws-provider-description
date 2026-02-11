# ============================================================================
# AWS Config Configuration Recorder
# ============================================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-19)の情報に基づいています。
#       最新の仕様については公式ドキュメントを必ず確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder
# ============================================================================

# AWS Config Configuration Recorderは、AWSリソースの構成変更を記録するために使用されます。
# 注意: このリソースは作成されたレコーダーを自動的に開始しません。
# レコーダーを開始するには、aws_config_configuration_recorder_statusリソースが必要です。
# また、配信チャネル(aws_config_delivery_channel)の設定も必要です。
#
# AWS公式ドキュメント:
# - AWS Config Configuration Recorder概要: https://docs.aws.amazon.com/config/latest/developerguide/stop-start-recorder.html
# - IAMロール権限: https://docs.aws.amazon.com/config/latest/developerguide/iamrole-permissions.html
# - Recording Group: https://docs.aws.amazon.com/config/latest/APIReference/API_RecordingGroup.html
# - Recording Mode: https://docs.aws.amazon.com/config/latest/APIReference/API_RecordingMode.html

resource "aws_config_configuration_recorder" "example" {
  # ============================================================================
  # 基本設定
  # ============================================================================

  # (Optional) レコーダーの名前
  # デフォルトは "default"
  # 変更すると、リソースが再作成されます
  name = "example-recorder"

  # (Required) IAMロールのAmazon Resource Name (ARN)
  # 配信チャネルへの読み取り/書き込みリクエストと、アカウントに関連するAWSリソースの記述に使用されます
  # AWS Config用のIAMロール権限の詳細: http://docs.aws.amazon.com/config/latest/developerguide/iamrole-permissions.html
  role_arn = "arn:aws:iam::123456789012:role/aws-config-role"

  # (Optional) このリソースが管理されるリージョン
  # デフォルトではプロバイダー設定のリージョンが使用されます
  # リージョナルエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # プロバイダー設定: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  region = "us-east-1"

  # (Optional) Computed属性
  # id: レコーダーの名前（自動的に設定されます）

  # ============================================================================
  # Recording Group - 記録するリソースタイプの設定
  # ============================================================================
  # AWS Configがどのリソースタイプの構成変更を記録するかを指定します
  # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_RecordingGroup.html

  recording_group {
    # (Optional) サポートされているすべてのリージョナルリソースタイプの構成変更を記録するかどうか
    # 将来サポートされる新しいタイプも含まれます
    # デフォルト: true
    # resource_types と競合します
    # include_global_resource_types = true を設定するには、この値を true にする必要があります
    all_supported = true

    # (Optional) グローバルリソースタイプ（IAMリソースなど）をすべて含めるかどうか
    # all_supported = true が必要です
    # resource_types と競合します
    # 注意: 一部のリージョンでは2022年2月以降、IAMリソースタイプを記録できません
    # （例: アジアパシフィック（ハイデラバード）、アジアパシフィック（メルボルン）など）
    include_global_resource_types = true

    # (Optional) AWS Configが構成変更を記録する特定のAWSリソースタイプのリスト
    # 例: ["AWS::EC2::Instance", "AWS::CloudTrail::Trail"]
    # この属性を使用するには、all_supported を false に設定する必要があります
    # all_supported および include_global_resource_types と競合します
    # 利用可能なタイプ: http://docs.aws.amazon.com/config/latest/APIReference/API_ResourceIdentifier.html#config-Type-ResourceIdentifier-resourceType
    # resource_types = ["AWS::EC2::Instance", "AWS::EC2::Volume"]

    # ============================================================================
    # Exclusion By Resource Types - 除外するリソースタイプの設定
    # ============================================================================
    # AWS Configがリソースタイプを記録から除外する方法を指定します
    # このオプションを使用するには、recording_strategy の use_only フィールドを
    # "EXCLUSION_BY_RESOURCE_TYPES" に設定する必要があります
    # all_supported = false が必要です
    # resource_types と競合します

    # exclusion_by_resource_types {
    #   # (Optional) AWS Configが構成変更の記録から除外するAWSリソースタイプのリスト
    #   # 例: ["AWS::EC2::Instance"] を指定すると、EC2インスタンスは記録されません
    #   # 利用可能なタイプ: http://docs.aws.amazon.com/config/latest/APIReference/API_ResourceIdentifier.html#config-Type-ResourceIdentifier-resourceType
    #   resource_types = ["AWS::EC2::Instance"]
    # }

    # ============================================================================
    # Recording Strategy - 記録戦略の設定
    # ============================================================================
    # Configuration Recorderの記録戦略を設定します
    # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_RecordingStrategy.html

    # recording_strategy {
    #   # (Optional) 記録戦略
    #   # 有効な値:
    #   # - "ALL_SUPPORTED_RESOURCE_TYPES": サポートされているすべてのリソースタイプを記録（グローバルIAMリソースタイプを除く）
    #   # - "INCLUSION_BY_RESOURCE_TYPES": RecordingGroupのresourceTypesフィールドで指定されたリソースタイプのみを記録
    #   # - "EXCLUSION_BY_RESOURCE_TYPES": ExclusionByResourceTypesのresourceTypesフィールドで指定されたリソースタイプを除くすべてのリソースタイプを記録
    #   # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_RecordingStrategy.html
    #   use_only = "EXCLUSION_BY_RESOURCE_TYPES"
    # }
  }

  # ============================================================================
  # Recording Mode - 記録モードの設定
  # ============================================================================
  # AWS Configの記録頻度を設定します
  # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_RecordingMode.html

  recording_mode {
    # (Optional) デフォルトの記録頻度
    # 有効な値:
    # - "CONTINUOUS": 構成変更が発生するたびに継続的に記録（デフォルト）
    # - "DAILY": 過去24時間の最新のリソース状態を1日1回記録（前回の状態と異なる場合のみ）
    # 注意:
    # - AWS Firewall Managerは継続的な記録を必要とします
    # - 特定のリソースタイプは日次記録をサポートしておらず、継続的な記録にデフォルト設定されます
    # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_RecordingMode.html
    recording_frequency = "CONTINUOUS"

    # ============================================================================
    # Recording Mode Override - 記録モードのオーバーライド設定
    # ============================================================================
    # 特定のリソースタイプに対して記録頻度をオーバーライドします
    # 最大1つのオーバーライドブロックを設定できます

    # recording_mode_override {
    #   # (Optional) オーバーライドの説明
    #   description = "Override recording frequency for specific resources"

    #   # (Required) オーバーライドが適用されるAWSリソースタイプのリスト
    #   # 制限事項: https://docs.aws.amazon.com/config/latest/APIReference/API_RecordingModeOverride.html
    #   resource_types = ["AWS::EC2::NetworkInterface"]

    #   # (Required) オーバーライドブロック内のリソースの記録頻度
    #   # 有効な値: "CONTINUOUS" または "DAILY"
    #   recording_frequency = "DAILY"
    # }
  }
}

# ============================================================================
# 使用例
# ============================================================================

# 例1: 基本的な使用方法（すべてのリソースを継続的に記録）
# resource "aws_config_configuration_recorder" "basic" {
#   name     = "example"
#   role_arn = aws_iam_role.config_role.arn
# }

# 例2: 特定のリソースタイプを除外
# resource "aws_config_configuration_recorder" "exclude_resources" {
#   name     = "example"
#   role_arn = aws_iam_role.config_role.arn
#
#   recording_group {
#     all_supported = false
#
#     exclusion_by_resource_types {
#       resource_types = ["AWS::EC2::Instance"]
#     }
#
#     recording_strategy {
#       use_only = "EXCLUSION_BY_RESOURCE_TYPES"
#     }
#   }
# }

# 例3: 定期的な記録（日次記録のオーバーライド）
# resource "aws_config_configuration_recorder" "periodic" {
#   name     = "example"
#   role_arn = aws_iam_role.config_role.arn
#
#   recording_group {
#     all_supported                 = false
#     include_global_resource_types = false
#     resource_types                = ["AWS::EC2::Instance", "AWS::EC2::NetworkInterface"]
#   }
#
#   recording_mode {
#     recording_frequency = "CONTINUOUS"
#
#     recording_mode_override {
#       description         = "Only record EC2 network interfaces daily"
#       resource_types      = ["AWS::EC2::NetworkInterface"]
#       recording_frequency = "DAILY"
#     }
#   }
# }

# ============================================================================
# 必要なIAMロール設定の例
# ============================================================================

# data "aws_iam_policy_document" "config_assume_role" {
#   statement {
#     effect = "Allow"
#
#     principals {
#       type        = "Service"
#       identifiers = ["config.amazonaws.com"]
#     }
#
#     actions = ["sts:AssumeRole"]
#   }
# }
#
# resource "aws_iam_role" "config_role" {
#   name               = "aws-config-role"
#   assume_role_policy = data.aws_iam_policy_document.config_assume_role.json
# }
