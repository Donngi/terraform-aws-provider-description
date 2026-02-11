# ==============================================================================
# Terraform AWS Provider Template: aws_cloudfront_origin_request_policy
# ==============================================================================
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-18)の AWS Provider v6.28.0 の仕様に基づいています
# - 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください
# - AWS Terraform Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_request_policy
# - AWS CloudFront API Reference: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_OriginRequestPolicyConfig.html
# ==============================================================================

resource "aws_cloudfront_origin_request_policy" "example" {
  # ------------------------------------------------------------------------------
  # Required Attributes
  # ------------------------------------------------------------------------------

  # name - (Required) CloudFrontオリジンリクエストポリシーを識別するための一意の名前
  # Type: string
  # AWS Docs: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_OriginRequestPolicyConfig.html
  name = "example-origin-request-policy"

  # ------------------------------------------------------------------------------
  # Optional Attributes
  # ------------------------------------------------------------------------------

  # comment - (Optional) オリジンリクエストポリシーを説明するためのコメント
  # コメントは128文字以下である必要があります
  # Type: string
  # AWS Docs: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_OriginRequestPolicyConfig.html
  comment = "Example origin request policy"

  # id - (Optional) オリジンリクエストポリシーの識別子
  # 通常は自動的に生成されるため、明示的に指定する必要はありません
  # Type: string
  # id = "auto-generated-id"

  # ------------------------------------------------------------------------------
  # Required Block: cookies_config
  # ------------------------------------------------------------------------------
  # ビューアリクエストのCookie(もしあれば)をオリジンリクエストに含めるかどうかを決定します
  # AWS Docs: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_OriginRequestPolicyCookiesConfig.html

  cookies_config {
    # cookie_behavior - (Required) ビューアリクエストのCookieをオリジンリクエストに含めるかどうかを決定します
    # 有効な値:
    # - "none": ビューアリクエストのCookieはオリジンリクエストに含まれません
    #   (CachePolicyで指定されたCookieは含まれます)
    # - "whitelist": CookieNamesで指定されたCookieのみが含まれます
    # - "all": すべてのCookieが含まれます
    # - "allExcept": CookieNamesで指定されたCookie以外のすべてのCookieが含まれます
    # Type: string
    cookie_behavior = "none"

    # ------------------------------------------------------------------------------
    # Optional Nested Block: cookies
    # ------------------------------------------------------------------------------
    # cookie_behaviorが"whitelist"または"allExcept"の場合に使用します
    # Cookie名のリストを含みます

    # cookies {
    #   # items - (Optional) Cookie名のセット
    #   # cookie_behaviorが"whitelist"の場合: これらのCookieのみが含まれます
    #   # cookie_behaviorが"allExcept"の場合: これらのCookie以外がすべて含まれます
    #   # Type: set(string)
    #   items = ["example-cookie-1", "example-cookie-2"]
    # }
  }

  # ------------------------------------------------------------------------------
  # Required Block: headers_config
  # ------------------------------------------------------------------------------
  # ビューアリクエストのHTTPヘッダー(もしあれば)をオリジンリクエストに含めるかどうかを決定します
  # AWS Docs: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_OriginRequestPolicyHeadersConfig.html

  headers_config {
    # header_behavior - (Optional) HTTPヘッダーをオリジンリクエストに含めるかどうかを決定します
    # 有効な値:
    # - "none": ビューアリクエストのHTTPヘッダーは含まれません
    #   (CachePolicyで指定されたヘッダーは含まれます)
    # - "whitelist": Headersで指定されたHTTPヘッダーのみが含まれます
    # - "allViewer": ビューアリクエストのすべてのHTTPヘッダーが含まれます
    # - "allViewerAndWhitelistCloudFront": ビューアリクエストのすべてのHTTPヘッダーと
    #   Headersで指定された追加のCloudFrontヘッダーが含まれます
    # - "allExcept": Headersで指定されたヘッダー以外のすべてのHTTPヘッダーが含まれます
    # Type: string
    header_behavior = "none"

    # ------------------------------------------------------------------------------
    # Optional Nested Block: headers
    # ------------------------------------------------------------------------------
    # header_behaviorが"whitelist"、"allViewerAndWhitelistCloudFront"、または"allExcept"の場合に使用します
    # HTTPヘッダー名のリストを含みます

    # headers {
    #   # items - (Optional) HTTPヘッダー名のセット
    #   # header_behaviorの値に応じて、これらのヘッダーが含まれる/除外されます
    #   # Type: set(string)
    #   items = ["CloudFront-Viewer-Country", "CloudFront-Is-Mobile-Viewer"]
    # }
  }

  # ------------------------------------------------------------------------------
  # Required Block: query_strings_config
  # ------------------------------------------------------------------------------
  # ビューアリクエストのURLクエリ文字列(もしあれば)をオリジンリクエストに含めるかどうかを決定します
  # AWS Docs: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_OriginRequestPolicyQueryStringsConfig.html

  query_strings_config {
    # query_string_behavior - (Required) URLクエリ文字列をオリジンリクエストに含めるかどうかを決定します
    # 有効な値:
    # - "none": ビューアリクエストのクエリ文字列は含まれません
    #   (CachePolicyで指定されたクエリ文字列は含まれます)
    # - "whitelist": QueryStringNamesで指定されたクエリ文字列のみが含まれます
    # - "all": すべてのクエリ文字列が含まれます
    # - "allExcept": QueryStringNamesで指定されたクエリ文字列以外がすべて含まれます
    # Type: string
    query_string_behavior = "none"

    # ------------------------------------------------------------------------------
    # Optional Nested Block: query_strings
    # ------------------------------------------------------------------------------
    # query_string_behaviorが"whitelist"または"allExcept"の場合に使用します
    # クエリ文字列名のリストを含みます

    # query_strings {
    #   # items - (Optional) クエリ文字列名のセット
    #   # query_string_behaviorが"whitelist"の場合: これらのクエリ文字列のみが含まれます
    #   # query_string_behaviorが"allExcept"の場合: これらのクエリ文字列以外がすべて含まれます
    #   # Type: set(string)
    #   items = ["example-param-1", "example-param-2"]
    # }
  }
}

# ==============================================================================
# Computed Attributes (Read-Only)
# ==============================================================================
# 以下の属性は自動的に計算され、読み取り専用です。テンプレートには含めません。
#
# - arn (string)
#   オリジンリクエストポリシーのARN
#   AWS Docs: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_OriginRequestPolicy.html
#
# - etag (string)
#   オリジンリクエストポリシーの現在のバージョン
#   AWS Docs: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_GetOriginRequestPolicy.html
# ==============================================================================

# ==============================================================================
# 参考情報
# ==============================================================================
# CloudFrontオリジンリクエストポリシーに関する詳細情報:
#
# - オリジンリクエストポリシーの理解:
#   https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/origin-request-understand-origin-request-policy.html
#
# - オリジンリクエストポリシーとキャッシュポリシーの連携:
#   https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/understanding-how-origin-request-policies-and-cache-policies-work-together.html
#
# - オリジンリクエストポリシーの作成:
#   https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/origin-request-create-origin-request-policy.html
#
# - ポリシーを使用したオリジンリクエストの制御:
#   https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/controlling-origin-requests.html
# ==============================================================================
