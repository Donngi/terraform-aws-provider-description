#---------------------------------------------------------------
# Amazon Managed Service for Prometheus Scraper
#---------------------------------------------------------------
#
# Amazon Managed Service for Prometheus のフルマネージドコレクター（スクレイパー）を
# プロビジョニングするリソースです。EKSクラスターからPrometheus互換メトリクスを自動収集し、
# Amazon Managed Service for Prometheus ワークスペースに送信します。
# エージェントのインストール・パッチ・管理が不要なサーバーレス型のメトリクス収集機能です。
#
# 注意: ソース（EKSクラスター）を変更した場合、Terraformは現在のスクレイパーを
#       削除して新しいスクレイパーを作成します。
#
# AWS公式ドキュメント:
#   - Amazon Managed Service for Prometheus マネージドコレクター: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-collector.html
#   - EKS向けマネージドコレクターの設定: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-collector-how-to.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_scraper
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_prometheus_scraper" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # alias (Optional)
  # 設定内容: スクレイパーに関連付けるエイリアス名を指定します。
  # 設定可能な値: 任意の文字列（一意である必要はありません）
  # 省略時: エイリアスなし
  alias = "my-prometheus-scraper"

  # scrape_configuration (Required)
  # 設定内容: スクレイパーが使用するPrometheusスクレイプ設定ファイルの内容を指定します。
  #           YAMLフォーマットのスクレイプ設定を文字列として渡します。
  # 設定可能な値: Prometheus設定ファイル形式のYAML文字列
  # 参考: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-collector-how-to.html#AMP-collector-configuration
  scrape_configuration = <<-EOT
    global:
      scrape_interval: 30s
    scrape_configs:
      - job_name: pod_exporter
        kubernetes_sd_configs:
          - role: pod
  EOT

  #-------------------------------------------------------------
  # ソース設定
  #-------------------------------------------------------------

  # source (Required)
  # 設定内容: マネージドスクレイパーがメトリクスを収集するソースの設定ブロックです。
  # 参考: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-collector.html
  source {

    # eks (Required)
    # 設定内容: メトリクス収集元のEKSクラスターを指定する設定ブロックです。
    # 関連機能: Amazon EKS マネージドスクレイパー
    #   EKSクラスターのVPC内にElastic Network Interface (ENI) を作成して接続し、
    #   Prometheusメトリクスをスクレイプします。
    #   - https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-collector-how-to.html
    eks {

      # cluster_arn (Required)
      # 設定内容: メトリクス収集元のEKSクラスターのARNを指定します。
      # 設定可能な値: 有効なEKSクラスターARN
      cluster_arn = "arn:aws:eks:ap-northeast-1:123456789012:cluster/my-cluster"

      # subnet_ids (Required)
      # 設定内容: EKSクラスターのVPCに接続するためのサブネットIDのセットを指定します。
      # 設定可能な値: 有効なサブネットIDのセット
      # 注意: 少なくとも2つの異なるアベイラビリティゾーンのサブネットを指定する必要があります
      subnet_ids = [
        "subnet-12345678",
        "subnet-87654321",
      ]

      # security_group_ids (Optional)
      # 設定内容: EKSクラスターのVPC設定に適用するセキュリティグループIDのセットを指定します。
      # 設定可能な値: 有効なセキュリティグループIDのセット
      # 省略時: EKSクラスターのセキュリティグループが自動的に使用されます
      security_group_ids = [
        "sg-12345678",
      ]
    }
  }

  #-------------------------------------------------------------
  # 送信先設定
  #-------------------------------------------------------------

  # destination (Required)
  # 設定内容: マネージドスクレイパーがメトリクスを送信する宛先の設定ブロックです。
  destination {

    # amp (Required)
    # 設定内容: 送信先のAmazon Managed Service for Prometheusワークスペースの設定ブロックです。
    # 関連機能: Amazon Managed Service for Prometheus ワークスペース
    #   収集したメトリクスの保存・クエリを行うワークスペース。
    #   - https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-onboard-create-workspace.html
    amp {

      # workspace_arn (Required)
      # 設定内容: メトリクスの送信先Amazon Managed Service for PrometheusワークスペースのARNを指定します。
      # 設定可能な値: 有効なAMPワークスペースARN
      workspace_arn = "arn:aws:aps:ap-northeast-1:123456789012:workspace/ws-12345678-1234-1234-1234-123456789012"
    }
  }

  #-------------------------------------------------------------
  # クロスアカウントロール設定
  #-------------------------------------------------------------

  # role_configuration (Optional)
  # 設定内容: 別アカウントのAmazon Managed Service for Prometheusワークスペースへの
  #           書き込みを有効にするためのIAMロール設定ブロックです。
  # 関連機能: クロスアカウントスクレイパー設定
  #   ソースアカウントとターゲットアカウントを跨いだメトリクス収集を実現します。
  #   - https://docs.aws.amazon.com/prometheus/latest/APIReference/API_CreateScraper.html
  role_configuration {

    # source_role_arn (Optional)
    # 設定内容: ソースアカウント側のIAMロールARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 省略時: スクレイパー作成時に自動生成されたIAMロールを使用
    source_role_arn = "arn:aws:iam::123456789012:role/source-scraper-role"

    # target_role_arn (Optional)
    # 設定内容: ターゲットアカウント側のIAMロールARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 省略時: 同一アカウント内での送信を前提とした設定になります
    target_role_arn = "arn:aws:iam::999999999999:role/target-amp-role"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
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
  tags = {
    Name        = "my-prometheus-scraper"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定する設定ブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" のような期間文字列。使用可能な単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" のような期間文字列。使用可能な単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" のような期間文字列。使用可能な単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: スクレイパーのAmazon Resource Name (ARN)
#
# - role_arn: スクレイパーがメトリクスを検出・収集・生成するための
#             IAMロールのARN（自動生成）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - id: スクレイパーの一意なID
#---------------------------------------------------------------
