################################################################################
# AWS Route 53 Recovery Readiness Cell
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_cell
# Provider Version: 6.28.0
################################################################################

# Provides an AWS Route 53 Recovery Readiness Cell.
#
# AWS Route 53 Application Recovery Controller の Recovery Readiness Cell は、
# アプリケーションの災害復旧準備状態を評価するための論理的なコンテナです。
# Cell は、アプリケーションの一部またはアプリケーション全体を表し、
# リソースセットとレディネスチェックを関連付けることで、
# リカバリに必要なリソースが準備できているかを継続的に監視します。

resource "aws_route53recoveryreadiness_cell" "example" {
  ################################################################################
  # Required Parameters
  ################################################################################

  # cell_name - (Required) string
  # セルの一意な名前
  #
  # この名前は AWS アカウント内でユニークである必要があります。
  # セルはアプリケーションやアプリケーションコンポーネントを論理的にグループ化するために使用されます。
  # 命名規則として、リージョンや環境、アプリケーション名を含めることを推奨します。
  # 例: "us-west-2-production-app", "eu-west-1-failover-cell"
  cell_name = "us-west-2-failover-cell"

  ################################################################################
  # Optional Parameters
  ################################################################################

  # cells - (Optional) list(string)
  # ネストされた障害ドメインとして追加するセル ARN のリスト
  #
  # 複数のセルを階層的に構成することで、より細かい粒度での障害ドメイン管理が可能になります。
  # 親セルは子セルの準備状態を集約して評価します。
  # ネストされたセルを使用することで、マルチリージョン構成やマルチアプリケーション構成を管理できます。
  # 例: 異なるリージョンのセルを親セルに追加することで、グローバルなレディネスを監視
  cells = [
    # "arn:aws:route53-recovery-readiness:us-east-1:123456789012:cell/us-east-1-cell",
    # "arn:aws:route53-recovery-readiness:eu-west-1:123456789012:cell/eu-west-1-cell"
  ]

  # tags - (Optional) map(string)
  # リソースに付与するタグのキー・バリューマッピング
  #
  # Provider の default_tags と併用可能です。
  # 同じキーのタグは、リソースレベルの tags が Provider レベルの default_tags を上書きします。
  # コスト配分、リソース管理、セキュリティポリシーの適用に活用できます。
  tags = {
    Name        = "example-recovery-cell"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  ################################################################################
  # Computed Attributes (Read-only)
  ################################################################################

  # arn - (Computed) string
  # セルの ARN
  # 他のリソースからこのセルを参照する際に使用します。

  # parent_readiness_scopes - (Computed) list(string)
  # このセルを含む Readiness Scope (Recovery Group または Cell) のリスト
  # セルの階層構造を理解するために有用です。

  # tags_all - (Computed) map(string)
  # Provider の default_tags を含む、リソースに割り当てられた全タグのマップ

  ################################################################################
  # Nested Blocks
  ################################################################################

  # timeouts - (Optional) single block
  # リソース操作のタイムアウト設定
  timeouts {
    # delete - (Optional) string
    # 削除操作のタイムアウト時間 (デフォルト: 一定時間)
    #
    # 形式: "60m", "2h", "30s" など
    # セルに関連する多数のリソースがある場合、削除に時間がかかることがあります。
    delete = "5m"
  }
}

################################################################################
# Outputs
################################################################################

output "route53recoveryreadiness_cell_arn" {
  description = "The ARN of the Route 53 Recovery Readiness Cell"
  value       = aws_route53recoveryreadiness_cell.example.arn
}

output "route53recoveryreadiness_cell_id" {
  description = "The ID of the Route 53 Recovery Readiness Cell"
  value       = aws_route53recoveryreadiness_cell.example.id
}

output "route53recoveryreadiness_cell_parent_scopes" {
  description = "The parent readiness scopes containing this cell"
  value       = aws_route53recoveryreadiness_cell.example.parent_readiness_scopes
}

################################################################################
# Additional Examples
################################################################################

# Example: Nested Cell Configuration (Multi-Region Setup)
# resource "aws_route53recoveryreadiness_cell" "regional_cell_us_west" {
#   cell_name = "us-west-2-regional-cell"
#
#   tags = {
#     Region = "us-west-2"
#     Type   = "regional"
#   }
# }
#
# resource "aws_route53recoveryreadiness_cell" "regional_cell_us_east" {
#   cell_name = "us-east-1-regional-cell"
#
#   tags = {
#     Region = "us-east-1"
#     Type   = "regional"
#   }
# }
#
# resource "aws_route53recoveryreadiness_cell" "global_cell" {
#   cell_name = "global-application-cell"
#
#   cells = [
#     aws_route53recoveryreadiness_cell.regional_cell_us_west.arn,
#     aws_route53recoveryreadiness_cell.regional_cell_us_east.arn
#   ]
#
#   tags = {
#     Scope = "global"
#     Type  = "parent"
#   }
# }

################################################################################
# Related Resources
################################################################################

# - aws_route53recoveryreadiness_recovery_group: Recovery Group の作成
# - aws_route53recoveryreadiness_resource_set: リソースセットの定義
# - aws_route53recoveryreadiness_readiness_check: レディネスチェックの作成

################################################################################
# Best Practices
################################################################################

# 1. 命名規則
#    - セル名にはリージョン、環境、アプリケーション名を含める
#    - 階層構造が分かりやすい命名を心がける
#
# 2. タグ付け
#    - 環境、所有者、コスト配分のためのタグを必ず設定
#    - Provider の default_tags を活用してタグ管理を簡素化
#
# 3. ネスト構造
#    - リージョナルセルをまず作成し、その後グローバルセルでまとめる
#    - 障害ドメインの粒度は管理しやすい単位に設定
#
# 4. Recovery Group との連携
#    - Cell は Recovery Group と組み合わせて使用することで効果を発揮
#    - アプリケーション全体の準備状態を監視するには Recovery Group を作成
#
# 5. モニタリング
#    - CloudWatch メトリクスを使用してセルのレディネス状態を監視
#    - アラームを設定して準備不足を早期に検知

################################################################################
# Important Notes
################################################################################

# - Cell の削除には、関連する Resource Set や Readiness Check の削除が必要な場合があります
# - Cell は ARN で他のリソースから参照されるため、削除時は依存関係に注意してください
# - ネストされたセルの構成を変更する場合、親セルの準備状態評価に影響があります
# - Route 53 Application Recovery Controller は特定のリージョンでのみ利用可能です
#   (us-east-1, us-west-2, ap-northeast-1, ap-southeast-2, eu-west-1)
