#---------------------------------------------------------------
# AWS SageMaker Workforce
#---------------------------------------------------------------
#
# Amazon SageMaker Ground Truth のプライベートワークフォースをプロビジョニングするリソースです。
# ワークフォースは、データラベリングジョブや人間によるレビュータスクを実行する
# ワーカーのグループです。認証プロバイダーとして Amazon Cognito または
# 独自の OIDC IdP を使用できます。1 AWSアカウント・1リージョンにつき
# ワークフォースは1つのみ作成できます。
#
# AWS公式ドキュメント:
#   - ワークフォース認証と制限: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-security-workforce-authentication.html
#   - プライベートワークフォースの作成（OIDC IdP）: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-workforce-create-private-oidc.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_workforce
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_workforce" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # workforce_name (Required, Forces new resource)
  # 設定内容: ワークフォースの一意な名前を指定します。
  # 設定可能な値: 英数字およびハイフンを含む文字列
  # 注意: 1 AWSアカウント・1リージョンにつきワークフォースは1つのみ作成可能です。
  workforce_name = "example-workforce"

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
  # Cognito 認証設定
  #-------------------------------------------------------------

  # cognito_config (Optional)
  # 設定内容: Amazon Cognito をプライベートワークフォースの認証プロバイダーとして
  #   設定するブロックです。Cognito ユーザープールと 1 対 1 で対応します。
  # 注意: oidc_config と排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-workforce-create-private-console.html
  cognito_config {

    # client_id (Required)
    # 設定内容: Amazon Cognito ユーザープールのクライアント ID を指定します。
    # 設定可能な値: 有効な Cognito ユーザープールクライアント ID
    client_id = "example-cognito-client-id"

    # user_pool (Required)
    # 設定内容: Amazon Cognito ユーザープールの ID を指定します。
    # 設定可能な値: 有効な Cognito ユーザープール ID（例: ap-northeast-1_xxxxxxxxx）
    user_pool = "ap-northeast-1_xxxxxxxxx"
  }

  #-------------------------------------------------------------
  # OIDC 認証設定
  #-------------------------------------------------------------

  # oidc_config (Optional)
  # 設定内容: 独自の OIDC Identity Provider を使用してプライベートワークフォースを
  #   設定するブロックです。IdP はグループをサポートしている必要があります。
  # 注意: cognito_config と排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-workforce-create-private-oidc.html
  # oidc_config {

    # authorization_endpoint (Required)
    # 設定内容: OIDC IdP の認可エンドポイント URL を指定します。
    # 設定可能な値: 有効な HTTPS URL
    # authorization_endpoint = "https://your-idp.example.com/oauth2/authorize"

    # client_id (Required)
    # 設定内容: OIDC IdP のクライアント ID を指定します。
    # 設定可能な値: IdP で発行されたクライアント ID 文字列
    # client_id = "your-oidc-client-id"

    # client_secret (Required, Sensitive)
    # 設定内容: OIDC IdP のクライアントシークレットを指定します。
    # 設定可能な値: IdP で発行されたクライアントシークレット文字列
    # 注意: センシティブな値です。tfvars や Secrets Manager 等で管理してください。
    # client_secret = "your-oidc-client-secret"

    # issuer (Required)
    # 設定内容: OIDC IdP の発行者 (Issuer) URL を指定します。
    # 設定可能な値: 有効な HTTPS URL
    # issuer = "https://your-idp.example.com"

    # jwks_uri (Required)
    # 設定内容: OIDC IdP の JSON Web Key Set (JWKS) URI を指定します。
    #   SageMaker が IdP のトークン署名を検証するために使用します。
    # 設定可能な値: 有効な HTTPS URL
    # jwks_uri = "https://your-idp.example.com/.well-known/jwks.json"

    # logout_endpoint (Required)
    # 設定内容: OIDC IdP のログアウトエンドポイント URL を指定します。
    # 設定可能な値: 有効な HTTPS URL
    # logout_endpoint = "https://your-idp.example.com/oauth2/logout"

    # token_endpoint (Required)
    # 設定内容: OIDC IdP のトークンエンドポイント URL を指定します。
    # 設定可能な値: 有効な HTTPS URL
    # token_endpoint = "https://your-idp.example.com/oauth2/token"

    # user_info_endpoint (Required)
    # 設定内容: OIDC IdP のユーザー情報エンドポイント URL を指定します。
    #   sagemaker:groups クレームを含む JSON を返す必要があります。
    # 設定可能な値: 有効な HTTPS URL
    # user_info_endpoint = "https://your-idp.example.com/oauth2/userInfo"

    # authentication_request_extra_params (Optional)
    # 設定内容: カスタム IdP に固有の識別子のキーと値のマップを指定します。
    #   認証リクエストに追加のパラメーターを付与する場合に使用します。
    # 設定可能な値: 文字列のキーバリューマップ
    # 省略時: 追加パラメーターなし
    # authentication_request_extra_params = {
    #   "acr_values" = "urn:mace:incommon:iap:silver"
    # }

    # scope (Optional)
    # 設定内容: クライアントアプリケーションがアクセスするユーザーデータや
    #   クレームを参照するためのスコープ識別子の配列を指定します。
    # 設定可能な値: スペース区切りのスコープ文字列（例: "openid email profile"）
    # 省略時: デフォルトのスコープを使用
    # scope = "openid email profile"
  # }

  #-------------------------------------------------------------
  # IPアドレス制限設定
  #-------------------------------------------------------------

  # source_ip_config (Optional)
  # 設定内容: プライベートワークフォースへのアクセスを許可する IP アドレス範囲の
  #   リストを設定するブロックです。
  # 省略時: IP アドレスによる制限なし
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-security-workforce-authentication.html
  source_ip_config {

    # cidrs (Required)
    # 設定内容: アクセスを許可する CIDR 形式の IP アドレス範囲のセットを指定します。
    # 設定可能な値: 最大 10 個の CIDR 値のセット（例: ["203.0.113.0/24", "198.51.100.0/24"]）
    cidrs = ["203.0.113.0/24"]
  }

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # workforce_vpc_config (Optional)
  # 設定内容: VPC を使用してワークフォースを設定するブロックです。
  #   ワーカーポータルへのアクセスを VPC 経由に制限する場合に使用します。
  # 省略時: VPC設定なし
  workforce_vpc_config {

    # vpc_id (Optional)
    # 設定内容: ワークフォースが通信に使用する VPC の ID を指定します。
    # 設定可能な値: 有効な VPC ID（例: vpc-0123456789abcdef0）
    # 省略時: VPC を使用しない
    vpc_id = "vpc-0123456789abcdef0"

    # subnets (Optional)
    # 設定内容: 接続する VPC 内のサブネット ID のセットを指定します。
    # 設定可能な値: 有効なサブネット ID のセット
    # 省略時: サブネット指定なし
    subnets = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]

    # security_group_ids (Optional)
    # 設定内容: ワークフォースに関連付ける VPC セキュリティグループ ID のセットを指定します。
    #   指定するセキュリティグループは vpc_id で指定した VPC と同じである必要があります。
    # 設定可能な値: 有効なセキュリティグループ ID のセット
    # 省略時: セキュリティグループ指定なし
    security_group_ids = ["sg-0123456789abcdef0"]
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ワークフォースに割り当てられた Amazon Resource Name (ARN)
# - id: ワークフォースの名前
# - subdomain: OIDC Identity Provider のサブドメイン
# - workforce_vpc_config[0].vpc_endpoint_id: VPC ワークフォースの VPC サービスエンドポイント ID
#---------------------------------------------------------------
