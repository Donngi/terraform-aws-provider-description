#-------------------------------------------------------------------------------------------------------
# aws_cloudfront_response_headers_policy
#-------------------------------------------------------------------------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-12
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudfront_response_headers_policy
#
# NOTE: このファイルは実環境にそのままデプロイすることを意図していません。
#       環境に合わせてパラメータを適切に設定した上でご利用ください。
#-------------------------------------------------------------------------------------------------------
# 目的: CloudFrontディストリビューションに適用するHTTPレスポンスヘッダーポリシーを定義
#
# 主な用途:
#   - CORS（Cross-Origin Resource Sharing）設定の集中管理
#   - セキュリティヘッダー（CSP, HSTS, X-Frame-Options等）の一括適用
#   - カスタムヘッダーの追加・削除による柔軟なレスポンス制御
#   - Server-Timingヘッダーによるパフォーマンスメトリクスの送信
#
# 関連リソース:
#   - aws_cloudfront_distribution: このポリシーを適用する配信先
#   - aws_cloudfront_cache_policy: キャッシュ動作と組み合わせて使用
#   - aws_wafv2_web_acl: セキュリティ設定の補完
#
# 重要な考慮事項:
#   - ポリシーはディストリビューションの各キャッシュビヘイビアに個別に関連付け可能
#   - セキュリティヘッダーとカスタムヘッダーは同一ポリシー内で併用可能
#   - オリジンのヘッダーを上書きする場合は override = true を設定
#   - Server-Timingヘッダーは本番環境では sampling_rate を適切に調整すべき
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_CreateResponseHeadersPolicy.html
#-------------------------------------------------------------------------------------------------------

resource "aws_cloudfront_response_headers_policy" "example" {
  #-------------------------------------------------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------------------------------------------------

  # name - レスポンスヘッダーポリシーの名前
  # 設定内容: ポリシーを識別するための一意の名前（CloudFrontアカウント内で一意）
  # 設定可能な値: 1〜128文字の英数字、ハイフン、アンダースコア
  # 制約事項: 既存のポリシー名と重複不可、変更すると新規リソース作成
  name = "example-response-headers-policy"

  # comment - ポリシーの説明
  # 設定内容: ポリシーの目的や適用対象を説明するコメント
  # 設定可能な値: 任意の文字列（最大256文字）
  # 省略時: コメントなし
  comment = "Example response headers policy for CORS and security headers"

  #-------------------------------------------------------------------------------------------------------
  # CORS設定
  #-------------------------------------------------------------------------------------------------------

  # cors_config - Cross-Origin Resource Sharingの設定
  # 設定内容: クロスオリジンリクエストに対するレスポンスヘッダー制御
  # 用途: ブラウザのSame-Origin Policyを緩和し、異なるオリジンからのアクセスを許可
  # 制約事項: 最大1ブロックまで設定可能
  # cors_config {
  #   # access_control_allow_credentials - 認証情報の送信許可
  #   # 設定内容: Access-Control-Allow-Credentialsヘッダーの値
  #   # 設定可能な値: true（Cookieや認証ヘッダーの送信を許可）, false（許可しない）
  #   # 制約事項: trueの場合、access_control_allow_originsに "*" は使用不可
  #   access_control_allow_credentials = false
  #
  #   # origin_override - オリジンのCORSヘッダーを上書き
  #   # 設定内容: オリジンが返すCORSヘッダーをCloudFrontのポリシーで置換するか
  #   # 設定可能な値: true（ポリシーで上書き）, false（オリジンのヘッダーを保持）
  #   # 推奨設定: オリジンがCORSヘッダーを返さない場合はtrue
  #   origin_override = true
  #
  #   # access_control_max_age_sec - プリフライトリクエストのキャッシュ期間
  #   # 設定内容: Access-Control-Max-Ageヘッダーの値（秒数）
  #   # 設定可能な値: 0〜86400（24時間）
  #   # 省略時: ブラウザのデフォルト動作（通常5秒）
  #   # 推奨設定: 頻繁なプリフライトリクエストを減らすため3600以上
  #   # access_control_max_age_sec = 3600
  #
  #   # access_control_allow_headers - 許可するリクエストヘッダー
  #   # 設定内容: Access-Control-Allow-Headersヘッダーの値
  #   # 用途: プリフライトリクエストでクライアントが送信可能なヘッダーを指定
  #   # 制約事項: 必須ブロック（min_items = 1）
  #   access_control_allow_headers {
  #     # items - 許可するヘッダー名のリスト
  #     # 設定可能な値: ヘッダー名の配列（例: ["Content-Type", "Authorization", "X-Custom-Header"]）
  #     # 省略時: 空のリスト（すべてのヘッダーを拒否）
  #     # 推奨設定: "*" でワイルドカード許可、または明示的なヘッダー名
  #     items = ["Content-Type", "Authorization", "X-Requested-With"]
  #   }
  #
  #   # access_control_allow_methods - 許可するHTTPメソッド
  #   # 設定内容: Access-Control-Allow-Methodsヘッダーの値
  #   # 用途: プリフライトリクエストでクライアントが使用可能なHTTPメソッドを指定
  #   # 制約事項: 必須ブロック（min_items = 1）
  #   access_control_allow_methods {
  #     # items - 許可するHTTPメソッドのリスト
  #     # 設定可能な値: GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS
  #     # 推奨設定: 必要最小限のメソッドのみ許可（セキュリティ考慮）
  #     items = ["GET", "POST", "OPTIONS"]
  #   }
  #
  #   # access_control_allow_origins - 許可するオリジン
  #   # 設定内容: Access-Control-Allow-Originヘッダーの値
  #   # 用途: クロスオリジンリクエストを許可するドメインを指定
  #   # 制約事項: 必須ブロック（min_items = 1）
  #   access_control_allow_origins {
  #     # items - 許可するオリジンのリスト
  #     # 設定可能な値: 完全なURL（例: "https://example.com"）または "*"（全オリジン許可）
  #     # 制約事項: access_control_allow_credentials = true の場合、"*" 使用不可
  #     # 推奨設定: セキュリティのため明示的なドメインリストを推奨
  #     items = ["https://example.com", "https://www.example.com"]
  #   }
  #
  #   # access_control_expose_headers - 公開するレスポンスヘッダー
  #   # 設定内容: Access-Control-Expose-Headersヘッダーの値
  #   # 用途: ブラウザのJavaScriptからアクセス可能なレスポンスヘッダーを指定
  #   # 制約事項: 最大1ブロックまで設定可能
  #   # access_control_expose_headers {
  #   #   # items - 公開するヘッダー名のリスト
  #   #   # 設定可能な値: ヘッダー名の配列（例: ["ETag", "X-Custom-Response-Header"]）
  #   #   # 省略時: 空のリスト（標準的なヘッダーのみ公開）
  #   #   # 推奨設定: カスタムヘッダーやメタデータをクライアントで利用する場合に設定
  #   #   items = ["ETag", "X-Amz-Request-Id"]
  #   # }
  # }

  #-------------------------------------------------------------------------------------------------------
  # カスタムヘッダー設定
  #-------------------------------------------------------------------------------------------------------

  # custom_headers_config - カスタムレスポンスヘッダーの追加
  # 設定内容: 任意のHTTPヘッダーをレスポンスに追加
  # 用途: 独自のヘッダーによる機能制御、デバッグ情報の付与、アプリケーション固有の設定
  # 制約事項: 最大1ブロックまで設定可能
  # custom_headers_config {
  #   # items - 追加するカスタムヘッダーのリスト
  #   # 設定内容: ヘッダー名、値、上書き設定の組
  #   # 制約事項: 複数のitemsブロックを設定可能（setタイプ）
  #   items {
  #     # header - ヘッダー名
  #     # 設定内容: 追加するHTTPヘッダーの名前
  #     # 設定可能な値: 任意の有効なHTTPヘッダー名
  #     # 制約事項: CloudFrontが自動生成するヘッダー（X-Cache等）は上書き不可
  #     header = "X-Custom-Header"
  #
  #     # value - ヘッダーの値
  #     # 設定内容: ヘッダーに設定する値
  #     # 設定可能な値: 任意の文字列（最大1783文字）
  #     # 推奨設定: 環境情報、バージョン番号、キャッシュキー等
  #     value = "CustomValue"
  #
  #     # override - オリジンのヘッダーを上書き
  #     # 設定内容: オリジンが同名のヘッダーを返した場合の動作
  #     # 設定可能な値: true（ポリシーの値で上書き）, false（オリジンの値を保持）
  #     # 推奨設定: オリジン側の設定を尊重する場合はfalse
  #     override = false
  #   }
  #
  #   # items {
  #   #   header = "X-Environment"
  #   #   value = "production"
  #   #   override = true
  #   # }
  # }

  #-------------------------------------------------------------------------------------------------------
  # ヘッダー削除設定
  #-------------------------------------------------------------------------------------------------------

  # remove_headers_config - レスポンスヘッダーの削除
  # 設定内容: オリジンから返されたヘッダーをクライアントに送信する前に削除
  # 用途: 内部情報の漏洩防止、不要なヘッダーの除去
  # 制約事項: 最大1ブロックまで設定可能
  # remove_headers_config {
  #   # items - 削除するヘッダーのリスト
  #   # 設定内容: 削除対象のヘッダー名
  #   # 制約事項: 複数のitemsブロックを設定可能（setタイプ）
  #   items {
  #     # header - 削除するヘッダー名
  #     # 設定内容: オリジンから返されるヘッダーのうち削除するもの
  #     # 設定可能な値: 任意の有効なHTTPヘッダー名
  #     # 推奨設定: Server, X-Powered-By等の内部情報を含むヘッダー
  #     header = "Server"
  #   }
  #
  #   # items {
  #   #   header = "X-Powered-By"
  #   # }
  # }

  #-------------------------------------------------------------------------------------------------------
  # セキュリティヘッダー設定
  #-------------------------------------------------------------------------------------------------------

  # security_headers_config - セキュリティ関連ヘッダーの設定
  # 設定内容: XSS、クリックジャッキング、MIMEスニッフィング等の攻撃を防ぐヘッダー群
  # 用途: Webアプリケーションのセキュリティ強化
  # 制約事項: 最大1ブロックまで設定可能
  # security_headers_config {
  #   # content_security_policy - Content Security Policyの設定
  #   # 設定内容: Content-Security-Policyヘッダーの値
  #   # 用途: XSS攻撃を防ぐため、リソース読み込み元を制限
  #   # 制約事項: 最大1ブロックまで設定可能
  #   # content_security_policy {
  #   #   # content_security_policy - CSPディレクティブ
  #   #   # 設定内容: CSPポリシーの完全な定義
  #   #   # 設定可能な値: CSP仕様に準拠したディレクティブ文字列
  #   #   # 推奨設定: default-src 'self'; script-src 'self' 'unsafe-inline'; など
  #   #   content_security_policy = "default-src 'self'; script-src 'self' 'unsafe-inline';"
  #   #
  #   #   # override - オリジンのCSPヘッダーを上書き
  #   #   # 設定内容: オリジンが返すContent-Security-Policyヘッダーの扱い
  #   #   # 設定可能な値: true（ポリシーで上書き）, false（オリジンの値を保持）
  #   #   override = true
  #   # }
  #
  #   # content_type_options - X-Content-Type-Optionsの設定
  #   # 設定内容: X-Content-Type-Optionsヘッダーを "nosniff" に設定
  #   # 用途: ブラウザによるMIMEタイプのスニッフィングを防止
  #   # 制約事項: 最大1ブロックまで設定可能
  #   # content_type_options {
  #   #   # override - オリジンのヘッダーを上書き
  #   #   # 設定内容: オリジンが返すX-Content-Type-Optionsヘッダーの扱い
  #   #   # 設定可能な値: true（ポリシーで上書き）, false（オリジンの値を保持）
  #   #   # 推奨設定: 一貫したセキュリティポリシーのためtrue推奨
  #   #   override = true
  #   # }
  #
  #   # frame_options - X-Frame-Optionsの設定
  #   # 設定内容: X-Frame-Optionsヘッダーの値
  #   # 用途: クリックジャッキング攻撃を防ぐため、フレーム埋め込みを制御
  #   # 制約事項: 最大1ブロックまで設定可能
  #   # frame_options {
  #   #   # frame_option - フレーム埋め込みポリシー
  #   #   # 設定内容: X-Frame-Optionsヘッダーの値
  #   #   # 設定可能な値: DENY（すべてのフレーム埋め込みを拒否）, SAMEORIGIN（同一オリジンのみ許可）
  #   #   # 推奨設定: DENY（最も厳格）、フレーム内表示が必要な場合はSAMEORIGIN
  #   #   frame_option = "DENY"
  #   #
  #   #   # override - オリジンのヘッダーを上書き
  #   #   # 設定内容: オリジンが返すX-Frame-Optionsヘッダーの扱い
  #   #   # 設定可能な値: true（ポリシーで上書き）, false（オリジンの値を保持）
  #   #   override = true
  #   # }
  #
  #   # referrer_policy - Referrer-Policyの設定
  #   # 設定内容: Referrer-Policyヘッダーの値
  #   # 用途: リクエスト時に送信されるRefererヘッダーの制御
  #   # 制約事項: 最大1ブロックまで設定可能
  #   # referrer_policy {
  #   #   # referrer_policy - リファラーポリシー
  #   #   # 設定内容: Referrer-Policyヘッダーの値
  #   #   # 設定可能な値: no-referrer, no-referrer-when-downgrade, origin, origin-when-cross-origin,
  #   #   #              same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
  #   #   # 推奨設定: strict-origin-when-cross-origin（プライバシーとトラッキングのバランス）
  #   #   referrer_policy = "strict-origin-when-cross-origin"
  #   #
  #   #   # override - オリジンのヘッダーを上書き
  #   #   # 設定内容: オリジンが返すReferrer-Policyヘッダーの扱い
  #   #   # 設定可能な値: true（ポリシーで上書き）, false（オリジンの値を保持）
  #   #   override = true
  #   # }
  #
  #   # strict_transport_security - HTTP Strict Transport Security (HSTS)の設定
  #   # 設定内容: Strict-Transport-Securityヘッダーの値
  #   # 用途: HTTPSへのアップグレードを強制し、中間者攻撃を防止
  #   # 制約事項: 最大1ブロックまで設定可能
  #   # strict_transport_security {
  #   #   # access_control_max_age_sec - HSTSの有効期間
  #   #   # 設定内容: max-ageディレクティブの値（秒数）
  #   #   # 設定可能な値: 0〜31536000（1年）
  #   #   # 推奨設定: 31536000（1年）でブラウザプリロードリストへの登録を推奨
  #   #   # 注意事項: HTTPサポートを完全に停止してから設定すること
  #   #   access_control_max_age_sec = 31536000
  #   #
  #   #   # override - オリジンのヘッダーを上書き
  #   #   # 設定内容: オリジンが返すStrict-Transport-Securityヘッダーの扱い
  #   #   # 設定可能な値: true（ポリシーで上書き）, false（オリジンの値を保持）
  #   #   override = true
  #   #
  #   #   # include_subdomains - サブドメインへのHSTS適用
  #   #   # 設定内容: includeSubDomainsディレクティブの追加
  #   #   # 設定可能な値: true（サブドメインにもHSTSを適用）, false（ルートドメインのみ）
  #   #   # 省略時: false
  #   #   # 注意事項: すべてのサブドメインがHTTPSに対応していることを確認してから有効化
  #   #   # include_subdomains = true
  #   #
  #   #   # preload - HSTSプリロードリストへの登録準備
  #   #   # 設定内容: preloadディレクティブの追加
  #   #   # 設定可能な値: true（プリロード対応）, false（非対応）
  #   #   # 省略時: false
  #   #   # 注意事項: max-age=31536000 と include_subdomains=true も必須
  #   #   # 推奨設定: https://hstspreload.org/ で登録申請する場合はtrue
  #   #   # preload = true
  #   # }
  #
  #   # xss_protection - X-XSS-Protectionの設定
  #   # 設定内容: X-XSS-Protectionヘッダーの値
  #   # 用途: ブラウザのXSS検知機能を制御（レガシーブラウザ対応）
  #   # 制約事項: 最大1ブロックまで設定可能
  #   # xss_protection {
  #   #   # protection - XSS保護の有効化
  #   #   # 設定内容: X-XSS-Protectionヘッダーの基本値
  #   #   # 設定可能な値: true（XSS保護を有効化）, false（無効化）
  #   #   # 推奨設定: CSPを使用する場合はfalse（XSS Auditorの脆弱性回避）
  #   #   protection = false
  #   #
  #   #   # override - オリジンのヘッダーを上書き
  #   #   # 設定内容: オリジンが返すX-XSS-Protectionヘッダーの扱い
  #   #   # 設定可能な値: true（ポリシーで上書き）, false（オリジンの値を保持）
  #   #   override = true
  #   #
  #   #   # mode_block - ブロックモードの有効化
  #   #   # 設定内容: mode=blockディレクティブの追加
  #   #   # 設定可能な値: true（XSS検知時にページレンダリングをブロック）, false（サニタイズのみ）
  #   #   # 省略時: false
  #   #   # 推奨設定: protection=trueの場合はtrue（より安全）
  #   #   # mode_block = true
  #   #
  #   #   # report_uri - XSS検知レポートの送信先
  #   #   # 設定内容: report=URIディレクティブの値
  #   #   # 設定可能な値: XSS検知レポートを受信するエンドポイントのURL
  #   #   # 省略時: レポート送信なし
  #   #   # report_uri = "https://example.com/xss-report"
  #   # }
  # }

  #-------------------------------------------------------------------------------------------------------
  # Server-Timingヘッダー設定
  #-------------------------------------------------------------------------------------------------------

  # server_timing_headers_config - Server-Timingヘッダーの設定
  # 設定内容: Server-Timingヘッダーを使用したCloudFrontメトリクスの送信
  # 用途: ブラウザ開発者ツールでCloudFrontのキャッシュヒット状況やレイテンシを可視化
  # 制約事項: 最大1ブロックまで設定可能
  # server_timing_headers_config {
  #   # enabled - Server-Timingヘッダーの有効化
  #   # 設定内容: Server-Timingヘッダーの追加を有効にするか
  #   # 設定可能な値: true（有効）, false（無効）
  #   # 推奨設定: 開発・ステージング環境ではtrue、本番環境ではfalseまたはsampling_rate調整
  #   enabled = false
  #
  #   # sampling_rate - サンプリングレート
  #   # 設定内容: Server-Timingヘッダーを追加するリクエストの割合
  #   # 設定可能な値: 0.0〜100.0（パーセンテージ）
  #   # 推奨設定: 本番環境では低い値（例: 1.0）、開発環境では100.0
  #   # 注意事項: 高いサンプリングレートはレスポンスサイズの増加を招く
  #   sampling_rate = 0.0
  # }
}

#-------------------------------------------------------------------------------------------------------
# Attributes Reference（参照専用の属性）
#-------------------------------------------------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id
#   レスポンスヘッダーポリシーの一意な識別子
#   形式: ポリシーID（例: "e2b1c2d3-4e5f-6a7b-8c9d-0e1f2a3b4c5d"）
#
# - arn
#   レスポンスヘッダーポリシーのAmazon Resource Name
#   形式: arn:aws:cloudfront::123456789012:response-headers-policy/{id}
#   用途: IAMポリシーでのリソース指定、他サービスとの連携
#
# - etag
#   ポリシーの現在のバージョンを示すETag値
#   用途: 更新時の競合検知、楽観的ロック制御
#   形式: 英数字の文字列（例: "E2QWRUHAPOMQZL"）
