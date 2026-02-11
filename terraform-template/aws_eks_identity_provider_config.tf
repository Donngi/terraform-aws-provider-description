#---------------------------------------------------------------
# EKS Identity Provider Configuration
#---------------------------------------------------------------
#
# Amazon EKS Identity Provider Configurationを管理します。
# OpenID Connect (OIDC) アイデンティティプロバイダーをEKSクラスターに
# 関連付けることで、AWS IAMの代替としてOIDCプロバイダーを使用した
# Kubernetesクラスターへの認証が可能になります。
#
# 1つのOIDCアイデンティティプロバイダーを1つのクラスターに関連付けることができます。
# アイデンティティプロバイダーの発行者URLは公開アクセス可能である必要があり、
# 自己署名証明書は使用できません。
#
# AWS公式ドキュメント:
#   - EKS OIDC認証: https://docs.aws.amazon.com/eks/latest/userguide/authenticate-oidc-identity-provider.html
#   - API Reference: https://docs.aws.amazon.com/eks/latest/APIReference/API_OidcIdentityProviderConfigRequest.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_identity_provider_config
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource \"aws_eks_identity_provider_config\" \"example\" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # EKSクラスターの名前
  # OIDCアイデンティティプロバイダーを関連付けるEKSクラスターを指定します。
  # クラスター作成後に関連付けを行うため、通常はaws_eks_cluster.nameを参照します。
  cluster_name = \"my-eks-cluster\"

  #---------------------------------------------------------------
  # OpenID Connect (OIDC) 設定ブロック（必須）
  #---------------------------------------------------------------
  # OIDCアイデンティティプロバイダーの設定を行います。
  # このブロックは必須であり、1つのみ指定可能です。

  oidc {
    # クライアントID（必須）
    # OIDCアイデンティティプロバイダーに認証リクエストを行う
    # クライアントアプリケーションのIDを指定します。
    # Azure AD、Okta、Auth0などのIDプロバイダーで発行されるクライアントIDを設定します。
    client_id = \"your-client-id\"

    # アイデンティティプロバイダー設定名（必須）
    # このOIDCプロバイダー設定を識別するための名前を指定します。
    # EKSクラスター内で一意である必要があります。
    identity_provider_config_name = \"example-oidc-provider\"

    # 発行者URL（必須）
    # OIDCアイデンティティプロバイダーのURLを指定します。
    # このURLにより、APIサーバーがトークン検証用の公開署名キーを検出できます。
    # - https://で始まる必要があります
    # - プロバイダーのOIDC IDトークン内の\"iss\"クレームに対応する必要があります
    # - \".well-known/openid-configuration\"の1レベル下を指すべきです
    # - インターネット経由で公開アクセス可能である必要があります
    # 例: https://oidc.eks.region.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE
    issuer_url = \"https://your-issuer-url\"

    # グループクレーム（オプション）
    # プロバイダーがグループを返すために使用するJWTクレームを指定します。
    # IDトークンに含まれるグループ情報を取得するクレーム名を設定します。
    # Kubernetes RBACでグループベースの認可を行う場合に使用します。
    # 例: \"groups\", \"cognito:groups\"など
    groups_claim = null

    # グループプレフィックス（オプション）
    # グループクレームに付加されるプレフィックスを指定します。
    # 既存の名前との衝突を防ぐため、グループ名の前に付加される文字列です。
    # 例: \"oidc:\"を設定すると、グループ名が\"oidc:developers\"のようになります。
    groups_prefix = null

    # 必須クレーム（オプション）
    # アイデンティティトークンに存在する必要があるクレームのキーと値のペアを指定します。
    # 各クレームは、トークン内に一致する値とともに存在することが検証されます。
    # 追加のセキュリティ要件として、特定のクレーム値を要求する場合に使用します。
    # 例: { \"aud\" = \"kubernetes\", \"email_verified\" = \"true\" }
    required_claims = null

    # ユーザー名クレーム（オプション）
    # ユーザー名として使用するJSON Web Token (JWT) クレームを指定します。
    # デフォルトは\"sub\"ですが、OIDCアイデンティティプロバイダーに応じて
    # \"email\"や\"name\"などの他のクレームを使用できます。
    # Kubernetes監査ログやRBACポリシーで使用されるユーザー識別子になります。
    username_claim = null

    # ユーザー名プレフィックス（オプション）
    # ユーザー名クレームに付加されるプレフィックスを指定します。
    # 既存の名前との衝突を防ぐため、ユーザー名の前に付加される文字列です。
    # すべてのプレフィックス付与を無効にする場合は\"-\"を指定します。
    # 例: \"oidc:\"を設定すると、ユーザー名が\"oidc:user@example.com\"のようになります。
    username_prefix = null
  }

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # リソースのタグ
  # リソースに適用するキーと値のペアのマップを指定します。
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # マッチするキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  # コスト管理、リソース管理、アクセス制御に使用されます。
  tags = {
    Environment = \"production\"
    ManagedBy   = \"terraform\"
  }

  # リージョン（オプション）
  # このリソースが管理されるAWSリージョンを指定します。
  # 省略した場合、プロバイダー設定で設定されたリージョンがデフォルトとして使用されます。
  # マルチリージョン構成で特定のリージョンにリソースを配置する場合に使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # タイムアウト設定（オプション）
  #---------------------------------------------------------------
  # リソースの作成・削除にかかる時間の上限を設定します。

  timeouts {
    # 作成タイムアウト
    # Identity Provider Configurationの作成操作のタイムアウト時間を指定します。
    # 形式: \"60m\" (分)、\"1h\" (時間) など
    # デフォルトは適切な値が設定されていますが、ネットワーク状況や
    # プロバイダーの応答時間により調整が必要な場合に使用します。
    create = null

    # 削除タイムアウト
    # Identity Provider Configurationの削除操作のタイムアウト時間を指定します。
    # 形式: \"60m\" (分)、\"1h\" (時間) など
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（設定不可）:
#
# - arn: EKS Identity Provider ConfigurationのAmazon Resource Name (ARN)
#        他のリソースでこのIdentity Provider Configurationを参照する際に使用
#
# - id: EKSクラスター名とEKS Identity Provider Configuration名をコロン(:)で
#       区切った形式の識別子
#       形式: \"cluster_name:identity_provider_config_name\"
#
# - status: EKS Identity Provider Configurationのステータス
#           値: CREATING, ACTIVE, DELETING
#           リソースの現在の状態を示します
#
# - tags_all: リソースに割り当てられたすべてのタグのマップ
#             プロバイダーのdefault_tags設定ブロックから継承されたタグも含みます
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# 完全な実装例:
#
# resource \"aws_eks_cluster\" \"example\" {
#   name     = \"my-cluster\"
#   role_arn = aws_iam_role.example.arn
#
#   vpc_config {
#     subnet_ids = aws_subnet.example[*].id
#   }
# }
#
# resource \"aws_eks_identity_provider_config\" \"example\" {
#   cluster_name = aws_eks_cluster.example.name
#
#   oidc {
#     client_id                     = \"kubernetes\"
#     identity_provider_config_name = \"azure-ad\"
#     issuer_url                    = \"https://sts.windows.net/tenant-id/\"
#     groups_claim                  = \"groups\"
#     groups_prefix                 = \"azure:\"
#     username_claim                = \"email\"
#     username_prefix               = \"azure:\"
#   }
#
#   tags = {
#     Environment = \"production\"
#     Team        = \"platform\"
#   }
# }
#
# # Identity Provider ARNを出力
# output \"identity_provider_arn\" {
#   value = aws_eks_identity_provider_config.example.arn
# }
#---------------------------------------------------------------
