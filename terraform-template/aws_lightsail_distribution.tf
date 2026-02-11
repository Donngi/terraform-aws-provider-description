################################################################################
# AWS Lightsail Distribution
################################################################################
# Manages a Lightsail content delivery network (CDN) distribution.
# Use this resource to cache content at edge locations and reduce latency
# for users accessing your content.
#
# Lightsail Distribution は、Lightsail バケット、インスタンス、またはロードバランサーを
# オリジンとして使用でき、グローバルなコンテンツ配信を実現します。
#
# AWS公式ドキュメント:
#   - Lightsail Distribution 概要: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-content-delivery-network-distributions.html
#   - CDN の仕組み: https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-content-delivery-network.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_distribution
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
################################################################################

resource "aws_lightsail_distribution" "example" {
  ################################################################################
  # 基本設定 (Required)
  ################################################################################

  # name (Required)
  # 設定内容: ディストリビューションの名前を指定します。
  # 設定可能な値: 2〜255 文字の英数字、アンダースコア、ハイフン、ピリオド
  # 注意: 名前は作成後に変更できません（リソース再作成が必要）
  name = "example-distribution"

  # bundle_id (Required)
  # 設定内容: ディストリビューションで使用するバンドル ID を指定します。
  # 設定可能な値:
  #   - "small_1_0": 50 GB データ転送/月、125 リクエスト/秒
  #   - "medium_1_0": 125 GB データ転送/月、250 リクエスト/秒
  #   - "large_1_0": 250 GB データ転送/月、500 リクエスト/秒
  # 注意: バンドル変更は追加料金が発生する場合があります
  # 参考: https://aws.amazon.com/lightsail/pricing/
  bundle_id = "small_1_0"

  ################################################################################
  # オリジン設定 (Required)
  ################################################################################

  # origin (Required)
  # 設定内容: ディストリビューションのオリジンリソースを指定します。
  # 注意: Lightsail インスタンス、バケット、またはロードバランサーを指定できます
  origin {
    # name (Required)
    # 設定内容: オリジンリソースの名前を指定します。
    # 設定可能な値:
    #   - Lightsail インスタンス名（静的 IP がアタッチされている必要があります）
    #   - Lightsail バケット名
    #   - Lightsail ロードバランサー名（少なくとも 1 つのインスタンスがアタッチされている必要があります）
    name = "example-bucket"

    # region_name (Required)
    # 設定内容: オリジンリソースが存在する AWS リージョン名を指定します。
    # 設定可能な値: AWS リージョンコード（例: ap-northeast-1, us-east-1）
    region_name = "ap-northeast-1"

    # protocol_policy (Optional)
    # 設定内容: ディストリビューションがオリジンとの接続を確立する際に使用するプロトコルを指定します。
    # 設定可能な値:
    #   - "http-only": HTTP のみ使用
    #   - "https-only": HTTPS のみ使用（推奨）
    # 省略時: AWS が自動的に決定します
    # 注意: セキュリティのため https-only の使用を推奨します
    protocol_policy = null
  }

  ################################################################################
  # デフォルトキャッシュ動作設定 (Required)
  ################################################################################

  # default_cache_behavior (Required)
  # 設定内容: ディストリビューションのデフォルトキャッシュ動作を指定します。
  # 注意: パスベースのキャッシュ動作で一致しないすべてのリクエストに適用されます
  default_cache_behavior {
    # behavior (Required)
    # 設定内容: デフォルトのキャッシュ動作を指定します。
    # 設定可能な値:
    #   - "cache": コンテンツをキャッシュします（静的コンテンツ推奨）
    #   - "dont-cache": コンテンツをキャッシュしません（動的コンテンツ推奨）
    # 注意: キャッシュすることで CDN のパフォーマンスメリットが最大化されます
    behavior = "cache"
  }

  ################################################################################
  # オプション設定
  ################################################################################

  # is_enabled (Optional)
  # 設定内容: ディストリビューションを有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): ディストリビューションを有効化
  #   - false: ディストリビューションを無効化（一時停止）
  # 注意: 無効化しても料金は発生します
  is_enabled = true

  # ip_address_type (Optional)
  # 設定内容: ディストリビューションで使用する IP アドレスタイプを指定します。
  # 設定可能な値:
  #   - "dualstack" (デフォルト): IPv4 と IPv6 の両方をサポート
  #   - "ipv4": IPv4 アドレスのみ
  # 注意: デュアルスタックは最新のクライアントで推奨されます
  ip_address_type = "dualstack"

  # certificate_name (Optional)
  # 設定内容: ディストリビューションにアタッチする SSL/TLS 証明書の名前を指定します。
  # 設定可能な値: Lightsail で作成した証明書の名前
  # 注意: カスタムドメインを使用する場合は証明書が必要です
  # 関連リソース: aws_lightsail_certificate
  certificate_name = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: ディストリビューション自体はグローバルリソースですが、管理リージョンを指定します
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  ################################################################################
  # パスベースキャッシュ動作設定 (Optional)
  ################################################################################

  # cache_behavior (Optional)
  # 設定内容: パスごとのキャッシュ動作を指定します。
  # 注意: 複数の cache_behavior ブロックを指定できます
  # ユースケース:
  #   - 画像ファイルは長期間キャッシュ
  #   - API エンドポイントはキャッシュしない
  #   - 静的アセットは積極的にキャッシュ
  cache_behavior {
    # path (Required)
    # 設定内容: キャッシュするディレクトリまたはファイルへのパスを指定します。
    # 設定可能な値:
    #   - ワイルドカードディレクトリ: "path/to/assets/*"
    #   - ファイルタイプ: "*.html", "*.jpg", "*.js"
    #   - 特定のパス: "/api/*"
    # 注意: ディレクトリとファイルパスは大文字小文字を区別します
    path = "*.jpg"

    # behavior (Required)
    # 設定内容: 指定されたパスのキャッシュ動作を指定します。
    # 設定可能な値:
    #   - "cache": コンテンツをキャッシュします
    #   - "dont-cache": コンテンツをキャッシュしません
    behavior = "cache"
  }

  ################################################################################
  # キャッシュ動作詳細設定 (Optional)
  ################################################################################

  # cache_behavior_settings (Optional)
  # 設定内容: キャッシュ動作の詳細設定を指定します。
  # 注意: default_cache_behavior と cache_behavior の両方に適用されます
  cache_behavior_settings {
    # allowed_http_methods (Optional)
    # 設定内容: 処理してオリジンに転送する HTTP メソッドを指定します。
    # 設定可能な値:
    #   - "GET,HEAD": 読み取り専用メソッド（デフォルト）
    #   - "GET,HEAD,OPTIONS": オプションメソッド追加
    #   - "GET,HEAD,OPTIONS,PUT,PATCH,POST,DELETE": すべてのメソッド
    # 注意: 書き込みメソッドを許可する場合は慎重に検討してください
    allowed_http_methods = "GET,HEAD,OPTIONS,PUT,PATCH,POST,DELETE"

    # cached_http_methods (Optional)
    # 設定内容: ディストリビューションがキャッシュする HTTP メソッドレスポンスを指定します。
    # 設定可能な値:
    #   - "GET,HEAD": GET と HEAD のレスポンスのみキャッシュ（推奨）
    #   - "GET,HEAD,OPTIONS": OPTIONS のレスポンスもキャッシュ
    # 注意: 通常は GET と HEAD のみキャッシュすることを推奨します
    cached_http_methods = "GET,HEAD"

    # default_ttl (Optional)
    # 設定内容: オブジェクトがディストリビューションのキャッシュに残るデフォルト時間（秒）を指定します。
    # 設定可能な値: 0〜31536000 秒（0 秒〜1 年）
    # 省略時: 86400 秒（1 日）
    # 注意: オリジンがキャッシュヘッダーを返す場合、そちらが優先されます
    # パフォーマンス考慮: 高い値はキャッシュヒット率を向上させますが、コンテンツの鮮度が低下します
    default_ttl = 86400

    # minimum_ttl (Optional)
    # 設定内容: オブジェクトがディストリビューションのキャッシュに残る最小時間（秒）を指定します。
    # 設定可能な値: 0〜31536000 秒（0 秒〜1 年）
    # 省略時: 0 秒
    # 注意: この値より短い Cache-Control ヘッダーは無視されます
    minimum_ttl = 0

    # maximum_ttl (Optional)
    # 設定内容: オブジェクトがディストリビューションのキャッシュに残る最大時間（秒）を指定します。
    # 設定可能な値: 0〜31536000 秒（0 秒〜1 年）
    # 省略時: 31536000 秒（1 年）
    # 注意: この値より長い Cache-Control ヘッダーは無視されます
    maximum_ttl = 31536000

    ############################################################################
    # クッキー転送設定 (Optional)
    ############################################################################

    # forwarded_cookies (Optional)
    # 設定内容: オリジンに転送するクッキーを指定します。
    # 注意: コンテンツは転送されたクッキーに基づいてキャッシュされます
    # パフォーマンス影響: クッキーを転送するとキャッシュキーが増加し、キャッシュ効率が低下します
    forwarded_cookies {
      # option (Optional)
      # 設定内容: ディストリビューションのオリジンに転送するクッキーを指定します。
      # 設定可能な値:
      #   - "none" (デフォルト): クッキーを転送しません
      #   - "allow-list": 指定したクッキーのみ転送
      #   - "all": すべてのクッキーを転送
      # 注意: "all" を使用するとキャッシュ効率が低下する可能性があります
      # 推奨: 必要最小限のクッキーのみ転送するため "allow-list" を使用
      option = "none"

      # cookies_allow_list (Optional)
      # 設定内容: ディストリビューションのオリジンに転送する特定のクッキーを指定します。
      # 設定可能な値: クッキー名のリスト
      # 注意: option が "allow-list" の場合のみ有効
      # 例: ["session-id", "user-preference", "auth-token"]
      cookies_allow_list = []
    }

    ############################################################################
    # ヘッダー転送設定 (Optional)
    ############################################################################

    # forwarded_headers (Optional)
    # 設定内容: オリジンに転送するヘッダーを指定します。
    # 注意: コンテンツは転送されたヘッダーに基づいてキャッシュされます
    # パフォーマンス影響: ヘッダーを転送するとキャッシュキーが増加し、キャッシュ効率が低下します
    forwarded_headers {
      # option (Optional)
      # 設定内容: ディストリビューションのオリジンに転送するヘッダーを指定します。
      # 設定可能な値:
      #   - "default" (デフォルト): CloudFront のデフォルトヘッダーセットを転送（推奨）
      #   - "allow-list": 指定したヘッダーのみ転送
      #   - "all": すべてのヘッダーを転送（キャッシュを無効化）
      # 注意: "all" を使用するとキャッシュが実質的に無効化されます
      # 推奨: "default" または必要なヘッダーのみの "allow-list" を使用
      option = "default"

      # headers_allow_list (Optional)
      # 設定内容: ディストリビューションのオリジンに転送する特定のヘッダーを指定します。
      # 設定可能な値: ヘッダー名のリスト
      # 注意: option が "allow-list" の場合のみ有効
      # 一般的な例:
      #   - ["Accept", "Accept-Language"]: 言語ベースのコンテンツネゴシエーション
      #   - ["Authorization"]: 認証が必要な API
      #   - ["CloudFront-Viewer-Country"]: 地理的ロケーションベースのコンテンツ
      headers_allow_list = []
    }

    ############################################################################
    # クエリ文字列転送設定 (Optional)
    ############################################################################

    # forwarded_query_strings (Optional)
    # 設定内容: オリジンに転送するクエリ文字列を指定します。
    # 注意: コンテンツは転送されたクエリ文字列に基づいてキャッシュされます
    # パフォーマンス影響: クエリ文字列を転送するとキャッシュキーが増加し、キャッシュ効率が低下します
    forwarded_query_strings {
      # option (Optional)
      # 設定内容: ディストリビューションがクエリ文字列に基づいて転送とキャッシュを行うかを指定します。
      # 設定可能な値:
      #   - false (デフォルト): クエリ文字列を転送しません
      #   - true: クエリ文字列を転送します
      # 注意: true を使用する場合、query_strings_allowed_list で特定のパラメータのみに限定することを推奨
      # ユースケース:
      #   - false: 静的コンテンツ（画像、CSS、JS）
      #   - true: 動的コンテンツ（検索結果、フィルタリング、ページネーション）
      option = false

      # query_strings_allowed_list (Optional)
      # 設定内容: ディストリビューションのオリジンに転送する特定のクエリ文字列を指定します。
      # 設定可能な値: クエリ文字列パラメータ名のリスト
      # 注意: option が true の場合に、特定のクエリ文字列のみに基づいてキャッシュする場合に使用
      # 例: ["page", "sort", "filter", "lang"]
      # 推奨: 必要なパラメータのみを指定してキャッシュ効率を維持
      query_strings_allowed_list = []
    }
  }

  ################################################################################
  # タグ設定 (Optional)
  ################################################################################

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  # ベストプラクティス:
  #   - Name: リソースの識別名
  #   - Environment: 環境（dev, staging, production）
  #   - ManagedBy: 管理ツール（terraform, cloudformation）
  #   - Owner: 所有者またはチーム
  #   - CostCenter: コストセンター
  tags = {
    Name        = "example-distribution"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

################################################################################
# Attributes Reference (読み取り専用属性)
################################################################################
# このリソースは以下の属性をエクスポートします:
#
# - id: ディストリビューションの ID（name と同じ）
#
# - arn: ディストリビューションの Amazon Resource Name (ARN)
#   フォーマット: arn:aws:lightsail:region:account-id:Distribution/distribution-id
#
# - alternative_domain_names: ディストリビューションの代替ドメイン名
#   カスタムドメインを設定している場合に使用されます
#
# - created_at: ディストリビューションが作成されたタイムスタンプ
#   フォーマット: RFC3339 形式（例: 2023-01-15T10:30:00Z）
#
# - domain_name: ディストリビューションの CloudFront ドメイン名
#   フォーマット: xxxxxxxxxxxxx.cloudfront.net
#   用途: DNS レコード設定、エンドポイントアクセスに使用
#
# - location: ディストリビューションのロケーション情報（AWS リージョンと AZ）
#   - availability_zone: アベイラビリティーゾーン（例: us-east-2a）
#   - region_name: AWS リージョン名（例: us-east-2）
#
# - origin_public_dns: オリジンのパブリック DNS 名
#   オリジンへの直接アクセス時に使用
#
# - origin[0].resource_type: オリジンリソースのタイプ
#   可能な値: Instance, Bucket, LoadBalancer
#
# - resource_type: Lightsail リソースタイプ
#   常に "Distribution" を返します
#
# - status: ディストリビューションの現在のステータス
#   可能な値:
#     - InProgress: デプロイ中
#     - Succeeded: デプロイ完了、正常動作中
#     - Failed: デプロイまたは更新失敗
#
# - support_code: AWS サポート用のコード
#   用途: AWS サポートへの問い合わせ時にこのコードを提供すると、
#        サポートチームが迅速に情報を検索できます
#
# - tags_all: すべてのタグのマップ
#   プロバイダーの default_tags 設定ブロックから継承されたタグを含む
################################################################################

################################################################################
# 出力例 (Outputs)
################################################################################

output "lightsail_distribution_id" {
  description = "ディストリビューションの ID"
  value       = aws_lightsail_distribution.example.id
}

output "lightsail_distribution_arn" {
  description = "ディストリビューションの ARN"
  value       = aws_lightsail_distribution.example.arn
}

output "lightsail_distribution_domain_name" {
  description = "ディストリビューションの CloudFront ドメイン名"
  value       = aws_lightsail_distribution.example.domain_name
}

output "lightsail_distribution_status" {
  description = "ディストリビューションのステータス"
  value       = aws_lightsail_distribution.example.status
}

output "lightsail_distribution_origin_public_dns" {
  description = "オリジンのパブリック DNS"
  value       = aws_lightsail_distribution.example.origin_public_dns
}

################################################################################
# 使用例とベストプラクティス
################################################################################

# 例1: Lightsail バケットをオリジンとするディストリビューション
# -----------------------------------------------------------------------------
# resource "aws_lightsail_bucket" "content" {
#   name      = "my-content-bucket"
#   bundle_id = "small_1_0"
# }
#
# resource "aws_lightsail_distribution" "bucket_cdn" {
#   name      = "bucket-distribution"
#   bundle_id = "small_1_0"
#
#   origin {
#     name        = aws_lightsail_bucket.content.name
#     region_name = aws_lightsail_bucket.content.region
#   }
#
#   default_cache_behavior {
#     behavior = "cache"
#   }
#
#   cache_behavior_settings {
#     allowed_http_methods = "GET,HEAD,OPTIONS,PUT,PATCH,POST,DELETE"
#     cached_http_methods  = "GET,HEAD"
#     default_ttl          = 86400
#     maximum_ttl          = 31536000
#     minimum_ttl          = 0
#
#     forwarded_cookies {
#       option = "none"
#     }
#
#     forwarded_headers {
#       option = "default"
#     }
#
#     forwarded_query_strings {
#       option = false
#     }
#   }
# }

# 例2: Lightsail インスタンスをオリジンとするディストリビューション
# -----------------------------------------------------------------------------
# data "aws_availability_zones" "available" {
#   state = "available"
#
#   filter {
#     name   = "opt-in-status"
#     values = ["opt-in-not-required"]
#   }
# }
#
# resource "aws_lightsail_static_ip" "web_ip" {
#   name = "web-static-ip"
# }
#
# resource "aws_lightsail_instance" "web" {
#   name              = "web-instance"
#   availability_zone = data.aws_availability_zones.available.names[0]
#   blueprint_id      = "amazon_linux_2"
#   bundle_id         = "micro_1_0"
# }
#
# resource "aws_lightsail_static_ip_attachment" "web" {
#   static_ip_name = aws_lightsail_static_ip.web_ip.name
#   instance_name  = aws_lightsail_instance.web.name
# }
#
# resource "aws_lightsail_distribution" "instance_cdn" {
#   name       = "instance-distribution"
#   bundle_id  = "small_1_0"
#   depends_on = [aws_lightsail_static_ip_attachment.web]
#
#   origin {
#     name        = aws_lightsail_instance.web.name
#     region_name = data.aws_availability_zones.available.id
#   }
#
#   default_cache_behavior {
#     behavior = "cache"
#   }
# }

# 例3: ロードバランサーをオリジンとするディストリビューション
# -----------------------------------------------------------------------------
# resource "aws_lightsail_lb" "app" {
#   name              = "app-load-balancer"
#   health_check_path = "/"
#   instance_port     = "80"
# }
#
# resource "aws_lightsail_instance" "app" {
#   name              = "app-instance"
#   availability_zone = data.aws_availability_zones.available.names[0]
#   blueprint_id      = "amazon_linux_2"
#   bundle_id         = "nano_3_0"
# }
#
# resource "aws_lightsail_lb_attachment" "app" {
#   lb_name       = aws_lightsail_lb.app.name
#   instance_name = aws_lightsail_instance.app.name
# }
#
# resource "aws_lightsail_distribution" "lb_cdn" {
#   name       = "lb-distribution"
#   bundle_id  = "small_1_0"
#   depends_on = [aws_lightsail_lb_attachment.app]
#
#   origin {
#     name        = aws_lightsail_lb.app.name
#     region_name = data.aws_availability_zones.available.id
#   }
#
#   default_cache_behavior {
#     behavior = "cache"
#   }
# }

# 例4: 複数のキャッシュ動作を持つディストリビューション
# -----------------------------------------------------------------------------
# resource "aws_lightsail_distribution" "multi_behavior" {
#   name      = "multi-behavior-distribution"
#   bundle_id = "small_1_0"
#
#   origin {
#     name        = aws_lightsail_bucket.content.name
#     region_name = aws_lightsail_bucket.content.region
#   }
#
#   default_cache_behavior {
#     behavior = "cache"
#   }
#
#   # API エンドポイントはキャッシュしない
#   cache_behavior {
#     path     = "/api/*"
#     behavior = "dont-cache"
#   }
#
#   # 画像ファイルはキャッシュ
#   cache_behavior {
#     path     = "*.jpg"
#     behavior = "cache"
#   }
#
#   cache_behavior {
#     path     = "*.png"
#     behavior = "cache"
#   }
#
#   # 静的アセットはキャッシュ
#   cache_behavior {
#     path     = "/static/*"
#     behavior = "cache"
#   }
#
#   cache_behavior_settings {
#     allowed_http_methods = "GET,HEAD,OPTIONS"
#     cached_http_methods  = "GET,HEAD"
#     default_ttl          = 86400
#     maximum_ttl          = 31536000
#     minimum_ttl          = 0
#
#     forwarded_cookies {
#       option = "none"
#     }
#
#     forwarded_headers {
#       option = "default"
#     }
#
#     forwarded_query_strings {
#       option = false
#     }
#   }
# }

# 例5: カスタムドメインと証明書を使用するディストリビューション
# -----------------------------------------------------------------------------
# resource "aws_lightsail_distribution" "custom_domain" {
#   name             = "custom-domain-distribution"
#   bundle_id        = "medium_1_0"
#   certificate_name = "my-certificate"
#
#   origin {
#     name            = aws_lightsail_bucket.content.name
#     region_name     = aws_lightsail_bucket.content.region
#     protocol_policy = "https-only"
#   }
#
#   default_cache_behavior {
#     behavior = "cache"
#   }
#
#   cache_behavior_settings {
#     allowed_http_methods = "GET,HEAD"
#     cached_http_methods  = "GET,HEAD"
#     default_ttl          = 3600
#
#     forwarded_cookies {
#       option = "none"
#     }
#
#     forwarded_headers {
#       option = "default"
#     }
#
#     forwarded_query_strings {
#       option = false
#     }
#   }
# }

# 例6: 動的コンテンツ向けの設定（クッキー・ヘッダー転送）
# -----------------------------------------------------------------------------
# resource "aws_lightsail_distribution" "dynamic_content" {
#   name      = "dynamic-content-distribution"
#   bundle_id = "small_1_0"
#
#   origin {
#     name        = aws_lightsail_lb.app.name
#     region_name = data.aws_availability_zones.available.id
#   }
#
#   default_cache_behavior {
#     behavior = "cache"
#   }
#
#   cache_behavior_settings {
#     allowed_http_methods = "GET,HEAD,OPTIONS,PUT,PATCH,POST,DELETE"
#     cached_http_methods  = "GET,HEAD"
#     default_ttl          = 300  # 5分（動的コンテンツのため短め）
#     maximum_ttl          = 600
#     minimum_ttl          = 0
#
#     forwarded_cookies {
#       option             = "allow-list"
#       cookies_allow_list = ["session-id", "user-preference"]
#     }
#
#     forwarded_headers {
#       option             = "allow-list"
#       headers_allow_list = ["Accept", "Accept-Language", "Authorization"]
#     }
#
#     forwarded_query_strings {
#       option                     = true
#       query_strings_allowed_list = ["page", "sort", "filter"]
#     }
#   }
# }

################################################################################
# 重要な注意事項とベストプラクティス
################################################################################

# 1. バンドルサイズの選択
#    - small_1_0: 小規模サイト、テスト環境向け（50 GB/月）
#    - medium_1_0: 中規模サイト向け（125 GB/月）
#    - large_1_0: 大規模サイト、高トラフィック向け（250 GB/月）
#    - トラフィック予測に基づいて適切なバンドルを選択
#    - 超過料金に注意し、モニタリングを実施

# 2. オリジン要件
#    - インスタンスオリジン: 静的 IP のアタッチが必須
#    - ロードバランサーオリジン: 最低 1 つのインスタンスアタッチが必須
#    - バケットオリジン: Lightsail バケットが事前に作成されている必要がある
#    - 依存関係を depends_on で明示的に指定

# 3. キャッシュ戦略
#    - 静的コンテンツ: 高 TTL（86400秒 = 1日以上）
#    - 動的コンテンツ: 低 TTL（300秒 = 5分程度）
#    - API レスポンス: キャッシュしない（dont-cache）
#    - キャッシュキーの最小化でヒット率向上

# 4. セキュリティのベストプラクティス
#    - protocol_policy に "https-only" を使用
#    - カスタムドメイン使用時は必ず SSL/TLS 証明書を設定
#    - 必要最小限のHTTPメソッドのみ許可
#    - 認証情報を含むヘッダーの転送は慎重に

# 5. パフォーマンス最適化
#    - 不要なクッキー/ヘッダー/クエリ文字列の転送を避ける
#    - キャッシュキーを最小限に保つ
#    - パスベースのキャッシュ動作で細かく制御
#    - 高頻度で変更されないコンテンツは高 TTL に設定

# 6. コスト最適化
#    - トラフィックパターンに基づいて適切なバンドルを選択
#    - キャッシュヒット率を高めてオリジンへのリクエストを削減
#    - 不要な転送を避けてデータ転送量を最小化
#    - CloudWatch メトリクスでモニタリング

# 7. 運用上の考慮事項
#    - 変更は伝播に時間がかかる（数分〜10分程度）
#    - コンテンツ更新後はキャッシュ無効化が必要な場合がある
#    - ステータス監視で障害を早期検知
#    - support_code を記録しておくとサポート対応が迅速

# 8. パスパターンマッチング
#    - パスパターンは大文字小文字を区別
#    - ワイルドカード使用で柔軟なマッチング（*.jpg, /path/*）
#    - より具体的なパターンが優先される
#    - デフォルト動作は最後のフォールバック

# 9. インポート
#    既存の Lightsail Distribution は以下のコマンドでインポート可能:
#    terraform import aws_lightsail_distribution.example example-distribution

# 10. 関連リソース
#     - aws_lightsail_bucket: オリジンバケット
#     - aws_lightsail_instance: オリジンインスタンス
#     - aws_lightsail_lb: オリジンロードバランサー
#     - aws_lightsail_static_ip: インスタンス用静的IP
#     - aws_lightsail_certificate: SSL/TLS証明書
#     - aws_lightsail_domain: カスタムドメイン
