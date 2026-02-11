#---------------------------------------------------------------
# EMR Containers Virtual Cluster
#---------------------------------------------------------------
#
# Amazon EMR on EKS仮想クラスターを管理するリソース。
# 仮想クラスターは、Amazon EMRが登録されたKubernetesネームスペースで、
# EMR on EKSでジョブを実行するために使用されます。
# 仮想クラスターは追加のリソースを消費せず、EKSクラスター上の
# 単一のKubernetesネームスペースにマッピングされます。
#
# AWS公式ドキュメント:
#   - Managing virtual clusters: https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/virtual-cluster.html
#   - EMR on EKS Concepts: https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/emr-eks-concepts.html
#   - API Reference - VirtualCluster: https://docs.aws.amazon.com/emr-on-eks/latest/APIReference/API_VirtualCluster.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emrcontainers_virtual_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_emrcontainers_virtual_cluster" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # 仮想クラスターの名前
  # Amazon EMRコンソールやCLIで表示される識別名です。
  # 制約: 1〜64文字の英数字、ハイフン、アンダースコア
  name = "example-virtual-cluster"

  # 仮想クラスターに関連付けられるコンテナプロバイダーの設定
  # EKSクラスターとそのネームスペースの情報を指定します。
  # 仮想クラスターは単一のKubernetesネームスペースにマッピングされ、
  # そのネームスペース内でEMRジョブが実行されます。
  container_provider {
    # EKSクラスターの名前またはARN
    # EMR on EKSワークロードを実行する既存のEKSクラスターを指定します。
    # 注意: EKSクラスターは事前に作成されており、EMR on EKS用に
    #       適切に設定されている必要があります（RBAC設定、IAM設定など）。
    id = "example-eks-cluster"

    # コンテナプロバイダーのタイプ
    # 現在サポートされている値: "EKS"
    # Amazon EMR on EKSではEKSクラスターのみがサポートされています。
    type = "EKS"

    # コンテナプロバイダーの詳細情報
    # EKS固有の設定（ネームスペースなど）を含みます。
    info {
      # EKS固有の設定情報
      # EMRジョブを実行するKubernetesネームスペースを指定します。
      eks_info {
        # EMRワークロードを実行するKubernetesネームスペース
        # このネームスペースは事前にEKSクラスター上に作成されている必要があります。
        # また、Amazon EMR on EKSがこのネームスペースにアクセスできるよう
        # RBACロール（emr-containers）が設定されている必要があります。
        # 例: "default", "emr", "spark-jobs"
        # 省略可能: 指定しない場合、デフォルトの動作が適用されます
        namespace = "emr-namespace"
      }
    }
  }

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # リージョンの明示的な指定
  # このリソースを管理するAWSリージョンを指定します。
  # 省略した場合はプロバイダー設定のリージョンが使用されます。
  # 使用例: マルチリージョン構成で特定リージョンにリソースを配置する場合
  # region = "us-west-2"

  # リソースタグ
  # 仮想クラスターに付与するタグのキー・バリューペア。
  # コスト配分、リソース管理、アクセス制御などに使用できます。
  # プロバイダーレベルでdefault_tagsが設定されている場合、
  # ここで指定したタグは default_tags をオーバーライドします。
  tags = {
    Environment = "production"
    Team        = "data-engineering"
    ManagedBy   = "terraform"
  }

  #---------------------------------------------------------------
  # Timeouts Configuration
  #---------------------------------------------------------------

  # タイムアウト設定
  # リソース操作のタイムアウト時間を調整できます。
  # timeouts {
  #   # 削除操作のタイムアウト（デフォルト: 90分）
  #   # 仮想クラスターの削除には時間がかかる場合があるため、
  #   # 必要に応じて延長できます。
  #   delete = "90m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - arn
#   仮想クラスターのAmazon Resource Name (ARN)
#   形式: arn:aws:emr-containers:region:account-id:virtual-cluster/virtual-cluster-id
#   例: arn:aws:emr-containers:us-west-2:123456789012:virtual-cluster/abc123def456
#
# - id
#   仮想クラスターのID（一意の識別子）
#   例: abc123def456
#   注意: このIDはEMRジョブ実行時に仮想クラスターを指定する際に使用します
#
# - tags_all
#   リソースに割り当てられたすべてのタグのマップ
#   プロバイダーのdefault_tagsとリソース固有のtagsをマージしたもの
#
# 使用例:
# output "virtual_cluster_id" {
#   value = aws_emrcontainers_virtual_cluster.example.id
# }
#
# output "virtual_cluster_arn" {
#   value = aws_emrcontainers_virtual_cluster.example.arn
# }
