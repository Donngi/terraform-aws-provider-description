#---------------------------------------------------------------
# Application Load Balancer Listener
#---------------------------------------------------------------
#
# Elastic Load Balancing (ELB) のリスナーをプロビジョニングするリソースです。
# リスナーは、指定したプロトコルとポートを使用して接続リクエストをチェックし、
# ルールに基づいてリクエストをターゲットグループにルーティングします。
#
# サポートされるロードバランサータイプ:
#   - Application Load Balancer (ALB): HTTP/HTTPS プロトコル
#   - Network Load Balancer (NLB): TCP/TLS/UDP/TCP_UDP/QUIC/TCP_QUIC プロトコル
#   - Gateway Load Balancer (GWLB): GENEVE プロトコル
#
# 主な機能:
#   - デフォルトアクション: forward, redirect, fixed-response, authenticate-cognito,
#     authenticate-oidc, jwt-validation
#   - HTTPS リスナー: SSL/TLS 証明書、セキュリティポリシーの設定
#   - mTLS (相互TLS認証): クライアント証明書検証
#   - HTTPヘッダーのカスタマイズ: リクエスト/レスポンスヘッダーの変更
#   - WebSocketsとHTTP/2のネイティブサポート (ALB)
#
# AWS公式ドキュメント:
#   - Listeners for Application Load Balancers: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html
#   - Create an HTTPS listener: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html
#   - SSL certificates: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/https-listener-certificates.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_listener" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ロードバランサーのARN
  # このリスナーをアタッチするロードバランサーを指定します。
  # 変更すると新しいリソースが作成されます (Forces New Resource)。
  load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/my-load-balancer/50dc6c495c0c9188"

  #---------------------------------------------------------------
  # デフォルトアクション (必須)
  #---------------------------------------------------------------
  # リスナーのデフォルトアクションを定義します。
  # 少なくとも1つのデフォルトアクションが必要です。
  # 他のルールに一致しないリクエストに対して実行されます。

  default_action {
    # アクションのタイプ (必須)
    # 有効な値: forward, redirect, fixed-response, authenticate-cognito,
    # authenticate-oidc, jwt-validation
    type = "forward"

    # ターゲットグループのARN (任意)
    # type が "forward" の場合に使用します。
    # 単一のターゲットグループにルーティングする場合に指定します。
    # 複数のターゲットグループにルーティングする場合は forward ブロックを使用します。
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-targets/73e2d6bc24d8a067"

    # アクションの順序 (任意)
    # 複数のアクションがある場合の実行順序を指定します。
    # 有効な値: 1-50000
    # デフォルト: リスト内の位置
    # order = 1

    #-----------------------------------------------------------
    # Cognito認証アクション (任意)
    #-----------------------------------------------------------
    # Amazon Cognito を使用してユーザーを認証する場合に指定します。
    # type が "authenticate-cognito" の場合のみ有効です。

    # authenticate_cognito {
    #   # Cognito ユーザープールのARN (必須)
    #   user_pool_arn = "arn:aws:cognito-idp:us-east-1:123456789012:userpool/us-east-1_EXAMPLE"
    #
    #   # Cognito ユーザープールクライアントのID (必須)
    #   user_pool_client_id = "1example23456789"
    #
    #   # Cognito ユーザープールのドメイン (必須)
    #   # ドメインプレフィックスまたは完全修飾ドメイン名を指定します。
    #   user_pool_domain = "example-domain"
    #
    #   # 認証リクエストに含める追加のクエリパラメータ (任意)
    #   # 最大10個まで指定可能です。
    #   # authentication_request_extra_params = {
    #   #   key1 = "value1"
    #   #   key2 = "value2"
    #   # }
    #
    #   # 未認証リクエストの動作 (任意)
    #   # 有効な値: deny, allow, authenticate
    #   # on_unauthenticated_request = "authenticate"
    #
    #   # IdP からリクエストするユーザークレームのセット (任意)
    #   # scope = "openid"
    #
    #   # セッション情報を維持するために使用されるクッキーの名前 (任意)
    #   # session_cookie_name = "AWSELBAuthSessionCookie"
    #
    #   # 認証セッションの最大期間 (秒) (任意)
    #   # session_timeout = 3600
    # }

    #-----------------------------------------------------------
    # OIDC認証アクション (任意)
    #-----------------------------------------------------------
    # OpenID Connect (OIDC) 準拠の ID プロバイダーを使用する場合に指定します。
    # type が "authenticate-oidc" の場合のみ有効です。

    # authenticate_oidc {
    #   # IdP の認可エンドポイント (必須)
    #   authorization_endpoint = "https://example.com/authorization_endpoint"
    #
    #   # OAuth 2.0 クライアント識別子 (必須)
    #   client_id = "client_id"
    #
    #   # OAuth 2.0 クライアントシークレット (必須)
    #   # この値はセンシティブな情報として扱われます。
    #   client_secret = "client_secret"
    #
    #   # OIDC 発行者識別子 (必須)
    #   issuer = "https://example.com"
    #
    #   # IdP のトークンエンドポイント (必須)
    #   token_endpoint = "https://example.com/token_endpoint"
    #
    #   # IdP のユーザー情報エンドポイント (必須)
    #   user_info_endpoint = "https://example.com/user_info_endpoint"
    #
    #   # 認証リクエストに含める追加のクエリパラメータ (任意)
    #   # 最大10個まで指定可能です。
    #   # authentication_request_extra_params = {
    #   #   key1 = "value1"
    #   # }
    #
    #   # 未認証リクエストの動作 (任意)
    #   # 有効な値: deny, allow, authenticate
    #   # on_unauthenticated_request = "authenticate"
    #
    #   # IdP からリクエストするユーザークレームのセット (任意)
    #   # scope = "openid"
    #
    #   # セッション情報を維持するために使用されるクッキーの名前 (任意)
    #   # session_cookie_name = "AWSELBAuthSessionCookie"
    #
    #   # 認証セッションの最大期間 (秒) (任意)
    #   # session_timeout = 3600
    # }

    #-----------------------------------------------------------
    # 固定レスポンスアクション (任意)
    #-----------------------------------------------------------
    # カスタムHTTPレスポンスを返すアクションを作成します。
    # type が "fixed-response" の場合に必須です。

    # fixed_response {
    #   # コンテンツタイプ (必須)
    #   # 有効な値: text/plain, text/css, text/html,
    #   # application/javascript, application/json
    #   content_type = "text/plain"
    #
    #   # メッセージボディ (任意)
    #   # message_body = "Fixed response content"
    #
    #   # HTTPレスポンスコード (任意)
    #   # 有効な値: 2XX, 4XX, 5XX
    #   # status_code = "200"
    # }

    #-----------------------------------------------------------
    # フォワードアクション (任意)
    #-----------------------------------------------------------
    # 1つ以上のターゲットグループにリクエストを分散するアクションを作成します。
    # type が "forward" の場合のみ指定します。
    # 単一のターゲットグループの場合は target_group_arn を使用することもできます。

    # forward {
    #   # ターゲットグループのセット (必須)
    #   # 1-5個のターゲットグループを指定できます。
    #   target_group {
    #     # ターゲットグループのARN (必須)
    #     arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-targets/73e2d6bc24d8a067"
    #
    #     # 重み (任意)
    #     # 範囲: 0-999
    #     # weight = 100
    #   }
    #
    #   # スティッキネスの設定 (任意)
    #   # ターゲットグループのスティッキネスを設定します。
    #   # stickiness {
    #   #   # 期間 (秒) (必須)
    #   #   # クライアントからのリクエストを同じターゲットグループにルーティングする期間
    #   #   # 範囲: 1-604800秒 (7日間)
    #   #   duration = 600
    #   #
    #   #   # スティッキネスの有効化 (任意)
    #   #   # デフォルト: false
    #   #   # enabled = true
    #   # }
    # }

    #-----------------------------------------------------------
    # JWT検証アクション (任意)
    #-----------------------------------------------------------
    # JWT検証アクションを作成します。
    # type が "jwt-validation" の場合に必須です。

    # jwt_validation {
    #   # JWTの発行者 (必須)
    #   issuer = "https://example.com"
    #
    #   # JSON Web Key Set (JWKS) エンドポイント (必須)
    #   # プロバイダーからの署名を検証するために使用される JSON Web Keys (JWK) を含むエンドポイント
    #   # HTTPSプロトコル、ドメイン、パスを含む完全なURLである必要があります。
    #   jwks_endpoint = "https://example.com/.well-known/jwks.json"
    #
    #   # 検証する追加のクレーム (任意)
    #   # 最大10個まで指定可能です。
    #   # additional_claim {
    #   #   # クレーム値のフォーマット (必須)
    #   #   # 有効な値: single-string, string-array, space-separated-values
    #   #   format = "string-array"
    #   #
    #   #   # 検証するクレームの名前 (必須)
    #   #   # exp, iss, nbf, iat はデフォルトで検証されるため指定できません。
    #   #   name = "claim_name"
    #   #
    #   #   # クレームの期待値のリスト (必須)
    #   #   values = ["value1", "value2"]
    #   # }
    # }

    #-----------------------------------------------------------
    # リダイレクトアクション (任意)
    #-----------------------------------------------------------
    # リダイレクトアクションを作成します。
    # type が "redirect" の場合に必須です。

    # redirect {
    #   # HTTPリダイレクトコード (必須)
    #   # 有効な値: HTTP_301 (永続的), HTTP_302 (一時的)
    #   status_code = "HTTP_301"
    #
    #   # ホスト名 (任意)
    #   # このコンポーネントはパーセントエンコードされません。
    #   # #{host} を含めることができます。
    #   # デフォルト: #{host}
    #   # host = "#{host}"
    #
    #   # パス (任意)
    #   # 先頭の "/" で始まる絶対パス
    #   # このコンポーネントはパーセントエンコードされません。
    #   # #{host}, #{path}, #{port} を含めることができます。
    #   # デフォルト: /#{path}
    #   # path = "/#{path}"
    #
    #   # ポート (任意)
    #   # 1-65535 の値または #{port} を指定します。
    #   # デフォルト: #{port}
    #   # port = "#{port}"
    #
    #   # プロトコル (任意)
    #   # 有効な値: HTTP, HTTPS, #{protocol}
    #   # デフォルト: #{protocol}
    #   # protocol = "#{protocol}"
    #
    #   # クエリパラメータ (任意)
    #   # 必要に応じてURLエンコードされますが、パーセントエンコードはされません。
    #   # 先頭の "?" を含めないでください。
    #   # デフォルト: #{query}
    #   # query = "#{query}"
    # }
  }

  #---------------------------------------------------------------
  # オプションパラメータ - 基本設定
  #---------------------------------------------------------------

  # リスナーのポート (任意)
  # ロードバランサーがリッスンするポート
  # Gateway Load Balancer では無効です。
  # port = 443

  # プロトコル (任意)
  # クライアントからロードバランサーへの接続のプロトコル
  # - Application Load Balancer: HTTP, HTTPS (デフォルト: HTTP)
  # - Network Load Balancer: TCP, TLS, UDP, TCP_UDP, QUIC, TCP_QUIC
  #   注意: デュアルスタックモードが有効な場合、UDP または TCP_UDP は無効
  #   注意: セキュリティグループが設定されている、またはデュアルスタックモードが有効な場合、
  #        QUIC または TCP_QUIC は無効
  # - Gateway Load Balancer では無効
  # protocol = "HTTPS"

  # SSL/TLS証明書のARN (任意)
  # デフォルトのSSLサーバー証明書のARN
  # プロトコルが HTTPS の場合、正確に1つの証明書が必要です。
  # 追加のSSL証明書を追加するには aws_lb_listener_certificate リソースを使用します。
  # certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  # SSLポリシー (任意)
  # リスナーのSSLポリシーの名前
  # プロトコルが HTTPS または TLS の場合に必須です。
  # デフォルト: ELBSecurityPolicy-2016-08
  # ssl_policy = "ELBSecurityPolicy-2016-08"

  # ALPNポリシー (任意)
  # Application-Layer Protocol Negotiation (ALPN) ポリシーの名前
  # プロトコルが TLS の場合に設定できます。
  # 有効な値: HTTP1Only, HTTP2Only, HTTP2Optional, HTTP2Preferred, None
  # alpn_policy = "HTTP2Preferred"

  # TCPアイドルタイムアウト (秒) (任意)
  # TCPアイドルタイムアウト値 (秒)
  # Network Load Balancer でプロトコルが TCP の場合、または
  # Gateway Load Balancer でのみ設定できます。
  # Application Load Balancer ではサポートされていません。
  # 有効な値: 60-6000
  # デフォルト: 350
  # tcp_idle_timeout_seconds = 350

  # リソースID (任意)
  # リスナーの一意識別子
  # 指定しない場合は自動的に生成されます。
  # 通常は指定する必要はありません。
  # id = null

  # リージョン (任意)
  # このリソースが管理されるリージョン
  # デフォルト: プロバイダー設定のリージョン
  # region = "us-east-1"

  # タグ (任意)
  # リソースに割り当てるタグのマップ
  # プロバイダーの default_tags 設定ブロックで設定されている場合、
  # 一致するキーを持つタグは上書きされます。
  # 注意: Name キーがマップで指定されている場合、AWS Console は
  # 特定のロードバランサーリスナーページ内の Listener Rules テーブルの
  # Name Tag 列の値にマップされます。それ以外の場合は Default と表示されます。
  # tags = {
  #   Name        = "example-listener"
  #   Environment = "production"
  # }

  #---------------------------------------------------------------
  # オプションパラメータ - HTTPヘッダーのカスタマイズ
  #---------------------------------------------------------------
  # Application Load Balancer の HTTP/HTTPS プロトコルでのみ使用可能です。
  # Network Load Balancer と Gateway Load Balancer ではサポートされていません。

  #-----------------------------------------------------------
  # HTTPリクエストヘッダー - mTLS クライアント証明書関連
  #-----------------------------------------------------------
  # プロトコルが HTTPS の場合のみ設定可能です。
  # X-Amzn-Mtls-* ヘッダー名をカスタマイズできます。

  # X-Amzn-Mtls-Clientcert ヘッダー名 (任意)
  # routing_http_request_x_amzn_mtls_clientcert_header_name = "X-Amzn-Mtls-Clientcert"

  # X-Amzn-Mtls-Clientcert-Issuer ヘッダー名 (任意)
  # routing_http_request_x_amzn_mtls_clientcert_issuer_header_name = "X-Amzn-Mtls-Clientcert-Issuer"

  # X-Amzn-Mtls-Clientcert-Leaf ヘッダー名 (任意)
  # routing_http_request_x_amzn_mtls_clientcert_leaf_header_name = "X-Amzn-Mtls-Clientcert-Leaf"

  # X-Amzn-Mtls-Clientcert-Serial-Number ヘッダー名 (任意)
  # routing_http_request_x_amzn_mtls_clientcert_serial_number_header_name = "X-Amzn-Mtls-Clientcert-Serial-Number"

  # X-Amzn-Mtls-Clientcert-Subject ヘッダー名 (任意)
  # routing_http_request_x_amzn_mtls_clientcert_subject_header_name = "X-Amzn-Mtls-Clientcert-Subject"

  # X-Amzn-Mtls-Clientcert-Validity ヘッダー名 (任意)
  # routing_http_request_x_amzn_mtls_clientcert_validity_header_name = "X-Amzn-Mtls-Clientcert-Validity"

  #-----------------------------------------------------------
  # HTTPリクエストヘッダー - TLS関連
  #-----------------------------------------------------------
  # プロトコルが HTTPS の場合のみ設定可能です。

  # X-Amzn-Tls-Cipher-Suite ヘッダー名 (任意)
  # routing_http_request_x_amzn_tls_cipher_suite_header_name = "X-Amzn-Tls-Cipher-Suite"

  # X-Amzn-Tls-Version ヘッダー名 (任意)
  # routing_http_request_x_amzn_tls_version_header_name = "X-Amzn-Tls-Version"

  #-----------------------------------------------------------
  # HTTPレスポンスヘッダー - セキュリティ関連
  #-----------------------------------------------------------
  # プロトコルが HTTP または HTTPS の場合のみ設定可能です。

  # Server レスポンスヘッダーの有効化 (任意)
  # HTTP レスポンスサーバーヘッダーを許可または削除できます。
  # 有効な値: true, false
  # routing_http_response_server_enabled = false

  # Strict-Transport-Security ヘッダー値 (任意)
  # ブラウザにHTTPSでのみサイトにアクセスするよう通知し、
  # 将来HTTPでアクセスしようとした場合は自動的にHTTPSに変換されます。
  # デフォルト: max-age=31536000; includeSubDomains; preload
  # 詳細は Strict-Transport-Security のドキュメントを参照してください。
  # routing_http_response_strict_transport_security_header_value = "max-age=31536000; includeSubDomains; preload"

  # Content-Security-Policy ヘッダー値 (任意)
  # 特定の種類のセキュリティ脅威のリスクを最小限に抑えるために
  # ブラウザが実施する制限を指定します。
  # この値は広範囲で、設定時に影響が大きい可能性があるため、
  # Content-Security-Policy のドキュメントを参照してください。
  # routing_http_response_content_security_policy_header_value = "default-src 'self'"

  # X-Content-Type-Options ヘッダー値 (任意)
  # Content-Type ヘッダーで通知されるMIMEタイプに従い、変更されないべきかを示します。
  # 有効な値: nosniff
  # routing_http_response_x_content_type_options_header_value = "nosniff"

  # X-Frame-Options ヘッダー値 (任意)
  # ブラウザがフレーム、iframe、embed、object でページをレンダリングできるかを示します。
  # 有効な値: DENY, SAMEORIGIN, ALLOW-FROM https://example.com
  # routing_http_response_x_frame_options_header_value = "DENY"

  #-----------------------------------------------------------
  # HTTPレスポンスヘッダー - CORS関連
  #-----------------------------------------------------------
  # プロトコルが HTTP または HTTPS の場合のみ設定可能です。

  # Access-Control-Allow-Origin ヘッダー値 (任意)
  # サーバーへのアクセスが許可されるオリジンを指定します。
  # 有効な値は URI です (例: https://example.com)
  # routing_http_response_access_control_allow_origin_header_value = "https://example.com"

  # Access-Control-Allow-Methods ヘッダー値 (任意)
  # 異なるオリジンからサーバーにアクセスする際に許可されるHTTPメソッドを設定します。
  # 有効な値: GET, HEAD, POST, DELETE, CONNECT, OPTIONS, TRACE, PATCH
  # routing_http_response_access_control_allow_methods_header_value = "GET, POST, OPTIONS"

  # Access-Control-Allow-Headers ヘッダー値 (任意)
  # リクエスト中に使用できるヘッダーを指定します。
  # 有効な値: *, Accept, Accept-Language, Cache-Control, Content-Language,
  # Content-Length, Content-Type, Expires, Last-Modified, Pragma
  # ユースケースに応じて他のヘッダーも公開可能です。
  # Access-Control-Allow-Headers のドキュメントを参照してください。
  # routing_http_response_access_control_allow_headers_header_value = "Content-Type, Authorization"

  # Access-Control-Allow-Credentials ヘッダー値 (任意)
  # ブラウザがリクエストする際に認証情報を含めるべきかを指定します。
  # 有効な値: true
  # routing_http_response_access_control_allow_credentials_header_value = "true"

  # Access-Control-Expose-Headers ヘッダー値 (任意)
  # ブラウザがリクエスト元のクライアントに公開すべきヘッダーを指定します。
  # 有効な値: *, Cache-Control, Content-Language, Content-Length,
  # Content-Type, Expires, Last-Modified, Pragma
  # ユースケースに応じて他のヘッダーも公開可能です。
  # Access-Control-Expose-Headers のドキュメントを参照してください。
  # routing_http_response_access_control_expose_headers_header_value = "Content-Length, Date"

  # Access-Control-Max-Age ヘッダー値 (任意)
  # プリフライトリクエストの結果をキャッシュできる時間 (秒) を指定します。
  # 有効な値: 0-86400
  # この値はブラウザ固有です。Access-Control-Max-Age のドキュメントを参照してください。
  # routing_http_response_access_control_max_age_header_value = "86400"

  #---------------------------------------------------------------
  # オプションパラメータ - 相互TLS認証
  #---------------------------------------------------------------

  # mutual_authentication {
  #   # モード (必須)
  #   # 有効な値: off, passthrough, verify
  #   mode = "verify"
  #
  #   # トラストストアARN (verify モードの場合に必須、それ以外は無効)
  #   # ELBv2 トラストストアのARN
  #   # trust_store_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:truststore/my-trust-store/1234567890abcdef"
  #
  #   # トラストストアCA名のアドバタイズ (verify モードの場合に任意、それ以外は無効)
  #   # 有効な値: off, on
  #   # advertise_trust_store_ca_names = "on"
  #
  #   # クライアント証明書の有効期限を無視 (verify モードの場合に任意、それ以外は無効)
  #   # デフォルト: false
  #   # ignore_client_certificate_expiry = false
  # }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # timeouts {
  #   # 作成タイムアウト (任意)
  #   # create = "10m"
  #
  #   # 更新タイムアウト (任意)
  #   # update = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Read-Only)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: リスナーのARN
# - id: リスナーのID (ARNと同じ)
# - tags_all: リソースに割り当てられたタグのマップ
#            プロバイダーの default_tags 設定ブロックから継承したタグを含みます
#
# これらの属性は他のリソースで参照できます:
# - aws_lb_listener.example.arn
# - aws_lb_listener.example.id
# - aws_lb_listener.example.tags_all
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# Load Balancer Listener は ARN を使用してインポートできます:
#
# terraform import aws_lb_listener.example arn:aws:elasticloadbalancing:us-west-2:123456789012:listener/app/my-load-balancer/50dc6c495c0c9188/f2f7dc8efc522ab2
#
# 注意: forward タイプのデフォルトアクションを持つリスナーをインポートする場合、
# インポート時の差分を避けるために、トップレベルのターゲットグループ ARN と
# forward ブロック (target_group と arn を含む) の両方を含める必要があります。
#---------------------------------------------------------------
