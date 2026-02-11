#---------------------------------------------------------------
# VPC Reachability Analyzer Network Insights Path
#---------------------------------------------------------------
#
# VPC Reachability Analyzerで使用するNetwork Insights Pathをプロビジョニングするリソースです。
# Network Insights Pathは、VPC内のリソース間のネットワーク到達可能性を分析するための
# パス定義を表し、送信元と宛先の間のネットワーク経路を検証します。
#
# AWS公式ドキュメント:
#   - Reachability Analyzer概要: https://docs.aws.amazon.com/vpc/latest/userguide/reachability-analyzer.html
#   - Reachability Analyzer開始ガイド: https://docs.aws.amazon.com/vpc/latest/reachability/getting-started.html
#   - CreateNetworkInsightsPath API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateNetworkInsightsPath.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_network_insights_path
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_network_insights_path" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # source (Required)
  # 設定内容: パスの送信元となるリソースのIDまたはARNを指定します。
  # 設定可能な値: 以下のリソースのIDまたはARN
  #   - EC2インスタンス
  #   - インターネットゲートウェイ
  #   - ネットワークインターフェイス
  #   - Transit Gateway
  #   - VPCエンドポイント
  #   - VPCピアリング接続
  #   - VPNゲートウェイ
  # 注意: リソースが別のアカウントにある場合は、ARNを指定する必要があります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/reachability/getting-started.html
  source = "eni-0123456789abcdef0"

  # protocol (Required)
  # 設定内容: 分析に使用するプロトコルを指定します。
  # 設定可能な値:
  #   - "tcp": TCP プロトコル
  #   - "udp": UDP プロトコル
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateNetworkInsightsPath.html
  protocol = "tcp"

  #-------------------------------------------------------------
  # 送信元設定
  #-------------------------------------------------------------

  # source_ip (Optional)
  # 設定内容: 送信元リソースのIPアドレスを指定します。
  # 設定可能な値: 有効なIPv4アドレス
  # 省略時: 送信元リソースのプライマリIPアドレスが使用されます
  # 注意: filter_at_sourceを指定する場合、このパラメータは指定できません。
  source_ip = null

  #-------------------------------------------------------------
  # 宛先設定
  #-------------------------------------------------------------

  # destination (Optional)
  # 設定内容: パスの宛先となるリソースのIDまたはARNを指定します。
  # 設定可能な値: 以下のリソースのIDまたはARN
  #   - EC2インスタンス
  #   - インターネットゲートウェイ
  #   - ネットワークインターフェイス
  #   - Transit Gateway
  #   - VPCエンドポイント
  #   - VPCピアリング接続
  #   - VPNゲートウェイ
  # 省略時: filter_at_source内のdestination_addressを使用する必要があります
  # 注意: リソースが別のアカウントにある場合は、ARNを指定する必要があります。
  #       destinationまたはfilter_at_source内のdestination_addressのいずれかを指定する必要があります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/reachability/getting-started.html
  destination = "eni-0fedcba9876543210"

  # destination_ip (Optional)
  # 設定内容: 宛先リソースのIPアドレスを指定します。
  # 設定可能な値: 有効なIPv4アドレス
  # 省略時: 宛先リソースのプライマリIPアドレスが使用されます
  # 注意: filter_at_destinationを指定する場合、このパラメータは指定できません。
  destination_ip = null

  # destination_port (Optional)
  # 設定内容: アクセスを分析する宛先ポート番号を指定します。
  # 設定可能な値: 1-65535の整数
  # 省略時: ポート番号の制約なしで分析が実行されます
  # 注意: filter_at_sourceを指定する場合、このパラメータは指定できません。
  destination_port = null

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
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-network-insights-path"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: リソースに割り当てられたすべてのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: プロバイダーのdefault_tags設定ブロックから継承されたタグが使用されます
  # 注意: このパラメータはComputedであり、通常は明示的に設定する必要はありません。
  tags_all = null

  #-------------------------------------------------------------
  # フィルター設定（送信元）
  #-------------------------------------------------------------

  # filter_at_source (Optional)
  # 設定内容: 送信元で特定のフィルターに一致するネットワークパスに分析範囲を絞り込みます。
  # 注意: このパラメータを指定する場合、source_ipまたはdestination_portは指定できません。
  #       Terraformは、値が提供された場合にのみこの引数のドリフト検出を実行します。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateNetworkInsightsPath.html
  # filter_at_source {
  #   # destination_address (Optional)
  #   # 設定内容: 宛先IPv4アドレスを指定します。
  #   # 設定可能な値: 有効なIPv4アドレス
  #   destination_address = "10.0.2.0"
  #
  #   # source_address (Optional)
  #   # 設定内容: 送信元IPv4アドレスを指定します。
  #   # 設定可能な値: 有効なIPv4アドレス
  #   source_address = "10.0.1.0"
  #
  #   # destination_port_range (Optional)
  #   # 設定内容: 宛先ポート範囲を指定します。
  #   # destination_port_range {
  #   #   # from_port (Optional)
  #   #   # 設定内容: ポート範囲の最初のポート番号を指定します。
  #   #   # 設定可能な値: 1-65535の整数
  #   #   from_port = 80
  #   #
  #   #   # to_port (Optional)
  #   #   # 設定内容: ポート範囲の最後のポート番号を指定します。
  #   #   # 設定可能な値: 1-65535の整数
  #   #   to_port = 80
  #   # }
  #
  #   # source_port_range (Optional)
  #   # 設定内容: 送信元ポート範囲を指定します。
  #   # source_port_range {
  #   #   # from_port (Optional)
  #   #   # 設定内容: ポート範囲の最初のポート番号を指定します。
  #   #   # 設定可能な値: 1-65535の整数
  #   #   from_port = 1024
  #   #
  #   #   # to_port (Optional)
  #   #   # 設定内容: ポート範囲の最後のポート番号を指定します。
  #   #   # 設定可能な値: 1-65535の整数
  #   #   to_port = 65535
  #   # }
  # }

  #-------------------------------------------------------------
  # フィルター設定（宛先）
  #-------------------------------------------------------------

  # filter_at_destination (Optional)
  # 設定内容: 宛先で特定のフィルターに一致するネットワークパスに分析範囲を絞り込みます。
  # 注意: このパラメータを指定する場合、destination_ipは指定できません。
  #       Terraformは、値が提供された場合にのみこの引数のドリフト検出を実行します。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateNetworkInsightsPath.html
  # filter_at_destination {
  #   # destination_address (Optional)
  #   # 設定内容: 宛先IPv4アドレスを指定します。
  #   # 設定可能な値: 有効なIPv4アドレス
  #   destination_address = "10.0.2.0"
  #
  #   # source_address (Optional)
  #   # 設定内容: 送信元IPv4アドレスを指定します。
  #   # 設定可能な値: 有効なIPv4アドレス
  #   source_address = "10.0.1.0"
  #
  #   # destination_port_range (Optional)
  #   # 設定内容: 宛先ポート範囲を指定します。
  #   # destination_port_range {
  #   #   # from_port (Optional)
  #   #   # 設定内容: ポート範囲の最初のポート番号を指定します。
  #   #   # 設定可能な値: 1-65535の整数
  #   #   from_port = 443
  #   #
  #   #   # to_port (Optional)
  #   #   # 設定内容: ポート範囲の最後のポート番号を指定します。
  #   #   # 設定可能な値: 1-65535の整数
  #   #   to_port = 443
  #   # }
  #
  #   # source_port_range (Optional)
  #   # 設定内容: 送信元ポート範囲を指定します。
  #   # source_port_range {
  #   #   # from_port (Optional)
  #   #   # 設定内容: ポート範囲の最初のポート番号を指定します。
  #   #   # 設定可能な値: 1-65535の整数
  #   #   from_port = 1024
  #   #
  #   #   # to_port (Optional)
  #   #   # 設定内容: ポート範囲の最後のポート番号を指定します。
  #   #   # 設定可能な値: 1-65535の整数
  #   #   to_port = 65535
  #   # }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Network Insights PathのAmazon Resource Name (ARN)
#
# - destination_arn: 宛先のAmazon Resource Name (ARN)
#
# - id: Network Insights PathのID
#
# - source_arn: 送信元のAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
