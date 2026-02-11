################################################################################
# AWS Placement Group
# プレースメントグループ
#
# EC2インスタンスの配置戦略を定義するリソースです。
# クラスター、パーティション、スプレッドの3つの戦略があり、
# レイテンシ最適化、可用性向上、耐障害性向上などの用途に応じて選択できます。
#
# 主な用途:
# - HPC(High Performance Computing)環境でのクラスター戦略
# - 分散アプリケーションのパーティション戦略
# - 高可用性が求められるアプリケーションのスプレッド戦略
#
# 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/placement_group
################################################################################

resource "aws_placement_group" "example" {
  # ============================================================================
  # 必須パラメータ
  # ============================================================================

  # name - プレースメントグループの名前
  # (Required) プレースメントグループを一意に識別する名前を指定します。
  # リージョン内で一意である必要があります。
  #
  # 制約:
  # - 255文字以内
  # - 英数字、ハイフン、アンダースコアを使用可能
  #
  # 例: "my-cluster-pg", "web-app-spread-pg"
  name = "example-placement-group"

  # strategy - 配置戦略
  # (Required) インスタンスの配置方法を指定します。
  #
  # 選択肢:
  # - "cluster"  : 同一AZ内の近接した配置でネットワークレイテンシを最小化
  #                HPC、高性能データベースに最適
  # - "partition": 異なる物理ハードウェアに分散配置
  #                大規模分散システム(Hadoop、Cassandraなど)に最適
  #                最大7パーティションまで指定可能
  # - "spread"   : 各インスタンスを別々のハードウェアに配置
  #                小規模な高可用性アプリケーションに最適
  #                AZあたり最大7インスタンスまで
  #
  # 注意: 作成後の変更は不可。新規作成が必要です。
  strategy = "cluster"

  # ============================================================================
  # オプションパラメータ
  # ============================================================================

  # partition_count - パーティション数
  # (Optional) パーティション戦略使用時のパーティション数を指定します。
  # strategyが"partition"の場合のみ有効です。
  #
  # 制約:
  # - 1〜7の範囲で指定
  # - デフォルト値: 2
  # - パーティション数が多いほど障害の影響を分散できる
  #
  # 使用例:
  # partition_count = 3  # 3つのパーティションに分散配置
  # partition_count = null

  # spread_level - スプレッドレベル
  # (Optional) スプレッド戦略の配置レベルを指定します。
  # strategyが"spread"の場合のみ有効です。
  #
  # 選択肢:
  # - "rack" : ラックレベルでスプレッド(デフォルト)
  #            通常のEC2インスタンスで使用
  # - "host" : ホストレベルでスプレッド
  #            AWS Outpost環境でのみ使用可能
  #
  # デフォルト: "rack"
  #
  # 使用例:
  # spread_level = "rack"
  # spread_level = null

  # region - リージョン指定
  # (Optional) このリソースを管理するAWSリージョンを明示的に指定します。
  # 通常はプロバイダー設定のリージョンが使用されます。
  #
  # 使用例:
  # region = "ap-northeast-1"  # 東京リージョン
  # region = "us-east-1"        # バージニア北部リージョン
  # region = null

  # tags - リソースタグ
  # (Optional) プレースメントグループに付与するタグを指定します。
  # リソース管理、コスト配分、検索などに使用できます。
  #
  # ベストプラクティス:
  # - 環境(Environment)、プロジェクト(Project)、所有者(Owner)などのタグを推奨
  # - コスト配分のためのタグを含める
  # - 命名規則を統一する
  #
  # 使用例:
  # tags = {
  #   Name        = "example-placement-group"
  #   Environment = "production"
  #   Application = "web-app"
  #   ManagedBy   = "terraform"
  # }
  tags = {
    Name = "example-placement-group"
  }
}

################################################################################
# 出力値(Outputs)
################################################################################

# arn - プレースメントグループのARN
# Amazon Resource Name。IAMポリシーでの参照などに使用します。
# 形式: arn:aws:ec2:region:account-id:placement-group/placement-group-name
output "placement_group_arn" {
  description = "プレースメントグループのARN"
  value       = aws_placement_group.example.arn
}

# id - プレースメントグループの名前
# Terraform上での識別子として使用されます。
# プレースメントグループの場合、名前と同じ値になります。
output "placement_group_id" {
  description = "プレースメントグループのID(名前)"
  value       = aws_placement_group.example.id
}

# placement_group_id - プレースメントグループID
# AWS APIが返す実際のプレースメントグループIDです。
# EC2インスタンスの起動時にこのIDを参照します。
output "placement_group_group_id" {
  description = "プレースメントグループの実際のID"
  value       = aws_placement_group.example.placement_group_id
}

# tags_all - 全タグ
# リソースに適用されているすべてのタグを表示します。
# プロバイダーのdefault_tagsで設定したタグも含まれます。
output "placement_group_tags_all" {
  description = "プレースメントグループに適用されている全てのタグ"
  value       = aws_placement_group.example.tags_all
}

################################################################################
# 使用例とベストプラクティス
################################################################################

# --- 例1: クラスター戦略(HPC用途) ---
# resource "aws_placement_group" "hpc_cluster" {
#   name     = "hpc-compute-cluster"
#   strategy = "cluster"
#
#   tags = {
#     Name        = "HPC Cluster Placement Group"
#     Environment = "production"
#     Workload    = "HPC"
#   }
# }

# --- 例2: パーティション戦略(分散システム用途) ---
# resource "aws_placement_group" "distributed_system" {
#   name            = "hadoop-partition-pg"
#   strategy        = "partition"
#   partition_count = 7  # 最大値
#
#   tags = {
#     Name        = "Hadoop Partition Placement Group"
#     Environment = "production"
#     Application = "hadoop-cluster"
#   }
# }

# --- 例3: スプレッド戦略(高可用性用途) ---
# resource "aws_placement_group" "high_availability" {
#   name         = "web-app-spread-pg"
#   strategy     = "spread"
#   spread_level = "rack"
#
#   tags = {
#     Name        = "Web App Spread Placement Group"
#     Environment = "production"
#     Tier        = "web"
#   }
# }

# --- EC2インスタンスでの使用例 ---
# resource "aws_instance" "cluster_instance" {
#   ami               = "ami-xxxxx"
#   instance_type     = "c5.large"
#   placement_group   = aws_placement_group.example.id
#
#   # クラスター戦略の場合は同じAZに配置する必要がある
#   availability_zone = "ap-northeast-1a"
#
#   tags = {
#     Name = "Cluster Instance"
#   }
# }

################################################################################
# 注意事項
################################################################################

# 1. 戦略の選択について:
#    - cluster: 10Gbpsの低レイテンシネットワークが必要な場合に使用
#    - partition: 大規模分散処理(7パーティション×数百インスタンス)に適用
#    - spread: 小規模(AZあたり最大7インスタンス)で高可用性が必要な場合
#
# 2. インスタンスタイプ制約:
#    - cluster戦略: Enhanced Networkingをサポートするインスタンスタイプ推奨
#    - spread戦略: 専用ホスト(Dedicated Host)は使用不可
#
# 3. 配置制約:
#    - cluster戦略: 全インスタンスを同一AZに配置する必要がある
#    - spread戦略: AZあたり最大7インスタンスまで
#    - partition戦略: パーティションあたりのインスタンス数に制限なし
#
# 4. 変更とライフサイクル:
#    - 作成後のstrategy変更は不可(新規作成が必要)
#    - プレースメントグループは空の状態でなければ削除不可
#    - インスタンスを停止してから削除する必要がある
#
# 5. リージョン制約:
#    - 一部の古いリージョンでは特定の戦略がサポートされない場合がある
#    - Outpost環境でのhost spread_levelはOutpostでのみ有効
#
# 6. コスト:
#    - プレースメントグループ自体に追加料金はかかりません
#    - インスタンスの料金は通常通り発生します
#
# 7. パフォーマンス:
#    - cluster戦略では最大10Gbpsのネットワーク帯域幅が利用可能
#    - Enhanced Networkingを有効化することでさらなる性能向上が可能
#
# 8. 容量計画:
#    - cluster戦略では全インスタンスを一度に起動することを推奨
#    - キャパシティ予約と組み合わせることで確実な起動を保証
#    - 一つのリクエストで複数インスタンスを起動することを推奨
