#---------------------------------------------------------------
# AWS Route 53 Resolver Endpoint
#---------------------------------------------------------------
#
# Amazon Route 53 ResolverのエンドポイントをプロビジョニングするリソースJです。
# Resolver エンドポイントには受信（Inbound）と送信（Outbound）の2種類があります。
# 受信エンドポイントはオンプレミスネットワークからVPCへDNSクエリを転送し、
# 送信エンドポイントはVPCからオンプレミスネットワークへDNSクエリを転送します。
#
# AWS公式ドキュメント:
#   - Route 53 Resolverの概要: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-overview-DSN-queries-to-vpc.html
#   - CreateResolverEndpoint APIリファレンス: https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53resolver_CreateResolverEndpoint.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_resolver_endpoint" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # direction (Required)
  # 設定内容: DNSクエリの方向を指定します。
  # 設定可能な値:
  #   - "INBOUND": オンプレミスまたは別VPCからVPCのDNSサービスへクエリを転送
  #   - "OUTBOUND": VPCのDNSサービスからオンプレミスまたは別VPCへクエリを転送
  #   - "INBOUND_DELEGATION": オンプレミスからRoute 53プライベートホストゾーンへクエリを委任
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-overview-DSN-queries-to-vpc.html
  direction = "INBOUND"

  # name (Optional)
  # 設定内容: Route 53 Resolverエンドポイントのフレンドリー名を指定します。
  # 設定可能な値: 最大64文字の英数字、ハイフン、アンダースコアを含む文字列
  # 省略時: 名前なしで作成されます
  name = "example-resolver-endpoint"

  # security_group_ids (Required)
  # 設定内容: このVPCへのアクセス制御に使用するセキュリティグループIDのセットを指定します。
  # 設定可能な値: 有効なセキュリティグループIDのセット
  # 注意: 作成後は変更不可（変更するにはリソースの再作成が必要）
  security_group_ids = [
    "sg-12345678",
    "sg-87654321",
  ]

  #-------------------------------------------------------------
  # エンドポイントタイプ設定
  #-------------------------------------------------------------

  # resolver_endpoint_type (Optional)
  # 設定内容: エンドポイントのIPアドレスタイプを指定します。このタイプは全IPアドレスに適用されます。
  # 設定可能な値:
  #   - "IPV4": IPv4アドレスのみ使用
  #   - "IPV6": IPv6アドレスのみ使用
  #   - "DUALSTACK": IPv4とIPv6の両方を使用
  # 省略時: "IPV4"が適用されます
  resolver_endpoint_type = "IPV4"

  # protocols (Optional)
  # 設定内容: Route 53 Resolverエンドポイントで使用するプロトコルのセットを指定します。
  # 設定可能な値:
  #   - "Do53": 標準DNS（DNS over Port 53）
  #   - "DoH": DNS over HTTPS（暗号化DNS）
  #   - "DoH-FIPS": FIPS準拠のDNS over HTTPS
  # 省略時: "Do53"が適用されます
  # 参考: https://aws.amazon.com/blogs/networking-and-content-delivery/encrypt-dns-queries-using-dns-over-https-doh-with-amazon-route-53-resolver-endpoints/
  protocols = ["Do53"]

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
  # メトリクス設定
  #-------------------------------------------------------------

  # rni_enhanced_metrics_enabled (Optional)
  # 設定内容: ResolverネットワークインターフェイスのCloudWatch拡張メトリクスを有効にするかを指定します。
  # 設定可能な値:
  #   - true: 拡張メトリクスを有効化。CloudWatchでエンドポイントに関連する各RNIの1分粒度メトリクスを提供
  #   - false: 拡張メトリクスを無効化
  # 省略時: false
  # 注意: 一度trueに設定した後falseに戻す場合は、引数を削除するのではなく明示的にfalseを指定する必要があります
  # 注意: INBOUNDエンドポイントではサポートされません
  rni_enhanced_metrics_enabled = false

  # target_name_server_metrics_enabled (Optional)
  # 設定内容: 送信Resolverエンドポイントのターゲットネームサーバーメトリクスを有効にするかを指定します。
  # 設定可能な値:
  #   - true: ターゲットネームサーバーメトリクスを有効化。CloudWatchで各ターゲットネームサーバーの1分粒度メトリクスを提供
  #   - false: メトリクスを無効化
  # 省略時: false
  # 注意: OUTBOUNDエンドポイントにのみ適用されます
  # 注意: 一度trueに設定した後falseに戻す場合は、引数を削除するのではなく明示的にfalseを指定する必要があります
  target_name_server_metrics_enabled = false

  #-------------------------------------------------------------
  # IPアドレス設定
  #-------------------------------------------------------------

  # ip_address (Required)
  # 設定内容: エンドポイントが使用するサブネットとIPアドレスの設定ブロックです。
  #   送信エンドポイントの場合: VPCからオンプレミスへのクエリが通過するサブネットとIPアドレス
  #   受信エンドポイントの場合: オンプレミスからVPCへのクエリを受け取るサブネットとIPアドレス
  # 注意: 最低2個、最大10個のip_addressブロックを指定する必要があります
  # 注意: 高可用性のため異なるアベイラビリティーゾーンのサブネットを指定することを推奨します
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-overview-DSN-queries-to-vpc.html
  ip_address {
    # subnet_id (Required)
    # 設定内容: IPアドレスを含むサブネットのIDを指定します。
    # 設定可能な値: 有効なサブネットID
    subnet_id = "subnet-12345678"

    # ip (Optional)
    # 設定内容: DNSクエリに使用するサブネット内のIPv4アドレスを指定します。
    # 設定可能な値: サブネット内の有効なIPv4アドレス
    # 省略時: AWSがサブネット内のIPv4アドレスを自動的に選択します
    ip = null

    # ipv6 (Optional)
    # 設定内容: DNSクエリに使用するサブネット内のIPv6アドレスを指定します。
    # 設定可能な値: サブネット内の有効なIPv6アドレス
    # 省略時: AWSがサブネット内のIPv6アドレスを自動的に選択します
    # 注意: resolver_endpoint_typeが"IPV6"または"DUALSTACK"の場合に使用
    ipv6 = null
  }

  ip_address {
    # subnet_id (Required)
    # 設定内容: IPアドレスを含むサブネットのIDを指定します。
    # 設定可能な値: 有効なサブネットID
    # 注意: 高可用性のため異なるAZのサブネットを指定することを推奨します
    subnet_id = "subnet-87654321"

    # ip (Optional)
    # 設定内容: DNSクエリに使用するサブネット内のIPv4アドレスを指定します。
    # 設定可能な値: サブネット内の有効なIPv4アドレス
    # 省略時: AWSがサブネット内のIPv4アドレスを自動的に選択します
    ip = null

    # ipv6 (Optional)
    # 設定内容: DNSクエリに使用するサブネット内のIPv6アドレスを指定します。
    # 設定可能な値: サブネット内の有効なIPv6アドレス
    # 省略時: AWSがサブネット内のIPv6アドレスを自動的に選択します
    ipv6 = null
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間の設定ブロックです。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "60m"、"2h" などのDuration文字列
    # 省略時: デフォルトのタイムアウト時間が適用されます
    create = "10m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "60m"、"2h" などのDuration文字列
    # 省略時: デフォルトのタイムアウト時間が適用されます
    update = "10m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "60m"、"2h" などのDuration文字列
    # 省略時: デフォルトのタイムアウト時間が適用されます
    delete = "10m"
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
    Name        = "example-resolver-endpoint"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Route 53 ResolverエンドポイントのARN
# - host_vpc_id: ResolverエンドポイントのホストVPCのID
# - id: Route 53 ResolverエンドポイントのID
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
