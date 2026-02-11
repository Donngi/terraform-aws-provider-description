#---------------------------------------------------------------
# AWS VPC Lattice Service Network Service Association
#---------------------------------------------------------------
#
# Amazon VPC LatticeのサービスネットワークとサービスのAssociation（関連付け）を
# プロビジョニングするリソースです。サービスをサービスネットワークに関連付けることで、
# そのサービスネットワークに関連付けられたVPC内のクライアントがサービスに
# アクセスできるようになります。
#
# AWS公式ドキュメント:
#   - VPC Lattice概要: https://docs.aws.amazon.com/vpc-lattice/latest/ug/what-is-vpc-lattice.html
#   - サービスネットワークの関連付け: https://docs.aws.amazon.com/vpc-lattice/latest/ug/service-network-associations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_service_network_service_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpclattice_service_network_service_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # service_identifier (Required)
  # 設定内容: 関連付けるサービスのIDまたはARNを指定します。
  # 設定可能な値: VPC Latticeサービスの有効なIDまたはARN
  # 注意: サービスは事前に作成されている必要があります。
  # 参考: https://docs.aws.amazon.com/vpc-lattice/latest/ug/services.html
  service_identifier = "svc-0123456789abcdef0"

  # service_network_identifier (Required)
  # 設定内容: 関連付けるサービスネットワークのIDまたはARNを指定します。
  # 設定可能な値: VPC Latticeサービスネットワークの有効なIDまたはARN
  # 注意: 異なるアカウントのリソースを指定する場合はARNを使用する必要があります。
  # 参考: https://docs.aws.amazon.com/vpc-lattice/latest/ug/service-networks.html
  service_network_identifier = "sn-0123456789abcdef0"

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
  tags = {
    Name        = "example-service-association"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 各操作のタイムアウト時間を指定します。
  # 関連機能: Terraform Operation Timeouts
  #   リソースの作成・更新・削除操作に対するタイムアウトをカスタマイズできます。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AssociationのAmazon Resource Name (ARN)
#
# - created_by: Associationを作成したアカウント
#
# - custom_domain_name: サービスのカスタムドメイン名
#
# - dns_entry: サービスのDNS情報
#   - domain_name: サービスのドメイン名
#   - hosted_zone_id: ホストゾーンのID
#
# - id: AssociationのID
#
# - status: 操作ステータス
#   有効な値: CREATE_IN_PROGRESS | ACTIVE | DELETE_IN_PROGRESS |
#            CREATE_FAILED | DELETE_FAILED
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
