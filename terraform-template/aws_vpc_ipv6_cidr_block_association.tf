#---------------------------------------------------------------
# VPC IPv6 CIDR Block Association
#---------------------------------------------------------------
#
# VPCに追加のIPv6 CIDRブロックを関連付けるためのリソースです。
# このリソースを使用すると、既存のVPCに対してIPv6 CIDRブロックを追加できます。
# VPCは最大5つまでのIPv6 CIDRブロック（/44から/60まで、4刻み）を持つことができます。
#
# AWS公式ドキュメント:
#   - VPC CIDR ブロック: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html
#   - VPC IPv6サポートの追加: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-migrate-ipv6-add.html
#   - AssociateVpcCidrBlock API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AssociateVpcCidrBlock.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv6_cidr_block_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_ipv6_cidr_block_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: 関連付けを行うVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-12345678）
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html
  vpc_id = "vpc-12345678"

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformが自動的に生成（通常は明示的に指定する必要はありません）
  # 注意: 通常このパラメータを設定することはありません。Terraformが自動的にIDを管理します。
  id = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # IPv6 CIDR ブロック設定
  #-------------------------------------------------------------

  # assign_generated_ipv6_cidr_block (Optional)
  # 設定内容: Amazon提供のIPv6 CIDRブロック（/56プレフィックス長）をリクエストします。
  # 設定可能な値:
  #   - true: Amazon提供のIPv6 CIDRブロックをリクエスト（IPアドレスの範囲やCIDRブロックのサイズは指定不可）
  #   - false (デフォルト): Amazon提供のIPv6 CIDRブロックをリクエストしない
  # 省略時: false
  # 注意: ipv6_ipam_pool_id、ipv6_pool、ipv6_cidr_block、ipv6_netmask_lengthと排他的（同時に指定不可）
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html#vpc-sizing-ipv6
  assign_generated_ipv6_cidr_block = false

  # ipv6_cidr_block (Optional)
  # 設定内容: VPCに割り当てるIPv6 CIDRブロックを明示的に指定します。
  # 設定可能な値: 有効なIPv6 CIDRブロック（例: 2001:db8::/56）
  # 省略時: ipv6_netmask_lengthが設定されている場合はIPAMから派生、または
  #        IPAMプールにallocation_default_netmaskが設定されている場合はそれを使用
  # 注意:
  #   - ipv6_netmask_lengthが設定されていない場合で、かつIPAMプールに
  #     allocation_default_netmaskが設定されていない場合は、このパラメータが必須
  #   - assign_generated_ipv6_cidr_blockと排他的（同時に指定不可）
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html#vpc-sizing-ipv6
  ipv6_cidr_block = null

  # ipv6_ipam_pool_id (Optional)
  # 設定内容: このVPCのIPv6 CIDRの割り当てに使用するIPAMプールのIDを指定します。
  # 設定可能な値: 有効なIPAM IPv6プールID（例: ipam-pool-12345678）
  # 省略時: IPAMを使用しない
  # 関連機能: AWS IPAM (IP Address Manager)
  #   VPC機能の一つで、AWS組織全体およびリージョン間でIPアドレス管理ワークフロー
  #   （割り当て、追跡、トラブルシューティング、監査）を自動化できます。
  #   - https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
  # 注意: assign_generated_ipv6_cidr_blockおよびipv6_poolと排他的（同時に指定不可）
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html#vpc-sizing-ipv6
  ipv6_ipam_pool_id = null

  # ipv6_netmask_length (Optional)
  # 設定内容: このVPCに割り当てるIPv6 CIDRのネットマスク長を指定します。
  # 設定可能な値: 44から60まで、4刻み（44, 48, 52, 56, 60）
  # 省略時: IPAMプールにallocation_default_netmaskが設定されている場合はそれを使用、
  #        設定されていない場合はipv6_cidr_blockが必須
  # 注意:
  #   - ipv6_ipam_pool_idの指定が必要
  #   - ipv6_cidr_blockと排他的（同時に指定不可）
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html#vpc-sizing-ipv6
  ipv6_netmask_length = null

  # ipv6_pool (Optional)
  # 設定内容: IPv6 CIDRブロックを割り当てるIPv6アドレスプールのIDを指定します。
  # 設定可能な値: 有効なIPv6アドレスプールID
  # 省略時: IPv6アドレスプールを使用しない
  # 注意: assign_generated_ipv6_cidr_blockおよびipv6_ipam_pool_idと排他的（同時に指定不可）
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html#vpc-sizing-ipv6
  ipv6_pool = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 設定可能な値:
  #   - create: リソース作成のタイムアウト時間（例: "10m"）
  #   - delete: リソース削除のタイムアウト時間（例: "10m"）
  # 省略時: Terraformのデフォルトタイムアウトを使用
  timeouts {
    create = "10m"
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - ip_source: IPアドレス空間を割り当てたソース
#        設定可能な値:
#          - "amazon": AmazonによってパブリックIPアドレス空間が割り当てられた
#          - "byoip": Bring Your Own IP (BYOIP)でユーザーが割り当てた空間
#          - "none": プライベート空間
#
# - ipv6_address_attribute: IPv6アドレスがパブリックかプライベートかを指定
#        設定可能な値:
#          - "public": AWSからインターネット上で広告されるパブリックIPv6アドレス
#          - "private": AWSからインターネット上で広告されないプライベートIPアドレス
#---------------------------------------------------------------
