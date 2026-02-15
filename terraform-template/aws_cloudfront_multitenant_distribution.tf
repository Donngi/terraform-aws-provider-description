#######################################################################
# Terraform Template: aws_cloudfront_multitenant_distribution
#######################################################################
# 目的: CloudFront マルチテナントディストリビューションを作成・管理
# リソース種別: AWS CloudFront
# 説明: 複数テナント向けのパラメータ化されたCloudFrontディストリビューションを定義し、
#       テナント固有の設定をサポートします。
#-----------------------------------------------------------------------
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_multitenant_distribution
# Generated: 2026-02-12
#-----------------------------------------------------------------------
# NOTE:
# - マルチテナント構成では、各テナント向けにパラメータ化された設定を提供
# - テナント設定は parameter_definition で定義したパラメータを使用
# - enabled が false の場合でも課金対象となる点に注意
# - ディストリビューションの有効化には15分以上かかる場合がある
# - ドメイン名の変更には新規作成・削除が必要
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# リソース定義
#-----------------------------------------------------------------------
resource "aws_cloudfront_multitenant_distribution" "example" {

  #-----------------------------------------------------------------------
  # 基本設定
  #-----------------------------------------------------------------------
  # 設定内容: ディストリビューションの説明コメント
  # 省略時: 設定不可（必須）
  comment = "Multi-tenant CloudFront distribution"

  # 設定内容: ディストリビューションの有効化状態
  # 設定可能な値: true（有効）、false（無効）
  # 省略時: 設定不可（必須）
  enabled = true

  #-----------------------------------------------------------------------
  # オリジン設定
  #-----------------------------------------------------------------------
  # 設定内容: コンテンツソースとなるオリジンの設定
  # 省略時: 設定不可（最低1つ必須）
  origin {
    # 設定内容: オリジンの一意識別子
    # 省略時: 設定不可（必須）
    id = "example-origin"

    # 設定内容: オリジンのドメイン名（S3バケット、ELB、カスタムオリジンなど）
    # 省略時: 設定不可（必須）
    domain_name = "example.s3.amazonaws.com"

    # 設定内容: オリジン配下の特定パスをルートとして使用
    # 省略時: ルートパス（/）から配信
    # origin_path = "/production"

    # 設定内容: オリジン接続試行回数
    # 設定可能な値: 1〜3
    # 省略時: 3
    # connection_attempts = 3

    # 設定内容: オリジン接続タイムアウト（秒）
    # 設定可能な値: 1〜10
    # 省略時: 10
    # connection_timeout = 10

    # 設定内容: レスポンス完了タイムアウト（秒）
    # 設定可能な値: 1〜300
    # 省略時: 30
    # response_completion_timeout = 30

    # 設定内容: Origin Access Control の ID（S3オリジン推奨）
    # 省略時: OAC未使用
    # origin_access_control_id = aws_cloudfront_origin_access_control.example.id

    #-----------------------------------------------------------------------
    # カスタムオリジン設定（S3以外の場合）
    #-----------------------------------------------------------------------
    # custom_origin_config {
    #   # 設定内容: HTTPポート番号
    #   # 省略時: 設定不可（必須）
    #   http_port = 80
    #
    #   # 設定内容: HTTPSポート番号
    #   # 省略時: 設定不可（必須）
    #   https_port = 443
    #
    #   # 設定内容: オリジンへの通信プロトコル
    #   # 設定可能な値: http-only、https-only、match-viewer
    #   # 省略時: 設定不可（必須）
    #   origin_protocol_policy = "https-only"
    #
    #   # 設定内容: オリジンとの通信で使用するSSL/TLSプロトコル
    #   # 設定可能な値: SSLv3、TLSv1、TLSv1.1、TLSv1.2
    #   # 省略時: 設定不可（必須）
    #   origin_ssl_protocols = ["TLSv1.2"]
    #
    #   # 設定内容: オリジンのIPアドレスタイプ
    #   # 設定可能な値: IPv4、dualstack
    #   # 省略時: IPv4
    #   # ip_address_type = "IPv4"
    #
    #   # 設定内容: Keep-Aliveタイムアウト（秒）
    #   # 設定可能な値: 1〜60
    #   # 省略時: 5
    #   # origin_keepalive_timeout = 5
    #
    #   # 設定内容: 読み取りタイムアウト（秒）
    #   # 設定可能な値: 1〜60
    #   # 省略時: 30
    #   # origin_read_timeout = 30
    # }

    #-----------------------------------------------------------------------
    # VPCオリジン設定（VPC Lattice統合の場合）
    #-----------------------------------------------------------------------
    # vpc_origin_config {
    #   # 設定内容: VPCオリジンID
    #   # 省略時: 設定不可（必須）
    #   vpc_origin_id = "vpc-origin-1"
    #
    #   # 設定内容: Keep-Aliveタイムアウト（秒）
    #   # 設定可能な値: 1〜60
    #   # 省略時: 5
    #   # origin_keepalive_timeout = 5
    #
    #   # 設定内容: 読み取りタイムアウト（秒）
    #   # 設定可能な値: 1〜60
    #   # 省略時: 30
    #   # origin_read_timeout = 30
    # }

    #-----------------------------------------------------------------------
    # カスタムヘッダー設定
    #-----------------------------------------------------------------------
    # custom_header {
    #   # 設定内容: ヘッダー名
    #   # 省略時: 設定不可（必須）
    #   header_name = "X-Custom-Header"
    #
    #   # 設定内容: ヘッダー値
    #   # 省略時: 設定不可（必須）
    #   header_value = "custom-value"
    # }

    #-----------------------------------------------------------------------
    # Origin Shield 設定
    #-----------------------------------------------------------------------
    # origin_shield {
    #   # 設定内容: Origin Shield の有効化状態
    #   # 省略時: 設定不可（必須）
    #   enabled = true
    #
    #   # 設定内容: Origin Shield のリージョン
    #   # 省略時: 自動選択
    #   # origin_shield_region = "us-east-1"
    # }
  }

  #-----------------------------------------------------------------------
  # オリジングループ設定（フェイルオーバー構成）
  #-----------------------------------------------------------------------
  # origin_group {
  #   # 設定内容: オリジングループの一意識別子
  #   # 省略時: 設定不可（必須）
  #   origin_id = "group-1"
  #
  #   # フェイルオーバー条件
  #   failover_criteria {
  #     # 設定内容: フェイルオーバーをトリガーするHTTPステータスコード
  #     # 省略時: 設定不可（必須）
  #     status_codes = [500, 502, 503, 504]
  #   }
  #
  #   # プライマリオリジン
  #   member {
  #     # 設定内容: オリジンID
  #     # 省略時: 設定不可（必須）
  #     origin_id = "primary-origin"
  #   }
  #
  #   # セカンダリオリジン
  #   member {
  #     # 設定内容: オリジンID
  #     # 省略時: 設定不可（必須）
  #     origin_id = "secondary-origin"
  #   }
  # }

  #-----------------------------------------------------------------------
  # デフォルトキャッシュビヘイビア設定
  #-----------------------------------------------------------------------
  # 設定内容: 全てのリクエストに適用されるデフォルトの動作設定
  # 省略時: 設定不可（必須）
  default_cache_behavior {
    # 設定内容: リクエスト転送先のオリジンID
    # 省略時: 設定不可（必須）
    target_origin_id = "example-origin"

    # 設定内容: ビューワープロトコルポリシー
    # 設定可能な値: allow-all、https-only、redirect-to-https
    # 省略時: 設定不可（必須）
    viewer_protocol_policy = "redirect-to-https"

    # 設定内容: キャッシュポリシーID（Managed または Custom）
    # 省略時: レガシーキャッシュ設定を使用
    # cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized

    # 設定内容: オリジンリクエストポリシーID
    # 省略時: キャッシュキー以外のヘッダー・Cookie・クエリ文字列は転送されない
    # origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3" # Managed-AllViewer

    # 設定内容: レスポンスヘッダーポリシーID
    # 省略時: カスタムヘッダー追加なし
    # response_headers_policy_id = "60669652-455b-4ae9-85a4-c4c02393f86c" # Managed-SecurityHeadersPolicy

    # 設定内容: フィールドレベル暗号化ID
    # 省略時: フィールドレベル暗号化未使用
    # field_level_encryption_id = aws_cloudfront_field_level_encryption_config.example.id

    # 設定内容: コンテンツの自動圧縮（gzip, brotli）
    # 省略時: 自動判定
    # compress = true

    # 設定内容: リアルタイムログ設定ARN
    # 省略時: リアルタイムログ未使用
    # realtime_log_config_arn = aws_cloudfront_realtime_log_config.example.arn

    #-----------------------------------------------------------------------
    # 許可メソッド設定
    #-----------------------------------------------------------------------
    # allowed_methods {
    #   # 設定内容: CloudFrontが処理するHTTPメソッド
    #   # 設定可能な値: GET、HEAD、OPTIONS、PUT、POST、PATCH、DELETE
    #   # 省略時: 設定不可（必須）
    #   items = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    #
    #   # 設定内容: CloudFrontがキャッシュするHTTPメソッド
    #   # 省略時: 設定不可（必須）
    #   cached_methods = ["GET", "HEAD", "OPTIONS"]
    # }

    #-----------------------------------------------------------------------
    # Lambda@Edge / CloudFront Functions 関連付け
    #-----------------------------------------------------------------------
    # function_association {
    #   # 設定内容: イベントタイプ
    #   # 設定可能な値: viewer-request、viewer-response
    #   # 省略時: 設定不可（必須）
    #   event_type = "viewer-request"
    #
    #   # 設定内容: CloudFront Function の ARN
    #   # 省略時: 設定不可（必須）
    #   function_arn = aws_cloudfront_function.example.arn
    # }

    # lambda_function_association {
    #   # 設定内容: イベントタイプ
    #   # 設定可能な値: viewer-request、viewer-response、origin-request、origin-response
    #   # 省略時: 設定不可（必須）
    #   event_type = "viewer-request"
    #
    #   # 設定内容: Lambda 関数の ARN（バージョン含む）
    #   # 省略時: 設定不可（必須）
    #   lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:my-function:1"
    #
    #   # 設定内容: リクエストボディを Lambda に含めるか
    #   # 省略時: false
    #   # include_body = false
    # }

    #-----------------------------------------------------------------------
    # 署名付きURL / 署名付きCookie 設定
    #-----------------------------------------------------------------------
    # trusted_key_groups {
    #   # 設定内容: 署名付きURL/Cookieの有効化
    #   # 省略時: 自動判定
    #   # enabled = true
    #
    #   # 設定内容: 信頼するキーグループIDのリスト
    #   # 省略時: 署名検証なし
    #   # items = [aws_cloudfront_key_group.example.id]
    # }
  }

  #-----------------------------------------------------------------------
  # 追加キャッシュビヘイビア設定（パスパターン別設定）
  #-----------------------------------------------------------------------
  # cache_behavior {
  #   # 設定内容: パスパターン（例: /api/*, /static/*）
  #   # 省略時: 設定不可（必須）
  #   path_pattern = "/api/*"
  #
  #   # 設定内容: リクエスト転送先のオリジンID
  #   # 省略時: 設定不可（必須）
  #   target_origin_id = "api-origin"
  #
  #   # 設定内容: ビューワープロトコルポリシー
  #   # 設定可能な値: allow-all、https-only、redirect-to-https
  #   # 省略時: 設定不可（必須）
  #   viewer_protocol_policy = "https-only"
  #
  #   # 設定内容: キャッシュポリシーID
  #   # 省略時: レガシーキャッシュ設定を使用
  #   # cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # Managed-CachingDisabled
  #
  #   # 設定内容: オリジンリクエストポリシーID
  #   # 省略時: キャッシュキー以外は転送されない
  #   # origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
  #
  #   # 設定内容: レスポンスヘッダーポリシーID
  #   # 省略時: カスタムヘッダー追加なし
  #   # response_headers_policy_id = "60669652-455b-4ae9-85a4-c4c02393f86c"
  #
  #   # 設定内容: コンテンツの自動圧縮
  #   # 省略時: 自動判定
  #   # compress = true
  #
  #   # 設定内容: フィールドレベル暗号化ID
  #   # 省略時: フィールドレベル暗号化未使用
  #   # field_level_encryption_id = aws_cloudfront_field_level_encryption_config.example.id
  #
  #   # 設定内容: リアルタイムログ設定ARN
  #   # 省略時: リアルタイムログ未使用
  #   # realtime_log_config_arn = aws_cloudfront_realtime_log_config.example.arn
  #
  #   # allowed_methods {
  #   #   items          = ["GET", "HEAD", "OPTIONS"]
  #   #   cached_methods = ["GET", "HEAD"]
  #   # }
  #
  #   # function_association {
  #   #   event_type   = "viewer-request"
  #   #   function_arn = aws_cloudfront_function.api.arn
  #   # }
  #
  #   # lambda_function_association {
  #   #   event_type         = "origin-request"
  #   #   lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:api-auth:1"
  #   # }
  #
  #   # trusted_key_groups {
  #   #   enabled = true
  #   #   items   = [aws_cloudfront_key_group.example.id]
  #   # }
  # }

  #-----------------------------------------------------------------------
  # 地理的制限設定
  #-----------------------------------------------------------------------
  # 設定内容: コンテンツアクセスの地理的制限
  # 省略時: 設定不可（必須）
  restrictions {
    geo_restriction {
      # 設定内容: 制限タイプ
      # 設定可能な値: none（制限なし）、whitelist（許可リスト）、blacklist（拒否リスト）
      # 省略時: 設定不可（必須）
      restriction_type = "none"

      # 設定内容: 国コードのリスト（ISO 3166-1 alpha-2）
      # 省略時: 空リスト
      # items = ["US", "CA", "GB"]
    }
  }

  #-----------------------------------------------------------------------
  # SSL/TLS 証明書設定
  #-----------------------------------------------------------------------
  # 設定内容: ビューワー接続用のSSL/TLS証明書設定
  # 省略時: CloudFront デフォルト証明書を使用
  # viewer_certificate {
  #   # 設定内容: CloudFront デフォルト証明書の使用
  #   # 省略時: false（カスタムSSL証明書を使用する場合）
  #   # cloudfront_default_certificate = false
  #
  #   # 設定内容: ACM 証明書 ARN（us-east-1 リージョンのみ）
  #   # 省略時: CloudFront デフォルト証明書を使用
  #   # acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/xxxxx"
  #
  #   # 設定内容: SSL サポート方法
  #   # 設定可能な値: sni-only、vip（専用IP、追加課金あり）
  #   # 省略時: sni-only
  #   # ssl_support_method = "sni-only"
  #
  #   # 設定内容: 最小TLSプロトコルバージョン
  #   # 設定可能な値: TLSv1、TLSv1_2016、TLSv1.1_2016、TLSv1.2_2018、TLSv1.2_2019、TLSv1.2_2021
  #   # 省略時: TLSv1（非推奨）
  #   # minimum_protocol_version = "TLSv1.2_2021"
  # }

  #-----------------------------------------------------------------------
  # エラーレスポンスのカスタマイズ
  #-----------------------------------------------------------------------
  # custom_error_response {
  #   # 設定内容: オリジンから返されるエラーコード
  #   # 省略時: 設定不可（必須）
  #   error_code = 404
  #
  #   # 設定内容: エラーキャッシュの最小TTL（秒）
  #   # 設定可能な値: 0〜31536000
  #   # 省略時: 300
  #   # error_caching_min_ttl = 300
  #
  #   # 設定内容: ビューワーに返すHTTPステータスコード
  #   # 省略時: オリジンのエラーコードをそのまま返す
  #   # response_code = "200"
  #
  #   # 設定内容: カスタムエラーページのパス
  #   # 省略時: オリジンのレスポンスをそのまま返す
  #   # response_page_path = "/errors/404.html"
  # }

  #-----------------------------------------------------------------------
  # その他の設定
  #-----------------------------------------------------------------------
  # 設定内容: デフォルトルートオブジェクト（例: index.html）
  # 省略時: ルートURLへのアクセス時にオリジンへそのままリクエスト
  default_root_object = ""

  # 設定内容: サポートするHTTPバージョン
  # 設定可能な値: http1.1、http2、http2and3、http3
  # 省略時: http2
  http_version = "http2"

  # 設定内容: AWS WAF WebACL の ID
  # 省略時: WAF未適用
  web_acl_id = ""

  #-----------------------------------------------------------------------
  # テナント設定（マルチテナント固有）
  #-----------------------------------------------------------------------
  # 設定内容: テナント固有のパラメータ定義
  # 省略時: テナントパラメータ未使用
  # tenant_config {
  #   parameter_definition {
  #     # 設定内容: パラメータ名
  #     # 省略時: 設定不可（必須）
  #     name = "tenant_id"
  #
  #     definition {
  #       string_schema {
  #         # 設定内容: パラメータの必須フラグ
  #         # 省略時: 設定不可（必須）
  #         required = true
  #
  #         # 設定内容: パラメータの説明コメント
  #         # 省略時: コメントなし
  #         # comment = "Tenant identifier for this distribution"
  #
  #         # 設定内容: デフォルト値
  #         # 省略時: デフォルト値なし
  #         # default_value = "default-tenant"
  #       }
  #     }
  #   }
  #
  #   parameter_definition {
  #     name = "origin_domain"
  #
  #     definition {
  #       string_schema {
  #         required      = true
  #         comment       = "Custom origin domain for tenant"
  #         # default_value = "tenant.example.com"
  #       }
  #     }
  #   }
  # }

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------
  # 設定内容: リソースに付与するタグ
  # 省略時: タグなし
  tags = {
    Name = "multi-tenant-distribution"
  }

  #-----------------------------------------------------------------------
  # アクティブな信頼キーグループ（読み取り専用）
  #-----------------------------------------------------------------------
  # 設定内容: 署名付きURL/Cookie検証に使用されるアクティブなキーグループ情報
  # 省略時: computed（自動計算）
  # active_trusted_key_groups {
  #   # 全て computed 属性
  #   # enabled: キーグループが有効かどうか
  #   # items: キーグループとキーペアID情報のリスト
  # }

  #-----------------------------------------------------------------------
  # タイムアウト設定
  #-----------------------------------------------------------------------
  # timeouts {
  #   # 設定内容: 作成タイムアウト（例: "30m"）
  #   # 省略時: デフォルトタイムアウト適用
  #   # create = "30m"
  #
  #   # 設定内容: 更新タイムアウト（例: "30m"）
  #   # 省略時: デフォルトタイムアウト適用
  #   # update = "30m"
  #
  #   # 設定内容: 削除タイムアウト（例: "30m"）
  #   # 省略時: デフォルトタイムアウト適用
  #   # delete = "30m"
  # }
}

#-----------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-----------------------------------------------------------------------
# このリソース作成後に参照可能な属性:
#
# - id: ディストリビューション ID
# - arn: ディストリビューション ARN
# - domain_name: CloudFront ドメイン名（例: d111111abcdef8.cloudfront.net）
# - status: ディストリビューションのステータス（Deployed など）
# - caller_reference: ディストリビューション作成時の一意識別子
# - etag: ディストリビューション設定の ETag
# - connection_mode: 接続モード
# - in_progress_invalidation_batches: 進行中の無効化バッチ数
# - last_modified_time: 最終更新日時
# - tags_all: プロバイダーデフォルトタグを含む全タグ
# - active_trusted_key_groups: 署名付きURL/Cookie検証に使用されるアクティブキーグループ情報（computed）
