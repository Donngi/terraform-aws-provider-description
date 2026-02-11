################################################################################
# Resource: aws_route53_resolver_config
# Provider Version: 6.28.0
# Last Updated: 2026-02-03
################################################################################
# Description:
# Provides a Route 53 Resolver config resource.
#
# Key Features:
# - VPC単位でRoute 53 Resolverの設定を管理
# - 逆引きDNSルックアップの自動定義ルールの制御
# - VPCごとのDNS解決動作のカスタマイズ
#
# Use Cases:
# - VPCの逆引きDNSルックアップ設定の管理
# - プライベートホストゾーンとの統合
# - DNSセキュリティポリシーの実装
#
# Best Practices:
# - VPCのDNS設定(enable_dns_support, enable_dns_hostnames)を有効化
# - セキュリティ要件に応じて逆引きルックアップを適切に設定
# - 複数VPCで一貫したDNS設定ポリシーを適用
#
# Important Notes:
# - このリソースはVPC単位で1つのみ作成可能
# - 既存のVPCに対して設定を適用する
# - 削除時は設定がデフォルト値に戻る
#
# Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/route53_resolver_config
################################################################################

resource "aws_route53_resolver_config" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # resource_id - (Required) string
  # Description:
  # - The ID of the VPC that the configuration is for.
  # - 設定を適用する対象のVPC ID
  #
  # Details:
  # - VPC IDは有効なVPCリソースのIDである必要がある
  # - 1つのVPCに対して1つのResolver設定のみ存在可能
  # - VPCは事前に作成されている必要がある
  #
  # Constraints:
  # - 有効なVPC IDフォーマット (vpc-xxxxxxxx)
  # - VPCは同じリージョン内に存在する必要がある
  #
  # Example Values:
  # - aws_vpc.example.id
  # - "vpc-0123456789abcdef0"
  resource_id = aws_vpc.example.id

  # autodefined_reverse_flag - (Required) string
  # Description:
  # - Indicates whether or not the Resolver will create autodefined rules for reverse DNS lookups.
  # - 逆引きDNSルックアップの自動定義ルールを作成するかどうか
  #
  # Details:
  # - ENABLEの場合、Resolverは自動的に逆引きルールを作成
  # - DISABLEの場合、手動で逆引きルールを定義する必要がある
  # - デフォルトではENABLEに設定される
  #
  # Valid Values:
  # - "ENABLE" : 自動定義ルールを有効化（推奨）
  # - "DISABLE": 自動定義ルールを無効化（手動管理が必要）
  #
  # Security Considerations:
  # - DISABLEにすると、意図しないDNSクエリを防げる
  # - ENABLEは利便性が高いが、すべての逆引きクエリが許可される
  #
  # Example Values:
  # - "ENABLE"
  # - "DISABLE"
  autodefined_reverse_flag = "DISABLE"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # region - (Optional) string (Computed)
  # Description:
  # - Region where this resource will be managed.
  # - このリソースが管理されるリージョン
  #
  # Details:
  # - デフォルトではプロバイダー設定のリージョンが使用される
  # - 明示的に指定することで、プロバイダーとは異なるリージョンで管理可能
  # - VPCと同じリージョンである必要がある
  #
  # Default Behavior:
  # - プロバイダー設定のリージョンが使用される
  # - 省略可能（通常は指定不要）
  #
  # Example Values:
  # - "us-east-1"
  # - "ap-northeast-1"
  # - "eu-west-1"
  # region = "us-east-1"

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################

  # These attributes are automatically set by AWS and cannot be configured.
  # They are available for reference in other resources or outputs.
  #
  # - id        : string - The ID of the resolver configuration
  # - owner_id  : string - The AWS account ID of the owner of the VPC

  ################################################################################
  # Lifecycle Management
  ################################################################################

  # lifecycle {
  #   # Resolver設定の意図しない削除を防止
  #   prevent_destroy = true
  #
  #   # VPC削除時にResolver設定も削除
  #   # create_before_destroy = false
  #
  #   # 特定の属性変更を無視（通常は不要）
  #   # ignore_changes = [
  #   #   region,
  #   # ]
  # }
}

################################################################################
# Related Resources
################################################################################

# VPCリソース（必須）
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  # DNS設定を有効化（Resolver設定の前提条件）
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

################################################################################
# Outputs
################################################################################

output "resolver_config_id" {
  description = "The ID of the Route 53 Resolver configuration"
  value       = aws_route53_resolver_config.example.id
}

output "resolver_config_owner_id" {
  description = "The AWS account ID of the VPC owner"
  value       = aws_route53_resolver_config.example.owner_id
}

################################################################################
# Usage Examples
################################################################################

# Example 1: 逆引きDNSルックアップを無効化
# resource "aws_route53_resolver_config" "no_reverse" {
#   resource_id              = aws_vpc.private.id
#   autodefined_reverse_flag = "DISABLE"
# }

# Example 2: 逆引きDNSルックアップを有効化（デフォルト動作）
# resource "aws_route53_resolver_config" "with_reverse" {
#   resource_id              = aws_vpc.public.id
#   autodefined_reverse_flag = "ENABLE"
# }

# Example 3: 特定リージョンでの設定
# resource "aws_route53_resolver_config" "regional" {
#   resource_id              = aws_vpc.regional.id
#   autodefined_reverse_flag = "DISABLE"
#   region                   = "ap-northeast-1"
# }

################################################################################
# Common Patterns
################################################################################

# Pattern 1: Private HostedZoneとの統合
# resource "aws_vpc" "main" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_support   = true
#   enable_dns_hostnames = true
# }
#
# resource "aws_route53_zone" "private" {
#   name = "internal.example.com"
#   vpc {
#     vpc_id = aws_vpc.main.id
#   }
# }
#
# resource "aws_route53_resolver_config" "main" {
#   resource_id              = aws_vpc.main.id
#   autodefined_reverse_flag = "ENABLE"
# }

# Pattern 2: マルチVPC環境での一貫した設定
# locals {
#   vpcs = {
#     production  = aws_vpc.production.id
#     staging     = aws_vpc.staging.id
#     development = aws_vpc.development.id
#   }
# }
#
# resource "aws_route53_resolver_config" "vpcs" {
#   for_each = local.vpcs
#
#   resource_id              = each.value
#   autodefined_reverse_flag = "DISABLE"
# }

# Pattern 3: セキュリティ強化（逆引き無効化）
# resource "aws_route53_resolver_config" "secure" {
#   resource_id              = aws_vpc.secure.id
#   autodefined_reverse_flag = "DISABLE"
#
#   lifecycle {
#     prevent_destroy = true
#   }
# }

################################################################################
# Troubleshooting
################################################################################

# Issue 1: "InvalidParameterValue: VPC not found"
# Solution: VPCが存在し、同じリージョン内にあることを確認
#
# Issue 2: "ResourceAlreadyExists"
# Solution: 1つのVPCに対して1つのResolver設定のみ作成可能。既存設定を確認
#
# Issue 3: DNS resolution not working
# Solution: VPCのDNS設定（enable_dns_support、enable_dns_hostnames）を確認

################################################################################
# Security Considerations
################################################################################

# 1. 逆引きDNSルックアップ
#    - セキュリティ要件に応じてDISABLEを検討
#    - 不要なDNSクエリを防止
#
# 2. VPCアクセス制御
#    - VPCレベルのセキュリティグループとNACLで保護
#    - Resolver設定は認証されたアカウントのみが変更可能
#
# 3. 監査とログ
#    - CloudTrailで設定変更を記録
#    - Route 53 Resolver Query Loggingを有効化

################################################################################
# Cost Optimization
################################################################################

# Route 53 Resolver設定自体に直接的なコストは発生しませんが、
# 以下の関連コストに注意：
#
# 1. Route 53 Resolver Query Logging
#    - 有効化するとクエリ数に応じて課金
#
# 2. Route 53 Resolver Endpoints
#    - インバウンド/アウトバウンドエンドポイントは時間単位で課金
#
# 3. Route 53 Private Hosted Zones
#    - VPC関連付け数に応じて課金

################################################################################
# Validation Rules
################################################################################

# 1. resource_id
#    - 有効なVPC IDフォーマット
#    - VPCが存在する
#    - VPCが同じリージョン内にある
#
# 2. autodefined_reverse_flag
#    - "ENABLE" または "DISABLE" のみ
#
# 3. region (オプション)
#    - 有効なAWSリージョンコード
#    - VPCと同じリージョン
