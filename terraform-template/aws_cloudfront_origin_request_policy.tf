#---------------------------------------------------------------
# CloudFront Origin Request Policy
#---------------------------------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-12
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudfront_origin_request_policy
#
# NOTE:
# CloudFrontのオリジンリクエストポリシー
# キャッシュミス時にCloudFrontがオリジンへ送信するリクエストに含める
# ヘッダー、Cookie、クエリ文字列を制御します
#
# 主な用途:
# - オリジンへ転送するビューワーリクエストの要素を指定
# - キャッシュキーとは独立してオリジンリクエストを制御
# - 複数のディストリビューションで共通のポリシーを再利用
#
# 制限事項:
# - ポリシー名は同一アカウント内で一意である必要があります
# - キャッシュポリシーと併用する必要があります
# - マネージドポリシー（AWS管理）は変更できません
#
# AWS API/CLI 対応:
# - API: CreateOriginRequestPolicy, UpdateOriginRequestPolicy
# - CLI: aws cloudfront create-origin-request-policy
#
# Terraform 留意事項:
# - cookies_config、headers_config、query_strings_configは必須ブロック
# - 各設定でbehaviorに応じてitemsブロックが必要/不要になります
# - etag属性は更新時の競合検知に使用されます

#---------------------------------------------------------------
# リソース定義
#---------------------------------------------------------------
resource "aws_cloudfront_origin_request_policy" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------
  # 設定内容: オリジンリクエストポリシーの名前
  # 説明: 同一アカウント内で一意である必要があります
  # 用途: ポリシーの識別、ディストリビューションからの参照に使用
  name = "example-origin-request-policy"

  # 設定内容: ポリシーの説明（任意）
  # 説明: ポリシーの目的や用途を記述します
  # 用途: 管理者がポリシーの意図を理解するための補助情報
  comment = "Example origin request policy for custom headers and cookies"

  #---------------------------------------------------------------
  # Cookie設定
  #---------------------------------------------------------------
  # CloudFrontがオリジンへ転送するCookieを制御
  cookies_config {
    # 設定内容: Cookieの転送動作
    # 設定可能な値:
    #   - "none": Cookieを転送しない
    #   - "whitelist": 指定したCookieのみ転送
    #   - "all": すべてのCookieを転送
    #   - "allExcept": 指定したCookie以外を転送
    # 説明: whitelistまたはallExceptを指定した場合、cookiesブロックが必要です
    cookie_behavior = "whitelist"

    # 設定内容: 転送対象または除外対象のCookie一覧
    # 説明: cookie_behaviorが"whitelist"または"allExcept"の場合に指定
    # 注意: cookie_behaviorが"none"または"all"の場合は不要です
    cookies {
      # 設定内容: Cookie名のリスト
      # 説明: ワイルドカード（*）は使用できません
      # 例: ["session-id", "user-preference"]
      items = ["session-id", "user-token"]
    }
  }

  #---------------------------------------------------------------
  # ヘッダー設定
  #---------------------------------------------------------------
  # CloudFrontがオリジンへ転送するHTTPヘッダーを制御
  headers_config {
    # 設定内容: ヘッダーの転送動作
    # 設定可能な値:
    #   - "none": ヘッダーを転送しない（CloudFrontの自動追加ヘッダーのみ）
    #   - "whitelist": 指定したヘッダーのみ転送
    #   - "allViewer": すべてのビューワーヘッダーを転送
    #   - "allViewerAndWhitelistCloudFront": ビューワーヘッダーと指定したCloudFrontヘッダーを転送
    #   - "allExcept": 指定したヘッダー以外を転送
    # 説明: whitelistなどを指定した場合、headersブロックが必要です
    header_behavior = "whitelist"

    # 設定内容: 転送対象または除外対象のヘッダー一覧
    # 説明: header_behaviorに応じて必要性が変わります
    # 注意: header_behaviorが"none"または"allViewer"の場合は不要です
    headers {
      # 設定内容: ヘッダー名のリスト
      # 説明: 大文字小文字を区別しません
      # 例: ["Origin", "Referer", "User-Agent"]
      # CloudFrontが追加可能なヘッダー例: CloudFront-Viewer-Country, CloudFront-Is-Mobile-Viewer
      items = ["Origin", "Referer", "CloudFront-Viewer-Country"]
    }
  }

  #---------------------------------------------------------------
  # クエリ文字列設定
  #---------------------------------------------------------------
  # CloudFrontがオリジンへ転送するURLクエリ文字列を制御
  query_strings_config {
    # 設定内容: クエリ文字列の転送動作
    # 設定可能な値:
    #   - "none": クエリ文字列を転送しない
    #   - "whitelist": 指定したクエリ文字列のみ転送
    #   - "all": すべてのクエリ文字列を転送
    #   - "allExcept": 指定したクエリ文字列以外を転送
    # 説明: whitelistまたはallExceptを指定した場合、query_stringsブロックが必要です
    query_string_behavior = "whitelist"

    # 設定内容: 転送対象または除外対象のクエリ文字列一覧
    # 説明: query_string_behaviorが"whitelist"または"allExcept"の場合に指定
    # 注意: query_string_behaviorが"none"または"all"の場合は不要です
    query_strings {
      # 設定内容: クエリ文字列パラメータ名のリスト
      # 説明: ワイルドカード（*）は使用できません
      # 例: ["page", "sort", "filter"]
      items = ["page", "category", "sort"]
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------------------------------
# このリソースの作成後に参照可能な属性:
#
# - id
#   説明: オリジンリクエストポリシーの一意な識別子（自動生成）
#   用途: ポリシーの参照、他リソースでの指定に使用
#   例: cloudfront_distribution のorigin_request_policy_id で参照
#
# - arn
#   説明: オリジンリクエストポリシーのARN（Amazon Resource Name）
#   フォーマット: arn:aws:cloudfront::${account_id}:origin-request-policy/${id}
#   用途: IAMポリシーでのアクセス制御、CloudFormationテンプレート参照
#
# - etag
#   説明: ポリシーのバージョンを表すETagヘッダー値
#   用途: 更新時の競合検知、条件付き更新に使用
#   注意: AWS APIでの更新時に必要になります
