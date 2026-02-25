#---------------------------------------------------------------
# Amazon CloudWatch Internet Monitor - Monitor
#---------------------------------------------------------------
#
# Amazon CloudWatch Internet Monitorのモニターをプロビジョニングするリソースです。
# Internet Monitorは、AWSでホストされたアプリケーションのエンドユーザーに影響する
# インターネット上の問題に対する可視性を提供します。AWSのグローバルネットワークデータを
# 活用してインターネットトラフィックのベースラインを確立し、パフォーマンスと可用性の
# 問題を検出します。
#
# AWS公式ドキュメント:
#   - Internet Monitor概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-InternetMonitor.html
#   - モニターの作成: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-IM-working-with.create.html
#   - 詳細設定オプション: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-IM-get-started.advanced-options.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internetmonitor_monitor
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_internetmonitor_monitor" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # monitor_name (Required)
  # 設定内容: モニターの名前を指定します。
  # 設定可能な値: 文字列（一意な名前）
  monitor_name = "example-monitor"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # モニタリング対象リソース設定
  #-------------------------------------------------------------

  # resources (Optional)
  # 設定内容: モニターに含めるAWSリソースのARNセットを指定します。
  # 設定可能な値: 有効なAWSリソースARNのセット（VPC、CloudFrontディストリビューション等）
  # 省略時: モニタリング対象リソースなし
  # 注意: 各モニターには同一種類のリソースのみ指定可能。VPCを追加する場合は
  #       インターネットゲートウェイが設定されている必要があります。
  resources = [
    "arn:aws:ec2:ap-northeast-1:123456789012:vpc/vpc-12345678"
  ]

  #-------------------------------------------------------------
  # トラフィック監視設定
  #-------------------------------------------------------------

  # traffic_percentage_to_monitor (Optional)
  # 設定内容: Internet Monitorでモニタリングするアプリケーションのインターネット
  #           向きトラフィックの割合を指定します。
  # 設定可能な値: 1〜100の整数（パーセンテージ）
  # 省略時: 設定なし
  traffic_percentage_to_monitor = 100

  # max_city_networks_to_monitor (Optional)
  # 設定内容: リソースに対してモニタリングするシティネットワークの最大数を指定します。
  #           シティネットワークとは、クライアントがアプリケーションのリソースに
  #           アクセスする際の場所（都市）とネットワーク（ISP等のASN）の組み合わせです。
  #           この上限を設定することでInternet Monitorの料金を予測可能にできます。
  # 設定可能な値: 正の整数（デフォルトは500000）
  # 省略時: 設定なし
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-IM-working-with.create.html
  max_city_networks_to_monitor = 500000

  #-------------------------------------------------------------
  # モニターステータス設定
  #-------------------------------------------------------------

  # status (Optional)
  # 設定内容: モニターのステータスを指定します。
  # 設定可能な値:
  #   - "ACTIVE": モニターを有効化してモニタリングを実行
  #   - "INACTIVE": モニターを無効化
  # 省略時: 設定なし
  status = "ACTIVE"

  #-------------------------------------------------------------
  # ヘルスイベント設定
  #-------------------------------------------------------------

  # health_events_config (Optional)
  # 設定内容: ヘルスイベントのしきい値を設定するブロックです。
  #           パフォーマンスと可用性のしきい値パーセンテージによって、
  #           Internet Monitorがインターネット上の問題がアプリケーションの
  #           エンドユーザーに影響した場合にヘルスイベントを作成するタイミングを制御します。
  # 関連機能: Internet Monitor ヘルスイベント
  #   ヘルスイベントのしきい値をカスタマイズすることで、特定の地域に集中している
  #   クライアントへの影響をより詳細に監視できます。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-IM-get-started.change-threshold.html
  health_events_config {

    # availability_score_threshold (Optional)
    # 設定内容: 可用性スコアのヘルスイベントしきい値パーセンテージを指定します。
    # 設定可能な値: 0〜100の数値（パーセンテージ）
    # 省略時: 設定なし
    availability_score_threshold = 96

    # performance_score_threshold (Optional)
    # 設定内容: パフォーマンススコアのヘルスイベントしきい値パーセンテージを指定します。
    # 設定可能な値: 0〜100の数値（パーセンテージ）
    # 省略時: 設定なし
    performance_score_threshold = 96
  }

  #-------------------------------------------------------------
  # インターネット計測ログ配信設定
  #-------------------------------------------------------------

  # internet_measurements_log_delivery (Optional)
  # 設定内容: Internet MonitorのインターネットメジャーメントをAmazon S3バケットに
  #           CloudWatch Logsに加えて追加公開するための設定ブロックです。
  # 関連機能: Internet Monitor S3ログ配信
  #   全モニタリング済みシティネットワークのインターネット計測データをS3に保存。
  #   S3に公開してもCloudWatch Logsへの公開は継続されます。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-IM-get-started.Publish-to-S3.html
  internet_measurements_log_delivery {

    # s3_config (Optional)
    # 設定内容: インターネット計測の公開先S3バケットの設定ブロックです。
    s3_config {

      # bucket_name (Required)
      # 設定内容: インターネット計測を公開するS3バケット名を指定します。
      # 設定可能な値: 有効なS3バケット名
      bucket_name = "example-internetmonitor-logs"

      # bucket_prefix (Optional)
      # 設定内容: S3バケット内のカスタムプレフィックスを指定します。
      # 設定可能な値: 有効なS3オブジェクトキープレフィックス文字列
      # 省略時: プレフィックスなし
      bucket_prefix = "internet-monitor/"

      # log_delivery_status (Optional)
      # 設定内容: S3へのログ配信のステータスを指定します。
      # 設定可能な値:
      #   - "ENABLED": S3へのログ配信を有効化
      #   - "DISABLED": S3へのログ配信を無効化
      # 省略時: 設定なし
      log_delivery_status = "ENABLED"
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-internetmonitor"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: モニターのAmazon Resource Name (ARN)
# - id: モニターの名前
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
