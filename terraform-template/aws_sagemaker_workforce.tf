################################################################################
# AWS SageMaker Workforce
################################################################################
# リソースタイプ: aws_sagemaker_workforce
# プロバイダーバージョン: 6.28.0
#
# 用途:
# Amazon SageMaker AI Workforceリソースを管理します。Workforceは、データのラベリングや
# レビュー作業を行うワーカーのグループです。プライベートワークフォース（従業員や専門家）を
# 作成し、Amazon Cognito または OIDC IdP で認証を管理できます。
#
# 主な使用ケース:
# - 機械学習モデルのトレーニングデータのラベリング作業
# - Amazon SageMaker Ground Truth でのデータラベリングジョブ
# - Amazon Augmented AI (A2I) でのヒューマンレビューワークフロー
# - 企業内の専門家によるデータ品質管理
#
# 制限事項:
# - 各AWSアカウントはリージョンごとに1つのプライベートワークフォースのみ作成可能
# - cognito_config と oidc_config は排他的（両方同時には使用不可）
# - Source IP設定では最大10個のCIDRブロックまで指定可能
#
# 参考ドキュメント:
# - https://docs.aws.amazon.com/sagemaker/latest/dg/sms-workforce-private.html
# - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/sagemaker_workforce
################################################################################

# Example 1: Cognito認証を使用したワークフォース（推奨：OIDC IdP不要な場合）
resource "aws_sagemaker_workforce" "cognito_example" {
  # ================================
  # 必須パラメータ
  # ================================

  # ワークフォース名（一意である必要があります）
  # 命名規則: 小文字、数字、ハイフンのみ使用可能
  workforce_name = "my-labeling-workforce"

  # ================================
  # Cognito認証設定（オプション - OIDC Configと排他的）
  # ================================

  # Amazon Cognitoユーザープールを使用してプライベートワークフォースを構成
  # 新規にSageMaker Ground Truth/A2Iを使い始める場合に推奨
  cognito_config {
    # CognitoユーザープールクライアントのクライアントID
    # 注意: generate_secret = true のクライアントを使用すること
    client_id = aws_cognito_user_pool_client.workforce.id

    # Cognitoユーザープールのプール ID
    # ワーカーの認証情報を管理するユーザープール
    user_pool = aws_cognito_user_pool_domain.workforce.user_pool_id
  }

  # ================================
  # ソースIP制限（オプション）
  # ================================

  # 特定のIPアドレスからのみワークフォースへのアクセスを許可
  # オフィスネットワークやVPNからのみアクセスを許可する場合に使用
  source_ip_config {
    # 許可するCIDRブロックのリスト（最大10個）
    # 例: 企業のオフィスIPアドレス範囲
    cidrs = [
      "203.0.113.0/24",   # オフィスネットワーク1
      "198.51.100.0/24",  # オフィスネットワーク2
    ]
  }

  # ================================
  # VPC設定（オプション）
  # ================================

  # VPCを使用してワークフォースを構成（プライベートアクセス制御）
  # VPC内部からのみアクセスを許可する場合に使用
  workforce_vpc_config {
    # VPC ID（ワークフォースが通信に使用するVPC）
    vpc_id = "vpc-12345678"

    # サブネットID（VPC内のサブネット - 複数指定可能）
    # 高可用性のため、複数のアベイラビリティゾーンにまたがるサブネットを推奨
    subnets = [
      "subnet-abcdef01",
      "subnet-abcdef02",
    ]

    # セキュリティグループID（VPCセキュリティグループ - 複数指定可能）
    # 指定するサブネットと同じVPCのセキュリティグループである必要があります
    security_group_ids = [
      "sg-12345678",
    ]
  }

  # ================================
  # リージョン指定（オプション）
  # ================================

  # このリソースを管理するリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用されます
  # region = "us-west-2"
}


# Example 2: OIDC認証を使用したワークフォース（独自のIdP使用時）
resource "aws_sagemaker_workforce" "oidc_example" {
  # ワークフォース名
  workforce_name = "my-oidc-workforce"

  # ================================
  # OIDC認証設定（オプション - Cognito Configと排他的）
  # ================================

  # 独自のOpenID Connect (OIDC) Identity Providerを使用してワークフォースを構成
  # 既存の企業IdP（Okta、Azure AD等）を使用する場合に選択
  oidc_config {
    # OIDC IdPの認可エンドポイント
    # 例: https://your-idp.com/oauth2/authorize
    authorization_endpoint = "https://your-idp.example.com/oauth2/authorize"

    # OIDC IdPのクライアントID
    # IdPで登録したアプリケーションのクライアントID
    client_id = "your-oidc-client-id"

    # OIDC IdPのクライアントシークレット（機密情報）
    # 注意: 環境変数やSecrets Managerから取得することを推奨
    # センシティブ情報のため、Terraformステートファイルでも暗号化される
    client_secret = var.oidc_client_secret # 直接記述せず、変数から取得

    # OIDC IdPの発行者URL
    # 例: https://your-idp.com
    issuer = "https://your-idp.example.com"

    # OIDC IdPのJSON Web Key Set (JWKS) URI
    # JWTトークンの検証に使用される公開鍵のURL
    # 例: https://your-idp.com/.well-known/jwks.json
    jwks_uri = "https://your-idp.example.com/.well-known/jwks.json"

    # OIDC IdPのログアウトエンドポイント
    # 例: https://your-idp.com/oauth2/logout
    logout_endpoint = "https://your-idp.example.com/oauth2/logout"

    # OIDC IdPのトークンエンドポイント
    # アクセストークンとIDトークンを取得するエンドポイント
    # 例: https://your-idp.com/oauth2/token
    token_endpoint = "https://your-idp.example.com/oauth2/token"

    # OIDC IdPのユーザー情報エンドポイント
    # ユーザーのプロフィール情報を取得するエンドポイント
    # 例: https://your-idp.com/oauth2/userInfo
    user_info_endpoint = "https://your-idp.example.com/oauth2/userInfo"

    # 認証リクエストの追加パラメータ（オプション）
    # カスタムIdPに固有の識別子をマップ形式で指定
    authentication_request_extra_params = {
      "prompt" = "login"
      "domain" = "example.com"
    }

    # スコープ（オプション）
    # クライアントアプリケーションがアクセスしたいユーザーデータの範囲を指定
    # デフォルト: "openid profile email"
    scope = "openid profile email groups"
  }
}


# Example 3: シンプルなCognito設定（最小構成）
resource "aws_sagemaker_workforce" "simple" {
  # 必須パラメータのみで構成
  workforce_name = "simple-workforce"

  cognito_config {
    client_id = aws_cognito_user_pool_client.simple.id
    user_pool = aws_cognito_user_pool.simple.id
  }
}


################################################################################
# 依存リソース例: Cognito User Pool（Example 1用）
################################################################################

resource "aws_cognito_user_pool" "workforce" {
  name = "sagemaker-workforce-pool"

  # パスワードポリシー
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  # 自動検証（メールアドレス）
  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "workforce" {
  name            = "sagemaker-workforce-client"
  user_pool_id    = aws_cognito_user_pool.workforce.id
  generate_secret = true # SageMaker Workforceでは必須

  # OAuth設定
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid", "profile", "email"]
  callback_urls                        = ["https://example.com/callback"]
}

resource "aws_cognito_user_pool_domain" "workforce" {
  domain       = "my-sagemaker-workforce"
  user_pool_id = aws_cognito_user_pool.workforce.id
}


################################################################################
# Outputs（参照用）
################################################################################

# ワークフォースのARN
# 他のSageMakerリソース（Labeling JobやHuman Task UI等）から参照可能
output "workforce_arn" {
  description = "The ARN of the SageMaker Workforce"
  value       = aws_sagemaker_workforce.cognito_example.arn
}

# ワークフォースID（名前と同じ）
output "workforce_id" {
  description = "The ID (name) of the SageMaker Workforce"
  value       = aws_sagemaker_workforce.cognito_example.id
}

# OIDCワークフォースのサブドメイン（OIDC使用時のみ）
# ワーカーがアクセスするSageMaker Ground Truthポータルのサブドメイン
output "workforce_subdomain" {
  description = "The subdomain for the OIDC Identity Provider"
  value       = aws_sagemaker_workforce.oidc_example.subdomain
}

# VPCエンドポイントID（VPC設定使用時のみ）
output "workforce_vpc_endpoint_id" {
  description = "The VPC endpoint ID for the workforce VPC"
  value       = try(aws_sagemaker_workforce.cognito_example.workforce_vpc_config[0].vpc_endpoint_id, null)
}


################################################################################
# 補足情報
################################################################################

# 【属性参照】
# - arn: ワークフォースのAmazon Resource Name
# - id: ワークフォース名
# - subdomain: OIDC IdP使用時のサブドメイン
# - workforce_vpc_config.0.vpc_endpoint_id: VPC Workforceサービスエンドポイント

# 【重要な注意事項】
# 1. リージョン制限:
#    - 各AWSアカウントでは、リージョンごとに1つのプライベートワークフォースのみ作成可能
#    - 複数のワークチームは同一ワークフォース内で作成できます
#
# 2. 認証方式の選択:
#    - cognito_config: 新規利用者や独自IdP不要な場合に推奨（シンプル）
#    - oidc_config: 既存の企業IdP（Okta、Azure AD等）と統合する場合
#    - 両方同時には使用できません（排他的）
#
# 3. セキュリティ考慮事項:
#    - OIDC client_secretはセンシティブ情報（Terraformステートで暗号化される）
#    - Source IP設定でアクセス元IPを制限可能（最大10 CIDR）
#    - VPC設定でプライベートネットワーク内に閉じた運用が可能
#
# 4. ワークチーム管理:
#    - ワークフォース作成後、aws_sagemaker_workteam リソースでワークチームを作成
#    - ワークチームに対してラベリングジョブを割り当てます
#
# 5. ワーカー招待:
#    - Cognitoを使用する場合、SageMakerコンソールまたはCognitoコンソールからワーカーを招待
#    - メールアドレスで最大100人のワーカーを一度に招待可能
#
# 6. 削除時の注意:
#    - ワークフォースを削除すると、関連するすべてのワークチームとワーカーも削除されます
#    - Ground TruthとAmazon A2Iでワークフォースを共有しているため、削除前に確認必須

# 【ベストプラクティス】
# - テスト目的では小規模なプライベートワークチームから開始
# - 本番環境ではSource IP制限またはVPC設定でアクセス制御を実施
# - OIDC client_secretは必ず変数または Secrets Manager から取得
# - 複数のアベイラビリティゾーンにまたがるサブネットを使用（VPC設定時）
# - ワーカーのパフォーマンス追跡にはSageMakerコンソールのメトリクスを活用
