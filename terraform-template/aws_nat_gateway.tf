#---------------------------------------------------------------
# NAT Gateway
#---------------------------------------------------------------
#
# Amazon VPCのNATゲートウェイをプロビジョニングするリソースです。
# NATゲートウェイは、プライベートサブネット内のインスタンスがインターネットや
# 他のVPCに接続できるようにするNetwork Address Translation (NAT) サービスです。
# 外部サービスからこれらのインスタンスへの接続開始は防止されます。
# ゾーン型（単一AZ）とリージョナル型（マルチAZ）の2つのタイプがあり、
# パブリックとプライベートの2つの接続タイプをサポートします。
#
# AWS公式ドキュメント:
#   - NAT gateways: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html
#   - CreateNatGateway API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateNatGateway.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_nat_gateway" "example" {
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
  # 可用性モード設定
  #-------------------------------------------------------------

  # availability_mode (Optional)
  # 設定内容: ゾーン型（単一AZ）かリージョナル型（マルチAZ）のNATゲートウェイを作成するかを指定します。
  # 設定可能な値:
  #   - "zonal" (デフォルト): 単一のアベイラビリティゾーンに配置されるNATゲートウェイ
  #   - "regional": 複数のアベイラビリティゾーンに自動的に展開されるNATゲートウェイ
  # 省略時: "zonal"
  # 関連機能: Regional NAT Gateway
  #   リージョナルNATゲートウェイは、VPC内の複数のアベイラビリティゾーンに自動的に展開され、
  #   高可用性を提供します。新しいAZの検出時に自動的に拡張し、EIPを関連付けます（autoモード）。
  #   availability_zone_addressブロックを指定すると、手動モードで動作します。
  # 注意: リージョナルモードの場合、connectivity_typeは"public"である必要があります
  availability_mode = "zonal"

  # vpc_id (Optional, regional NAT gateways only)
  # 設定内容: このNATゲートウェイを作成するVPC IDを指定します。
  # 設定可能な値: 有効なVPC ID
  # 省略時: 指定なし
  # 注意: availability_modeが"regional"の場合は必須です。"zonal"の場合は指定不可
  vpc_id = null

  #-------------------------------------------------------------
  # ネットワーク設定（ゾーン型NAT用）
  #-------------------------------------------------------------

  # subnet_id (Optional, zonal NAT gateways only)
  # 設定内容: NATゲートウェイを配置するサブネットのIDを指定します。
  # 設定可能な値: 有効なサブネットID
  # 省略時: 指定なし
  # 注意: availability_modeが"zonal"の場合は必須です。"regional"の場合は指定不可
  subnet_id = "subnet-12345678"

  #-------------------------------------------------------------
  # 接続タイプ設定
  #-------------------------------------------------------------

  # connectivity_type (Optional)
  # 設定内容: NATゲートウェイの接続タイプを指定します。
  # 設定可能な値:
  #   - "public" (デフォルト): パブリックNATゲートウェイ。インターネット接続を提供
  #   - "private": プライベートNATゲートウェイ。VPC間またはオンプレミス接続のみ
  # 省略時: "public"
  # 関連機能: Public/Private NAT Gateway
  #   パブリックNATゲートウェイはパブリックサブネットに作成され、Elastic IPアドレスが必要です。
  #   プライベートNATゲートウェイはプライベートサブネットに作成され、Elastic IPは関連付けできません。
  #   トラフィックはトランジットゲートウェイまたは仮想プライベートゲートウェイ経由でルーティングされます。
  # 注意: availability_modeが"regional"の場合、この値は"public"である必要があります
  connectivity_type = "public"

  #-------------------------------------------------------------
  # Elastic IP設定（パブリック・ゾーン型NAT用）
  #-------------------------------------------------------------

  # allocation_id (Optional, zonal NAT gateways only)
  # 設定内容: NATゲートウェイに関連付けるElastic IPアドレスのAllocation IDを指定します。
  # 設定可能な値: 有効なElastic IP Allocation ID
  # 省略時: 指定なし
  # 注意: connectivity_typeが"public"かつavailability_modeが"zonal"の場合は必須です。
  #       availability_modeが"regional"の場合は指定不可（代わりにavailability_zone_addressブロックを使用）
  allocation_id = "eipalloc-12345678"

  # secondary_allocation_ids (Optional, zonal NAT gateways only)
  # 設定内容: このNATゲートウェイのセカンダリElastic IPのAllocation IDリストを指定します。
  # 設定可能な値: Elastic IP Allocation IDのセット
  # 省略時: 指定なし
  # 注意: すべてのセカンダリアロケーションを削除する場合は空のリストを指定します。
  #       secondary_allocation_idsを持つaws_nat_gatewayリソースを
  #       aws_nat_gateway_eip_associationリソースと併用しないでください。
  #       永続的な差分が発生し、関連付けが上書きされる可能性があります。
  secondary_allocation_ids = null

  #-------------------------------------------------------------
  # プライベートIP設定（ゾーン型NAT用）
  #-------------------------------------------------------------

  # private_ip (Optional, zonal NAT gateways only)
  # 設定内容: NATゲートウェイに割り当てるプライベートIPv4アドレスを指定します。
  # 設定可能な値: 有効なプライベートIPv4アドレス
  # 省略時: プライベートIPv4アドレスが自動的に割り当てられます
  private_ip = null

  # secondary_private_ip_address_count (Optional, zonal and private NAT gateways only)
  # 設定内容: NATゲートウェイに割り当てるセカンダリプライベートIPv4アドレスの数を指定します。
  # 設定可能な値: 整数値
  # 省略時: 指定なし
  # 注意: ゾーン型かつプライベートNATゲートウェイの場合のみ指定可能
  secondary_private_ip_address_count = null

  # secondary_private_ip_addresses (Optional, zonal NAT gateways only)
  # 設定内容: NATゲートウェイに割り当てるセカンダリプライベートIPv4アドレスのリストを指定します。
  # 設定可能な値: プライベートIPv4アドレスのセット
  # 省略時: 指定なし
  # 注意: すべてのセカンダリプライベートアドレスを削除する場合は空のリストを指定します
  secondary_private_ip_addresses = null

  #-------------------------------------------------------------
  # アベイラビリティゾーンアドレス設定（リージョナル型NAT用）
  #-------------------------------------------------------------

  # availability_zone_address (Optional, regional NAT gateways only)
  # 設定内容: リージョナルNATゲートウェイのElastic IPアドレス（EIP）と
  #          アベイラビリティゾーンの設定を行う繰り返し可能なブロックです。
  # 省略時: リージョナルNATゲートウェイは、Elastic Network Interfaceの検出時に
  #        新しいAZに自動的に拡張し、EIPを関連付けます（autoモード）
  # 注意: このブロックを指定すると、自動拡張が無効化されます（manualモード）
  #       availability_modeが"regional"の場合のみ指定可能
  # availability_zone_address {
  #   # allocation_ids (Required)
  #   # 設定内容: この特定のアベイラビリティゾーンでアウトバウンドNATトラフィックを
  #   #          処理するために使用されるElastic IPアドレス（EIP）のAllocation IDリストを指定します。
  #   # 設定可能な値: Elastic IP Allocation IDのセット
  #   allocation_ids = ["eipalloc-12345678"]
  #
  #   # availability_zone (Optional)
  #   # 設定内容: この特定のNATゲートウェイ設定がアクティブになる
  #   #          アベイラビリティゾーン（例: us-west-2a）を指定します。
  #   # 設定可能な値: 有効なアベイラビリティゾーン名
  #   # 注意: availability_zoneまたはavailability_zone_idのいずれか一方を必ず指定する必要があります
  #   availability_zone = "ap-northeast-1a"
  #
  #   # availability_zone_id (Optional)
  #   # 設定内容: この特定のNATゲートウェイ設定がアクティブになる
  #   #          アベイラビリティゾーンID（例: usw2-az2）を指定します。
  #   # 設定可能な値: 有効なアベイラビリティゾーンID
  #   # 注意: availability_zoneまたはavailability_zone_idのいずれか一方を必ず指定する必要があります
  #   availability_zone_id = null
  # }

  #-------------------------------------------------------------
  # ID設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: NATゲートウェイのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: 自動的に生成されます
  # 注意: 通常は指定する必要はありません
  id = null

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
    Name        = "example-nat-gateway"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tagsから継承されたタグを含む、すべてのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: 自動的に計算されます
  # 注意: 通常はこの属性を直接設定する必要はありません
  tags_all = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: リソース作成のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "10m", "1h"）
  #   # 省略時: デフォルトのタイムアウト時間を使用
  #   create = "10m"
  #
  #   # delete (Optional)
  #   # 設定内容: リソース削除のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトのタイムアウト時間を使用
  #   delete = "30m"
  #
  #   # update (Optional)
  #   # 設定内容: リソース更新のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "10m", "1h"）
  #   # 省略時: デフォルトのタイムアウト時間を使用
  #   update = "10m"
  # }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  # depends_on = [aws_internet_gateway.example]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - association_id: (ゾーン型NATのみ) NATゲートウェイに関連付けられたElastic IPアドレスのアソシエーションID。
#                   connectivity_typeが"public"の場合のみ利用可能。
#
# - auto_provision_zones: (リージョナル型NATのみ) AWSが自動的にAZカバレッジを管理するかを示します。
#
# - auto_scaling_ips: (リージョナル型NATのみ) AWSが、そのAZからの単一宛先への同時接続の増加により
#                     NATゲートウェイがより多くのポートを必要とする場合に、AZ内で追加のElastic IPアドレス（EIP）を
#                     自動的に割り当てるかを示します。
#
# - id: NATゲートウェイのID。
#
# - network_interface_id: (ゾーン型NATのみ) NATゲートウェイに関連付けられたネットワークインターフェイスのID。
#
# - public_ip: (ゾーン型NATのみ) NATゲートウェイに関連付けられたElastic IPアドレス。
#
# - regional_nat_gateway_address: (リージョナル型NATのみ) リージョナルNATゲートウェイに関連付けられた
#                                 IPアドレスとネットワークインターフェイスの情報を含む繰り返しブロック。
#     * allocation_id: Elastic IPアドレスのAllocation ID。
#     * association_id: Elastic IPアドレスのアソシエーションID。
#     * availability_zone: この特定のNATゲートウェイ設定がアクティブなアベイラビリティゾーン。
#---------------------------------------------------------------
