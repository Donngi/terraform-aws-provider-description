#---------------------------------------------------------------
# AWS VPC Lattice Service Network VPC Association
#---------------------------------------------------------------
#
# Amazon VPC LatticeのサービスネットワークにVPCを関連付けるリソースです。
# VPCをサービスネットワークに関連付けることで、そのVPC内のリソースが
# サービスネットワーク上の他のサービスやリソース設定に接続できるようになります。
# 関連付けはサービスネットワークアカウントとVPCオーナーアカウントの
# 両方に作成されます。
#
# AWS公式ドキュメント:
#   - VPC Lattice サービスネットワークの関連付け管理: https://docs.aws.amazon.com/vpc-lattice/latest/ug/service-network-associations.html
#   - セキュリティグループを使用したVPC Latticeトラフィック制御: https://docs.aws.amazon.com/vpc-lattice/latest/ug/security-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_service_network_vpc_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpclattice_service_network_vpc_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # service_network_identifier (Required)
  # 設定内容: 関連付けるサービスネットワークのIDまたはARNを指定します。
  # 設定可能な値: サービスネットワークのID（snw-xxxxxxxxxxxxxxxxx）またはARN
  # 注意: 異なるアカウントのリソースを指定する場合はARNを使用する必要があります。
  service_network_identifier = "snw-xxxxxxxxxxxxxxxxx"

  # vpc_identifier (Required)
  # 設定内容: サービスネットワークに関連付けるVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-xxxxxxxxxxxxxxxxx）
  # 注意: 1つのVPCは1つのサービスネットワークに対して1つの関連付けのみ持てます。
  vpc_identifier = "vpc-xxxxxxxxxxxxxxxxx"

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
  # ネットワーク設定
  #-------------------------------------------------------------

  # security_group_ids (Optional)
  # 設定内容: VPCの関連付けに適用するセキュリティグループIDのリストを指定します。
  # 設定可能な値: セキュリティグループIDの文字列リスト
  # 省略時: セキュリティグループなしで関連付けが作成されます。
  # 注意: セキュリティグループはいつでも追加・変更可能です。
  #       すべてのセキュリティグループを削除するには、関連付けを削除して
  #       セキュリティグループなしで再作成する必要があります。
  #       セキュリティグループをすべて削除すると、そのサービスネットワーク上の
  #       サービスへのトラフィックが遮断されます。
  # 参考: https://docs.aws.amazon.com/vpc-lattice/latest/ug/security-groups.html
  security_group_ids = [
    "sg-xxxxxxxxxxxxxxxxx",
  ]

  #-------------------------------------------------------------
  # プライベートDNS設定
  #-------------------------------------------------------------

  # private_dns_enabled (Optional)
  # 設定内容: VPC関連付けに対してプライベートDNSを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: プライベートDNSを有効化。VPC内からサービスのカスタムドメイン名で
  #           プライベートIPアドレスに解決できるようになります。
  #   - false (デフォルト): プライベートDNSを無効化
  # 省略時: false
  private_dns_enabled = false

  #-------------------------------------------------------------
  # DNSオプション設定
  #-------------------------------------------------------------

  # dns_options (Optional)
  # 設定内容: VPC関連付けのDNSオプション設定を指定します。
  # 省略時: デフォルトのDNS設定が使用されます。
  dns_options {
    # private_dns_preference (Optional)
    # 設定内容: カスタムドメイン名のプライベートホストゾーンを作成・関連付ける
    #           優先度を指定します。
    # 設定可能な値:
    #   - "VERIFIED_DOMAINS_ONLY": 検証済みドメインのみ対象
    #   - "ALL_DOMAINS": すべてのドメインを対象
    #   - "VERIFIED_DOMAINS_AND_SPECIFIED_DOMAINS": 検証済みドメインと指定ドメインの両方を対象
    #   - "SPECIFIED_DOMAINS_ONLY": 指定されたドメインのみ対象
    # 注意: private_dns_enabledがtrueの場合のみサポートされます。
    private_dns_preference = "VERIFIED_DOMAINS_ONLY"

    # private_dns_specified_domains (Optional)
    # 設定内容: プライベートホストゾーンを作成してVPCに関連付けるプライベートドメインを指定します。
    # 設定可能な値: ドメイン名の文字列セット
    # 省略時: 指定なし（Terraform管理外のドメインは保持されます）
    # 注意: private_dns_enabledがtrueで、かつprivate_dns_preferenceが
    #       "VERIFIED_DOMAINS_AND_SPECIFIED_DOMAINS"または"SPECIFIED_DOMAINS_ONLY"の
    #       場合のみサポートされます。
    private_dns_specified_domains = []
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-sn-vpc-association"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: サービスネットワークVPC関連付けのAmazon Resource Name (ARN)
#
# - created_by: この関連付けを作成したAWSアカウントID
#
# - id: 関連付けのID
#
# - status: 関連付けの操作ステータス
#           設定可能な値: CREATE_IN_PROGRESS | ACTIVE | DELETE_IN_PROGRESS |
#           CREATE_FAILED | DELETE_FAILED
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
