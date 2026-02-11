#---------------------------------------------------------------
# VPC IPAM Resource Discovery
#---------------------------------------------------------------
#
# Amazon VPCのIPアドレス管理（IPAM）のリソースディスカバリーをプロビジョニングするリソースです。
# IPAMリソースディスカバリーは、マルチ組織のお客様向けのリソースです。
# 複数の組織にまたがって単一のIPAMを使用する場合、リソースディスカバリーを作成し、
# 配下組織から管理組織のIPAM委任管理者アカウントに共有できます。
#
# AWS公式ドキュメント:
#   - IPAM概要: https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
#   - IPAMリソースディスカバリー: https://docs.aws.amazon.com/vpc/latest/ipam/how-ipam-works.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_resource_discovery
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_ipam_resource_discovery" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: IPAMリソースディスカバリーの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  # 用途: リソースディスカバリーの目的や用途を明示的に記録する際に使用
  description = "My IPAM Resource Discovery"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 動作リージョン設定
  #-------------------------------------------------------------

  # operating_regions (Required, 最小1つ)
  # 設定内容: リソースディスカバリーがIPAM機能を有効にする対象リージョンを指定します。
  # 用途:
  #   - ロケールは、IPAMプールを割り当て可能にするリージョンを定義します
  #   - IPAMプールは、リソースディスカバリーの動作リージョンと一致するロケールのみで作成可能
  #   - VPCは、VPCのリージョンと一致するロケールを持つプールからのみ作成可能
  # 注意: プロバイダーブロックのリージョンを動作リージョンとして設定する必要があります
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/how-ipam-works.html
  operating_regions {
    # region_name (Required)
    # 設定内容: IPAMに追加するリージョンの名前を指定します。
    # 設定可能な値: 有効なAWSリージョン名（例: ap-northeast-1, us-east-1）
    # 注意: プロバイダー設定のリージョンを必ず含める必要があります
    region_name = "ap-northeast-1"
  }

  # 複数リージョンでの動作例
  # operating_regions {
  #   region_name = "us-east-1"
  # }
  #
  # operating_regions {
  #   region_name = "eu-west-1"
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/vpc/latest/ipam/tagging-ipam.html
  tags = {
    Name        = "my-ipam-resource-discovery"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 設定可能な値:
  #   - create: 作成操作のタイムアウト（デフォルト値が使用されます）
  #   - update: 更新操作のタイムアウト（デフォルト値が使用されます）
  #   - delete: 削除操作のタイムアウト（デフォルト値が使用されます）
  # 省略時: Terraformのデフォルトタイムアウトが適用されます
  # 用途: 大規模な環境やAPI制限が厳しい環境でタイムアウトエラーを防ぐ際に使用
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: IPAMリソースディスカバリーのAmazon Resource Name (ARN)
#
# - id: IPAMリソースディスカバリーのID
#
# - ipam_resource_discovery_region: リソースディスカバリーのホームリージョン
#
# - is_default: リソースディスカバリーがアカウントのデフォルトリソースディスカバリーか
#               どうかを示すブール値
#
# - owner_id: リソースディスカバリーを管理するアカウントのアカウントID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
