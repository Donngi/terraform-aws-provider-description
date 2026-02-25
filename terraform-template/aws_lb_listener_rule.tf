#---------------------------------------------------------------
# AWS Load Balancer Listener Rule
#---------------------------------------------------------------
#
# Application Load Balancer (ALB) のリスナーにルールをアタッチするリソースです。
# ルールは条件（パスパターン、ホストヘッダー、HTTPヘッダー等）を定義し、
# 条件に一致したリクエストに対するアクション（フォワード、リダイレクト、
# 固定レスポンス、Cognito/OIDC認証、JWT検証等）を設定します。
#
# AWS公式ドキュメント:
#   - ALBリスナールール概要: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/listener-update-rules.html
#   - ルール条件タイプ: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html#rule-condition-types
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_listener_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # listener_arn (Required, Forces new resource)
  # 設定内容: ルールをアタッチするリスナーのARNを指定します。
  # 設定可能な値: 有効なALBリスナーARN
  listener_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:listener/app/my-alb/1234567890abcdef/1234567890abcdef"

  # priority (Optional)
  # 設定内容: ルールの優先度を指定します。値が低いほど優先度が高くなります。
  # 設定可能な値: 1 〜 50000 の整数
  # 省略時: 現在存在するルールのうち最大の優先度の次の値が自動設定されます。
  # 注意: 同一リスナー内で同じ優先度を持つルールは設定できません。
  priority = 100

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # アクション設定
  #-------------------------------------------------------------

  # action (Required)
  # 設定内容: 条件に一致したリクエストに対して実行するアクションを定義するブロックです。
  # 注意: 複数のactionブロックを指定する場合、orderで実行順を制御します。
  #       type が "forward" の場合は target_group_arn または forward ブロックのどちらかを指定します。
  action {

    # type (Required)
    # 設定内容: ルーティングアクションのタイプを指定します。
    # 設定可能な値:
    #   - "forward": ターゲットグループへのリクエスト転送
    #   - "redirect": URLリダイレクト
    #   - "fixed-response": カスタムHTTPレスポンスを返す
    #   - "authenticate-cognito": Amazon Cognitoによる認証
    #   - "authenticate-oidc": OIDCプロバイダーによる認証
    #   - "jwt-validation": JWTトークンの検証
    type = "forward"

    # target_group_arn (Optional)
    # 設定内容: リクエストを転送するターゲットグループのARNを指定します。
    # 設定可能な値: 有効なターゲットグループARN
    # 省略時: forward ブロックで複数のターゲットグループを指定する場合は省略します。
    # 注意: type が "forward" の場合のみ有効。forward ブロックとは同時に指定できません。
    target_group_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:targetgroup/my-tg/1234567890abcdef"

    # order (Optional)
    # 設定内容: アクションの実行順序を指定します。値が低いほど先に実行されます。
    # 設定可能な値: 1 〜 50000 の整数
    # 省略時: action ブロックのリスト内の位置順に設定されます。
    order = 1

    #-------------------------------------------------------------
    # フォワードアクション設定（forward ブロック）
    #-------------------------------------------------------------

    # forward (Optional)
    # 設定内容: 重み付きルーティングで複数のターゲットグループにリクエストを分散する設定ブロックです。
    # 設定内容: type が "forward" の場合のみ有効。target_group_arn とは同時に指定できません。
    # 注意: 1〜5個の target_group ブロックを指定する必要があります。
    forward {

      #-------------------------------------------------------------
      # フォワード先ターゲットグループ設定
      #-------------------------------------------------------------

      # target_group (Required, min_items=1, max_items=5)
      # 設定内容: フォワード先のターゲットグループとその重みを指定するブロックです。
      # 注意: 最低1つ、最大5つまで指定可能です。
      target_group {

        # arn (Required)
        # 設定内容: ターゲットグループのARNを指定します。
        # 設定可能な値: 有効なターゲットグループARN
        arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:targetgroup/my-tg-main/1234567890abcdef"

        # weight (Optional)
        # 設定内容: このターゲットグループへのリクエスト転送の重みを指定します。
        # 設定可能な値: 0 〜 999 の整数
        # 省略時: 均等に分散されます。
        weight = 80
      }

      target_group {
        arn    = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:targetgroup/my-tg-canary/abcdef1234567890"
        weight = 20
      }

      #-------------------------------------------------------------
      # スティッキーセッション設定
      #-------------------------------------------------------------

      # stickiness (Optional)
      # 設定内容: ターゲットグループのスティッキーセッション設定ブロックです。
      # 設定内容: 有効化すると、一定期間同じクライアントからのリクエストを同じターゲットグループに転送します。
      stickiness {

        # duration (Required)
        # 設定内容: スティッキーセッションの持続時間を秒単位で指定します。
        # 設定可能な値: 1 〜 604800 秒（7日間）
        duration = 600

        # enabled (Optional)
        # 設定内容: スティッキーセッションを有効にするかを指定します。
        # 設定可能な値:
        #   - true: スティッキーセッションを有効化
        #   - false: スティッキーセッションを無効化
        enabled = true
      }
    }

    #-------------------------------------------------------------
    # リダイレクトアクション設定
    #-------------------------------------------------------------

    # redirect (Optional)
    # 設定内容: URLリダイレクトを設定するブロックです。
    # 注意: type が "redirect" の場合に必須です。
    #       URIコンポーネントには #{protocol}, #{host}, #{port}, #{path}, #{query} が使用できます。
    redirect {

      # status_code (Required)
      # 設定内容: HTTPリダイレクトコードを指定します。
      # 設定可能な値:
      #   - "HTTP_301": 恒久的リダイレクト
      #   - "HTTP_302": 一時的リダイレクト
      status_code = "HTTP_301"

      # host (Optional)
      # 設定内容: リダイレクト先のホスト名を指定します。パーセントエンコードはされません。
      # 設定可能な値: ホスト名文字列。#{host} キーワードが使用可能です。
      # 省略時: #{host}（元のホスト名を維持）
      host = "#{host}"

      # path (Optional)
      # 設定内容: リダイレクト先の絶対パスを指定します。先頭は "/" で始まります。
      # 設定可能な値: パス文字列。#{host}, #{path}, #{port} キーワードが使用可能です。
      # 省略時: /#{path}（元のパスを維持）
      path = "/#{path}"

      # port (Optional)
      # 設定内容: リダイレクト先のポートを指定します。
      # 設定可能な値: 1 〜 65535 の整数値文字列、または "#{port}"
      # 省略時: #{port}（元のポートを維持）
      port = "#{port}"

      # protocol (Optional)
      # 設定内容: リダイレクト先のプロトコルを指定します。
      # 設定可能な値: "HTTP", "HTTPS", "#{protocol}"
      # 省略時: #{protocol}（元のプロトコルを維持）
      protocol = "HTTPS"

      # query (Optional)
      # 設定内容: リダイレクト先のクエリパラメータを指定します。先頭に "?" は含めません。
      # 設定可能な値: クエリパラメータ文字列（URLエンコード済み）
      # 省略時: #{query}（元のクエリパラメータを維持）
      query = "#{query}"
    }

    #-------------------------------------------------------------
    # 固定レスポンスアクション設定
    #-------------------------------------------------------------

    # fixed_response (Optional)
    # 設定内容: カスタムHTTPレスポンスを返すアクションの設定ブロックです。
    # 注意: type が "fixed-response" の場合に必須です。
    fixed_response {

      # content_type (Required)
      # 設定内容: レスポンスのContent-Typeを指定します。
      # 設定可能な値:
      #   - "text/plain"
      #   - "text/css"
      #   - "text/html"
      #   - "application/javascript"
      #   - "application/json"
      content_type = "text/plain"

      # message_body (Optional)
      # 設定内容: レスポンスのメッセージボディを指定します。
      # 設定可能な値: 文字列（最大1024バイト）
      message_body = "HEALTHY"

      # status_code (Optional)
      # 設定内容: HTTPレスポンスコードを指定します。
      # 設定可能な値: "2XX", "4XX", "5XX"
      # 省略時: "200"
      status_code = "200"
    }

    #-------------------------------------------------------------
    # Cognito認証アクション設定
    #-------------------------------------------------------------

    # authenticate_cognito (Optional)
    # 設定内容: Amazon Cognitoを使用した認証アクションの設定ブロックです。
    # 注意: type が "authenticate-cognito" の場合に必須です。
    # 参考: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/listener-authenticate-users.html
    authenticate_cognito {

      # user_pool_arn (Required)
      # 設定内容: Cognitoユーザープールの ARN を指定します。
      # 設定可能な値: 有効なCognitoユーザープールARN
      user_pool_arn = "arn:aws:cognito-idp:ap-northeast-1:123456789012:userpool/ap-northeast-1_XXXXXXXXX"

      # user_pool_client_id (Required)
      # 設定内容: Cognitoユーザープールクライアントの ID を指定します。
      # 設定可能な値: 有効なCognitoユーザープールクライアントID
      user_pool_client_id = "abcdefghijklmnopqrstuvwxyz"

      # user_pool_domain (Required)
      # 設定内容: Cognitoユーザープールのドメインプレフィックスまたは完全修飾ドメイン名を指定します。
      # 設定可能な値: ドメインプレフィックス文字列またはFQDN
      user_pool_domain = "my-app-domain"

      # authentication_request_extra_params (Optional)
      # 設定内容: 認可エンドポイントへのリダイレクトリクエストに含めるクエリパラメータのマップを指定します。
      # 設定可能な値: 文字列のキーバリューマップ（最大10個）
      authentication_request_extra_params = {}

      # on_unauthenticated_request (Optional)
      # 設定内容: ユーザーが認証されていない場合の動作を指定します。
      # 設定可能な値:
      #   - "authenticate": 認証フローを開始する（デフォルト）
      #   - "allow": 未認証のままリクエストを通過させる
      #   - "deny": HTTP 401 Unauthorized を返す
      on_unauthenticated_request = "authenticate"

      # scope (Optional)
      # 設定内容: IdPに要求するユーザークレームのセットを指定します。
      # 設定可能な値: スペース区切りのスコープ文字列（例: "openid email profile"）
      scope = "openid"

      # session_cookie_name (Optional)
      # 設定内容: セッション情報を保持するCookieの名前を指定します。
      # 設定可能な値: 有効なCookie名文字列
      session_cookie_name = "AWSELBAuthSessionCookie"

      # session_timeout (Optional)
      # 設定内容: 認証セッションの最大継続時間を秒単位で指定します。
      # 設定可能な値: 正の整数（秒）
      session_timeout = 3600
    }

    #-------------------------------------------------------------
    # OIDC認証アクション設定
    #-------------------------------------------------------------

    # authenticate_oidc (Optional)
    # 設定内容: OIDCプロバイダーを使用した認証アクションの設定ブロックです。
    # 注意: type が "authenticate-oidc" の場合に必須です。
    # 参考: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/listener-authenticate-users.html
    authenticate_oidc {

      # authorization_endpoint (Required)
      # 設定内容: IdPの認可エンドポイントのURLを指定します。
      # 設定可能な値: 有効なHTTPS URL
      authorization_endpoint = "https://example.com/authorization_endpoint"

      # client_id (Required)
      # 設定内容: OAuth 2.0 クライアント識別子を指定します。
      # 設定可能な値: OIDCプロバイダーから発行されたクライアントID文字列
      client_id = "my-client-id"

      # client_secret (Required)
      # 設定内容: OAuth 2.0 クライアントシークレットを指定します。
      # 設定可能な値: OIDCプロバイダーから発行されたクライアントシークレット文字列
      # 注意: 機密情報のため、変数参照またはSecretsManagerの参照を推奨します。
      client_secret = "my-client-secret"

      # issuer (Required)
      # 設定内容: OIDCプロバイダーの発行者識別子を指定します。
      # 設定可能な値: 有効なHTTPS URL（OIDC Discovery DocumentのベースURL）
      issuer = "https://example.com"

      # token_endpoint (Required)
      # 設定内容: IdPのトークンエンドポイントのURLを指定します。
      # 設定可能な値: 有効なHTTPS URL
      token_endpoint = "https://example.com/token_endpoint"

      # user_info_endpoint (Required)
      # 設定内容: IdPのユーザー情報エンドポイントのURLを指定します。
      # 設定可能な値: 有効なHTTPS URL
      user_info_endpoint = "https://example.com/user_info_endpoint"

      # authentication_request_extra_params (Optional)
      # 設定内容: 認可エンドポイントへのリダイレクトリクエストに含めるクエリパラメータのマップを指定します。
      # 設定可能な値: 文字列のキーバリューマップ（最大10個）
      authentication_request_extra_params = {}

      # on_unauthenticated_request (Optional)
      # 設定内容: ユーザーが認証されていない場合の動作を指定します。
      # 設定可能な値:
      #   - "authenticate": 認証フローを開始する（デフォルト）
      #   - "allow": 未認証のままリクエストを通過させる
      #   - "deny": HTTP 401 Unauthorized を返す
      on_unauthenticated_request = "authenticate"

      # scope (Optional)
      # 設定内容: IdPに要求するユーザークレームのセットを指定します。
      # 設定可能な値: スペース区切りのスコープ文字列（例: "openid email profile"）
      scope = "openid"

      # session_cookie_name (Optional)
      # 設定内容: セッション情報を保持するCookieの名前を指定します。
      # 設定可能な値: 有効なCookie名文字列
      session_cookie_name = "AWSELBAuthSessionCookie"

      # session_timeout (Optional)
      # 設定内容: 認証セッションの最大継続時間を秒単位で指定します。
      # 設定可能な値: 正の整数（秒）
      session_timeout = 3600
    }

    #-------------------------------------------------------------
    # JWT検証アクション設定
    #-------------------------------------------------------------

    # jwt_validation (Optional)
    # 設定内容: JWTトークンを検証する認証アクションの設定ブロックです。
    # 注意: type が "jwt-validation" の場合に必須です。
    jwt_validation {

      # issuer (Required)
      # 設定内容: JWTの発行者識別子を指定します。
      # 設定可能な値: 有効なHTTPS URL
      issuer = "https://example.com"

      # jwks_endpoint (Required)
      # 設定内容: JWTの署名を検証するためのJSON Web Key Set (JWKS) エンドポイントのURLを指定します。
      # 設定可能な値: 有効なHTTPS URLのフルパス（プロトコル・ドメイン・パスを含む）
      jwks_endpoint = "https://example.com/.well-known/jwks.json"

      #-------------------------------------------------------------
      # 追加クレーム検証設定
      #-------------------------------------------------------------

      # additional_claim (Optional, max_items=10)
      # 設定内容: 検証する追加クレームを定義するブロックです。
      # 注意: exp, iss, nbf, iat はデフォルトで検証されるため指定できません。最大10個まで指定可能です。
      additional_claim {

        # format (Required)
        # 設定内容: クレーム値のフォーマットを指定します。
        # 設定可能な値:
        #   - "single-string": 単一の文字列値
        #   - "string-array": 文字列の配列値
        #   - "space-separated-values": スペース区切りの文字列値
        format = "string-array"

        # name (Required)
        # 設定内容: 検証するクレームの名前を指定します。
        # 設定可能な値: クレーム名文字列（exp, iss, nbf, iat は指定不可）
        name = "groups"

        # values (Required)
        # 設定内容: クレームに期待する値のリストを指定します。
        # 設定可能な値: 文字列のセット
        values = ["admin", "operator"]
      }
    }
  }

  #-------------------------------------------------------------
  # 条件設定
  #-------------------------------------------------------------

  # condition (Required, min_items=1)
  # 設定内容: ルールが適用されるリクエストの条件を定義するブロックです。
  # 注意: 複数の condition ブロックを指定できますが、各ブロック内では
  #       host_header, http_header, http_request_method, path_pattern,
  #       query_string, source_ip のうちいずれか1つのみ指定できます。
  condition {

    #-------------------------------------------------------------
    # ホストヘッダー条件設定
    #-------------------------------------------------------------

    # host_header (Optional)
    # 設定内容: ホストヘッダーのパターンによる条件設定ブロックです。
    # 注意: condition ブロック内で他の条件タイプとは排他的です。
    host_header {

      # regex_values (Optional)
      # 設定内容: ホストヘッダーと比較する正規表現のリストを指定します。
      # 設定可能な値: 最大128文字の正規表現文字列のセット
      # 注意: values と同時に指定できません。
      regex_values = []

      # values (Optional)
      # 設定内容: ホストヘッダーと比較するパターンのリストを指定します。
      # 設定可能な値: 最大128文字の文字列のセット（大文字小文字の区別なし、ワイルドカード * と ? をサポート）
      # 注意: regex_values と同時に指定できません。
      values = ["example.com", "*.example.com"]
    }
  }

  condition {

    #-------------------------------------------------------------
    # HTTPヘッダー条件設定
    #-------------------------------------------------------------

    # http_header (Optional)
    # 設定内容: HTTPヘッダーのパターンによる条件設定ブロックです。
    # 注意: condition ブロック内で他の条件タイプとは排他的です。
    http_header {

      # http_header_name (Required)
      # 設定内容: 検索するHTTPヘッダーの名前を指定します。
      # 設定可能な値: 最大40文字のRFC7240準拠の文字列（大文字小文字の区別なし、ワイルドカード不可）
      # 注意: ホストヘッダーを指定する場合は host_header 条件を使用してください。
      http_header_name = "X-Custom-Header"

      # regex_values (Optional)
      # 設定内容: HTTPヘッダー値と比較する正規表現のリストを指定します。
      # 設定可能な値: 最大128文字の正規表現文字列のセット
      # 注意: values と同時に指定できません。
      regex_values = []

      # values (Optional)
      # 設定内容: HTTPヘッダー値と比較するパターンのリストを指定します。
      # 設定可能な値: 最大128文字の文字列のセット（大文字小文字の区別なし、ワイルドカード * と ? をサポート）
      # 注意: regex_values と同時に指定できません。
      values = ["custom-value"]
    }
  }

  condition {

    #-------------------------------------------------------------
    # HTTPリクエストメソッド条件設定
    #-------------------------------------------------------------

    # http_request_method (Optional)
    # 設定内容: HTTPリクエストメソッドによる条件設定ブロックです。
    # 注意: condition ブロック内で他の条件タイプとは排他的です。
    http_request_method {

      # values (Required)
      # 設定内容: マッチさせるHTTPリクエストメソッドのリストを指定します。
      # 設定可能な値: A-Z、ハイフン(-)、アンダースコア(_)のみの最大40文字の文字列のセット（大文字小文字を区別、ワイルドカード不可）
      # 注意: GETとHEADリクエストは同様にルーティングすることをAWSは推奨しています。
      values = ["GET", "HEAD"]
    }
  }

  condition {

    #-------------------------------------------------------------
    # パスパターン条件設定
    #-------------------------------------------------------------

    # path_pattern (Optional)
    # 設定内容: リクエストURLのパスパターンによる条件設定ブロックです。
    # 注意: condition ブロック内で他の条件タイプとは排他的です。
    path_pattern {

      # regex_values (Optional)
      # 設定内容: リクエストURLと比較する正規表現のリストを指定します。
      # 設定可能な値: 最大128文字の正規表現文字列のセット
      # 注意: values と同時に指定できません。
      regex_values = []

      # values (Optional)
      # 設定内容: リクエストURLのパスと比較するパターンのリストを指定します。
      # 設定可能な値: 最大128文字の文字列のセット（大文字小文字を区別、ワイルドカード * と ? をサポート）
      # 注意: クエリ文字列は比較対象外です。regex_values と同時に指定できません。
      values = ["/api/*", "/static/*"]
    }
  }

  condition {

    #-------------------------------------------------------------
    # クエリ文字列条件設定
    #-------------------------------------------------------------

    # query_string (Optional)
    # 設定内容: クエリ文字列のキーバリューペアによる条件設定ブロックです。
    # 注意: condition ブロック内で他の条件タイプとは排他的です。
    #       複数の query_string ブロックを同一 condition ブロック内に指定可能です。
    query_string {

      # key (Optional)
      # 設定内容: マッチさせるクエリ文字列のキーパターンを指定します。
      # 設定可能な値: 最大128文字の文字列（大文字小文字の区別なし、ワイルドカード * と ? をサポート）
      # 省略時: キーを問わず value のみでマッチを行います。
      key = "version"

      # value (Required)
      # 設定内容: マッチさせるクエリ文字列の値パターンを指定します。
      # 設定可能な値: 最大128文字の文字列（大文字小文字の区別なし、ワイルドカード * と ? をサポート）
      value = "v2"
    }
  }

  condition {

    #-------------------------------------------------------------
    # 送信元IP条件設定
    #-------------------------------------------------------------

    # source_ip (Optional)
    # 設定内容: リクエスト送信元IPアドレスのCIDR表記による条件設定ブロックです。
    # 注意: condition ブロック内で他の条件タイプとは排他的です。
    #       X-Forwarded-For ヘッダーのアドレスは対象外です（その場合は http_header 条件を使用）。
    source_ip {

      # values (Required)
      # 設定内容: マッチさせる送信元IPのCIDRブロックのリストを指定します。
      # 設定可能な値: IPv4またはIPv6のCIDR表記文字列のセット（ワイルドカード不可）
      values = ["192.168.0.0/16", "10.0.0.0/8"]
    }
  }

  #-------------------------------------------------------------
  # トランスフォーム設定
  #-------------------------------------------------------------

  # transform (Optional, max_items=2)
  # 設定内容: このルールに一致するリクエストに適用する変換を定義するブロックです。
  # 注意: 最大2つまで指定可能です。一度設定後に削除する場合は transform ブロックをすべて削除する必要があります。
  transform {

    # type (Required)
    # 設定内容: トランスフォームのタイプを指定します。
    # 設定可能な値:
    #   - "host-header-rewrite": ホストヘッダーの書き換え
    #   - "url-rewrite": URLの書き換え
    type = "url-rewrite"

    #-------------------------------------------------------------
    # ホストヘッダー書き換え設定
    #-------------------------------------------------------------

    # host_header_rewrite_config (Optional)
    # 設定内容: ホストヘッダーの書き換え設定ブロックです。
    # 注意: type が "host-header-rewrite" の場合に必須です。
    host_header_rewrite_config {

      # rewrite (Optional, max_items=1)
      # 設定内容: ホストヘッダーの書き換えルールを定義するブロックです。
      rewrite {

        # regex (Required)
        # 設定内容: 入力文字列にマッチさせる正規表現を指定します。
        # 設定可能な値: 1〜1024文字の正規表現文字列
        regex = "^mywebsite-(.+).com$"

        # replace (Required)
        # 設定内容: マッチした入力を書き換える置換文字列を指定します。キャプチャグループは $1, $2 等で参照可能です。
        # 設定可能な値: 0〜1024文字の文字列
        replace = "internal.dev.$1.myweb.com"
      }
    }

    #-------------------------------------------------------------
    # URL書き換え設定
    #-------------------------------------------------------------

    # url_rewrite_config (Optional)
    # 設定内容: URLの書き換え設定ブロックです。
    # 注意: type が "url-rewrite" の場合に必須です。
    url_rewrite_config {

      # rewrite (Optional, max_items=1)
      # 設定内容: URLの書き換えルールを定義するブロックです。
      rewrite {

        # regex (Required)
        # 設定内容: 入力文字列にマッチさせる正規表現を指定します。
        # 設定可能な値: 1〜1024文字の正規表現文字列
        regex = "^/dp/([A-Za-z0-9]+)/?$"

        # replace (Required)
        # 設定内容: マッチした入力を書き換える置換文字列を指定します。キャプチャグループは $1, $2 等で参照可能です。
        # 設定可能な値: 0〜1024文字の文字列
        replace = "/product.php?id=$1"
      }
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-listener-rule"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ルールのARN（arn と同一）
# - arn: ルールのAmazon Resource Name (ARN)
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
