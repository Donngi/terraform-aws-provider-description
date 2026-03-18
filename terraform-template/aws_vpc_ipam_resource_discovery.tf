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
# Provider Version: 6.36.0
# Generated: 2026-03-18
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
  description = "My IPAM Resource Discovery"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

  #-------------------------------------------------------------
  # 動作リージョン設定
  #-------------------------------------------------------------

  # operating_regions (Required, 最小1つ)
  # 設定内容: リソースディスカバリーがIPAM機能を有効にする対象リージョンを指定します。
  # 注意: プロバイダーブロックのリージョンを動作リージョンとして設定する必要があります
  operating_regions {
    # region_name (Required)
    # 設定内容: IPAMに追加するリージョンの名前を指定します。
    # 設定可能な値: 有効なAWSリージョン名（例: ap-northeast-1, us-east-1）
    region_name = "ap-northeast-1"
  }

  # 複数リージョンでの動作例
  # operating_regions {
  #   region_name = "us-east-1"
  # }

  #-------------------------------------------------------------
  # 組織ユニット除外設定
  #-------------------------------------------------------------

  # organizational_unit_exclusion (Optional)
  # 設定内容: IPAMから除外する組織ユニット（OU）を指定します。
  # IPAMがAWS Organizationsと統合されている場合、OU除外を追加すると、
  # 該当OUのアカウントのIPアドレスをIPAMが管理しなくなります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/quotas-ipam.html
  # organizational_unit_exclusion {
  #   # organizations_entity_path (Required)
  #   # 設定内容: AWS Organizationsのエンティティパスを指定します。
  #   # 設定可能な値: AWS Organizations IDを「/」で区切ったパス文字列
  #   #   パスの末尾に「/*」を付けると、すべての子OUが含まれます
  #   #   例: "o-abc123/r-ab12/ou-ab12-11111111/*"
  #   organizations_entity_path = "o-abc123/r-ab12/ou-ab12-11111111/*"
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし（default_tagsのみ適用）
  tags = {
    Name        = "my-ipam-resource-discovery"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 省略時: Terraformのデフォルトタイムアウトが適用されます
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
# - id: IPAMリソースディスカバリーのID
# - ipam_resource_discovery_region: リソースディスカバリーのホームリージョン
# - is_default: アカウントのデフォルトリソースディスカバリーかどうかを示すブール値
# - owner_id: リソースディスカバリーを管理するアカウントのアカウントID
# - tags_all: default_tagsから継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
