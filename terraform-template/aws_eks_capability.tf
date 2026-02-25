#---------------------------------------
# EKS Capability
#---------------------------------------
# EKSクラスタに対してCapability（機能拡張）を管理するリソース。
# ArgoCD、ACK（AWS Controllers for Kubernetes）、KRO（Kubernetes Resource Operator）などの
# マネージド機能をEKSクラスタに統合できます。
#
# Terraform AWS Provider Version: 6.28.0
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/eks_capability
#
# NOTE: このファイルはテンプレートです。実際の環境に合わせて値を変更してください。

#---------------------------------------
# 基本設定
#---------------------------------------
resource "aws_eks_capability" "example" {
  # 設定内容: Capabilityの名前（クラスタ内で一意である必要がある）
  # 設定可能な値: 任意の文字列（クラスタ内で重複しない名前）
  capability_name = "argocd"

  # 設定内容: EKSクラスタの名前
  # 設定可能な値: 既存のEKSクラスタ名
  cluster_name = "example-cluster"

  # 設定内容: Capabilityのタイプ
  # 設定可能な値: ACK, KRO, ARGOCD
  type = "ARGOCD"

  # 設定内容: Capabilityに関連付けるIAMロールのARN
  # 設定可能な値: IAMロールのARN
  role_arn = "arn:aws:iam::123456789012:role/example-eks-capability-role"

  # 設定内容: 削除時の伝播ポリシー
  # 設定可能な値: RETAIN（削除時にリソースを保持）
  delete_propagation_policy = "RETAIN"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-west-2"

  #---------------------------------------
  # ArgoCD設定
  #---------------------------------------
  configuration {
    argo_cd {
      # 設定内容: ArgoCDをデプロイするKubernetesネームスペース
      # 省略時: デフォルトのネームスペースを使用
      namespace = "argocd"

      #---------------------------------------
      # AWS IAM Identity Center統合
      #---------------------------------------
      aws_idc {
        # 設定内容: IAM Identity CenterインスタンスのARN
        # 設定可能な値: IAM Identity CenterインスタンスARN
        idc_instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef0"

        # 設定内容: IAM Identity Centerインスタンスのリージョン
        # 省略時: 自動的に検出されたリージョンを使用
        # idc_region = "us-east-1"
      }

      #---------------------------------------
      # ネットワークアクセス設定
      #---------------------------------------
      # network_access {
      #   # 設定内容: VPCエンドポイントのIDリスト
      #   # 設定可能な値: VPCエンドポイントIDのセット
      #   vpce_ids = [
      #     "vpce-0123456789abcdef0",
      #     "vpce-0fedcba9876543210"
      #   ]
      # }

      #---------------------------------------
      # RBACロールマッピング
      #---------------------------------------
      # rbac_role_mapping {
      #   # 設定内容: ArgoCDのロール
      #   # 設定可能な値: ADMIN, EDITOR, VIEWER
      #   role = "ADMIN"
      #
      #   identity {
      #     # 設定内容: IDアイデンティティのID
      #     # 設定可能な値: SSOユーザーまたはグループのID
      #     id = "user-id-1234"
      #
      #     # 設定内容: アイデンティティのタイプ
      #     # 設定可能な値: SSO_USER, SSO_GROUP
      #     type = "SSO_USER"
      #   }
      #
      #   identity {
      #     id   = "group-id-5678"
      #     type = "SSO_GROUP"
      #   }
      # }
      #
      # rbac_role_mapping {
      #   role = "VIEWER"
      #
      #   identity {
      #     id   = "user-id-9999"
      #     type = "SSO_USER"
      #   }
      # }
    }
  }

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のペア（最大50個）
  tags = {
    Name        = "example-argocd-capability"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------
  # timeouts {
  #   # 設定内容: 作成処理のタイムアウト時間
  #   # 省略時: デフォルトのタイムアウト時間を使用
  #   create = "30m"
  #
  #   # 設定内容: 更新処理のタイムアウト時間
  #   # 省略時: デフォルトのタイムアウト時間を使用
  #   update = "30m"
  #
  #   # 設定内容: 削除処理のタイムアウト時間
  #   # 省略時: デフォルトのタイムアウト時間を使用
  #   delete = "30m"
  # }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# arn - CapabilityのARN
# version - Capabilityのバージョン
# tags_all - プロバイダーのdefault_tagsを含む全てのタグ
# configuration.0.argo_cd.0.server_url - Argo CDサーバーのURL
# configuration.0.argo_cd.0.aws_idc.0.idc_managed_application_arn - IAM Identity CenterマネージドアプリケーションのARN
