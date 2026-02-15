#---------------------------------------
# DSQL Cluster Peering
#---------------------------------------
# 用途: Amazon DSQLクラスター間のピアリング接続を確立
# 特徴:
#   - マルチリージョン間でのクラスターピアリング
#   - Witness Regionを使用した高可用性構成
#   - 複数のDSQLクラスターを1つのピアリンググループに統合
# ユースケース:
#   - 地理的に分散したDSQLクラスター間のデータレプリケーション
#   - 災害復旧のためのマルチリージョン構成
#   - 低レイテンシーなグローバルデータアクセス
# 補足:
#   - 少なくとも2つのクラスターが必要
#   - Witness Regionは参加クラスターとは異なるリージョンを推奨
#   - ピアリング接続の確立には数分かかる場合がある
#
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/dsql_cluster_peering
# Generated: 2026-02-14
# NOTE: このテンプレートは実際のAWSリソースを作成します。使用前に内容を確認してください。

#---------------------------------------
# Terraform設定
#---------------------------------------
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.28.0"
    }
  }
}

#---------------------------------------
# Provider設定
#---------------------------------------
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "production"
      ManagedBy   = "terraform"
      Service     = "dsql-peering"
    }
  }
}

#---------------------------------------
# DSQL Cluster Peering
#---------------------------------------

#---------------------------------------
# 基本的なピアリング構成
#---------------------------------------
resource "aws_dsql_cluster_peering" "example" {
  #---------------------------------------
  # 必須パラメータ
  #---------------------------------------

  # ピアリング識別子
  # 設定内容: ピアリンググループの一意の識別子
  # 制約事項: 英数字とハイフンのみ使用可能、最初と最後は英数字
  # 補足: ピアリンググループを識別するための名前
  identifier = "my-dsql-peering-group"

  # 参加クラスター
  # 設定内容: ピアリンググループに参加するDSQLクラスターのARNまたは識別子のセット
  # 制約事項: 最低2つのクラスターが必要
  # 補足: 各クラスターは異なるリージョンに配置可能
  clusters = [
    "arn:aws:dsql:us-east-1:123456789012:cluster/cluster-1",
    "arn:aws:dsql:us-west-2:123456789012:cluster/cluster-2",
  ]

  # Witnessリージョン
  # 設定内容: ピアリンググループのWitnessとして機能するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, eu-west-1）
  # 補足: 高可用性のため、参加クラスターとは異なるリージョンを推奨
  witness_region = "eu-west-1"

  #---------------------------------------
  # オプションパラメータ - リソース管理
  #---------------------------------------

  # 管理リージョン
  # 設定内容: このリソースが管理されるAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  # 補足: クラスターのリージョンとは独立して設定可能
  # region = "us-east-1"

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------
  timeouts {
    # 作成タイムアウト
    # 設定内容: ピアリング接続の確立タイムアウト時間
    # 設定可能な値: Go duration形式（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用される
    create = "10m"
  }
}

#---------------------------------------
# マルチリージョンピアリング構成
#---------------------------------------
resource "aws_dsql_cluster_peering" "multi_region" {
  identifier = "global-dsql-peering"

  # 3つのリージョンにまたがるクラスター
  clusters = [
    "arn:aws:dsql:us-east-1:123456789012:cluster/primary",
    "arn:aws:dsql:eu-west-1:123456789012:cluster/europe",
    "arn:aws:dsql:ap-northeast-1:123456789012:cluster/asia",
  ]

  # アジアパシフィックをWitnessリージョンに指定
  witness_region = "ap-southeast-1"

  timeouts {
    create = "15m"
  }
}

#---------------------------------------
# 災害復旧用ピアリング構成
#---------------------------------------
resource "aws_dsql_cluster_peering" "disaster_recovery" {
  identifier = "dr-dsql-peering"

  # プライマリとセカンダリクラスター
  clusters = [
    "arn:aws:dsql:us-east-1:123456789012:cluster/primary-prod",
    "arn:aws:dsql:us-west-2:123456789012:cluster/secondary-dr",
  ]

  # 中立リージョンをWitnessに指定
  witness_region = "us-central-1"

  timeouts {
    create = "20m"
  }
}

#---------------------------------------
# Outputs
#---------------------------------------

#---------------------------------------
# ピアリング情報
#---------------------------------------
output "peering_identifier" {
  description = "DSQLピアリンググループの識別子"
  value       = aws_dsql_cluster_peering.example.identifier
}

output "peering_clusters" {
  description = "ピアリンググループに参加しているクラスター"
  value       = aws_dsql_cluster_peering.example.clusters
}

output "witness_region" {
  description = "Witnessリージョン"
  value       = aws_dsql_cluster_peering.example.witness_region
}

output "multi_region_peering_id" {
  description = "マルチリージョンピアリングの識別子"
  value       = aws_dsql_cluster_peering.multi_region.identifier
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - identifier        - ピアリンググループの識別子
# - clusters          - ピアリンググループに参加しているクラスターのセット
# - witness_region    - Witnessリージョン
# - region            - リソースが管理されているリージョン
