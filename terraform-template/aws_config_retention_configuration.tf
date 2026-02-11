# ================================================================================
# Terraform Template: aws_config_retention_configuration
# ================================================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# 注意:
# - このテンプレートは生成時点(2026-01-19)の情報に基づいています
# - 最新の仕様や詳細は公式ドキュメントを必ず確認してください
# - AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_retention_configuration
# ================================================================================

# AWS Config の保持設定を管理するリソース
# AWS Config が履歴情報を保存する日数を定義します
resource "aws_config_retention_configuration" "example" {
  # ================================================================================
  # Required Arguments
  # ================================================================================

  # retention_period_in_days - (必須) AWS Config が履歴情報を保存する日数
  # Type: number
  # 制約:
  #   - 最小値: 30日
  #   - 最大値: 2557日（約7年）
  #   - デフォルト（未設定時）: 2557日
  #
  # この保持期間は、AWS Config の ConfigurationItem 履歴にのみ適用されます。
  # 保持期間を設定すると、AWS Config API は指定された保持期間より古い状態を表す
  # ConfigurationItem を返さなくなります。
  #
  # 例:
  #   - 30: 30日間保持（最小値）
  #   - 90: 90日間保持（3ヶ月）
  #   - 365: 365日間保持（1年）
  #   - 1095: 1095日間保持（3年）
  #   - 2557: 2557日間保持（最大値、約7年）
  #
  # 参考: https://docs.aws.amazon.com/config/latest/APIReference/API_PutRetentionConfiguration.html
  retention_period_in_days = 90

  # ================================================================================
  # Optional Arguments
  # ================================================================================

  # region - (オプション) このリソースが管理されるリージョン
  # Type: string
  # デフォルト: プロバイダー設定で指定されたリージョン
  #
  # このリソースを作成・管理するAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  # AWS Config は各リージョンでアカウントごとに1つの保持設定のみをサポートします。
  #
  # 例:
  #   - "us-east-1": 米国東部（バージニア北部）
  #   - "ap-northeast-1": アジアパシフィック（東京）
  #   - "eu-west-1": 欧州（アイルランド）
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ================================================================================
  # Read-only Attributes (Computed)
  # ================================================================================
  # 以下の属性は読み取り専用で、リソース作成後にAWSによって自動的に設定されます:
  #
  # - id: リソースの一意識別子
  # - name: 保持設定オブジェクトの名前（常に "default" という名前になります）
  # ================================================================================
}

# ================================================================================
# 使用例
# ================================================================================
# 基本的な使用例（90日間の保持期間を設定）
# resource "aws_config_retention_configuration" "example" {
#   retention_period_in_days = 90
# }

# 最小保持期間を設定する例（30日）
# resource "aws_config_retention_configuration" "minimum" {
#   retention_period_in_days = 30
# }

# 最大保持期間を設定する例（2557日 = 約7年）
# resource "aws_config_retention_configuration" "maximum" {
#   retention_period_in_days = 2557
# }

# 1年間の保持期間を設定する例
# resource "aws_config_retention_configuration" "one_year" {
#   retention_period_in_days = 365
# }

# 特定のリージョンで保持設定を管理する例
# resource "aws_config_retention_configuration" "tokyo" {
#   retention_period_in_days = 365
#   region                   = "ap-northeast-1"
# }

# ================================================================================
# 重要な注意事項
# ================================================================================
# 1. AWS Config は各リージョンでアカウントごとに1つの保持設定のみをサポートします
# 2. 保持設定オブジェクトの名前は常に "default" になります
# 3. 保持期間は ConfigurationItem 履歴にのみ適用されます
# 4. 記録がオンの場合、AWS Config はリソースの現在の状態を記録し、
#    次の変更が記録されるまで保持します
# 5. 古い ConfigurationItem は指定された保持期間に基づいて削除されます
# 6. 保持期間を設定すると、AWS Config API は指定された保持期間より古い
#    状態を表す ConfigurationItem を返さなくなります
# ================================================================================

# ================================================================================
# 参考リンク
# ================================================================================
# - Terraform AWS Provider ドキュメント:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_retention_configuration
#
# - AWS Config API - PutRetentionConfiguration:
#   https://docs.aws.amazon.com/config/latest/APIReference/API_PutRetentionConfiguration.html
#
# - AWS Config API - RetentionConfiguration:
#   https://docs.aws.amazon.com/config/latest/APIReference/API_RetentionConfiguration.html
#
# - AWS Config - データの削除と保持期間:
#   https://docs.aws.amazon.com/config/latest/developerguide/delete-config-data-with-retention-period.html
#
# - AWS Config API - DescribeRetentionConfigurations:
#   https://docs.aws.amazon.com/config/latest/APIReference/API_DescribeRetentionConfigurations.html
# ================================================================================
