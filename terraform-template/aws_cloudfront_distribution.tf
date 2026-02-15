#-------
# Provider Version: 6.28.0
# リソース: aws_cloudfront_distribution
# Generated: 2025-01-XX
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudfront_distribution
#
# NOTE:
#   このテンプレートはAWS Provider v6.28.0のスキーマから自動生成されています。
#   実際の使用時は、必須パラメータとユースケースに応じたオプション設定を選択してください。
#
#-------
# 概要:
#   Amazon CloudFrontのディストリビューションを作成・管理するリソースです。
#   CloudFrontはAWSのコンテンツ配信ネットワーク(CDN)サービスで、世界中のエッジロケーションを
#   通じて静的・動的コンテンツを低レイテンシで配信します。
#
# 主な用途:
#   - Webサイト・アプリケーションの高速配信
#   - S3バケットやカスタムオリジンからのコンテンツ配信
#   - HTTPSによるセキュアなコンテンツ配信
#   - 動的・静的コンテンツのキャッシュ制御
#   - Lambda@EdgeやCloudFront Functionsによるエッジコンピューティング
#
# 料金への影響:
#   - データ転送量に応じた従量課金
#   - HTTPSリクエスト数による課金
#   - 選択したPrice Classによる料金変動
#   - カスタムSSL証明書使用時の追加料金
#   - Lambda@Edge実行による追加料金
#
#-------

resource "aws_cloudfront_distribution" "example" {
  #-------
  # 基本設定
  #-------

  # 設定内容: ディストリビューションの有効化状態
  # 設定可能な値: true（有効）、false（無効）
  # ※ 必須パラメータ
  enabled = true

  # 設定内容: ディストリビューションの説明コメント
  # 用途: 管理用の説明文やメモ
  comment = "CloudFront distribution for example.com"

  # 設定内容: デフォルトルートオブジェクトのパス
  # 用途: ルートURL（/）へのアクセス時に返すオブジェクト
  # 例: "index.html"
  default_root_object = "index.html"

  #-------
  # ドメイン設定
  #-------

  # 設定内容: ディストリビューションに関連付けるカスタムドメイン名のリスト
  # 用途: CloudFrontのデフォルトドメイン以外のドメイン名を使用
  # 注意: ACM証明書またはIAM証明書の設定が必要
  aliases = ["example.com", "www.example.com"]

  #-------
  # HTTP/IPv6設定
  #-------

  # 設定内容: サポートするHTTPプロトコルのバージョン
  # 設定可能な値: "http1.1", "http2", "http2and3", "http3"
  # 省略時: "http2"
  http_version = "http2and3"

  # 設定内容: IPv6サポートの有効化
  # 設定可能な値: true（有効）、false（無効）
  # 省略時: false
  is_ipv6_enabled = true

  #-------
  # Price Class設定
  #-------

  # 設定内容: 使用するエッジロケーションの範囲
  # 設定可能な値:
  #   - "PriceClass_All": 全てのエッジロケーション（最高コスト）
  #   - "PriceClass_200": 米国、欧州、アジア、中東、アフリカのエッジロケーション
  #   - "PriceClass_100": 米国、欧州のエッジロケーションのみ（最低コスト）
  # 省略時: "PriceClass_All"
  price_class = "PriceClass_100"

  #-------
  # オリジン設定（必須）
  #-------

  origin {
    # 設定内容: オリジンサーバーのドメイン名
    # 用途: S3バケット名、ELBのDNS名、カスタムオリジンのドメイン名など
    # ※ 必須パラメータ
    domain_name = "mybucket.s3.amazonaws.com"

    # 設定内容: オリジンの一意な識別子
    # 用途: キャッシュビヘイビアでオリジンを参照する際に使用
    # ※ 必須パラメータ
    origin_id = "S3-mybucket"

    # 設定内容: オリジンパス
    # 用途: ドメイン名の後に追加するパス（例: "/production"）
    origin_path = "/production"

    # 設定内容: オリジンアクセスコントロールのID
    # 用途: S3オリジンへのアクセス制御（OACを使用）
    origin_access_control_id = "E1A2B3C4D5E6F7"

    # 設定内容: オリジンへの接続試行回数
    # 設定可能な値: 1～3
    # 省略時: 3
    connection_attempts = 3

    # 設定内容: オリジンへの接続タイムアウト（秒）
    # 設定可能な値: 1～10
    # 省略時: 10
    connection_timeout = 10

    # 設定内容: レスポンス完了タイムアウト（秒）
    # 設定可能な値: 4～60
    # 省略時: 30
    response_completion_timeout = 30

    # カスタムヘッダー設定
    custom_header {
      # 設定内容: カスタムヘッダー名
      # ※ 必須パラメータ
      name = "X-Custom-Header"

      # 設定内容: カスタムヘッダー値
      # ※ 必須パラメータ
      value = "CustomValue"
    }

    # S3オリジン設定（S3バケットをオリジンとして使用する場合）
    s3_origin_config {
      # 設定内容: オリジンアクセスアイデンティティ（OAI）のパス
      # 用途: S3バケットへのアクセス制御（レガシー方式）
      # 注意: 新規作成の場合はOACの使用を推奨
      # ※ 必須パラメータ
      origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
    }

    # カスタムオリジン設定（S3以外のオリジンを使用する場合）
    # custom_origin_config {
    #   # 設定内容: HTTPポート番号
    #   # ※ 必須パラメータ
    #   http_port = 80
    #
    #   # 設定内容: HTTPSポート番号
    #   # ※ 必須パラメータ
    #   https_port = 443
    #
    #   # 設定内容: オリジンプロトコルポリシー
    #   # 設定可能な値: "http-only", "https-only", "match-viewer"
    #   # ※ 必須パラメータ
    #   origin_protocol_policy = "https-only"
    #
    #   # 設定内容: オリジンで使用可能なSSL/TLSプロトコル
    #   # 設定可能な値: "TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"
    #   # ※ 必須パラメータ
    #   origin_ssl_protocols = ["TLSv1.2"]
    #
    #   # 設定内容: IPアドレスタイプ
    #   # 設定可能な値: "IPv4", "dualstack"
    #   ip_address_type = "IPv4"
    #
    #   # 設定内容: オリジンキープアライブタイムアウト（秒）
    #   # 設定可能な値: 1～60
    #   # 省略時: 5
    #   origin_keepalive_timeout = 5
    #
    #   # 設定内容: オリジン読み取りタイムアウト（秒）
    #   # 設定可能な値: 1～60
    #   # 省略時: 30
    #   origin_read_timeout = 30
    # }

    # Origin Shield設定
    # origin_shield {
    #   # 設定内容: Origin Shieldの有効化
    #   # ※ 必須パラメータ
    #   enabled = true
    #
    #   # 設定内容: Origin Shieldのリージョン
    #   # 例: "us-east-1"
    #   origin_shield_region = "us-east-1"
    # }

    # VPCオリジン設定
    # vpc_origin_config {
    #   # 設定内容: VPCオリジンのID
    #   # ※ 必須パラメータ
    #   vpc_origin_id = "vpc-origin-123456"
    #
    #   # 設定内容: VPCオリジンの所有者AWSアカウントID
    #   owner_account_id = "123456789012"
    #
    #   # 設定内容: オリジンキープアライブタイムアウト（秒）
    #   # 設定可能な値: 1～60
    #   origin_keepalive_timeout = 5
    #
    #   # 設定内容: オリジン読み取りタイムアウト（秒）
    #   # 設定可能な値: 1～60
    #   origin_read_timeout = 30
    # }
  }

  #-------
  # オリジングループ設定（フェイルオーバー用）
  #-------

  # origin_group {
  #   # 設定内容: オリジングループの一意な識別子
  #   # ※ 必須パラメータ
  #   origin_id = "groupS3"
  #
  #   # フェイルオーバー基準設定
  #   failover_criteria {
  #     # 設定内容: フェイルオーバーをトリガーするHTTPステータスコード
  #     # ※ 必須パラメータ
  #     status_codes = [403, 404, 500, 502, 503, 504]
  #   }
  #
  #   # メンバー設定（プライマリとセカンダリの2つが必須）
  #   member {
  #     # 設定内容: プライマリオリジンのID
  #     # ※ 必須パラメータ
  #     origin_id = "S3-mybucket-primary"
  #   }
  #
  #   member {
  #     # 設定内容: セカンダリオリジンのID
  #     # ※ 必須パラメータ
  #     origin_id = "S3-mybucket-secondary"
  #   }
  # }

  #-------
  # デフォルトキャッシュビヘイビア設定（必須）
  #-------

  default_cache_behavior {
    # 設定内容: このビヘイビアが処理するHTTPメソッド
    # 設定可能な値: "GET", "HEAD", "POST", "PUT", "PATCH", "OPTIONS", "DELETE"
    # ※ 必須パラメータ
    allowed_methods = ["GET", "HEAD", "OPTIONS"]

    # 設定内容: キャッシュ対象のHTTPメソッド
    # 設定可能な値: allowed_methodsのサブセット
    # ※ 必須パラメータ
    cached_methods = ["GET", "HEAD"]

    # 設定内容: ターゲットオリジンのID
    # 用途: リクエストを転送するオリジンの指定
    # ※ 必須パラメータ
    target_origin_id = "S3-mybucket"

    # 設定内容: ビューワープロトコルポリシー
    # 設定可能な値:
    #   - "allow-all": HTTP/HTTPS両方を許可
    #   - "https-only": HTTPSのみ許可
    #   - "redirect-to-https": HTTPをHTTPSにリダイレクト
    # ※ 必須パラメータ
    viewer_protocol_policy = "redirect-to-https"

    # 設定内容: キャッシュポリシーID
    # 用途: AWS管理ポリシーまたはカスタムキャッシュポリシーのID
    # 注意: forwarded_valuesと同時に使用不可
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    # 設定内容: オリジンリクエストポリシーID
    # 用途: オリジンへ転送するヘッダー・クッキー・クエリ文字列の制御
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"

    # 設定内容: レスポンスヘッダーポリシーID
    # 用途: CloudFrontがクライアントに返すHTTPヘッダーの制御
    response_headers_policy_id = "5cc3b908-e619-4b99-88e5-2cf7f45965bd"

    # 設定内容: 圧縮の有効化
    # 用途: テキストベースのコンテンツの自動圧縮（gzip/brotli）
    # 省略時: false
    compress = true

    # 設定内容: 最小TTL（秒）
    # 用途: オブジェクトをキャッシュする最小時間
    # 省略時: 0
    min_ttl = 0

    # 設定内容: デフォルトTTL（秒）
    # 用途: オリジンがCache-Controlヘッダーを返さない場合のキャッシュ時間
    # 省略時: 86400（1日）
    default_ttl = 3600

    # 設定内容: 最大TTL（秒）
    # 用途: オブジェクトをキャッシュする最大時間
    # 省略時: 31536000（1年）
    max_ttl = 86400

    # 設定内容: Field Level EncryptionのID
    # 用途: 特定のフィールドの暗号化設定
    field_level_encryption_id = ""

    # 設定内容: リアルタイムログ設定のARN
    # 用途: リアルタイムでログをKinesis Data Streamsに送信
    realtime_log_config_arn = "arn:aws:cloudfront::123456789012:realtime-log-config/ExampleConfig"

    # 設定内容: Smooth Streamingの有効化
    # 用途: Microsoft Smooth Streamingフォーマットのサポート
    # 省略時: false
    smooth_streaming = false

    # 設定内容: 署名付きURLとクッキーに使用する信頼されたキーグループのリスト
    # 用途: コンテンツへのアクセス制御（推奨方式）
    trusted_key_groups = ["key-group-id-1"]

    # 設定内容: 署名付きURLとクッキーに使用する信頼されたAWSアカウントのリスト
    # 用途: コンテンツへのアクセス制御（レガシー方式）
    # 注意: trusted_key_groupsの使用を推奨
    # trusted_signers = ["self", "123456789012"]

    # 転送値設定（レガシー方式、cache_policy_idと同時に使用不可）
    # forwarded_values {
    #   # 設定内容: クエリ文字列の転送設定
    #   # ※ 必須パラメータ
    #   query_string = true
    #
    #   # 設定内容: キャッシュキーとして使用するクエリ文字列パラメータ
    #   query_string_cache_keys = ["id", "page"]
    #
    #   # 設定内容: オリジンへ転送するHTTPヘッダーのリスト
    #   headers = ["Origin", "Access-Control-Request-Headers"]
    #
    #   # クッキー設定
    #   cookies {
    #     # 設定内容: クッキーの転送方法
    #     # 設定可能な値: "none", "whitelist", "all"
    #     # ※ 必須パラメータ
    #     forward = "whitelist"
    #
    #     # 設定内容: 転送するクッキー名のリスト
    #     # 用途: forwardが"whitelist"の場合に使用
    #     whitelisted_names = ["session-id", "user-pref"]
    #   }
    # }

    # CloudFront Functions関連付け
    function_association {
      # 設定内容: 関数を実行するイベントタイプ
      # 設定可能な値: "viewer-request", "viewer-response"
      # ※ 必須パラメータ
      event_type = "viewer-request"

      # 設定内容: CloudFront FunctionのARN
      # ※ 必須パラメータ
      function_arn = "arn:aws:cloudfront::123456789012:function/ExampleFunction"
    }

    # Lambda@Edge関連付け
    # lambda_function_association {
    #   # 設定内容: Lambda関数を実行するイベントタイプ
    #   # 設定可能な値: "viewer-request", "viewer-response", "origin-request", "origin-response"
    #   # ※ 必須パラメータ
    #   event_type = "viewer-request"
    #
    #   # 設定内容: Lambda関数のARN（バージョン番号を含む）
    #   # ※ 必須パラメータ
    #   lambda_arn = "arn:aws:lambda:us-east-1:123456789012:function:ExampleFunction:1"
    #
    #   # 設定内容: リクエストボディをLambda関数に含めるかどうか
    #   # 省略時: false
    #   include_body = false
    # }

    # gRPC設定
    # grpc_config {
    #   # 設定内容: gRPCサポートの有効化
    #   # 省略時: false
    #   enabled = true
    # }
  }

  #-------
  # 順序付きキャッシュビヘイビア設定
  #-------

  # ordered_cache_behavior {
  #   # 設定内容: パスパターン
  #   # 用途: このビヘイビアを適用するURLパスパターン
  #   # 例: "/images/*", "/api/*"
  #   # ※ 必須パラメータ
  #   path_pattern = "/images/*"
  #
  #   # 設定内容: このビヘイビアが処理するHTTPメソッド
  #   # ※ 必須パラメータ
  #   allowed_methods = ["GET", "HEAD"]
  #
  #   # 設定内容: キャッシュ対象のHTTPメソッド
  #   # ※ 必須パラメータ
  #   cached_methods = ["GET", "HEAD"]
  #
  #   # 設定内容: ターゲットオリジンのID
  #   # ※ 必須パラメータ
  #   target_origin_id = "S3-mybucket"
  #
  #   # 設定内容: ビューワープロトコルポリシー
  #   # ※ 必須パラメータ
  #   viewer_protocol_policy = "redirect-to-https"
  #
  #   # 設定内容: キャッシュポリシーID
  #   cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  #
  #   # 設定内容: 圧縮の有効化
  #   compress = true
  #
  #   # 設定内容: 最小TTL（秒）
  #   min_ttl = 0
  #
  #   # 設定内容: デフォルトTTL（秒）
  #   default_ttl = 86400
  #
  #   # 設定内容: 最大TTL（秒）
  #   max_ttl = 31536000
  # }

  #-------
  # カスタムエラーレスポンス設定
  #-------

  # custom_error_response {
  #   # 設定内容: カスタマイズするHTTPエラーコード
  #   # ※ 必須パラメータ
  #   error_code = 404
  #
  #   # 設定内容: クライアントに返すHTTPステータスコード
  #   response_code = 200
  #
  #   # 設定内容: エラーレスポンスとして返すページのパス
  #   response_page_path = "/error-pages/404.html"
  #
  #   # 設定内容: エラーレスポンスのキャッシュ最小TTL（秒）
  #   # 省略時: 300
  #   error_caching_min_ttl = 300
  # }

  #-------
  # 地理的制限設定（必須）
  #-------

  restrictions {
    geo_restriction {
      # 設定内容: 地理的制限のタイプ
      # 設定可能な値:
      #   - "none": 制限なし
      #   - "whitelist": 指定国からのアクセスのみ許可
      #   - "blacklist": 指定国からのアクセスを拒否
      # ※ 必須パラメータ
      restriction_type = "none"

      # 設定内容: 制限対象の国コードリスト（ISO 3166-1 alpha-2形式）
      # 用途: restriction_typeが"whitelist"または"blacklist"の場合に使用
      # 例: ["US", "JP", "GB"]
      # locations = ["US", "JP"]
    }
  }

  #-------
  # SSL/TLS証明書設定（必須）
  #-------

  viewer_certificate {
    # 設定内容: CloudFrontのデフォルト証明書を使用
    # 用途: *.cloudfront.netドメインを使用する場合
    cloudfront_default_certificate = true

    # 設定内容: ACM証明書のARN
    # 用途: カスタムドメイン用のSSL/TLS証明書（us-east-1リージョン必須）
    # acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abc123"

    # 設定内容: IAM証明書のID
    # 用途: カスタムドメイン用のSSL/TLS証明書（レガシー方式）
    # iam_certificate_id = "ASCAEXAMPLE"

    # 設定内容: サポートする最小TLSプロトコルバージョン
    # 設定可能な値: "TLSv1", "TLSv1_2016", "TLSv1.1_2016", "TLSv1.2_2018", "TLSv1.2_2019", "TLSv1.2_2021"
    # 省略時: "TLSv1"
    # minimum_protocol_version = "TLSv1.2_2021"

    # 設定内容: SSLサポート方法
    # 設定可能な値: "sni-only", "vip"
    # 注意: "vip"は高額な追加料金が発生
    # ssl_support_method = "sni-only"
  }

  #-------
  # mTLS設定
  #-------

  # viewer_mtls_config {
  #   # 設定内容: mTLSモード
  #   # 設定可能な値: "off", "passthrough", "verify"
  #   mode = "verify"
  #
  #   # トラストストア設定
  #   trust_store_config {
  #     # 設定内容: トラストストアのID
  #     # ※ 必須パラメータ
  #     trust_store_id = "ts-123456"
  #
  #     # 設定内容: トラストストアCA名の通知
  #     # 省略時: false
  #     advertise_trust_store_ca_names = true
  #
  #     # 設定内容: 証明書の有効期限を無視
  #     # 省略時: false
  #     ignore_certificate_expiry = false
  #   }
  # }

  #-------
  # ログ設定
  #-------

  # logging_config {
  #   # 設定内容: ログを保存するS3バケット名
  #   # 注意: ".s3.amazonaws.com"を含める必要がある
  #   bucket = "mylogs.s3.amazonaws.com"
  #
  #   # 設定内容: S3バケット内のログファイルのプレフィックス
  #   prefix = "cloudfront/"
  #
  #   # 設定内容: クッキー情報のログ記録
  #   # 省略時: false
  #   include_cookies = false
  # }

  #-------
  # 接続関数設定
  #-------

  # connection_function_association {
  #   # 設定内容: 接続関数のID
  #   # ※ 必須パラメータ
  #   id = "conn-func-123456"
  # }

  #-------
  # 高度な設定
  #-------

  # 設定内容: AWS WAF Web ACLのID
  # 用途: CloudFrontディストリビューションへのWAF適用
  # 注意: us-east-1のWAF ARNまたはグローバルWAF IDを使用
  web_acl_id = "arn:aws:wafv2:us-east-1:123456789012:global/webacl/ExampleWebACL/a1234567-b890-1234-c567-d890e1234567"

  # 設定内容: 継続的デプロイメントポリシーID
  # 用途: ブルー/グリーンデプロイメントの制御
  continuous_deployment_policy_id = null

  # 設定内容: Anycast IPリストID
  # 用途: CloudFront Anycast Static IPの使用
  anycast_ip_list_id = null

  # 設定内容: ステージング環境として作成
  # 用途: 本番環境へのデプロイ前のテスト
  # 省略時: false
  staging = false

  # 設定内容: デプロイの完了を待機
  # 用途: Terraformがディストリビューションのデプロイ完了を待つかどうか
  # 省略時: true
  wait_for_deployment = true

  # 設定内容: 削除時の保持設定
  # 用途: Terraform destroyでディストリビューションを無効化のみ（削除しない）
  # 省略時: false
  retain_on_delete = false

  #-------
  # タグ設定
  #-------

  tags = {
    Name        = "example-cloudfront-distribution"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

#-------
# Attributes Reference（参照可能な属性）
#-------
# このリソースでは以下の属性が参照可能です:
#
# - id: ディストリビューションのID
# - arn: ディストリビューションのARN
# - caller_reference: ディストリビューションの呼び出し参照
# - domain_name: CloudFrontのドメイン名（例: d1234abcd.cloudfront.net）
# - etag: ディストリビューションの現在のバージョンを識別するETag値
# - hosted_zone_id: Route 53エイリアスレコード用のホストゾーンID（常にZ2FDTNDATAQYW2）
# - in_progress_validation_batches: 進行中の検証バッチ数
# - last_modified_time: ディストリビューションの最終更新日時
# - status: ディストリビューションのステータス（InProgress, Deployed等）
# - trusted_key_groups: 信頼されたキーグループの情報（enabled, items）
# - trusted_signers: 信頼された署名者の情報（enabled, items）
# - logging_v1_enabled: V1ログが有効かどうか
#
#-------
