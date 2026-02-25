#---------------------------------------
# EKS Identity Provider Configuration
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-17
#
# EKSクラスターにOpenID Connect（OIDC）アイデンティティプロバイダーを統合し、
# Kubernetesのユーザー認証とアクセス制御を外部のIDプロバイダーで管理できます。
#
# 主な用途:
# - 企業のSSOシステムとEKSクラスターの統合
# - OIDC準拠のIDプロバイダー（Okta、Azure AD、Auth0など）による認証
# - Kubernetes RBACと連携したきめ細かいアクセス制御
#
# 制限事項:
# - 各EKSクラスターに対して複数のIDプロバイダーを設定可能
# - OIDC形式のみサポート（SAMLなどは非対応）
# - IDプロバイダーの設定変更には再作成が必要な場合あり
#
# NOTE: このテンプレートは参考例です。実際の使用時は環境に応じて値を調整してください。
#
# 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_eks_identity_provider_config

resource "aws_eks_identity_provider_config" "example" {
  #-------
  # 基本設定
  #-------
  # 設定内容: IDプロバイダーを統合するEKSクラスターの名前
  # 注意事項: 既存のEKSクラスター名を指定する必要があり、変更時は再作成が必要
  cluster_name = "example-cluster"

  #-------
  # OpenID Connect設定
  #-------
  oidc {
    # 設定内容: アイデンティティプロバイダーの一意の設定名
    # 注意事項: クラスター内で一意である必要があり、変更時は再作成が必要
    identity_provider_config_name = "example-oidc"

    # 設定内容: OIDCクライアントID（アプリケーションID）
    # 注意事項: IDプロバイダーで発行されたクライアントIDを指定
    client_id = "your-client-id"

    # 設定内容: OIDCプロバイダーの発行者URL
    # 形式: HTTPS URL（例: https://oidc.example.com）
    # 注意事項: IDプロバイダーのディスカバリーエンドポイントとして機能するURLを指定
    issuer_url = "https://oidc.example.com"

    # 設定内容: グループ情報を含むJWTクレーム名
    # 省略時: グループ情報は使用されない
    # 注意事項: Kubernetes RBACでグループベースのアクセス制御を行う場合に指定
    # groups_claim = "groups"

    # 設定内容: グループ名に付与するプレフィックス
    # 省略時: プレフィックスなし
    # 用途: Kubernetesの既存グループとの名前衝突を回避
    # groups_prefix = "oidc:"

    # 設定内容: ユーザー名として使用するJWTクレーム名
    # 省略時: subクレームが使用される
    # 設定可能な値: email, name, preferred_username など
    # username_claim = "email"

    # 設定内容: ユーザー名に付与するプレフィックス
    # 省略時: プレフィックスなし
    # 用途: Kubernetesの既存ユーザーとの名前衝突を回避
    # username_prefix = "oidc:"

    # 設定内容: トークンに必須のクレームとその値のマップ
    # 省略時: 追加の検証なし
    # 用途: 特定の条件を満たすトークンのみを受け入れる（例: 特定のドメインのユーザーのみ）
    # required_claims = {
    #   "hd" = "example.com"
    # }
  }

  #-------
  # リソース管理
  #-------
  # 設定内容: リソースに付与するタグ
  # 用途: リソースの分類、コスト配分、管理の簡素化
  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  #-------
  # 地域設定
  #-------
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意事項: EKSクラスターと同じリージョンを指定する必要がある
  region = "ap-northeast-1"

  #-------
  # タイムアウト設定
  #-------
  # timeouts {
  #   # 設定内容: IDプロバイダー設定の作成タイムアウト
  #   # 省略時: 40分
  #   # create = "40m"

  #   # 設定内容: IDプロバイダー設定の削除タイムアウト
  #   # 省略時: 40分
  #   # delete = "40m"
  # }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# arn - IDプロバイダー設定のARN
# id - クラスター名とIDプロバイダー設定名をコロンで結合した識別子（例: cluster-name:config-name）
# status - IDプロバイダー設定のステータス（ACTIVE、CREATING、DELETINGなど）
# tags_all - リソースに割り当てられたすべてのタグ（プロバイダーのdefault_tagsを含む）
