#---------------------------------------------------------------
# AWS EKS Identity Provider Configuration
#---------------------------------------------------------------
#
# Amazon EKSクラスターにOpenID Connect (OIDC) アイデンティティプロバイダーを
# 関連付けるリソースです。OIDCプロバイダーをEKSクラスターに統合することで、
# 外部IDプロバイダー (Okta, Azure AD, Auth0, Google Workspace, Keycloak等) を
# 利用したKubernetesユーザー認証およびKubernetes RBACと連携したアクセス制御を
# 実現できます。
#
# AWS公式ドキュメント:
#   - OIDC IDプロバイダーをクラスターに関連付ける: https://docs.aws.amazon.com/eks/latest/userguide/authenticate-oidc-identity-provider.html
#   - EKSクラスター認証: https://docs.aws.amazon.com/eks/latest/userguide/cluster-auth.html
#   - AssociateIdentityProviderConfig API: https://docs.aws.amazon.com/eks/latest/APIReference/API_AssociateIdentityProviderConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_identity_provider_config
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_eks_identity_provider_config" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # cluster_name (Required, Forces new resource)
  # 設定内容: IDプロバイダー設定を関連付けるEKSクラスターの名前を指定します。
  # 設定可能な値: 既存のEKSクラスター名
  # 注意: 変更時はリソースの再作成が必要となります。
  # 参考: https://docs.aws.amazon.com/eks/latest/userguide/clusters.html
  cluster_name = "example-cluster"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: ap-northeast-1, us-east-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: 関連付け対象のEKSクラスターと同じリージョンを指定する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # OIDC アイデンティティプロバイダー設定
  #-------------------------------------------------------------
  # OIDCプロバイダーの詳細設定を定義するブロック。
  # min_items=1, max_items=1のため必ず1つだけ指定する必要があります。
  # ブロック内の各属性は変更時にリソースの再作成が必要です。

  oidc {
    # identity_provider_config_name (Required, Forces new resource)
    # 設定内容: アイデンティティプロバイダー設定の一意な名前を指定します。
    # 設定可能な値: クラスター内で一意な文字列
    # 注意: クラスター内で一意である必要があり、変更時は再作成が必要です。
    identity_provider_config_name = "example-oidc"

    # issuer_url (Required, Forces new resource)
    # 設定内容: OIDCプロバイダーのIssuer URL (発行者URL) を指定します。
    # 設定可能な値: HTTPSスキームの有効なURL (例: https://oidc.example.com)
    # 関連機能: OIDC Discovery
    #   このURLからOIDCディスカバリードキュメント (.well-known/openid-configuration) を
    #   取得し、JWKSエンドポイント等のメタデータを解決します。
    #   - https://openid.net/specs/openid-connect-discovery-1_0.html
    # 注意: HTTPSのみサポート。変更時は再作成が必要です。
    issuer_url = "https://oidc.example.com"

    # client_id (Required, Forces new resource)
    # 設定内容: OIDCプロバイダーで発行されたクライアントID (Audience) を指定します。
    # 設定可能な値: IDプロバイダー側で発行された任意の文字列
    # 関連機能: OIDC Audience検証
    #   発行されたIDトークンの aud クレームと照合され、想定されたクライアント宛の
    #   トークンであることを検証します。
    #   - https://docs.aws.amazon.com/eks/latest/userguide/authenticate-oidc-identity-provider.html
    # 注意: 変更時は再作成が必要です。
    client_id = "your-client-id"

    # username_claim (Optional, Forces new resource)
    # 設定内容: KubernetesユーザーIDとして使用するJWTクレームの名前を指定します。
    # 設定可能な値: JWTクレーム名 (例: email, sub, name, preferred_username)
    # 省略時: sub クレームが使用されます。
    # 注意: 変更時は再作成が必要です。
    username_claim = "email"

    # username_prefix (Optional, Forces new resource)
    # 設定内容: ユーザー名に付与するプレフィックスを指定します。
    # 設定可能な値: 任意の文字列
    # 省略時: プレフィックスなし
    # 用途: Kubernetesの既存ユーザーやサービスアカウント名との衝突回避に使用します。
    # 注意:
    #   - "system:" プレフィックスは予約されているため使用不可。
    #   - "-" を指定するとプレフィックスは付与されません。
    #   - 変更時は再作成が必要です。
    username_prefix = "oidc:"

    # groups_claim (Optional, Forces new resource)
    # 設定内容: Kubernetesグループ情報を取得するJWTクレームの名前を指定します。
    # 設定可能な値: グループ情報を含むJWTクレーム名 (例: groups)
    # 省略時: グループ情報は使用されません。
    # 用途: Kubernetes RBACでグループベースの権限制御を行う際に指定します。
    # 注意: 変更時は再作成が必要です。
    groups_claim = "groups"

    # groups_prefix (Optional, Forces new resource)
    # 設定内容: グループ名に付与するプレフィックスを指定します。
    # 設定可能な値: 任意の文字列
    # 省略時: プレフィックスなし
    # 用途: Kubernetesの既存グループ名との衝突回避に使用します。
    # 注意:
    #   - "system:" プレフィックスは予約されているため使用不可。
    #   - 変更時は再作成が必要です。
    groups_prefix = "oidc:"

    # required_claims (Optional, Forces new resource)
    # 設定内容: IDトークンに含まれていなければならないクレームと値のマップを指定します。
    # 設定可能な値: クレーム名と期待値のマップ (最大20エントリまで)
    # 省略時: 追加のクレーム検証なし
    # 用途: 特定の条件を満たすトークンのみを認証許可する場合に使用 (例: 特定のドメイン
    #       のユーザーのみ許可、特定のテナント所属者のみ許可)
    # 注意: 変更時は再作成が必要です。
    required_claims = {
      "hd" = "example.com"
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/eks/latest/userguide/eks-using-tags.html
  tags = {
    Name        = "example-oidc"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------
  # IDプロバイダー設定の関連付け・解除はEKSコントロールプレーンで非同期に実行されるため、
  # デフォルトのタイムアウトでは完了しないケースがあります。

  timeouts {
    # create (Optional)
    # 設定内容: IDプロバイダー設定作成時のタイムアウトを指定します。
    # 設定可能な値: Go duration形式の文字列 (例: "40m", "1h")
    # 省略時: 40分
    create = "40m"

    # delete (Optional)
    # 設定内容: IDプロバイダー設定削除時のタイムアウトを指定します。
    # 設定可能な値: Go duration形式の文字列 (例: "40m", "1h")
    # 省略時: 40分
    delete = "40m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: アイデンティティプロバイダー設定のAmazon Resource Name (ARN)
# - id: クラスター名とIDプロバイダー設定名をコロンで結合した識別子 (例: cluster-name:config-name)
# - identity_provider_config_name: ルートレベルでエクスポートされるIDプロバイダー設定名
# - status: IDプロバイダー設定のステータス (CREATING, ACTIVE, DELETING 等)
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
