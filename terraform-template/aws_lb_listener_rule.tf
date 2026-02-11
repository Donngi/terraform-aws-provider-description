#---------------------------------------------------------------
# Application Load Balancer Listener Rule
#---------------------------------------------------------------
#
# Application Load Balancer（ALB）のリスナールールを定義します。
# リスナールールは、リクエストの内容に基づいてトラフィックを
# ターゲットグループにルーティングする条件とアクションを定義します。
# 各ルールには優先度、条件、アクション、およびオプションの変換（transform）が含まれます。
#
# AWS公式ドキュメント:
#   - Listener rules for your Application Load Balancer: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/listener-rules.html
#   - Condition types for listener rules: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/rule-condition-types.html
#   - Transforms for listener rules: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/rule-transforms.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_listener_rule" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # (Required, Forces New Resource) ルールを適用するリスナーのARN
  # このリスナーに対してルーティング条件とアクションを定義します
  listener_arn = "arn:aws:elasticloadbalancing:region:account-id:listener/app/load-balancer-name/..."

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # (Optional) ルールの優先度 (1～50000の範囲)
  # 設定しない場合、既存の最高優先度ルールの次の番号が自動割り当てされます
  # 同じリスナーに同じ優先度のルールを複数定義することはできません
  # 優先度が低い数値のルールが先に評価されます
  priority = 100

  # (Optional) リージョンの指定
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトとして使用されます
  # 明示的にリージョンを管理する場合に使用します
  # region = "us-east-1"

  # (Optional) リソースに割り当てるタグのマップ
  # プロバイダーのdefault_tags設定がある場合、同じキーのタグは上書きされます
  tags = {
    Name        = "example-listener-rule"
    Environment = "production"
  }

  #---------------------------------------------------------------
  # アクションブロック (action) - 必須、最低1つ
  #---------------------------------------------------------------
  # リクエストが条件に一致した場合に実行されるアクションを定義します
  # 複数のアクションを定義でき、orderで実行順序を制御できます
  # サポートされるアクションタイプ: forward, redirect, fixed-response,
  # authenticate-cognito, authenticate-oidc, jwt-validation

  action {
    # (Required) アクションのタイプ
    # 有効な値: "forward", "redirect", "fixed-response",
    # "authenticate-cognito", "authenticate-oidc", "jwt-validation"
    type = "forward"

    # (Optional) アクションの実行順序
    # 最小値のorderを持つアクションが最初に実行されます
    # 有効な値: 1～50000
    # デフォルト: アクションリスト内の位置
    # order = 1

    # (Optional) ターゲットグループのARN
    # typeが"forward"の場合で、単一のターゲットグループにルーティングする場合のみ指定
    # 複数のターゲットグループにルーティングする場合は、forwardブロックを使用します
    # forwardブロックと同時に指定することはできません
    target_group_arn = "arn:aws:elasticloadbalancing:region:account-id:targetgroup/..."

    # (Optional) 複数のターゲットグループへのルーティング設定
    # typeが"forward"の場合で、重み付けルーティングやスティッキネスを使用する場合に指定
    # target_group_arnと同時に指定することはできません
    # forward {
    #   # (Required) ターゲットグループの設定（1～5個）
    #   target_group {
    #     # (Required) ターゲットグループのARN
    #     arn = "arn:aws:elasticloadbalancing:region:account-id:targetgroup/main/..."
    #
    #     # (Optional) ターゲットグループの重み (0～999)
    #     # 複数のターゲットグループ間でトラフィックを分散する際の比率
    #     weight = 80
    #   }
    #
    #   target_group {
    #     arn    = "arn:aws:elasticloadbalancing:region:account-id:targetgroup/canary/..."
    #     weight = 20
    #   }
    #
    #   # (Optional) ターゲットグループのスティッキネス設定
    #   stickiness {
    #     # (Optional) ターゲットグループのスティッキネスを有効にするか
    #     enabled = true
    #
    #     # (Required) スティッキネスの持続時間（秒）
    #     # クライアントからのリクエストを同じターゲットグループにルーティングする期間
    #     # 範囲: 1～604800秒（7日間）
    #     duration = 600
    #   }
    # }

    # (Optional) リダイレクトアクションの設定
    # typeが"redirect"の場合に必須
    # HTTPからHTTPSへのリダイレクトなどに使用します
    # redirect {
    #   # (Optional) リダイレクト先のホスト名
    #   # パーセントエンコードされません
    #   # #{host}を使用して元のホストを再利用できます
    #   # デフォルト: #{host}
    #   host = "#{host}"
    #
    #   # (Optional) リダイレクト先のパス
    #   # 先頭の"/"を含む絶対パス
    #   # #{host}, #{path}, #{port}を使用できます
    #   # デフォルト: /#{path}
    #   path = "/#{path}"
    #
    #   # (Optional) リダイレクト先のポート
    #   # 1～65535の値、または#{port}を指定
    #   # デフォルト: #{port}
    #   port = "#{port}"
    #
    #   # (Optional) リダイレクト先のプロトコル
    #   # 有効な値: "HTTP", "HTTPS", "#{protocol}"
    #   # デフォルト: #{protocol}
    #   protocol = "HTTPS"
    #
    #   # (Optional) リダイレクト先のクエリパラメータ
    #   # URLエンコード済み、先頭の"?"は含めません
    #   # デフォルト: #{query}
    #   query = "#{query}"
    #
    #   # (Required) HTTPリダイレクトコード
    #   # 有効な値: "HTTP_301" (永続的), "HTTP_302" (一時的)
    #   status_code = "HTTP_301"
    # }

    # (Optional) 固定レスポンスアクションの設定
    # typeが"fixed-response"の場合に必須
    # ヘルスチェックやメンテナンスページの返却に使用します
    # fixed_response {
    #   # (Required) レスポンスのコンテンツタイプ
    #   # 有効な値: "text/plain", "text/css", "text/html",
    #   # "application/javascript", "application/json"
    #   content_type = "text/plain"
    #
    #   # (Optional) レスポンスのメッセージボディ
    #   message_body = "HEALTHY"
    #
    #   # (Optional) HTTPレスポンスコード
    #   # 有効な値: "2XX", "4XX", "5XX"
    #   status_code = "200"
    # }

    # (Optional) Cognito認証アクションの設定
    # typeが"authenticate-cognito"の場合に必須
    # AWS Cognitoを使用したユーザー認証を実装します
    # authenticate_cognito {
    #   # (Required) CognitoユーザープールのARN
    #   user_pool_arn = "arn:aws:cognito-idp:region:account-id:userpool/..."
    #
    #   # (Required) CognitoユーザープールクライアントID
    #   user_pool_client_id = "client-id"
    #
    #   # (Required) Cognitoユーザープールのドメインプレフィックスまたは完全修飾ドメイン名
    #   user_pool_domain = "example-domain"
    #
    #   # (Optional) 認証エンドポイントへのリダイレクトリクエストに含めるクエリパラメータ
    #   # 最大10個まで指定可能
    #   # authentication_request_extra_params = {
    #   #   param1 = "value1"
    #   # }
    #
    #   # (Optional) ユーザーが認証されていない場合の動作
    #   # 有効な値: "deny", "allow", "authenticate"
    #   # on_unauthenticated_request = "authenticate"
    #
    #   # (Optional) IdPからリクエストするユーザークレームのセット
    #   # scope = "openid"
    #
    #   # (Optional) セッション情報を維持するために使用するCookieの名前
    #   # session_cookie_name = "AWSELBAuthSessionCookie"
    #
    #   # (Optional) 認証セッションの最大持続時間（秒）
    #   # session_timeout = 3600
    # }

    # (Optional) OIDC認証アクションの設定
    # typeが"authenticate-oidc"の場合に必須
    # OpenID Connect準拠のIdPを使用した認証を実装します
    # authenticate_oidc {
    #   # (Required) IdPの認可エンドポイント
    #   authorization_endpoint = "https://example.com/authorization_endpoint"
    #
    #   # (Required) OAuth 2.0クライアント識別子
    #   client_id = "client_id"
    #
    #   # (Required) OAuth 2.0クライアントシークレット
    #   # sensitiveとしてマークされており、Terraform stateで暗号化されます
    #   client_secret = "client_secret"
    #
    #   # (Required) IdPのOIDC issuer識別子
    #   issuer = "https://example.com"
    #
    #   # (Required) IdPのトークンエンドポイント
    #   token_endpoint = "https://example.com/token_endpoint"
    #
    #   # (Required) IdPのユーザー情報エンドポイント
    #   user_info_endpoint = "https://example.com/user_info_endpoint"
    #
    #   # (Optional) 認証エンドポイントへのリダイレクトリクエストに含めるクエリパラメータ
    #   # 最大10個まで指定可能
    #   # authentication_request_extra_params = {
    #   #   param1 = "value1"
    #   # }
    #
    #   # (Optional) ユーザーが認証されていない場合の動作
    #   # 有効な値: "deny", "allow", "authenticate"
    #   # on_unauthenticated_request = "authenticate"
    #
    #   # (Optional) IdPからリクエストするユーザークレームのセット
    #   # scope = "openid"
    #
    #   # (Optional) セッション情報を維持するために使用するCookieの名前
    #   # session_cookie_name = "AWSELBAuthSessionCookie"
    #
    #   # (Optional) 認証セッションの最大持続時間（秒）
    #   # session_timeout = 3600
    # }

    # (Optional) JWT検証アクションの設定
    # typeが"jwt-validation"の場合に必須
    # JSON Web Token (JWT)の検証を実装します
    # jwt_validation {
    #   # (Required) JWTの発行者
    #   issuer = "https://example.com"
    #
    #   # (Required) JSON Web Key Set (JWKS) エンドポイント
    #   # JWTの署名検証に使用されるJWKを含むエンドポイント
    #   # HTTPSプロトコル、ドメイン、パスを含む完全なURLを指定
    #   jwks_endpoint = "https://example.com/.well-known/jwks.json"
    #
    #   # (Optional) 検証する追加のクレーム設定（最大10個）
    #   # additional_claim {
    #   #   # (Required) クレーム値のフォーマット
    #   #   # 有効な値: "single-string", "string-array", "space-separated-values"
    #   #   format = "string-array"
    #   #
    #   #   # (Required) 検証するクレームの名前
    #   #   # exp, iss, nbf, iatは指定不可（デフォルトで検証されるため）
    #   #   name = "claim_name1"
    #   #
    #   #   # (Required) クレームの期待値のリスト
    #   #   values = ["value1", "value2"]
    #   # }
    # }
  }

  #---------------------------------------------------------------
  # 条件ブロック (condition) - 必須、最低1つ
  #---------------------------------------------------------------
  # リクエストがルールに一致するための条件を定義します
  # 複数の異なるタイプの条件ブロックを設定でき、すべてが満たされる必要があります
  # 各conditionブロックには、以下のいずれか1つのタイプのみを指定できます

  condition {
    # (Optional) ホストヘッダーパターンに基づく条件
    # host_header {
    #   # (Optional) ホストヘッダーと比較する値のリスト
    #   # 最大128文字、大文字小文字を区別しない
    #   # ワイルドカード文字: * (0文字以上にマッチ), ? (1文字にマッチ)
    #   # 少なくとも1つのパターンがマッチすれば条件を満たします
    #   # regex_valuesと同時には指定できません
    #   values = ["example.com", "*.example.com"]
    #
    #   # (Optional) ホストヘッダーと比較する正規表現のリスト
    #   # 各文字列の最大長は128文字
    #   # valuesと同時には指定できません
    #   # regex_values = ["^mywebsite-(.+).com$"]
    # }

    # (Optional) HTTPヘッダーに基づく条件
    # http_header {
    #   # (Required) 検索するHTTPヘッダーの名前
    #   # 最大40文字、大文字小文字を区別しない
    #   # RFC7240文字のみサポート、ワイルドカード不可
    #   # ホストヘッダーを指定する場合は、host-header条件を使用してください
    #   http_header_name = "X-Forwarded-For"
    #
    #   # (Optional) ヘッダー値と比較するパターンのリスト
    #   # 最大128文字、大文字小文字を区別しない
    #   # ワイルドカード文字: * (0文字以上にマッチ), ? (1文字にマッチ)
    #   # regex_valuesと同時には指定できません
    #   values = ["192.168.1.*"]
    #
    #   # (Optional) HTTPヘッダーと比較する正規表現のリスト
    #   # 各文字列の最大長は128文字
    #   # valuesと同時には指定できません
    #   # regex_values = ["^192\\.168\\..*"]
    # }

    # (Optional) HTTPリクエストメソッドに基づく条件
    # http_request_method {
    #   # (Required) HTTPリクエストメソッドまたはverbのリスト
    #   # 最大40文字、A-Z, ハイフン(-), アンダースコア(_)のみ許可
    #   # 大文字小文字を区別、ワイルドカード不可
    #   # 少なくとも1つがマッチすれば条件を満たします
    #   # AWSは、GETとHEADリクエストを同じ方法でルーティングすることを推奨
    #   values = ["GET", "HEAD"]
    # }

    # (Optional) パスパターンに基づく条件
    path_pattern {
      # (Optional) リクエストURLと比較するパスパターンのリスト
      # 最大128文字、大文字小文字を区別
      # ワイルドカード文字: * (0文字以上にマッチ), ? (1文字にマッチ)
      # パスパターンはURLのパス部分のみと比較され、クエリ文字列とは比較されません
      # クエリ文字列と比較する場合は、query_string条件を使用してください
      # regex_valuesと同時には指定できません
      values = ["/static/*"]

      # (Optional) リクエストURLと比較する正規表現のリスト
      # 各文字列の最大長は128文字
      # valuesと同時には指定できません
      # regex_values = ["^/api/v[0-9]+/.*"]
    }

    # (Optional) クエリ文字列に基づく条件
    # query_string {
    #   # (Optional) クエリ文字列のキーパターン
    #   key = "health"
    #
    #   # (Required) クエリ文字列の値パターン
    #   # 最大128文字、大文字小文字を区別しない
    #   # ワイルドカード文字: * (0文字以上にマッチ), ? (1文字にマッチ)
    #   # リテラルの'*'または'?'を検索する場合は、バックスラッシュ(\)でエスケープ
    #   # 少なくとも1つのペアがマッチすれば条件を満たします
    #   value = "check"
    # }
    #
    # # 複数のquery_stringブロックを指定可能
    # query_string {
    #   value = "bar"
    # }

    # (Optional) 送信元IPアドレスに基づく条件
    # source_ip {
    #   # (Required) 送信元IPアドレスのCIDR表記のリスト
    #   # IPv4とIPv6の両方のアドレスを使用可能
    #   # ワイルドカード不可
    #   # リクエストの送信元IPアドレスがいずれかのCIDRブロックに一致すれば条件を満たします
    #   # X-Forwarded-Forヘッダーのアドレスでは条件を満たさないので、
    #   # その場合はhttp_header条件を使用してください
    #   values = ["192.168.0.0/16", "2001:db8::/32"]
    # }
  }

  # 複数の条件を指定可能（すべて満たす必要があります）
  condition {
    host_header {
      values = ["example.com"]
    }
  }

  #---------------------------------------------------------------
  # 変換ブロック (transform) - オプション、最大2個
  #---------------------------------------------------------------
  # リクエストがターゲットにルーティングされる前に適用される変換を定義します
  # パス、クエリ文字列、ホストヘッダーの変更をロードバランサーにオフロードできます
  # 各ルールには、ホストヘッダーリライト変換とURLリライト変換を1つずつ設定可能

  # transform {
  #   # (Required) 変換のタイプ
  #   # 有効な値: "host-header-rewrite", "url-rewrite"
  #   type = "host-header-rewrite"
  #
  #   # (Optional) ホストヘッダーリライト設定
  #   # typeが"host-header-rewrite"の場合に必須
  #   host_header_rewrite_config {
  #     rewrite {
  #       # (Required) 入力文字列でマッチする正規表現
  #       # 長さの制約: 1～1024文字
  #       regex = "^mywebsite-(.+).com$"
  #
  #       # (Required) マッチした入力をリライトする際に使用する置換文字列
  #       # 正規表現のキャプチャグループ（例: $1, $2）を指定可能
  #       # 長さの制約: 0～1024文字
  #       replace = "internal.dev.$1.myweb.com"
  #     }
  #   }
  # }

  # transform {
  #   # URLリライト変換
  #   type = "url-rewrite"
  #
  #   # (Optional) URLリライト設定
  #   # typeが"url-rewrite"の場合に必須
  #   url_rewrite_config {
  #     rewrite {
  #       # (Required) 入力文字列でマッチする正規表現
  #       # 長さの制約: 1～1024文字
  #       regex = "^/dp/([A-Za-z0-9]+)/?$"
  #
  #       # (Required) マッチした入力をリライトする際に使用する置換文字列
  #       # 正規表現のキャプチャグループ（例: $1, $2）を指定可能
  #       # 長さの制約: 0～1024文字
  #       replace = "/product.php?id=$1"
  #     }
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Computed-only attributes)
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定されるため、
# リソース定義では指定できません。
# これらの値は他のリソースで参照する際に使用できます。
#
# - id: ルールのARN（arnと同じ）
# - arn: ルールのARN（idと同じ）
# - tags_all: リソースに割り当てられた全てのタグのマップ
#             プロバイダーのdefault_tags設定から継承されたタグを含みます
#
# 使用例:
#   output "listener_rule_arn" {
#     value = aws_lb_listener_rule.example.arn
#   }
#---------------------------------------------------------------
