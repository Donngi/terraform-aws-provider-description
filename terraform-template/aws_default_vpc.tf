#---------------------------------------------------------------
# AWS Default VPC
#---------------------------------------------------------------
#
# デフォルトVPCを管理するための高度なリソースです。このリソースには特別な注意事項があります。
# デフォルトVPCが既に存在する場合、Terraformはこのリソースを作成せず、代わりに既存のVPCを
# 管理下に「採用」します。デフォルトVPCが存在しない場合、Terraformは新しいデフォルトVPCを作成し、
# これにより他のリソース（サブネット、ルートテーブル、セキュリティグループなど）も暗黙的に作成されます。
#
# デフォルトでは、terraform destroyはデフォルトVPCを削除せず、Terraform管理から除外するのみです。
# デフォルトVPCを削除するには、force_destroy引数をtrueに設定する必要があります。
#
# 2013年12月4日以降にAWSアカウントを作成した場合、各リージョンにデフォルトVPCが存在します。
#
# AWS公式ドキュメント:
#   - Default VPCs: https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html
#   - Default VPC Components: https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html#default-vpc-components
#   - Amazon VPC User Guide: https://docs.aws.amazon.com/vpc/latest/userguide/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_default_vpc" "example" {
  #-------------------------------------------------------------
  # DNS設定 (オプション)
  #-------------------------------------------------------------

  # enable_dns_hostnames (Optional)
  # 設定内容: VPC内のインスタンスにパブリックDNSホスト名を割り当てるかを指定します。
  # 設定可能な値:
  #   - true: パブリックIPを持つインスタンスにDNSホスト名を割り当て（推奨）
  #   - false: DNSホスト名を割り当てない
  # 省略時: AWS側のデフォルト設定が使用されます（通常はtrue）
  # 注意: この機能を有効にするには、enable_dns_supportもtrueである必要があります。
  #       パブリックサブネット内のインスタンスがインターネットから到達可能にするために
  #       有効にすることが一般的です。
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html#vpc-dns-hostnames
  enable_dns_hostnames = true

  # enable_dns_support (Optional)
  # 設定内容: VPCのDNS解決サポートを有効にするかを指定します。
  # 設定可能な値:
  #   - true: Amazon提供のDNSサーバーを使用してDNS解決を有効化（推奨）
  #   - false: DNS解決を無効化
  # 省略時: AWS側のデフォルト設定が使用されます（通常はtrue）
  # 注意: この設定を無効にすると、VPC内のインスタンスはAmazon DNSサーバーを使用できなくなり、
  #       Route 53プライベートホストゾーンやVPCエンドポイントのDNS名が機能しなくなります。
  #       ほとんどのユースケースでtrueを維持することが推奨されます。
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html#vpc-dns-support
  enable_dns_support = true

  #-------------------------------------------------------------
  # IPv6設定 (オプション)
  #-------------------------------------------------------------

  # assign_generated_ipv6_cidr_block (Optional)
  # 設定内容: Amazon提供のIPv6 CIDRブロックをVPCに割り当てるかを指定します。
  # 設定可能な値:
  #   - true: Amazon提供の/56プレフィックスを持つIPv6 CIDRブロックを自動割り当て
  #   - false: IPv6を使用しない
  # 省略時: falseとして扱われ、IPv6は割り当てられません
  # 注意: trueに設定すると、AmazonのグローバルユニキャストIPv6アドレスプールから
  #       自動的にCIDRブロックが割り当てられます。IPv6を使用する場合は、
  #       サブネットにもIPv6 CIDRブロックを割り当てる必要があります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-ipv6.html
  assign_generated_ipv6_cidr_block = false

  # ipv6_cidr_block (Optional)
  # 設定内容: VPCに割り当てるIPv6 CIDRブロックを明示的に指定します。
  # 設定可能な値: 有効なIPv6 CIDR表記（/56プレフィックス）
  # 省略時: Amazon提供のCIDRブロックが自動割り当てされます
  # 注意: この属性を使用するには、ipv6_ipam_pool_idと組み合わせて使用する必要があります。
  #       IPAMプールから特定のCIDRブロックを選択する際に使用します。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
  ipv6_cidr_block = null

  # ipv6_ipam_pool_id (Optional)
  # 設定内容: IPv6アドレスをプロビジョニングするIPAMプールのIDを指定します。
  # 設定可能な値: IPAMプールID（ipam-pool-xxxxxxxxxxxxxxxxx形式）
  # 省略時: Amazon提供のIPv6アドレスプールが使用されます
  # 注意: AWS IPAMを使用してIPv6アドレス空間を管理する場合に使用します。
  #       この機能を使用するには、事前にIPAMプールを作成する必要があります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
  ipv6_ipam_pool_id = null

  # ipv6_netmask_length (Optional)
  # 設定内容: IPAMプールから割り当てるIPv6 CIDRのネットマスク長を指定します。
  # 設定可能な値: 整数値（通常は56）
  # 省略時: IPAMプールのデフォルト設定が使用されます
  # 注意: ipv6_ipam_pool_idを指定した場合に使用できます。
  #       VPCのIPv6 CIDRブロックのサイズを制御します。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/how-it-works-ipam.html
  ipv6_netmask_length = null

  # ipv6_cidr_block_network_border_group (Optional)
  # 設定内容: IPv6 CIDRブロックのネットワーク境界グループを指定します。
  # 設定可能な値: ネットワーク境界グループ名（通常はリージョン名と同じ）
  # 省略時: VPCが作成されるリージョンのネットワーク境界グループが使用されます
  # 注意: ローカルゾーンやWavelengthゾーンでVPCを使用する場合に関連します。
  #       通常のユースケースでは明示的に指定する必要はありません。
  # 参考: https://docs.aws.amazon.com/local-zones/latest/ug/how-local-zones-work.html
  ipv6_cidr_block_network_border_group = null

  #-------------------------------------------------------------
  # ネットワークメトリクス設定 (オプション)
  #-------------------------------------------------------------

  # enable_network_address_usage_metrics (Optional, Computed)
  # 設定内容: VPCのネットワークアドレス使用状況メトリクスを有効にするかを指定します。
  # 設定可能な値:
  #   - true: CloudWatchでIPアドレス使用状況メトリクスを収集
  #   - false: メトリクス収集を無効化
  # 省略時: AWSのデフォルト設定が使用されます
  # 注意: この機能を有効にすると、VPC内のIPアドレス使用状況を監視できます。
  #       IPアドレス枯渇の問題を早期に検出するのに役立ちます。
  #       追加の課金が発生する可能性があります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/network-address-usage.html
  enable_network_address_usage_metrics = false

  #-------------------------------------------------------------
  # 削除保護設定 (オプション)
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: terraform destroyでデフォルトVPCを削除するかを指定します。
  # 設定可能な値:
  #   - true: terraform destroyでデフォルトVPCを完全に削除
  #   - false: terraform destroyでVPCを削除せず、Terraform管理から除外のみ（デフォルト）
  # 省略時: false（デフォルトVPCは削除されません）
  # 注意: デフォルトVPCを削除すると、そのリージョンでデフォルトVPCが存在しない状態になります。
  #       削除後に新しいデフォルトVPCを作成するには、AWSコンソールまたはCLIを使用する必要があります。
  #       本番環境では慎重に使用してください。
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html#deleting-default-vpc
  force_destroy = false

  #-------------------------------------------------------------
  # リージョン設定 (オプション)
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンが使用されます
  # 注意: この設定を使用すると、プロバイダーのデフォルトリージョンとは異なるリージョンの
  #       デフォルトVPCを管理できます。マルチリージョン構成で有用です。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定 (オプション)
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: デフォルトVPCに適用するタグを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されません
  # 注意: タグを使用してリソースを分類、検索、コスト配分できます。
  #       適切な命名規則とタグ付け戦略を策定することが推奨されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "Default VPC"
    Environment = "default"
    ManagedBy   = "Terraform"
  }

  # tags_all (Optional, Computed)
  # 設定内容: このリソースとその子リソースに適用されるすべてのタグ（プロバイダーレベルのデフォルトタグを含む）
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: プロバイダー設定のdefault_tagsとリソースのtagsがマージされます
  # 注意: この属性は主に読み取り用です。通常はtagsとプロバイダーのdefault_tagsで管理します。
  #       プロバイダーレベルでデフォルトタグを設定している場合、それらが自動的に含まれます。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags
  tags_all = null

  #-------------------------------------------------------------
  # リソースID設定 (オプション)
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: デフォルトVPCのIDを明示的に指定します。
  # 設定可能な値: VPC ID（vpc-xxxxxxxxxxxxxxxxx形式）
  # 省略時: デフォルトVPCのIDが自動的に検出されます
  # 注意: この属性は通常、既存のデフォルトVPCをインポートする際に自動的に設定されます。
  #       新規作成時に手動で指定する必要はありません。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc#import
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: VPCのAmazon Resource Name (ARN)
#   形式: arn:aws:ec2:region:account-id:vpc/vpc-id
#   用途: IAMポリシーやリソースベースのポリシーで使用
#
# - cidr_block: VPCに割り当てられたプライマリIPv4 CIDRブロック
#   形式: CIDR表記（例: 172.31.0.0/16）
#   注意: デフォルトVPCは通常172.31.0.0/16が割り当てられます
#
# - instance_tenancy: VPC内のインスタンスに許可されるテナンシー
#   取り得る値:
#     - default: 共有ハードウェアで実行（通常）
#     - dedicated: 専有ハードウェアで実行
#   注意: デフォルトVPCのテナンシーは通常"default"です
#
# - default_network_acl_id: VPCに関連付けられたデフォルトネットワークACLのID
#   形式: acl-xxxxxxxxxxxxxxxxx
#   用途: デフォルトネットワークACLを参照または管理する際に使用
#
# - default_route_table_id: VPCに関連付けられたデフォルトルートテーブルのID
#   形式: rtb-xxxxxxxxxxxxxxxxx
#   用途: デフォルトルートテーブルを参照または管理する際に使用
#
# - default_security_group_id: VPCに関連付けられたデフォルトセキュリティグループのID
#   形式: sg-xxxxxxxxxxxxxxxxx
#   用途: デフォルトセキュリティグループを参照または管理する際に使用
#
# - dhcp_options_id: VPCに関連付けられたDHCPオプションセットのID
#   形式: dopt-xxxxxxxxxxxxxxxxx
#   用途: DHCPオプションセットを参照または変更する際に使用
#
# - main_route_table_id: VPCのメインルートテーブルのID
#   形式: rtb-xxxxxxxxxxxxxxxxx
#   注意: default_route_table_idと同じ値になることが多い
#
# - owner_id: VPCを所有するAWSアカウントID
#   形式: 12桁の数字
#   用途: クロスアカウント参照やリソース所有権の確認
#
# - ipv6_association_id: IPv6 CIDRブロックのアソシエーションID
#   形式: vpc-cidr-assoc-xxxxxxxxxxxxxxxxx
#   注意: assign_generated_ipv6_cidr_blockがtrueの場合に設定されます
#
# - ipv6_cidr_block: VPCに割り当てられたIPv6 CIDRブロック
#   形式: IPv6 CIDR表記（例: 2600:1f13:fc2:a700::/56）
#   注意: IPv6が有効な場合のみ設定されます
#
# - existing_default_vpc: このリソースが既存のデフォルトVPCを採用したかどうか
#   取り得る値:
#     - true: 既存のデフォルトVPCを採用
#     - false: 新しいデフォルトVPCを作成
#   用途: デフォルトVPCの管理状況を判断する際に使用
#
# - region: VPCが作成されているAWSリージョン
#   形式: リージョンコード（例: us-east-1）
#   用途: マルチリージョン構成での確認
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import (既存リソースのインポート)
#---------------------------------------------------------------
# 既存のデフォルトVPCをTerraform管理下に取り込むには:
#
# terraform import aws_default_vpc.example vpc-xxxxxxxxxxxxxxxxx
#
# 注意:
#   - VPC IDは、AWSコンソールまたはAWS CLIで確認できます
#   - インポート後、terraform planを実行して設定の差分を確認してください
#   - デフォルトVPCは各リージョンに1つのみ存在します
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例とベストプラクティス
#---------------------------------------------------------------
# 1. デフォルトVPCの採用と基本的なタグ付け
#    - 既存のデフォルトVPCを管理下に置き、適切なタグを設定
#    - force_destroyはfalseのまま、誤削除を防ぐ
#
# 2. DNS機能の有効化
#    - enable_dns_hostnamesとenable_dns_supportを両方trueに設定
#    - パブリックサブネット内のインスタンスに自動的にDNS名を割り当て
#
# 3. IPv6の有効化
#    - assign_generated_ipv6_cidr_blockをtrueに設定
#    - 次世代インターネットプロトコルに対応
#
# 4. 組織的なタグ付け戦略
#    - 環境、プロジェクト、コスト配分のためのタグを統一
#    - プロバイダーレベルのdefault_tagsと組み合わせて使用
#
# 5. セキュリティ考慮事項
#    - デフォルトVPCは広く知られた設定のため、本番環境では
#      カスタムVPCの使用を検討
#    - デフォルトセキュリティグループのルールを確認・制限
#
# 注意事項:
#   - デフォルトVPCは特別なリソースであり、通常のVPCとは動作が異なります
#   - 本番環境では、より詳細な制御が可能なaws_vpcリソースの使用を推奨
#   - デフォルトVPCを削除する場合は、依存するリソース（インスタンス、
#     サブネットなど）が存在しないことを確認してください
#
#---------------------------------------------------------------
