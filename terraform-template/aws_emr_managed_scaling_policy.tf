# ==============================================================================
# aws_emr_managed_scaling_policy - EMR Managed Scaling Policy
# ==============================================================================
# Generated: 2026-01-23
# Provider Version: hashicorp/aws 6.28.0
#
# 注意: このテンプレートは生成時点の情報です。
#       最新の仕様については公式ドキュメントを確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/emr_managed_scaling_policy
# ==============================================================================
#
# 概要:
# EMRクラスターのマネージドスケーリングポリシーを提供します。
# Amazon EMR バージョン 5.30.0 以降（Amazon EMR 6.0.0を除く）では、
# EMRマネージドスケーリングを有効にすることで、ワークロードに基づいて
# クラスター内のインスタンスまたはユニットの数を自動的に増減できます。
#
# 参考: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-managed-scaling.html
#
# 重要な制約:
# - スケーリングはコアノードとタスクノードにのみ適用されます
# - マスターノードは初期構成後にスケールできません
# ==============================================================================

resource "aws_emr_managed_scaling_policy" "example" {
  # ============================================================================
  # 必須パラメータ
  # ============================================================================

  # cluster_id - EMRクラスターのID (必須)
  # EMRマネージドスケーリングポリシーを適用するクラスターのID
  # Type: string
  # 参考: https://docs.aws.amazon.com/emr/latest/APIReference/API_PutManagedScalingPolicy.html
  cluster_id = "j-xxxxxxxxxxxxx"

  # ============================================================================
  # オプションパラメータ
  # ============================================================================

  # id - リソースID (オプション, Computed)
  # Terraform管理用のリソースID
  # 通常は明示的に設定する必要はありません
  # Type: string
  # id = "example-id"

  # region - リージョン (オプション, Computed)
  # このリソースを管理するAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用されます
  # Type: string
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # scaling_strategy - スケーリング戦略 (オプション)
  # カスタムスケーリング利用パフォーマンスインデックスを設定できるかどうかを決定します
  # 有効な値: "ADVANCED" | "DEFAULT"
  # - DEFAULT: デフォルトのスケーリング動作を使用
  # - ADVANCED: utilization_performance_indexを使用した高度なスケーリングを有効化
  # Type: string
  # 参考: https://docs.aws.amazon.com/emr/latest/APIReference/API_ManagedScalingPolicy.html
  # 参考: https://aws.amazon.com/about-aws/whats-new/2024/11/introducing-advanced-scaling-amazon-emr-managed-scaling/
  # 注意: ADVANCED戦略はEMR 7.0以降で使用可能
  # scaling_strategy = "DEFAULT"

  # utilization_performance_index - 利用率パフォーマンスインデックス (オプション)
  # 高度なスケーリング戦略のための設定値
  # - 高い値（100に近い）: パフォーマンス最適化（積極的なスケーリング）
  # - 低い値（1に近い）: リソース節約最適化（控えめなスケーリング）
  # - 50: パフォーマンスとリソース節約のバランス
  # 有効な値: 1〜100の整数
  # Type: number
  # 参考: https://docs.aws.amazon.com/emr/latest/ManagementGuide/managed-scaling-allocation-strategy-optimized.html
  # 注意: scaling_strategy = "ADVANCED"の場合のみ有効
  # 推奨値:
  #   - リソース最適化: 1
  #   - バランス型: 50
  #   - パフォーマンス最適化: 100
  # utilization_performance_index = 50

  # ============================================================================
  # ネストブロック - compute_limits (必須)
  # ============================================================================
  # マネージドスケーリングポリシーのコンピュートリミット設定
  # クラスターから追加または削除できるリソースの上限と下限を設定します
  # これらの制限はコアノードとタスクノードにのみ適用されます
  # 参考: https://docs.aws.amazon.com/emr/latest/APIReference/API_ComputeLimits.html

  compute_limits {
    # ==========================================================================
    # 必須パラメータ
    # ==========================================================================

    # unit_type - ユニットタイプ (必須)
    # マネージドスケーリングポリシーで使用される単位タイプ
    # 有効な値:
    # - "InstanceFleetUnits": インスタンスフリート用の単位
    # - "Instances": インスタンスグループ用のインスタンス数
    # - "VCPU": vCPUコア数
    # Type: string
    # 参考: https://docs.aws.amazon.com/emr/latest/APIReference/API_ComputeLimits.html
    unit_type = "Instances"

    # minimum_capacity_units - 最小キャパシティユニット数 (必須)
    # EC2ユニットの下限
    # - unit_type = "Instances"の場合: インスタンス数
    # - unit_type = "VCPU"の場合: vCPUコア数
    # - unit_type = "InstanceFleetUnits"の場合: フリート単位
    # マネージドスケーリングはこの境界を下回ることはありません
    # コアノードとタスクノードにのみ適用されます
    # Type: number
    # 参考: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-managed-scaling.html
    minimum_capacity_units = 2

    # maximum_capacity_units - 最大キャパシティユニット数 (必須)
    # EC2ユニットの上限
    # - unit_type = "Instances"の場合: インスタンス数
    # - unit_type = "VCPU"の場合: vCPUコア数
    # - unit_type = "InstanceFleetUnits"の場合: フリート単位
    # マネージドスケーリングはこの境界を超えることはありません
    # コアノードとタスクノードにのみ適用されます
    # Type: number
    # 参考: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-managed-scaling.html
    maximum_capacity_units = 10

    # ==========================================================================
    # オプションパラメータ
    # ==========================================================================

    # maximum_ondemand_capacity_units - 最大オンデマンドキャパシティユニット数 (オプション)
    # オンデマンドEC2ユニットの上限
    # - unit_type = "Instances"の場合: インスタンス数
    # - unit_type = "VCPU"の場合: vCPUコア数
    # - unit_type = "InstanceFleetUnits"の場合: フリート単位
    # オンデマンドユニットはこの境界を超えてスケールできません
    # このパラメータはオンデマンドインスタンスとスポットインスタンス間の
    # キャパシティ割り当てを分割するために使用されます
    # Type: number
    # 参考: https://docs.aws.amazon.com/emr/latest/APIReference/API_ComputeLimits.html
    # maximum_ondemand_capacity_units = 2

    # maximum_core_capacity_units - 最大コアキャパシティユニット数 (オプション)
    # クラスター内のコアノードタイプのEC2ユニットの上限
    # - unit_type = "Instances"の場合: インスタンス数
    # - unit_type = "VCPU"の場合: vCPUコア数
    # - unit_type = "InstanceFleetUnits"の場合: フリート単位
    # コアユニットはこの境界を超えてスケールできません
    # このパラメータはコアノードとタスクノード間の
    # キャパシティ割り当てを分割するために使用されます
    # Type: number
    # 参考: https://docs.aws.amazon.com/emr/latest/APIReference/API_ComputeLimits.html
    # maximum_core_capacity_units = 10
  }
}

# ==============================================================================
# 使用例
# ==============================================================================
# 基本的な使用例:
#
# resource "aws_emr_cluster" "example" {
#   name          = "emr-cluster-example"
#   release_label = "emr-7.0.0"
#
#   master_instance_group {
#     instance_type = "m5.xlarge"
#   }
#
#   core_instance_group {
#     instance_type  = "m5.xlarge"
#     instance_count = 2
#   }
#   # その他の設定...
# }
#
# resource "aws_emr_managed_scaling_policy" "example" {
#   cluster_id = aws_emr_cluster.example.id
#
#   compute_limits {
#     unit_type              = "Instances"
#     minimum_capacity_units = 2
#     maximum_capacity_units = 10
#   }
# }
#
# 高度なスケーリング戦略を使用した例 (EMR 7.0以降):
#
# resource "aws_emr_managed_scaling_policy" "advanced" {
#   cluster_id                    = aws_emr_cluster.example.id
#   scaling_strategy              = "ADVANCED"
#   utilization_performance_index = 75  # パフォーマンス重視
#
#   compute_limits {
#     unit_type                       = "Instances"
#     minimum_capacity_units          = 2
#     maximum_capacity_units          = 20
#     maximum_ondemand_capacity_units = 5
#     maximum_core_capacity_units     = 10
#   }
# }
# ==============================================================================
