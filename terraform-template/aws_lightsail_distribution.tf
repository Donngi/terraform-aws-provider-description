#---------------------------------------------------------------
# AWS Lightsail Distribution
#---------------------------------------------------------------
#
# Amazon LightsailのCDN（コンテンツデリバリーネットワーク）ディストリビューションを
# プロビジョニングするリソースです。エッジロケーションにコンテンツをキャッシュし、
# コンテンツへのアクセスレイテンシーを削減します。
# オリジンとしてLightsailインスタンス、バケット、ロードバランサーを指定できます。
#
# AWS公式ドキュメント:
#   - Lightsail Distributionsの概要: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-distributions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_distribution
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_distribution" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ディストリビューションの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-distribution"

  # bundle_id (Required)
  # 設定内容: ディストリビューションに使用するバンドルIDを指定します。
  # 設定可能な値: 有効なLightsailディストリビューションバンドルID（例: small_1_0）
  # 参考: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-distributions.html
  bundle_id = "small_1_0"

  # certificate_name (Optional)
  # 設定内容: ディストリビューションに関連付けるSSL/TLS証明書の名前を指定します。
  # 設定可能な値: 有効なLightsail証明書名
  # 省略時: SSL/TLS証明書は関連付けられません
  certificate_name = null

  # ip_address_type (Optional)
  # 設定内容: ディストリビューションのIPアドレスタイプを指定します。
  # 設定可能な値:
  #   - "dualstack" (デフォルト): IPv4とIPv6の両方をサポート
  #   - "ipv4": IPv4のみをサポート
  # 省略時: dualstack
  ip_address_type = "dualstack"

  # is_enabled (Optional)
  # 設定内容: ディストリビューションを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): ディストリビューションを有効化
  #   - false: ディストリビューションを無効化
  # 省略時: true
  is_enabled = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # オリジン設定
  #-------------------------------------------------------------

  # origin (Required)
  # 設定内容: ディストリビューションのオリジンリソースを指定する設定ブロックです。
  # 設定内容: オリジンとしてLightsailインスタンス（静的IP付き）、バケット、
  #           またはインスタンスが接続されたロードバランサーを指定できます。
  origin {

    # name (Required)
    # 設定内容: オリジンリソースの名前を指定します。
    # 設定可能な値: 静的IP付きインスタンス名、バケット名、またはロードバランサー名
    name = "example-bucket"

    # region_name (Required)
    # 設定内容: オリジンリソースのAWSリージョン名を指定します。
    # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1）
    region_name = "us-east-1"

    # protocol_policy (Optional)
    # 設定内容: ディストリビューションがコンテンツを取得するためにオリジンと接続する際に
    #           使用するプロトコルを指定します。
    # 設定可能な値: 文字列（例: "http-only", "https-only", "http-and-https"）
    # 省略時: オリジンのデフォルトプロトコルポリシーを使用
    protocol_policy = "https-only"
  }

  #-------------------------------------------------------------
  # デフォルトキャッシュ動作設定
  #-------------------------------------------------------------

  # default_cache_behavior (Required)
  # 設定内容: ディストリビューションのデフォルトキャッシュ動作を指定する設定ブロックです。
  default_cache_behavior {

    # behavior (Required)
    # 設定内容: ディストリビューションのキャッシュ動作を指定します。
    # 設定可能な値:
    #   - "cache": コンテンツをキャッシュする
    #   - "dont-cache": コンテンツをキャッシュしない
    behavior = "cache"
  }

  #-------------------------------------------------------------
  # パス別キャッシュ動作設定
  #-------------------------------------------------------------

  # cache_behavior (Optional)
  # 設定内容: 特定のパスに対するキャッシュ動作を指定する設定ブロックです（複数指定可能）。
  # 設定内容: ディレクトリやファイルのパスごとに異なるキャッシュ動作を設定できます。
  cache_behavior {

    # path (Required)
    # 設定内容: キャッシュまたはキャッシュしないディレクトリやファイルのパスを指定します。
    # 設定可能な値: パス文字列。ワイルドカード指定可能（例: /images/*, *.html）。
    #              ディレクトリとファイルパスは大文字小文字を区別します。
    path = "/images/*"

    # behavior (Required)
    # 設定内容: 指定したパスに対するキャッシュ動作を指定します。
    # 設定可能な値:
    #   - "cache": コンテンツをキャッシュする
    #   - "dont-cache": コンテンツをキャッシュしない
    behavior = "cache"
  }

  #-------------------------------------------------------------
  # キャッシュ動作設定
  #-------------------------------------------------------------

  # cache_behavior_settings (Optional)
  # 設定内容: ディストリビューションのキャッシュ動作設定を指定する設定ブロックです。
  # 関連機能: Lightsail Distribution キャッシュ設定
  #   TTL設定やHTTPメソッド、クッキー・ヘッダー・クエリ文字列の転送設定が可能。
  #   - https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-changing-default-cache-behavior.html
  cache_behavior_settings {

    # allowed_http_methods (Optional)
    # 設定内容: ディストリビューションのオリジンに処理・転送するHTTPメソッドを指定します。
    # 設定可能な値: カンマ区切りのHTTPメソッド文字列（例: "GET,HEAD"、"GET,HEAD,OPTIONS,PUT,PATCH,POST,DELETE"）
    # 省略時: オリジンのデフォルト設定を使用
    allowed_http_methods = "GET,HEAD,OPTIONS,PUT,PATCH,POST,DELETE"

    # cached_http_methods (Optional)
    # 設定内容: ディストリビューションでキャッシュするHTTPメソッドのレスポンスを指定します。
    # 設定可能な値: カンマ区切りのHTTPメソッド文字列（例: "GET,HEAD"）
    # 省略時: GET,HEAD のみキャッシュ
    cached_http_methods = "GET,HEAD"

    # default_ttl (Optional)
    # 設定内容: ディストリビューションがオリジンに次のリクエストを転送するまで、
    #           キャッシュにオブジェクトが残る秒数のデフォルト値を指定します。
    # 設定可能な値: 秒単位の数値（例: 86400 = 1日）
    # 省略時: 86400秒（1日）
    default_ttl = 86400

    # maximum_ttl (Optional)
    # 設定内容: ディストリビューションがオリジンに次のリクエストを転送するまで、
    #           キャッシュにオブジェクトが残る秒数の最大値を指定します。
    # 設定可能な値: 秒単位の数値（例: 31536000 = 1年）
    # 省略時: 31536000秒（1年）
    maximum_ttl = 31536000

    # minimum_ttl (Optional)
    # 設定内容: ディストリビューションがオリジンに次のリクエストを転送するまで、
    #           キャッシュにオブジェクトが残る秒数の最小値を指定します。
    # 設定可能な値: 秒単位の数値（例: 0）
    # 省略時: 0秒
    minimum_ttl = 0

    #-----------------------------------------------------------
    # クッキー転送設定
    #-----------------------------------------------------------

    # forwarded_cookies (Optional)
    # 設定内容: オリジンに転送するクッキーの設定ブロックです。
    # 設定内容: キャッシュはここで指定したクッキーに基づいて行われます。
    forwarded_cookies {

      # option (Optional)
      # 設定内容: キャッシュ動作に対してオリジンに転送するクッキーを指定します。
      # 設定可能な値:
      #   - "none": クッキーを転送しない
      #   - "allow-list": cookies_allow_listで指定したクッキーのみを転送
      #   - "all": 全てのクッキーを転送
      # 省略時: none
      option = "none"

      # cookies_allow_list (Optional)
      # 設定内容: ディストリビューションのオリジンに転送する特定のクッキーを指定します。
      # 設定可能な値: クッキー名のセット
      # 注意: option = "allow-list" の場合のみ有効
      cookies_allow_list = []
    }

    #-----------------------------------------------------------
    # ヘッダー転送設定
    #-----------------------------------------------------------

    # forwarded_headers (Optional)
    # 設定内容: オリジンに転送するヘッダーの設定ブロックです。
    # 設定内容: キャッシュはここで指定したヘッダーに基づいて行われます。
    forwarded_headers {

      # option (Optional)
      # 設定内容: ディストリビューションがオリジンに転送してキャッシュのベースとするヘッダーを指定します。
      # 設定可能な値:
      #   - "default": デフォルトのヘッダーのみを転送
      #   - "allow-list": headers_allow_listで指定したヘッダーのみを転送
      #   - "all": 全てのヘッダーを転送
      # 省略時: default
      option = "default"

      # headers_allow_list (Optional)
      # 設定内容: ディストリビューションのオリジンに転送する特定のヘッダーを指定します。
      # 設定可能な値: ヘッダー名のセット
      # 注意: option = "allow-list" の場合のみ有効
      headers_allow_list = []
    }

    #-----------------------------------------------------------
    # クエリ文字列転送設定
    #-----------------------------------------------------------

    # forwarded_query_strings (Optional)
    # 設定内容: オリジンに転送するクエリ文字列の設定ブロックです。
    # 設定内容: キャッシュはここで指定したクエリ文字列に基づいて行われます。
    forwarded_query_strings {

      # option (Optional)
      # 設定内容: ディストリビューションがクエリ文字列に基づいて転送・キャッシュするかを指定します。
      # 設定可能な値:
      #   - true: クエリ文字列に基づいて転送・キャッシュする
      #   - false: クエリ文字列を転送しない
      # 省略時: false
      option = false

      # query_strings_allowed_list (Optional)
      # 設定内容: ディストリビューションがオリジンに転送する特定のクエリ文字列を指定します。
      # 設定可能な値: クエリ文字列名のセット
      # 注意: option = true の場合のみ有効
      query_strings_allowed_list = []
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定する設定ブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" のような時間表記文字列
    # 省略時: プロバイダーのデフォルトタイムアウト値を使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" のような時間表記文字列
    # 省略時: プロバイダーのデフォルトタイムアウト値を使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" のような時間表記文字列
    # 省略時: プロバイダーのデフォルトタイムアウト値を使用
    delete = "30m"
  }

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
# - alternative_domain_names: ディストリビューションの代替ドメイン名のリスト
# - arn: ディストリビューションのAmazon Resource Name (ARN)
# - created_at: ディストリビューションが作成されたタイムスタンプ
# - domain_name: ディストリビューションのドメイン名
# - location: ディストリビューションのロケーション情報（availability_zone, region_name）
# - origin_public_dns: オリジンのパブリックDNS
# - origin[0].resource_type: オリジンリソースのリソースタイプ（例: Instance）
# - resource_type: LightsailリソースタイプÚ（例: Distribution）
# - status: ディストリビューションのステータス
# - support_code: サポートコード。Lightsailサポートへの問い合わせ時に使用
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
