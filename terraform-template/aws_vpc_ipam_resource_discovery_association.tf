#---------------------------------------------------------------
# VPC IPAM Resource Discovery Association
#---------------------------------------------------------------
#
# Amazon VPC IPAMとIPAMリソースディスカバリー間の関連付けをプロビジョニングするリソースです。
# IPAMリソースディスカバリーは、マルチ組織の顧客向けのリソースであり、
# 複数の組織で単一のIPAMを使用する場合、リソースディスカバリーを作成して
# 下位組織から管理組織のIPAM委任管理者アカウントに共有できます。
# 関連付けが確立されると、IPAMプールをRAM（Resource Access Manager）経由で
# 下位組織のアカウントと共有でき、下位組織のIPAMリソースを検出・監視できます。
#
# AWS公式ドキュメント:
#   - IPAM Resource Discovery の関連付け: https://docs.aws.amazon.com/vpc/latest/ipam/res-disc-work-with-associate.html
#   - AssociateIpamResourceDiscovery API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AssociateIpamResourceDiscovery.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_resource_discovery_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_ipam_resource_discovery_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # ipam_id (Required)
  # 設定内容: 関連付けるIPAMのIDを指定します。
  # 設定可能な値: 有効なIPAM ID（ipam-xxxxx形式）
  # 関連機能: VPC IPAM
  #   IPAMは、VPCとサブネット全体のIPアドレスを計画、追跡、および監視するために使用します。
  #   - https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
  ipam_id = "ipam-12345678901234567"

  # ipam_resource_discovery_id (Required)
  # 設定内容: 関連付けるリソースディスカバリーのIDを指定します。
  # 設定可能な値: 有効なIPAMリソースディスカバリーID（ipam-res-disco-xxxxx形式）
  # 関連機能: IPAM Resource Discovery
  #   IPAMリソースディスカバリーは、所有アカウントに属するリソースを管理および監視するIPAMコンポーネントです。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AssociateIpamResourceDiscovery.html
  ipam_resource_discovery_id = "ipam-res-disco-12345678901234567"

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
  #   - https://docs.aws.amazon.com/vpc/latest/ipam/res-disc-work-with-associate.html
  tags = {
    Name        = "example-ipam-resource-discovery-association"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: IPAMリソースディスカバリー関連付けのAmazon Resource Name (ARN)
#
# - id: IPAMリソースディスカバリー関連付けのID
#
# - ipam_arn: IPAMのAmazon Resource Name (ARN)
#
# - ipam_region: IPAMのホームリージョン
#
# - is_default: リソースディスカバリーがアカウントのデフォルトリソースディスカバリーであるかを示すブール値
#
# - owner_id: リソースディスカバリーを管理するアカウントのアカウントID
#
# - state: リソースディスカバリーを関連付けまたは関連付け解除する際の関連付けのライフサイクル状態
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
