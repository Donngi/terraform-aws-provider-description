#-------
# Provider Version: 6.36.0
# リソース: aws_cloudfront_multitenant_distribution
# Generated: 2026-03-18
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.36.0/docs/resources/cloudfront_multitenant_distribution
#
# NOTE:
#   このテンプレートはAWS Provider v6.36.0のスキーマから自動生成されています。
#   実際の使用時は、必須パラメータとユースケースに応じたオプション設定を選択してください。
#
#-------
# 概要:
#   Amazon CloudFrontのマルチテナントディストリビューションを作成・管理するリソースです。
#   マルチテナントディストリビューションは、SaaS等のマルチテナントアプリケーション向けに
#   設計された特殊なCloudFrontディストリビューションで、テナントごとのパラメータ定義を
#   サポートします。
#
# 主な用途:
#   - マルチテナントSaaSアプリケーションのコンテンツ配信
#   - テナントごとにカスタマイズ可能なCDN設定の一元管理
#   - テナント固有のオリジンドメインやパラメータの定義
#   - 複数テナントで共有するCloudFront設定のテンプレート化
#
# 料金への影響:
#   - データ転送量に応じた従量課金
#   - HTTPSリクエスト数による課金
#   - テナント数に応じたディストリビューション管理コスト
#   - Lambda@Edge / CloudFront Functions実行による追加料金
#
#-------

resource "aws_cloudfront_multitenant_distribution" "example" {
  #-------
  # 基本設定
  #-------

  # 設定内容: ディストリビューションの有効化状態
  # 設定可能な値: true（有効）、false（無効）
  # ※ 必須パラメータ
  enabled = true

  # 設定内容: ディストリビューションの説明コメント
  # ※ 必須パラメータ
  comment = "Multi-tenant CloudFront distribution"

  # 設定内容: デフォルトルートオブジェクトのパス
  # 用途: ルートURL（/）へのアクセス時に返すオブジェクト
  # default_root_object = "index.html"

  # 設定内容: サポートするHTTPプロトコルのバージョン
  # 設定可能な値: "http1.1", "http2", "http2and3", "http3"
  # 省略時: "http2"
  http_version = "http2"

  #-------
  # オリジン設定
  #-------

  origin {
    # 設定内容: オリジンサーバーのドメイン名
    # 用途: S3バケット名、ELBのDNS名、カスタムオリジンのドメイン名など
    # ※ 必須パラメータ
    domain_name = "example.com"

    # 設定内容: オリジンの一意な識別子
    # 用途: キャッシュビヘイビアでオリジンを参照する際に使用
    # ※ 必須パラメータ
    id = "example-origin"

    # 設定内容: オリジンパス
    # 用途: ドメイン名の後に追加するパス（例: "/production"）
    # origin_path = "/production"

    # 設定内容: オリジンアクセスコントロールのID
    # 用途: S3オリジンへのアクセス制御（OACを使用）
    # origin_access_control_id = "E1A2B3C4D5E6F7"

    # 設定内容: オリジンへの接続試行回数
    # 設定可能な値: 1～3
    # 省略時: 3
    # connection_attempts = 3

    # 設定内容: オリジンへの接続タイムアウト（秒）
    # 設定可能な値: 1～10
    # 省略時: 10
    # connection_timeout = 10

    # 設定内容: レスポンス完了タイムアウト（秒）
    # 省略時: 30
    # response_completion_timeout = 30

    # カスタムヘッダー設定
    # custom_header {
    #   # 設定内容: カスタムヘッダー名
    #   # ※ 必須パラメータ
    #   header_name = "X-Custom-Header"
    #
    #   # 設定内容: カスタムヘッダー値
    #   # ※ 必須パラメータ
    #   header_value = "CustomValue"
    # }

    # カスタムオリジン設定（S3以外のオリジンを使用する場合）
    custom_origin_config {
      # 設定内容: HTTPポート番号
      # ※ 必須パラメータ
      http_port = 80

      # 設定内容: HTTPSポート番号
      # ※ 必須パラメータ
      https_port = 443

      # 設定内容: オリジンプロトコルポリシー
      # 設定可能な値: "http-only", "https-only", "match-viewer"
      # ※ 必須パラメータ
      origin_protocol_policy = "https-only"

      # 設定内容: オリジンで使用可能なSSL/TLSプロトコル
      # 設定可能な値: "TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"
      # ※ 必須パラメータ
      origin_ssl_protocols = ["TLSv1.2"]

      # 設定内容: IPアドレスタイプ
      # 設定可能な値: "ipv4", "dualstack"
      # ip_address_type = "ipv4"

      # 設定内容: オリジンキープアライブタイムアウト（秒）
      # 省略時: 5
      # origin_keepalive_timeout = 5

      # 設定内容: オリジン読み取りタイムアウト（秒）
      # 省略時: 30
      # origin_read_timeout = 30
    }

    # Origin Shield設定
    # origin_shield {
    #   # 設定内容: Origin Shieldの有効化
    #   # ※ 必須パラメータ
    #   enabled = true
    #
    #   # 設定内容: Origin Shieldのリージョン
    #   # 用途: enabledがtrueの場合に必須
    #   # origin_shield_region = "us-east-1"
    # }

    # VPCオリジン設定
    # vpc_origin_config {
    #   # 設定内容: VPCオリジンのID
    #   # ※ 必須パラメータ
    #   vpc_origin_id = "vpc-origin-123456"
    #
    #   # 設定内容: オリジンキープアライブタイムアウト（秒）
    #   # 省略時: 5
    #   # origin_keepalive_timeout = 5
    #
    #   # 設定内容: オリジン読み取りタイムアウト（秒）
    #   # 省略時: 30
    #   # origin_read_timeout = 30
    # }
  }

  #-------
  # オリジングループ設定（フェイルオーバー用）
  #-------

  # origin_group {
  #   # 設定内容: オリジングループの一意な識別子
  #   # ※ 必須パラメータ
  #   id = "groupOrigin"
  #
  #   # フェイルオーバー基準設定
  #   failover_criteria {
  #     # 設定内容: フェイルオーバーをトリガーするHTTPステータスコード
  #     # ※ 必須パラメータ
  #     status_codes = [500, 502, 503, 504]
  #   }
  #
  #   # メンバー設定（プライマリとセカンダリの2つが必須）
  #   member {
  #     # 設定内容: プライマリオリジンのID
  #     # ※ 必須パラメータ
  #     origin_id = "primary-origin"
  #   }
  #
  #   member {
  #     # 設定内容: セカンダリオリジンのID
  #     # ※ 必須パラメータ
  #     origin_id = "secondary-origin"
  #   }
  # }

  #-------
  # デフォルトキャッシュビヘイビア設定
  #-------

  default_cache_behavior {
    # 設定内容: ターゲットオリジンのID
    # 用途: リクエストを転送するオリジンの指定
    # ※ 必須パラメータ
    target_origin_id = "example-origin"

    # 設定内容: ビューワープロトコルポリシー
    # 設定可能な値:
    #   - "allow-all": HTTP/HTTPS両方を許可
    #   - "https-only": HTTPSのみ許可
    #   - "redirect-to-https": HTTPをHTTPSにリダイレクト
    # ※ 必須パラメータ
    viewer_protocol_policy = "redirect-to-https"

    # 許可メソッド設定
    allowed_methods {
      # 設定内容: このビヘイビアが処理するHTTPメソッド
      # ※ 必須パラメータ
      items = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]

      # 設定内容: キャッシュ対象のHTTPメソッド
      # ※ 必須パラメータ
      cached_methods = ["GET", "HEAD"]
    }

    # 設定内容: キャッシュポリシーID
    # 用途: AWS管理ポリシーまたはカスタムキャッシュポリシーのID
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    # 設定内容: オリジンリクエストポリシーID
    # 用途: オリジンへ転送するヘッダー・クッキー・クエリ文字列の制御
    # origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"

    # 設定内容: レスポンスヘッダーポリシーID
    # 用途: CloudFrontがクライアントに返すHTTPヘッダーの制御
    # response_headers_policy_id = "5cc3b908-e619-4b99-88e5-2cf7f45965bd"

    # 設定内容: 圧縮の有効化
    # 用途: テキストベースのコンテンツの自動圧縮（gzip/brotli）
    # compress = true

    # 設定内容: Field Level EncryptionのID
    # 用途: 特定のフィールドの暗号化設定
    # field_level_encryption_id = ""

    # 設定内容: リアルタイムログ設定のARN
    # 用途: リアルタイムでログをKinesis Data Streamsに送信
    # realtime_log_config_arn = "arn:aws:cloudfront::123456789012:realtime-log-config/ExampleConfig"

    # CloudFront Functions関連付け
    # function_association {
    #   # 設定内容: 関数を実行するイベントタイプ
    #   # 設定可能な値: "viewer-request", "origin-request", "viewer-response", "origin-response"
    #   # ※ 必須パラメータ
    #   event_type = "viewer-request"
    #
    #   # 設定内容: CloudFront FunctionのARN
    #   # ※ 必須パラメータ
    #   function_arn = "arn:aws:cloudfront::123456789012:function/ExampleFunction"
    # }

    # Lambda@Edge関連付け
    # lambda_function_association {
    #   # 設定内容: Lambda関数を実行するイベントタイプ
    #   # 設定可能な値: "viewer-request", "origin-request", "viewer-response", "origin-response"
    #   # ※ 必須パラメータ
    #   event_type = "viewer-request"
    #
    #   # 設定内容: Lambda関数のARN（バージョン番号を含む）
    #   # ※ 必須パラメータ
    #   lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:ExampleFunction:1"
    #
    #   # 設定内容: リクエストボディをLambda関数に含めるかどうか
    #   # 省略時: false
    #   # include_body = false
    # }

    # 信頼されたキーグループ設定
    # trusted_key_groups {
    #   # 設定内容: 信頼されたキーグループの有効化
    #   # enabled = true
    #
    #   # 設定内容: キーグループIDのリスト
    #   # items = ["key-group-id-1"]
    # }
  }

  #-------
  # 順序付きキャッシュビヘイビア設定
  #-------

  # cache_behavior {
  #   # 設定内容: パスパターン
  #   # 用途: このビヘイビアを適用するURLパスパターン
  #   # ※ 必須パラメータ
  #   path_pattern = "/images/*"
  #
  #   # 設定内容: ターゲットオリジンのID
  #   # ※ 必須パラメータ
  #   target_origin_id = "example-origin"
  #
  #   # 設定内容: ビューワープロトコルポリシー
  #   # ※ 必須パラメータ
  #   viewer_protocol_policy = "redirect-to-https"
  #
  #   # 許可メソッド設定
  #   allowed_methods {
  #     items          = ["GET", "HEAD"]
  #     cached_methods = ["GET", "HEAD"]
  #   }
  #
  #   # 設定内容: キャッシュポリシーID
  #   # cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  #
  #   # 設定内容: 圧縮の有効化
  #   # compress = true
  #
  #   # 設定内容: Field Level EncryptionのID
  #   # field_level_encryption_id = ""
  #
  #   # 設定内容: オリジンリクエストポリシーID
  #   # origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  #
  #   # 設定内容: リアルタイムログ設定のARN
  #   # realtime_log_config_arn = "arn:aws:cloudfront::123456789012:realtime-log-config/ExampleConfig"
  #
  #   # 設定内容: レスポンスヘッダーポリシーID
  #   # response_headers_policy_id = "5cc3b908-e619-4b99-88e5-2cf7f45965bd"
  #
  #   # function_association {
  #   #   event_type   = "viewer-request"
  #   #   function_arn = "arn:aws:cloudfront::123456789012:function/ExampleFunction"
  #   # }
  #
  #   # lambda_function_association {
  #   #   event_type         = "viewer-request"
  #   #   lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:ExampleFunction:1"
  #   #   # include_body = false
  #   # }
  #
  #   # trusted_key_groups {
  #   #   enabled = true
  #   #   items   = ["key-group-id-1"]
  #   # }
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
  #   response_code = "200"
  #
  #   # 設定内容: エラーレスポンスとして返すページのパス
  #   response_page_path = "/error-pages/404.html"
  #
  #   # 設定内容: エラーレスポンスのキャッシュ最小TTL（秒）
  #   # error_caching_min_ttl = 300
  # }

  #-------
  # 地理的制限設定
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
      # items = ["US", "JP"]
    }
  }

  #-------
  # SSL/TLS証明書設定
  #-------

  viewer_certificate {
    # 設定内容: CloudFrontのデフォルト証明書を使用
    # 用途: *.cloudfront.netドメインを使用する場合
    # 注意: acm_certificate_arnと同時に使用不可
    cloudfront_default_certificate = true

    # 設定内容: ACM証明書のARN
    # 用途: カスタムドメイン用のSSL/TLS証明書（us-east-1リージョン必須）
    # acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abc123"

    # 設定内容: サポートする最小TLSプロトコルバージョン
    # 設定可能な値: "TLSv1", "TLSv1_2016", "TLSv1.1_2016", "TLSv1.2_2018", "TLSv1.2_2019", "TLSv1.2_2021"
    # 省略時: "TLSv1"
    # minimum_protocol_version = "TLSv1.2_2021"

    # 設定内容: SSLサポート方法
    # 設定可能な値: "sni-only", "vip"
    # 注意: acm_certificate_arn指定時は必須。"vip"は高額な追加料金が発生
    # ssl_support_method = "sni-only"
  }

  #-------
  # テナント設定
  #-------

  tenant_config {
    parameter_definition {
      # 設定内容: パラメータ名
      # 用途: テナントごとにカスタマイズ可能なパラメータの識別子
      # ※ 必須パラメータ
      name = "origin_domain"

      definition {
        string_schema {
          # 設定内容: パラメータが必須かどうか
          # 設定可能な値: true（必須）、false（任意）
          # ※ 必須パラメータ
          required = true

          # 設定内容: パラメータの説明コメント
          # comment = "Origin domain parameter for tenants"

          # 設定内容: パラメータのデフォルト値
          # default_value = "default.example.com"
        }
      }
    }
  }

  #-------
  # WAF設定
  #-------

  # 設定内容: AWS WAF Web ACLのID
  # 用途: CloudFrontディストリビューションへのWAF適用
  # web_acl_id = "arn:aws:wafv2:us-east-1:123456789012:global/webacl/ExampleWebACL/a1234567"

  #-------
  # タグ設定
  #-------

  tags = {
    Name        = "example-multitenant-distribution"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  #-------
  # アクティブな信頼キーグループ（読み取り専用）
  #-------
  # active_trusted_key_groups は computed 属性のため、設定は不要です。
  # 署名付きURL/Cookie検証に使用されるキーグループ情報が自動的に設定されます。

  #-------
  # タイムアウト設定
  #-------

  # timeouts {
  #   # 設定内容: 作成時のタイムアウト
  #   # 省略時: プロバイダーのデフォルト値
  #   # create = "30m"
  #
  #   # 設定内容: 更新時のタイムアウト
  #   # update = "30m"
  #
  #   # 設定内容: 削除時のタイムアウト
  #   # delete = "30m"
  # }
}

#-------
# Attributes Reference（参照可能な属性）
#-------
# このリソースでは以下の属性が参照可能です:
#
# - id: ディストリビューションのID
# - arn: ディストリビューションのARN
# - caller_reference: ディストリビューションの呼び出し参照
# - connection_mode: 接続モード（マルチテナントでは常に"tenant-only"）
# - domain_name: CloudFrontのドメイン名（例: d1234abcd.cloudfront.net）
# - etag: ディストリビューションの現在のバージョンを識別するETag値
# - in_progress_invalidation_batches: 進行中の無効化バッチ数
# - last_modified_time: ディストリビューションの最終更新日時
# - status: ディストリビューションのステータス（InProgress, Deployed等）
# - tags_all: プロバイダーのdefault_tagsを含む全タグのマップ
# - active_trusted_key_groups: 署名付きURL/クッキー検証用の信頼されたキーグループ情報
#
#-------
