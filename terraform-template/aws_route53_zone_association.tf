################################################################################
# AWS Route53 Zone Association
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/route53_zone_association
################################################################################

# aws_route53_zone_association
# Route53プライベートホストゾーンをVPCに関連付けるリソース
#
# 注意事項:
# - VPCとの関連付けは、プライベートゾーンでのみ可能です
# - クロスアカウント関連付けには、aws_route53_vpc_association_authorization リソースが必要です
# - このリソースと aws_route53_zone リソースの vpc ブロックを同時に使用すると、
#   継続的な差分が発生するため推奨されません
# - 通常は aws_route53_zone リソースの vpc ブロックを使用してください
# - このリソースを使用する場合は、aws_route53_zone リソースで
#   lifecycle { ignore_changes = [vpc] } を設定してください
#
# ユースケース:
# - クロスアカウントでのVPC関連付け
# - 明示的な関連付け順序が必要な場合
# - 既存のホストゾーンに追加のVPCを関連付ける場合

resource "aws_route53_zone_association" "example" {
  ################################################################################
  # Required Parameters
  ################################################################################

  # zone_id - プライベートホストゾーンID
  # (Required) 関連付けるプライベートホストゾーンのID
  # 形式: Z1234567890ABC
  #
  # 取得方法:
  # - aws_route53_zone.example.zone_id
  # - AWS CLIコマンド: aws route53 list-hosted-zones-by-name --dns-name example.com
  # - AWS Consoleで確認
  #
  # 制約:
  # - プライベートゾーンのみ指定可能（パブリックゾーンは不可）
  # - 存在するゾーンIDである必要があります
  zone_id = "Z1234567890ABC"

  # vpc_id - VPC ID
  # (Required) プライベートホストゾーンに関連付けるVPCのID
  # 形式: vpc-xxxxxxxx
  #
  # 取得方法:
  # - aws_vpc.example.id
  # - AWS CLIコマンド: aws ec2 describe-vpcs
  # - AWS Consoleで確認
  #
  # 前提条件:
  # - VPCでDNS解決を有効にする必要があります (enable_dns_support = true)
  # - VPCでDNSホスト名を有効にすることを推奨 (enable_dns_hostnames = true)
  #
  # 同一ゾーンに複数のVPCを関連付け可能です
  vpc_id = "vpc-12345678"

  ################################################################################
  # Optional Parameters
  ################################################################################

  # vpc_region - VPCのリージョン
  # (Optional) VPCが存在するAWSリージョン
  # デフォルト: AWSプロバイダーのリージョン
  #
  # クロスリージョンでVPCを関連付ける場合に指定します
  # 例: "us-west-2", "ap-northeast-1"
  #
  # ユースケース:
  # - 異なるリージョンのVPCをプライベートホストゾーンに関連付ける
  # - マルチリージョン構成でのDNS解決
  # vpc_region = "us-east-1"

  ################################################################################
  # Timeouts
  ################################################################################

  # タイムアウト設定
  # VPC関連付けの作成・削除にかかる時間を制御します
  #
  # デフォルト値:
  # - create: 通常は数秒～1分程度
  # - delete: 通常は数秒～1分程度
  #
  # タイムアウトを延長する必要がある場合:
  # - 大規模なVPC
  # - ネットワーク遅延が予想される環境
  # - クロスアカウント/クロスリージョン構成
  # timeouts {
  #   create = "10m"
  #   delete = "10m"
  # }
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################

# このリソースから参照可能な読み取り専用属性:
#
# - id
#   タイプ: string
#   説明: 関連付けの一意識別子（自動計算）
#   形式: <zone_id>:<vpc_id>
#   使用例: aws_route53_zone_association.example.id
#
# - owning_account
#   タイプ: string
#   説明: ホストゾーンを作成したAWSアカウントID
#   形式: 12桁の数字
#   使用例: aws_route53_zone_association.example.owning_account
#   用途: クロスアカウント構成での権限確認

################################################################################
# Import
################################################################################

# 既存のRoute53ゾーンとVPCの関連付けをインポート:
# terraform import aws_route53_zone_association.example Z1234567890ABC:vpc-12345678
#
# 形式: <zone_id>:<vpc_id>

################################################################################
# Example Usage - Complete Configuration
################################################################################

# 完全な構成例:
# プライマリVPCでホストゾーンを作成し、セカンダリVPCを追加で関連付けます

# # プライマリVPC
# resource "aws_vpc" "primary" {
#   cidr_block           = "10.6.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true
#
#   tags = {
#     Name = "primary-vpc"
#   }
# }
#
# # セカンダリVPC
# resource "aws_vpc" "secondary" {
#   cidr_block           = "10.7.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true
#
#   tags = {
#     Name = "secondary-vpc"
#   }
# }
#
# # プライベートホストゾーン（プライマリVPCで作成）
# resource "aws_route53_zone" "example" {
#   name = "example.com"
#
#   # プライマリVPCを初期関連付け
#   vpc {
#     vpc_id = aws_vpc.primary.id
#   }
#
#   # セカンダリVPCの関連付けは別リソースで管理するため、
#   # このvpcブロックの変更を無視します
#   lifecycle {
#     ignore_changes = [vpc]
#   }
#
#   tags = {
#     Name = "example.com"
#   }
# }
#
# # セカンダリVPCをプライベートホストゾーンに関連付け
# resource "aws_route53_zone_association" "secondary" {
#   zone_id = aws_route53_zone.example.zone_id
#   vpc_id  = aws_vpc.secondary.id
# }

################################################################################
# Example Usage - Cross-Region Association
################################################################################

# クロスリージョンVPC関連付けの例:
# 異なるリージョンのVPCをプライベートホストゾーンに関連付けます

# # プライマリリージョン (us-east-1) のプライベートホストゾーン
# resource "aws_route53_zone" "primary" {
#   name = "internal.example.com"
#
#   vpc {
#     vpc_id = aws_vpc.us_east_1.id
#   }
#
#   lifecycle {
#     ignore_changes = [vpc]
#   }
# }
#
# # セカンダリリージョン (us-west-2) のVPCを関連付け
# resource "aws_route53_zone_association" "us_west_2" {
#   zone_id    = aws_route53_zone.primary.zone_id
#   vpc_id     = aws_vpc.us_west_2.id
#   vpc_region = "us-west-2"
# }

################################################################################
# Example Usage - Cross-Account Association
################################################################################

# クロスアカウントVPC関連付けの例:
# 異なるAWSアカウントのVPCをプライベートホストゾーンに関連付けます
#
# 手順:
# 1. ホストゾーン所有者アカウントで aws_route53_vpc_association_authorization を作成
# 2. VPC所有者アカウントで aws_route53_zone_association を作成

# # アカウントA（ホストゾーン所有者）での設定
# resource "aws_route53_zone" "example" {
#   name = "cross-account.example.com"
#
#   vpc {
#     vpc_id = aws_vpc.account_a.id
#   }
# }
#
# # アカウントBのVPCに関連付けを承認
# resource "aws_route53_vpc_association_authorization" "example" {
#   zone_id = aws_route53_zone.example.zone_id
#   vpc_id  = "vpc-account-b-id"  # アカウントBのVPC ID
# }
#
# # アカウントB（VPC所有者）での設定
# resource "aws_route53_zone_association" "example" {
#   zone_id = "Z1234567890ABC"  # アカウントAのゾーンID
#   vpc_id  = aws_vpc.account_b.id
# }

################################################################################
# Best Practices
################################################################################

# ベストプラクティス:
#
# 1. 関連付け方法の選択:
#    - 単一VPCの場合: aws_route53_zone の vpc ブロックを使用
#    - 複数VPCの場合: このリソースを使用し、lifecycle.ignore_changes を設定
#    - クロスアカウントの場合: 必ずこのリソースと承認リソースを使用
#
# 2. VPC設定の確認:
#    - enable_dns_support = true が必須
#    - enable_dns_hostnames = true を推奨
#    - これらがfalseの場合、DNS解決が機能しません
#
# 3. タグ付け:
#    - このリソース自体にはタグ機能がありません
#    - aws_route53_zone リソースでタグを設定してください
#
# 4. セキュリティ考慮事項:
#    - プライベートホストゾーンは関連付けられたVPC内でのみ解決可能
#    - クロスアカウント関連付けには適切なIAM権限が必要
#    - 承認プロセスを経ずに他のアカウントのVPCは関連付けできません
#
# 5. モニタリング:
#    - CloudWatch Logs でDNSクエリログを有効化して監視
#    - VPC Flow Logs でネットワークトラフィックを監視
#
# 6. トラブルシューティング:
#    - DNS解決が機能しない場合、VPCのDNS設定を確認
#    - クロスアカウント関連付けの場合、承認状態を確認
#    - 関連付けが複数ある場合、ゾーンの設定を確認

################################################################################
# Additional Resources
################################################################################

# 関連リソース:
# - aws_route53_zone: プライベート/パブリックホストゾーンの作成
# - aws_route53_vpc_association_authorization: クロスアカウント関連付けの承認
# - aws_vpc: VPCの作成と設定
# - aws_route53_record: DNSレコードの管理
# - aws_route53_resolver_endpoint: Resolverエンドポイントの作成
# - aws_route53_resolver_rule: Resolver転送ルールの設定
