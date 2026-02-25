#-------
# AWS EKS Node Group - Amazon EKS管理ノードグループ
#-------
# 説明:
#   Amazon EKSクラスターにKubernetesワーカーノードを提供するマネージド
#   ノードグループを作成・管理します。Auto Scalingグループを自動プロビジョニング
#   し、EKSと互換性のあるワーカーノードを構成します。
#
# 用途:
#   - EKSクラスターへのマネージドワーカーノードの追加
#   - Kubernetesワークロード実行のためのEC2インスタンスグループ管理
#   - オートスケーリング設定によるノード数の動的管理
#   - ノードのライフサイクル管理とバージョンアップグレード
#
# 公式ドキュメント:
#   https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/eks_node_group
#   https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html
#
# 重要な考慮事項:
#   - ノードグループの削除時は、実行中のPodへの影響を考慮すること
#   - スケーリング設定変更時は、ワークロードの可用性を維持すること
#   - AMIタイプとインスタンスタイプの組み合わせに互換性があることを確認
#   - ノードロールには必要なIAMポリシーをアタッチすること
#   - launch_templateとremote_accessは同時に使用できない
#   - 最大50個までのtaintを設定可能
#
# このテンプレートのバージョン:
#   AWS Provider Version: 6.28.0
#   最終更新日: 2026-02-17
#
# Generated: 2026-02-17
# NOTE: このテンプレートは自動生成されたものです。実際の使用時は適切な値に置き換えてください。
#-------

#-------
# 基本設定
#-------

resource "aws_eks_node_group" "example" {
  # 設定内容: EKSクラスター名
  # 設定可能な値: 既存のEKSクラスターの名前
  # 省略時: 必須パラメータ（設定必須）
  cluster_name = "my-eks-cluster"

  # 設定内容: ノードグループ名（63文字以内、英数字・ハイフン・アンダースコア使用可）
  # 設定可能な値: 任意の文字列（先頭は英字または数字）
  # 省略時: Terraformがランダムな一意の名前を自動生成
  # 注意: node_group_name_prefixと同時使用不可
  node_group_name = "my-node-group"

  # 設定内容: ノードグループ名のプレフィックス
  # 設定可能な値: 任意の文字列（この値から始まる一意の名前が生成される）
  # 省略時: プレフィックスなしで名前が生成される
  # 注意: node_group_nameと同時使用不可
  node_group_name_prefix = "my-node-group-"

  # 設定内容: ノードグループに権限を付与するIAMロールのARN
  # 設定可能な値: IAMロールのARN（AmazonEKSWorkerNodePolicy等のポリシーが必要）
  # 省略時: 必須パラメータ（設定必須）
  node_role_arn = "arn:aws:iam::123456789012:role/eks-node-group-role"

  # 設定内容: ノードグループを配置するサブネットのID一覧
  # 設定可能な値: EC2サブネットIDのセット
  # 省略時: 必須パラメータ（設定必須）
  subnet_ids = [
    "subnet-12345678",
    "subnet-87654321",
  ]

  #-------
  # ノード設定
  #-------

  # 設定内容: ノードに使用するAMIタイプ
  # 設定可能な値: AL2_x86_64 / AL2_x86_64_GPU / AL2_ARM_64 / AL2023_x86_64_STANDARD / AL2023_ARM_64_STANDARD / CUSTOM / BOTTLEROCKET_ARM_64 / BOTTLEROCKET_x86_64 / BOTTLEROCKET_ARM_64_NVIDIA / BOTTLEROCKET_x86_64_NVIDIA / WINDOWS_CORE_2019_x86_64 / WINDOWS_FULL_2019_x86_64 / WINDOWS_CORE_2022_x86_64 / WINDOWS_FULL_2022_x86_64
  # 省略時: EKSがデフォルトのAMIタイプを選択（ドリフト検出は設定時のみ）
  ami_type = "AL2023_x86_64_STANDARD"

  # 設定内容: ノードのキャパシティタイプ
  # 設定可能な値: ON_DEMAND（オンデマンドインスタンス） / SPOT（スポットインスタンス）
  # 省略時: ON_DEMANDが使用される（ドリフト検出は設定時のみ）
  capacity_type = "ON_DEMAND"

  # 設定内容: ワーカーノードのディスクサイズ（GiB単位）
  # 設定可能な値: 正の整数
  # 省略時: Windowsノードは50GB、それ以外は20GB（ドリフト検出は設定時のみ）
  disk_size = 20

  # 設定内容: ノードグループに関連付けるインスタンスタイプ一覧
  # 設定可能な値: EC2インスタンスタイプのリスト（例: t3.medium、m5.large）
  # 省略時: ["t3.medium"]が使用される（ドリフト検出は設定時のみ）
  instance_types = ["t3.medium"]

  #-------
  # バージョン管理
  #-------

  # 設定内容: Kubernetesバージョン
  # 設定可能な値: Kubernetesバージョン番号（例: "1.31"）
  # 省略時: EKSクラスターのKubernetesバージョンを使用（ドリフト検出は設定時のみ）
  version = "1.31"

  # 設定内容: AMIのリリースバージョン
  # 設定可能な値: EKS最適化AMIのリリースバージョン
  # 省略時: 指定したKubernetesバージョンの最新AMIバージョンを使用
  release_version = "1.31.0-20240125"

  # 設定内容: Podの排出が失敗した場合に強制的にバージョンアップデートを実行
  # 設定可能な値: true / false
  # 省略時: false（Podが正常に排出できない場合はアップデート失敗）
  force_update_version = false

  #-------
  # ラベルとTaint
  #-------

  # 設定内容: ノードに適用するKubernetesラベル
  # 設定可能な値: キーと値のマップ
  # 省略時: ラベルは適用されない
  # 注意: EKS APIで適用したラベルのみが管理対象
  labels = {
    Environment = "production"
    Team        = "platform"
  }

  # 設定内容: リソースに適用するタグ
  # 設定可能な値: キーと値のマップ
  # 省略時: タグは適用されない
  # 注意: プロバイダーのdefault_tagsと重複するキーは上書きされる
  tags = {
    Name        = "my-node-group"
    Environment = "production"
  }

  #-------
  # リージョン設定
  #-------

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1、ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "ap-northeast-1"

  #-------
  # スケーリング設定（必須ブロック）
  #-------

  scaling_config {
    # 設定内容: 希望するワーカーノード数
    # 設定可能な値: min_size以上、max_size以下の整数
    # 省略時: 必須パラメータ（設定必須）
    desired_size = 2

    # 設定内容: 最大ワーカーノード数
    # 設定可能な値: min_size以上の整数
    # 省略時: 必須パラメータ（設定必須）
    max_size = 3

    # 設定内容: 最小ワーカーノード数
    # 設定可能な値: 0以上、max_size以下の整数
    # 省略時: 必須パラメータ（設定必須）
    min_size = 1
  }

  #-------
  # 起動テンプレート設定
  #-------
  # 注意: remote_accessブロックと同時使用不可

  # launch_template {
  #   # 設定内容: 起動テンプレートのID
  #   # 設定可能な値: EC2起動テンプレートのID
  #   # 省略時: 自動的に計算される
  #   # 注意: nameと同時使用不可
  #   # id = "lt-1234567890abcdef0"
  #
  #   # 設定内容: 起動テンプレートの名前
  #   # 設定可能な値: EC2起動テンプレートの名前
  #   # 省略時: 自動的に計算される
  #   # 注意: idと同時使用不可
  #   # name = "my-launch-template"
  #
  #   # 設定内容: 起動テンプレートのバージョン番号
  #   # 設定可能な値: バージョン番号（整数）
  #   # 省略時: 必須パラメータ（設定必須）
  #   # 注意: aws_launch_templateのdefault_versionまたはlatest_version属性の使用を推奨
  #   version = "1"
  # }

  #-------
  # リモートアクセス設定
  #-------
  # 注意: launch_templateブロックと同時使用不可

  # remote_access {
  #   # 設定内容: ワーカーノードへのリモートアクセスに使用するEC2キーペア名
  #   # 設定可能な値: EC2キーペア名
  #   # 省略時: リモートアクセスは設定されない
  #   # 注意: source_security_group_idsを指定しない場合、Windowsノードではポート3389、その他のOSではポート22がインターネットに公開される
  #   # ec2_ssh_key = "my-key-pair"
  #
  #   # 設定内容: SSHアクセスを許可するセキュリティグループIDのセット
  #   # 設定可能な値: EC2セキュリティグループIDのセット
  #   # 省略時: ec2_ssh_keyを指定した場合、ポート22がインターネットに公開される
  #   # source_security_group_ids = ["sg-12345678"]
  # }

  #-------
  # アップデート設定
  #-------

  # update_config {
  #   # 設定内容: ノードグループアップデート中に許容される最大使用不可ノード数
  #   # 設定可能な値: 正の整数
  #   # 省略時: 使用不可ノード数の制限なし
  #   # 注意: max_unavailable_percentageと同時使用不可
  #   # max_unavailable = 1
  #
  #   # 設定内容: ノードグループアップデート中に許容される最大使用不可ノード割合
  #   # 設定可能な値: 1〜100の整数（パーセント）
  #   # 省略時: 使用不可ノード割合の制限なし
  #   # 注意: max_unavailableと同時使用不可
  #   # max_unavailable_percentage = 33
  #
  #   # 設定内容: ノードグループの更新戦略
  #   # 設定可能な値: MINIMAL（最小限の中断）/ DEFAULT（標準の更新）
  #   # 省略時: DEFAULTが使用される
  #   # update_strategy = "DEFAULT"
  # }

  #-------
  # Taint設定（最大50個）
  #-------

  # taint {
  #   # 設定内容: Taintのキー
  #   # 設定可能な値: 最大63文字の文字列
  #   # 省略時: 必須パラメータ（設定必須）
  #   key = "dedicated"
  #
  #   # 設定内容: Taintの値
  #   # 設定可能な値: 最大63文字の文字列
  #   # 省略時: 値なし（キーのみのTaint）
  #   value = "gpu-workload"
  #
  #   # 設定内容: Taintの効果
  #   # 設定可能な値: NO_SCHEDULE（スケジュール不可）/ NO_EXECUTE（実行不可、既存Podも排出）/ PREFER_NO_SCHEDULE（可能な限りスケジュール回避）
  #   # 省略時: 必須パラメータ（設定必須）
  #   effect = "NO_SCHEDULE"
  # }

  #-------
  # ノード自動修復設定
  #-------

  # node_repair_config {
  #   # 設定内容: ノード自動修復の有効化
  #   # 設定可能な値: true / false
  #   # 省略時: false（自動修復は無効）
  #   # enabled = true
  #
  #   # 設定内容: 同時に修復可能な最大ノード数（実数値）
  #   # 設定可能な値: 正の整数
  #   # 省略時: 制限なし
  #   # 注意: max_parallel_nodes_repaired_percentageと同時使用不可
  #   # max_parallel_nodes_repaired_count = 2
  #
  #   # 設定内容: 同時に修復可能な最大ノード数（パーセンテージ）
  #   # 設定可能な値: 1〜100の整数
  #   # 省略時: 制限なし
  #   # 注意: max_parallel_nodes_repaired_countと同時使用不可
  #   # max_parallel_nodes_repaired_percentage = 20
  #
  #   # 設定内容: 自動修復を停止する異常ノード数の閾値（実数値）
  #   # 設定可能な値: 正の整数
  #   # 省略時: 制限なし
  #   # 注意: max_unhealthy_node_threshold_percentageと同時使用不可
  #   # max_unhealthy_node_threshold_count = 5
  #
  #   # 設定内容: 自動修復を停止する異常ノード割合の閾値（パーセンテージ）
  #   # 設定可能な値: 1〜100の整数
  #   # 省略時: 制限なし
  #   # 注意: max_unhealthy_node_threshold_countと同時使用不可
  #   # max_unhealthy_node_threshold_percentage = 50
  #
  #   # node_repair_config_overrides {
  #     # 設定内容: 修復を試行する前の最小待機時間（分単位）
  #     # 設定可能な値: 正の整数
  #     # 省略時: 必須パラメータ（設定必須）
  #     min_repair_wait_time_mins = 30
  #
  #     # 設定内容: この上書き設定が適用されるノード監視条件
  #     # 設定可能な値: ノード監視エージェントが報告する条件
  #     # 省略時: 必須パラメータ（設定必須）
  #     node_monitoring_condition = "NODE_CONDITION_READY"
  #
  #     # 設定内容: この上書き設定が適用されるノードの異常理由
  #     # 設定可能な値: ノード監視エージェントが報告する理由
  #     # 省略時: 必須パラメータ（設定必須）
  #     node_unhealthy_reason = "EC2_HEALTH_ISSUE"
  #
  #     # 設定内容: 条件が満たされた場合に実行する修復アクション
  #     # 設定可能な値: EKS APIで定義された修復アクション
  #     # 省略時: 必須パラメータ（設定必須）
  #     repair_action = "REPLACE"
  #   # }
  # }

  #-------
  # タイムアウト設定
  #-------

  # timeouts {
  #   # 設定内容: 作成操作のタイムアウト時間
  #   # 設定可能な値: 時間文字列（例: "60m"、"2h"）
  #   # 省略時: デフォルトのタイムアウト値を使用
  #   # create = "60m"
  #
  #   # 設定内容: 更新操作のタイムアウト時間
  #   # 設定可能な値: 時間文字列（例: "60m"、"2h"）
  #   # 省略時: デフォルトのタイムアウト値を使用
  #   # update = "60m"
  #
  #   # 設定内容: 削除操作のタイムアウト時間
  #   # 設定可能な値: 時間文字列（例: "60m"、"2h"）
  #   # 省略時: デフォルトのタイムアウト値を使用
  #   # delete = "60m"
  # }
}

#-------
# Attributes Reference（参照可能な属性）
#-------
# このリソース作成後に参照可能な属性:
#
# - arn
#   EKSノードグループのARN
#
# - id
#   EKSクラスター名とノードグループ名をコロン（:）で区切った文字列
#
# - status
#   EKSノードグループのステータス
#
# - resources
#   基盤となるリソースの情報を含むオブジェクトのリスト
#   - autoscaling_groups: Auto Scalingグループの情報を含むオブジェクトのリスト
#     - name: Auto Scalingグループの名前
#   - remote_access_security_group_id: リモートアクセス用EC2セキュリティグループID
#
# - tags_all
#   プロバイダーのdefault_tagsから継承されたタグを含む、リソースに割り当てられたすべてのタグのマップ
#
#-------
