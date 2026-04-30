#---------------------------------------------------------------
# AWS CloudFront Multi-Tenant Distribution
#---------------------------------------------------------------
#
# Amazon CloudFrontのマルチテナントディストリビューションをプロビジョニングするリソースです。
# マルチテナントディストリビューションは、SaaS型サービスやマルチサイトを運営する
# 事業者が単一のディストリビューション設定を共有しつつ、各テナント（顧客サイト）に
# 個別のドメイン・証明書・パラメータを割り当てる仕組みを提供します。
# テナントごとの設定は aws_cloudfront_distribution_tenant リソースで管理し、
# 本リソースは複数テナントが共通利用するベース設定（オリジン、キャッシュ動作、
# ビューワー設定、ジオ制限、テナントパラメータ定義）を定義します。
#
# AWS公式ドキュメント:
#   - CloudFront マルチテナント: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-multi-tenant.html
#   - マルチテナント概念: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-multi-tenant-overview.html
#   - キャッシュビヘイビア: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.43.0/docs/resources/cloudfront_multitenant_distribution
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudfront_multitenant_distribution" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # comment (Required)
  # 設定内容: ディストリビューションに付与する任意のコメントを指定します。
  # 設定可能な値: 最大128文字の文字列
  # 用途: マルチテナントディストリビューションの目的や用途を識別するための情報を記述
  comment = "Multi-tenant distribution for SaaS customers"

  # enabled (Required)
  # 設定内容: ディストリビューションを有効化するかを指定します。
  # 設定可能な値:
  #   - true: ディストリビューションを有効化し、リクエスト処理を開始
  #   - false: ディストリビューションを無効化（CloudFrontはリクエストを受け付けません）
  enabled = true

  # default_root_object (Optional)
  # 設定内容: ビューワーがルートURL（例: https://example.com/）にアクセスした際に
  #           CloudFrontがオリジンにリクエストするデフォルトオブジェクトを指定します。
  # 設定可能な値: 1-255文字のオブジェクト名（例: "index.html"）
  # 省略時: 設定なし。ルートURLアクセス時はオリジンが返すデフォルト動作に従う
  default_root_object = "index.html"

  # http_version (Optional)
  # 設定内容: ビューワーとCloudFront間で使用する最大HTTPバージョンを指定します。
  # 設定可能な値:
  #   - "http1.1": HTTP/1.1のみ
  #   - "http2": HTTP/2をサポート（HTTP/1.1にフォールバック可能）
  #   - "http2and3": HTTP/2およびHTTP/3をサポート
  #   - "http3": HTTP/3を優先
  # 省略時: "http2"
  http_version = "http2"

  # web_acl_id (Optional)
  # 設定内容: ディストリビューションに関連付けるAWS WAF Web ACLのIDまたはARNを指定します。
  # 設定可能な値:
  #   - WAFv2の場合: ARN形式 (arn:aws:wafv2:us-east-1:...:global/webacl/...)
  #   - WAF Classic（旧）の場合: Web ACL ID
  # 省略時: WAFによる保護なし
  # 注意: WAFv2の場合、Web ACLは必ずus-east-1リージョンに作成する必要があります
  # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/cloudfront-features.html
  web_acl_id = "arn:aws:wafv2:us-east-1:123456789012:global/webacl/example/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # オリジン設定
  #-------------------------------------------------------------

  # origin (Required, 1個以上)
  # 設定内容: コンテンツの取得元となるオリジン（S3バケット、ALB、カスタムオリジン、VPCオリジン等）を定義します。
  # 関連機能: CloudFront オリジン
  #   1ディストリビューションに複数オリジンを定義可能。キャッシュビヘイビアの target_origin_id で参照されます。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DownloadDistS3AndCustomOrigins.html
  origin {

    # id (Required)
    # 設定内容: オリジンを一意に識別する文字列を指定します。
    # 設定可能な値: 1-128文字の任意の文字列
    # 用途: cache_behaviorやdefault_cache_behaviorの target_origin_id から参照
    id = "primaryS3Origin"

    # domain_name (Required)
    # 設定内容: オリジンのドメイン名を指定します。
    # 設定可能な値:
    #   - S3バケットの場合: <bucket-name>.s3.<region>.amazonaws.com
    #   - カスタムオリジンの場合: 任意のFQDN
    domain_name = "example-bucket.s3.us-east-1.amazonaws.com"

    # origin_path (Optional)
    # 設定内容: オリジンへのリクエスト時にパスの先頭に付与するパスを指定します。
    # 設定可能な値: "/" で始まる文字列（末尾は "/" を含めない）
    # 省略時: パスは付与されません
    origin_path = "/static"

    # connection_attempts (Optional)
    # 設定内容: オリジンへの接続試行回数を指定します。
    # 設定可能な値: 1-3
    # 省略時: 3
    connection_attempts = 3

    # connection_timeout (Optional)
    # 設定内容: オリジンへの接続確立までのタイムアウト秒数を指定します。
    # 設定可能な値: 1-10（秒）
    # 省略時: 10
    connection_timeout = 10

    # response_completion_timeout (Optional)
    # 設定内容: オリジンからのレスポンス完了を待つタイムアウト秒数を指定します。
    # 設定可能な値: 秒数（整数）
    # 省略時: AWSデフォルト値が適用されます
    response_completion_timeout = 60

    # origin_access_control_id (Optional)
    # 設定内容: S3またはLambda Function URL等へのアクセスを制御するOACのIDを指定します。
    # 設定可能な値: aws_cloudfront_origin_access_control リソースのID
    # 省略時: OACなし
    # 関連機能: CloudFront Origin Access Control (OAC)
    #   S3等のオリジンへの直接アクセスを禁止し、CloudFront経由のみ許可するためのSigV4署名機能。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
    origin_access_control_id = "E2QWRUHEXAMPLE"

    # custom_header (Optional, 複数指定可)
    # 設定内容: CloudFrontからオリジンへのリクエストに含めるカスタムHTTPヘッダーを指定します。
    # 用途: オリジン側でCloudFront経由のリクエストを識別する等
    custom_header {

      # header_name (Required)
      # 設定内容: カスタムヘッダーの名前を指定します。
      # 設定可能な値: HTTPヘッダー名として有効な文字列
      header_name = "X-Custom-Header"

      # header_value (Required)
      # 設定内容: カスタムヘッダーの値を指定します。
      # 設定可能な値: 任意の文字列
      header_value = "secret-value"
    }

    # custom_origin_config (Optional)
    # 設定内容: カスタムオリジン（S3以外、ALB/EC2/外部HTTPサーバー等）を使用する場合の設定ブロックです。
    # 注意: S3静的ウェブサイトホスティングを利用する場合もこのブロックを使用します
    custom_origin_config {

      # http_port (Required)
      # 設定内容: HTTPプロトコル使用時のオリジンのポート番号を指定します。
      # 設定可能な値: 1-65535（一般的には 80）
      http_port = 80

      # https_port (Required)
      # 設定内容: HTTPSプロトコル使用時のオリジンのポート番号を指定します。
      # 設定可能な値: 1-65535（一般的には 443）
      https_port = 443

      # origin_protocol_policy (Required)
      # 設定内容: CloudFrontからオリジンへの接続時に使用するプロトコルポリシーを指定します。
      # 設定可能な値:
      #   - "http-only": HTTPのみ使用（S3静的ウェブサイトの場合は必須）
      #   - "https-only": HTTPSのみ使用
      #   - "match-viewer": ビューワーが使用したプロトコルに合わせる
      origin_protocol_policy = "https-only"

      # origin_ssl_protocols (Required)
      # 設定内容: CloudFrontがオリジンとのHTTPS接続で使用するSSL/TLSプロトコルを指定します。
      # 設定可能な値: ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"] のセット
      # 推奨: ["TLSv1.2"] のみ指定（古いプロトコルはセキュリティリスク）
      origin_ssl_protocols = ["TLSv1.2"]

      # origin_keepalive_timeout (Optional)
      # 設定内容: CloudFrontがオリジンとのアイドルキープアライブ接続を維持する秒数を指定します。
      # 設定可能な値: 1-60（秒）。デフォルトでは最大60秒。クォータ引き上げで最大180秒
      # 省略時: 5
      origin_keepalive_timeout = 5

      # origin_read_timeout (Optional)
      # 設定内容: CloudFrontがオリジンからのレスポンスを待機する秒数を指定します。
      # 設定可能な値: 1-60（秒）。デフォルトでは最大60秒。クォータ引き上げで最大180秒
      # 省略時: 30
      origin_read_timeout = 30

      # ip_address_type (Optional)
      # 設定内容: オリジンへの接続に使用するIPアドレスタイプを指定します。
      # 設定可能な値:
      #   - "ipv4": IPv4のみを使用
      #   - "ipv6": IPv6のみを使用
      #   - "dualstack": IPv4とIPv6の両方を使用
      # 省略時: "ipv4"
      ip_address_type = "ipv4"
    }

    # vpc_origin_config (Optional)
    # 設定内容: VPC内のプライベートリソース（ALB/NLB/EC2等）をオリジンとする場合の設定ブロックです。
    # 関連機能: CloudFront VPC Origins
    #   インターネット公開せずにVPC内のオリジンをCloudFrontから利用可能。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-vpc-origins.html
    vpc_origin_config {

      # vpc_origin_id (Required)
      # 設定内容: aws_cloudfront_vpc_origin リソースのIDを指定します。
      # 設定可能な値: 有効なVPC OriginのID
      vpc_origin_id = "vo_EXAMPLE123"

      # origin_keepalive_timeout (Optional)
      # 設定内容: VPCオリジンとのキープアライブ接続を維持する秒数を指定します。
      # 設定可能な値: 1-60（秒）
      # 省略時: 5
      origin_keepalive_timeout = 5

      # origin_read_timeout (Optional)
      # 設定内容: VPCオリジンからのレスポンスを待機する秒数を指定します。
      # 設定可能な値: 1-60（秒）
      # 省略時: 30
      origin_read_timeout = 30
    }

    # origin_shield (Optional)
    # 設定内容: オリジンシールド（追加キャッシュレイヤー）の設定ブロックです。
    # 関連機能: CloudFront Origin Shield
    #   オリジンへのリクエストを集約し、キャッシュヒット率を向上させる中央キャッシュレイヤー。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/origin-shield.html
    origin_shield {

      # enabled (Required)
      # 設定内容: オリジンシールドを有効化するかを指定します。
      # 設定可能な値: true / false
      enabled = true

      # origin_shield_region (Optional)
      # 設定内容: オリジンシールドを配置するAWSリージョンを指定します。
      # 設定可能な値: オリジンシールドをサポートするAWSリージョンコード（例: us-east-1）
      # 省略時: enabled = true の場合は必須
      origin_shield_region = "us-east-1"
    }
  }

  #-------------------------------------------------------------
  # オリジングループ設定
  #-------------------------------------------------------------

  # origin_group (Optional, 複数指定可)
  # 設定内容: 複数のオリジンをグループ化し、プライマリ障害時にセカンダリへフェイルオーバーする設定ブロックです。
  # 関連機能: CloudFront オリジンフェイルオーバー
  #   プライマリオリジンが指定HTTPステータスコードを返した場合、セカンダリへ自動切替。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/high_availability_origin_failover.html
  origin_group {

    # id (Required)
    # 設定内容: オリジングループを一意に識別する文字列を指定します。
    # 設定可能な値: 1-128文字の任意の文字列
    # 用途: cache_behaviorのtarget_origin_idから参照
    id = "groupS3"

    # failover_criteria (Required)
    # 設定内容: フェイルオーバーをトリガーするHTTPステータスコードを定義する設定ブロックです。
    failover_criteria {

      # status_codes (Required)
      # 設定内容: フェイルオーバーをトリガーするHTTPステータスコードのセットを指定します。
      # 設定可能な値: 400, 403, 404, 416, 500, 502, 503, 504 から選択
      status_codes = [403, 404, 500, 502]
    }

    # member (Required, 2個必須)
    # 設定内容: グループに含めるオリジンを指定する設定ブロックです。プライマリ・セカンダリの順に2件指定します。
    member {

      # origin_id (Required)
      # 設定内容: グループに含めるオリジンのIDを指定します（origin.id と一致させる）。
      origin_id = "primaryS3Origin"
    }

    member {
      origin_id = "secondaryS3Origin"
    }
  }

  #-------------------------------------------------------------
  # デフォルトキャッシュビヘイビア設定
  #-------------------------------------------------------------

  # default_cache_behavior (Required)
  # 設定内容: 他のcache_behaviorのpath_patternに一致しないリクエストに適用される
  #           デフォルトのキャッシュ動作の設定ブロックです。
  # 関連機能: CloudFront キャッシュビヘイビア
  #   キャッシュキー、TTL、許可メソッド、ビューワープロトコル等を定義します。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-cache-behaviors.html
  default_cache_behavior {

    # target_origin_id (Required)
    # 設定内容: このビヘイビアが対象とするオリジンのIDを指定します。
    # 設定可能な値: origin または origin_group の id と一致する文字列
    target_origin_id = "primaryS3Origin"

    # viewer_protocol_policy (Required)
    # 設定内容: ビューワーがCloudFrontへアクセスする際のプロトコル制約を指定します。
    # 設定可能な値:
    #   - "allow-all": HTTPとHTTPSの両方を許可
    #   - "https-only": HTTPSのみ許可。HTTPはエラー
    #   - "redirect-to-https": HTTPアクセスをHTTPSにリダイレクト
    viewer_protocol_policy = "redirect-to-https"

    # cache_policy_id (Optional)
    # 設定内容: 関連付けるキャッシュポリシーのIDを指定します。
    # 設定可能な値: aws_cloudfront_cache_policy リソースのID または AWS管理ポリシーID
    # 省略時: forwarded_values（旧形式）を使用する場合は不要
    # 関連機能: CloudFront キャッシュポリシー
    #   キャッシュキーとTTLを定義する再利用可能なポリシー。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/controlling-the-cache-key.html
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    # origin_request_policy_id (Optional)
    # 設定内容: 関連付けるオリジンリクエストポリシーのIDを指定します。
    # 設定可能な値: aws_cloudfront_origin_request_policy リソースのID または AWS管理ポリシーID
    # 省略時: ポリシーなし
    # 関連機能: CloudFront オリジンリクエストポリシー
    #   オリジンへ転送するヘッダー、クッキー、クエリ文字列を定義。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/controlling-origin-requests.html
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"

    # response_headers_policy_id (Optional)
    # 設定内容: 関連付けるレスポンスヘッダーポリシーのIDを指定します。
    # 設定可能な値: aws_cloudfront_response_headers_policy リソースのID または AWS管理ポリシーID
    # 省略時: ポリシーなし
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"

    # field_level_encryption_id (Optional)
    # 設定内容: フィールドレベル暗号化設定のIDを指定します。
    # 設定可能な値: 有効なFLE設定ID
    # 省略時: 暗号化なし
    # 関連機能: CloudFront フィールドレベル暗号化
    #   POSTリクエストの特定フィールドを公開鍵で暗号化。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/field-level-encryption.html
    field_level_encryption_id = ""

    # realtime_log_config_arn (Optional)
    # 設定内容: リアルタイムログ設定のARNを指定します。
    # 設定可能な値: aws_cloudfront_realtime_log_config リソースのARN
    # 省略時: リアルタイムログなし
    # 関連機能: CloudFront リアルタイムログ
    #   Kinesis Data Streamsへリクエストログをほぼリアルタイム送信。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/real-time-logs.html
    realtime_log_config_arn = "arn:aws:cloudfront::123456789012:realtime-log-config/example"

    # compress (Optional)
    # 設定内容: CloudFrontが自動的にコンテンツを圧縮するかを指定します。
    # 設定可能な値:
    #   - true: gzip/Brotli圧縮を有効化
    #   - false: 圧縮しない
    # 省略時: false
    compress = true

    # allowed_methods (Required)
    # 設定内容: ビューワーからCloudFrontへのリクエストで許可するHTTPメソッドを定義する設定ブロックです。
    allowed_methods {

      # items (Required)
      # 設定内容: 許可するHTTPメソッドのセットを指定します。
      # 設定可能な値: ["GET", "HEAD"], ["GET", "HEAD", "OPTIONS"], ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"] のいずれか
      items = ["GET", "HEAD", "OPTIONS"]

      # cached_methods (Required)
      # 設定内容: CloudFrontがレスポンスをキャッシュするHTTPメソッドのセットを指定します。
      # 設定可能な値: ["GET", "HEAD"] または ["GET", "HEAD", "OPTIONS"]
      cached_methods = ["GET", "HEAD"]
    }

    # function_association (Optional, 複数指定可)
    # 設定内容: CloudFront Functionをイベントに関連付ける設定ブロックです。
    # 関連機能: CloudFront Functions
    #   超軽量・低レイテンシのJavaScript関数。HTTPヘッダー操作等のシンプル処理向け。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cloudfront-functions.html
    function_association {

      # event_type (Required)
      # 設定内容: 関数を実行するイベントタイプを指定します。
      # 設定可能な値:
      #   - "viewer-request": ビューワー→CloudFront時に実行
      #   - "viewer-response": CloudFront→ビューワー時に実行
      event_type = "viewer-request"

      # function_arn (Required)
      # 設定内容: 関連付けるCloudFront FunctionのARNを指定します。
      # 設定可能な値: aws_cloudfront_function リソースのARN
      function_arn = "arn:aws:cloudfront::123456789012:function/example-function"
    }

    # lambda_function_association (Optional, 複数指定可)
    # 設定内容: Lambda@Edge関数をイベントに関連付ける設定ブロックです。
    # 関連機能: Lambda@Edge
    #   CloudFrontエッジロケーションでLambdaを実行可能。複雑な処理や外部API連携に対応。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-at-the-edge.html
    lambda_function_association {

      # event_type (Required)
      # 設定内容: Lambda関数を実行するイベントタイプを指定します。
      # 設定可能な値:
      #   - "viewer-request": ビューワーリクエスト時
      #   - "origin-request": オリジンリクエスト時
      #   - "origin-response": オリジンレスポンス時
      #   - "viewer-response": ビューワーレスポンス時
      event_type = "origin-request"

      # lambda_function_arn (Required)
      # 設定内容: バージョン番号を含むLambda関数のARNを指定します（$LATEST不可）。
      # 設定可能な値: バージョン付きLambda関数ARN（us-east-1リージョンに作成）
      lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:example-function:1"

      # include_body (Optional)
      # 設定内容: Lambda関数にリクエストボディを渡すかを指定します。
      # 設定可能な値:
      #   - true: ボディを含める（viewer-request/origin-requestのみ有効）
      #   - false: ボディを含めない
      # 省略時: false
      include_body = false
    }

    # trusted_key_groups (Optional, 複数指定可)
    # 設定内容: 署名付きURL/Cookie用の信頼されたキーグループを指定する設定ブロックです。
    # 関連機能: CloudFront 署名付きURL/Cookie
    #   プライベートコンテンツへの一時的アクセスを許可。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/PrivateContent.html
    trusted_key_groups {

      # enabled (Optional)
      # 設定内容: 信頼されたキーグループを有効化するかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      enabled = false

      # items (Optional)
      # 設定内容: 信頼するキーグループIDのリストを指定します。
      # 設定可能な値: aws_cloudfront_key_group リソースのIDのリスト
      items = []
    }
  }

  #-------------------------------------------------------------
  # キャッシュビヘイビア（パスパターン別）
  #-------------------------------------------------------------

  # cache_behavior (Optional, 複数指定可)
  # 設定内容: 特定のパスパターンに一致するリクエストに適用するキャッシュ動作を定義する設定ブロックです。
  # 注意: リスト内の順序が優先順位となります。default_cache_behaviorはどのパスにも一致しない場合のフォールバック
  cache_behavior {

    # path_pattern (Required)
    # 設定内容: このビヘイビアを適用するパスパターンを指定します。
    # 設定可能な値: ワイルドカード（*, ?）を含むパスパターン（例: "/api/*", "*.jpg"）
    path_pattern = "/api/*"

    # target_origin_id (Required)
    # 設定内容: このビヘイビアが対象とするオリジンのIDを指定します。
    target_origin_id = "primaryS3Origin"

    # viewer_protocol_policy (Required)
    # 設定内容: ビューワーがCloudFrontへアクセスする際のプロトコル制約を指定します。
    # 設定可能な値: "allow-all", "https-only", "redirect-to-https"
    viewer_protocol_policy = "https-only"

    # cache_policy_id (Optional)
    # 設定内容: 関連付けるキャッシュポリシーのIDを指定します。
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"

    # origin_request_policy_id (Optional)
    # 設定内容: 関連付けるオリジンリクエストポリシーのIDを指定します。
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"

    # response_headers_policy_id (Optional)
    # 設定内容: 関連付けるレスポンスヘッダーポリシーのIDを指定します。
    response_headers_policy_id = "5cc3b908-e619-4b99-88e5-2cf7f45965bd"

    # field_level_encryption_id (Optional)
    # 設定内容: フィールドレベル暗号化設定のIDを指定します。
    field_level_encryption_id = ""

    # realtime_log_config_arn (Optional)
    # 設定内容: リアルタイムログ設定のARNを指定します。
    realtime_log_config_arn = "arn:aws:cloudfront::123456789012:realtime-log-config/example"

    # compress (Optional)
    # 設定内容: CloudFrontが自動的にコンテンツを圧縮するかを指定します。
    # 省略時: false
    compress = true

    # allowed_methods (Required)
    # 設定内容: ビューワーからCloudFrontへのリクエストで許可するHTTPメソッドを定義します。
    allowed_methods {

      # items (Required)
      # 設定内容: 許可するHTTPメソッドのセットを指定します。
      items = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]

      # cached_methods (Required)
      # 設定内容: CloudFrontがレスポンスをキャッシュするHTTPメソッドのセットを指定します。
      cached_methods = ["GET", "HEAD"]
    }

    # function_association (Optional, 複数指定可)
    # 設定内容: CloudFront Functionをイベントに関連付けます。
    function_association {

      # event_type (Required)
      # 設定内容: 関数を実行するイベントタイプを指定します。
      # 設定可能な値: "viewer-request", "viewer-response"
      event_type = "viewer-response"

      # function_arn (Required)
      # 設定内容: 関連付けるCloudFront FunctionのARNを指定します。
      function_arn = "arn:aws:cloudfront::123456789012:function/example-function"
    }

    # lambda_function_association (Optional, 複数指定可)
    # 設定内容: Lambda@Edge関数をイベントに関連付けます。
    lambda_function_association {

      # event_type (Required)
      # 設定内容: Lambda関数を実行するイベントタイプを指定します。
      # 設定可能な値: "viewer-request", "origin-request", "origin-response", "viewer-response"
      event_type = "viewer-request"

      # lambda_function_arn (Required)
      # 設定内容: バージョン番号を含むLambda関数のARNを指定します。
      lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:example-function:1"

      # include_body (Optional)
      # 設定内容: Lambda関数にリクエストボディを渡すかを指定します。
      # 省略時: false
      include_body = false
    }

    # trusted_key_groups (Optional, 複数指定可)
    # 設定内容: 署名付きURL/Cookie用の信頼されたキーグループを指定します。
    trusted_key_groups {

      # enabled (Optional)
      # 設定内容: 信頼されたキーグループを有効化するかを指定します。
      # 省略時: false
      enabled = false

      # items (Optional)
      # 設定内容: 信頼するキーグループIDのリストを指定します。
      items = []
    }
  }

  #-------------------------------------------------------------
  # カスタムエラーレスポンス設定
  #-------------------------------------------------------------

  # custom_error_response (Optional, 複数指定可)
  # 設定内容: 特定HTTPエラーコード発生時に独自のエラーページを返す設定ブロックです。
  # 関連機能: CloudFront カスタムエラーレスポンス
  #   オリジンが返すエラーをCloudFrontが代替ページに置換可能。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/GeneratingCustomErrorResponses.html
  custom_error_response {

    # error_code (Required)
    # 設定内容: 対象のHTTPエラーコードを指定します。
    # 設定可能な値: 400, 403, 404, 405, 414, 416, 500, 501, 502, 503, 504
    error_code = 404

    # response_code (Optional)
    # 設定内容: ビューワーに返すHTTPステータスコードを指定します。
    # 設定可能な値: 200, 400, 403, 404, 405, 414, 416, 500, 501, 502, 503, 504 等
    # 省略時: error_code がそのまま返されます
    response_code = "200"

    # response_page_path (Optional)
    # 設定内容: 代替として表示するページのパスを指定します。
    # 設定可能な値: "/" で始まるオリジン上のオブジェクトパス（例: "/errors/404.html"）
    # 省略時: 代替ページなし
    response_page_path = "/errors/404.html"

    # error_caching_min_ttl (Optional)
    # 設定内容: エラーレスポンスをキャッシュする最小秒数を指定します。
    # 設定可能な値: 0-31536000（秒）
    # 省略時: 10
    error_caching_min_ttl = 10
  }

  #-------------------------------------------------------------
  # 地理的制限設定
  #-------------------------------------------------------------

  # restrictions (Required)
  # 設定内容: コンテンツ配信に対する地理的制限の設定ブロックです。
  # 関連機能: CloudFront 地理的制限
  #   特定の国に対してアクセスを許可または禁止。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/georestrictions.html
  restrictions {

    # geo_restriction (Required)
    # 設定内容: 国コードベースのアクセス制限を定義する設定ブロックです。
    geo_restriction {

      # restriction_type (Required)
      # 設定内容: 制限タイプを指定します。
      # 設定可能な値:
      #   - "none": 制限なし（全世界からアクセス可能）
      #   - "whitelist": items に含まれる国のみアクセス許可
      #   - "blacklist": items に含まれる国をブロック
      restriction_type = "whitelist"

      # items (Optional)
      # 設定内容: 制限対象のISO 3166-1 alpha-2国コードのセットを指定します。
      # 設定可能な値: ISO 3166-1 alpha-2 国コード（例: "JP", "US", "GB"）
      # 省略時: restriction_type が "none" の場合のみ省略可能
      items = ["JP", "US"]
    }
  }

  #-------------------------------------------------------------
  # ビューワー証明書設定
  #-------------------------------------------------------------

  # viewer_certificate (Required)
  # 設定内容: ビューワーへのHTTPS接続で使用するSSL/TLS証明書の設定ブロックです。
  # 関連機能: CloudFront SSL/TLS証明書
  #   CloudFrontデフォルト証明書、ACM証明書、IAMアップロード証明書のいずれかを使用可能。
  #   マルチテナントの場合、テナント側で証明書を上書き可能なベース設定を定義します。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cnames-and-https-procedures.html
  viewer_certificate {

    # acm_certificate_arn (Optional)
    # 設定内容: ACMで管理するSSL/TLS証明書のARNを指定します。
    # 設定可能な値: us-east-1リージョンのACM証明書ARN
    # 省略時: cloudfront_default_certificate を使用する場合は不要
    # 注意: CloudFront用ACM証明書は必ず us-east-1（バージニア北部）に作成する必要があります
    acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

    # cloudfront_default_certificate (Optional)
    # 設定内容: CloudFrontのデフォルト証明書（*.cloudfront.net）を使用するかを指定します。
    # 設定可能な値:
    #   - true: デフォルト証明書を使用（カスタムドメインは利用不可）
    #   - false: ACM/IAM証明書を使用
    # 省略時: false
    cloudfront_default_certificate = false

    # minimum_protocol_version (Optional)
    # 設定内容: HTTPS接続で受け付ける最小TLSプロトコルバージョンを指定します。
    # 設定可能な値:
    #   - "SSLv3": 非推奨
    #   - "TLSv1": 非推奨
    #   - "TLSv1_2016", "TLSv1.1_2016"
    #   - "TLSv1.2_2018", "TLSv1.2_2019", "TLSv1.2_2021"
    # 省略時: cloudfront_default_certificate=true の場合は "TLSv1"、それ以外は "TLSv1.2_2021"
    minimum_protocol_version = "TLSv1.2_2021"

    # ssl_support_method (Optional)
    # 設定内容: ビューワーへのHTTPS提供方法を指定します。
    # 設定可能な値:
    #   - "sni-only": SNI対応クライアントのみ（推奨、追加料金なし）
    #   - "vip": 専用IP（追加料金あり、レガシークライアント対応）
    #   - "static-ip": 静的IP割当（限定的サービス）
    # 省略時: cloudfront_default_certificate=true の場合は不要
    ssl_support_method = "sni-only"
  }

  #-------------------------------------------------------------
  # テナントパラメータ定義
  #-------------------------------------------------------------

  # tenant_config (Optional)
  # 設定内容: マルチテナントディストリビューションでテナントごとにカスタマイズ可能なパラメータを定義する設定ブロックです。
  # 関連機能: CloudFront マルチテナント パラメータ
  #   キャッシュビヘイビアやオリジン設定中で {{tenantName}} のように参照可能なテナント単位のパラメータ。
  #   各 aws_cloudfront_distribution_tenant でパラメータ値を実際に設定します。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-multi-tenant-parameters.html
  tenant_config {

    # parameter_definition (Optional, 複数指定可)
    # 設定内容: 個別のテナントパラメータを定義する設定ブロックです。
    parameter_definition {

      # name (Required)
      # 設定内容: パラメータの名前を指定します。
      # 設定可能な値: 1-32文字の英数字またはアンダースコア
      # 用途: 設定中で {{name}} の形式で参照
      name = "tenantName"

      # definition (Required)
      # 設定内容: パラメータのデータ型および制約を定義する設定ブロックです。
      definition {

        # string_schema (Required)
        # 設定内容: 文字列型パラメータのスキーマ定義ブロックです。
        string_schema {

          # required (Required)
          # 設定内容: テナント側でこのパラメータの設定を必須にするかを指定します。
          # 設定可能な値:
          #   - true: テナントは必ず値を指定する必要あり
          #   - false: 任意（default_value が使用される）
          required = true

          # default_value (Optional)
          # 設定内容: テナントが値を指定しなかった場合に使用されるデフォルト値を指定します。
          # 設定可能な値: 任意の文字列
          # 省略時: required=true の場合は不要、required=false の場合はデフォルト値なし
          default_value = "default-tenant"

          # comment (Optional)
          # 設定内容: パラメータに関する説明コメントを指定します。
          # 設定可能な値: 任意の文字列
          comment = "Tenant identifier used in origin path templating"
        }
      }
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のカスタムタイムアウトを指定する設定ブロックです。
  # 関連機能: Terraformタイムアウト
  #   時間単位は s/m/h を使用（例: "30m"）。
  timeouts {

    # create (Optional)
    # 設定内容: 作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30m", "1h"）
    # 省略時: プロバイダーデフォルト値
    create = "30m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30m", "1h"）
    # 省略時: プロバイダーデフォルト値
    update = "30m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30m", "1h"）
    # 省略時: プロバイダーデフォルト値
    delete = "30m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定と同じキーを持つタグは、リソース側で上書きします。
  tags = {
    Name        = "multitenant-distribution-example"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ディストリビューションのAmazon Resource Name (ARN)
# - id: ディストリビューションの識別子
# - caller_reference: 作成時の一意なリファレンス文字列
# - connection_mode: 接続モード（マルチテナントでは "tenant-only" 等）
# - domain_name: CloudFrontが割り当てたドメイン名（例: d1234.cloudfront.net）
# - etag: ディストリビューションの現在のETag
# - in_progress_invalidation_batches: 進行中の無効化バッチ数
# - last_modified_time: 最終更新日時
# - status: ディストリビューションのステータス（"InProgress" / "Deployed"）
# - active_trusted_key_groups (読み取り専用ブロック): 署名付きURL/Cookieに使用される
#   信頼されたキーグループの情報。各 items 配下に key_group_id, key_pair_ids が含まれます。
# - tags_all: 継承タグを含む全タグマップ
#---------------------------------------------------------------
