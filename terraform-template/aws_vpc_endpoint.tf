#---------------------------------------------------------------
# AWS VPC Endpoint
#---------------------------------------------------------------
#
# Amazon VPC内からAWSサービスやAWS PrivateLinkを利用したサービスへの
# プライベート接続を確立するVPCエンドポイントをプロビジョニングします。
# VPCエンドポイントを使用することで、インターネットゲートウェイやNATデバイスを
# 経由せずに、プライベートIPアドレスを使用してAWSサービスに安全にアクセスできます。
#
# AWS公式ドキュメント:
#   - AWS PrivateLink概念: https://docs.aws.amazon.com/vpc/latest/privatelink/concepts.html
#   - インターフェースVPCエンドポイントの作成: https://docs.aws.amazon.com/vpc/latest/privatelink/create-interface-endpoint.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_endpoint" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: エンドポイントが使用されるVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID
  # 注意: VPCエンドポイントは指定したVPC内に作成されます。
  # 参考: https://docs.aws.amazon.com/vpc/latest/privatelink/concepts.html
  vpc_id = "vpc-12345678"

  #-------------------------------------------------------------
  # エンドポイントタイプ設定
  #-------------------------------------------------------------

  # vpc_endpoint_type (Optional)
  # 設定内容: VPCエンドポイントのタイプを指定します。
  # 設定可能な値:
  #   - "Gateway": S3やDynamoDBへのゲートウェイエンドポイント（ルートテーブルベース）
  #   - "GatewayLoadBalancer": Gateway Load Balancerエンドポイント
  #   - "Interface": AWS PrivateLinkによるインターフェースエンドポイント
  #   - "Resource": VPC Latticeリソース設定エンドポイント
  #   - "ServiceNetwork": VPC Latticeサービスネットワークエンドポイント
  # 省略時: "Gateway"
  # 関連機能: VPCエンドポイントタイプ
  #   エンドポイントタイプにより利用可能な設定や接続方式が異なります。
  #   Gatewayタイプはルートテーブル経由、Interfaceタイプはプライベート
  #   IPアドレス経由でサービスへアクセスします。
  #   - https://docs.aws.amazon.com/vpc/latest/privatelink/concepts.html#concepts-vpc-endpoints
  vpc_endpoint_type = "Interface"

  #-------------------------------------------------------------
  # サービス/リソース識別設定
  #-------------------------------------------------------------

  # service_name (Optional)
  # 設定内容: 接続先サービスの名前を指定します。
  # 設定可能な値: AWSサービス名（例: com.amazonaws.us-west-2.s3）または
  #   カスタムエンドポイントサービス名
  # 注意: resource_configuration_arn、service_name、service_network_arnの
  #   いずれか1つを必ず指定する必要があります。
  # 関連機能: サービス名
  #   各AWSサービスはリージョンごとに一意のサービス名を持ちます。
  #   カスタムエンドポイントサービスの場合、サービスプロバイダーから
  #   サービス名を取得する必要があります。
  #   - https://docs.aws.amazon.com/vpc/latest/privatelink/concepts.html#concepts-service-names
  service_name = "com.amazonaws.ap-northeast-1.ec2"

  # resource_configuration_arn (Optional)
  # 設定内容: 接続先のVPC Latticeリソース設定のARNを指定します。
  # 設定可能な値: 有効なリソース設定ARN
  # 注意: resource_configuration_arn、service_name、service_network_arnの
  #   いずれか1つを必ず指定する必要があります。
  # 関連機能: リソース設定
  #   VPC Latticeリソース設定は、データベースやEC2インスタンスなどの
  #   単一リソースまたはリソースグループを表します。
  #   - https://docs.aws.amazon.com/vpc/latest/privatelink/concepts.html#concepts-resource-configuration
  resource_configuration_arn = null

  # service_network_arn (Optional)
  # 設定内容: 接続先のVPC Latticeサービスネットワークの ARNを指定します。
  # 設定可能な値: 有効なサービスネットワークARN
  # 注意: resource_configuration_arn、service_name、service_network_arnの
  #   いずれか1つを必ず指定する必要があります。
  # 関連機能: サービスネットワーク
  #   サービスネットワークエンドポイントを使用すると、単一のエンドポイントから
  #   サービスネットワークに関連付けられた複数のリソースとサービスに
  #   プライベートかつ安全にアクセスできます。
  service_network_arn = null

  #-------------------------------------------------------------
  # リージョン・クロスリージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # service_region (Optional)
  # 設定内容: VPCエンドポイントサービスのAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード
  # 省略時: エンドポイントと同じリージョン
  # 適用対象: Interfaceタイプのエンドポイント
  # 関連機能: クロスリージョンエンドポイント
  #   クロスリージョンエンドポイントを使用すると、異なるリージョンにある
  #   サービスにVPCからプライベートに接続できます。
  service_region = null

  #-------------------------------------------------------------
  # 自動承認設定
  #-------------------------------------------------------------

  # auto_accept (Optional)
  # 設定内容: VPCエンドポイント接続を自動的に承認するかを指定します。
  # 設定可能な値:
  #   - true: 接続リクエストを自動承認
  #   - false (デフォルト): 手動承認が必要
  # 注意: VPCエンドポイントとサービスが同じAWSアカウントにある必要があります。
  auto_accept = false

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # subnet_ids (Optional)
  # 設定内容: エンドポイントネットワークインターフェースを作成するサブネットのIDリストを指定します。
  # 設定可能な値: サブネットIDのリスト
  # 適用対象: GatewayLoadBalancerおよびInterfaceタイプのエンドポイント
  # 注意: Interfaceタイプのエンドポイントはサブネットへの割り当てなしでは機能しません。
  # 関連機能: エンドポイントネットワークインターフェース
  #   各サブネットに対してエンドポイントネットワークインターフェースが作成され、
  #   サブネットアドレス範囲からプライベートIPアドレスが割り当てられます。
  #   - https://docs.aws.amazon.com/vpc/latest/privatelink/concepts.html#concepts-endpoint-network-interfaces
  subnet_ids = ["subnet-12345678", "subnet-87654321"]

  # security_group_ids (Optional)
  # 設定内容: ネットワークインターフェースに関連付けるセキュリティグループのIDリストを指定します。
  # 設定可能な値: セキュリティグループIDのリスト
  # 適用対象: Interfaceタイプのエンドポイント
  # 省略時: VPCのデフォルトセキュリティグループが関連付けられます。
  # 注意: セキュリティグループは、VPC内のリソースからの予想されるトラフィック
  #   （例: HTTPSリクエスト）を許可する必要があります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html#DefaultSecurityGroup
  security_group_ids = ["sg-12345678"]

  # route_table_ids (Optional)
  # 設定内容: 1つ以上のルートテーブルのIDリストを指定します。
  # 設定可能な値: ルートテーブルIDのリスト
  # 適用対象: Gatewayタイプのエンドポイント
  # 関連機能: ゲートウェイエンドポイント
  #   ゲートウェイエンドポイントはルートテーブルに指定するゲートウェイで、
  #   AWSネットワーク経由でVPCからサービスにアクセスします。
  route_table_ids = null

  #-------------------------------------------------------------
  # IPアドレス設定
  #-------------------------------------------------------------

  # ip_address_type (Optional)
  # 設定内容: エンドポイントのIPアドレスタイプを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4アドレスのみ
  #   - "ipv6": IPv6アドレスのみ
  #   - "dualstack": IPv4とIPv6の両方のアドレス
  # 関連機能: IPアドレスタイプ
  #   選択したIPアドレスタイプに応じて、エンドポイントネットワーク
  #   インターフェースにIPv4、IPv6、またはその両方のアドレスが割り当てられます。
  #   - https://docs.aws.amazon.com/vpc/latest/privatelink/privatelink-access-aws-services.html#aws-service-ip-address-type
  ip_address_type = "ipv4"

  #-------------------------------------------------------------
  # DNS設定
  #-------------------------------------------------------------

  # private_dns_enabled (Optional)
  # 設定内容: 指定されたVPCにプライベートホストゾーンを関連付けるかを指定します。
  # 設定可能な値:
  #   - true: プライベートDNSを有効化
  #   - false (デフォルト): プライベートDNSを無効化
  # 適用対象: Interfaceタイプのエンドポイント（AWSサービスおよび
  #   AWS Marketplaceパートナーサービスのみ）
  # 注意: ほとんどのユーザーはVPC内のサービスが自動的にエンドポイントを
  #   使用できるようにするため、これを有効にすることを推奨します。
  # 関連機能: プライベートDNS
  #   プライベートDNSを有効にすると、パブリックサービスエンドポイントを
  #   使用するリクエスト（AWS SDKを通じたリクエストなど）がVPCエンドポイントに
  #   解決されます。
  private_dns_enabled = true

  # dns_options (Optional)
  # 設定内容: エンドポイントのDNSオプションを設定します。
  # 関連機能: DNSオプション
  #   DNSレコードのIPタイプ、プライベートDNS設定の詳細な制御が可能です。
  dns_options {
    # dns_record_ip_type (Optional)
    # 設定内容: エンドポイント用に作成されるDNSレコードのタイプを指定します。
    # 設定可能な値:
    #   - "ipv4": Aレコードのみ
    #   - "ipv6": AAAAレコードのみ
    #   - "dualstack": AレコードとAAAAレコードの両方
    #   - "service-defined": サービスが定義するデフォルト
    # 関連機能: DNSレコードIPタイプ
    #   エンドポイントのIPアドレスタイプに応じて、返されるDNSレコードタイプを
    #   カスタマイズできます。
    dns_record_ip_type = "ipv4"

    # private_dns_only_for_inbound_resolver_endpoint (Optional)
    # 設定内容: インバウンドエンドポイント専用のプライベートDNSを有効にするかを指定します。
    # 設定可能な値:
    #   - true: インバウンドリゾルバーエンドポイント専用のプライベートDNSを有効化
    #   - false (デフォルト): 標準のプライベートDNS動作
    # 注意: このオプションは、ゲートウェイエンドポイントとインターフェース
    #   エンドポイントの両方をサポートするサービスのインターフェース
    #   エンドポイントでのみ使用可能です。同じサービス用のゲートウェイ
    #   エンドポイントが作成されている必要があります。
    #   private_dns_enabledがtrueの場合にのみ指定できます。
    # 関連機能: ハイブリッドDNS設定
    #   VPC発信のトラフィックはゲートウェイエンドポイントにルーティングされ、
    #   オンプレミス発信のトラフィックはインターフェースエンドポイントに
    #   ルーティングされます。
    private_dns_only_for_inbound_resolver_endpoint = false

    # private_dns_preference (Optional)
    # 設定内容: プライベートホストゾーンが作成・関連付けられる
    #   プライベートドメインの優先設定を指定します。
    # 設定可能な値:
    #   - "ALL_DOMAINS": すべてのドメイン
    #   - "VERIFIED_DOMAINS_ONLY": 検証済みドメインのみ
    #   - "VERIFIED_DOMAINS_AND_SPECIFIED_DOMAINS": 検証済みおよび指定ドメイン
    #   - "SPECIFIED_DOMAINS_ONLY": 指定ドメインのみ
    # 適用対象: private_dns_enabledがtrueで、vpc_endpoint_typeが
    #   ServiceNetworkまたはResourceの場合のみサポート
    private_dns_preference = null

    # private_dns_specified_domains (Optional)
    # 設定内容: プライベートホストゾーンを作成し、指定したVPCに関連付ける
    #   プライベートドメインのリストを指定します。
    # 設定可能な値: ドメイン名のリスト
    # 注意: private_dns_enabledがtrueで、private_dns_preferenceが
    #   "VERIFIED_DOMAINS_AND_SPECIFIED_DOMAINS"または
    #   "SPECIFIED_DOMAINS_ONLY"の場合に指定する必要があります。
    #   その他の場合は指定してはいけません。
    private_dns_specified_domains = null
  }

  #-------------------------------------------------------------
  # サブネット詳細設定
  #-------------------------------------------------------------

  # subnet_configuration (Optional)
  # 設定内容: エンドポイントのサブネット設定を指定し、特定のIPv4/IPv6アドレスを
  #   エンドポイントに選択するために使用します。
  # 関連機能: ユーザー定義IPアドレス
  #   デフォルトではサブネットIPアドレス範囲からIPアドレスを選択し、
  #   エンドポイントネットワークインターフェースに割り当てますが、
  #   このブロックで特定のIPアドレスを指定できます。
  # 注意: サブネットCIDRブロックの最初の4つのIPアドレスと最後のIPアドレスは
  #   内部使用のために予約されているため、エンドポイントネットワーク
  #   インターフェースには指定できません。
  subnet_configuration {
    # ipv4 (Optional)
    # 設定内容: サブネット内のエンドポイントネットワークインターフェースに
    #   割り当てるIPv4アドレスを指定します。
    # 設定可能な値: 有効なIPv4アドレス
    # 注意: VPCエンドポイントがIPv4をサポートする場合、IPv4アドレスを
    #   提供する必要があります。
    ipv4 = "10.0.1.10"

    # ipv6 (Optional)
    # 設定内容: サブネット内のエンドポイントネットワークインターフェースに
    #   割り当てるIPv6アドレスを指定します。
    # 設定可能な値: 有効なIPv6アドレス
    # 注意: VPCエンドポイントがIPv6をサポートする場合、IPv6アドレスを
    #   提供する必要があります。
    ipv6 = null

    # subnet_id (Optional)
    # 設定内容: サブネットのIDを指定します。
    # 設定可能な値: 有効なサブネットID
    # 注意: subnet_ids引数に対応するサブネットが必要です。
    subnet_id = "subnet-12345678"
  }

  #-------------------------------------------------------------
  # アクセスポリシー設定
  #-------------------------------------------------------------

  # policy (Optional)
  # 設定内容: サービスへのアクセスを制御するためにエンドポイントに
  #   アタッチするポリシーを指定します。
  # 設定可能な値: JSON形式の文字列
  # 省略時: フルアクセス
  # 適用対象: すべてのGatewayエンドポイントと一部のInterfaceエンドポイント
  # 関連機能: エンドポイントポリシー
  #   VPCエンドポイントポリシーは、VPCエンドポイントにアタッチする
  #   IAMリソースポリシーです。どのプリンシパルがVPCエンドポイントを
  #   使用してエンドポイントサービスにアクセスできるかを決定します。
  #   デフォルトのVPCエンドポイントポリシーは、VPCエンドポイント経由の
  #   すべてのリソースに対するすべてのプリンシパルによるすべてのアクションを許可します。
  #   - https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints-access.html
  # 参考: TerraformでのAWS IAMポリシードキュメントの構築については以下を参照
  #   - https://learn.hashicorp.com/terraform/aws/iam-policy
  policy = null

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
    Name        = "my-vpc-endpoint"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  #   リソースに割り当てられたすべてのタグのマップです。
  # 注意: この属性はTerraformによって自動管理されるため、通常は指定不要です。
  tags_all = null

  #-------------------------------------------------------------
  # その他の設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: VPCエンドポイントのID。
  # 注意: この属性は通常Terraformによって自動的に管理されます。
  id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 各操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    create = "10m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    update = "10m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPCエンドポイントのID
#
# - arn: VPCエンドポイントのAmazon Resource Name (ARN)
#
# - cidr_blocks: 公開されるAWSサービスのCIDRブロックのリスト。
#   Gatewayタイプのエンドポイントに適用されます。
#
# - dns_entry: VPCエンドポイントのDNSエントリ。
#   Interfaceタイプのエンドポイントに適用されます。
#   DNSブロックには以下が含まれます:
#     - dns_name: DNS名
#     - hosted_zone_id: プライベートホストゾーンのID
#
# - network_interface_ids: VPCエンドポイントの1つ以上のネットワークインターフェース。
#   Interfaceタイプのエンドポイントに適用されます。
#
# - owner_id: VPCエンドポイントを所有するAWSアカウントのID
#
# - prefix_list_id: 公開されるAWSサービスのプレフィックスリストID。
#   Gatewayタイプのエンドポイントに適用されます。
#---------------------------------------------------------------
