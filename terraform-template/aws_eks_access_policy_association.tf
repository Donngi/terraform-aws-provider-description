#---------------------------------------------------------------
# EKS Access Policy Association
#---------------------------------------------------------------
#
# Amazon EKS Access Policy Associationリソースは、EKSクラスターへのアクセスエントリに
# AWSマネージドアクセスポリシーを関連付けます。これにより、IAMプリンシパル（ユーザーまたはロール）に
# 特定のKubernetes権限を付与し、クラスターレベルまたは名前空間レベルでスコープを制御できます。
#
# AWS公式ドキュメント:
#   - Associate access policies with access entries: https://docs.aws.amazon.com/eks/latest/userguide/access-policies.html
#   - Grant IAM users access to Kubernetes with EKS access entries: https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html
#   - API Reference - AssociateAccessPolicy: https://docs.aws.amazon.com/eks/latest/APIReference/API_AssociateAccessPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_eks_access_policy_association" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # EKSクラスターの名前
  # - アクセスポリシーを関連付ける対象のEKSクラスター名を指定
  # - 既存のEKSクラスターが存在している必要があります
  cluster_name = "my-eks-cluster"

  # アクセスポリシーのARN
  # - 関連付けるAWSマネージドEKSアクセスポリシーのARNを指定
  # - 利用可能なポリシー例:
  #   - arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy
  #   - arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy
  #   - arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy
  #   - arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy
  # - 利用可能なポリシーは AWS CLI の list-access-policies コマンドで確認可能
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

  # プリンシパルARN
  # - EKSクラスターへの認証アクセスを必要とするIAMプリンシパル（ユーザーまたはロール）のARN
  # - このIAMプリンシパルに対してアクセスポリシーが適用されます
  # - 事前にアクセスエントリ（aws_eks_access_entry）が作成されている必要があります
  principal_arn = "arn:aws:iam::123456789012:user/example-user"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # ID
  # - Terraformリソースの識別子
  # - 通常は指定不要（自動生成）
  # - フォーマット: cluster_name#principal_arn#policy_arn
  # id = null

  # リージョン
  # - このリソースを管理するAWSリージョン
  # - 指定しない場合、プロバイダー設定のリージョンが使用されます
  # - クロスリージョン管理が必要な場合に指定
  # region = "us-west-2"

  #---------------------------------------------------------------
  # Block: access_scope (Required)
  #---------------------------------------------------------------
  # アクセスポリシーのスコープを決定する設定ブロック
  # - 各ポリシーは1つのaccess_scopeブロックを持つ必要があります
  # - クラスター全体またはKubernetes名前空間レベルでスコープを制御

  access_scope {
    # アクセススコープのタイプ (Required)
    # - 有効な値:
    #   - "cluster": クラスター全体にアクセス権限を付与
    #   - "namespace": 特定の名前空間にのみアクセス権限を付与
    # - type = "namespace" の場合、namespaces パラメータの指定が必要
    type = "namespace"

    # 名前空間のリスト (Optional)
    # - type = "namespace" の場合に適用対象の名前空間を指定
    # - 複数の名前空間を指定可能（セット型）
    # - type = "cluster" の場合は指定不要
    # - 例: ["default", "kube-system", "my-app-namespace"]
    namespaces = ["example-namespace"]
  }

  #---------------------------------------------------------------
  # Block: timeouts (Optional)
  #---------------------------------------------------------------
  # リソース操作のタイムアウト設定

  # timeouts {
  #   # 作成時のタイムアウト
  #   # - アクセスポリシーの関連付け完了までの最大待機時間
  #   # - デフォルト値が適用されます（通常は十分）
  #   # - フォーマット: "10m", "1h" など
  #   create = "10m"
  #
  #   # 削除時のタイムアウト
  #   # - アクセスポリシーの関連付け解除完了までの最大待機時間
  #   # - デフォルト値が適用されます
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed-only）:
#
# - associated_at: ポリシーが関連付けられた日時（RFC3339形式）
# - modified_at: ポリシーが最後に更新された日時（RFC3339形式）
#
# 使用例:
#   output "policy_associated_at" {
#     value = aws_eks_access_policy_association.example.associated_at
#   }
#---------------------------------------------------------------

