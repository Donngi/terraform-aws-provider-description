#---------------------------------------------------------------
# VPC Lattice Service Network VPC Association
#---------------------------------------------------------------
# VPC Lattice のサービスネットワークと VPC を関連付けます。この関連付けにより、
# VPC内のクライアントがサービスネットワークに関連付けられたサービスやリソースに
# アクセスできるようになります。セキュリティグループやプライベート DNS の設定を通じて、
# きめ細かいアクセス制御が可能です。
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/vpc-lattice/latest/ug/service-network-associations.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpclattice_service_network_vpc_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
#
# NOTE: このテンプレートは参考例です。実際の利用環境に応じて適切な値を設定してください。
#---------------------------------------------------------------

resource "aws_vpclattice_service_network_vpc_association" "example" {

  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vpc_identifier (Required)
  # 設定内容: サービスネットワークに関連付ける VPC の ID を指定します
  # 設定可能な値: 有効な VPC ID（vpc-xxxxxxxxxxxxxxxxx 形式）
  # 関連機能: VPC - https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html
  vpc_identifier = "vpc-0123456789abcdef0"

  # service_network_identifier (Required)
  # 設定内容: VPC に関連付けるサービスネットワークの ID または ARN を指定します。異なるアカウントのリソースを指定する場合は ARN を使用する必要があります
  # 設定可能な値: サービスネットワークの ID または完全な ARN
  # 関連機能: VPC Lattice サービスネットワーク - https://docs.aws.amazon.com/vpc-lattice/latest/ug/service-networks.html
  service_network_identifier = "sn-0123456789abcdef0"

  #-------------------------------------------------------------
  # セキュリティグループ設定
  #-------------------------------------------------------------

  # security_group_ids (Optional)
  # 設定内容: VPC からサービスネットワークへのアクセスを制御するセキュリティグループの ID を指定します。ネットワークレベルのセキュリティ保護を提供します
  # 設定可能な値: セキュリティグループ ID のリスト（sg-xxxxxxxxxxxxxxxxx 形式）
  # 省略時: セキュリティグループによる制御なし
  # 関連機能: VPC Lattice アクセス管理 - https://docs.aws.amazon.com/vpc-lattice/latest/ug/access-management-overview.html
  security_group_ids = ["sg-0123456789abcdef0"]

  #-------------------------------------------------------------
  # プライベート DNS 設定
  #-------------------------------------------------------------

  # private_dns_enabled (Optional)
  # 設定内容: VPC 関連付けでプライベート DNS を有効にするかどうかを指定します。有効にすると、VPC Lattice がコンシューマーの VPC にプライベートホストゾーンをプロビジョニングします
  # 設定可能な値: true（有効）または false（無効）
  # 省略時: false
  # 関連機能: カスタムドメイン名 - https://docs.aws.amazon.com/vpc-lattice/latest/ug/service-custom-domain-name.html
  private_dns_enabled = true

  # dns_options (Optional)
  # 設定内容: DNS オプションの詳細設定を行います。プライベート DNS が有効な場合に、どのドメインにプライベートホストゾーンを作成するかを制御できます
  # 省略時: デフォルトの DNS 設定
  dns_options {

    # private_dns_preference (Optional)
    # 設定内容: プライベートホストゾーンを作成する対象ドメインの優先順位を指定します。private_dns_enabled が true の場合のみサポートされます
    # 設定可能な値:
    #   - VERIFIED_DOMAINS_ONLY: 検証済みドメインのみ
    #   - ALL_DOMAINS: すべてのドメイン
    #   - VERIFIED_DOMAINS_AND_SPECIFIED_DOMAINS: 検証済みドメインと指定されたドメイン
    #   - SPECIFIED_DOMAINS_ONLY: 指定されたドメインのみ
    # 省略時: デフォルトの優先順位設定
    # 関連機能: ドメイン検証 - https://aws.amazon.com/blogs/networking-and-content-delivery/custom-domain-names-for-vpc-lattice-resources/
    private_dns_preference = "VERIFIED_DOMAINS_AND_SPECIFIED_DOMAINS"

    # private_dns_specified_domains (Optional)
    # 設定内容: プライベートホストゾーンを作成して VPC に関連付けるプライベートドメインのリストを指定します。private_dns_enabled が true で、private_dns_preference が VERIFIED_DOMAINS_AND_SPECIFIED_DOMAINS または SPECIFIED_DOMAINS_ONLY の場合のみサポートされます
    # 設定可能な値: ドメイン名のリスト
    # 省略時: 指定されたドメインなし
    private_dns_specified_domains = ["api.internal.example.com"]
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します
  # 設定可能な値: 有効な AWS リージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: リージョナルエンドポイント - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるキー・バリュー形式のタグを指定します
  # 設定可能な値: 任意のキー・バリューペアのマップ
  # 省略時: タグなし（プロバイダーの default_tags があれば適用されます）
  tags = {
    Name        = "my-vpc-association"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# 以下の属性は、リソース作成後に参照可能です:
#
# arn - VPC 関連付けの Amazon Resource Name (ARN)
# created_by - 関連付けを作成したアカウント
# id - 関連付けの一意識別子
# status - オペレーションのステータス
#          有効な値: CREATE_IN_PROGRESS, ACTIVE, DELETE_IN_PROGRESS, CREATE_FAILED, DELETE_FAILED
# tags_all - プロバイダーの default_tags を含む、リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
