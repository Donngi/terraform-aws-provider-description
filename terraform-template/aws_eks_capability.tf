# ============================================================================
# Terraform AWS Resource: aws_eks_capability
# Provider Version: 6.28.0
# Generated: 2026-01-27
# ============================================================================
#
# リソース概要:
# aws_eks_capability は、Amazon EKS クラスター向けの完全マネージド型の機能を管理します。
# EKS Capabilities は、開発者の生産性を向上させ、Kubernetes でのビルドとスケーリングの
# 複雑さを軽減するために設計された、完全マネージド型のクラスター機能セットです。
#
# サポートされる機能タイプ:
# - ACK (AWS Controllers for Kubernetes): Kubernetes API を使用して AWS リソースを管理
# - ARGOCD: GitOps ベースの継続的デプロイメントを実装
# - KRO: カスタム Kubernetes API を作成し、複数のリソースを高レベルの抽象化に統合
#
# 主な特徴:
# - AWS によって完全マネージド - インストール、メンテナンス、スケーリングが不要
# - AWS Identity Center との統合による認証と認可
# - マルチクラスター・マルチリージョンのサポート
# - GitOps ワークフローのネイティブサポート
# - 宣言的な構成管理とバージョン管理
#
# AWS ドキュメント:
# https://docs.aws.amazon.com/eks/latest/userguide/capabilities.html
# https://docs.aws.amazon.com/eks/latest/userguide/argocd.html
#
# Terraform ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_capability
#
# ============================================================================

resource "aws_eks_capability" "example" {
  # --------------------------------------------------------------------------
  # 必須パラメータ (Required Parameters)
  # --------------------------------------------------------------------------

  # capability_name - (Required) 機能の名前
  #
  # 説明:
  # - クラスター内で一意である必要があります
  # - 機能インスタンスを識別するために使用されます
  # - 英数字、ハイフン、アンダースコアを使用できます
  #
  # 例:
  # - "argocd-production"
  # - "ack-controller"
  # - "kro-platform"
  capability_name = "argocd"

  # cluster_name - (Required) EKS クラスターの名前
  #
  # 説明:
  # - 機能を有効化する対象の EKS クラスター名を指定します
  # - クラスターは既に存在している必要があります
  # - 通常は aws_eks_cluster リソースから参照します
  cluster_name = aws_eks_cluster.example.name

  # type - (Required) 機能のタイプ
  #
  # 有効な値:
  # - "ACK": AWS Controllers for Kubernetes
  #   - Kubernetes API を使用して AWS リソース (S3、RDS、IAM など) を管理
  #   - クロスアカウント・クロスリージョンのリソース管理をサポート
  #   - 継続的な状態の調整により、drift を自動修正
  #
  # - "ARGOCD": Argo CD
  #   - GitOps ベースの継続的デプロイメント
  #   - Git リポジトリからアプリケーションを自動同期
  #   - マルチクラスター管理のサポート
  #   - UI による可視化と監視機能
  #
  # - "KRO": Kube Resource Orchestrator
  #   - カスタム Kubernetes API の作成
  #   - 複数のリソースを高レベルの抽象化に統合
  #   - プラットフォームチームが再利用可能なパターンを定義可能
  type = "ARGOCD"

  # role_arn - (Required) 機能に関連付ける IAM ロールの ARN
  #
  # 説明:
  # - 機能が AWS リソースにアクセスするための IAM ロール
  # - 適切な信頼ポリシーと権限ポリシーが必要です
  # - ArgoCD の場合、このロールは ArgoCD が AWS サービスと統合するために使用されます
  #
  # 信頼ポリシーの例:
  # {
  #   "Version": "2012-10-17",
  #   "Statement": [{
  #     "Effect": "Allow",
  #     "Principal": {
  #       "Service": "eks.amazonaws.com"
  #     },
  #     "Action": "sts:AssumeRole"
  #   }]
  # }
  role_arn = aws_iam_role.example.arn

  # delete_propagation_policy - (Required) 機能の削除伝播ポリシー
  #
  # 有効な値:
  # - "RETAIN": 機能を削除する際、クラスター内にインストールされた
  #             カスタムリソース定義 (CRD) とリソースを保持します
  #
  # 注意:
  # - 現在、RETAIN のみがサポートされています
  # - 機能を削除する前に、手動でリソースをクリーンアップする必要がある場合があります
  delete_propagation_policy = "RETAIN"

  # --------------------------------------------------------------------------
  # オプションパラメータ (Optional Parameters)
  # --------------------------------------------------------------------------

  # configuration - (Optional) 機能の構成
  #
  # 説明:
  # - 機能タイプに応じた詳細な構成設定を定義します
  # - 現在、主に ARGOCD タイプで使用されます
  # - ネストされたブロック構造で設定を指定します
  configuration {
    # argo_cd - (Optional) ArgoCD の構成
    #
    # 説明:
    # - type = "ARGOCD" の場合に使用します
    # - ArgoCD の動作、認証、ネットワーク設定を定義します
    argo_cd {
      # aws_idc - (Optional) AWS IAM Identity Center の構成
      #
      # 説明:
      # - ArgoCD と AWS Identity Center を統合します
      # - シームレスな認証と認可を提供します
      # - ユーザーとグループベースのアクセス制御が可能です
      aws_idc {
        # idc_instance_arn - (Required) IAM Identity Center インスタンスの ARN
        #
        # 形式: arn:aws:sso:::instance/ssoins-xxxxxxxxxxxx
        #
        # 説明:
        # - AWS Identity Center インスタンスを識別します
        # - AWS コンソールまたは AWS CLI で確認できます
        # - 組織全体で共有される場合があります
        idc_instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef0"

        # idc_region - (Optional) IAM Identity Center インスタンスのリージョン
        #
        # 説明:
        # - Identity Center インスタンスが存在するリージョンを指定します
        # - 指定しない場合、現在のリージョンが使用されます
        # - Identity Center は通常、組織のホームリージョンで設定されます
        #
        # 例: "us-east-1", "eu-west-1"
        # idc_region = "us-east-1"
      }

      # namespace - (Optional) ArgoCD 用の Kubernetes 名前空間
      #
      # 説明:
      # - ArgoCD のコントローラーとリソースがデプロイされる名前空間
      # - 指定しない場合、デフォルトの名前空間が使用されます
      # - 既存の名前空間を使用する場合は、事前に作成しておく必要があります
      #
      # デフォルト: "argocd"
      namespace = "argocd"

      # network_access - (Optional) ネットワークアクセス構成
      #
      # 説明:
      # - ArgoCD サーバーへのネットワークアクセスを制御します
      # - VPC エンドポイント経由でのプライベートアクセスを設定できます
      # network_access {
      #   # vpce_ids - (Optional) VPC エンドポイント ID のリスト
      #   #
      #   # 説明:
      #   # - ArgoCD サーバーへのアクセスを許可する VPC エンドポイントを指定します
      #   # - プライベートネットワークからのアクセスを制限する場合に使用します
      #   # - 複数の VPC エンドポイントを指定できます
      #   #
      #   # 例: ["vpce-1234567890abcdef0", "vpce-0fedcba9876543210"]
      #   vpce_ids = []
      # }

      # rbac_role_mapping - (Optional) RBAC ロールマッピング
      #
      # 説明:
      # - AWS Identity Center のユーザーまたはグループを ArgoCD ロールにマッピングします
      # - きめ細かなアクセス制御を実現します
      # - 複数のマッピングを定義できます
      # rbac_role_mapping {
      #   # role - (Required) ArgoCD のロール
      #   #
      #   # 有効な値:
      #   # - "ADMIN": 完全な管理者権限
      #   #   - すべてのリソースの作成、更新、削除が可能
      #   #   - RBAC 設定の変更が可能
      #   #
      #   # - "EDITOR": 編集権限
      #   #   - アプリケーションの作成、更新、同期が可能
      #   #   - 削除権限はありません
      #   #
      #   # - "VIEWER": 読み取り専用
      #   #   - リソースの表示のみ可能
      #   #   - 変更操作は実行できません
      #   role = "ADMIN"
      #
      #   # identity - (Required) アイデンティティのリスト
      #   #
      #   # 説明:
      #   # - このロールにマッピングする Identity Center のユーザーまたはグループ
      #   # - 複数のアイデンティティを指定できます
      #   identity {
      #     # id - (Required) アイデンティティ ID
      #     #
      #     # 説明:
      #     # - Identity Center のユーザー ID またはグループ ID
      #     # - AWS コンソールまたは CLI で確認できます
      #     #
      #     # 例: "user-id-xxxxxxxxxxxx" または "group-id-xxxxxxxxxxxx"
      #     id = "user-id-1234567890abcdef0"
      #
      #     # type - (Required) アイデンティティのタイプ
      #     #
      #     # 有効な値:
      #     # - "SSO_USER": Identity Center の個別ユーザー
      #     # - "SSO_GROUP": Identity Center のグループ
      #     #
      #     # ベストプラクティス:
      #     # - 管理を簡素化するため、可能な限りグループを使用してください
      #     type = "SSO_USER"
      #   }
      # }
    }
  }

  # region - (Optional) このリソースが管理されるリージョン
  #
  # 説明:
  # - リソースを管理する AWS リージョンを指定します
  # - 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # - マルチリージョン構成の場合に有用です
  #
  # 例: "us-west-2", "eu-central-1", "ap-northeast-1"
  # region = "us-east-1"

  # tags - (Optional) リソースタグのキー/バリューマップ
  #
  # 説明:
  # - リソースの整理、コスト追跡、アクセス制御に使用します
  # - AWS のタグ付けベストプラクティスに従ってください
  #
  # ベストプラクティス:
  # - 環境 (Environment)、プロジェクト (Project)、所有者 (Owner) などの標準タグを使用
  # - コスト配分のための請求タグを含める
  # - 自動化のためのタグを追加 (例: Backup, Maintenance)
  tags = {
    Name        = "example-capability"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all は、プロバイダーレベルの default_tags と組み合わされた
  # すべてのタグを含む計算済み属性です。直接設定する必要はありません。
}

# ============================================================================
# 出力属性 (Computed Attributes)
# ============================================================================
#
# このリソースが作成された後、以下の属性が利用可能になります:
#
# - arn (string)
#   機能の ARN (Amazon Resource Name)
#   形式: arn:aws:eks:region:account-id:capability/cluster-name/capability-name
#   例: aws_eks_capability.example.arn
#
# - configuration.0.argo_cd.0.server_url (string)
#   Argo CD サーバーの URL
#   説明:
#   - 機能が作成された後に AWS によって生成されます
#   - ArgoCD UI およびCLI へのアクセスに使用します
#   - HTTPS プロトコルを使用したセキュアな接続が提供されます
#   例: https://argocd-xxxxxxxxxxxx.eks.amazonaws.com
#   参照: aws_eks_capability.example.configuration[0].argo_cd[0].server_url
#
# - tags_all (map of strings)
#   リソースに割り当てられたすべてのタグのマップ
#   プロバイダーの default_tags 設定ブロックから継承されたタグを含みます
#   例: aws_eks_capability.example.tags_all
#
# - version (string)
#   機能のバージョン
#   説明:
#   - AWS によって管理されるバージョン番号
#   - 自動的にアップグレードされる場合があります
#   例: aws_eks_capability.example.version

# ============================================================================
# インポート (Import)
# ============================================================================
#
# 既存の EKS Capability は以下の形式でインポートできます:
#
# terraform import aws_eks_capability.example cluster-name:capability-name
#
# 例:
# terraform import aws_eks_capability.example my-cluster:argocd

# ============================================================================
# 使用例 (Usage Examples)
# ============================================================================

# 例1: シンプルな ArgoCD 機能
# -----------------------------------------------------------------------------
# resource "aws_eks_capability" "argocd_simple" {
#   cluster_name              = aws_eks_cluster.main.name
#   capability_name           = "argocd"
#   type                      = "ARGOCD"
#   role_arn                  = aws_iam_role.argocd_capability.arn
#   delete_propagation_policy = "RETAIN"
#
#   configuration {
#     argo_cd {
#       aws_idc {
#         idc_instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef0"
#       }
#       namespace = "argocd"
#     }
#   }
#
#   tags = {
#     Name = "argocd-capability"
#   }
# }

# 例2: RBAC マッピング付きの ArgoCD 機能
# -----------------------------------------------------------------------------
# resource "aws_eks_capability" "argocd_rbac" {
#   cluster_name              = aws_eks_cluster.main.name
#   capability_name           = "argocd-rbac"
#   type                      = "ARGOCD"
#   role_arn                  = aws_iam_role.argocd_capability.arn
#   delete_propagation_policy = "RETAIN"
#
#   configuration {
#     argo_cd {
#       aws_idc {
#         idc_instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef0"
#         idc_region       = "us-east-1"
#       }
#       namespace = "argocd"
#
#       # 管理者グループ
#       rbac_role_mapping {
#         role = "ADMIN"
#         identity {
#           id   = "admin-group-id"
#           type = "SSO_GROUP"
#         }
#       }
#
#       # 開発者グループ
#       rbac_role_mapping {
#         role = "EDITOR"
#         identity {
#           id   = "developer-group-id"
#           type = "SSO_GROUP"
#         }
#       }
#
#       # 閲覧者グループ
#       rbac_role_mapping {
#         role = "VIEWER"
#         identity {
#           id   = "viewer-group-id"
#           type = "SSO_GROUP"
#         }
#       }
#     }
#   }
# }

# 例3: ACK (AWS Controllers for Kubernetes) 機能
# -----------------------------------------------------------------------------
# resource "aws_eks_capability" "ack" {
#   cluster_name              = aws_eks_cluster.main.name
#   capability_name           = "ack-controller"
#   type                      = "ACK"
#   role_arn                  = aws_iam_role.ack_capability.arn
#   delete_propagation_policy = "RETAIN"
#
#   tags = {
#     Name        = "ack-capability"
#     Environment = "production"
#   }
# }

# 例4: KRO (Kube Resource Orchestrator) 機能
# -----------------------------------------------------------------------------
# resource "aws_eks_capability" "kro" {
#   cluster_name              = aws_eks_cluster.main.name
#   capability_name           = "kro-platform"
#   type                      = "KRO"
#   role_arn                  = aws_iam_role.kro_capability.arn
#   delete_propagation_policy = "RETAIN"
#
#   tags = {
#     Name        = "kro-capability"
#     Environment = "production"
#   }
# }

# ============================================================================
# IAM ロールの例 (Example IAM Role)
# ============================================================================

# ArgoCD 機能用の IAM ロール
# resource "aws_iam_role" "argocd_capability" {
#   name = "eks-argocd-capability-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
#
#   tags = {
#     Name = "eks-argocd-capability-role"
#   }
# }

# ArgoCD が AWS リソースにアクセスするためのポリシー例
# resource "aws_iam_role_policy" "argocd_capability_policy" {
#   name = "argocd-capability-policy"
#   role = aws_iam_role.argocd_capability.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "secretsmanager:GetSecretValue",
#           "secretsmanager:DescribeSecret"
#         ]
#         Resource = "arn:aws:secretsmanager:*:*:secret:argocd/*"
#       }
#     ]
#   })
# }

# ============================================================================
# ベストプラクティス (Best Practices)
# ============================================================================
#
# 1. IAM ロールの最小権限原則:
#    - 機能に必要な最小限の権限のみを付与してください
#    - サービス固有のポリシーを作成してください
#
# 2. タグ付け戦略:
#    - 一貫したタグ付け規則を使用してください
#    - 環境、プロジェクト、コストセンターなどの標準タグを含めてください
#
# 3. RBAC の設定:
#    - グループベースのアクセス制御を使用してください
#    - 最小権限の原則に従ってください
#    - 定期的にアクセス権限を見直してください
#
# 4. ネットワークセキュリティ:
#    - 可能な限り VPC エンドポイントを使用してプライベートアクセスを実現してください
#    - ネットワークポリシーを適用してトラフィックを制限してください
#
# 5. 監視とロギング:
#    - CloudWatch Logs で機能のログを監視してください
#    - CloudTrail で API 呼び出しを追跡してください
#    - アラートを設定して異常を検出してください
#
# 6. GitOps ワークフロー:
#    - Git リポジトリを信頼できる唯一の情報源として使用してください
#    - ブランチ保護とコードレビューを実装してください
#    - 機密情報は Git にコミットせず、Secrets Manager を使用してください
#
# 7. マルチクラスター管理:
#    - 環境ごとに個別の機能インスタンスを作成することを検討してください
#    - クラスター間でポリシーと構成を標準化してください
#
# 8. バックアップと災害復旧:
#    - Git リポジトリのバックアップを定期的に実施してください
#    - 災害復旧計画を文書化してテストしてください

# ============================================================================
# 注意事項 (Important Notes)
# ============================================================================
#
# 1. 料金:
#    - EKS Capabilities は、Amazon EKS クラスター上でアクティブな時間数と、
#      管理される Kubernetes リソースの数に基づいて課金されます
#
# 2. リージョンの可用性:
#    - EKS Capabilities は、Amazon EKS が利用可能なすべての
#      AWS 商用リージョンで利用できます
#
# 3. 削除の動作:
#    - delete_propagation_policy = "RETAIN" を使用すると、機能を削除しても
#      クラスター内のカスタムリソースは保持されます
#    - 完全にクリーンアップするには、手動でリソースを削除する必要があります
#
# 4. アップグレード:
#    - 機能のバージョンは AWS によって自動的に管理されます
#    - メジャーアップグレードの前に、リリースノートを確認してください
#
# 5. Identity Center の要件:
#    - ArgoCD 機能を使用するには、AWS Identity Center が有効になっている必要があります
#    - 組織レベルで Identity Center を設定する必要があります
#
# 6. クラスターの互換性:
#    - すべての EKS コンピュートタイプ (EC2、Fargate) をサポートします
#    - Kubernetes バージョンの互換性を確認してください

