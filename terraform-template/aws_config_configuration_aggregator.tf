# =============================================================================
# AWS Config Configuration Aggregator
# =============================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# Note: This template is generated based on the AWS Provider schema at the time
# of generation. Always refer to the official documentation for the latest
# specifications and best practices.
# =============================================================================

resource "aws_config_configuration_aggregator" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # name - (必須) Configuration Aggregatorの名前
  # 1文字以上256文字以下の文字列
  # AWS Config Configuration Aggregatorを一意に識別するための名前
  # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_ConfigurationAggregator.html
  name = "example-aggregator"

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # region - (オプション) リソースを管理するリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用される
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags - (オプション) リソースに割り当てるタグのマップ
  # プロバイダーのdefault_tags設定ブロックと組み合わせて使用可能
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags = {
  #   Environment = "production"
  #   ManagedBy   = "terraform"
  # }

  # tags_all - (オプション) リソースに割り当てられる全てのタグのマップ
  # プロバイダーのdefault_tagsから継承されたタグを含む
  # 通常はTerraformが自動的に管理するため、明示的な設定は不要
  # tags_all = {}

  # ============================================================================
  # Block Types - Aggregation Source
  # account_aggregation_sourceとorganization_aggregation_sourceのいずれかを指定する必要がある
  # ============================================================================

  # account_aggregation_source - (オプション) 個別アカウントベースの集約ソース設定
  # 特定のAWSアカウントからConfig データを集約する場合に使用
  # 最大1ブロックまで指定可能
  # 参考: https://docs.aws.amazon.com/config/latest/developerguide/aggregated-add-authorization.html
  # account_aggregation_source {
  #   # account_ids - (必須) 集約対象のAWSアカウントIDのリスト
  #   # 12桁のアカウントIDを指定
  #   account_ids = ["123456789012", "210987654321"]
  #
  #   # all_regions - (オプション) 全てのAWSリージョンから集約するかどうか
  #   # trueの場合、既存および将来のAWS Configリージョンから集約される
  #   # regionsと排他的な関係 - いずれか一方を指定する必要がある
  #   # all_regions = true
  #
  #   # regions - (オプション) 集約対象のリージョンのリスト
  #   # all_regionsと排他的な関係 - いずれか一方を指定する必要がある
  #   # regions = ["us-east-1", "us-west-2"]
  # }

  # organization_aggregation_source - (オプション) AWS Organizations ベースの集約ソース設定
  # AWS Organizations内の全アカウントからConfigデータを集約する場合に使用
  # 最大1ブロックまで指定可能
  # 参考: https://docs.aws.amazon.com/config/latest/developerguide/aggregated-add-authorization.html
  organization_aggregation_source {
    # role_arn - (必須) 集約アカウントに関連付けられたAWS OrganizationのDetails取得に使用するIAMロールのARN
    # AWSConfigRoleForOrganizationsマネージドポリシーをアタッチしたロールを指定
    # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_OrganizationAggregationSource.html
    role_arn = "arn:aws:iam::123456789012:role/aws-config-aggregator-role"

    # all_regions - (オプション) 全てのAWSリージョンから集約するかどうか
    # trueの場合、既存および将来のAWS Configリージョンから集約される
    # regionsと排他的な関係 - いずれか一方を指定する必要がある
    all_regions = true

    # regions - (オプション) 集約対象のリージョンのリスト
    # all_regionsと排他的な関係 - いずれか一方を指定する必要がある
    # regions = ["us-east-1", "us-west-2", "eu-west-1"]
  }
}

# =============================================================================
# Attributes Reference
# =============================================================================
# 以下の属性がエクスポートされ、他のリソースから参照可能:
#
# - arn - Configuration AggregatorのARN
# - tags_all - リソースに割り当てられた全てのタグ (プロバイダーのdefault_tagsから継承されたタグを含む)
#
# 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_aggregator
# =============================================================================
