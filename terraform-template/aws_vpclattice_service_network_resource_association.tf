#---------------------------------------------------------------
# AWS VPC Lattice Service Network Resource Association
#---------------------------------------------------------------
#
# VPC Lattice サービスネットワークとリソース設定の関連付けを管理するリソースです。
# サービスネットワークにリソース設定を関連付けることで、
# VPC Lattice サービスネットワーク経由でリソースにアクセスできるようになります。
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_service_network_resource_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# Attributes Reference:
# - id                  : 関連付けのID
# - arn                 : 関連付けのARN
# - dns_entry           : サービスネットワーク内の関連付けのDNSエントリ（リスト）
#   - domain_name       : サービスネットワーク内の関連付けのドメイン名
#   - hosted_zone_id    : ドメイン名を含むホストゾーンのID
# - tags_all            : プロバイダーのdefault_tagsを含む全タグのマップ
#---------------------------------------------------------------

resource "aws_vpclattice_service_network_resource_association" "example" {
  #---------------------------------------
  # 必須設定
  #---------------------------------------

  # 設定内容: 関連付けるリソース設定の識別子
  # 設定可能な値: aws_vpclattice_resource_configurationリソースのIDまたはARN
  resource_configuration_identifier = aws_vpclattice_resource_configuration.example.id

  # 設定内容: リソースを関連付けるサービスネットワークの識別子
  # 設定可能な値: aws_vpclattice_service_networkリソースのIDまたはARN
  service_network_identifier = aws_vpclattice_service_network.example.id

  #---------------------------------------
  # オプション設定
  #---------------------------------------

  # 設定内容: サービスネットワークリソース関連付けのプライベートDNSを有効にするかどうか
  # 設定可能な値: true / false
  # 省略時: false
  # 備考: trueに設定する場合、resource_configuration_identifierで指定するリソース設定にカスタムドメイン名またはグループドメインが必要
  private_dns_enabled = false

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: "us-east-1" / "ap-northeast-1" 等のリージョンコード
  # 省略時: プロバイダー設定のリージョンを使用
  region = "ap-northeast-1"

  # 設定内容: リソースに付与するタグのマップ
  # 省略時: タグなし
  tags = {
    Name = "example"
  }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------

  timeouts {
    # 設定内容: 作成操作のタイムアウト時間
    # 設定可能な値: "30s" / "5m" / "2h" 等の期間文字列（s=秒, m=分, h=時間）
    # 省略時: プロバイダーのデフォルト値を使用
    create = "30m"

    # 設定内容: 削除操作のタイムアウト時間
    # 設定可能な値: "30s" / "5m" / "2h" 等の期間文字列（s=秒, m=分, h=時間）
    # 省略時: プロバイダーのデフォルト値を使用
    delete = "30m"
  }
}
