# ==============================================================================
# Terraform AWS Provider Resource Template
# ==============================================================================
# Resource: aws_controltower_baseline
# Provider Version: 6.28.0
# Generated: 2026-01-19
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-19)の仕様に基づいています
# - 最新の仕様や詳細は公式ドキュメントを確認してください
# - 全てのオプション属性を網羅していますが、実際の用途に応じて不要な項目は削除してください
#
# 公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/controltower_baseline
# ==============================================================================

resource "aws_controltower_baseline" "example" {
  # ==============================================================================
  # 必須パラメータ (Required Parameters)
  # ==============================================================================

  # baseline_identifier - (Required) The ARN of the baseline to be enabled.
  #
  # AWS Control Towerで有効化するベースラインのARNを指定します。
  # ベースラインは、AWS Control Towerが管理するガバナンスルールとポリシーのセットです。
  #
  # 例: "arn:aws:controltower:us-east-1::baseline/17BSJV3IGJ2QSGA2"
  #
  # Type: string
  baseline_identifier = "arn:aws:controltower:us-east-1::baseline/EXAMPLE_BASELINE_ID"

  # baseline_version - (Required) The version of the baseline to be enabled.
  #
  # 有効化するベースラインのバージョンを指定します。
  # ベースラインは定期的に更新され、新しい機能やセキュリティ強化が追加されます。
  #
  # 例: "4.0", "5.0"
  #
  # Type: string
  baseline_version = "4.0"

  # target_identifier - (Required) The ARN of the target on which the baseline will be enabled.
  #
  # ベースラインを有効化する対象のARNを指定します。
  # 現在、組織単位(OU)のみがターゲットとしてサポートされています。
  #
  # 例: "arn:aws:organizations::123456789012:ou/o-exampleorgid/ou-examplerootid123-exampleouid123"
  #
  # Type: string
  target_identifier = "arn:aws:organizations::123456789012:ou/o-exampleorgid/ou-example"

  # ==============================================================================
  # オプションパラメータ (Optional Parameters)
  # ==============================================================================

  # region - (Optional) Region where this resource will be managed.
  #
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # プロバイダー設定: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # Type: string
  # Default: プロバイダー設定のリージョン
  region = "us-east-1"

  # tags - (Optional) Tags to apply to the landing zone.
  #
  # ランディングゾーンに適用するタグのキーと値のペアを指定します。
  # タグは、リソースの整理、コスト配分、アクセス制御などに使用できます。
  #
  # プロバイダーの default_tags 設定ブロックで定義されたタグがある場合、
  # 同じキーを持つタグはここで指定した値で上書きされます。
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  #
  # Type: map(string)
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "control-tower-baseline"
  }

  # ==============================================================================
  # ネストブロック: parameters
  # ==============================================================================
  # parameters - (Optional) A list of key-value objects that specify enablement parameters.
  #
  # ベースラインの有効化パラメータを指定します。
  # 各パラメータは、特定のベースライン機能の設定や動作をカスタマイズするために使用されます。
  #
  # 例: Identity Center統合の有効化など、ベースライン固有の設定を行います。

  parameters {
    # key - (Required) The key of the parameter.
    #
    # パラメータのキー名を指定します。
    # 使用可能なキーは、有効化するベースラインのタイプによって異なります。
    #
    # 一般的なキーの例:
    # - "IdentityCenterEnabledBaselineArn": Identity Center統合のベースラインARN
    #
    # Type: string
    key = "IdentityCenterEnabledBaselineArn"

    # value - (Required) The value of the parameter.
    #
    # パラメータの値を指定します。
    # 値の形式は、パラメータのキーによって異なります。
    # 文字列、ARN、JSON文書などを指定できます。
    #
    # Type: string
    value = "arn:aws:controltower:us-east-1:123456789012:enabledbaseline/EXAMPLE_ENABLED_BASELINE_ID"
  }

  # 複数のパラメータを指定する場合は、複数のparametersブロックを追加できます
  # parameters {
  #   key   = "AnotherParameter"
  #   value = "AnotherValue"
  # }

  # ==============================================================================
  # タイムアウト設定 (Timeouts)
  # ==============================================================================
  # timeouts - (Optional) リソース操作のタイムアウト時間を設定します。
  #
  # Control Towerのベースライン有効化は時間がかかる操作であるため、
  # 必要に応じてタイムアウト値を調整できます。

  timeouts {
    # create - (Optional) リソース作成時のタイムアウト時間
    #
    # ベースラインの有効化にかかる時間を指定します。
    # 形式: "30s", "5m", "2h45m" など（s=秒, m=分, h=時間）
    #
    # 参考: https://pkg.go.dev/time#ParseDuration
    #
    # Type: string
    create = "60m"

    # update - (Optional) リソース更新時のタイムアウト時間
    #
    # ベースラインの更新にかかる時間を指定します。
    # 形式: "30s", "5m", "2h45m" など（s=秒, m=分, h=時間）
    #
    # Type: string
    update = "60m"

    # delete - (Optional) リソース削除時のタイムアウト時間
    #
    # ベースラインの無効化にかかる時間を指定します。
    # 形式: "30s", "5m", "2h45m" など（s=秒, m=分, h=時間）
    #
    # 注: deleteタイムアウトは、destroy操作の前に状態が保存される場合にのみ適用されます。
    #
    # Type: string
    delete = "60m"
  }
}

# ==============================================================================
# 出力例 (Computed Attributes)
# ==============================================================================
# このリソースを作成すると、以下の計算済み属性が利用可能になります:
#
# - arn: ベースラインのARN
#   例: output "baseline_arn" { value = aws_controltower_baseline.example.arn }
#
# - operation_identifier: 非同期操作のID (UUID形式)
#   例: output "operation_id" { value = aws_controltower_baseline.example.operation_identifier }
#
# - tags_all: リソースに割り当てられた全タグ (プロバイダーのdefault_tagsを含む)
#   例: output "all_tags" { value = aws_controltower_baseline.example.tags_all }
# ==============================================================================
