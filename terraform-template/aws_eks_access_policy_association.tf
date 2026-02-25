#---------------------------------------
# EKS Access Policy Association
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association
#
# EKSクラスターのアクセスエントリに対してAWSマネージドアクセスポリシーを関連付けるリソース。
# IAMプリンシパル（ユーザーまたはロール）に対してKubernetesクラスターへのアクセス権限を付与します。
#
# ユースケース:
# - IAMユーザー/ロールにEKSクラスターへのアクセス権限を付与
# - Kubernetes名前空間レベルまたはクラスター全体での権限スコープ設定
# - aws-authConfigMapを使用せずにアクセス管理を簡素化
#
# 制約事項:
# - クラスターの認証モードでアクセスエントリが有効になっている必要があります
# - 各アクセスエントリに対して同じポリシーを複数回関連付けることはできません
# - アクセスエントリのタイプがStandardの場合のみポリシー関連付けが必要です
#
# 関連リソース:
# - aws_eks_cluster: EKSクラスター
# - aws_eks_access_entry: EKSアクセスエントリ
# - aws_iam_role / aws_iam_user: IAMプリンシパル
#
# NOTE: このテンプレートは設定例であり、実際の使用時には環境に応じて適切な値に変更してください。
#---------------------------------------

resource "aws_eks_access_policy_association" "example" {
  #---------------------------------------
  # 基本設定
  #---------------------------------------
  # 設定内容: EKSクラスター名
  # 設定可能な値: 既存のEKSクラスター名
  # 省略時: 必須項目のため指定が必要
  cluster_name = "example-cluster"

  # 設定内容: 関連付けるアクセスポリシーのARN
  # 設定可能な値: AWSマネージドEKSアクセスポリシーのARN
  #   - arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy (読み取り専用)
  #   - arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy (編集権限)
  #   - arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy (管理者権限)
  #   - arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy (クラスター管理者)
  # 省略時: 必須項目のため指定が必要
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

  # 設定内容: EKSクラスターへの認証アクセスを必要とするIAMプリンシパルのARN
  # 設定可能な値: IAMユーザーまたはIAMロールのARN
  # 省略時: 必須項目のため指定が必要
  principal_arn = "arn:aws:iam::123456789012:role/example-role"

  #---------------------------------------
  # リージョン設定（オプション）
  #---------------------------------------
  # 設定内容: リソースが管理されるAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1、ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンが使用されます
  region = "us-east-1"

  #---------------------------------------
  # アクセススコープ設定
  #---------------------------------------
  access_scope {
    # 設定内容: アクセススコープのタイプ
    # 設定可能な値: cluster（クラスター全体）、namespace（特定の名前空間）
    # 省略時: 必須項目のため指定が必要
    type = "namespace"

    # 設定内容: アクセススコープが適用されるKubernetes名前空間のリスト
    # 設定可能な値: Kubernetes名前空間名のセット
    # 省略時: typeがclusterの場合は不要、namespaceの場合は指定推奨
    namespaces = ["default", "kube-system"]
  }

  #---------------------------------------
  # タイムアウト設定（オプション）
  #---------------------------------------
  # timeouts {
  #   # 設定内容: 作成時のタイムアウト時間
  #   # 設定可能な値: 時間文字列（例: 10m、1h）
  #   # 省略時: デフォルトのタイムアウト値が使用されます
  #   create = "10m"
  #
  #   # 設定内容: 削除時のタイムアウト時間
  #   # 設定可能な値: 時間文字列（例: 10m、1h）
  #   # 省略時: デフォルトのタイムアウト値が使用されます
  #   delete = "10m"
  # }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# id - リソースID（cluster_name#principal_arn#policy_arn形式）
# associated_at - ポリシーが関連付けられた日時（RFC3339形式）
# modified_at - ポリシーが更新された日時（RFC3339形式）
