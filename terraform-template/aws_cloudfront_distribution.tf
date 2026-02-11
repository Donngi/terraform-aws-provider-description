#---------------------------------------------------------------
# AWS CloudFront Distribution
#---------------------------------------------------------------
#
# Amazon CloudFront Webディストリビューションをプロビジョニングするリソースです。
# CloudFrontはAWSのグローバルなコンテンツ配信ネットワーク（CDN）サービスで、
# エッジロケーションを通じてコンテンツを低レイテンシーで配信します。
#
# AWS公式ドキュメント:
#   - CloudFront Developer Guide: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html
#   - ディストリビューション設定: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-working-with.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudfront_distribution" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # enabled (Required)
  # 設定内容: ディストリビューションがコンテンツのリクエストを受け付けるかを指定します。
  # 設定可能な値:
  #   - true: ディストリビューションが有効で、エンドユーザーリクエストを処理
  #   - false: ディストリビューションが無効で、リクエストを処理しない
  enabled = true

  # comment (Optional)
  # 設定内容: ディストリビューションの説明コメントを指定します。
  # 設定可能な値: 任意の文字列（最大128文字）
  # 用途: ディストリビューションの目的や管理情報を記録
  comment = "Example CloudFront distribution"

  # default_root_object (Optional)
  # 設定内容: ルートURLリクエスト時に返すデフォルトオブジェクトを指定します。
  # 設定可能な値: オブジェクト名（例: index.html）、最大255文字
  # 用途: https://example.com/ へのリクエスト時に返すファイルを指定
  # 注意: 先頭にスラッシュ（/）を含めないこと
  default_root_object = "index.html"

  # is_ipv6_enabled (Optional)
  # 設定内容: IPv6をサポートするかを指定します。
  # 設定可能な値:
  #   - true: IPv4とIPv6の両方でリクエストを受け付け
  #   - false: IPv4のみでリクエストを受け付け
  # 省略時: false
  is_ipv6_enabled = true

  # http_version (Optional)
  # 設定内容: サポートするHTTPバージョンの最大値を指定します。
  # 設定可能な値:
  #   - "http1.1": HTTP/1.1のみをサポート
  #   - "http2": HTTP/1.1とHTTP/2をサポート（デフォルト）
  #   - "http2and3": HTTP/1.1、HTTP/2、HTTP/3をサポート
  #   - "http3": HTTP/1.1、HTTP/2、HTTP/3をサポート
  # 注意: HTTP/2およびHTTP/3の使用にはTLSv1.2以上とSNIサポートが必要
  # 関連機能: CloudFront HTTP/3サポート
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html
  http_version = "http2"

  # price_class (Optional)
  # 設定内容: CloudFrontサービスの最大料金に対応する価格クラスを指定します。
  # 設定可能な値:
  #   - "PriceClass_All": すべてのエッジロケーションを使用（最高パフォーマンス、最高コスト）
  #   - "PriceClass_200": 北米、ヨーロッパ、アジア、中東、アフリカのエッジロケーションを使用
  #   - "PriceClass_100": 北米、ヨーロッパのエッジロケーションのみ使用（最低コスト）
  # 省略時: PriceClass_All
  # 関連機能: CloudFront価格クラス
  #   価格クラスによりコストとパフォーマンスのバランスを調整可能
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/PriceClass.html
  price_class = "PriceClass_All"

  # aliases (Optional)
  # 設定内容: ディストリビューションの代替ドメイン名（CNAME）を指定します。
  # 設定可能な値: ドメイン名のセット（例: ["www.example.com", "cdn.example.com"]）
  # 注意: CNAMEを使用する場合、対応するSSL/TLS証明書が必要
  # 関連機能: カスタムドメイン
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/CNAMEs.html
  aliases = ["cdn.example.com"]

  # web_acl_id (Optional)
  # 設定内容: ディストリビューションに関連付けるAWS WAF Web ACLのARNを指定します。
  # 設定可能な値: WAFv2 Web ACLのARN
  # 用途: Webアプリケーションファイアウォールによるセキュリティ保護
  # 注意: WAF Classicの場合はWeb ACL ID、WAFv2の場合はARNを指定
  # 関連機能: AWS WAF
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/what-is-aws-waf.html
  web_acl_id = null

  # staging (Optional)
  # 設定内容: ステージングディストリビューションかどうかを指定します。
  # 設定可能な値:
  #   - true: ステージングディストリビューション（継続的デプロイに使用）
  #   - false: 本番ディストリビューション
  # 関連機能: CloudFront継続的デプロイ
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/continuous-deployment.html
  staging = false

  # continuous_deployment_policy_id (Optional)
  # 設定内容: 継続的デプロイポリシーのIDを指定します。
  # 設定可能な値: 継続的デプロイポリシーID
  # 用途: トラフィックの一部をステージングディストリビューションにルーティング
  continuous_deployment_policy_id = null

  # anycast_ip_list_id (Optional)
  # 設定内容: Anycast静的IPリストのIDを指定します。
  # 設定可能な値: Anycast IPリストID
  # 用途: 専用の静的IPアドレスを使用したい場合に指定
  # 関連機能: CloudFront Anycast静的IP
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/working-with-anycast-static-ips.html
  anycast_ip_list_id = null

  # retain_on_delete (Optional)
  # 設定内容: Terraform destroy時にディストリビューションを無効化のみにするかを指定します。
  # 設定可能な値:
  #   - true: destroyでディストリビューションを削除せず、無効化のみ
  #   - false: destroyでディストリビューションを削除（デフォルト）
  # 注意: ディストリビューションのデプロイには約15分かかるため、削除をブロックしたい場合に有用
  retain_on_delete = false

  # wait_for_deployment (Optional)
  # 設定内容: ディストリビューションのデプロイ完了を待機するかを指定します。
  # 設定可能な値:
  #   - true: デプロイ完了を待機（デフォルト）
  #   - false: デプロイ完了を待機しない
  # 注意: falseにすると作成/更新は速くなるが、後続リソースで問題が発生する可能性あり
  wait_for_deployment = true

  #-------------------------------------------------------------
  # オリジン設定 (Required, 1個以上)
  #-------------------------------------------------------------

  # origin (Required)
  # 設定内容: コンテンツの配信元（オリジン）を定義します。
  # 最大25個のオリジンを定義可能
  origin {
    # domain_name (Required)
    # 設定内容: オリジンのドメイン名を指定します。
    # 設定可能な値:
    #   - S3バケット: bucket-name.s3.region.amazonaws.com
    #   - ALB/ELB: my-alb-123456789.region.elb.amazonaws.com
    #   - カスタムオリジン: www.example.com
    domain_name = "my-bucket.s3.ap-northeast-1.amazonaws.com"

    # origin_id (Required)
    # 設定内容: オリジンの一意識別子を指定します。
    # 設定可能な値: 任意の文字列
    # 用途: キャッシュビヘイビアでtarget_origin_idとして参照
    origin_id = "myS3Origin"

    # origin_path (Optional)
    # 設定内容: CloudFrontがオリジンにリクエストする際に追加するパスを指定します。
    # 設定可能な値: スラッシュで始まる文字列（例: /production）
    # 注意: 末尾にスラッシュを含めないこと
    origin_path = ""

    # origin_access_control_id (Optional)
    # 設定内容: オリジンアクセスコントロール（OAC）のIDを指定します。
    # 設定可能な値: aws_cloudfront_origin_access_controlリソースのID
    # 用途: S3バケットへのアクセスをCloudFrontからのみに制限
    # 関連機能: Origin Access Control
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
    origin_access_control_id = null

    # connection_attempts (Optional)
    # 設定内容: オリジンへの接続試行回数を指定します。
    # 設定可能な値: 1〜3の整数
    # 省略時: 3
    connection_attempts = 3

    # connection_timeout (Optional)
    # 設定内容: オリジンへの接続タイムアウト（秒）を指定します。
    # 設定可能な値: 1〜10の整数
    # 省略時: 10
    connection_timeout = 10

    # response_completion_timeout (Optional)
    # 設定内容: オリジンからのレスポンス完了待機時間（秒）を指定します。
    # 設定可能な値: origin_read_timeout以上の整数
    # 省略時: 値を指定しないか0の場合、最大値の制限なし
    response_completion_timeout = null

    # custom_header (Optional, 複数可)
    # 設定内容: オリジンへのリクエストに含めるカスタムヘッダーを指定します。
    # 用途: オリジンでCloudFrontからのリクエストを識別
    custom_header {
      # name (Required)
      # 設定内容: ヘッダー名
      name = "X-Custom-Header"

      # value (Required)
      # 設定内容: ヘッダー値
      value = "custom-value"
    }

    # origin_shield (Optional)
    # 設定内容: Origin Shieldの設定を指定します。
    # 関連機能: Origin Shield
    #   オリジンへのリクエストを減らし、オリジン負荷を軽減
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/origin-shield.html
    origin_shield {
      # enabled (Required)
      # 設定内容: Origin Shieldを有効にするか
      enabled = false

      # origin_shield_region (Optional)
      # 設定内容: Origin Shieldを配置するリージョン
      # 注意: enabledがtrueの場合に必須
      origin_shield_region = null
    }

    # S3オリジン設定 (カスタムオリジンの場合は不要)
    # s3_origin_config (Optional)
    # 設定内容: S3オリジン固有の設定を指定します。
    # 注意: OACを使用する場合はorigin_access_control_idを使用し、
    #       この設定は使用しないことを推奨（OAIは非推奨）
    # s3_origin_config {
    #   # origin_access_identity (Required)
    #   # 設定内容: オリジンアクセスアイデンティティ（OAI）のパスを指定
    #   # 注意: OAIは非推奨。OACの使用を推奨
    #   origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
    # }

    # カスタムオリジン設定 (S3オリジンの場合は不要)
    # custom_origin_config (Optional)
    # 設定内容: カスタムオリジン（HTTP/HTTPSサーバー）の設定を指定します。
    # custom_origin_config {
    #   # http_port (Required)
    #   # 設定内容: HTTPリクエストに使用するポート
    #   http_port = 80
    #
    #   # https_port (Required)
    #   # 設定内容: HTTPSリクエストに使用するポート
    #   https_port = 443
    #
    #   # origin_protocol_policy (Required)
    #   # 設定内容: オリジンへの接続プロトコルポリシー
    #   # 設定可能な値:
    #   #   - "http-only": HTTPのみ使用
    #   #   - "https-only": HTTPSのみ使用
    #   #   - "match-viewer": ビューアと同じプロトコルを使用
    #   origin_protocol_policy = "https-only"
    #
    #   # origin_ssl_protocols (Required)
    #   # 設定内容: オリジンとのHTTPS通信で使用するSSL/TLSプロトコル
    #   # 設定可能な値: "SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"のセット
    #   origin_ssl_protocols = ["TLSv1.2"]
    #
    #   # origin_keepalive_timeout (Optional)
    #   # 設定内容: キープアライブタイムアウト（秒）
    #   # 設定可能な値: 1〜60（デフォルト: 5）
    #   origin_keepalive_timeout = 5
    #
    #   # origin_read_timeout (Optional)
    #   # 設定内容: 読み取りタイムアウト（秒）
    #   # 設定可能な値: 1〜60（デフォルト: 30）
    #   origin_read_timeout = 30
    #
    #   # ip_address_type (Optional)
    #   # 設定内容: オリジンへの接続に使用するIPアドレスタイプ
    #   # 設定可能な値:
    #   #   - "ipv4": IPv4のみ
    #   #   - "dualstack": IPv4とIPv6
    #   ip_address_type = "ipv4"
    # }

    # VPCオリジン設定 (プライベートVPC内のオリジン用)
    # vpc_origin_config (Optional)
    # 設定内容: VPC内のプライベートオリジンの設定を指定します。
    # vpc_origin_config {
    #   # vpc_origin_id (Required)
    #   # 設定内容: VPCオリジンのID
    #   vpc_origin_id = "vpc-origin-id"
    #
    #   # origin_keepalive_timeout (Optional)
    #   # 設定内容: キープアライブタイムアウト（秒）
    #   # 設定可能な値: 1〜60（デフォルト: 5）
    #   origin_keepalive_timeout = 5
    #
    #   # origin_read_timeout (Optional)
    #   # 設定内容: 読み取りタイムアウト（秒）
    #   # 設定可能な値: 1〜60（デフォルト: 30）
    #   origin_read_timeout = 30
    #
    #   # owner_account_id (Optional)
    #   # 設定内容: VPCオリジンを所有するAWSアカウントID
    #   # 用途: クロスアカウントVPCオリジンアクセス時に使用
    #   owner_account_id = null
    # }
  }

  #-------------------------------------------------------------
  # オリジングループ設定 (Optional)
  #-------------------------------------------------------------

  # origin_group (Optional)
  # 設定内容: フェイルオーバー用のオリジングループを定義します。
  # 用途: プライマリオリジン障害時に自動的にセカンダリオリジンにフェイルオーバー
  # origin_group {
  #   # origin_id (Required)
  #   # 設定内容: オリジングループの一意識別子
  #   origin_id = "groupS3"
  #
  #   # failover_criteria (Required)
  #   # 設定内容: フェイルオーバー条件
  #   failover_criteria {
  #     # status_codes (Required)
  #     # 設定内容: フェイルオーバーをトリガーするHTTPステータスコード
  #     # 設定可能な値: 400〜599の範囲のステータスコード
  #     status_codes = [403, 404, 500, 502, 503, 504]
  #   }
  #
  #   # member (Required, 2個必要)
  #   # 設定内容: オリジングループのメンバー（プライマリとセカンダリ）
  #   member {
  #     origin_id = "primaryS3"
  #   }
  #
  #   member {
  #     origin_id = "failoverS3"
  #   }
  # }

  #-------------------------------------------------------------
  # デフォルトキャッシュビヘイビア設定 (Required)
  #-------------------------------------------------------------

  # default_cache_behavior (Required)
  # 設定内容: パスパターンに一致しないリクエストのキャッシュ動作を定義します。
  default_cache_behavior {
    # target_origin_id (Required)
    # 設定内容: リクエストをルーティングするオリジンのID
    # 設定可能な値: originブロックで定義したorigin_id
    target_origin_id = "myS3Origin"

    # viewer_protocol_policy (Required)
    # 設定内容: ビューアがコンテンツにアクセスする際のプロトコルポリシー
    # 設定可能な値:
    #   - "allow-all": HTTPとHTTPSの両方を許可
    #   - "https-only": HTTPSのみ許可、HTTPはエラー
    #   - "redirect-to-https": HTTPリクエストをHTTPSにリダイレクト
    viewer_protocol_policy = "redirect-to-https"

    # allowed_methods (Required)
    # 設定内容: オリジンに転送するHTTPメソッド
    # 設定可能な値:
    #   - ["GET", "HEAD"]: GETとHEADのみ（静的コンテンツ向け）
    #   - ["GET", "HEAD", "OPTIONS"]: 上記 + OPTIONS
    #   - ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]: すべてのメソッド
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]

    # cached_methods (Required)
    # 設定内容: CloudFrontがキャッシュするHTTPメソッド
    # 設定可能な値:
    #   - ["GET", "HEAD"]: GETとHEADのみ
    #   - ["GET", "HEAD", "OPTIONS"]: GETとHEADとOPTIONS
    cached_methods = ["GET", "HEAD"]

    # cache_policy_id (Optional)
    # 設定内容: キャッシュポリシーのID
    # 設定可能な値: aws_cloudfront_cache_policyリソースのIDまたはマネージドポリシーID
    # 用途: キャッシュキーとTTL設定を制御
    # 注意: cache_policy_idとforwarded_valuesは排他的
    # マネージドポリシー例:
    #   - CachingOptimized: 658327ea-f89d-4fab-a63d-7e88639e58f6
    #   - CachingDisabled: 4135ea2d-6df8-44a3-9df3-4b5a84be39ad
    cache_policy_id = null

    # origin_request_policy_id (Optional)
    # 設定内容: オリジンリクエストポリシーのID
    # 設定可能な値: aws_cloudfront_origin_request_policyリソースのIDまたはマネージドポリシーID
    # 用途: オリジンに転送するヘッダー、Cookie、クエリ文字列を制御
    origin_request_policy_id = null

    # response_headers_policy_id (Optional)
    # 設定内容: レスポンスヘッダーポリシーのID
    # 設定可能な値: aws_cloudfront_response_headers_policyリソースのID
    # 用途: ビューアへのレスポンスにヘッダーを追加
    response_headers_policy_id = null

    # compress (Optional)
    # 設定内容: コンテンツの自動圧縮を有効にするか
    # 設定可能な値:
    #   - true: gzip/Brotli圧縮を有効化
    #   - false: 圧縮を無効化
    # 注意: ビューアがAccept-Encodingヘッダーを送信した場合のみ圧縮
    compress = true

    # min_ttl (Optional)
    # 設定内容: キャッシュの最小TTL（秒）
    # 設定可能な値: 0以上の整数
    # 省略時: 0
    # 注意: cache_policy_idを使用する場合は無視される
    min_ttl = 0

    # default_ttl (Optional)
    # 設定内容: キャッシュのデフォルトTTL（秒）
    # 設定可能な値: 0以上の整数
    # 省略時: 86400 (24時間)
    # 注意: cache_policy_idを使用する場合は無視される
    default_ttl = 3600

    # max_ttl (Optional)
    # 設定内容: キャッシュの最大TTL（秒）
    # 設定可能な値: 0以上の整数
    # 省略時: 31536000 (365日)
    # 注意: cache_policy_idを使用する場合は無視される
    max_ttl = 86400

    # smooth_streaming (Optional)
    # 設定内容: Microsoft Smooth Streamingを有効にするか
    # 設定可能な値:
    #   - true: Smooth Streamingを有効化
    #   - false: 無効化（デフォルト）
    smooth_streaming = false

    # realtime_log_config_arn (Optional)
    # 設定内容: リアルタイムログ設定のARN
    # 設定可能な値: aws_cloudfront_realtime_log_configリソースのARN
    # 用途: Kinesis Data Streamsへのリアルタイムログ配信
    realtime_log_config_arn = null

    # field_level_encryption_id (Optional)
    # 設定内容: フィールドレベル暗号化設定のID
    # 設定可能な値: aws_cloudfront_field_level_encryption_configリソースのID
    # 用途: 特定のフォームフィールドをエッジで暗号化
    field_level_encryption_id = null

    # trusted_key_groups (Optional)
    # 設定内容: 署名付きURLまたはCookieの検証に使用するキーグループ
    # 設定可能な値: aws_cloudfront_key_groupリソースのIDのリスト
    # 用途: プライベートコンテンツへのアクセス制御
    trusted_key_groups = null

    # trusted_signers (Optional)
    # 設定内容: 署名付きURLまたはCookieの検証に使用するAWSアカウント
    # 設定可能な値: AWSアカウントIDのリスト、または"self"
    # 注意: trusted_key_groupsの使用を推奨（こちらは非推奨）
    trusted_signers = null

    # forwarded_values (Optional, Deprecated)
    # 設定内容: オリジンに転送する値を指定（非推奨）
    # 注意: cache_policy_idとorigin_request_policy_idの使用を推奨
    # forwarded_values {
    #   # query_string (Required)
    #   # 設定内容: クエリ文字列をオリジンに転送するか
    #   query_string = false
    #
    #   # query_string_cache_keys (Optional)
    #   # 設定内容: キャッシュキーに含めるクエリ文字列パラメータ
    #   query_string_cache_keys = []
    #
    #   # headers (Optional)
    #   # 設定内容: オリジンに転送するヘッダー
    #   headers = []
    #
    #   # cookies (Required)
    #   cookies {
    #     # forward (Required)
    #     # 設定内容: Cookieの転送方法
    #     # 設定可能な値: "none", "whitelist", "all"
    #     forward = "none"
    #
    #     # whitelisted_names (Optional)
    #     # 設定内容: 転送するCookie名（forwardが"whitelist"の場合）
    #     whitelisted_names = []
    #   }
    # }

    # function_association (Optional, 最大2個)
    # 設定内容: CloudFront Functionsの関連付け
    # 用途: 軽量なエッジ処理（URLリライト、ヘッダー操作等）
    # function_association {
    #   # event_type (Required)
    #   # 設定内容: 関数を実行するイベントタイプ
    #   # 設定可能な値: "viewer-request", "viewer-response"
    #   event_type = "viewer-request"
    #
    #   # function_arn (Required)
    #   # 設定内容: CloudFront FunctionのARN
    #   function_arn = "arn:aws:cloudfront::123456789012:function/my-function"
    # }

    # lambda_function_association (Optional, 最大4個)
    # 設定内容: Lambda@Edgeの関連付け
    # 用途: より複雑なエッジ処理
    # lambda_function_association {
    #   # event_type (Required)
    #   # 設定内容: Lambda関数を実行するイベントタイプ
    #   # 設定可能な値:
    #   #   - "viewer-request": ビューアリクエスト時
    #   #   - "origin-request": オリジンリクエスト時
    #   #   - "origin-response": オリジンレスポンス時
    #   #   - "viewer-response": ビューアレスポンス時
    #   event_type = "viewer-request"
    #
    #   # lambda_arn (Required)
    #   # 設定内容: Lambda関数のARN（バージョン番号付き）
    #   lambda_arn = "arn:aws:lambda:us-east-1:123456789012:function:my-function:1"
    #
    #   # include_body (Optional)
    #   # 設定内容: リクエストボディをLambdaに含めるか
    #   # 設定可能な値:
    #   #   - true: ボディを含める（viewer-request/origin-requestのみ）
    #   #   - false: ボディを含めない（デフォルト）
    #   include_body = false
    # }

    # grpc_config (Optional)
    # 設定内容: gRPCの設定
    # grpc_config {
    #   # enabled (Optional)
    #   # 設定内容: gRPCを有効にするか
    #   enabled = false
    # }
  }

  #-------------------------------------------------------------
  # 追加キャッシュビヘイビア設定 (Optional)
  #-------------------------------------------------------------

  # ordered_cache_behavior (Optional, 複数可)
  # 設定内容: 特定のパスパターンに対するキャッシュ動作を定義します。
  # 注意: リスト内での順序が優先度となる（先頭が最高優先度）
  ordered_cache_behavior {
    # path_pattern (Required)
    # 設定内容: このキャッシュビヘイビアを適用するパスパターン
    # 設定可能な値: ワイルドカード使用可能なパス（例: /images/*, *.jpg）
    path_pattern = "/images/*"

    # target_origin_id (Required)
    target_origin_id = "myS3Origin"

    # viewer_protocol_policy (Required)
    viewer_protocol_policy = "redirect-to-https"

    # allowed_methods (Required)
    allowed_methods = ["GET", "HEAD", "OPTIONS"]

    # cached_methods (Required)
    cached_methods = ["GET", "HEAD", "OPTIONS"]

    # cache_policy_id (Optional)
    cache_policy_id = null

    # origin_request_policy_id (Optional)
    origin_request_policy_id = null

    # response_headers_policy_id (Optional)
    response_headers_policy_id = null

    # compress (Optional)
    compress = true

    # min_ttl (Optional)
    min_ttl = 0

    # default_ttl (Optional)
    default_ttl = 86400

    # max_ttl (Optional)
    max_ttl = 31536000

    # smooth_streaming (Optional)
    smooth_streaming = false

    # realtime_log_config_arn (Optional)
    realtime_log_config_arn = null

    # field_level_encryption_id (Optional)
    field_level_encryption_id = null

    # trusted_key_groups (Optional)
    trusted_key_groups = null

    # trusted_signers (Optional)
    trusted_signers = null

    # forwarded_values, function_association, lambda_function_association, grpc_config
    # は default_cache_behavior と同様の設定が可能
  }

  #-------------------------------------------------------------
  # カスタムエラーレスポンス設定 (Optional)
  #-------------------------------------------------------------

  # custom_error_response (Optional, 複数可)
  # 設定内容: 特定のHTTPエラーコードに対するカスタムレスポンスを定義します。
  # 用途: エラーページのカスタマイズ、エラーキャッシュ時間の制御
  custom_error_response {
    # error_code (Required)
    # 設定内容: カスタムレスポンスを適用するHTTPエラーコード
    # 設定可能な値: 400, 403, 404, 405, 414, 416, 500, 501, 502, 503, 504
    error_code = 404

    # error_caching_min_ttl (Optional)
    # 設定内容: エラーレスポンスの最小キャッシュ時間（秒）
    # 設定可能な値: 0以上の整数
    # 省略時: デフォルトのキャッシュ時間を使用
    error_caching_min_ttl = 300

    # response_code (Optional)
    # 設定内容: ビューアに返すHTTPステータスコード
    # 設定可能な値: 200, 400, 403, 404, 405, 414, 416, 500, 501, 502, 503, 504
    # 注意: response_page_pathと一緒に指定する必要あり
    response_code = 200

    # response_page_path (Optional)
    # 設定内容: エラー時に返すカスタムエラーページのパス
    # 設定可能な値: スラッシュで始まるパス（例: /error-pages/404.html）
    # 注意: response_codeと一緒に指定する必要あり
    response_page_path = "/error-pages/404.html"
  }

  #-------------------------------------------------------------
  # 地理的制限設定 (Required)
  #-------------------------------------------------------------

  # restrictions (Required)
  # 設定内容: コンテンツ配信の制限を定義します。
  restrictions {
    # geo_restriction (Required)
    # 設定内容: 地理的な配信制限を定義します。
    geo_restriction {
      # restriction_type (Required)
      # 設定内容: 地理的制限のタイプ
      # 設定可能な値:
      #   - "none": 制限なし
      #   - "whitelist": 指定した国にのみ配信を許可
      #   - "blacklist": 指定した国への配信をブロック
      restriction_type = "none"

      # locations (Optional)
      # 設定内容: 制限を適用する国コード（ISO 3166-1 alpha-2）
      # 設定可能な値: 国コードのセット（例: ["US", "CA", "JP"]）
      # 注意: restriction_typeがwhitelistまたはblacklistの場合に使用
      locations = []
    }
  }

  #-------------------------------------------------------------
  # ビューア証明書設定 (Required)
  #-------------------------------------------------------------

  # viewer_certificate (Required)
  # 設定内容: HTTPS接続に使用するSSL/TLS証明書を定義します。
  viewer_certificate {
    # cloudfront_default_certificate (Optional)
    # 設定内容: CloudFrontデフォルト証明書を使用するか
    # 設定可能な値:
    #   - true: *.cloudfront.net証明書を使用
    #   - false: カスタム証明書を使用
    # 注意: acm_certificate_arn、iam_certificate_idと排他的
    cloudfront_default_certificate = true

    # acm_certificate_arn (Optional)
    # 設定内容: ACM証明書のARN
    # 設定可能な値: AWS Certificate Managerの証明書ARN
    # 注意: 証明書はus-east-1リージョンにある必要あり
    # acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

    # iam_certificate_id (Optional)
    # 設定内容: IAM証明書のID
    # 設定可能な値: IAM証明書ストアにアップロードされた証明書のID
    # iam_certificate_id = null

    # minimum_protocol_version (Optional)
    # 設定内容: HTTPS接続に使用する最小SSL/TLSプロトコルバージョン
    # 設定可能な値:
    #   - "SSLv3": SSLv3（非推奨）
    #   - "TLSv1": TLSv1
    #   - "TLSv1_2016": TLSv1（2016ポリシー）
    #   - "TLSv1.1_2016": TLSv1.1
    #   - "TLSv1.2_2018": TLSv1.2（2018ポリシー）
    #   - "TLSv1.2_2019": TLSv1.2（2019ポリシー）
    #   - "TLSv1.2_2021": TLSv1.2（2021ポリシー、推奨）
    #   - "TLSv1.2_2025": TLSv1.2（2025ポリシー）
    #   - "TLSv1.3_2025": TLSv1.3（2025ポリシー）
    # 省略時: TLSv1
    # 関連機能: CloudFront セキュリティポリシー
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/secure-connections-supported-viewer-protocols-ciphers.html
    minimum_protocol_version = "TLSv1.2_2021"

    # ssl_support_method (Optional)
    # 設定内容: CloudFrontがHTTPSリクエストを処理する方法
    # 設定可能な値:
    #   - "sni-only": SNI対応クライアントのみサポート（推奨、追加料金なし）
    #   - "vip": 専用IPアドレスを使用（レガシークライアント対応、追加料金あり）
    #   - "static-ip": Anycast静的IPを使用
    # 注意: acm_certificate_arnまたはiam_certificate_idを指定した場合に必須
    # ssl_support_method = "sni-only"
  }

  #-------------------------------------------------------------
  # ビューアmTLS設定 (Optional)
  #-------------------------------------------------------------

  # viewer_mtls_config (Optional)
  # 設定内容: 相互TLS（mTLS）認証の設定を定義します。
  # 用途: クライアント証明書による認証を要求
  # viewer_mtls_config {
  #   # mode (Optional)
  #   # 設定内容: mTLSのモード
  #   # 設定可能な値:
  #   #   - "verify": クライアント証明書を検証
  #   #   - "enforce": クライアント証明書を強制
  #   mode = "verify"
  #
  #   # trust_store_config (Optional)
  #   # 設定内容: 信頼ストアの設定
  #   trust_store_config {
  #     # trust_store_id (Required)
  #     # 設定内容: 信頼ストアのID
  #     trust_store_id = "ts-123456789"
  #
  #     # advertise_trust_store_ca_names (Optional)
  #     # 設定内容: CA名をクライアントに広告するか
  #     advertise_trust_store_ca_names = true
  #
  #     # ignore_certificate_expiry (Optional)
  #     # 設定内容: 証明書の有効期限を無視するか
  #     ignore_certificate_expiry = false
  #   }
  # }

  #-------------------------------------------------------------
  # コネクション関数関連付け (Optional)
  #-------------------------------------------------------------

  # connection_function_association (Optional, 最大1個)
  # 設定内容: コネクション関数の関連付けを定義します。
  # 用途: 接続レベルでの処理（TLSハンドシェイク時等）
  # connection_function_association {
  #   # id (Required)
  #   # 設定内容: コネクション関数のID
  #   id = "conn-func-123456"
  # }

  #-------------------------------------------------------------
  # ロギング設定 (Optional)
  #-------------------------------------------------------------

  # logging_config (Optional)
  # 設定内容: 標準ログ（アクセスログ）の設定を定義します。
  # 注意: V2ロギング（CloudWatch Logs配信）を使用する場合は
  #       aws_cloudwatch_log_delivery_sourceを使用
  # logging_config {
  #   # bucket (Optional)
  #   # 設定内容: ログを保存するS3バケット
  #   # 設定可能な値: S3バケットのドメイン名（例: my-logs.s3.amazonaws.com）
  #   bucket = "my-logs.s3.amazonaws.com"
  #
  #   # prefix (Optional)
  #   # 設定内容: ログファイルのプレフィックス
  #   # 設定可能な値: 任意の文字列
  #   prefix = "cloudfront/"
  #
  #   # include_cookies (Optional)
  #   # 設定内容: Cookie情報をログに含めるか
  #   # 設定可能な値:
  #   #   - true: Cookieを含める
  #   #   - false: Cookieを含めない（デフォルト）
  #   include_cookies = false
  # }

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
    Name        = "example-distribution"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ディストリビューションの識別子（例: EDFDVBD632BHDS5）
#
# - arn: ディストリビューションのARN
#        例: arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5
#
# - caller_reference: CloudFrontが将来の更新を許可するために使用する内部値
#
# - domain_name: ディストリビューションのドメイン名
#                例: d604721fxaaqy9.cloudfront.net
#
# - etag: ディストリビューション情報の現在のバージョン
#         例: E2QWRUHAPOMQZL
#
# - hosted_zone_id: Route 53エイリアスレコードセットに使用できるCloudFrontゾーンID
#                   固定値: Z2FDTNDATAQYW2
#
# - in_progress_validation_batches: 現在進行中の無効化バッチの数
#
# - last_modified_time: ディストリビューションが最後に変更された日時
#
# - logging_v1_enabled: V1ロギングが有効かどうか
#
# - status: ディストリビューションの現在のステータス
#           Deployed: 情報がCloudFrontシステム全体に伝播完了
#
# - tags_all: プロバイダーのdefault_tags設定から継承されたタグを含む
#             すべてのタグのマップ
#
# - trusted_key_groups: 信頼されたキーグループのリスト（署名付きURL/Cookie用）
#   - enabled: キーグループに有効な公開鍵があるかどうか
#   - items: 各キーグループの詳細
#     - key_group_id: キーグループID
#     - key_pair_ids: CloudFrontキーペアIDのセット
#
# - trusted_signers: 信頼された署名者のリスト（署名付きURL/Cookie用、非推奨）
#   - enabled: アカウントにアクティブなキーペアがあるかどうか
#   - items: 各署名者の詳細
#     - aws_account_number: AWSアカウントIDまたは"self"
#     - key_pair_ids: キーペアIDのセット
#---------------------------------------------------------------
