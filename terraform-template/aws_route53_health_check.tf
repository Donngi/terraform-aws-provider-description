#---------------------------------------------------------------
# Amazon Route 53 Health Check
#---------------------------------------------------------------
#
# Amazon Route 53のヘルスチェックをプロビジョニングするリソースです。
# エンドポイントの死活監視を行い、DNSフェイルオーバーの基盤として機能します。
# HTTP/HTTPS/TCP接続チェック、文字列一致チェック、CALCULATED（集約チェック）、
# CloudWatchアラーム連携、Arc Recovery Controlなど多様なタイプをサポートします。
#
# AWS公式ドキュメント:
#   - Route 53 ヘルスチェックの概要: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/welcome-health-checks.html
#   - ヘルスチェックタイプ: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/health-checks-types.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_health_check
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_health_check" "example" {
  #-------------------------------------------------------------
  # ヘルスチェック種別設定
  #-------------------------------------------------------------

  # type (Required)
  # 設定内容: ヘルスチェック実行時に使用するプロトコルを指定します。
  # 設定可能な値:
  #   - "HTTP": HTTPステータスコードによる接続チェック
  #   - "HTTPS": HTTPSステータスコードによる接続チェック
  #   - "HTTP_STR_MATCH": HTTPレスポンスボディの文字列一致チェック
  #   - "HTTPS_STR_MATCH": HTTPSレスポンスボディの文字列一致チェック
  #   - "TCP": TCP接続チェック
  #   - "CALCULATED": 子ヘルスチェックを集約する計算済みチェック
  #   - "CLOUDWATCH_METRIC": CloudWatchアラームの状態に基づくチェック
  #   - "RECOVERY_CONTROL": Arc Recovery Controlルーティングコントロールに基づくチェック
  type = "HTTP"

  #-------------------------------------------------------------
  # エンドポイント設定
  #-------------------------------------------------------------

  # fqdn (Optional)
  # 設定内容: チェック対象エンドポイントの完全修飾ドメイン名を指定します。
  # 設定可能な値: 有効なFQDN文字列（例: example.com）
  # 省略時: ip_address を直接指定する場合は省略可能
  # 注意: ip_address も指定した場合、fqdn の値はHTTPリクエストの Host ヘッダーに使用されます
  fqdn = "example.com"

  # ip_address (Optional)
  # 設定内容: チェック対象エンドポイントのIPアドレスを指定します。
  # 設定可能な値: 有効なIPv4またはIPv6アドレス文字列
  # 省略時: fqdn によりDNS解決されたアドレスを使用
  ip_address = null

  # port (Optional)
  # 設定内容: チェック対象エンドポイントのポート番号を指定します。
  # 設定可能な値: 1〜65535 の整数
  # 省略時: タイプに応じたデフォルトポート（HTTP: 80、HTTPS: 443 等）
  port = 80

  # resource_path (Optional)
  # 設定内容: ヘルスチェック実行時にAmazon Route 53がリクエストするパスを指定します。
  # 設定可能な値: "/" で始まるパス文字列（例: "/health"）
  # 省略時: パスなしでルートにリクエスト
  # 注意: type が "HTTP", "HTTPS", "HTTP_STR_MATCH", "HTTPS_STR_MATCH" の場合に有効
  resource_path = "/"

  #-------------------------------------------------------------
  # チェック間隔・閾値設定
  #-------------------------------------------------------------

  # request_interval (Optional)
  # 設定内容: Amazon Route 53がエンドポイントからレスポンスを受け取ってから
  #          次のヘルスチェックリクエストを送信するまでの秒数を指定します。
  # 設定可能な値:
  #   - 10: 高速チェック（追加コストが発生）
  #   - 30: 標準チェック
  # 省略時: 30
  request_interval = 30

  # failure_threshold (Optional)
  # 設定内容: Route 53がエンドポイントを不健全と判定するために
  #          連続して失敗する必要があるヘルスチェックの回数を指定します。
  # 設定可能な値: 1〜10 の整数
  # 省略時: 3
  failure_threshold = 3

  #-------------------------------------------------------------
  # 文字列一致設定
  #-------------------------------------------------------------

  # search_string (Optional)
  # 設定内容: ヘルスチェックを健全と判定するためにレスポンスボディ先頭5120バイト内で
  #          検索する文字列を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 文字列一致チェックなし
  # 注意: type が "HTTP_STR_MATCH" または "HTTPS_STR_MATCH" の場合のみ有効
  search_string = null

  #-------------------------------------------------------------
  # SNI・レイテンシー設定
  #-------------------------------------------------------------

  # enable_sni (Optional)
  # 設定内容: ヘルスチェック実行時にRoute 53がエンドポイントへ fqdn を送信するかを指定します。
  # 設定可能な値:
  #   - true: fqdn を TLS ハンドシェイク時の SNI として送信
  #   - false: SNI を送信しない
  # 省略時: type が "HTTPS" の場合は true、それ以外は false（AWSのデフォルト）
  enable_sni = null

  # measure_latency (Optional)
  # 設定内容: 複数のAWSリージョンのヘルスチェッカーとエンドポイント間のレイテンシーを
  #          Route 53が計測し、Route 53コンソールにCloudWatchレイテンシーグラフを
  #          表示するかを指定します。
  # 設定可能な値:
  #   - true: レイテンシー計測を有効化
  #   - false: レイテンシー計測を無効化
  # 省略時: false
  # 注意: リソース作成後は変更不可
  measure_latency = false

  #-------------------------------------------------------------
  # ヘルスチェック動作設定
  #-------------------------------------------------------------

  # invert_healthcheck (Optional)
  # 設定内容: ヘルスチェックのステータスを反転するかを指定します。
  # 設定可能な値:
  #   - true: 健全なヘルスチェックを不健全として扱い、不健全なものを健全として扱う
  #   - false: 通常のステータスを使用
  # 省略時: false
  invert_healthcheck = false

  # disabled (Optional)
  # 設定内容: Route 53によるヘルスチェックの実行を停止するかを指定します。
  # 設定可能な値:
  #   - true: ヘルスチェックを無効化（常に健全と見なされる）
  #   - false: ヘルスチェックを有効化
  # 省略時: false
  # 注意: 無効化後もDNSフェイルオーバーは継続して対応リソースへトラフィックをルーティングします。
  #       トラフィックを停止したい場合は invert_healthcheck の変更を検討してください。
  disabled = false

  #-------------------------------------------------------------
  # チェックリージョン設定
  #-------------------------------------------------------------

  # regions (Optional)
  # 設定内容: エンドポイントのチェックに使用するAWSリージョンのリストを指定します。
  # 設定可能な値:
  #   - "us-east-1", "us-west-1", "us-west-2", "eu-west-1"
  #   - "ap-southeast-1", "ap-southeast-2", "ap-northeast-1", "sa-east-1"
  # 省略時: 上記全リージョンを使用
  # 注意: 一度設定すると、この引数を削除しても変更は反映されません
  regions = null

  # reference_name (Optional)
  # 設定内容: Caller Reference の識別に使用する参照名を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 自動生成
  reference_name = null

  #-------------------------------------------------------------
  # CALCULATED（集約ヘルスチェック）設定
  #-------------------------------------------------------------

  # child_healthchecks (Optional)
  # 設定内容: 親ヘルスチェックに関連付ける子ヘルスチェックのIDセットを指定します。
  # 設定可能な値: 有効なRoute 53ヘルスチェックIDのセット
  # 省略時: 子ヘルスチェックなし
  # 注意: type = "CALCULATED" の場合に使用します
  child_healthchecks = null

  # child_health_threshold (Optional)
  # 設定内容: Route 53が親ヘルスチェックを健全と判定するために
  #          健全である必要がある子ヘルスチェックの最小数を指定します。
  # 設定可能な値: 0〜256 の整数
  # 省略時: 子ヘルスチェックなし
  # 注意: type = "CALCULATED" の場合に使用します
  child_health_threshold = null

  #-------------------------------------------------------------
  # CloudWatch アラーム連携設定
  #-------------------------------------------------------------

  # cloudwatch_alarm_name (Optional)
  # 設定内容: 連携するCloudWatchアラームの名前を指定します。
  # 設定可能な値: 有効なCloudWatchアラーム名
  # 省略時: CloudWatchアラーム連携なし
  # 注意: type = "CLOUDWATCH_METRIC" の場合に使用します
  cloudwatch_alarm_name = null

  # cloudwatch_alarm_region (Optional)
  # 設定内容: CloudWatchアラームが作成されたリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-west-2）
  # 省略時: CloudWatchアラーム連携なし
  # 注意: type = "CLOUDWATCH_METRIC" の場合に使用します
  cloudwatch_alarm_region = null

  # insufficient_data_health_status (Optional)
  # 設定内容: CloudWatchがアラームに関連するデータを持っていない場合の
  #          ヘルスチェックのステータスを指定します。
  # 設定可能な値:
  #   - "Healthy": データ不足時に健全と判定
  #   - "Unhealthy": データ不足時に不健全と判定
  #   - "LastKnownStatus": 最後に既知のステータスを維持
  # 省略時: CloudWatchアラーム連携なし
  # 注意: type = "CLOUDWATCH_METRIC" の場合に使用します
  insufficient_data_health_status = null

  #-------------------------------------------------------------
  # トリガー設定
  #-------------------------------------------------------------

  # triggers (Optional)
  # 設定内容: 変更時にCloudWatchアラーム引数のインプレース更新をトリガーする
  #          任意のキーと値のマップを指定します。
  # 設定可能な値: 文字列のキーバリューマップ
  # 省略時: トリガーなし
  # 注意: type = "CLOUDWATCH_METRIC" でアラームの設定変更を同期する際に使用します
  triggers = null

  #-------------------------------------------------------------
  # Recovery Control設定
  #-------------------------------------------------------------

  # routing_control_arn (Optional)
  # 設定内容: Route 53 Application Recovery Controllerのルーティングコントロールの
  #          ARNを指定します。
  # 設定可能な値: 有効なARC ルーティングコントロールARN
  # 省略時: Recovery Control連携なし
  # 注意: type = "RECOVERY_CONTROL" の場合に使用します
  routing_control_arn = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: ヘルスチェックに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 参考: プロバイダーレベルの default_tags と一致するキーはプロバイダー定義を上書きします
  tags = {
    Name        = "example-health-check"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ヘルスチェックのID
# - arn: ヘルスチェックのAmazon Resource Name (ARN)
# - tags_all: プロバイダーのdefault_tagsを含む全タグマップ
#---------------------------------------------------------------
