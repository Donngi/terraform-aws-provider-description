#---------------------------------------------------------------
# AWS Network Interface (ENI)
#---------------------------------------------------------------
#
# VPC内に Elastic Network Interface（弾力的ネットワークインターフェース）を
# 作成・管理するリソースです。
# ENIはEC2インスタンス、Lambda関数、ECSタスクなどに接続して
# ネットワーク通信を提供します。複数のIPアドレス・セキュリティグループを
# アタッチでき、インスタンス間の移動も可能です。
#
# AWS公式ドキュメント:
#   - Elastic Network Interface: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html
#   - ENIの作成と操作: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/working-with-enis.html
#   - Elastic Fabric Adapter (EFA): https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa.html
#   - ENA Express (SRD): https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ena-express.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_network_interface" "example" {
  #-------------------------------------------------------------
  # サブネット設定
  #-------------------------------------------------------------

  # subnet_id (Required)
  # 設定内容: ENIを配置するサブネットのIDを指定します。
  # 設定可能な値: 有効なサブネットID（例: "subnet-12345678"）
  # 省略時: 省略不可（必須項目）
  subnet_id = "subnet-12345678"

  #-------------------------------------------------------------
  # 説明
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ENIの説明文を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なしで作成されます。
  description = "example network interface"

  #-------------------------------------------------------------
  # インターフェースタイプ設定
  #-------------------------------------------------------------

  # interface_type (Optional)
  # 設定内容: ネットワークインターフェースのタイプを指定します。
  # 設定可能な値:
  #   - "interface": 通常のElastic Network Interface（デフォルト相当）
  #   - "efa": Elastic Fabric Adapter。HPC・機械学習向けの高速インターコネクト用
  #   - "efa-only": EFA専用モード。EC2 ENA通信を伴わないEFA専用インターフェース
  #   - "trunk": トランクネットワークインターフェース（ECSタスクのENIトランキング用）
  # 省略時: AWSが自動的に "interface" を選択します。
  # 関連機能: Elastic Fabric Adapter
  #   低レイテンシ・高スループット通信を必要とするHPC・MLワークロード向けの
  #   ネットワークインターフェース。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa.html
  interface_type = null

  #-------------------------------------------------------------
  # プライベートIPv4アドレス設定
  #-------------------------------------------------------------

  # private_ip (Optional)
  # 設定内容: ENIのプライマリプライベートIPv4アドレスを指定します。
  # 設定可能な値: サブネットCIDR範囲内の有効なIPv4アドレス（例: "10.0.0.10"）
  # 省略時: サブネット範囲内のIPアドレスがAWSによって自動的に割り当てられます。
  # 注意: private_ip_list_enabled が true の場合は private_ip_list を使用してください。
  private_ip = null

  # private_ips (Optional)
  # 設定内容: ENIに割り当てるプライベートIPv4アドレスのセットを指定します。
  # 設定可能な値: サブネットCIDR範囲内のIPv4アドレスのセット（例: ["10.0.0.10", "10.0.0.11"]）
  # 省略時: AWSが自動的にIPアドレスを割り当てます。
  # 注意: private_ip_list_enabled が true の場合はこの属性は使用できません。
  private_ips = []

  # private_ips_count (Optional)
  # 設定内容: プライマリIPアドレスに加えて自動割り当てするセカンダリプライベートIPアドレスの数を指定します。
  # 設定可能な値: 0以上の整数
  # 省略時: セカンダリIPアドレスは追加されません。
  # 注意: private_ips, private_ip_list との同時指定は競合する場合があります。
  private_ips_count = null

  # private_ip_list_enabled (Optional)
  # 設定内容: private_ip_list 属性を使用したIPアドレス管理モードを有効にするかを指定します。
  # 設定可能な値:
  #   - true: private_ip_list を使用してIPアドレスを順序付きリストで管理
  #   - false: private_ips セットを使用（デフォルト動作）
  # 省略時: false
  # 注意: trueにした場合は private_ip_list でIPアドレスの順序付きリストを管理します。
  private_ip_list_enabled = false

  # private_ip_list (Optional)
  # 設定内容: ENIに割り当てるプライベートIPv4アドレスの順序付きリストを指定します。
  # 設定可能な値: サブネットCIDR範囲内のIPv4アドレスのリスト（例: ["10.0.0.10", "10.0.0.11"]）
  # 省略時: 空のリスト
  # 注意: private_ip_list_enabled が true の場合にのみ使用します。
  #       リストの最初の要素がプライマリIPv4アドレスになります。
  private_ip_list = []

  #-------------------------------------------------------------
  # IPv4プレフィックス委任設定
  #-------------------------------------------------------------

  # ipv4_prefixes (Optional)
  # 設定内容: ENIに割り当てるIPv4プレフィックスのセットを指定します。
  # 設定可能な値: CIDRブロック形式のプレフィックスのセット（例: ["10.0.0.0/28"]）
  # 省略時: IPv4プレフィックスは割り当てられません。
  # 関連機能: IPプレフィックス委任
  #   ENIにIPv4/IPv6プレフィックスを委任することで、ポッドやコンテナへ
  #   サブネットレベルでIP割当を行えます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-prefix-eni.html
  # 注意: ipv4_prefix_count との同時指定は不可です。
  ipv4_prefixes = []

  # ipv4_prefix_count (Optional)
  # 設定内容: ENIに自動的に割り当てるIPv4プレフィックスの数を指定します。
  # 設定可能な値: 0以上の整数
  # 省略時: IPv4プレフィックスの自動割り当ては行われません。
  # 注意: ipv4_prefixes との同時指定は不可です。
  ipv4_prefix_count = null

  #-------------------------------------------------------------
  # IPv6アドレス設定
  #-------------------------------------------------------------

  # enable_primary_ipv6 (Optional)
  # 設定内容: プライマリIPv6グローバルユニークアドレス（GUA）を有効にするかを指定します。
  # 設定可能な値:
  #   - true: プライマリIPv6アドレスを有効化（変更不可となり安定）
  #   - false: プライマリIPv6を無効化
  # 省略時: AWSが自動的に判断します（IPv6サブネット利用時のみ意味を持つ）。
  # 関連機能: プライマリIPv6
  #   IPv6専用サブネットや双対スタックでのIPv6エンドポイント安定化に使用されます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html
  enable_primary_ipv6 = null

  # ipv6_addresses (Optional)
  # 設定内容: ENIに割り当てるIPv6アドレスのセットを指定します。
  # 設定可能な値: サブネットCIDR範囲内の有効なIPv6アドレスのセット（例: ["2001:db8::1"]）
  # 省略時: IPv6アドレスは割り当てられません。
  # 注意: ipv6_address_list_enabled が true の場合はこの属性は使用できません。
  ipv6_addresses = []

  # ipv6_address_count (Optional)
  # 設定内容: ENIに自動的に割り当てるIPv6アドレスの数を指定します。
  # 設定可能な値: 0以上の整数
  # 省略時: IPv6アドレスの自動割り当ては行われません。
  ipv6_address_count = null

  # ipv6_address_list_enabled (Optional)
  # 設定内容: ipv6_address_list 属性を使用したIPv6アドレス管理モードを有効にするかを指定します。
  # 設定可能な値:
  #   - true: ipv6_address_list を使用してIPv6アドレスを順序付きリストで管理
  #   - false: ipv6_addresses セットを使用（デフォルト動作）
  # 省略時: false
  ipv6_address_list_enabled = false

  # ipv6_address_list (Optional)
  # 設定内容: ENIに割り当てるIPv6アドレスの順序付きリストを指定します。
  # 設定可能な値: 有効なIPv6アドレスのリスト
  # 省略時: 空のリスト
  # 注意: ipv6_address_list_enabled が true の場合にのみ使用します。
  ipv6_address_list = []

  #-------------------------------------------------------------
  # IPv6プレフィックス委任設定
  #-------------------------------------------------------------

  # ipv6_prefixes (Optional)
  # 設定内容: ENIに割り当てるIPv6プレフィックスのセットを指定します。
  # 設定可能な値: CIDRブロック形式のIPv6プレフィックスのセット
  # 省略時: IPv6プレフィックスは割り当てられません。
  # 注意: ipv6_prefix_count との同時指定は不可です。
  ipv6_prefixes = []

  # ipv6_prefix_count (Optional)
  # 設定内容: ENIに自動的に割り当てるIPv6プレフィックスの数を指定します。
  # 設定可能な値: 0以上の整数
  # 省略時: IPv6プレフィックスの自動割り当ては行われません。
  # 注意: ipv6_prefixes との同時指定は不可です。
  ipv6_prefix_count = null

  #-------------------------------------------------------------
  # セキュリティグループ設定
  #-------------------------------------------------------------

  # security_groups (Optional)
  # 設定内容: ENIに関連付けるセキュリティグループIDのセットを指定します。
  # 設定可能な値: 有効なセキュリティグループIDのセット（例: ["sg-12345678", "sg-87654321"]）
  # 省略時: VPCのデフォルトセキュリティグループが適用されます。
  # 関連機能: VPCセキュリティグループ
  #   ENIに関連付けるセキュリティグループはENI単位で評価されます。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html
  security_groups = []

  #-------------------------------------------------------------
  # ソース/宛先チェック設定
  #-------------------------------------------------------------

  # source_dest_check (Optional)
  # 設定内容: 送信元/宛先チェックの有効・無効を指定します。
  # 設定可能な値:
  #   - true (デフォルト): チェック有効。ENIは自身宛て以外のトラフィックを破棄
  #   - false: チェック無効。NATインスタンスやVPNアプライアンス用途で必要
  # 省略時: true（チェックが有効）
  # 関連機能: ソース/宛先チェック
  #   NATインスタンス・ファイアウォール・ルータなどのネットワーク機器を
  #   構築する際は false に設定する必要があります。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html#EIP_Disable_SrcDestCheck
  source_dest_check = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなしで作成されます。
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-eni"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # インスタンスへのアタッチメント設定
  #-------------------------------------------------------------

  # attachment (Optional, Block Set)
  # 設定内容: ENIをEC2インスタンスにアタッチする設定を指定するブロックです。
  # 設定可能な値: 1つ以上のattachmentブロック（複数指定可能）
  # 省略時: アタッチされない状態（detached）でENIが作成されます。
  # 注意: EC2インスタンスのプライマリENI（eth0）の管理にはこのブロックを使用しないでください。
  #       プライマリENIの変更はインスタンス再起動を必要とする場合があります。
  # attachment {
  #   #-----------------------------------------------------------
  #   # アタッチ先インスタンス設定
  #   #-----------------------------------------------------------
  #
  #   # instance (Required)
  #   # 設定内容: アタッチ先のEC2インスタンスIDを指定します。
  #   # 設定可能な値: 有効なEC2インスタンスID（例: "i-1234567890abcdef0"）
  #   # 省略時: 省略不可（必須項目）
  #   instance = "i-1234567890abcdef0"
  #
  #   # device_index (Required)
  #   # 設定内容: インスタンスへのアタッチメントのデバイスインデックスを指定します。
  #   # 設定可能な値: 0以上の整数（0はプライマリインターフェース）
  #   # 省略時: 省略不可（必須項目）
  #   device_index = 1
  #
  #   #-----------------------------------------------------------
  #   # ネットワークカード設定
  #   #-----------------------------------------------------------
  #
  #   # network_card_index (Optional)
  #   # 設定内容: ENIをアタッチするネットワークカードのインデックスを指定します。
  #   # 設定可能な値: 0以上の整数
  #   # 省略時: AWSが自動的に選択します（通常は 0）。
  #   # 注意: 複数ネットワークカードを持つインスタンスタイプでのみ意味を持ちます。
  #   network_card_index = 0
  # }

  #-------------------------------------------------------------
  # ENA Express (Scalable Reliable Datagram) 設定
  #-------------------------------------------------------------

  # ena_srd_specification (Optional, Block List, max=1)
  # 設定内容: ENA Express（Scalable Reliable Datagram, SRD）の有効/無効と
  #           UDPに対するSRDの利用設定を行うブロックです。
  # 設定可能な値: 1つの ena_srd_specification ブロック
  # 省略時: ENA Expressは無効
  # 関連機能: ENA Express
  #   AWS独自のSRDプロトコルを利用してEC2インスタンス間TCP/UDP通信の
  #   レイテンシとスループットを改善する機能。
  #   サポートされたインスタンスタイプ間の同一AZ内通信でのみ有効化可能。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ena-express.html
  # ena_srd_specification {
  #   # ena_srd_enabled (Optional)
  #   # 設定内容: ENA Express（TCP含むSRD通信全般）を有効化するかを指定します。
  #   # 設定可能な値:
  #   #   - true: ENA Express を有効化
  #   #   - false: ENA Express を無効化
  #   # 省略時: false（無効）
  #   ena_srd_enabled = true
  #
  #   #-----------------------------------------------------------
  #   # UDP向けSRD設定
  #   #-----------------------------------------------------------
  #
  #   # ena_srd_udp_specification (Optional, Block List, max=1)
  #   # 設定内容: UDPトラフィックに対するSRD利用の設定ブロックを指定します。
  #   # 設定可能な値: 1つの ena_srd_udp_specification ブロック
  #   # 省略時: UDPに対するSRDは無効
  #   # ena_srd_udp_specification {
  #   #   # ena_srd_udp_enabled (Optional)
  #   #   # 設定内容: UDPトラフィックでSRDを利用するかを指定します。
  #   #   # 設定可能な値:
  #   #   #   - true: UDPでSRDを利用
  #   #   #   - false: UDPでSRDを利用しない
  #   #   # 省略時: false（無効）
  #   #   # 注意: ena_srd_enabled が true の場合にのみ有効化できます。
  #   #   ena_srd_udp_enabled = true
  #   # }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ネットワークインターフェースのID（例: eni-xxxxxxxx）
# - arn: ネットワークインターフェースのARN
# - mac_address: ENIのMACアドレス
# - private_dns_name: ENIのプライベートDNS名
# - owner_id: ENIを所有するAWSアカウントのID
# - outpost_arn: Outpost上に配置されている場合のOutpostのARN
# - attachment[*].attachment_id: アタッチメントID
# - tags_all: プロバイダーの default_tags を含む全タグのマップ
#---------------------------------------------------------------
