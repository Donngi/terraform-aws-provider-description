#---------------------------------------------------------------
# AWS ALB Listener Rule (aws_alb_listener_rule / aws_lb_listener_rule)
#---------------------------------------------------------------
#
# Application Load Balancerのリスナールールをプロビジョニングするリソースです。
# リスナールールは、リクエストを評価する条件とマッチした場合に実行する
# アクション（転送、リダイレクト、固定レスポンス等）を定義します。
#
# NOTE: aws_alb_listener_rule は aws_lb_listener_rule のエイリアスです。
#       機能は同一です。
#
# AWS公式ドキュメント:
#   - リスナールール概要: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/listener-rules.html
#   - 条件タイプ: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/rule-condition-types.html
#   - ルールの追加: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/add-rule.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
#
# Provider Version: 6.28.0
# Generated: 2025-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_alb_listener_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # listener_arn (Required, Forces new resource)
  # 設定内容: ルールをアタッチするリスナーのARNを指定します。
  # 設定可能な値: 有効なリスナーARN
  listener_arn = aws_lb_listener.front_end.arn

  # priority (Optional)
  # 設定内容: ルールの優先度を指定します。
  # 設定可能な値: 1〜50000の整数
  # 省略時: 現在の最高優先度ルールの次の優先度が自動設定されます。
  # 注意: 同一リスナーで同じ優先度を持つ複数のルールは作成できません。
  priority = 100

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-listener-rule"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # アクション設定 (action)
  #-------------------------------------------------------------
  # ルールの条件がマッチした場合に実行されるアクションを定義します。
  # 複数のアクションブロックを指定可能（認証アクション + 転送アクション等）。
  # 最低1つのアクションブロックが必要です。

  action {
    # type (Required)
    # 設定内容: ルーティングアクションのタイプを指定します。
    # 設定可能な値:
    #   - "forward": ターゲットグループへリクエストを転送
    #   - "redirect": 別のURLへリダイレクト
    #   - "fixed-response": カスタムHTTPレスポンスを返却
    #   - "authenticate-cognito": Cognito User Poolで認証
    #   - "authenticate-oidc": OIDCプロバイダーで認証
    #   - "jwt-validation": JWTトークンを検証
    type = "forward"

    # order (Optional)
    # 設定内容: アクションの実行順序を指定します。
    # 設定可能な値: 1〜50000の整数
    # 省略時: アクションリスト内の位置がデフォルト値となります。
    # 注意: 値が小さいアクションが先に実行されます。
    order = 1

    # target_group_arn (Optional)
    # 設定内容: トラフィックをルーティングするターゲットグループのARNを指定します。
    # 設定可能な値: 有効なターゲットグループARN
    # 注意:
    #   - typeが"forward"で単一ターゲットグループにルーティングする場合のみ指定
    #   - 複数ターゲットグループにルーティングする場合はforwardブロックを使用
    #   - forwardブロックとは排他的（同時指定不可）
    target_group_arn = aws_lb_target_group.main.arn

    #-----------------------------------------------------------
    # 転送設定 (forward) - 重み付けルーティング用
    #-----------------------------------------------------------
    # 複数のターゲットグループに重み付けでトラフィックを分散する場合に使用。
    # target_group_arnとは排他的です。

    # forward {
    #   # target_group (Required)
    #   # 設定内容: ターゲットグループとその重みを指定します。
    #   # 最小1、最大5つのターゲットグループを指定可能。
    #
    #   target_group {
    #     # arn (Required)
    #     # 設定内容: ターゲットグループのARNを指定します。
    #     arn = aws_lb_target_group.main.arn
    #
    #     # weight (Optional)
    #     # 設定内容: このターゲットグループへのトラフィック配分の重みを指定します。
    #     # 設定可能な値: 0〜999の整数
    #     weight = 80
    #   }
    #
    #   target_group {
    #     arn    = aws_lb_target_group.canary.arn
    #     weight = 20
    #   }
    #
    #   # stickiness (Optional)
    #   # 設定内容: ターゲットグループスティッキネスを設定します。
    #   # 関連機能: セッション維持機能
    #   #   同一クライアントからのリクエストを一定期間同じターゲットグループに送信。
    #   stickiness {
    #     # enabled (Optional)
    #     # 設定内容: スティッキネスを有効にするかを指定します。
    #     # 設定可能な値: true / false
    #     enabled = true
    #
    #     # duration (Required)
    #     # 設定内容: スティッキネスの持続時間（秒）を指定します。
    #     # 設定可能な値: 1〜604800（7日間）
    #     duration = 600
    #   }
    # }

    #-----------------------------------------------------------
    # リダイレクト設定 (redirect)
    #-----------------------------------------------------------
    # type = "redirect" の場合に必須。
    # URIコンポーネントを再利用する予約キーワード:
    #   #{protocol}, #{host}, #{port}, #{path}, #{query}

    # redirect {
    #   # host (Optional)
    #   # 設定内容: リダイレクト先のホスト名を指定します。
    #   # 設定可能な値: ホスト名文字列。#{host}を含めることができます。
    #   # 省略時: #{host} (元のホスト名を維持)
    #   host = "#{host}"
    #
    #   # path (Optional)
    #   # 設定内容: リダイレクト先のパスを指定します。
    #   # 設定可能な値: "/" で始まる絶対パス。#{host}, #{path}, #{port}を含めることができます。
    #   # 省略時: /#{path} (元のパスを維持)
    #   path = "/#{path}"
    #
    #   # port (Optional)
    #   # 設定内容: リダイレクト先のポート番号を指定します。
    #   # 設定可能な値: 1〜65535の文字列、または #{port}
    #   # 省略時: #{port} (元のポートを維持)
    #   port = "443"
    #
    #   # protocol (Optional)
    #   # 設定内容: リダイレクト先のプロトコルを指定します。
    #   # 設定可能な値: "HTTP", "HTTPS", または #{protocol}
    #   # 省略時: #{protocol} (元のプロトコルを維持)
    #   protocol = "HTTPS"
    #
    #   # query (Optional)
    #   # 設定内容: リダイレクト先のクエリパラメータを指定します。
    #   # 設定可能な値: クエリ文字列（先頭の"?"は不要）
    #   # 省略時: #{query} (元のクエリを維持)
    #   query = "#{query}"
    #
    #   # status_code (Required)
    #   # 設定内容: HTTPリダイレクトコードを指定します。
    #   # 設定可能な値:
    #   #   - "HTTP_301": 恒久的リダイレクト
    #   #   - "HTTP_302": 一時的リダイレクト
    #   status_code = "HTTP_301"
    # }

    #-----------------------------------------------------------
    # 固定レスポンス設定 (fixed_response)
    #-----------------------------------------------------------
    # type = "fixed-response" の場合に必須。

    # fixed_response {
    #   # content_type (Required)
    #   # 設定内容: レスポンスのContent-Typeを指定します。
    #   # 設定可能な値:
    #   #   - "text/plain"
    #   #   - "text/css"
    #   #   - "text/html"
    #   #   - "application/javascript"
    #   #   - "application/json"
    #   content_type = "text/plain"
    #
    #   # message_body (Optional)
    #   # 設定内容: レスポンスボディを指定します。
    #   # 設定可能な値: 文字列
    #   message_body = "HEALTHY"
    #
    #   # status_code (Optional)
    #   # 設定内容: HTTPステータスコードを指定します。
    #   # 設定可能な値: "2XX", "4XX", "5XX" 形式の文字列（例: "200", "404"）
    #   status_code = "200"
    # }

    #-----------------------------------------------------------
    # Cognito認証設定 (authenticate_cognito)
    #-----------------------------------------------------------
    # type = "authenticate-cognito" の場合に必須。
    # 関連機能: Amazon Cognito User Pool認証
    #   ALBでCognito User Poolを使用してユーザー認証を実行。

    # authenticate_cognito {
    #   # user_pool_arn (Required)
    #   # 設定内容: Cognito User PoolのARNを指定します。
    #   user_pool_arn = aws_cognito_user_pool.pool.arn
    #
    #   # user_pool_client_id (Required)
    #   # 設定内容: Cognito User PoolクライアントIDを指定します。
    #   user_pool_client_id = aws_cognito_user_pool_client.client.id
    #
    #   # user_pool_domain (Required)
    #   # 設定内容: Cognito User Poolドメイン（プレフィックスまたはFQDN）を指定します。
    #   user_pool_domain = aws_cognito_user_pool_domain.domain.domain
    #
    #   # authentication_request_extra_params (Optional)
    #   # 設定内容: 認可エンドポイントへのリダイレクトリクエストに含める追加クエリパラメータを指定します。
    #   # 設定可能な値: キーと値のペアのマップ（最大10個）
    #   authentication_request_extra_params = {
    #     prompt = "login"
    #   }
    #
    #   # on_unauthenticated_request (Optional)
    #   # 設定内容: 未認証ユーザーへの動作を指定します。
    #   # 設定可能な値:
    #   #   - "deny": アクセス拒否
    #   #   - "allow": 認証なしでアクセス許可
    #   #   - "authenticate": 認証を要求
    #   on_unauthenticated_request = "authenticate"
    #
    #   # scope (Optional)
    #   # 設定内容: IdPからリクエストするユーザークレームのセットを指定します。
    #   # 設定可能な値: スコープ文字列
    #   scope = "openid"
    #
    #   # session_cookie_name (Optional)
    #   # 設定内容: セッション情報を維持するCookie名を指定します。
    #   session_cookie_name = "AWSELBAuthSessionCookie"
    #
    #   # session_timeout (Optional)
    #   # 設定内容: 認証セッションの最大持続時間（秒）を指定します。
    #   session_timeout = 3600
    # }

    #-----------------------------------------------------------
    # OIDC認証設定 (authenticate_oidc)
    #-----------------------------------------------------------
    # type = "authenticate-oidc" の場合に必須。
    # 関連機能: OpenID Connect認証
    #   ALBでOIDC準拠のIdPを使用してユーザー認証を実行。

    # authenticate_oidc {
    #   # authorization_endpoint (Required)
    #   # 設定内容: IdPの認可エンドポイントURLを指定します。
    #   authorization_endpoint = "https://example.com/authorization_endpoint"
    #
    #   # client_id (Required)
    #   # 設定内容: OAuth 2.0クライアント識別子を指定します。
    #   client_id = "client_id"
    #
    #   # client_secret (Required, Sensitive)
    #   # 設定内容: OAuth 2.0クライアントシークレットを指定します。
    #   # 注意: この値は機密情報として扱われます。
    #   client_secret = "client_secret"
    #
    #   # issuer (Required)
    #   # 設定内容: IdPのOIDC発行者識別子を指定します。
    #   issuer = "https://example.com"
    #
    #   # token_endpoint (Required)
    #   # 設定内容: IdPのトークンエンドポイントURLを指定します。
    #   token_endpoint = "https://example.com/token_endpoint"
    #
    #   # user_info_endpoint (Required)
    #   # 設定内容: IdPのユーザー情報エンドポイントURLを指定します。
    #   user_info_endpoint = "https://example.com/user_info_endpoint"
    #
    #   # authentication_request_extra_params (Optional)
    #   # 設定内容: 認可エンドポイントへのリダイレクトリクエストに含める追加クエリパラメータを指定します。
    #   # 設定可能な値: キーと値のペアのマップ（最大10個）
    #   authentication_request_extra_params = {
    #     prompt = "login"
    #   }
    #
    #   # on_unauthenticated_request (Optional)
    #   # 設定内容: 未認証ユーザーへの動作を指定します。
    #   # 設定可能な値:
    #   #   - "deny": アクセス拒否
    #   #   - "allow": 認証なしでアクセス許可
    #   #   - "authenticate": 認証を要求
    #   on_unauthenticated_request = "authenticate"
    #
    #   # scope (Optional)
    #   # 設定内容: IdPからリクエストするユーザークレームのセットを指定します。
    #   scope = "openid"
    #
    #   # session_cookie_name (Optional)
    #   # 設定内容: セッション情報を維持するCookie名を指定します。
    #   session_cookie_name = "AWSELBAuthSessionCookie"
    #
    #   # session_timeout (Optional)
    #   # 設定内容: 認証セッションの最大持続時間（秒）を指定します。
    #   session_timeout = 3600
    # }

    #-----------------------------------------------------------
    # JWT検証設定 (jwt_validation)
    #-----------------------------------------------------------
    # type = "jwt-validation" の場合に必須。
    # 関連機能: JWTトークン検証
    #   ALBでJWTトークンを検証し、有効なトークンを持つリクエストのみを許可。

    # jwt_validation {
    #   # issuer (Required)
    #   # 設定内容: JWTの発行者を指定します。
    #   issuer = "https://example.com"
    #
    #   # jwks_endpoint (Required)
    #   # 設定内容: JSON Web Key Set (JWKS) エンドポイントを指定します。
    #   # 設定可能な値: HTTPSプロトコルを含む完全なURL
    #   # 注意: このエンドポイントにはJWTの署名を検証するためのJWKが含まれます。
    #   jwks_endpoint = "https://example.com/.well-known/jwks.json"
    #
    #   # additional_claim (Optional)
    #   # 設定内容: 検証する追加のクレームを指定します。
    #   # 最大10個まで指定可能。
    #   additional_claim {
    #     # format (Required)
    #     # 設定内容: クレーム値のフォーマットを指定します。
    #     # 設定可能な値:
    #     #   - "single-string": 単一文字列
    #     #   - "string-array": 文字列配列
    #     #   - "space-separated-values": スペース区切りの値
    #     format = "string-array"
    #
    #     # name (Required)
    #     # 設定内容: 検証するクレーム名を指定します。
    #     # 注意: exp, iss, nbf, iat はデフォルトで検証されるため指定不可
    #     name = "groups"
    #
    #     # values (Required)
    #     # 設定内容: クレームの期待値リストを指定します。
    #     values = ["admin", "users"]
    #   }
    # }
  }

  #-------------------------------------------------------------
  # 条件設定 (condition)
  #-------------------------------------------------------------
  # ルールがマッチするかを判定する条件を定義します。
  # 複数のconditionブロックを指定可能（全て満たす必要があります）。
  # 各ルールには最大5つの条件評価を含めることができます。
  # 最低1つのconditionブロックが必要です。

  condition {
    #-----------------------------------------------------------
    # パスパターン条件 (path_pattern)
    #-----------------------------------------------------------
    # リクエストURLのパスに基づいてルーティング。
    # ワイルドカード: * (0文字以上), ? (1文字)
    # 大文字小文字を区別します。

    path_pattern {
      # values (Optional)
      # 設定内容: マッチさせるパスパターンのリストを指定します。
      # 設定可能な値: 最大128文字のパターン文字列のセット
      # 注意: regex_valuesと排他的（どちらか一方のみ指定可能）
      values = ["/api/*", "/static/*"]

      # regex_values (Optional)
      # 設定内容: パスにマッチさせる正規表現のリストを指定します。
      # 設定可能な値: 最大128文字の正規表現文字列のセット
      # 注意: valuesと排他的（どちらか一方のみ指定可能）
      # regex_values = ["^/api/v[0-9]+/.*$"]
    }
  }

  condition {
    #-----------------------------------------------------------
    # ホストヘッダー条件 (host_header)
    #-----------------------------------------------------------
    # ホストヘッダーのホスト名に基づいてルーティング。
    # ワイルドカード: * (0文字以上), ? (1文字)
    # 大文字小文字を区別しません。

    host_header {
      # values (Optional)
      # 設定内容: マッチさせるホストヘッダー値パターンのリストを指定します。
      # 設定可能な値: 最大128文字のパターン文字列のセット
      # 注意: regex_valuesと排他的
      values = ["example.com", "*.example.com"]

      # regex_values (Optional)
      # 設定内容: ホストヘッダーにマッチさせる正規表現のリストを指定します。
      # 注意: valuesと排他的
      # regex_values = ["^.*\\.example\\.com$"]
    }
  }

  #-----------------------------------------------------------
  # HTTPヘッダー条件 (http_header) - 例
  #-----------------------------------------------------------
  # 特定のHTTPヘッダーの値に基づいてルーティング。

  # condition {
  #   http_header {
  #     # http_header_name (Required)
  #     # 設定内容: 検索するHTTPヘッダー名を指定します。
  #     # 設定可能な値: 最大40文字（RFC7240準拠文字のみ）
  #     # 注意: ホストヘッダーはhost_header条件を使用してください
  #     http_header_name = "X-Custom-Header"
  #
  #     # values (Optional)
  #     # 設定内容: マッチさせるヘッダー値パターンのリストを指定します。
  #     # 設定可能な値: 最大128文字のパターン文字列のセット
  #     # ワイルドカード: * (0文字以上), ? (1文字)
  #     # 大文字小文字を区別しません。
  #     # 注意: regex_valuesと排他的
  #     values = ["value1", "value2*"]
  #
  #     # regex_values (Optional)
  #     # 設定内容: ヘッダー値にマッチさせる正規表現のリストを指定します。
  #     # 注意: valuesと排他的
  #     # regex_values = ["^custom-.*$"]
  #   }
  # }

  #-----------------------------------------------------------
  # HTTPリクエストメソッド条件 (http_request_method) - 例
  #-----------------------------------------------------------
  # HTTPリクエストメソッドに基づいてルーティング。

  # condition {
  #   http_request_method {
  #     # values (Required)
  #     # 設定内容: マッチさせるHTTPリクエストメソッドのリストを指定します。
  #     # 設定可能な値: GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS等
  #     #   最大40文字、A-Z・ハイフン・アンダースコアのみ
  #     # 大文字小文字を区別します。ワイルドカード不可。
  #     # 注意: GETとHEADは同じ方法でルーティングすることを推奨
  #     values = ["GET", "POST"]
  #   }
  # }

  #-----------------------------------------------------------
  # クエリ文字列条件 (query_string) - 例
  #-----------------------------------------------------------
  # クエリ文字列のキー/値ペアに基づいてルーティング。

  # condition {
  #   query_string {
  #     # key (Optional)
  #     # 設定内容: マッチさせるクエリ文字列のキーパターンを指定します。
  #     key = "version"
  #
  #     # value (Required)
  #     # 設定内容: マッチさせるクエリ文字列の値パターンを指定します。
  #     # 設定可能な値: 最大128文字のパターン文字列
  #     # ワイルドカード: * (0文字以上), ? (1文字)
  #     # 大文字小文字を区別しません。
  #     value = "v2"
  #   }
  #
  #   # 複数のquery_stringブロックを同一condition内に指定可能
  #   query_string {
  #     value = "bar"
  #   }
  # }

  #-----------------------------------------------------------
  # ソースIP条件 (source_ip) - 例
  #-----------------------------------------------------------
  # リクエストのソースIPアドレスに基づいてルーティング。

  # condition {
  #   source_ip {
  #     # values (Required)
  #     # 設定内容: マッチさせるソースIPのCIDR表記リストを指定します。
  #     # 設定可能な値: IPv4およびIPv6のCIDR表記
  #     # 注意: X-Forwarded-Forヘッダーのアドレスでは条件を満たしません。
  #     #       ヘッダーベースの条件にはhttp_header条件を使用してください。
  #     values = ["10.0.0.0/8", "192.168.0.0/16"]
  #   }
  # }

  #-------------------------------------------------------------
  # 変換設定 (transform)
  #-------------------------------------------------------------
  # ルールにマッチしたリクエストに適用する変換を定義します。
  # 最大2つのtransformブロックを指定可能。
  # 削除するには設定からtransformブロックを削除します。

  # transform {
  #   # type (Required)
  #   # 設定内容: 変換のタイプを指定します。
  #   # 設定可能な値:
  #   #   - "host-header-rewrite": ホストヘッダーを書き換え
  #   #   - "url-rewrite": URLを書き換え
  #   type = "host-header-rewrite"
  #
  #   #---------------------------------------------------------
  #   # ホストヘッダー書き換え設定 (host_header_rewrite_config)
  #   #---------------------------------------------------------
  #   # type = "host-header-rewrite" の場合に必須。
  #
  #   host_header_rewrite_config {
  #     rewrite {
  #       # regex (Required)
  #       # 設定内容: 入力文字列でマッチさせる正規表現を指定します。
  #       # 設定可能な値: 1〜1024文字の正規表現
  #       regex = "^mywebsite-(.+).com$"
  #
  #       # replace (Required)
  #       # 設定内容: マッチした入力を書き換える置換文字列を指定します。
  #       # 設定可能な値: 0〜1024文字の文字列
  #       # 注意: キャプチャグループ ($1, $2等) を使用可能
  #       replace = "internal.dev.$1.myweb.com"
  #     }
  #   }
  # }

  # transform {
  #   type = "url-rewrite"
  #
  #   #---------------------------------------------------------
  #   # URL書き換え設定 (url_rewrite_config)
  #   #---------------------------------------------------------
  #   # type = "url-rewrite" の場合に必須。
  #
  #   url_rewrite_config {
  #     rewrite {
  #       # regex (Required)
  #       # 設定内容: 入力URLでマッチさせる正規表現を指定します。
  #       regex = "^/dp/([A-Za-z0-9]+)/?$"
  #
  #       # replace (Required)
  #       # 設定内容: マッチしたURLを書き換える置換文字列を指定します。
  #       replace = "/product.php?id=$1"
  #     }
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ルールのARN (arnと同じ値)
#
# - arn: ルールのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
