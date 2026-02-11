# =============================================================================
# AWS CloudFront Multi-Tenant Distribution - Annotated Template
# =============================================================================
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# NOTE: このテンプレートは生成時点の情報です。
#       最新の仕様については公式ドキュメントを確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_multitenant_distribution
# =============================================================================

resource "aws_cloudfront_multitenant_distribution" "example" {
  # =========================================================================
  # Required Arguments
  # =========================================================================

  # comment - (Required) ディストリビューションに含めるコメント
  # マルチテナントディストリビューションの用途や目的を記述
  comment = "Multi-tenant distribution for my application"

  # enabled - (Required) ディストリビューションがエンドユーザーのリクエストを受け付けるかどうか
  # true: 有効、false: 無効
  enabled = true

  # =========================================================================
  # Optional Top-Level Arguments
  # =========================================================================

  # default_root_object - (Optional) エンドユーザーがルートURLをリクエストしたときにCloudFrontが返すオブジェクト
  # 例: "index.html"
  default_root_object = "index.html"

  # http_version - (Optional) ディストリビューションでサポートする最大HTTPバージョン
  # 有効値: "http1.1", "http2", "http2and3", "http3"
  # デフォルト: "http2"
  http_version = "http2"

  # tags - (Optional) リソースに割り当てるタグのマップ
  # provider の default_tags と組み合わせて使用可能
  tags = {
    Environment = "production"
    Application = "web"
  }

  # web_acl_id - (Optional) このディストリビューションに関連付けるAWS WAF v2 Web ACLの一意の識別子
  # Web Application Firewallを使用してセキュリティルールを適用
  web_acl_id = "arn:aws:wafv2:us-east-1:123456789012:global/webacl/example/a1b2c3d4-5678-90ab-cdef-EXAMPLE11111"

  # =========================================================================
  # Required Blocks
  # =========================================================================

  # origin - (Required) このディストリビューションのオリジン設定（複数指定可能）
  # 最低1つは必須
  origin {
    # domain_name - (Required) S3バケットまたはカスタムオリジンのDNSドメイン名
    domain_name = "example.com"

    # id - (Required) オリジンの一意の識別子
    # cache_behavior や default_cache_behavior の target_origin_id で参照
    id = "example-origin"

    # connection_attempts - (Optional) CloudFrontがオリジンへの接続を試行する回数
    # 範囲: 1-3、デフォルト: 3
    connection_attempts = 3

    # connection_timeout - (Optional) CloudFrontがオリジンへの接続確立を待機する秒数
    # 範囲: 1-10、デフォルト: 10
    connection_timeout = 10

    # origin_access_control_id - (Optional) オリジンに関連付けるCloudFront Origin Access Controlの識別子
    # S3オリジンへのアクセス制御に使用
    origin_access_control_id = "E1ABC2DEF3GHI4"

    # origin_path - (Optional) CloudFrontがコンテンツをリクエストするディレクトリパス
    # 例: "/production"
    origin_path = "/production"

    # response_completion_timeout - (Optional) CloudFrontがオリジンからのレスポンスを待機する秒数
    # デフォルト: 30
    response_completion_timeout = 30

    # custom_header - (Optional) オリジンに送信するカスタムヘッダー（複数指定可能）
    custom_header {
      # header_name - (Required) ヘッダー名
      header_name = "X-Custom-Header"

      # header_value - (Required) ヘッダー値
      header_value = "custom-value"
    }

    # custom_origin_config - (Optional) カスタムオリジンの設定
    # S3以外のオリジン（Webサーバーなど）を使用する場合に指定
    custom_origin_config {
      # http_port - (Required) カスタムオリジンがリッスンするHTTPポート
      http_port = 80

      # https_port - (Required) カスタムオリジンがリッスンするHTTPSポート
      https_port = 443

      # origin_protocol_policy - (Required) オリジンに適用するプロトコルポリシー
      # 有効値: "http-only", "https-only", "match-viewer"
      origin_protocol_policy = "https-only"

      # origin_ssl_protocols - (Required) CloudFrontがHTTPS経由でオリジンと通信する際に使用するSSL/TLSプロトコルのリスト
      # 有効値: "SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"
      origin_ssl_protocols = ["TLSv1.2"]

      # ip_address_type - (Optional) オリジンが使用するIPアドレスのタイプ
      # 有効値: "ipv4", "dualstack"
      ip_address_type = "ipv4"

      # origin_keepalive_timeout - (Optional) カスタムキープアライブタイムアウト（秒）
      # デフォルト: 5
      origin_keepalive_timeout = 5

      # origin_read_timeout - (Optional) カスタム読み取りタイムアウト（秒）
      # デフォルト: 30
      origin_read_timeout = 30
    }

    # origin_shield - (Optional) CloudFront Origin Shield の設定
    # オリジンへの負荷を軽減し、キャッシュヒット率を向上
    origin_shield {
      # enabled - (Required) Origin Shield を有効にするかどうか
      enabled = true

      # origin_shield_region - (Optional) Origin Shield のAWSリージョン
      # enabled が true の場合は必須
      origin_shield_region = "us-east-1"
    }

    # vpc_origin_config - (Optional) CloudFront VPC オリジンの設定
    # VPC内のプライベートリソースをオリジンとして使用
    vpc_origin_config {
      # vpc_origin_id - (Required) CloudFrontがリクエストをルーティングするVPCオリジンのID
      vpc_origin_id = "vo-1234567890abcdef0"

      # origin_keepalive_timeout - (Optional) カスタムキープアライブタイムアウト（秒）
      # デフォルト: 5
      origin_keepalive_timeout = 5

      # origin_read_timeout - (Optional) カスタム読み取りタイムアウト（秒）
      # デフォルト: 30
      origin_read_timeout = 30
    }
  }

  # default_cache_behavior - (Required) デフォルトのキャッシュ動作設定
  # パスパターンに一致しないリクエストに適用
  default_cache_behavior {
    # target_origin_id - (Required) リクエストをルーティングするオリジンのID
    # origin ブロックの id と一致する必要がある
    target_origin_id = "example-origin"

    # viewer_protocol_policy - (Required) ユーザーがコンテンツにアクセスする際に使用できるプロトコル
    # 有効値: "allow-all", "https-only", "redirect-to-https"
    viewer_protocol_policy = "redirect-to-https"

    # cache_policy_id - (Optional) キャッシュビヘイビアに適用するキャッシュポリシーの一意の識別子
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    # compress - (Optional) CloudFrontがAccept-Encoding: gzipを含むリクエストに対してコンテンツを自動圧縮するかどうか
    # デフォルト: false
    compress = true

    # field_level_encryption_id - (Optional) フィールドレベル暗号化の設定ID
    field_level_encryption_id = "E1ABC2DEF3GHI4"

    # origin_request_policy_id - (Optional) ビヘイビアに適用するオリジンリクエストポリシーの一意の識別子
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"

    # realtime_log_config_arn - (Optional) このキャッシュビヘイビアに適用するリアルタイムログ設定のARN
    realtime_log_config_arn = "arn:aws:cloudfront::123456789012:realtime-log-config/ExampleConfig"

    # response_headers_policy_id - (Optional) レスポンスヘッダーポリシーの識別子
    response_headers_policy_id = "5cc3b908-e619-4b99-88e5-2cf7f45965bd"

    # allowed_methods - (Required) CloudFrontが処理してオリジンに転送するHTTPメソッドを制御
    allowed_methods {
      # items - (Required) 許可するHTTPメソッドのセット
      # 有効値: "GET", "HEAD", "POST", "PUT", "PATCH", "OPTIONS", "DELETE"
      items = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]

      # cached_methods - (Required) CloudFrontが指定されたHTTPメソッドを使用したリクエストに対してレスポンスをキャッシュするかどうかを制御
      cached_methods = ["GET", "HEAD"]
    }

    # function_association - (Optional) CloudFront Functions の関連付け（複数指定可能）
    function_association {
      # event_type - (Required) この関数をトリガーする特定のイベント
      # 有効値: "viewer-request", "origin-request", "viewer-response", "origin-response"
      event_type = "viewer-request"

      # function_arn - (Required) CloudFront FunctionのARN
      function_arn = "arn:aws:cloudfront::123456789012:function/ExampleFunction"
    }

    # lambda_function_association - (Optional) Lambda@Edge の関連付け（複数指定可能）
    lambda_function_association {
      # event_type - (Required) この関数をトリガーする特定のイベント
      # 有効値: "viewer-request", "origin-request", "viewer-response", "origin-response"
      event_type = "viewer-request"

      # lambda_function_arn - (Required) Lambda関数のARN
      # バージョン番号を含む完全なARNを指定する必要がある
      lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:ExampleFunction:1"

      # include_body - (Optional) リクエストボディをLambda関数に公開するかどうか
      # デフォルト: false
      include_body = false
    }

    # trusted_key_groups - (Optional) CloudFrontが署名付きURLまたは署名付きCookieを検証するために使用できるキーグループのリスト
    trusted_key_groups {
      # enabled - (Optional) トラステッドキーグループを有効にするかどうか
      # デフォルト: computed
      enabled = true

      # items - (Optional) キーグループIDのリスト
      items = ["K1ABCDEFGHIJ2L"]
    }
  }

  # restrictions - (Required) このディストリビューションの制限設定
  restrictions {
    # geo_restriction - (Required) 地理的制限の設定
    geo_restriction {
      # restriction_type - (Required) コンテンツの配信を制限する方法
      # 有効値: "none", "whitelist", "blacklist"
      restriction_type = "none"

      # items - (Optional) ISO 3166-1-alpha-2の国コードのリスト
      # restriction_type が "whitelist" または "blacklist" の場合は必須
      items = ["US", "CA", "GB"]
    }
  }

  # tenant_config - (Required) マルチテナントディストリビューション用のパラメータ定義を含むテナント設定
  tenant_config {
    # parameter_definition - (Required) テナント設定用の1つ以上のパラメータ定義
    parameter_definition {
      # name - (Required) パラメータの名前
      name = "origin_domain"

      # definition - (Required) パラメータスキーマの定義
      definition {
        # string_schema - (Required) 文字列スキーマの設定
        string_schema {
          # required - (Required) パラメータが必須かどうか
          required = true

          # comment - (Optional) パラメータを説明するコメント
          comment = "Origin domain parameter for tenants"

          # default_value - (Optional) パラメータのデフォルト値
          default_value = "example.com"
        }
      }
    }
  }

  # viewer_certificate - (Required) このディストリビューションのSSL設定
  viewer_certificate {
    # acm_certificate_arn - (Optional) このディストリビューションで使用するAWS Certificate Manager証明書のARN
    # カスタムSSL証明書を使用する場合は必須
    acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

    # cloudfront_default_certificate - (Optional) CloudFrontのデフォルト証明書を使用するかどうか
    # acm_certificate_arn と併用不可
    cloudfront_default_certificate = false

    # minimum_protocol_version - (Optional) CloudFrontがHTTPS接続に使用するSSLプロトコルの最小バージョン
    # デフォルト: "TLSv1"
    # 有効値: "SSLv3", "TLSv1", "TLSv1_2016", "TLSv1.1_2016", "TLSv1.2_2018", "TLSv1.2_2019", "TLSv1.2_2021"
    minimum_protocol_version = "TLSv1.2_2021"

    # ssl_support_method - (Optional) CloudFrontがHTTPSリクエストを処理する方法
    # 有効値: "sni-only", "vip"
    # acm_certificate_arn が指定されている場合は必須
    ssl_support_method = "sni-only"
  }

  # =========================================================================
  # Optional Blocks
  # =========================================================================

  # cache_behavior - (Optional) 順序付きキャッシュビヘイビアのリスト（複数指定可能）
  # 特定のパスパターンに対するキャッシュ動作をカスタマイズ
  cache_behavior {
    # path_pattern - (Required) このキャッシュビヘイビアを適用するリクエストを指定するパターン
    # 例: "images/*.jpg"
    path_pattern = "images/*.jpg"

    # target_origin_id - (Required) リクエストをルーティングするオリジンのID
    target_origin_id = "example-origin"

    # viewer_protocol_policy - (Required) ユーザーがコンテンツにアクセスする際に使用できるプロトコル
    # 有効値: "allow-all", "https-only", "redirect-to-https"
    viewer_protocol_policy = "redirect-to-https"

    # cache_policy_id - (Optional) キャッシュビヘイビアに適用するキャッシュポリシーの一意の識別子
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    # compress - (Optional) CloudFrontがAccept-Encoding: gzipを含むリクエストに対してコンテンツを自動圧縮するかどうか
    # デフォルト: false
    compress = true

    # field_level_encryption_id - (Optional) フィールドレベル暗号化の設定ID
    field_level_encryption_id = "E1ABC2DEF3GHI4"

    # origin_request_policy_id - (Optional) ビヘイビアに適用するオリジンリクエストポリシーの一意の識別子
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"

    # realtime_log_config_arn - (Optional) このキャッシュビヘイビアに適用するリアルタイムログ設定のARN
    realtime_log_config_arn = "arn:aws:cloudfront::123456789012:realtime-log-config/ExampleConfig"

    # response_headers_policy_id - (Optional) レスポンスヘッダーポリシーの識別子
    response_headers_policy_id = "5cc3b908-e619-4b99-88e5-2cf7f45965bd"

    # allowed_methods - (Required) CloudFrontが処理してオリジンに転送するHTTPメソッドを制御
    allowed_methods {
      # items - (Required) 許可するHTTPメソッドのセット
      items = ["GET", "HEAD", "OPTIONS"]

      # cached_methods - (Required) キャッシュするHTTPメソッド
      cached_methods = ["GET", "HEAD"]
    }

    # function_association - (Optional) CloudFront Functions の関連付け（複数指定可能）
    function_association {
      # event_type - (Required) この関数をトリガーする特定のイベント
      event_type = "viewer-request"

      # function_arn - (Required) CloudFront FunctionのARN
      function_arn = "arn:aws:cloudfront::123456789012:function/ExampleFunction"
    }

    # lambda_function_association - (Optional) Lambda@Edge の関連付け（複数指定可能）
    lambda_function_association {
      # event_type - (Required) この関数をトリガーする特定のイベント
      event_type = "viewer-request"

      # lambda_function_arn - (Required) Lambda関数のARN
      lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:ExampleFunction:1"

      # include_body - (Optional) リクエストボディをLambda関数に公開するかどうか
      include_body = false
    }

    # trusted_key_groups - (Optional) CloudFrontが署名付きURLまたは署名付きCookieを検証するために使用できるキーグループのリスト
    trusted_key_groups {
      # enabled - (Optional) トラステッドキーグループを有効にするかどうか
      enabled = true

      # items - (Optional) キーグループIDのリスト
      items = ["K1ABCDEFGHIJ2L"]
    }
  }

  # custom_error_response - (Optional) 1つ以上のカスタムエラーレスポンス要素（複数指定可能）
  # オリジンからエラーが返された場合のCloudFrontの動作をカスタマイズ
  custom_error_response {
    # error_code - (Required) カスタムエラーページやキャッシュ期間を指定するHTTPステータスコード
    # 例: 400, 403, 404, 500
    error_code = 404

    # error_caching_min_ttl - (Optional) CloudFrontがerror_codeで指定されたHTTPステータスコードをキャッシュする最小時間（秒）
    error_caching_min_ttl = 300

    # response_code - (Optional) CloudFrontがカスタムエラーページと共にビューアに返すHTTPステータスコード
    response_code = "200"

    # response_page_path - (Optional) error_codeで指定されたHTTPステータスコードをオリジンが返したときにCloudFrontがビューアに返すカスタムエラーページのパス
    response_page_path = "/error-pages/404.html"
  }

  # origin_group - (Optional) このディストリビューション用の1つ以上のorigin_group（複数指定可能）
  # オリジンフェイルオーバーを設定
  origin_group {
    # origin_id - (Required) オリジングループの一意の識別子
    origin_id = "groupS3"

    # failover_criteria - (Required) セカンダリオリジンにフェイルオーバーする条件
    failover_criteria {
      # status_codes - (Required) セカンダリオリジンへのフェイルオーバーをトリガーするHTTPステータスコードのリスト
      # 例: 500, 502, 503, 504
      status_codes = [500, 502, 503, 504]
    }

    # member - (Required) このオリジングループ内のオリジンのリスト
    # 正確に2つのメンバーを含む必要がある
    member {
      # origin_id - (Required) オリジングループ内のオリジンの一意の識別子
      origin_id = "primaryS3"
    }

    member {
      # origin_id - (Required) オリジングループ内のオリジンの一意の識別子
      origin_id = "failoverS3"
    }
  }

  # timeouts - (Optional) タイムアウト設定
  timeouts {
    # create - (Optional) 作成操作のタイムアウト
    # 例: "30s", "2h45m"
    create = "40m"

    # update - (Optional) 更新操作のタイムアウト
    update = "40m"

    # delete - (Optional) 削除操作のタイムアウト
    delete = "40m"
  }
}

# =============================================================================
# Computed-Only Attributes (Read-Only)
# =============================================================================
# 以下の属性は computed-only であり、Terraformによって自動的に設定されます。
# テンプレートには含めませんが、output や data source で参照可能です。
#
# - arn                              : ディストリビューションのARN
# - caller_reference                 : CloudFrontが将来のディストリビューション設定の更新を許可するために使用する内部値
# - connection_mode                  : ディストリビューションの接続モード（マルチテナントディストリビューションの場合は常に "tenant-only"）
# - domain_name                      : ディストリビューションに対応するドメイン名
# - etag                             : ディストリビューション情報の現在のバージョン
# - id                               : ディストリビューションの識別子
# - in_progress_invalidation_batches : 現在進行中の無効化バッチの数
# - last_modified_time               : ディストリビューションが最後に変更された日時
# - status                           : ディストリビューションの現在のステータス（"Deployed"など）
# - tags_all                         : providerのdefault_tagsを含むリソースに割り当てられたタグのマップ
# - active_trusted_key_groups        : CloudFrontが署名付きURLまたは署名付きCookieを検証するために使用できるキーグループのリスト
#   - enabled                        : キーグループが有効かどうか
#   - items                          : キーグループのリスト
#     - key_group_id                 : 公開鍵を含むキーグループのID
#     - key_pair_ids                 : 署名付きURLおよび署名付きCookieの署名を検証するために使用できるアクティブなCloudFrontキーペアのセット
# =============================================================================

# =============================================================================
# 参考リンク
# =============================================================================
# Terraform AWS Provider - CloudFront Multi-Tenant Distribution:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_multitenant_distribution
#
# AWS CloudFront Developer Guide - Multi-Tenant Distributions:
#   https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-config-options.html
#
# AWS Blog - CloudFront SaaS Manager:
#   https://aws.amazon.com/blogs/aws/reduce-your-operational-overhead-today-with-amazon-cloudfront-saas-manager/
#
# AWS CloudFront Developer Guide - Tenant Customizations:
#   https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/tenant-customization.html
# =============================================================================
