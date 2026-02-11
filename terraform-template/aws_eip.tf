# ================================================================
# AWS Elastic IP (EIP) - 完全リファレンステンプレート
# Provider Version: 6.28.0
# ================================================================
#
# Elastic IP (EIP) は動的クラウドコンピューティング向けに設計された静的な
# パブリックIPv4アドレスです。EIPをインスタンスやネットワークインターフェースに
# 関連付けることで、インスタンスやソフトウェアの障害時に別のインスタンスへ
# 迅速にIPアドレスを再マッピングできます。
#
# 重要な注意事項:
# - EIPは使用中（リソースに関連付け済み）でも、未使用（割り当て済みだが未関連付け）
#   でも課金されます
# - デフォルトでは各リージョンで5個のEIP制限があります
# - EIPはリージョン固有であり、別のリージョンへ移動できません
# - VPC内でのみタグを設定可能です
# - Internet Gateway (IGW) の存在が必要な場合があります（depends_on を使用）
# - aws_lb や aws_nat_gateway との関連付けには network_interface ではなく
#   それらのリソースの allocation_id を使用してください
#
# 参考ドキュメント:
# - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html
# - https://docs.aws.amazon.com/vpc/latest/userguide/WorkWithEIPs.html
# ================================================================

# ================================================================
# 基本的な使用例: VPC内のインスタンスへのEIP割り当て
# ================================================================
resource "aws_eip" "example_basic" {
  # --------------------------------------------------
  # 必須設定項目
  # --------------------------------------------------
  # EIPはリソースブロックの定義のみで作成可能です
  # すべての属性はオプションですが、domain = "vpc" の指定を推奨

  # --------------------------------------------------
  # 基本設定
  # --------------------------------------------------

  # domain - (オプション) EIPがVPC用であることを示します
  # タイプ: string
  # 有効値: "vpc" | "standard"
  # デフォルト: computed（通常は "vpc"）
  #
  # VPC内でEIPを使用する場合は "vpc" を指定します。
  # EC2-Classic（廃止予定）の場合は "standard" を指定しますが、
  # 新規の場合は常に "vpc" を使用してください。
  # この値を設定することで、タグの使用やVPC固有の機能が有効になります。
  #
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html
  domain = "vpc"

  # instance - (オプション) 関連付けるEC2インスタンスのID
  # タイプ: string
  # デフォルト: computed（関連付けがない場合は空）
  #
  # EIPを特定のEC2インスタンスに関連付ける場合に指定します。
  # インスタンスIDまたはnetwork_interfaceのいずれか一方のみを指定できます。
  # 両方を指定すると未定義の動作になります。
  #
  # 注意:
  # - インスタンスに既存のパブリックIPv4アドレスがある場合、EIP関連付け時に
  #   その既存アドレスは解放され、EIPに置き換えられます
  # - aws_lb や aws_nat_gateway との関連付けには使用しないでください
  #
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AssociateAddress.html
  # instance = aws_instance.example.id

  # associate_with_private_ip - (オプション) EIPを関連付けるプライベートIPアドレス
  # タイプ: string
  # デフォルト: なし（プライマリプライベートIPアドレスが使用される）
  #
  # ユーザーが指定したプライマリまたはセカンダリのプライベートIPアドレス。
  # 指定しない場合、EIPはプライマリプライベートIPアドレスに関連付けられます。
  #
  # 使用例:
  # - 単一のネットワークインターフェースに複数のプライベートIPアドレスがあり、
  #   特定のプライベートIPにEIPを関連付けたい場合
  # - インスタンスの起動時に事前に割り当てられたプライベートIPにEIPを
  #   関連付けたい場合（VPCのみ）
  #
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/WorkWithEIPs.html
  # associate_with_private_ip = "10.0.0.12"

  # --------------------------------------------------
  # ネットワーク設定
  # --------------------------------------------------

  # network_interface - (オプション) 関連付けるネットワークインターフェースのID
  # タイプ: string
  # デフォルト: computed（関連付けがない場合は空）
  #
  # EIPを特定のネットワークインターフェース（ENI）に関連付ける場合に指定します。
  # instance または network_interface のいずれか一方のみを指定できます。
  # 両方を指定すると未定義の動作になります。
  #
  # 使用例:
  # - 複数のネットワークインターフェースを持つインスタンスの特定のENIに
  #   EIPを関連付けたい場合
  # - デュアルスタック（IPv4/IPv6）構成を実装する場合
  #
  # 注意:
  # - aws_lb や aws_nat_gateway との関連付けには使用しないでください
  # - これらのリソースでは allocation_id を使用して関連付けを管理します
  #
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html
  # network_interface = aws_network_interface.example.id

  # network_border_group - (オプション) IPアドレスがアドバタイズされる場所
  # タイプ: string
  # デフォルト: computed（リージョン内のすべてのAZを含むグループ、例: us-west-2）
  #
  # このパラメータを使用して、アドレスをこのロケーションに制限できます。
  # ネットワークボーダーグループは、AWSがパブリックIPアドレスをアドバタイズする
  # Availability Zone（AZ）、Local Zone、またはWavelength Zoneの集合です。
  #
  # 重要:
  # - EIPは関連付けられるAWSリソースと同じネットワークボーダーグループに
  #   割り当てる必要があります
  # - 1つのネットワークボーダーグループのEIPは、そのグループ内のゾーンでのみ
  #   アドバタイズされ、他のグループのゾーンではアドバタイズされません
  # - Local ZoneやWavelength Zoneは、最小レイテンシーや物理的距離を確保する
  #   ために、リージョンのAZとは異なるネットワークボーダーグループを
  #   持つ場合があります
  #
  # Local ZoneやWavelength Zoneを有効にしていない場合:
  # - リージョン内のすべてのAZを表すネットワークボーダーグループが
  #   自動的に設定され、変更できません
  #
  # 使用例:
  # - Local Zoneでのエッジコンピューティング実装
  # - Wavelength Zoneでの5Gアプリケーション
  # - 特定の地理的位置からのアドバタイズ制限
  #
  # 参考: https://docs.aws.amazon.com/local-zones/latest/ug/getting-started.html
  # network_border_group = "us-west-2-lax-1"

  # --------------------------------------------------
  # IPアドレスプール設定
  # --------------------------------------------------

  # public_ipv4_pool - (オプション) EC2 IPv4アドレスプール識別子
  # タイプ: string
  # デフォルト: "amazon"（Amazonのデフォルトプール）
  # 有効値: "amazon" | カスタムプールID（例: "ipv4pool-ec2-012345"）
  #
  # IPv4アドレスを割り当てるプールを指定します。
  # このオプションはVPC EIPでのみ使用可能です。
  #
  # 設定可能な値:
  # - "amazon": AmazonのデフォルトIPv4アドレスプールから割り当て
  # - カスタムプールID: BYOIP（Bring Your Own IP）プールから割り当て
  #
  # 注意:
  # - public_ipv4_pool と address の両方を指定した場合、address のみが
  #   使用されます（APIは2つのうち1つのみを必要とするため）
  # - BYOIPプールから割り当てたEIPはEIP制限にカウントされません
  #
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-byoip.html
  # public_ipv4_pool = "amazon"

  # address - (オプション) EC2 BYOIPプールからの特定のIPアドレス
  # タイプ: string
  # デフォルト: なし（自動割り当て）
  #
  # BYOIP（Bring Your Own IP）プールから特定のIPアドレスを指定して
  # 割り当てる場合に使用します。このオプションはVPC EIPでのみ使用可能です。
  #
  # 使用例:
  # - 以前に解放したEIPを回復する場合
  # - BYOIPプールから特定のIPアドレスを再利用する場合
  # - セキュリティ要件やホワイトリスト登録のため特定のIPが必要な場合
  #
  # 注意:
  # - 指定するIPアドレスは、アカウントに属するBYOIPプールに
  #   存在する必要があります
  # - 他のAWSアカウントに割り当て済みの場合は回復できません
  # - 回復により制限を超える場合は回復できません
  # - public_ipv4_pool と併用した場合、address が優先されます
  #
  # 回復の例（AWS CLI）:
  # aws ec2 allocate-address --domain vpc --address 203.0.113.3
  #
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/WorkWithEIPs.html#recover-eip
  # address = "203.0.113.3"

  # customer_owned_ipv4_pool - (オプション) カスタマー所有アドレスプールのID
  # タイプ: string
  # デフォルト: なし
  #
  # AWS Outpostsで使用するカスタマー所有IPアドレス（CoIP）プールのIDを指定します。
  # Outpostsのネットワーキングコンポーネントとして、オンプレミスネットワークから
  # 作成されたプールのアドレスを使用する場合に設定します。
  #
  # 使用例:
  # - AWS Outpostsを有効化および設定している環境
  # - オンプレミスネットワークからIPアドレスを使用したい場合
  # - ハイブリッドクラウド環境での一貫したIPアドレス管理
  #
  # 注意:
  # - このオプションはOutpostsがある場合のみ使用可能です
  # - CoIPから割り当てたEIPは他のアカウントへ転送できません
  # - ただし、AWS RAMを使用してCoIPプールを別のアカウントと共有できます
  #
  # 参考: https://docs.aws.amazon.com/outposts/latest/userguide/outposts-networking-components.html#ip-addressing
  # customer_owned_ipv4_pool = "ipv4pool-coip-123456789"

  # ipam_pool_id - (オプション) IPAM（IP Address Management）プールのID
  # タイプ: string
  # デフォルト: computed
  #
  # VPC IPAM（IP Address Management）を使用して、IPアドレス範囲を管理し、
  # そのプールからEIPを割り当てる場合に指定します。
  #
  # IPAMの利点:
  # - シーケンシャル（連続した）Elastic IPアドレスの割り当てが可能
  # - セキュリティ管理の簡素化
  # - エンタープライズアクセスの管理が容易
  # - IPアドレス管理の一元化
  # - 組織全体でのIPアドレス使用状況の追跡とモニタリング
  #
  # 使用例:
  # - 大規模な組織でIPアドレスを一元管理したい場合
  # - 連続したIPアドレスが必要なアプリケーション
  # - マルチアカウント環境でのIP使用状況の可視化
  #
  # 注意:
  # - Amazon所有のパブリックIPv4 CIDRブロックのプロビジョニングには
  #   料金がかかります
  # - プロビジョニング可能なブロック数とサイズには制限があります
  #
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/tutorials-eip-pool.html
  # ipam_pool_id = "ipam-pool-07ccc86aa41bef7ce"

  # --------------------------------------------------
  # リージョン設定
  # --------------------------------------------------

  # region - (オプション) このリソースが管理されるリージョン
  # タイプ: string
  # デフォルト: computed（プロバイダー設定のリージョン）
  #
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  #
  # 重要:
  # - EIPはリージョン固有のリソースであり、別のリージョンへ移動できません
  # - マルチリージョン構成では、各リージョンで個別にEIPを割り当てる
  #   必要があります
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  # --------------------------------------------------
  # タグ設定
  # --------------------------------------------------

  # tags - (オプション) リソースに割り当てるタグのマップ
  # タイプ: map(string)
  # デフォルト: なし
  #
  # EIPに割り当てるタグを指定します。
  # タグはVPC内のEIPにのみ適用可能です（domain = "vpc" が必要）。
  #
  # プロバイダーレベルでdefault_tags設定ブロックが定義されている場合、
  # 同じキーのタグはここで定義したタグで上書きされます。
  #
  # ベストプラクティス:
  # - Name: リソースの識別用（推奨）
  # - Environment: dev/staging/production などの環境識別
  # - Project: プロジェクト名
  # - Owner: 所有者またはチーム名
  # - CostCenter: コスト配分用
  # - ManagedBy: "Terraform" など管理ツールの識別
  #
  # 注意:
  # - EIP転送時、関連付けられているタグは転送完了時にリセットされます
  # - 転送されたEIPを受け入れる際、新しいタグを定義できます
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-eip-basic"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  # tags_all - (オプション) プロバイダーのdefault_tagsを含む全タグのマップ
  # タイプ: map(string)
  # デフォルト: computed
  # 読み取り専用: はい（Terraform管理）
  #
  # このリソースに割り当てられているすべてのタグのマップ。
  # プロバイダーのdefault_tags設定ブロックから継承されたタグを含みます。
  #
  # この属性は自動的に計算され、手動で設定することはできません。
  # リソースに割り当てられている完全なタグセットを参照する際に使用します。
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags_all = computed

  # --------------------------------------------------
  # タイムアウト設定
  # --------------------------------------------------

  # timeouts - (オプション) リソース操作のタイムアウト設定
  #
  # Terraformがリソース操作を待機する時間を設定します。
  # 大規模なインフラストラクチャや複雑な依存関係がある場合に有用です。
  timeouts {
    # read - (オプション) 読み取り操作のタイムアウト
    # デフォルト: 15分
    #
    # データソースやリソースの状態確認時のタイムアウト。
    # read = "15m"

    # update - (オプション) 更新操作のタイムアウト
    # デフォルト: 5分
    #
    # EIPの関連付け変更やタグ更新時のタイムアウト。
    # update = "5m"

    # delete - (オプション) 削除操作のタイムアウト
    # デフォルト: 3分
    #
    # EIPの解放時のタイムアウト。
    # 関連付けが残っている場合はエラーになります。
    # delete = "3m"
  }

  # --------------------------------------------------
  # 依存関係の設定（重要）
  # --------------------------------------------------

  # Internet Gatewayへの明示的な依存関係を設定
  # EIPはIGWが存在する前に関連付けを試みるとエラーになる場合があります
  # depends_on = [aws_internet_gateway.example]
}

# ================================================================
# 読み取り専用属性（computed attributes）
# ================================================================
# 以下の属性は自動的に計算され、outputs や他のリソースで参照できます

# allocation_id - VPC内でのElastic IPアドレス割り当てを表すID
# タイプ: string
# 読み取り専用: はい
#
# AWSがVPC内のElastic IPアドレス割り当てに割り当てるID。
# このIDは、EIPを他のリソース（NAT Gateway、Network Load Balancerなど）に
# 関連付ける際に使用されます。
#
# 使用例:
# - NAT Gateway作成時の allocation_id パラメータ
# - Network Load Balancer のサブネットマッピング
# - EIPの関連付け管理
#
# 参照方法: aws_eip.example_basic.allocation_id

# association_id - VPCインスタンスとのアドレス関連付けを表すID
# タイプ: string
# 読み取り専用: はい
#
# VPCインスタンスとのアドレス関連付けを表すID。
# EIPがインスタンスまたはネットワークインターフェースに関連付けられている
# 場合にのみ設定されます。
#
# 使用例:
# - 関連付け状態の確認
# - 関連付けの解除操作
# - インフラストラクチャの監査
#
# 参照方法: aws_eip.example_basic.association_id

# arn - EIPのAmazon Resource Name
# タイプ: string
# 読み取り専用: はい
#
# EIPのAmazon Resource Name（ARN）。
# IAMポリシー、リソースベースのポリシー、クロスアカウントアクセスなどで
# 使用されます。
#
# フォーマット: arn:aws:ec2:region:account-id:elastic-ip/allocation-id
#
# 使用例:
# - IAMポリシーでのリソース指定
# - CloudFormationスタック間の参照
# - リソースの一意識別
#
# 参照方法: aws_eip.example_basic.arn

# carrier_ip - キャリアIPアドレス
# タイプ: string
# 読み取り専用: はい
#
# Wavelength Zoneで使用されるキャリアIPアドレス。
# 通常のAZでは設定されません。
#
# Wavelength Zoneは、5Gネットワークのエッジに配置されたAWSインフラで、
# 超低レイテンシーアプリケーション向けに設計されています。
#
# 参照方法: aws_eip.example_basic.carrier_ip

# customer_owned_ip - カスタマー所有IP
# タイプ: string
# 読み取り専用: はい
#
# AWS Outpostsでカスタマー所有IPアドレスプールから割り当てられた場合の
# IPアドレス。通常の環境では設定されません。
#
# 参照方法: aws_eip.example_basic.customer_owned_ip

# id - EIP割り当てIDを含む（allocation_id と同じ）
# タイプ: string
# 読み取り専用: はい
#
# EIP割り当てIDを含みます。VPCでは allocation_id と同じ値になります。
# Terraformリソースの一意識別子として使用されます。
#
# 参照方法: aws_eip.example_basic.id

# private_dns - Elastic IPアドレスに関連付けられたプライベートDNS
# タイプ: string
# 読み取り専用: はい
#
# VPC内でのElastic IPアドレスに関連付けられたプライベートDNS名。
# このDNS名は、VPCのDNS設定（enableDnsHostnames）に基づいて計算されます。
#
# フォーマット: ip-private-ipv4-address.region.compute.internal
# （例: ip-10-0-0-12.us-west-2.compute.internal）
#
# VPC内部からこのDNS名を解決すると、プライベートIPアドレスに解決されます。
#
# 参考: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html#vpc-dns-hostnames
#
# 参照方法: aws_eip.example_basic.private_dns

# private_ip - プライベートIPアドレスを含む（VPC内の場合）
# タイプ: string
# 読み取り専用: はい
#
# EIPが関連付けられているインスタンスまたはネットワークインターフェースの
# プライベートIPアドレス。
#
# VPC内からインスタンスに接続する場合、このプライベートIPが使用され、
# VPC外部からはパブリックIP（public_ip）が使用されます。
#
# 参照方法: aws_eip.example_basic.private_ip

# ptr_record - IPアドレスのDNSポインタ（PTR）レコード
# タイプ: string
# 読み取り専用: はい
#
# IPアドレスの逆引きDNS（PTR）レコード。
# メールサーバーなどで送信元IPの検証に使用されます。
#
# カスタムPTRレコードを設定する場合:
# - AWS Supportにリクエストを送信する必要があります
# - メール送信の信頼性向上に有用です
# - EIP転送時、PTRレコードが設定されている場合は転送前に削除が必要です
#
# 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Elastic_Addressing_Reverse_DNS.html
#
# 参照方法: aws_eip.example_basic.ptr_record

# public_dns - パブリックDNS名
# タイプ: string
# 読み取り専用: はい
#
# Elastic IPアドレスに関連付けられたパブリックDNS名。
# このDNS名は、VPCのDNS設定に基づいて計算されます。
#
# フォーマット: ec2-public-ipv4-address.region.compute.amazonaws.com
# （例: ec2-203-0-113-25.us-west-2.compute.amazonaws.com）
#
# 重要な動作:
# - VPC外部からこのDNS名を解決すると、パブリックIPアドレス（またはEIP）に
#   解決されます
# - VPC内部からこのDNS名を解決すると、プライベートIPアドレスに解決されます
# - EIPをインスタンスに関連付けると、インスタンスのパブリックDNSホスト名が
#   EIPに合わせて変更されます
#
# 参考: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html#vpc-dns-hostnames
#
# 参照方法: aws_eip.example_basic.public_dns

# public_ip - パブリックIPアドレスを含む
# タイプ: string
# 読み取り専用: はい
#
# 割り当てられたElastic IPアドレス。
# インターネットからアクセス可能なパブリックIPv4アドレスです。
#
# 使用例:
# - DNSレコードの設定
# - ファイアウォールルールの設定
# - ホワイトリスト登録
# - ドキュメントや設定ファイルへの記載
#
# 参照方法: aws_eip.example_basic.public_ip


# ================================================================
# 使用例1: 複数のEIPを単一のネットワークインターフェースに関連付け
# ================================================================
resource "aws_network_interface" "multi_ip" {
  subnet_id   = aws_subnet.example.id
  private_ips = ["10.0.1.10", "10.0.1.11"]

  tags = {
    Name = "multi-ip-interface"
  }
}

resource "aws_eip" "multi_one" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.multi_ip.id
  associate_with_private_ip = "10.0.1.10"

  tags = {
    Name = "eip-for-10.0.1.10"
  }
}

resource "aws_eip" "multi_two" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.multi_ip.id
  associate_with_private_ip = "10.0.1.11"

  tags = {
    Name = "eip-for-10.0.1.11"
  }
}

# ================================================================
# 使用例2: 事前に割り当てられたプライベートIPを持つインスタンスへの関連付け
# ================================================================
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example-igw"
  }
}

resource "aws_subnet" "example" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  # Internet Gatewayへの依存関係を設定
  depends_on = [aws_internet_gateway.example]

  tags = {
    Name = "example-subnet"
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2（リージョンにより異なる）
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.example.id
  private_ip    = "10.0.1.12"

  tags = {
    Name = "example-instance"
  }
}

resource "aws_eip" "with_instance" {
  domain                    = "vpc"
  instance                  = aws_instance.example.id
  associate_with_private_ip = "10.0.1.12"

  # EIPはInternet Gatewayが存在する必要があります
  depends_on = [aws_internet_gateway.example]

  tags = {
    Name = "eip-for-instance"
  }
}

# ================================================================
# 使用例3: BYOIPプールからのEIP割り当て
# ================================================================
resource "aws_eip" "byoip" {
  domain           = "vpc"
  public_ipv4_pool = "ipv4pool-ec2-012345" # BYOIPプールID

  tags = {
    Name = "byoip-eip"
    Type = "BYOIP"
  }
}

# ================================================================
# 使用例4: IPAMプールからのEIP割り当て
# ================================================================
resource "aws_eip" "ipam" {
  domain       = "vpc"
  ipam_pool_id = "ipam-pool-07ccc86aa41bef7ce"

  tags = {
    Name = "ipam-managed-eip"
    Type = "IPAM"
  }
}

# ================================================================
# 使用例5: NAT GatewayでのEIP使用（推奨パターン）
# ================================================================
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-eip"
  }

  # NAT GatewayはInternet Gatewayに依存します
  depends_on = [aws_internet_gateway.example]
}

resource "aws_nat_gateway" "example" {
  # EIPのallocation_idを使用（network_interfaceやinstanceは使用しない）
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.example.id

  tags = {
    Name = "example-nat-gateway"
  }

  depends_on = [aws_internet_gateway.example]
}

# ================================================================
# 使用例6: 特定のネットワークボーダーグループでのEIP割り当て
# （Local ZoneやWavelength Zone使用時）
# ================================================================
resource "aws_eip" "local_zone" {
  domain              = "vpc"
  network_border_group = "us-west-2-lax-1" # Los Angeles Local Zone

  tags = {
    Name = "local-zone-eip"
    Zone = "LAX-1"
  }
}

# ================================================================
# Outputs - 他のモジュールやリソースで使用可能
# ================================================================
output "eip_id" {
  description = "EIPの割り当てID（allocation_id）"
  value       = aws_eip.example_basic.id
}

output "eip_public_ip" {
  description = "割り当てられたElastic IPアドレス"
  value       = aws_eip.example_basic.public_ip
}

output "eip_allocation_id" {
  description = "VPCでのElastic IP割り当てID（NAT Gateway等で使用）"
  value       = aws_eip.example_basic.allocation_id
}

output "eip_association_id" {
  description = "インスタンスとの関連付けID"
  value       = aws_eip.example_basic.association_id
}

output "eip_public_dns" {
  description = "パブリックDNS名"
  value       = aws_eip.example_basic.public_dns
}

output "eip_private_dns" {
  description = "プライベートDNS名（VPC内）"
  value       = aws_eip.example_basic.private_dns
}

output "eip_private_ip" {
  description = "関連付けられたプライベートIPアドレス"
  value       = aws_eip.example_basic.private_ip
}

# ================================================================
# ベストプラクティスと注意事項
# ================================================================
#
# 1. コスト管理
#    - 使用中・未使用に関わらず、すべてのEIPに課金されます
#    - 不要になったEIPは速やかに解放してください
#    - パブリックIPv4アドレスの課金についてAWS価格表を確認してください
#
# 2. 制限とクォータ
#    - デフォルトでは各リージョンで5個のEIPに制限されています
#    - BYOIPプールからのEIPは制限にカウントされません
#    - 制限の引き上げはService Quotasコンソールから申請できます
#
# 3. 依存関係管理
#    - EIPの関連付けにはInternet Gatewayが必要な場合があります
#    - depends_on を使用して明示的な依存関係を設定してください
#    - NAT GatewayやLoad BalancerとのEIP関連付けには allocation_id を使用
#
# 4. DNS設定
#    - VPCでenableDnsHostnamesを有効にすると、パブリック/プライベートDNS名が
#      自動的に設定されます
#    - DNS名はVPC内部と外部で異なるIPアドレスに解決されます
#
# 5. セキュリティ
#    - EIPは静的なパブリックIPのため、セキュリティグループやNACLで
#      適切にアクセス制御を実施してください
#    - 不要なEIPへの関連付けは避け、最小権限の原則に従ってください
#
# 6. 高可用性設計
#    - EIPはインスタンス障害時の迅速なフェイルオーバーに使用できます
#    - ただし、EIPの再関連付けには時間がかかる場合があります
#    - DNSベースのフェイルオーバーも検討してください
#
# 7. マルチリージョン対応
#    - EIPはリージョン固有のリソースです
#    - マルチリージョン構成では、各リージョンで個別にEIPを割り当てる
#      必要があります
#
# 8. EIP転送時の注意点
#    - EIP転送時、関連付けられているタグはリセットされます
#    - 転送前にEIPを関連付けから解除する必要があります
#    - カスタムPTRレコードが設定されている場合は、転送前に削除が必要です
#    - BYOIPおよびCoIPプールからのEIPは転送できません
#
# 9. IPAMとの統合
#    - 大規模環境ではIPAMを使用してIPアドレスを一元管理することを推奨
#    - 連続したIPアドレスが必要な場合はIPAMプールを使用
#    - 組織全体でのIP使用状況の追跡とモニタリングが可能
#
# 10. モニタリングとアラート
#     - CloudWatch でEIPの関連付け状態を監視
#     - 未使用のEIPに対するアラートを設定してコスト削減
#     - EIP制限の使用率を監視してクォータ超過を防止
#
# ================================================================

