#---------------------------------------------------------------
# Amazon VPC (Virtual Private Cloud)
#---------------------------------------------------------------
#
# Amazon Virtual Private Cloud (VPC) を作成します。VPCは、AWSクラウド内に論理的に
# 分離されたネットワークセグメントを提供し、EC2インスタンスなどのAWSリソースを
# 起動できます。IPアドレス範囲、サブネット、ルートテーブル、ネットワークゲートウェイを
# 完全に制御できます。
#
# AWS公式ドキュメント:
#   - Amazon VPC とは: https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html
#   - VPC CIDR ブロック: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc" "example" {
  #---------------------------------------------------------------
  # IPv4 CIDR設定
  #---------------------------------------------------------------
  # VPCのIPv4 CIDRブロック。明示的に設定するか、ipv4_netmask_lengthを使用して
  # IPAMから割り当てることができます。
  # 例: "10.0.0.0/16", "172.16.0.0/12", "192.168.0.0/16"
  #
  # 注意:
  # - IPAMを使用する場合はipv4_ipam_pool_idとipv4_netmask_lengthを指定
  # - 既存のネットワークやVPCピアリングを考慮してCIDRを選択
  cidr_block = "10.0.0.0/16"

  #---------------------------------------------------------------
  # インスタンステナンシー
  #---------------------------------------------------------------
  # VPC内に起動されるインスタンスのテナンシーオプション。
  #
  # 有効な値:
  # - "default" (デフォルト): EC2インスタンス起動時に指定されたテナンシー属性を使用
  # - "dedicated": VPC内のすべてのEC2インスタンスを専有インスタンスとして起動
  #                起動時の属性に関わらず専有ハードウェアで実行される
  #
  # 注意: dedicatedを選択すると、リージョンごとに$2/時の固定料金と
  #       インスタンスごとの時間料金が発生します
  instance_tenancy = "default"

  #---------------------------------------------------------------
  # IPv4 IPAM設定
  #---------------------------------------------------------------
  # IPv4 CIDRの割り当てに使用するIPAMプールID。
  # IPAMは、AWS OrganizationとリージョンにわたってIPアドレスの割り当て、追跡、
  # トラブルシューティング、監査を自動化するVPC機能です。
  #
  # 使用条件: ipv4_netmask_lengthと併用してCIDRを自動割り当て
  ipv4_ipam_pool_id = null

  # IPAMプールから割り当てるIPv4 CIDRのネットマスク長。
  # ipv4_ipam_pool_idの指定が必要です。
  #
  # 有効な値: IPAMプール設定に応じた値（例: 16-28）
  ipv4_netmask_length = null

  #---------------------------------------------------------------
  # IPv6設定
  #---------------------------------------------------------------
  # Amazon提供のIPv6 CIDRブロック（/56プレフィックス長）をリクエストします。
  # IPアドレス範囲やCIDRブロックサイズは指定できません。
  #
  # デフォルト: false
  # 競合: ipv6_ipam_pool_idとは同時に使用できません
  assign_generated_ipv6_cidr_block = false

  # IPAMプールからリクエストするIPv6 CIDRブロック。
  # 明示的に設定するか、ipv6_netmask_lengthを使用してIPAMから導出できます。
  #
  # 競合: assign_generated_ipv6_cidr_blockとは同時に使用できません
  ipv6_cidr_block = null

  # IPv6プールに使用するIPAMプールID。
  #
  # 競合: assign_generated_ipv6_cidr_blockとは同時に使用できません
  ipv6_ipam_pool_id = null

  # IPAMプールからリクエストするネットマスク長。
  # IPAMプールにallocation_default_netmask_lengthが設定されている場合は省略可能。
  #
  # 有効な値: 44から60まで、4刻み（44, 48, 52, 56, 60）
  # 競合: ipv6_cidr_blockとは同時に使用できません
  ipv6_netmask_length = null

  # VPCにIPv6 CIDRが割り当てられた際のデフォルトの
  # ipv6_cidr_block_network_border_groupはVPCのリージョンに設定されます。
  # これを変更して、パブリックアドレスの広告を特定のネットワークボーダーグループ
  # （LocalZonesなど）に制限できます。
  ipv6_cidr_block_network_border_group = null

  #---------------------------------------------------------------
  # DNS設定
  #---------------------------------------------------------------
  # VPC内のDNSサポートを有効/無効にするブールフラグ。
  #
  # デフォルト: true
  #
  # 注意: DNSサポートを無効にすると、VPC内のインスタンスは
  #       Amazon提供のDNSサーバーを使用できなくなります
  enable_dns_support = true

  # VPC内のDNSホスト名を有効/無効にするブールフラグ。
  # 有効にすると、VPC内のインスタンスにパブリックDNSホスト名が割り当てられます。
  #
  # デフォルト: false
  #
  # 注意: この設定を有効にするには、enable_dns_supportもtrueである必要があります
  enable_dns_hostnames = false

  #---------------------------------------------------------------
  # ネットワークアドレス使用状況メトリクス
  #---------------------------------------------------------------
  # VPCのネットワークアドレス使用状況メトリクスを有効にするかどうかを示します。
  # 有効にすると、VPC内のIPアドレスの使用状況をCloudWatchメトリクスで監視できます。
  #
  # デフォルト: false
  enable_network_address_usage_metrics = false

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------
  # このリソースが管理されるリージョン。
  # プロバイダー設定で設定されたリージョンがデフォルトで使用されます。
  #
  # 参照:
  # - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  region = null

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------
  # リソースに割り当てるタグのマップ。
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  #
  # 例:
  # tags = {
  #   Name        = "main-vpc"
  #   Environment = "production"
  #   Project     = "example-project"
  # }
  tags = {
    Name = "example-vpc"
  }

  # リソースに割り当てられたタグのマップ。
  # プロバイダーのdefault_tags設定ブロックから継承されたタグを含みます。
  #
  # 注意: このフィールドはcomputed属性であるため、通常は設定不要です。
  #       プロバイダーレベルのdefault_tagsとリソース固有のtagsが自動的にマージされます。
  tags_all = null

  #---------------------------------------------------------------
  # ID (通常は設定不要)
  #---------------------------------------------------------------
  # VPCのID。通常はTerraformが自動的に管理するため設定不要です。
  # インポート時やstate管理の特殊なケースでのみ使用します。
  id = null
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（参照のみ、設定不可）:
#
# - arn: VPCのAmazon Resource Name (ARN)
# - id: VPCのID
# - instance_tenancy: VPC内でスピンアップされるインスタンスのテナンシー
# - dhcp_options_id: VPCに関連付けられたDHCPオプションID
# - enable_dns_support: VPCがDNSサポートを持っているかどうか
# - enable_network_address_usage_metrics: VPCでネットワークアドレス使用状況メトリクスが有効かどうか
# - enable_dns_hostnames: VPCがDNSホスト名サポートを持っているかどうか
# - main_route_table_id: このVPCに関連付けられたメインルートテーブルのID
#                        注意: aws_main_route_table_associationを使用してVPCのメインルートテーブルを変更できます
# - default_network_acl_id: VPC作成時にデフォルトで作成されたネットワークACLのID
# - default_security_group_id: VPC作成時にデフォルトで作成されたセキュリティグループのID
# - default_route_table_id: VPC作成時にデフォルトで作成されたルートテーブルのID
# - ipv6_association_id: IPv6 CIDRブロックの関連付けID
# - ipv6_cidr_block_network_border_group: ネットワークボーダーグループゾーン名
# - owner_id: VPCを所有するAWSアカウントのID
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたタグのマップ
#
# 使用例:
# output "vpc_id" {
#   value = aws_vpc.example.id
# }
#
# output "vpc_arn" {
#   value = aws_vpc.example.arn
# }
#---------------------------------------------------------------
