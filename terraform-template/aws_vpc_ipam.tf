#---------------------------------------------------------------
# VPC IP Address Manager (IPAM)
#---------------------------------------------------------------
#
# AWS VPC IP Address Manager（IPAM）リソースを管理します。
# IPAMは、AWSワークロード用のIPアドレス管理を簡素化する機能で、
# IPアドレス空間の整理、使用状況の監視、ワークフローの自動化を可能にします。
#
# 主な機能:
# - ルーティングおよびセキュリティドメインの管理
# - IPアドレス使用状況の監視
# - IPアドレス割り当て履歴の表示
# - CIDRの自動割り当て
# - ネットワーク接続の問題のトラブルシューティング
# - リージョン間・アカウント間でのBYOIP（Bring Your Own IP）アドレスの共有
# - Amazonが提供する連続したIPv6 CIDRブロックのプロビジョニング
#
# AWS公式ドキュメント:
#   - What is IPAM?: https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
#   - Tracking IP address usage: https://docs.aws.amazon.com/vpc/latest/ipam/tracking-ip-addresses-ipam.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpc_ipam
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_ipam" "example" {

  #-------------------------------------------------------------
  # 必須パラメータ - 動作リージョン
  #-------------------------------------------------------------

  # operating_regions (Required, min_items: 1)
  # 設定内容: プールを作成する際に選択できるロケール（リージョン）を決定します
  # 設定可能な値: IPAMプールを利用可能にしたいリージョン名のリスト
  # 省略時: 設定必須（最低1つのリージョンが必要）
  # 注意: プロバイダーブロックで設定したリージョンを動作リージョンとして
  #      設定する必要があります
  # 関連機能: IPAM Operating Regions
  #   IPAMの動作リージョンに関する詳細 - https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
  operating_regions {
    # region_name (Required)
    # 設定内容: IPAMに追加するリージョンの名前
    # 設定可能な値: us-east-1, ap-northeast-1, eu-west-1 など
    # 省略時: 設定必須
    region_name = "ap-northeast-1"
  }

  # 複数リージョンで動作させる場合の例:
  # operating_regions {
  #   region_name = "us-east-1"
  # }
  #
  # operating_regions {
  #   region_name = "us-west-2"
  # }

  #-------------------------------------------------------------
  # オプションパラメータ - 基本設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: IPAMの説明
  # 設定可能な値: 任意の文字列
  # 省略時: 空文字列
  description = "Multi-region IPAM for production environment"

  # tier (Optional)
  # 設定内容: IPAMのティア（階層）
  # 設定可能な値: "free", "advanced"
  # 省略時: "advanced"
  # 注意: advancedティアでは追加機能が利用可能ですが、料金が発生します
  # 関連機能: IPAM Pricing
  #   IPAMの料金詳細 - https://aws.amazon.com/vpc/pricing/
  tier = "advanced"

  #-------------------------------------------------------------
  # オプションパラメータ - 高度な設定
  #-------------------------------------------------------------

  # cascade (Optional)
  # 設定内容: IPAMの迅速な削除を有効にするかどうか
  # 設定可能な値: true, false
  # 省略時: false
  # 注意: trueに設定すると、IPAMとともにプライベートスコープ、プール、
  #      プール内の割り当てを迅速に削除できます
  # cascade = false

  # enable_private_gua (Optional)
  # 設定内容: 独自のGUA（Global Unicast Address）範囲を
  #          プライベートIPv6アドレスとして使用するオプション
  # 設定可能な値: true, false
  # 省略時: false
  # 関連機能: Private IPv6 GUA
  #   プライベートIPv6 GUAの詳細 - https://docs.aws.amazon.com/vpc/latest/ipam/ipam-private-gua.html
  # enable_private_gua = false

  # metered_account (Optional)
  # 設定内容: IPAMで管理されるアクティブなIPアドレスに対して課金される
  #          AWSアカウント
  # 設定可能な値: "ipam-owner", "resource-owner"
  # 省略時: "ipam-owner"
  # 注意: "ipam-owner"の場合はIPAMを所有するアカウントに課金され、
  #      "resource-owner"の場合はリソースを所有するアカウントに課金されます
  # metered_account = "ipam-owner"

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: us-east-1, ap-northeast-1 など
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: AWS Regional Endpoints
  #   リージョナルエンドポイントの詳細 - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: 空のマップ
  # 関連機能: AWS Tagging Strategies
  #   タグ付けのベストプラクティス - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "production-ipam"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsとリソース固有のタグを含む
  #          すべてのタグのマップ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: プロバイダーのdefault_tagsから自動設定
  # 関連機能: Provider default_tags
  #   プロバイダーのデフォルトタグ設定 - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags_all = {}

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: IPAM作成のタイムアウト時間
    # 設定可能な値: 時間文字列（例: "3m", "10m"）
    # 省略時: デフォルトタイムアウト値
    # create = "3m"

    # update (Optional)
    # 設定内容: IPAM更新のタイムアウト時間
    # 設定可能な値: 時間文字列（例: "3m", "10m"）
    # 省略時: デフォルトタイムアウト値
    # update = "3m"

    # delete (Optional)
    # 設定内容: IPAM削除のタイムアウト時間
    # 設定可能な値: 時間文字列（例: "3m", "10m"）
    # 省略時: デフォルトタイムアウト値
    # delete = "3m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# - id: IPAMのID
# - arn: IPAMのAmazon Resource Name (ARN)
# - default_resource_discovery_id: IPAMのデフォルトリソースディスカバリーID
# - default_resource_discovery_association_id: IPAMのデフォルトリソース
#   ディスカバリーアソシエーションID
# - private_default_scope_id: IPAMのプライベートスコープのID
#   スコープはIPAM内のトップレベルコンテナで、各スコープはIP独立ネットワークを
#   表します。IPアドレス空間が重複するネットワークを表現できます。
#   IPAMの作成時にパブリックとプライベートの2つのスコープが自動作成されます。
#   プライベートスコープはプライベートIP空間用です。
# - public_default_scope_id: IPAMのパブリックスコープのID
#   パブリックスコープはインターネットルーティング可能なすべてのIP空間用です。
# - scope_count: IPAM内のスコープの数
# - tags_all: プロバイダーのdefault_tagsを含む、リソースに割り当てられた
#   すべてのタグのマップ
#---------------------------------------------------------------
