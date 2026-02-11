#---------------------------------------------------------------
# AWS EKS Pod Identity Association
#---------------------------------------------------------------
#
# Amazon EKS Pod Identity Associationをプロビジョニングするリソースです。
# EKS Pod Identity Associationは、Kubernetesのサービスアカウントに
# IAMロールを関連付けることで、Podに対してAWSリソースへのアクセス権限を
# 付与する仕組みを提供します。これにより、Pod内のアプリケーションは
# AWS APIを安全に呼び出すことができます。
#
# AWS公式ドキュメント:
#   - EKS Pod Identity: https://docs.aws.amazon.com/eks/latest/userguide/pod-identities.html
#   - IAM roles for service accounts: https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_eks_pod_identity_association" "example" {
  #-------------------------------------------------------------
  # クラスター設定 (必須)
  #-------------------------------------------------------------

  # cluster_name (Required)
  # 設定内容: Pod Identity Associationを作成するEKSクラスターの名前を指定します。
  # 設定可能な値: 既存のEKSクラスター名
  # 注意: クラスターは事前に作成されている必要があります。
  # 参考: https://docs.aws.amazon.com/eks/latest/userguide/clusters.html
  cluster_name = "my-eks-cluster"

  #-------------------------------------------------------------
  # Kubernetes設定 (必須)
  #-------------------------------------------------------------

  # namespace (Required)
  # 設定内容: サービスアカウントが存在するKubernetesの名前空間を指定します。
  # 設定可能な値: 有効なKubernetes namespace名
  # 注意: 名前空間は事前にKubernetesクラスター内に作成されている必要があります。
  # 参考: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
  namespace = "default"

  # service_account (Required)
  # 設定内容: IAMロールを関連付けるKubernetesサービスアカウント名を指定します。
  # 設定可能な値: 有効なKubernetes ServiceAccount名
  # 注意: サービスアカウントは事前にKubernetesクラスター内に作成されている必要があります。
  # 参考: https://kubernetes.io/docs/concepts/security/service-accounts/
  service_account = "my-service-account"

  #-------------------------------------------------------------
  # IAMロール設定 (必須)
  #-------------------------------------------------------------

  # role_arn (Required)
  # 設定内容: Podに割り当てるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールのARN
  # 注意: IAMロールには適切な信頼ポリシーが設定されている必要があります。
  #       特にEKS Pod Identityサービスプリンシパル（pods.eks.amazonaws.com）を
  #       信頼する設定が必要です。
  # 参考: https://docs.aws.amazon.com/eks/latest/userguide/pod-identities.html
  role_arn = "arn:aws:iam::123456789012:role/my-pod-role"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # disable_session_tags (Optional)
  # 設定内容: セッションタグの使用を無効にするかを指定します。
  # 設定可能な値:
  #   - true: セッションタグを無効化します
  #   - false: セッションタグを有効化します（デフォルト）
  # 関連機能: AWS STS Session Tags
  #   セッションタグは、一時的な認証情報に関連付けられたキーと値のペアです。
  #   ABAC（Attribute-Based Access Control）に使用できます。
  #   - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_session-tags.html
  disable_session_tags = null

  # target_role_arn (Optional)
  # 設定内容: Podが引き受けるターゲットIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールのARN
  # 注意: この設定は特定のユースケースで使用されます。
  #       通常はrole_arnのみで十分です。
  target_role_arn = null

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
  #   - https://docs.aws.amazon.com/tag-editor/latest/userguide/tagging.html
  tags = {
    Name        = "my-pod-identity-association"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - association_arn: Pod Identity AssociationのAmazon Resource Name (ARN)
#
# - association_id: Pod Identity Associationの一意の識別子
#
# - external_id: 外部ID（特定の認証シナリオで使用）
#
# - id: リソースのID（association_idと同じ値）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
