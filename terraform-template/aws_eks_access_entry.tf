#---------------------------------------------------------------
# AWS EKS Access Entry
#---------------------------------------------------------------
#
# Amazon EKS クラスターへのアクセスエントリを管理するリソースです。
# EKS Access Entryは、IAMプリンシパル（ユーザーまたはロール）をEKSクラスターに
# 関連付け、Kubernetesグループへのマッピングやアクセスタイプの設定を可能にします。
#
# AWS公式ドキュメント:
#   - EKS クラスターアクセス管理: https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html
#   - EKS セキュリティ: https://docs.aws.amazon.com/eks/latest/userguide/security.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_eks_access_entry" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # cluster_name (Required)
  # 設定内容: アクセスエントリを作成するEKSクラスターの名前を指定します。
  # 設定可能な値: 既存のEKSクラスター名
  # 関連機能: EKS クラスターアクセス管理
  #   EKSクラスターへのIAMプリンシパルのアクセスを管理します。
  #   - https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html
  cluster_name = "my-eks-cluster"

  # principal_arn (Required)
  # 設定内容: EKSクラスターへのアクセスを許可するIAMプリンシパルのARNを指定します。
  # 設定可能な値: 有効なIAMユーザーまたはロールのARN
  # 関連機能: IAMプリンシパルとEKSの統合
  #   IAMエンティティをKubernetesの認証・認可システムと統合します。
  #   - https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
  principal_arn = "arn:aws:iam::123456789012:role/MyEKSRole"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # kubernetes_groups (Optional)
  # 設定内容: プリンシパルを関連付けるKubernetesグループのリストを指定します。
  # 設定可能な値: Kubernetesグループ名の文字列セット
  # 関連機能: Kubernetes RBAC
  #   KubernetesのRole-Based Access Control（RBAC）と統合し、
  #   グループベースの権限管理を可能にします。
  #   - https://kubernetes.io/docs/reference/access-authn-authz/rbac/
  kubernetes_groups = ["system:masters", "developers"]

  # type (Optional)
  # 設定内容: アクセスエントリのタイプを指定します。
  # 設定可能な値:
  #   - "STANDARD": 標準的なアクセスエントリ
  #   - "EC2_LINUX": EC2 Linuxワーカーノード用
  #   - "EC2_WINDOWS": EC2 Windowsワーカーノード用
  #   - "FARGATE_LINUX": Fargate Linuxポッド用
  # 省略時: "STANDARD"が使用されます
  # 関連機能: EKS ワーカーノード認証
  #   異なるコンピューティング環境に応じたアクセスタイプを定義します。
  #   - https://docs.aws.amazon.com/eks/latest/userguide/worker.html
  type = "STANDARD"

  # user_name (Optional)
  # 設定内容: Kubernetes内でプリンシパルを識別するために使用されるユーザー名を指定します。
  # 設定可能な値: Kubernetesで使用可能なユーザー名文字列
  # 省略時: プリンシパルARNから自動的に生成されます
  # 関連機能: Kubernetes ユーザー認証
  #   Kubernetes監査ログやRBACポリシーで使用される識別子を定義します。
  #   - https://kubernetes.io/docs/reference/access-authn-authz/authentication/
  user_name = "my-eks-user"

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
    Name        = "my-eks-access-entry"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: アクセスエントリ作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = "10m"

    # delete (Optional)
    # 設定内容: アクセスエントリ削除時のタイムアウト時間を指定します。
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
# - id: アクセスエントリのID（cluster_name:principal_arn形式）
#
# - access_entry_arn: アクセスエントリのAmazon Resource Name (ARN)
#
# - created_at: アクセスエントリが作成された日時（RFC3339形式）
#
# - modified_at: アクセスエントリが最後に変更された日時（RFC3339形式）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
