#!/usr/bin/env python3
import json

template_content = """#---------------------------------------------------------------
# Amazon EKS Managed Node Group
#---------------------------------------------------------------
#
# Amazon EKS managed node groupは、EKSクラスター用のワーカーノード（Amazon EC2インスタンス）
# のプロビジョニングとライフサイクル管理を自動化します。
#
# マネージドノードグループは、Amazon EKSによって管理されるAuto Scaling Groupの一部として
# プロビジョニングされ、Kubernetes Cluster Autoscalerによる自動検出のためのタグが付与されます。
# ノードの更新や終了時には自動的にドレインされ、アプリケーションの可用性が保たれます。
#
# AWS公式ドキュメント:
#   - Managed Node Groups: https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html
#   - CreateNodegroup API: https://docs.aws.amazon.com/eks/latest/APIReference/API_CreateNodegroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_eks_node_group" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # EKSクラスターの名前
  # Type: string
  cluster_name = "example-cluster"

  # ノードグループのIAMロールARN
  # EKSワーカーノードに必要な権限を提供するIAMロール
  # 必要なマネージドポリシー:
  #   - AmazonEKSWorkerNodePolicy
  #   - AmazonEKS_CNI_Policy
  #   - AmazonEC2ContainerRegistryReadOnly
  # Type: string
  node_role_arn = "arn:aws:iam::123456789012:role/eks-node-group-role"

  # ノードグループを配置するサブネットID
  # 複数のアベイラビリティゾーンにまたがるサブネットを指定することで高可用性を実現
  # Type: set(string)
  subnet_ids = ["subnet-12345678", "subnet-87654321"]

  #---------------------------------------------------------------
  # Scaling Configuration (Required Block)
  #---------------------------------------------------------------

  # スケーリング設定
  # ワーカーノードの最小、最大、希望数を定義
  scaling_config {
    # 希望するワーカーノード数
    # Type: number
    desired_size = 2

    # 最大ワーカーノード数
    # Type: number
    max_size = 4

    # 最小ワーカーノード数
    # Type: number
    min_size = 1
  }

  #---------------------------------------------------------------
  # Optional Arguments - Node Configuration
  #---------------------------------------------------------------

  # AMIタイプ
  # ノードグループに使用するAMIのタイプ
  # 有効な値: AL2_x86_64 (デフォルト), AL2_x86_64_GPU, AL2_ARM_64, CUSTOM,
  #          BOTTLEROCKET_ARM_64, BOTTLEROCKET_x86_64, BOTTLEROCKET_ARM_64_NVIDIA,
  #          BOTTLEROCKET_x86_64_NVIDIA, WINDOWS_CORE_2019_x86_64, WINDOWS_FULL_2019_x86_64,
  #          WINDOWS_CORE_2022_x86_64, WINDOWS_FULL_2022_x86_64, AL2023_x86_64_STANDARD,
  #          AL2023_ARM_64_STANDARD
  # Type: string (optional, computed)
  # ami_type = "AL2_x86_64"

  # キャパシティタイプ
  # ノードグループのキャパシティタイプ
  # 有効な値:
  #   - ON_DEMAND: オンデマンドインスタンス（デフォルト、予測可能な料金）
  #   - SPOT: スポットインスタンス（最大90%割引、ただし中断の可能性あり）
  # Type: string (optional, computed)
  # capacity_type = "ON_DEMAND"

  # ディスクサイズ
  # ワーカーノードのディスクサイズ（GiB単位）
  # デフォルト: Windowsノードは50 GiB、その他は20 GiB
  # Type: number (optional, computed)
  # disk_size = 20

  # インスタンスタイプ
  # ノードグループに使用するEC2インスタンスタイプのリスト
  # デフォルト: ["t3.medium"]
  # 複数のインスタンスタイプを指定することで、可用性の向上とコスト最適化が可能
  # Type: list(string) (optional, computed)
  # instance_types = ["t3.medium"]

  # Kubernetesラベル
  # ノードグループのノードに適用されるKubernetesラベル
  # EKS APIで適用されたラベルのみが管理対象
  # Type: map(string) (optional)
  # labels = {
  #   "environment" = "production"
  #   "team"        = "platform"
  # }

  #---------------------------------------------------------------
  # Optional Arguments - Naming
  #---------------------------------------------------------------

  # ノードグループ名
  # EKSノードグループの名前（最大63文字）
  # 省略時はTerraformがランダムな一意の名前を割り当て
  # node_group_name_prefixと競合
  # Type: string (optional, computed)
  # node_group_name = "example-node-group"

  # ノードグループ名プレフィックス
  # 指定したプレフィックスで始まる一意の名前を作成
  # node_group_nameと競合
  # Type: string (optional, computed)
  # node_group_name_prefix = "example-"

  #---------------------------------------------------------------
  # Optional Arguments - Versioning
  #---------------------------------------------------------------

  # Kubernetesバージョン
  # ノードグループのKubernetesバージョン
  # デフォルト: EKSクラスターのKubernetesバージョンに一致
  # Type: string (optional, computed)
  # version = "1.28"

  # リリースバージョン
  # EKSノードグループのAMIバージョン
  # 指定しない場合は、Kubernetesバージョンの最新バージョンがデフォルト
  # SSM Parameter Storeから最新のAMIリリースバージョンを取得可能:
  # /aws/service/eks/optimized-ami/{k8s_version}/amazon-linux-2/recommended/release_version
  # Type: string (optional, computed)
  # release_version = "1.28.3-20231211"

  # バージョン強制更新
  # Pod Disruption Budgetによりポッドがドレインできない場合でも、バージョン更新を強制
  # Type: bool (optional)
  # force_update_version = false

  #---------------------------------------------------------------
  # Optional Arguments - Region and Tags
  #---------------------------------------------------------------

  # リージョン
  # このリソースが管理されるAWSリージョン
  # デフォルト: プロバイダー設定のリージョン
  # Type: string (optional, computed)
  # region = "us-west-2"

  # タグ
  # リソースに適用するタグ
  # Type: map(string) (optional)
  # tags = {
  #   "Environment" = "production"
  #   "ManagedBy"   = "terraform"
  # }

  # tags_all
  # provider default_tagsを含む、リソースに割り当てられた全タグ
  # 通常は明示的な設定不要（providerのdefault_tagsが自動的に適用される）
  # Type: map(string) (optional, computed)
  # tags_all = {}

  #---------------------------------------------------------------
  # Optional Block - Launch Template
  #---------------------------------------------------------------

  # 起動テンプレート
  # カスタム起動テンプレートを使用してノードをデプロイ
  # より高度なカスタマイズが可能（カスタムAMI、追加のセキュリティグループ、ユーザーデータなど）
  # remote_accessと競合
  # 最大1ブロック
  # launch_template {
  #   # 起動テンプレートID
  #   # EC2起動テンプレートの識別子
  #   # nameと競合
  #   # Type: string (optional, computed)
  #   id = "lt-0123456789abcdef0"
  #
  #   # 起動テンプレート名
  #   # EC2起動テンプレートの名前
  #   # idと競合
  #   # Type: string (optional, computed)
  #   # name = "example-launch-template"
  #
  #   # バージョン
  #   # EC2起動テンプレートのバージョン番号
  #   # $Defaultや$Latestは使用可能だが、TerraformがAPIから返されたバージョン番号との差分を検出
  #   # aws_launch_templateリソースのdefault_versionまたはlatest_version属性の使用を推奨
  #   # Type: string (required)
  #   version = "$Latest"
  # }

  #---------------------------------------------------------------
  # Optional Block - Node Auto Repair Configuration
  #---------------------------------------------------------------

  # ノード自動修復設定
  # ノードの自動修復機能の設定
  # ノードの健全性を継続的に監視し、問題を検出した場合に自動的にノードを交換
  # 最大1ブロック
  # node_repair_config {
  #   # 有効化フラグ
  #   # ノード自動修復を有効にするか
  #   # デフォルト: false
  #   # Type: bool (optional)
  #   enabled = true
  #
  #   # 並列修復ノード数（カウント）
  #   # 同時に修復できる最大ノード数（絶対数）
  #   # max_parallel_nodes_repaired_percentageと競合
  #   # Type: number (optional)
  #   # max_parallel_nodes_repaired_count = 1
  #
  #   # 並列修復ノード数（パーセンテージ）
  #   # 同時に修復できる最大ノード数（不健全ノードのパーセンテージ）
  #   # max_parallel_nodes_repaired_countと競合
  #   # Type: number (optional)
  #   # max_parallel_nodes_repaired_percentage = 10
  #
  #   # 不健全ノード閾値（カウント）
  #   # この数を超える不健全ノードが検出された場合、自動修復を停止
  #   # max_unhealthy_node_threshold_percentageと競合
  #   # Type: number (optional)
  #   # max_unhealthy_node_threshold_count = 3
  #
  #   # 不健全ノード閾値（パーセンテージ）
  #   # この割合を超える不健全ノードが検出された場合、自動修復を停止
  #   # max_unhealthy_node_threshold_countと競合
  #   # Type: number (optional)
  #   # max_unhealthy_node_threshold_percentage = 30
  #
  #   # ノード修復設定のオーバーライド
  #   # 特定の修復アクションに対する詳細なオーバーライド設定
  #   # node_repair_config_overrides {
  #     # 最小修復待機時間（分）
  #     # 指定された条件でノードの修復を試みるまでの最小待機時間
  #     # Type: number (required)
  #     min_repair_wait_time_mins = 10
  #
  #     # ノード監視条件
  #     # このオーバーライドが適用される、ノード監視エージェントによって報告される不健全な条件
  #     # Type: string (required)
  #     node_monitoring_condition = "InstanceStatusCheckFailed"
  #
  #     # ノード不健全理由
  #     # このオーバーライドが適用される、ノード監視エージェントによって報告される理由
  #     # Type: string (required)
  #     node_unhealthy_reason = "SystemStatusCheckFailed"
  #
  #     # 修復アクション
  #     # すべての指定条件が満たされた場合にノードに対して実行する修復アクション
  #     # Type: string (required)
  #     repair_action = "Replace"
  #   # }
  # }

  #---------------------------------------------------------------
  # Optional Block - Remote Access
  #---------------------------------------------------------------

  # リモートアクセス設定
  # ワーカーノードへのSSHアクセスを設定
  # launch_templateと競合
  # 最大1ブロック
  # remote_access {
  #   # EC2 SSHキー
  #   # ワーカーノードへのリモート通信用のEC2キーペア名
  #   # source_security_group_idsを指定しない場合、
  #   # Windowsノードはポート3389、その他のノードはポート22がインターネット（0.0.0.0/0）に開放
  #   # Type: string (optional)
  #   ec2_ssh_key = "my-key-pair"
  #
  #   # ソースセキュリティグループID
  #   # ワーカーノードへのSSHアクセス（ポート22）を許可するEC2セキュリティグループIDのセット
  #   # ec2_ssh_keyを指定しているがこれを指定しない場合、ポート22がインターネット（0.0.0.0/0）に開放
  #   # Type: set(string) (optional)
  #   source_security_group_ids = ["sg-0123456789abcdef0"]
  # }

  #---------------------------------------------------------------
  # Optional Block - Taints
  #---------------------------------------------------------------

  # Kubernetes Taint
  # ノードグループのノードに適用するKubernetes taint
  # 最大50個
  # taint {
  #   # キー
  #   # taintのキー（最大63文字）
  #   # Type: string (required)
  #   key = "dedicated"
  #
  #   # 値
  #   # taintの値（最大63文字）
  #   # Type: string (optional)
  #   value = "gpu-workload"
  #
  #   # 効果
  #   # taintの効果
  #   # 有効な値:
  #   #   - NO_SCHEDULE: taintに一致しないポッドはスケジュールされない
  #   #   - NO_EXECUTE: taintに一致しないポッドは即座に退避される
  #   #   - PREFER_NO_SCHEDULE: taintに一致しないポッドのスケジュールを避けるが、強制はしない
  #   # Type: string (required)
  #   effect = "NO_SCHEDULE"
  # }

  #---------------------------------------------------------------
  # Optional Block - Update Configuration
  #---------------------------------------------------------------

  # 更新設定
  # ノードグループ更新時の動作を制御
  # 最大1ブロック
  # update_config {
  #   # 最大利用不可ノード数
  #   # ノードグループ更新時に同時に利用不可となる最大ワーカーノード数
  #   # max_unavailable_percentageと排他
  #   # Type: number (optional)
  #   # max_unavailable = 1
  #
  #   # 最大利用不可ノード率
  #   # ノードグループ更新時に同時に利用不可となる最大ワーカーノードのパーセンテージ
  #   # max_unavailableと排他
  #   # Type: number (optional)
  #   # max_unavailable_percentage = 33
  #
  #   # 更新戦略
  #   # ノードグループの更新に使用する戦略
  #   # 有効な値:
  #   #   - DEFAULT: ローリングアップデート（既存ノードをドレインしてから新ノードを起動）
  #   #   - MINIMAL: 最小限の中断（新ノードを先に起動してから古いノードをドレイン）
  #   # Type: string (optional)
  #   # update_strategy = "DEFAULT"
  # }

  #---------------------------------------------------------------
  # Optional Block - Timeouts
  #---------------------------------------------------------------

  # タイムアウト設定
  # 各オペレーションのタイムアウト時間
  # timeouts {
  #   # 作成タイムアウト
  #   # Type: string (optional)
  #   # create = "60m"
  #
  #   # 更新タイムアウト
  #   # Type: string (optional)
  #   # update = "60m"
  #
  #   # 削除タイムアウト
  #   # Type: string (optional)
  #   # delete = "60m"
  # }

  #---------------------------------------------------------------
  # Lifecycle Management
  #---------------------------------------------------------------

  # Auto Scalingによって変更されるdesired_sizeを無視する場合
  # lifecycle {
  #   ignore_changes = [scaling_config[0].desired_size]
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Computed Outputs)
#---------------------------------------------------------------

# 以下の属性は、リソース作成後に参照可能な読み取り専用属性です。

# arn
#   - Amazon Resource Name (ARN) of the EKS Node Group
#   - Type: string
#   - Example: arn:aws:eks:us-west-2:123456789012:nodegroup/example-cluster/example-node-group/abc12345-6789-0def-ghij-klmnopqrstuv

# id
#   - EKS Cluster name and EKS Node Group name separated by a colon (:)
#   - Type: string
#   - Example: example-cluster:example-node-group

# resources
#   - List of objects containing information about underlying resources
#   - Type: list(object)
#   - Structure:
#     - autoscaling_groups: List of objects containing information about AutoScaling Groups
#       - name: Name of the AutoScaling Group
#     - remote_access_security_group_id: Identifier of the remote access EC2 Security Group

# status
#   - Status of the EKS Node Group
#   - Type: string
#   - Possible values: CREATING, ACTIVE, UPDATING, DELETING, CREATE_FAILED, DELETE_FAILED, DEGRADED

# tags_all
#   - A map of tags assigned to the resource, including those inherited from the provider
#     default_tags configuration block
#   - Type: map(string)
"""

result = {
    "status": "success",
    "resource": "aws_eks_node_group",
    "provider_version": "6.28.0",
    "content": template_content
}

print(json.dumps(result, ensure_ascii=False, indent=2))

