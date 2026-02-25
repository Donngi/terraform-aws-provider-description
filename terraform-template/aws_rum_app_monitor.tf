#---------------------------------------------------------------
# Amazon CloudWatch RUM App Monitor
#---------------------------------------------------------------
#
# Amazon CloudWatch RUM（Real User Monitoring）のアプリモニターを
# プロビジョニングするリソースです。
# ウェブアプリケーションのクライアントサイドパフォーマンスや
# エラー、ユーザーインタラクションをリアルタイムで収集・可視化します。
# JavaScript スニペットをウェブアプリに組み込むことで、
# ページロード時間・JavaScriptエラー・HTTPリクエストなどの
# テレメトリデータを CloudWatch に送信します。
#
# AWS公式ドキュメント:
#   - CloudWatch RUM とは: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM.html
#   - アプリモニターの作成: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM-get-started-authorization.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rum_app_monitor
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rum_app_monitor" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: アプリモニターの一意な名前を指定します。
  # 設定可能な値: 1〜255文字の英数字、ハイフン、アンダースコア
  name = "example-rum-app-monitor"

  # domain (Optional)
  # 設定内容: モニタリング対象のウェブアプリケーションのトップレベルドメインを指定します。
  # 設定可能な値: 有効なドメイン名文字列（例: "example.com", "app.example.com"）
  # 省略時: domain_list を使用して複数ドメインを指定可能
  # 注意: domain と domain_list はいずれか一方を指定します
  domain = "example.com"

  # domain_list (Optional)
  # 設定内容: モニタリング対象のドメインのリストを指定します。複数ドメインをモニタリングする場合に使用します。
  # 設定可能な値: ドメイン名文字列のリスト
  # 省略時: domain を使用して単一ドメインを指定可能
  # 注意: domain と domain_list はいずれか一方を指定します
  domain_list = null

  #-------------------------------------------------------------
  # CloudWatch Logs 設定
  #-------------------------------------------------------------

  # cw_log_enabled (Optional)
  # 設定内容: RUM が収集したデータを CloudWatch Logs に送信するかを指定します。
  # 設定可能な値:
  #   - true: CloudWatch Logs へのデータ送信を有効化
  #   - false: CloudWatch Logs へのデータ送信を無効化
  # 省略時: false
  cw_log_enabled = false

  #-------------------------------------------------------------
  # アプリモニター設定
  #-------------------------------------------------------------

  # app_monitor_configuration (Optional)
  # 設定内容: アプリモニターの詳細設定ブロックです。
  # テレメトリの種類、対象ページ、セッションサンプリング率などを制御します。
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM-get-started-authorization.html
  app_monitor_configuration {

    # allow_cookies (Optional)
    # 設定内容: RUM がユーザーの X-Amzn-RUM-Auth Cookie を使用してセッションを延長するかを指定します。
    # 設定可能な値:
    #   - true: Cookie を使用してセッション延長を許可
    #   - false: Cookie を使用しない
    # 省略時: false
    allow_cookies = false

    # enable_xray (Optional)
    # 設定内容: RUM が X-Ray トレーシングと連携するかを指定します。
    # 設定可能な値:
    #   - true: X-Ray トレーシングを有効化
    #   - false: X-Ray トレーシングを無効化
    # 省略時: false
    enable_xray = false

    # excluded_pages (Optional)
    # 設定内容: モニタリング対象から除外するページ URL のセットを指定します。
    # 設定可能な値: URL パターン文字列のセット（例: "https://example.com/admin"）
    # 省略時: ページの除外なし
    excluded_pages = []

    # favorite_pages (Optional)
    # 設定内容: お気に入りページとして登録するページ URL のセットを指定します。
    # 設定可能な値: URL パターン文字列のセット
    # 省略時: お気に入りページなし
    favorite_pages = []

    # included_pages (Optional)
    # 設定内容: モニタリング対象に含めるページ URL のセットを指定します。
    # 設定可能な値: URL パターン文字列のセット（例: "https://example.com/app/*"）
    # 省略時: すべてのページを対象
    included_pages = []

    # guest_role_arn (Optional)
    # 設定内容: RUM ウェブクライアントが使用する Cognito ID プール未認証ロールの ARN を指定します。
    # 設定可能な値: 有効な IAM ロール ARN
    # 省略時: identity_pool_id と合わせて指定することを推奨
    guest_role_arn = null

    # identity_pool_id (Optional)
    # 設定内容: RUM ウェブクライアントが認証に使用する Amazon Cognito ID プールの ID を指定します。
    # 設定可能な値: 有効な Cognito ID プール ID（例: "ap-northeast-1:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"）
    # 省略時: 匿名認証を使用
    identity_pool_id = null

    # session_sample_rate (Optional)
    # 設定内容: RUM セッションをモニタリング対象とするサンプリング率を指定します。
    # 設定可能な値: 0.0〜1.0 の数値（例: 0.1 = 10%のセッションをサンプリング）
    # 省略時: 0.1（10%）
    session_sample_rate = 0.1

    # telemetries (Optional)
    # 設定内容: 収集するテレメトリデータの種類のセットを指定します。
    # 設定可能な値:
    #   - "errors": JavaScript エラーとページロード中のエラーを収集
    #   - "performance": ページロードのパフォーマンスデータを収集
    #   - "http": HTTP リクエストのデータを収集
    # 省略時: テレメトリデータを収集しない
    telemetries = ["errors", "performance", "http"]
  }

  #-------------------------------------------------------------
  # カスタムイベント設定
  #-------------------------------------------------------------

  # custom_events (Optional)
  # 設定内容: カスタムイベントの有効化設定ブロックです。
  # アプリケーションが RUM に送信するカスタムイベントを制御します。
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM-custom-events.html
  custom_events {

    # status (Optional)
    # 設定内容: カスタムイベントの収集を有効にするかを指定します。
    # 設定可能な値:
    #   - "ENABLED": カスタムイベントの収集を有効化
    #   - "DISABLED": カスタムイベントの収集を無効化
    # 省略時: "DISABLED"
    status = "DISABLED"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-rum-app-monitor"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - app_monitor_id: アプリモニターの一意な識別子
# - arn: アプリモニターの Amazon Resource Name (ARN)
# - cw_log_group: CloudWatch Logs が有効な場合のロググループ名
# - id: アプリモニターの名前（name と同じ）
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
