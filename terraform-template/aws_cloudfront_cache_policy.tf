#---------------------------------------------------------------
# AWS CloudFront Cache Policy
#---------------------------------------------------------------
#
# Amazon CloudFrontのキャッシュポリシーをプロビジョニングするリソースです。
# キャッシュポリシーは、CloudFrontキャッシュ内のオブジェクトのキャッシュキーに含める値
# （HTTPヘッダー、Cookie、URLクエリ文字列）と、オブジェクトがキャッシュに留まる
# 時間（TTL）を制御します。
#
# AWS公式ドキュメント:
#   - キャッシュポリシーの概要: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/controlling-the-cache-key.html
#   - キャッシュポリシーの理解: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cache-key-understand-cache-policy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_cache_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudfront_cache_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: キャッシュポリシーの一意な名前を指定します。
  # 設定可能な値: 一意の文字列
  # 用途: コンソールやAPIでキャッシュポリシーを識別するために使用されます。
  name = "example-cache-policy"

  # comment (Optional)
  # 設定内容: キャッシュポリシーの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: キャッシュポリシーの目的を説明するために使用します。
  comment = "Example cache policy for demonstration"

  #-------------------------------------------------------------
  # TTL（Time To Live）設定
  #-------------------------------------------------------------
  # TTL設定は、オリジンレスポンスのCache-ControlおよびExpiresヘッダーと
  # 連携して、CloudFrontキャッシュ内のオブジェクトの有効期間を決定します。
  # 参考: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Expiration.html

  # min_ttl (Optional)
  # 設定内容: オブジェクトがCloudFrontキャッシュに留まる最小時間（秒）を指定します。
  # 設定可能な値: 0以上の整数（秒単位）
  # 省略時: 0
  # 注意: min_ttlが0より大きい場合、オリジンヘッダーにCache-Control: no-cache、
  #       no-store、privateディレクティブが含まれていても、min_ttlの期間は
  #       コンテンツがキャッシュされます。
  min_ttl = 1

  # default_ttl (Optional)
  # 設定内容: オブジェクトがCloudFrontキャッシュに留まるデフォルト時間（秒）を指定します。
  # 設定可能な値: 0以上の整数（秒単位）
  # 省略時: 86400（24時間）
  # 動作: オリジンがCache-ControlまたはExpiresヘッダーを送信しない場合に
  #       オブジェクトのTTLとして使用されます。
  default_ttl = 86400

  # max_ttl (Optional)
  # 設定内容: オブジェクトがCloudFrontキャッシュに留まる最大時間（秒）を指定します。
  # 設定可能な値: 0以上の整数（秒単位）
  # 省略時: 31536000（365日）
  # 動作: オリジンがCache-ControlまたはExpiresヘッダーを送信した場合にのみ使用されます。
  # 注意: min_ttl、max_ttl、default_ttlをすべて0に設定すると、CloudFrontキャッシュが無効化されます。
  max_ttl = 31536000

  #-------------------------------------------------------------
  # キャッシュキーとオリジン転送設定
  #-------------------------------------------------------------
  # キャッシュキーに含める値（ヘッダー、Cookie、クエリ文字列）を指定します。
  # キャッシュキーに含まれる値は、オリジンへのリクエストにも自動的に含まれます。
  # キャッシュキーに含める値が少ないほど、キャッシュヒット率が向上します。

  parameters_in_cache_key_and_forwarded_to_origin {

    # enable_accept_encoding_brotli (Optional)
    # 設定内容: Accept-Encoding HTTPヘッダー（Brotli）をキャッシュキーと
    #           オリジンリクエストに含めるかを指定します。
    # 設定可能な値:
    #   - true: Brotli圧縮オブジェクトのリクエストとキャッシュを有効化
    #   - false: Brotli圧縮を無効化
    # 省略時: false
    # 関連機能: CloudFront圧縮
    #   ビューアがBrotliをサポートする場合（Accept-EncodingヘッダーにbrがChromeとFirefoxブラウザは
    #   HTTPS経由のリクエストでのみBrotli圧縮をサポートします。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/ServingCompressedFiles.html
    enable_accept_encoding_brotli = true

    # enable_accept_encoding_gzip (Optional)
    # 設定内容: Accept-Encoding HTTPヘッダー（Gzip）をキャッシュキーと
    #           オリジンリクエストに含めるかを指定します。
    # 設定可能な値:
    #   - true: Gzip圧縮オブジェクトのリクエストとキャッシュを有効化
    #   - false: Gzip圧縮を無効化
    # 省略時: false
    # 関連機能: CloudFront圧縮
    #   ビューアがGzipをサポートする場合（Accept-EncodingヘッダーにgzipがCloudFrontは
    #   圧縮されたオブジェクトをリクエストしてキャッシュします。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/ServingCompressedFiles.html
    enable_accept_encoding_gzip = true

    #-----------------------------------------------------------
    # Cookieの設定
    #-----------------------------------------------------------
    # ビューアリクエスト内のCookieをキャッシュキーに含めるかを制御します。

    cookies_config {
      # cookie_behavior (Required)
      # 設定内容: ビューアリクエスト内のCookieをキャッシュキーに含めるかを指定します。
      # 設定可能な値:
      #   - "none": Cookieをキャッシュキーに含めず、オリジンリクエストにも自動的に含めない
      #   - "whitelist": 指定したCookieのみをキャッシュキーとオリジンリクエストに含める
      #   - "allExcept": 指定したCookie以外のすべてをキャッシュキーとオリジンリクエストに含める
      #   - "all": すべてのCookieをキャッシュキーとオリジンリクエストに含める
      cookie_behavior = "whitelist"

      # cookies (Optional)
      # 設定内容: cookie_behaviorが"whitelist"または"allExcept"の場合に、
      #           対象となるCookie名のリストを指定します。
      # 注意: Cookie名のみを指定します（値は含めません）。
      #       例: "session_ID=abcd1234"ではなく"session_ID"を指定します。
      cookies {
        # items (Optional)
        # 設定内容: Cookie名のリストを指定します。
        # 設定可能な値: Cookie名の文字列セット
        items = ["session_id", "user_preference"]
      }
    }

    #-----------------------------------------------------------
    # ヘッダーの設定
    #-----------------------------------------------------------
    # ビューアリクエスト内のHTTPヘッダーをキャッシュキーに含めるかを制御します。

    headers_config {
      # header_behavior (Optional)
      # 設定内容: ビューアリクエスト内のHTTPヘッダーをキャッシュキーに含めるかを指定します。
      # 設定可能な値:
      #   - "none": ヘッダーをキャッシュキーに含めず、オリジンリクエストにも自動的に含めない
      #   - "whitelist": 指定したヘッダーのみをキャッシュキーとオリジンリクエストに含める
      # 注意: CookieやクエリパラメータとMismatchしてallやallExceptはサポートされません。
      header_behavior = "whitelist"

      # headers (Optional)
      # 設定内容: header_behaviorが"whitelist"の場合に、対象となるヘッダー名のリストを指定します。
      # 注意: ヘッダー名のみを指定します（値は含めません）。
      #       例: "Accept-Language: en-US,en;q=0.5"ではなく"Accept-Language"を指定します。
      #       CloudFront生成ヘッダーも含めることができます。
      #       参考: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/adding-cloudfront-headers.html
      headers {
        # items (Optional)
        # 設定内容: ヘッダー名のリストを指定します。
        # 設定可能な値: HTTPヘッダー名の文字列セット
        items = ["Accept-Language", "Authorization"]
      }
    }

    #-----------------------------------------------------------
    # クエリ文字列の設定
    #-----------------------------------------------------------
    # ビューアリクエスト内のURLクエリ文字列をキャッシュキーに含めるかを制御します。

    query_strings_config {
      # query_string_behavior (Required)
      # 設定内容: ビューアリクエスト内のURLクエリ文字列をキャッシュキーに含めるかを指定します。
      # 設定可能な値:
      #   - "none": クエリ文字列をキャッシュキーに含めず、オリジンリクエストにも自動的に含めない
      #   - "whitelist": 指定したクエリ文字列のみをキャッシュキーとオリジンリクエストに含める
      #   - "allExcept": 指定したクエリ文字列以外のすべてをキャッシュキーとオリジンリクエストに含める
      #   - "all": すべてのクエリ文字列をキャッシュキーとオリジンリクエストに含める
      query_string_behavior = "whitelist"

      # query_strings (Optional)
      # 設定内容: query_string_behaviorが"whitelist"または"allExcept"の場合に、
      #           対象となるクエリ文字列名のリストを指定します。
      # 注意: クエリ文字列名のみを指定します（値は含めません）。
      #       例: "split-pages=false"ではなく"split-pages"を指定します。
      #       アスタリスク(*)はワイルドカードではなくリテラル文字列として扱われます。
      query_strings {
        # items (Optional)
        # 設定内容: クエリ文字列名のリストを指定します。
        # 設定可能な値: クエリ文字列名の文字列セット
        items = ["page", "sort", "filter"]
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: キャッシュポリシーの識別子
#
# - arn: キャッシュポリシーのAmazon Resource Name (ARN)
#
# - etag: キャッシュポリシーの現在のバージョン。ポリシーを更新する際に
#         楽観的ロックに使用されます。
#---------------------------------------------------------------
