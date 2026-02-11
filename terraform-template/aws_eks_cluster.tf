#---------------------------------------------------------------
# AWS EKS Cluster
#---------------------------------------------------------------
#
# Amazon Elastic Kubernetes Service (EKS) のクラスターをプロビジョニングする
# リソースです。EKSは、AWSでKubernetesを実行するためのマネージドサービスで、
# コントロールプレーンの管理を自動化し、高可用性を提供します。
#
# 主な機能:
#   - マネージドKubernetesコントロールプレーン
#   - AWS統合（IAM、VPC、CloudWatch等）
#   - EKS Auto Mode、Hybrid Nodes、Outpost対応
#   - マルチAZ配置による高可用性
#
# AWS公式ドキュメント:
#   - EKS概要: https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html
#   - クラスターVPC要件: https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
#   - クラスターセキュリティグループ: https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html
#   - EKS Auto Mode: https://docs.aws.amazon.com/eks/latest/userguide/auto-mode.html
#   - EKS Hybrid Nodes: https://docs.aws.amazon.com/eks/latest/userguide/eks-hybrid-nodes.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_eks_cluster" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: クラスター名を指定します。
  # 設定可能な値: 1-100文字の英数字、ダッシュ、アンダースコア
  #   - 英数字で始まる必要があります
  #   - 正規表現: ^[0-9A-Za-z][A-Za-z0-9\-_]*$
  # 注意: 作成後の変更はリソースの再作成を伴います。
  name = "my-eks-cluster"

  # role_arn (Required)
  # 設定内容: Kubernetesコントロールプレーンに必要なIAMロールのARNを指定します。
  # 設定可能な値: IAMロールのARN
  # 注意: EKSがECインフラストラクチャ（セキュリティグループ等）を削除できるよう、
  #       depends_onで明示的な依存関係を設定することを推奨します。
  # 参考: https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html
  role_arn = aws_iam_role.cluster.arn

  #-------------------------------------------------------------
  # VPC設定（必須）
  #-------------------------------------------------------------

  # vpc_config (Required)
  # 設定内容: クラスターに関連付けるVPC設定を指定します。
  # 関連機能: EKS VPC要件とセキュリティグループ要件
  #   - https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
  #   - https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html
  vpc_config {
    # subnet_ids (Required)
    # 設定内容: クラスターのサブネットIDリストを指定します。
    # 設定可能な値: 最低2つの異なるアベイラビリティゾーンのサブネットID
    # 注意: EKSはこれらのサブネットにクロスアカウントENIを作成し、
    #       ワーカーノードとコントロールプレーン間の通信を可能にします。
    subnet_ids = [
      aws_subnet.private_1.id,
      aws_subnet.private_2.id,
    ]

    # endpoint_private_access (Optional)
    # 設定内容: プライベートAPIサーバーエンドポイントを有効化するかを指定します。
    # 設定可能な値:
    #   - true: VPC内からのみアクセス可能
    #   - false (デフォルト): プライベートアクセス無効
    # 用途: VPC内のワーカーノードからの安全なアクセスを提供
    endpoint_private_access = true

    # endpoint_public_access (Optional)
    # 設定内容: パブリックAPIサーバーエンドポイントを有効化するかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): インターネットからアクセス可能
    #   - false: パブリックアクセス無効
    # 用途: kubectl等のCLIツールからのアクセスに使用
    endpoint_public_access = true

    # public_access_cidrs (Optional, Computed)
    # 設定内容: パブリックAPIサーバーエンドポイントにアクセス可能なCIDRブロックを指定します。
    # 設定可能な値: CIDRブロックのリスト
    # デフォルト: ["0.0.0.0/0"]（全てのIPアドレスからアクセス可能）
    # 注意: Terraformは設定ファイルに記載がある場合のみドリフト検出を実行します。
    public_access_cidrs = ["0.0.0.0/0"]

    # security_group_ids (Optional)
    # 設定内容: クロスアカウントENIに適用する追加のセキュリティグループIDを指定します。
    # 設定可能な値: セキュリティグループIDのリスト
    # 用途: ワーカーノードとKubernetesコントロールプレーン間の通信制御
    # security_group_ids = [aws_security_group.cluster.id]

    # cluster_security_group_id (Computed)
    # 説明: EKSが自動作成するクラスターセキュリティグループのID
    # 用途: マネージドノードグループはこのセキュリティグループを使用して
    #       コントロールプレーンとデータプレーン間の通信を行います。

    # vpc_id (Computed)
    # 説明: クラスターに関連付けられたVPCのID
  }

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # version (Optional, Computed)
  # 設定内容: Kubernetesのバージョンを指定します。
  # 設定可能な値: サポートされているKubernetesバージョン（例: "1.31", "1.30"）
  # 省略時: リソース作成時の最新バージョン
  # 注意:
  #   - バージョンアップグレードはこの値を増加させることで実行可能
  #   - ダウングレードはEKSでサポートされていません
  #   - 自動アップグレードは発生しません
  # 参考: https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html
  version = "1.31"

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  # deletion_protection (Optional, Computed)
  # 設定内容: クラスターの削除保護を有効化するかを指定します。
  # 設定可能な値:
  #   - true: 削除保護を無効化するまでクラスターを削除不可
  #   - false (デフォルト): 削除保護無効
  # 用途: 本番環境のクラスターを誤削除から保護
  deletion_protection = false

  # bootstrap_self_managed_addons (Optional)
  # 設定内容: デフォルトの非マネージドアドオン（aws-cni、kube-proxy、CoreDNS）を
  #           クラスター作成時にインストールするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): アドオンを自動インストール
  #   - false: 手動でアドオンをインストール（EKS Auto Mode時に推奨）
  # 注意: 作成後の変更はリソースの再作成を伴います。
  bootstrap_self_managed_addons = true

  # force_update_version (Optional)
  # 設定内容: クラスターバージョン更新時にアップグレードブロック準備完了チェックを
  #           上書きするかを指定します。
  # 設定可能な値:
  #   - true: 準備完了チェックを無視して強制アップグレード
  #   - false (デフォルト): 通常のアップグレードプロセス
  # 用途: 準備完了チェックでブロックされている場合の回避策
  force_update_version = false

  #-------------------------------------------------------------
  # アクセス設定
  #-------------------------------------------------------------

  # access_config (Optional)
  # 設定内容: クラスターのアクセスエントリ設定を指定します。
  # 関連機能: Amazon EKS Access Entries
  #   - https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html
  access_config {
    # authentication_mode (Optional, Computed)
    # 設定内容: クラスターの認証モードを指定します。
    # 設定可能な値:
    #   - CONFIG_MAP: aws-authConfigMapのみ使用（レガシー）
    #   - API: EKS Access APIのみ使用（推奨）
    #   - API_AND_CONFIG_MAP: 両方を使用（移行期用）
    # 用途: IAMプリンシパルのKubernetes RBAC認証方法を制御
    authentication_mode = "API_AND_CONFIG_MAP"

    # bootstrap_cluster_creator_admin_permissions (Optional)
    # 設定内容: クラスター作成者に管理者権限を自動付与するかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): 作成者に自動的に管理者権限を付与
    #   - false: 手動でアクセス設定が必要
    # 注意: falseの場合、クラスター作成後に手動でアクセス権限を設定する必要があります。
    bootstrap_cluster_creator_admin_permissions = true
  }

  #-------------------------------------------------------------
  # ロギング設定
  #-------------------------------------------------------------

  # enabled_cluster_log_types (Optional)
  # 設定内容: 有効化するコントロールプレーンログの種類を指定します。
  # 設定可能な値:
  #   - api: Kubernetes APIサーバーログ
  #   - audit: Kubernetes監査ログ
  #   - authenticator: 認証ログ
  #   - controllerManager: コントローラーマネージャーログ
  #   - scheduler: スケジューラーログ
  # 参考: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  # 注意: CloudWatch Logsに送信され、ログ保存料金が発生します。
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
  ]

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_config (Optional)
  # 設定内容: クラスターのシークレット暗号化設定を指定します。
  # 関連機能: Kubernetes Secrets暗号化
  #   - https://docs.aws.amazon.com/eks/latest/userguide/enable-kms.html
  # 注意: 作成後の変更はリソースの再作成を伴います。
  encryption_config {
    # resources (Required)
    # 設定内容: 暗号化するリソースの種類を指定します。
    # 設定可能な値: ["secrets"]
    # 注意: 現在、Kubernetes Secretsのみが暗号化対象です。
    resources = ["secrets"]

    # provider (Required)
    # 設定内容: 暗号化に使用するKMSキーの設定を指定します。
    provider {
      # key_arn (Required)
      # 設定内容: 使用するKMS CMKのARNを指定します。
      # 設定可能な値: KMSキーのARN
      # 注意:
      #   - CMKは対称鍵である必要があります
      #   - クラスターと同じリージョンに作成する必要があります
      #   - 異なるアカウントのCMKを使用する場合、適切な権限設定が必要
      # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-modifying-external-accounts.html
      key_arn = aws_kms_key.eks.arn
    }
  }

  #-------------------------------------------------------------
  # Kubernetesネットワーク設定
  #-------------------------------------------------------------

  # kubernetes_network_config (Optional)
  # 設定内容: Kubernetesのネットワーク設定を指定します。
  # 注意: 削除された場合、設定値が指定されていればドリフト検出のみ実行されます。
  kubernetes_network_config {
    # ip_family (Optional, Computed)
    # 設定内容: KubernetesのPodとServiceに割り当てるIPファミリーを指定します。
    # 設定可能な値:
    #   - ipv4 (デフォルト): IPv4アドレスを使用
    #   - ipv6: IPv6アドレスを使用
    # 注意: 作成後の変更はリソースの再作成を伴います。
    ip_family = "ipv4"

    # service_ipv4_cidr (Optional, Computed)
    # 設定内容: KubernetesのPodとServiceに割り当てるIPv4 CIDRブロックを指定します。
    # 設定可能な値: プライベートIPアドレスブロック（/24 ~ /12）
    #   - 10.0.0.0/8、172.16.0.0/12、192.168.0.0/16のいずれか内
    #   - VPCのCIDRブロックと重複しない範囲
    # デフォルト: 10.100.0.0/16 または 172.20.0.0/16
    # 注意: 作成後の変更はリソースの再作成を伴います。
    # service_ipv4_cidr = "10.100.0.0/16"

    # service_ipv6_cidr (Computed)
    # 説明: ip_familyにipv6を指定した場合に割り当てられるIPv6 CIDRブロック
    # 注意: IPv6の場合、カスタムCIDRブロックは指定できません（fc00::/7から自動割当）

    # elastic_load_balancing (Optional)
    # 設定内容: EKS Auto Modeのロードバランシング機能の設定を指定します。
    # 関連機能: EKS Auto Modeロードバランシング
    elastic_load_balancing {
      # enabled (Optional, Computed)
      # 設定内容: ロードバランシング機能を有効化するかを指定します。
      # 設定可能な値:
      #   - true: EKS Auto ModeがAWSアカウント内のロードバランサーを作成・削除
      #   - false: ロードバランシング機能無効
      # 用途: EKS Auto Mode使用時の自動ロードバランサー管理
      enabled = false
    }
  }

  #-------------------------------------------------------------
  # コントロールプレーンスケーリング設定
  #-------------------------------------------------------------

  # control_plane_scaling_config (Optional)
  # 設定内容: コントロールプレーンのスケーリングティア設定を指定します。
  # 関連機能: EKS Provisioned Control Plane
  #   - https://docs.aws.amazon.com/eks/latest/userguide/eks-provisioned-control-plane-getting-started.html
  # control_plane_scaling_config {
  #   # tier (Optional, Computed)
  #   # 設定内容: コントロールプレーンのスケーリングティアを指定します。
  #   # 設定可能な値:
  #   #   - standard (デフォルト): 標準ティア
  #   #   - tier-xl: XLティア
  #   #   - tier-2xl: 2XLティア
  #   #   - tier-4xl: 4XLティア
  #   # 用途: クラスターのノード数に応じて適切なティアを選択
  #   tier = "standard"
  # }

  #-------------------------------------------------------------
  # コンピュート設定（EKS Auto Mode）
  #-------------------------------------------------------------

  # compute_config (Optional)
  # 設定内容: EKS Auto Modeのコンピュート設定を指定します。
  # 関連機能: EKS Auto Mode
  #   - https://docs.aws.amazon.com/eks/latest/userguide/auto-mode.html
  # compute_config {
  #   # enabled (Optional, Computed)
  #   # 設定内容: コンピュート機能を有効化するかを指定します。
  #   # 設定可能な値:
  #   #   - true: EKS Auto ModeがEC2インスタンスを自動作成・削除
  #   #   - false: コンピュート機能無効
  #   # 用途: ワーカーノードの自動管理
  #   enabled = true
  #
  #   # node_pools (Optional)
  #   # 設定内容: コンピュートリソースを定義するノードプールを指定します。
  #   # 設定可能な値:
  #   #   - general-purpose: 汎用ワークロード用
  #   #   - system: システムワークロード用
  #   # 用途: クラスターのコンピュートリソース構成を定義
  #   node_pools = ["general-purpose", "system"]
  #
  #   # node_role_arn (Optional)
  #   # 設定内容: EC2マネージドインスタンスに割り当てるIAMロールのARNを指定します。
  #   # 設定可能な値: IAMロールのARN
  #   # 注意: コンピュート機能有効化後は変更できません。
  #   # 参考: AmazonEKSWorkerNodeMinimalPolicy、AmazonEC2ContainerRegistryPullOnlyが必要
  #   node_role_arn = aws_iam_role.node.arn
  # }

  #-------------------------------------------------------------
  # ストレージ設定（EKS Auto Mode）
  #-------------------------------------------------------------

  # storage_config (Optional)
  # 設定内容: EKS Auto Modeのストレージ設定を指定します。
  # storage_config {
  #   # block_storage (Optional)
  #   # 設定内容: ブロックストレージの設定を指定します。
  #   block_storage {
  #     # enabled (Optional, Computed)
  #     # 設定内容: ブロックストレージ機能を有効化するかを指定します。
  #     # 設定可能な値:
  #     #   - true: EKS Auto ModeがEBSボリュームを自動作成・削除
  #     #   - false: ブロックストレージ機能無効
  #     # 用途: 永続ボリュームの自動管理
  #     enabled = true
  #   }
  # }

  #-------------------------------------------------------------
  # リモートネットワーク設定（EKS Hybrid Nodes）
  #-------------------------------------------------------------

  # remote_network_config (Optional)
  # 設定内容: EKS Hybrid Nodesのリモートネットワーク設定を指定します。
  # 関連機能: EKS Hybrid Nodes
  #   - https://docs.aws.amazon.com/eks/latest/userguide/eks-hybrid-nodes.html
  # remote_network_config {
  #   # remote_node_networks (Required)
  #   # 設定内容: ハイブリッドノードを含むネットワークCIDRを指定します。
  #   remote_node_networks {
  #     # cidrs (Optional)
  #     # 設定内容: ハイブリッドノードを含むネットワークCIDRのリストを指定します。
  #     # 設定可能な値: ネットワークCIDRのリスト
  #     cidrs = ["172.16.0.0/18"]
  #   }
  #
  #   # remote_pod_networks (Optional)
  #   # 設定内容: ハイブリッドノード上でKubernetes Webhookを実行するPodを
  #   #           含むネットワークCIDRを指定します。
  #   remote_pod_networks {
  #     # cidrs (Optional)
  #     # 設定内容: リモートPodネットワークCIDRのリストを指定します。
  #     # 設定可能な値: ネットワークCIDRのリスト
  #     cidrs = ["172.16.64.0/18"]
  #   }
  # }

  #-------------------------------------------------------------
  # Outpost設定（Local EKS Cluster on AWS Outpost）
  #-------------------------------------------------------------

  # outpost_config (Optional)
  # 設定内容: AWS Outpost上のローカルEKSクラスター設定を指定します。
  # 注意: AWSクラウド上のEKSクラスター作成には使用できません。
  # 関連機能: EKS on Outposts
  #   - https://docs.aws.amazon.com/eks/latest/userguide/eks-on-outposts.html
  # outpost_config {
  #   # control_plane_instance_type (Required)
  #   # 設定内容: Kubernetesコントロールプレーンに使用するEC2インスタンスタイプを指定します。
  #   # 設定可能な値: EC2インスタンスタイプ
  #   # 推奨:
  #   #   - 1-20ノード: largeインスタンス
  #   #   - 21-100ノード: xlargeインスタンス
  #   #   - 101-250ノード: 2xlargeインスタンス
  #   # 注意: 作成後の変更は不可。EKSによる自動スケーリングは行われません。
  #   control_plane_instance_type = "m5.large"
  #
  #   # outpost_arns (Required)
  #   # 設定内容: 使用するOutpostのARNを指定します。
  #   # 設定可能な値: OutpostのARNのリスト
  #   # 注意: 現在は単一のOutpost ARNのみサポート
  #   outpost_arns = [data.aws_outposts_outpost.example.arn]
  #
  #   # control_plane_placement (Optional)
  #   # 設定内容: コントロールプレーンインスタンスの配置設定を指定します。
  #   control_plane_placement {
  #     # group_name (Required)
  #     # 設定内容: Kubernetesコントロールプレーンインスタンスの配置グループ名を指定します。
  #     # 設定可能な値: 配置グループ名
  #     # 注意: 作成後の変更は不可
  #     group_name = "eks-control-plane-placement"
  #   }
  # }

  #-------------------------------------------------------------
  # アップグレードポリシー設定
  #-------------------------------------------------------------

  # upgrade_policy (Optional)
  # 設定内容: クラスターのサポートタイプを指定します。
  # 関連機能: EKS Extended Support
  #   - https://docs.aws.amazon.com/eks/latest/userguide/extended-support.html
  # upgrade_policy {
  #   # support_type (Optional, Computed)
  #   # 設定内容: サポートタイプを指定します。
  #   # 設定可能な値:
  #   #   - STANDARD: 標準サポート（標準サポート終了時に自動アップグレード）
  #   #   - EXTENDED: 拡張サポート（標準サポート終了時に拡張サポートに移行）
  #   # 用途: クラスターのサポート期間とアップグレードポリシーを制御
  #   support_type = "STANDARD"
  # }

  #-------------------------------------------------------------
  # Zonal Shift設定
  #-------------------------------------------------------------

  # zonal_shift_config (Optional)
  # 設定内容: クラスターのZonal Shift設定を指定します。
  # 関連機能: AWS Zonal Shift
  #   - https://docs.aws.amazon.com/r53recovery/latest/dg/arc-zonal-shift.html
  # zonal_shift_config {
  #   # enabled (Optional)
  #   # 設定内容: Zonal Shiftを有効化するかを指定します。
  #   # 設定可能な値:
  #   #   - true: Zonal Shift有効
  #   #   - false: Zonal Shift無効
  #   # 用途: AZ障害時のトラフィックシフト機能
  #   enabled = false
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-eks-cluster"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト時間をカスタマイズします。
  timeouts {
    # create (Optional)
    # 設定内容: クラスター作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # デフォルト: 30分
    create = "30m"

    # update (Optional)
    # 設定内容: クラスター更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "2h"）
    # デフォルト: 60分
    update = "60m"

    # delete (Optional)
    # 設定内容: クラスター削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "15m", "30m"）
    # デフォルト: 15分
    delete = "15m"
  }

  #-------------------------------------------------------------
  # 依存関係設定
  #-------------------------------------------------------------

  # IAMロール権限がクラスター処理の前に作成され、後に削除されるようにします。
  # そうしないと、EKSはセキュリティグループ等のEKSマネージドEC2インフラを
  # 適切に削除できません。
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

#---------------------------------------------------------------
# 関連リソース例: IAMロール
#---------------------------------------------------------------

# EKSクラスター用IAMロール
resource "aws_iam_role" "cluster" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# EKSクラスターポリシーのアタッチ
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# EKS Auto Mode使用時の追加ポリシー例
# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSComputePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
#   role       = aws_iam_role.cluster.name
# }
#
# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSBlockStoragePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
#   role       = aws_iam_role.cluster.name
# }
#
# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSLoadBalancingPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
#   role       = aws_iam_role.cluster.name
# }
#
# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSNetworkingPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
#   role       = aws_iam_role.cluster.name
# }

# Outpost使用時のポリシー例
# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSLocalOutpostClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLocalOutpostClusterPolicy"
#   role       = aws_iam_role.cluster.name
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: クラスターのAmazon Resource Name (ARN)
#
# - certificate_authority: クラスターの証明書機関データを含む属性ブロック
#   - data: クラスターとの通信に必要なBase64エンコードされた証明書データ
#           kubeconfigファイルのcertificate-authority-dataセクションに追加します。
#
# - cluster_id: AWS Outpost上のローカルEKSクラスターのID
#   注意: AWSクラウド上のEKSクラスターでは利用できません。
#
# - created_at: クラスターが作成されたUnixエポックタイムスタンプ（秒）
#
# - endpoint: Kubernetes APIサーバーのエンドポイント
#
# - id: クラスター名
#
# - identity: クラスターのIDプロバイダー情報を含む属性ブロック
#   注意: 2019年9月3日以降に作成またはアップグレードされた
#         Kubernetesバージョン1.13および1.14クラスターでのみ利用可能
#   - oidc: OpenID Connect IDプロバイダー情報を含むネストブロック
#     - issuer: OpenID Connect IDプロバイダーのIssuer URL
#
# - platform_version: クラスターのプラットフォームバージョン
#
# - status: EKSクラスターのステータス
#   値: CREATING, ACTIVE, DELETING, FAILED
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - vpc_config.cluster_security_group_id: EKSが作成したクラスターセキュリティグループのID
#   用途: マネージドノードグループがコントロールプレーンとデータプレーン間の
#         通信に使用します。
#
# - vpc_config.vpc_id: クラスターに関連付けられたVPCのID
#---------------------------------------------------------------
