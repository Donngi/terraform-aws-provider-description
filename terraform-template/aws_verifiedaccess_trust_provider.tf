#---------------------------------------------------------------
# AWS Verified Access Trust Provider
#---------------------------------------------------------------
#
# AWS Verified Access のトラストプロバイダーを管理するリソース。
# トラストプロバイダーは、ユーザー ID またはデバイスのセキュリティ状態を管理し、
# Verified Access に対してセキュリティ関連のデータを送信します。
#
# サポートされるトラストプロバイダーの種類:
# - ユーザーベース: IAM Identity Center または OIDC (OpenID Connect)
# - デバイスベース: Jamf, CrowdStrike, JumpCloud
#
# AWS公式ドキュメント:
#   - VerifiedAccessTrustProvider API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_VerifiedAccessTrustProvider.html
#   - Device trust providers: https://docs.aws.amazon.com/verified-access/latest/ug/device-trust.html
#   - CreateVerifiedAccessTrustProviderDeviceOptions: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateVerifiedAccessTrustProviderDeviceOptions.html
#   - ModifyVerifiedAccessTrustProvider: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyVerifiedAccessTrustProvider.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/verifiedaccess_trust_provider
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_verifiedaccess_trust_provider" "example" {

  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # policy_reference_name (Required)
  # 設定内容: ポリシールールで使用される識別子
  # 設定可能な値: 英数字とハイフンを含む文字列。アクセスポリシー内で trust context を
  #              参照する際の名前として使用される (例: "idc", "jamf", "okta" など)
  # 省略時: 必須項目のため指定が必要
  # 関連機能: Access Policies
  #   Verified Access でのポリシー評価時に使用される識別子
  #   https://docs.aws.amazon.com/verified-access/latest/ug/how-it-works.html
  policy_reference_name = "idc"

  # trust_provider_type (Required)
  # 設定内容: トラストプロバイダーのタイプ
  # 設定可能な値: "user" (ユーザーベース) または "device" (デバイスベース)
  # 省略時: 必須項目のため指定が必要
  # 関連機能: Trust Provider Types
  #   ユーザーまたはデバイスの信頼データを管理
  #   https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_VerifiedAccessTrustProvider.html
  trust_provider_type = "user"

  #-------------------------------------------------------------
  # オプション設定 - 基本設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: トラストプロバイダーの説明
  # 設定可能な値: 任意の説明文字列
  # 省略時: 説明なし
  description = "IAM Identity Center trust provider for corporate users"

  # region (Optional, Computed)
  # 設定内容: このリソースが管理されるリージョン
  # 設定可能な値: AWS リージョンコード (us-east-1, ap-northeast-1 など)
  # 省略時: プロバイダー設定のリージョンが使用される
  # 関連機能: Regional Endpoints
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  # tags (Optional)
  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のマップ (最大50タグ)
  # 省略時: タグなし
  tags = {
    Name        = "example-trust-provider"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # オプション設定 - ユーザートラストプロバイダー
  #-------------------------------------------------------------

  # user_trust_provider_type (Optional)
  # 設定内容: ユーザーベーストラストプロバイダーのタイプ
  # 設定可能な値: "iam-identity-center" または "oidc"
  # 省略時: trust_provider_type が "user" の場合は指定が推奨される
  # 関連機能: User Trust Provider Types
  #   IAM Identity Center または OIDC プロバイダーによるユーザー認証
  #   https://docs.aws.amazon.com/verified-access/latest/ug/how-it-works.html
  user_trust_provider_type = "iam-identity-center"

  #-------------------------------------------------------------
  # オプション設定 - デバイストラストプロバイダー
  #-------------------------------------------------------------

  # device_trust_provider_type (Optional)
  # 設定内容: デバイスベーストラストプロバイダーのタイプ
  # 設定可能な値: "jamf", "crowdstrike", "jumpcloud"
  # 省略時: trust_provider_type が "device" の場合は指定が必要
  # 関連機能: Device Trust Providers
  #   デバイスのセキュリティ状態を管理するサードパーティプロバイダー
  #   https://docs.aws.amazon.com/verified-access/latest/ug/device-trust.html
  # device_trust_provider_type = "jamf"

  #-------------------------------------------------------------
  # ネストブロック - device_options
  #-------------------------------------------------------------

  # device_options (Optional)
  # 設定内容: デバイス ID ベースのトラストプロバイダー向けオプション
  # 設定可能な値: tenant_id を含むブロック
  # 省略時: trust_provider_type が "device" の場合は設定が推奨される
  # 関連機能: Device Options
  #   デバイスプロバイダーのテナント設定
  #   https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateVerifiedAccessTrustProviderDeviceOptions.html

  # device_options {
  #   # tenant_id (Optional)
  #   # 設定内容: デバイス ID プロバイダーのテナントアプリケーション ID
  #   # 設定可能な値: プロバイダー固有のテナント識別子
  #   # 省略時: プロバイダーのデフォルト設定が使用される
  #   tenant_id = "your-tenant-id-from-device-provider"
  # }

  #-------------------------------------------------------------
  # ネストブロック - oidc_options
  #-------------------------------------------------------------

  # oidc_options (Optional)
  # 設定内容: OIDC タイプのユーザー ID ベーストラストプロバイダー向けの OpenID Connect 設定
  # 設定可能な値: OIDC プロバイダーのエンドポイント、クライアント情報を含むブロック
  # 省略時: user_trust_provider_type が "oidc" の場合は設定が必要
  # 関連機能: OIDC Trust Provider
  #   OpenID Connect プロバイダーとの統合設定
  #   https://docs.aws.amazon.com/verified-access/latest/ug/device-trust.html

  # oidc_options {
  #   # authorization_endpoint (Optional)
  #   # 設定内容: OIDC プロバイダーの認可エンドポイント URL
  #   # 設定可能な値: HTTPS URL (例: https://accounts.google.com/o/oauth2/v2/auth)
  #   # 省略時: プロバイダーの Issuer URL から自動検出される場合がある
  #   authorization_endpoint = "https://your-idp.example.com/authorize"
  #
  #   # client_id (Optional)
  #   # 設定内容: OIDC アプリケーションのクライアント ID
  #   # 設定可能な値: OIDC プロバイダーから発行されたクライアント識別子
  #   # 省略時: 認証が正常に機能しない
  #   client_id = "your-client-id"
  #
  #   # client_secret (Required when using oidc_options)
  #   # 設定内容: OIDC アプリケーションのクライアントシークレット (機密情報)
  #   # 設定可能な値: OIDC プロバイダーから発行されたシークレット文字列
  #   # 省略時: oidc_options ブロックを使用する場合は必須
  #   # 注意: Terraform State に平文で保存されるため、暗号化された State バックエンドを推奨
  #   client_secret = "your-client-secret"
  #
  #   # issuer (Optional)
  #   # 設定内容: OIDC プロバイダーの Issuer URL
  #   # 設定可能な値: HTTPS URL (例: https://accounts.google.com)
  #   # 省略時: OIDC Discovery が使用できない
  #   issuer = "https://your-idp.example.com"
  #
  #   # scope (Optional)
  #   # 設定内容: リクエストする OIDC スコープ
  #   # 設定可能な値: スペース区切りのスコープ文字列 (例: "openid profile email")
  #   # 省略時: デフォルトスコープ "openid" が使用される
  #   scope = "openid profile email"
  #
  #   # token_endpoint (Optional)
  #   # 設定内容: OIDC プロバイダーのトークンエンドポイント URL
  #   # 設定可能な値: HTTPS URL (例: https://oauth2.googleapis.com/token)
  #   # 省略時: プロバイダーの Issuer URL から自動検出される場合がある
  #   token_endpoint = "https://your-idp.example.com/oauth/token"
  #
  #   # user_info_endpoint (Optional)
  #   # 設定内容: OIDC プロバイダーのユーザー情報エンドポイント URL
  #   # 設定可能な値: HTTPS URL (例: https://openidconnect.googleapis.com/v1/userinfo)
  #   # 省略時: プロバイダーの Issuer URL から自動検出される場合がある
  #   user_info_endpoint = "https://your-idp.example.com/userinfo"
  # }

  #-------------------------------------------------------------
  # ネストブロック - native_application_oidc_options
  #-------------------------------------------------------------

  # native_application_oidc_options (Optional)
  # 設定内容: Native Application OIDC タイプのユーザー ID ベーストラストプロバイダー向け設定
  # 設定可能な値: ネイティブアプリケーション用の OIDC エンドポイント情報を含むブロック
  # 省略時: ネイティブアプリケーション統合を使用しない場合は不要
  # 関連機能: Native Application OIDC
  #   モバイルアプリなどのネイティブアプリケーション向け OIDC 統合
  #   https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyVerifiedAccessTrustProvider.html

  # native_application_oidc_options {
  #   # authorization_endpoint (Optional)
  #   # 設定内容: OIDC プロバイダーの認可エンドポイント URL
  #   # 設定可能な値: HTTPS URL
  #   # 省略時: プロバイダーの Issuer URL から自動検出される場合がある
  #   authorization_endpoint = "https://your-idp.example.com/authorize"
  #
  #   # client_id (Optional)
  #   # 設定内容: ネイティブアプリケーションのクライアント ID
  #   # 設定可能な値: OIDC プロバイダーから発行されたクライアント識別子
  #   # 省略時: 認証が正常に機能しない
  #   client_id = "your-native-app-client-id"
  #
  #   # client_secret (Required when using native_application_oidc_options)
  #   # 設定内容: ネイティブアプリケーションのクライアントシークレット (機密情報)
  #   # 設定可能な値: OIDC プロバイダーから発行されたシークレット文字列
  #   # 省略時: native_application_oidc_options ブロックを使用する場合は必須
  #   # 注意: Terraform State に平文で保存されるため、暗号化された State バックエンドを推奨
  #   client_secret = "your-native-app-client-secret"
  #
  #   # issuer (Optional)
  #   # 設定内容: OIDC プロバイダーの Issuer URL
  #   # 設定可能な値: HTTPS URL
  #   # 省略時: OIDC Discovery が使用できない
  #   issuer = "https://your-idp.example.com"
  #
  #   # public_signing_key_endpoint (Optional)
  #   # 設定内容: 公開署名鍵を取得するエンドポイント URL (JWKS エンドポイント)
  #   # 設定可能な値: HTTPS URL (例: https://your-idp.example.com/.well-known/jwks.json)
  #   # 省略時: プロバイダーの Issuer URL から自動検出される場合がある
  #   public_signing_key_endpoint = "https://your-idp.example.com/.well-known/jwks.json"
  #
  #   # scope (Optional)
  #   # 設定内容: リクエストする OIDC スコープ
  #   # 設定可能な値: スペース区切りのスコープ文字列 (例: "openid profile email")
  #   # 省略時: デフォルトスコープ "openid" が使用される
  #   scope = "openid profile email"
  #
  #   # token_endpoint (Optional)
  #   # 設定内容: OIDC プロバイダーのトークンエンドポイント URL
  #   # 設定可能な値: HTTPS URL
  #   # 省略時: プロバイダーの Issuer URL から自動検出される場合がある
  #   token_endpoint = "https://your-idp.example.com/oauth/token"
  #
  #   # user_info_endpoint (Optional)
  #   # 設定内容: OIDC プロバイダーのユーザー情報エンドポイント URL
  #   # 設定可能な値: HTTPS URL
  #   # 省略時: プロバイダーの Issuer URL から自動検出される場合がある
  #   user_info_endpoint = "https://your-idp.example.com/userinfo"
  # }

  #-------------------------------------------------------------
  # ネストブロック - sse_specification
  #-------------------------------------------------------------

  # sse_specification (Optional)
  # 設定内容: サーバーサイド暗号化 (SSE) の設定
  # 設定可能な値: カスタマー管理キーの使用有無と KMS キー ARN を含むブロック
  # 省略時: AWS 管理キーによる暗号化が使用される
  # 関連機能: Server-Side Encryption
  #   トラストプロバイダーデータの暗号化設定
  #   https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_VerifiedAccessTrustProvider.html

  # sse_specification {
  #   # customer_managed_key_enabled (Optional)
  #   # 設定内容: カスタマー管理 KMS キーを使用するかどうか
  #   # 設定可能な値: true (カスタマー管理キーを使用) または false (AWS 管理キーを使用)
  #   # 省略時: false (AWS 管理キーが使用される)
  #   customer_managed_key_enabled = true
  #
  #   # kms_key_arn (Optional)
  #   # 設定内容: 使用する KMS キーの ARN
  #   # 設定可能な値: KMS キーの ARN (customer_managed_key_enabled が true の場合に指定)
  #   # 省略時: customer_managed_key_enabled が true の場合はエラー
  #   # 関連機能: AWS KMS
  #   #   暗号化に使用する KMS キーの管理
  #   #   https://docs.aws.amazon.com/kms/latest/developerguide/overview.html
  #   kms_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  # }

  #-------------------------------------------------------------
  # ネストブロック - timeouts
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: Terraform の操作タイムアウト設定
  # 設定可能な値: create, update, delete の各操作のタイムアウト時間
  # 省略時: デフォルトのタイムアウト値が使用される

  # timeouts {
  #   # create (Optional)
  #   # 設定内容: リソース作成のタイムアウト時間
  #   # 設定可能な値: 時間文字列 (例: "30m", "1h")
  #   # 省略時: デフォルト値が使用される
  #   create = "30m"
  #
  #   # update (Optional)
  #   # 設定内容: リソース更新のタイムアウト時間
  #   # 設定可能な値: 時間文字列 (例: "30m", "1h")
  #   # 省略時: デフォルト値が使用される
  #   update = "30m"
  #
  #   # delete (Optional)
  #   # 設定内容: リソース削除のタイムアウト時間
  #   # 設定可能な値: 時間文字列 (例: "30m", "1h")
  #   # 省略時: デフォルト値が使用される
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# - id: AWS Verified Access トラストプロバイダーの ID (vatp-xxxxxxxxx 形式)
# - tags_all: リソースに割り当てられたすべてのタグ (プロバイダーのデフォルトタグを含む)
#---------------------------------------------------------------
