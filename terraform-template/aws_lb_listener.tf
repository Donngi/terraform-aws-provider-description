#---------------------------------------------------------------
# AWS LB Listener (Application / Network / Gateway Load Balancer)
#---------------------------------------------------------------
#
# Application Load Balancer (ALB)、Network Load Balancer (NLB)、
# および Gateway Load Balancer (GWLB) のリスナーを管理するリソースです。
# リスナーはロードバランサーに対する受信接続リクエストをチェックし、
# デフォルトアクションのルールに基づいてリクエストをルーティングします。
#
# 主な機能:
#   - HTTPSリスナーでのSSL/TLS終端
#   - Cognito / OIDCを使用した認証アクション
#   - JWT検証による認可 (NLB)
#   - リクエストを複数のターゲットグループに重み付き転送
#   - 固定レスポンスやリダイレクトアクション
#   - 相互TLS認証 (mTLS)
#   - ALBリクエスト/レスポンスHTTPヘッダーのカスタマイズ
#
# Note: NLBでTLSリスナーを作成する場合は certificate_arn と ssl_policy が必要です。
#       ALBのHTTPSリスナーでも同様に certificate_arn が必要です。
#
# AWS公式ドキュメント:
#   - リスナー: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html
#   - NLBリスナー: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-listeners.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_listener" "example" {
  #-------------------------------------------------------------
  # ロードバランサー設定
  #-------------------------------------------------------------

  # load_balancer_arn (Required)
  # 設定内容: リスナーを関連付けるロードバランサーのARNを指定します。
  # 設定可能な値: aws_lb または aws_alb リソースのARN
  load_balancer_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:loadbalancer/app/example/1234567890123456"

  #-------------------------------------------------------------
  # プロトコル・ポート設定
  #-------------------------------------------------------------

  # port (Optional)
  # 設定内容: リスナーが受け付けるポート番号を指定します。
  # 設定可能な値: 1-65535の整数
  # 省略時: プロトコルがGENEVEの場合は省略可能
  port = 443

  # protocol (Optional)
  # 設定内容: リスナーが受け付けるプロトコルを指定します。
  # 設定可能な値:
  #   ALBの場合: "HTTP", "HTTPS"
  #   NLBの場合: "TCP", "UDP", "TLS", "TCP_UDP"
  #   GWLBの場合: "GENEVE"
  # 省略時: "HTTP"（ALB）、Terraformが推測（NLB）
  protocol = "HTTPS"

  #-------------------------------------------------------------
  # SSL / TLS設定
  #-------------------------------------------------------------

  # certificate_arn (Optional)
  # 設定内容: SSL/TLS証明書のARNを指定します。
  # 設定可能な値: ACM (aws_acm_certificate) または IAM サーバー証明書のARN
  # 省略時: プロトコルが HTTPS または TLS の場合は必須
  # 注意: 追加の証明書は aws_lb_listener_certificate リソースで管理します。
  certificate_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  # ssl_policy (Optional)
  # 設定内容: HTTPS/TLSリスナーのSSLネゴシエーションポリシー名を指定します。
  # 設定可能な値: ELBSecurityPolicy-TLS13-1-2-2021-06、ELBSecurityPolicy-2016-08 等
  # 省略時: "ELBSecurityPolicy-2016-08"
  # 参考: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html#describe-ssl-policies
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  # alpn_policy (Optional)
  # 設定内容: NLBのTLSリスナーに対するALPN (Application-Layer Protocol Negotiation) ポリシーを指定します。
  # 設定可能な値:
  #   - "HTTP1Only": HTTP/1.1のみ
  #   - "HTTP2Only": HTTP/2のみ
  #   - "HTTP2Optional": クライアントが優先するプロトコルをネゴシエート（HTTP/2優先）
  #   - "HTTP2Preferred": HTTP/2を優先（フォールバックあり）
  #   - "None": ALPNなし
  # 省略時: プロトコルが TLS の NLBリスナーのみ有効
  alpn_policy = null

  #-------------------------------------------------------------
  # TCP接続設定
  #-------------------------------------------------------------

  # tcp_idle_timeout_seconds (Optional)
  # 設定内容: TCPアイドル接続のタイムアウト値（秒）を指定します。
  # 設定可能な値: 60-6000の整数
  # 省略時: プロバイダーデフォルト値を使用
  # 注意: NLBのTCPおよびTLS リスナーのみ有効です。
  tcp_idle_timeout_seconds = null

  #-------------------------------------------------------------
  # デフォルトアクション設定
  #-------------------------------------------------------------

  default_action {
    # type (Required)
    # 設定内容: ルーティングアクションのタイプを指定します。
    # 設定可能な値:
    #   - "forward": 1つ以上のターゲットグループにリクエストを転送
    #   - "redirect": 別のURLにリダイレクト
    #   - "fixed-response": カスタムHTTPレスポンスを返す（ALBのみ）
    #   - "authenticate-cognito": Cognitoで認証（ALBのみ）
    #   - "authenticate-oidc": OIDCで認証（ALBのみ）
    type = "forward"

    # target_group_arn (Optional)
    # 設定内容: type が "forward" の場合に転送先ターゲットグループのARNを指定します。
    # 設定可能な値: aws_lb_target_group リソースのARN
    # 省略時: forward ブロックを使用する場合は不要
    # 注意: 複数ターゲットグループへの重み付き転送には forward ブロックを使用してください。
    target_group_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:targetgroup/example/1234567890123456"

    # order (Optional)
    # 設定内容: アクションの評価順序を指定します。
    # 設定可能な値: 1-50000の整数
    # 省略時: Terraformが自動的に割り当て
    order = null
  }

  #-------------------------------------------------------------
  # 重み付きフォワード設定
  #-------------------------------------------------------------

  # forward ブロックを使用すると複数のターゲットグループへの
  # 重み付き転送やスティッキーセッションを設定できます。
  # target_group_arn と forward は同時に指定できません。

  # default_action {
  #   type = "forward"
  #
  #   forward {
  #     # target_group (Required, min:1, max:5)
  #     # 設定内容: 転送先ターゲットグループとその重みを指定します。
  #     target_group {
  #       # arn (Required)
  #       # 設定内容: ターゲットグループのARNを指定します。
  #       arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:targetgroup/example-v1/1234567890123456"
  #
  #       # weight (Optional)
  #       # 設定内容: このターゲットグループへのトラフィックの重みを指定します。
  #       # 設定可能な値: 0-999の整数
  #       # 省略時: 1
  #       weight = 80
  #     }
  #
  #     target_group {
  #       arn    = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:targetgroup/example-v2/1234567890123456"
  #       weight = 20
  #     }
  #
  #     #-----------------------------------------------------------
  #     # スティッキーセッション設定
  #     #-----------------------------------------------------------
  #     # stickiness {
  #     #   # duration (Required)
  #     #   # 設定内容: スティッキーセッションの有効期間（秒）を指定します。
  #     #   # 設定可能な値: 1-604800の整数
  #     #   duration = 86400
  #     #
  #     #   # enabled (Optional)
  #     #   # 設定内容: スティッキーセッションを有効にするかを指定します。
  #     #   # 設定可能な値: true または false
  #     #   # 省略時: false
  #     #   enabled = true
  #     # }
  #   }
  # }

  #-------------------------------------------------------------
  # リダイレクトアクション設定
  #-------------------------------------------------------------

  # default_action {
  #   type = "redirect"
  #
  #   redirect {
  #     # status_code (Required)
  #     # 設定内容: リダイレクト時のHTTPステータスコードを指定します。
  #     # 設定可能な値: "HTTP_301"（恒久的）、"HTTP_302"（一時的）
  #     status_code = "HTTP_301"
  #
  #     # host (Optional)
  #     # 設定内容: リダイレクト先のホスト名を指定します。
  #     # 設定可能な値: ホスト名文字列（例: "example.com"）
  #     # 省略時: 元のリクエストのホストをそのまま使用（"#{host}"）
  #     host = null
  #
  #     # path (Optional)
  #     # 設定内容: リダイレクト先のパスを指定します（先頭スラッシュ必須）。
  #     # 設定可能な値: パス文字列（例: "/new-path"）
  #     # 省略時: 元のリクエストのパスをそのまま使用（"#{path}"）
  #     path = null
  #
  #     # port (Optional)
  #     # 設定内容: リダイレクト先のポート番号を指定します。
  #     # 設定可能な値: 1-65535の整数、または "#{port}"
  #     # 省略時: 元のリクエストのポートをそのまま使用（"#{port}"）
  #     port = null
  #
  #     # protocol (Optional)
  #     # 設定内容: リダイレクト先のプロトコルを指定します。
  #     # 設定可能な値: "HTTP"、"HTTPS"、または "#{protocol}"
  #     # 省略時: 元のリクエストのプロトコルをそのまま使用（"#{protocol}"）
  #     protocol = "HTTPS"
  #
  #     # query (Optional)
  #     # 設定内容: リダイレクト先のクエリパラメータを指定します。
  #     # 設定可能な値: クエリ文字列（例: "param=value"）
  #     # 省略時: 元のリクエストのクエリをそのまま使用（"#{query}"）
  #     query = null
  #   }
  # }

  #-------------------------------------------------------------
  # 固定レスポンスアクション設定 (ALBのみ)
  #-------------------------------------------------------------

  # default_action {
  #   type = "fixed-response"
  #
  #   fixed_response {
  #     # content_type (Required)
  #     # 設定内容: レスポンスのコンテンツタイプを指定します。
  #     # 設定可能な値: "text/plain"、"text/css"、"text/html"、
  #     #              "application/javascript"、"application/json"
  #     content_type = "application/json"
  #
  #     # message_body (Optional)
  #     # 設定内容: レスポンスのメッセージボディを指定します。
  #     # 設定可能な値: 最大1024バイトの文字列
  #     # 省略時: 空のボディ
  #     message_body = "{\"error\":\"not found\"}"
  #
  #     # status_code (Optional)
  #     # 設定内容: レスポンスのHTTPステータスコードを指定します。
  #     # 設定可能な値: "200"から"599"の文字列
  #     # 省略時: "200"
  #     status_code = "404"
  #   }
  # }

  #-------------------------------------------------------------
  # Cognito認証アクション設定 (ALBのみ)
  #-------------------------------------------------------------

  # default_action {
  #   type = "authenticate-cognito"
  #
  #   authenticate_cognito {
  #     # user_pool_arn (Required)
  #     # 設定内容: Cognito User Pool のARNを指定します。
  #     user_pool_arn = "arn:aws:cognito-idp:ap-northeast-1:123456789012:userpool/ap-northeast-1_XXXXXXXXX"
  #
  #     # user_pool_client_id (Required)
  #     # 設定内容: Cognito User Pool クライアントIDを指定します。
  #     user_pool_client_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  #
  #     # user_pool_domain (Required)
  #     # 設定内容: Cognito User Pool ドメインを指定します（プレフィックスのみ、またはカスタムドメイン）。
  #     user_pool_domain = "example-domain"
  #
  #     # authentication_request_extra_params (Optional)
  #     # 設定内容: 認証エンドポイントへのリクエストに追加するクエリパラメータを指定します。
  #     # 省略時: 追加パラメータなし
  #     authentication_request_extra_params = null
  #
  #     # on_unauthenticated_request (Optional)
  #     # 設定内容: 未認証リクエストに対する動作を指定します。
  #     # 設定可能な値: "deny"（拒否）、"allow"（許可）、"authenticate"（認証ページへリダイレクト）
  #     # 省略時: "authenticate"
  #     on_unauthenticated_request = "authenticate"
  #
  #     # scope (Optional)
  #     # 設定内容: OAuthスコープをスペース区切りで指定します。
  #     # 省略時: "openid"
  #     scope = "openid email"
  #
  #     # session_cookie_name (Optional)
  #     # 設定内容: 認証セッションを保持するCookieの名前を指定します。
  #     # 省略時: "AWSELBAuthSessionCookie"
  #     session_cookie_name = null
  #
  #     # session_timeout (Optional)
  #     # 設定内容: 認証セッションのタイムアウト（秒）を指定します。
  #     # 省略時: 604800（7日間）
  #     session_timeout = null
  #   }
  # }

  #-------------------------------------------------------------
  # OIDC認証アクション設定 (ALBのみ)
  #-------------------------------------------------------------

  # default_action {
  #   type = "authenticate-oidc"
  #
  #   authenticate_oidc {
  #     # authorization_endpoint (Required)
  #     # 設定内容: OIDCプロバイダーの認可エンドポイントのURLを指定します。
  #     authorization_endpoint = "https://example.com/oauth2/authorize"
  #
  #     # client_id (Required)
  #     # 設定内容: OIDCクライアントIDを指定します。
  #     client_id = "example-client-id"
  #
  #     # client_secret (Required, sensitive)
  #     # 設定内容: OIDCクライアントシークレットを指定します。
  #     # 注意: センシティブな値です。Terraform stateに平文で保存されます。
  #     #       Secrets Managerや環境変数で管理することを推奨します。
  #     client_secret = "example-client-secret"
  #
  #     # issuer (Required)
  #     # 設定内容: OIDCプロバイダーの発行者識別子のURLを指定します。
  #     issuer = "https://example.com"
  #
  #     # token_endpoint (Required)
  #     # 設定内容: OIDCプロバイダーのトークンエンドポイントのURLを指定します。
  #     token_endpoint = "https://example.com/oauth2/token"
  #
  #     # user_info_endpoint (Required)
  #     # 設定内容: OIDCプロバイダーのユーザー情報エンドポイントのURLを指定します。
  #     user_info_endpoint = "https://example.com/oauth2/userinfo"
  #
  #     # authentication_request_extra_params (Optional)
  #     # 設定内容: 認証エンドポイントへのリクエストに追加するクエリパラメータを指定します。
  #     # 省略時: 追加パラメータなし
  #     authentication_request_extra_params = null
  #
  #     # on_unauthenticated_request (Optional)
  #     # 設定内容: 未認証リクエストに対する動作を指定します。
  #     # 設定可能な値: "deny"（拒否）、"allow"（許可）、"authenticate"（認証ページへリダイレクト）
  #     # 省略時: "authenticate"
  #     on_unauthenticated_request = "authenticate"
  #
  #     # scope (Optional)
  #     # 設定内容: OAuthスコープをスペース区切りで指定します。
  #     # 省略時: "openid"
  #     scope = "openid"
  #
  #     # session_cookie_name (Optional)
  #     # 設定内容: 認証セッションを保持するCookieの名前を指定します。
  #     # 省略時: "AWSELBAuthSessionCookie"
  #     session_cookie_name = null
  #
  #     # session_timeout (Optional)
  #     # 設定内容: 認証セッションのタイムアウト（秒）を指定します。
  #     # 省略時: 604800（7日間）
  #     session_timeout = null
  #   }
  # }

  #-------------------------------------------------------------
  # JWT検証アクション設定 (NLBのみ)
  #-------------------------------------------------------------

  # default_action {
  #   type = "forward"
  #
  #   jwt_validation {
  #     # issuer (Required)
  #     # 設定内容: JWTトークンの発行者識別子のURLを指定します。
  #     issuer = "https://example.com"
  #
  #     # jwks_endpoint (Required)
  #     # 設定内容: JWK (JSON Web Key Set) エンドポイントのURLを指定します。
  #     jwks_endpoint = "https://example.com/.well-known/jwks.json"
  #
  #     #-----------------------------------------------------------
  #     # 追加クレーム設定 (max:10)
  #     #-----------------------------------------------------------
  #     # additional_claim {
  #     #   # name (Required)
  #     #   # 設定内容: 検証するJWTクレームの名前を指定します。
  #     #   name = "example-claim"
  #     #
  #     #   # values (Required)
  #     #   # 設定内容: クレームの期待値のセットを指定します。
  #     #   values = ["allowed-value"]
  #     #
  #     #   # format (Required)
  #     #   # 設定内容: クレーム値のフォーマットを指定します。
  #     #   # 設定可能な値: "String"、"StringList"
  #     #   format = "String"
  #     # }
  #   }
  # }

  #-------------------------------------------------------------
  # 相互TLS認証設定 (mTLS)
  #-------------------------------------------------------------

  # mutual_authentication {
  #   # mode (Required)
  #   # 設定内容: 相互認証モードを指定します。
  #   # 設定可能な値:
  #   #   - "verify": クライアント証明書を検証（必須）
  #   #   - "passthrough": 証明書をバックエンドに転送（ALBのみ）
  #   #   - "off": 相互認証を無効化
  #   mode = "verify"
  #
  #   # trust_store_arn (Optional)
  #   # 設定内容: クライアント証明書の検証に使用するトラストストアのARNを指定します。
  #   # 設定可能な値: aws_lb_trust_store リソースのARN
  #   # 省略時: mode が "passthrough" の場合は不要
  #   trust_store_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:trust-store/example/1234567890123456"
  #
  #   # ignore_client_certificate_expiry (Optional)
  #   # 設定内容: クライアント証明書の有効期限切れを無視するかを指定します。
  #   # 設定可能な値: true または false
  #   # 省略時: false
  #   ignore_client_certificate_expiry = false
  #
  #   # advertise_trust_store_ca_names (Optional)
  #   # 設定内容: TLSハンドシェイク中にトラストストアのCA名をアドバタイズするかを指定します。
  #   # 設定可能な値: "on"、"off"
  #   # 省略時: "off"
  #   advertise_trust_store_ca_names = "off"
  # }

  #-------------------------------------------------------------
  # HTTPリクエストヘッダー設定 (ALBのみ)
  #-------------------------------------------------------------

  # routing_http_request_x_amzn_mtls_clientcert_header_name (Optional)
  # 設定内容: mTLSクライアント証明書を転送するカスタムHTTPヘッダー名を指定します。
  # 省略時: "X-Amzn-Mtls-Clientcert"
  routing_http_request_x_amzn_mtls_clientcert_header_name = null

  # routing_http_request_x_amzn_mtls_clientcert_issuer_header_name (Optional)
  # 設定内容: mTLSクライアント証明書の発行者を転送するカスタムHTTPヘッダー名を指定します。
  # 省略時: "X-Amzn-Mtls-Clientcert-Issuer"
  routing_http_request_x_amzn_mtls_clientcert_issuer_header_name = null

  # routing_http_request_x_amzn_mtls_clientcert_leaf_header_name (Optional)
  # 設定内容: mTLSクライアント証明書のリーフ証明書を転送するカスタムHTTPヘッダー名を指定します。
  # 省略時: "X-Amzn-Mtls-Clientcert-Leaf"
  routing_http_request_x_amzn_mtls_clientcert_leaf_header_name = null

  # routing_http_request_x_amzn_mtls_clientcert_serial_number_header_name (Optional)
  # 設定内容: mTLSクライアント証明書のシリアル番号を転送するカスタムHTTPヘッダー名を指定します。
  # 省略時: "X-Amzn-Mtls-Clientcert-Serial-Number"
  routing_http_request_x_amzn_mtls_clientcert_serial_number_header_name = null

  # routing_http_request_x_amzn_mtls_clientcert_subject_header_name (Optional)
  # 設定内容: mTLSクライアント証明書のサブジェクトを転送するカスタムHTTPヘッダー名を指定します。
  # 省略時: "X-Amzn-Mtls-Clientcert-Subject"
  routing_http_request_x_amzn_mtls_clientcert_subject_header_name = null

  # routing_http_request_x_amzn_mtls_clientcert_validity_header_name (Optional)
  # 設定内容: mTLSクライアント証明書の有効期間を転送するカスタムHTTPヘッダー名を指定します。
  # 省略時: "X-Amzn-Mtls-Clientcert-Validity"
  routing_http_request_x_amzn_mtls_clientcert_validity_header_name = null

  # routing_http_request_x_amzn_tls_cipher_suite_header_name (Optional)
  # 設定内容: TLS暗号スイートを転送するカスタムHTTPヘッダー名を指定します。
  # 省略時: "X-Amzn-Tls-Cipher-Suite"
  routing_http_request_x_amzn_tls_cipher_suite_header_name = null

  # routing_http_request_x_amzn_tls_version_header_name (Optional)
  # 設定内容: TLSバージョンを転送するカスタムHTTPヘッダー名を指定します。
  # 省略時: "X-Amzn-Tls-Version"
  routing_http_request_x_amzn_tls_version_header_name = null

  #-------------------------------------------------------------
  # HTTPレスポンスヘッダー設定 (ALBのみ)
  #-------------------------------------------------------------

  # routing_http_response_access_control_allow_credentials_header_value (Optional)
  # 設定内容: Access-Control-Allow-Credentials レスポンスヘッダーの値を指定します。
  # 設定可能な値: "true"、"false"
  # 省略時: ヘッダーを追加しない
  routing_http_response_access_control_allow_credentials_header_value = null

  # routing_http_response_access_control_allow_headers_header_value (Optional)
  # 設定内容: Access-Control-Allow-Headers レスポンスヘッダーの値を指定します。
  # 省略時: ヘッダーを追加しない
  routing_http_response_access_control_allow_headers_header_value = null

  # routing_http_response_access_control_allow_methods_header_value (Optional)
  # 設定内容: Access-Control-Allow-Methods レスポンスヘッダーの値を指定します。
  # 省略時: ヘッダーを追加しない
  routing_http_response_access_control_allow_methods_header_value = null

  # routing_http_response_access_control_allow_origin_header_value (Optional)
  # 設定内容: Access-Control-Allow-Origin レスポンスヘッダーの値を指定します。
  # 省略時: ヘッダーを追加しない
  routing_http_response_access_control_allow_origin_header_value = null

  # routing_http_response_access_control_expose_headers_header_value (Optional)
  # 設定内容: Access-Control-Expose-Headers レスポンスヘッダーの値を指定します。
  # 省略時: ヘッダーを追加しない
  routing_http_response_access_control_expose_headers_header_value = null

  # routing_http_response_access_control_max_age_header_value (Optional)
  # 設定内容: Access-Control-Max-Age レスポンスヘッダーの値を指定します。
  # 省略時: ヘッダーを追加しない
  routing_http_response_access_control_max_age_header_value = null

  # routing_http_response_content_security_policy_header_value (Optional)
  # 設定内容: Content-Security-Policy レスポンスヘッダーの値を指定します。
  # 省略時: ヘッダーを追加しない
  routing_http_response_content_security_policy_header_value = null

  # routing_http_response_server_enabled (Optional)
  # 設定内容: Server レスポンスヘッダーを有効にするかを指定します。
  # 設定可能な値: true または false
  # 省略時: true（ALBはデフォルトでServerヘッダーを返す）
  routing_http_response_server_enabled = null

  # routing_http_response_strict_transport_security_header_value (Optional)
  # 設定内容: Strict-Transport-Security (HSTS) レスポンスヘッダーの値を指定します。
  # 省略時: ヘッダーを追加しない
  routing_http_response_strict_transport_security_header_value = null

  # routing_http_response_x_content_type_options_header_value (Optional)
  # 設定内容: X-Content-Type-Options レスポンスヘッダーの値を指定します。
  # 設定可能な値: "nosniff"
  # 省略時: ヘッダーを追加しない
  routing_http_response_x_content_type_options_header_value = null

  # routing_http_response_x_frame_options_header_value (Optional)
  # 設定内容: X-Frame-Options レスポンスヘッダーの値を指定します。
  # 設定可能な値: "DENY"、"SAMEORIGIN"
  # 省略時: ヘッダーを追加しない
  routing_http_response_x_frame_options_header_value = null

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
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts {
  #   # create (Optional)
  #   # 設定内容: リスナー作成のタイムアウトを指定します。
  #   # 省略時: デフォルトのタイムアウトを使用
  #   create = null
  #
  #   # update (Optional)
  #   # 設定内容: リスナー更新のタイムアウトを指定します。
  #   # 省略時: デフォルトのタイムアウトを使用
  #   update = null
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: プロバイダーレベルの default_tags と同じキーを持つタグは上書きされます。
  tags = {
    Name        = "example-lb-listener"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: リスナーを識別するARN
# - id: リスナーのARN（arn と同じ値）
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
