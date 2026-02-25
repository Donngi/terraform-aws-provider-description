#---------------------------------------------------------------
# AWS Global Accelerator Custom Routing Accelerator
#---------------------------------------------------------------
#
# AWS Global Acceleratorのカスタムルーティングアクセラレーターをプロビジョニングするリソースです。
# カスタムルーティングアクセラレーターは、独自のアプリケーションロジックを使用してトラフィックを
# VPCサブネット内の特定のAmazon EC2インスタンスに確定的にルーティングするために使用します。
# ゲームアプリケーションやVoIPセッションなど、特定のECインスタンスとポートに
# ユーザーをルーティングする必要があるユースケースに適しています。
#
# AWS公式ドキュメント:
#   - カスタムルーティングアクセラレーター概要: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-custom-routing-accelerators.html
#   - カスタムルーティングの仕組み: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-custom-routing-how-it-works.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_custom_routing_accelerator
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_globalaccelerator_custom_routing_accelerator" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: カスタムルーティングアクセラレーターの名前を指定します。
  # 設定可能な値: 最大64文字の文字列（英数字、ハイフン）
  name = "example-custom-routing-accelerator"

  # enabled (Optional)
  # 設定内容: アクセラレーターを有効にするかを指定します。
  # 設定可能な値:
  #   - true: アクセラレーターを有効化（トラフィックのルーティングを開始）
  #   - false: アクセラレーターを無効化（トラフィックのルーティングを停止）
  # 省略時: true
  enabled = true

  #-------------------------------------------------------------
  # IPアドレス設定
  #-------------------------------------------------------------

  # ip_address_type (Optional)
  # 設定内容: アクセラレーターがサポートするIPアドレスタイプを指定します。
  # 設定可能な値:
  #   - "IPV4": IPv4アドレスを使用（カスタムルーティングアクセラレーターはIPV4のみサポート）
  # 省略時: "IPV4"
  # 注意: カスタムルーティングアクセラレーターはIPv4のみをサポートしています。
  ip_address_type = "IPV4"

  # ip_addresses (Optional)
  # 設定内容: BYOIPアクセラレーターに使用するIPアドレスのリストを指定します。
  # 設定可能な値: 1または2つのIPv4アドレスのリスト
  # 省略時: AWSサービスがIPアドレスを自動割り当てします。
  # 注意: 自身のIPアドレス範囲をAWSに持ち込む（BYOIP）場合にのみ指定します。
  #       IPアドレスはアクセラレーターが存在する間は割り当てられ続けますが、
  #       アクセラレーターを削除するとIPアドレスは失われます。
  # 参考: https://docs.aws.amazon.com/global-accelerator/latest/dg/using-byoip.html
  ip_addresses = ["1.2.3.4"]

  #-------------------------------------------------------------
  # フローログ設定
  #-------------------------------------------------------------

  # attributes (Optional)
  # 設定内容: アクセラレーターのフローログを設定するブロックです。
  # 関連機能: Global Accelerator フローログ
  #   アクセラレーターを経由するトラフィックの詳細なログを収集してS3に保存します。
  #   - https://docs.aws.amazon.com/global-accelerator/latest/dg/monitoring-global-accelerator.flow-logs.html
  attributes {

    # flow_logs_enabled (Optional)
    # 設定内容: フローログの収集を有効にするかを指定します。
    # 設定可能な値:
    #   - true: フローログを有効化（S3バケットとプレフィックスの指定が必要）
    #   - false: フローログを無効化
    # 省略時: false
    flow_logs_enabled = true

    # flow_logs_s3_bucket (Optional)
    # 設定内容: フローログを保存するAmazon S3バケット名を指定します。
    # 設定可能な値: 有効なS3バケット名
    # 注意: flow_logs_enabled が true の場合は必須です。
    flow_logs_s3_bucket = "example-flow-logs-bucket"

    # flow_logs_s3_prefix (Optional)
    # 設定内容: フローログを保存するS3バケット内のプレフィックス（パス）を指定します。
    # 設定可能な値: S3オブジェクトキープレフィックスの文字列
    # 注意: flow_logs_enabled が true の場合は必須です。
    flow_logs_s3_prefix = "flow-logs/"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" など時間単位の文字列
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" など時間単位の文字列
    update = "30m"
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
    Name        = "example-custom-routing-accelerator"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: カスタムルーティングアクセラレーターのAmazon Resource Name (ARN)
#
# - dns_name: アクセラレーターのDNS名
#             例: a5d53ff5ee6bca4ce.awsglobalaccelerator.com
#
# - hosted_zone_id: Global AcceleratorのRoute 53ゾーンID
#                   エイリアスリソースレコードセットのルーティングに使用可能
#                   （Z2BJ6XQ5FK7U4Hの別名）
#
# - ip_sets: アクセラレーターに関連付けられたIPアドレスセット
#            各セットにip_addresses（IPアドレスリスト）とip_family（IPファミリー種別）を含む
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
