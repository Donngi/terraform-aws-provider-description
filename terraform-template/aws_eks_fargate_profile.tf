#---------------------------------------------------------------
# AWS EKS Fargate Profile
#---------------------------------------------------------------
#
# Amazon EKS Fargate ProfileはEKSクラスター内のKubernetes Podを
# AWS Fargateで実行するための設定を管理します。
# Fargateを使用することで、EC2インスタンスを管理することなく、
# サーバーレスなコンテナ実行環境を利用できます。
#
# AWS公式ドキュメント:
#   - EKS Fargate: https://docs.aws.amazon.com/eks/latest/userguide/fargate.html
#   - Fargate Profile: https://docs.aws.amazon.com/eks/latest/userguide/fargate-profile.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_eks_fargate_profile" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # cluster_name (Required)
  # 設定内容: Fargate Profileを作成するEKSクラスターの名前を指定します。
  # 設定可能な値: 既存のEKSクラスター名
  # 関連機能: EKS クラスター統合
  #   指定したEKSクラスターにFargateの実行環境を統合します。
  #   - https://docs.aws.amazon.com/eks/latest/userguide/clusters.html
  cluster_name = "my-eks-cluster"

  # fargate_profile_name (Required)
  # 設定内容: Fargate Profileの名前を指定します。
  # 設定可能な値: 英数字とハイフンを含む文字列
  # 関連機能: プロファイル識別
  #   クラスター内で一意のプロファイル名として使用されます。
  fargate_profile_name = "my-fargate-profile"

  # pod_execution_role_arn (Required)
  # 設定内容: Fargate ProfileがPodを実行する際に使用するIAMロールのARNを指定します。
  # 設定可能な値: AmazonEKSFargatePodExecutionRolePolicyポリシーを持つIAMロールのARN
  # 関連機能: IAM権限管理
  #   Fargateインフラストラクチャがコンテナイメージの取得や
  #   CloudWatch Logsへの書き込みを行うための権限を提供します。
  #   - https://docs.aws.amazon.com/eks/latest/userguide/pod-execution-role.html
  pod_execution_role_arn = "arn:aws:iam::123456789012:role/eks-fargate-pod-execution-role"

  #-------------------------------------------------------------
  # Podセレクター設定
  #-------------------------------------------------------------

  # selector (Required)
  # 設定内容: FargateでPodを実行するためのセレクター条件を指定します。
  # 設定可能な値: 1つ以上のセレクターブロック
  # 関連機能: Pod実行環境の選択
  #   namespaceとlabelsに基づいてFargateで実行するPodを決定します。
  #   - https://docs.aws.amazon.com/eks/latest/userguide/fargate-profile.html#fargate-profile-components
  selector {
    # namespace (Required)
    # 設定内容: FargateでPodを実行するKubernetesネームスペースを指定します。
    # 設定可能な値: 有効なKubernetesネームスペース名
    # 関連機能: ネームスペースベースの分離
    #   特定のネームスペース内のPodをFargateで実行します。
    namespace = "default"

    # labels (Optional)
    # 設定内容: Podを選択するためのKubernetesラベルのマップを指定します。
    # 設定可能な値: キーと値のペアのマップ
    # 省略時: ネームスペース内のすべてのPodが対象になります
    # 関連機能: ラベルベースの選択
    #   指定したラベルを持つPodのみをFargateで実行します。
    #   - https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
    labels = {
      environment = "production"
      tier        = "backend"
    }
  }

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # subnet_ids (Optional)
  # 設定内容: Fargate Profileに関連付けるプライベートサブネットのIDリストを指定します。
  # 設定可能な値: プライベートサブネットIDのセット
  # 関連機能: VPCネットワーク統合
  #   指定したサブネットにFargate Podが配置されます。
  #   サブネットには kubernetes.io/cluster/CLUSTER_NAME タグが必要です。
  #   - https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
  subnet_ids = [
    "subnet-0123456789abcdef0",
    "subnet-0123456789abcdef1",
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "my-fargate-profile"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: Fargate Profile作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = "10m"

    # delete (Optional)
    # 設定内容: Fargate Profile削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: EKSクラスター名とFargate Profile名をコロン（:）で区切った形式
#
# - arn: Fargate ProfileのAmazon Resource Name (ARN)
#
# - status: Fargate Profileのステータス（CREATING, ACTIVE, DELETING等）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
