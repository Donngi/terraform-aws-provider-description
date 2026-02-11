#---------------------------------------------------------------
# AWS ALB/LB Listener
#---------------------------------------------------------------
#
# Application Load Balancer (ALB)、Network Load Balancer (NLB)、または
# Gateway Load Balancer (GWLB) のリスナーをプロビジョニングするリソースです。
# リスナーは指定されたプロトコルとポートを使用して接続リクエストをチェックし、
# ルールに基づいてリクエストをターゲットグループにルーティングします。
#
# Note: aws_alb_listener は aws_lb_listener のエイリアスです。機能は同一です。
#
# AWS公式ドキュメント:
#   - ALBリスナー: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html
#   - HTTPSリスナーの作成: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html
#   - セキュリティポリシー: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/describe-ssl-policies.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_alb_listener" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # load_balancer_arn (Required, Forces new resource)
  # 設定内容: リスナーを関連付けるロードバランサーのARNを指定します。
  # 設定可能な値: 有効なALB、NLB、またはGWLBのARN
  load_balancer_arn = aws_lb.example.arn

  #-------------------------------------------------------------
  # プロトコル・ポート設定
  #-------------------------------------------------------------

  # port (Optional)
  # 設定内容: ロードバランサーがリスニングするポート番号を指定します。
  # 設定可能な値: 1-65535の整数
  # 注意: Gateway Load Balancerでは無効です。
  port = 443

  # protocol (Optional)
  # 設定内容: クライアントからロードバランサーへの接続プロトコルを指定します。
  # 設定可能な値:
  #   - ALBの場合: "HTTP", "HTTPS" (デフォルト: HTTP)
  #   - NLBの場合: "TCP", "TLS", "UDP", "TCP_UDP", "QUIC", "TCP_QUIC"
  #     - dual-stackモード有効時: UDP, TCP_UDPは無効
  #     - セキュリティグループ設定時またはdual-stackモード有効時: QUIC, TCP_QUICは無効
  # 注意: Gateway Load Balancerでは無効です。
  protocol = "HTTPS"

  #-------------------------------------------------------------
  # SSL/TLS設定
  #-------------------------------------------------------------

  # certificate_arn (Optional)
  # 設定内容: デフォルトのSSLサーバー証明書のARNを指定します。
  # 設定可能な値: 有効なACM証明書またはIAMサーバー証明書のARN
  # 注意: プロトコルがHTTPSの場合は必須です。
  #       追加のSSL証明書については aws_lb_listener_certificate リソースを使用してください。
  # 関連機能: SSL/TLS終端
  #   ロードバランサーでSSL/TLS接続を終端し、証明書を使用してリクエストを復号化します。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/https-listener-certificates.html
  certificate_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  # ssl_policy (Optional)
  # 設定内容: リスナーのSSLポリシー名を指定します。
  # 設定可能な値: AWSが提供するセキュリティポリシー名
  #   - "ELBSecurityPolicy-2016-08" (デフォルト)
  #   - "ELBSecurityPolicy-TLS13-1-2-2021-06" (TLS 1.3対応)
  #   - "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09" (ポスト量子暗号対応、コンソールデフォルト)
  #   - その他多数のポリシーが利用可能
  # 注意: プロトコルがHTTPSまたはTLSの場合に必須です。
  # 関連機能: セキュリティポリシー
  #   SSL/TLS接続をネゴシエートするためのプロトコルと暗号の組み合わせを定義します。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/describe-ssl-policies.html
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  # alpn_policy (Optional)
  # 設定内容: Application-Layer Protocol Negotiation (ALPN) ポリシー名を指定します。
  # 設定可能な値:
  #   - "HTTP1Only": HTTP/1.1のみをネゴシエート
  #   - "HTTP2Only": HTTP/2のみをネゴシエート
  #   - "HTTP2Optional": クライアントがHTTP/2をサポートする場合はHTTP/2、それ以外はHTTP/1.1
  #   - "HTTP2Preferred": HTTP/2を優先しますが、HTTP/1.1にフォールバック可能
  #   - "None": ALPNを使用しない
  # 注意: プロトコルがTLSの場合にのみ設定可能です。
  alpn_policy = null

  #-------------------------------------------------------------
  # TCP設定
  #-------------------------------------------------------------

  # tcp_idle_timeout_seconds (Optional)
  # 設定内容: TCPアイドルタイムアウト値を秒単位で指定します。
  # 設定可能な値: 60-6000の整数 (デフォルト: 350)
  # 注意: Network Load BalancerでプロトコルがTCPの場合、または
  #       Gateway Load Balancerでのみ設定可能です。
  #       Application Load Balancerではサポートされていません。
  tcp_idle_timeout_seconds = null

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
  # HTTPレスポンスヘッダー設定 (ALBのみ)
  #-------------------------------------------------------------

  # routing_http_response_server_enabled (Optional)
  # 設定内容: HTTPレスポンスのServerヘッダーを許可または削除するかを指定します。
  # 設定可能な値:
  #   - true: Serverヘッダーを含める
  #   - false: Serverヘッダーを削除
  # 注意: ALBでプロトコルがHTTPまたはHTTPSの場合のみ設定可能です。
  routing_http_response_server_enabled = null

  # routing_http_response_strict_transport_security_header_value (Optional)
  # 設定内容: Strict-Transport-Security (HSTS) ヘッダーの値を指定します。
  # 設定可能な値: HSTSヘッダー値の文字列
  #   例: "max-age=31536000; includeSubDomains; preload"
  # 省略時: "max-age=31536000; includeSubDomains; preload"
  # 関連機能: HTTP Strict Transport Security
  #   ブラウザにHTTPSのみでサイトにアクセスすべきことを通知し、
  #   将来のHTTPリクエストを自動的にHTTPSに変換します。
  routing_http_response_strict_transport_security_header_value = null

  # routing_http_response_content_security_policy_header_value (Optional)
  # 設定内容: Content-Security-Policy ヘッダーの値を指定します。
  # 設定可能な値: CSPディレクティブの文字列
  # 関連機能: Content Security Policy
  #   XSSなどのセキュリティ脅威のリスクを最小化するための制限を指定します。
  # 注意: 値は広範囲に設定可能で、設定時に影響がある可能性があります。
  routing_http_response_content_security_policy_header_value = null

  # routing_http_response_x_content_type_options_header_value (Optional)
  # 設定内容: X-Content-Type-Options ヘッダーの値を指定します。
  # 設定可能な値: "nosniff" (唯一の有効な値)
  # 関連機能: MIME type sniffing防止
  #   Content-Typeヘッダーで指定されたMIMEタイプに従い、変更しないことを指示します。
  routing_http_response_x_content_type_options_header_value = null

  # routing_http_response_x_frame_options_header_value (Optional)
  # 設定内容: X-Frame-Options ヘッダーの値を指定します。
  # 設定可能な値:
  #   - "DENY": フレーム内での表示を完全に禁止
  #   - "SAMEORIGIN": 同一オリジンからのフレーム内表示のみ許可
  #   - "ALLOW-FROM https://example.com": 指定されたURIからのフレーム内表示を許可
  # 関連機能: クリックジャッキング防止
  #   ブラウザがページをframe, iframe, embed, objectで表示することを許可するかを制御します。
  routing_http_response_x_frame_options_header_value = null

  #-------------------------------------------------------------
  # CORS (Cross-Origin Resource Sharing) 設定 (ALBのみ)
  #-------------------------------------------------------------

  # routing_http_response_access_control_allow_origin_header_value (Optional)
  # 設定内容: Access-Control-Allow-Origin ヘッダーの値を指定します。
  # 設定可能な値: 有効なURI（例: "https://example.com"）
  # 関連機能: CORS
  #   サーバーへのアクセスを許可するオリジンを指定します。
  routing_http_response_access_control_allow_origin_header_value = null

  # routing_http_response_access_control_allow_methods_header_value (Optional)
  # 設定内容: Access-Control-Allow-Methods ヘッダーの値を指定します。
  # 設定可能な値: "GET", "HEAD", "POST", "DELETE", "CONNECT", "OPTIONS", "TRACE", "PATCH"
  #   カンマ区切りで複数指定可能
  # 関連機能: CORS
  #   異なるオリジンからサーバーにアクセスする際に許可されるHTTPメソッドを設定します。
  routing_http_response_access_control_allow_methods_header_value = null

  # routing_http_response_access_control_allow_headers_header_value (Optional)
  # 設定内容: Access-Control-Allow-Headers ヘッダーの値を指定します。
  # 設定可能な値: "*", "Accept", "Accept-Language", "Cache-Control", "Content-Language",
  #   "Content-Length", "Content-Type", "Expires", "Last-Modified", "Pragma" など
  # 関連機能: CORS
  #   リクエスト中に使用できるヘッダーを指定します。
  routing_http_response_access_control_allow_headers_header_value = null

  # routing_http_response_access_control_allow_credentials_header_value (Optional)
  # 設定内容: Access-Control-Allow-Credentials ヘッダーの値を指定します。
  # 設定可能な値: "true" (唯一の有効な値)
  # 関連機能: CORS
  #   ブラウザがリクエストを行う際にCookieや認証情報を含めるべきかを指定します。
  routing_http_response_access_control_allow_credentials_header_value = null

  # routing_http_response_access_control_expose_headers_header_value (Optional)
  # 設定内容: Access-Control-Expose-Headers ヘッダーの値を指定します。
  # 設定可能な値: "*", "Cache-Control", "Content-Language", "Content-Length",
  #   "Content-Type", "Expires", "Last-Modified", "Pragma" など
  # 関連機能: CORS
  #   ブラウザがリクエスト元のクライアントに公開できるヘッダーを指定します。
  routing_http_response_access_control_expose_headers_header_value = null

  # routing_http_response_access_control_max_age_header_value (Optional)
  # 設定内容: Access-Control-Max-Age ヘッダーの値を指定します。
  # 設定可能な値: 0-86400の整数を文字列で指定
  # 関連機能: CORS
  #   プリフライトリクエストの結果をキャッシュできる秒数を指定します。
  #   ブラウザによって動作が異なります。
  routing_http_response_access_control_max_age_header_value = null

  #-------------------------------------------------------------
  # mTLS (相互TLS) HTTPリクエストヘッダー名設定 (ALB HTTPSのみ)
  #-------------------------------------------------------------

  # routing_http_request_x_amzn_mtls_clientcert_header_name (Optional)
  # 設定内容: X-Amzn-Mtls-Clientcert HTTPリクエストヘッダーのカスタム名を指定します。
  # 設定可能な値: 有効なHTTPヘッダー名の文字列
  # 注意: ALBでプロトコルがHTTPSの場合のみ設定可能です。
  routing_http_request_x_amzn_mtls_clientcert_header_name = null

  # routing_http_request_x_amzn_mtls_clientcert_serial_number_header_name (Optional)
  # 設定内容: X-Amzn-Mtls-Clientcert-Serial-Number HTTPリクエストヘッダーのカスタム名を指定します。
  # 設定可能な値: 有効なHTTPヘッダー名の文字列
  routing_http_request_x_amzn_mtls_clientcert_serial_number_header_name = null

  # routing_http_request_x_amzn_mtls_clientcert_issuer_header_name (Optional)
  # 設定内容: X-Amzn-Mtls-Clientcert-Issuer HTTPリクエストヘッダーのカスタム名を指定します。
  # 設定可能な値: 有効なHTTPヘッダー名の文字列
  routing_http_request_x_amzn_mtls_clientcert_issuer_header_name = null

  # routing_http_request_x_amzn_mtls_clientcert_subject_header_name (Optional)
  # 設定内容: X-Amzn-Mtls-Clientcert-Subject HTTPリクエストヘッダーのカスタム名を指定します。
  # 設定可能な値: 有効なHTTPヘッダー名の文字列
  routing_http_request_x_amzn_mtls_clientcert_subject_header_name = null

  # routing_http_request_x_amzn_mtls_clientcert_validity_header_name (Optional)
  # 設定内容: X-Amzn-Mtls-Clientcert-Validity HTTPリクエストヘッダーのカスタム名を指定します。
  # 設定可能な値: 有効なHTTPヘッダー名の文字列
  routing_http_request_x_amzn_mtls_clientcert_validity_header_name = null

  # routing_http_request_x_amzn_mtls_clientcert_leaf_header_name (Optional)
  # 設定内容: X-Amzn-Mtls-Clientcert-Leaf HTTPリクエストヘッダーのカスタム名を指定します。
  # 設定可能な値: 有効なHTTPヘッダー名の文字列
  routing_http_request_x_amzn_mtls_clientcert_leaf_header_name = null

  # routing_http_request_x_amzn_tls_version_header_name (Optional)
  # 設定内容: X-Amzn-Tls-Version HTTPリクエストヘッダーのカスタム名を指定します。
  # 設定可能な値: 有効なHTTPヘッダー名の文字列
  routing_http_request_x_amzn_tls_version_header_name = null

  # routing_http_request_x_amzn_tls_cipher_suite_header_name (Optional)
  # 設定内容: X-Amzn-Tls-Cipher-Suite HTTPリクエストヘッダーのカスタム名を指定します。
  # 設定可能な値: 有効なHTTPヘッダー名の文字列
  routing_http_request_x_amzn_tls_cipher_suite_header_name = null

  #-------------------------------------------------------------
  # デフォルトアクション設定 (Required)
  #-------------------------------------------------------------
  # リクエストがリスナールールに一致しない場合に実行するアクションを定義します。
  # 最低1つのdefault_actionブロックが必須です。

  default_action {
    # type (Required)
    # 設定内容: ルーティングアクションのタイプを指定します。
    # 設定可能な値:
    #   - "forward": ターゲットグループにリクエストを転送
    #   - "redirect": 別のURLにリダイレクト
    #   - "fixed-response": カスタムHTTPレスポンスを返す
    #   - "authenticate-cognito": Amazon Cognitoで認証
    #   - "authenticate-oidc": OIDC準拠のIdPで認証
    #   - "jwt-validation": JWTを検証
    type = "forward"

    # target_group_arn (Optional)
    # 設定内容: トラフィックをルーティングするターゲットグループのARNを指定します。
    # 設定可能な値: 有効なターゲットグループARN
    # 注意: typeが"forward"で単一のターゲットグループにルーティングする場合に指定。
    #       複数のターゲットグループへルーティングする場合はforwardブロックを使用。
    target_group_arn = aws_lb_target_group.example.arn

    # order (Optional)
    # 設定内容: アクションの実行順序を指定します。
    # 設定可能な値: 1-50000の整数
    # 省略時: アクションリスト内の位置に基づいて自動設定
    # 注意: 最も低い値のアクションが最初に実行されます。
    order = null

    #-----------------------------------------------------------
    # forwardブロック (Optional)
    # 複数のターゲットグループに分散してリクエストを転送する場合に使用
    #-----------------------------------------------------------
    # forward {
    #   # target_group (Required)
    #   # 1-5個のターゲットグループを指定
    #   target_group {
    #     # arn (Required): ターゲットグループのARN
    #     arn = aws_lb_target_group.main.arn
    #
    #     # weight (Optional): ルーティングウェイト (0-999)
    #     weight = 80
    #   }
    #
    #   target_group {
    #     arn    = aws_lb_target_group.canary.arn
    #     weight = 20
    #   }
    #
    #   # stickiness (Optional)
    #   # ターゲットグループスティッキネス設定
    #   stickiness {
    #     # duration (Required): スティッキネス期間（秒）
    #     # 設定可能な値: 1-604800 (7日)
    #     duration = 3600
    #
    #     # enabled (Optional): スティッキネスを有効にするか
    #     # 省略時: false
    #     enabled = true
    #   }
    # }

    #-----------------------------------------------------------
    # redirectブロック (Optional)
    # typeが"redirect"の場合に必須
    #-----------------------------------------------------------
    # redirect {
    #   # status_code (Required)
    #   # HTTPリダイレクトコード
    #   # 設定可能な値:
    #   #   - "HTTP_301": 恒久的リダイレクト
    #   #   - "HTTP_302": 一時的リダイレクト
    #   status_code = "HTTP_301"
    #
    #   # host (Optional): リダイレクト先ホスト名
    #   # 省略時: "#{host}" (元のホスト名を使用)
    #   # 設定可能な値: ホスト名または "#{host}"
    #   host = "example.com"
    #
    #   # path (Optional): リダイレクト先パス
    #   # 省略時: "/#{path}" (元のパスを使用)
    #   # 設定可能な値: "/"で始まる絶対パス、#{host}, #{path}, #{port}を含められる
    #   path = "/new-path"
    #
    #   # port (Optional): リダイレクト先ポート
    #   # 省略時: "#{port}" (元のポートを使用)
    #   # 設定可能な値: 1-65535 または "#{port}"
    #   port = "443"
    #
    #   # protocol (Optional): リダイレクト先プロトコル
    #   # 省略時: "#{protocol}" (元のプロトコルを使用)
    #   # 設定可能な値: "HTTP", "HTTPS", "#{protocol}"
    #   protocol = "HTTPS"
    #
    #   # query (Optional): リダイレクト先クエリパラメータ
    #   # 省略時: "#{query}" (元のクエリを使用)
    #   # 設定可能な値: "?"を含まないクエリ文字列
    #   query = "key=value"
    # }

    #-----------------------------------------------------------
    # fixed_responseブロック (Optional)
    # typeが"fixed-response"の場合に必須
    #-----------------------------------------------------------
    # fixed_response {
    #   # content_type (Required)
    #   # レスポンスのContent-Type
    #   # 設定可能な値: "text/plain", "text/css", "text/html",
    #   #               "application/javascript", "application/json"
    #   content_type = "text/plain"
    #
    #   # message_body (Optional): レスポンスボディ
    #   message_body = "Fixed response content"
    #
    #   # status_code (Optional): HTTPステータスコード
    #   # 設定可能な値: "2XX", "4XX", "5XX" (例: "200", "404", "503")
    #   status_code = "200"
    # }

    #-----------------------------------------------------------
    # authenticate_cognitoブロック (Optional)
    # typeが"authenticate-cognito"の場合に使用
    #-----------------------------------------------------------
    # authenticate_cognito {
    #   # user_pool_arn (Required): Cognito ユーザープールのARN
    #   user_pool_arn = aws_cognito_user_pool.pool.arn
    #
    #   # user_pool_client_id (Required): CognitoユーザープールクライアントのID
    #   user_pool_client_id = aws_cognito_user_pool_client.client.id
    #
    #   # user_pool_domain (Required): Cognitoユーザープールのドメインプレフィックスまたは完全修飾ドメイン名
    #   user_pool_domain = aws_cognito_user_pool_domain.domain.domain
    #
    #   # authentication_request_extra_params (Optional)
    #   # 認可エンドポイントへのリダイレクトリクエストに含める追加クエリパラメータ
    #   # 最大10個まで
    #   authentication_request_extra_params = {
    #     display = "page"
    #   }
    #
    #   # on_unauthenticated_request (Optional)
    #   # 未認証ユーザーの処理方法
    #   # 設定可能な値: "deny", "allow", "authenticate"
    #   on_unauthenticated_request = "authenticate"
    #
    #   # scope (Optional): IdPからリクエストするユーザークレームのセット
    #   scope = "openid"
    #
    #   # session_cookie_name (Optional): セッション情報を維持するためのCookie名
    #   session_cookie_name = "AWSELBAuthSessionCookie"
    #
    #   # session_timeout (Optional): 認証セッションの最大期間（秒）
    #   session_timeout = 604800
    # }

    #-----------------------------------------------------------
    # authenticate_oidcブロック (Optional)
    # typeが"authenticate-oidc"の場合に使用
    #-----------------------------------------------------------
    # authenticate_oidc {
    #   # authorization_endpoint (Required): IdPの認可エンドポイント
    #   authorization_endpoint = "https://example.com/authorization_endpoint"
    #
    #   # client_id (Required): OAuth 2.0クライアント識別子
    #   client_id = "client_id"
    #
    #   # client_secret (Required, Sensitive): OAuth 2.0クライアントシークレット
    #   client_secret = "client_secret"
    #
    #   # issuer (Required): IdPのOIDC発行者識別子
    #   issuer = "https://example.com"
    #
    #   # token_endpoint (Required): IdPのトークンエンドポイント
    #   token_endpoint = "https://example.com/token_endpoint"
    #
    #   # user_info_endpoint (Required): IdPのユーザー情報エンドポイント
    #   user_info_endpoint = "https://example.com/user_info_endpoint"
    #
    #   # authentication_request_extra_params (Optional)
    #   # 認可エンドポイントへのリダイレクトリクエストに含める追加クエリパラメータ
    #   authentication_request_extra_params = {
    #     display = "page"
    #   }
    #
    #   # on_unauthenticated_request (Optional)
    #   # 未認証ユーザーの処理方法
    #   # 設定可能な値: "deny", "allow", "authenticate"
    #   on_unauthenticated_request = "authenticate"
    #
    #   # scope (Optional): IdPからリクエストするユーザークレームのセット
    #   scope = "openid"
    #
    #   # session_cookie_name (Optional): セッション情報を維持するためのCookie名
    #   session_cookie_name = "AWSELBAuthSessionCookie"
    #
    #   # session_timeout (Optional): 認証セッションの最大期間（秒）
    #   session_timeout = 604800
    # }

    #-----------------------------------------------------------
    # jwt_validationブロック (Optional)
    # typeが"jwt-validation"の場合に必須
    #-----------------------------------------------------------
    # jwt_validation {
    #   # issuer (Required): JWTの発行者
    #   issuer = "https://example.com"
    #
    #   # jwks_endpoint (Required)
    #   # JSON Web Key Set (JWKS) エンドポイント
    #   # プロバイダーからの署名を検証するためのJSON Web Keys (JWK) を含む
    #   # HTTPSプロトコル、ドメイン、パスを含む完全なURLである必要があります
    #   jwks_endpoint = "https://example.com/.well-known/jwks.json"
    #
    #   # additional_claim (Optional)
    #   # 追加の検証対象クレーム設定（最大10個）
    #   additional_claim {
    #     # format (Required)
    #     # クレーム値のフォーマット
    #     # 設定可能な値: "single-string", "string-array", "space-separated-values"
    #     format = "string-array"
    #
    #     # name (Required)
    #     # 検証するクレーム名
    #     # 注意: "exp", "iss", "nbf", "iat"はデフォルトで検証されるため指定不可
    #     name = "groups"
    #
    #     # values (Required)
    #     # クレームの期待値のリスト
    #     values = ["admin", "user"]
    #   }
    # }
  }

  #-------------------------------------------------------------
  # 相互TLS認証設定 (Optional)
  #-------------------------------------------------------------
  # クライアント証明書による認証を設定します。

  # mutual_authentication {
  #   # mode (Required)
  #   # 相互認証モード
  #   # 設定可能な値:
  #   #   - "off": 相互認証を無効化
  #   #   - "passthrough": クライアント証明書をターゲットに転送（検証なし）
  #   #   - "verify": クライアント証明書を検証
  #   mode = "verify"
  #
  #   # trust_store_arn (Required when mode is "verify")
  #   # elbv2 Trust StoreのARN
  #   # クライアント証明書を検証するためのCA証明書を含むTrust Store
  #   trust_store_arn = aws_lb_trust_store.example.arn
  #
  #   # advertise_trust_store_ca_names (Optional when mode is "verify")
  #   # Trust Store CA名をアドバタイズするか
  #   # 設定可能な値: "off", "on"
  #   advertise_trust_store_ca_names = "off"
  #
  #   # ignore_client_certificate_expiry (Optional when mode is "verify")
  #   # クライアント証明書の有効期限を無視するか
  #   # 省略時: false
  #   ignore_client_certificate_expiry = false
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts {
  #   # create (Optional): 作成タイムアウト
  #   create = "10m"
  #
  #   # update (Optional): 更新タイムアウト
  #   update = "10m"
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: "Name"キーを指定すると、AWS Console上のリスナールールテーブルの
  #       "Name Tag"列に値が表示されます。指定しない場合は"Default"と表示されます。
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-listener"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: リスナーのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
