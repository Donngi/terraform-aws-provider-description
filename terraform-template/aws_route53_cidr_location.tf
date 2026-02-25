#---------------------------------------------------------------
# AWS Route53 CIDR Location
#---------------------------------------------------------------
#
# Amazon Route 53のCIDRコレクション内にCIDRロケーションをプロビジョニングするリソースです。
# CIDRロケーションはIPアドレス範囲（CIDRブロック）をグループ化する名前付きエンティティで、
# IPベースルーティングのレコードセットから参照されます。
#
# AWS公式ドキュメント:
#   - CIDRロケーションの操作: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-working-with-cidr-locations.html
#   - IPベースルーティング: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-ipbased.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_cidr_location
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_cidr_location" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # cidr_collection_id (Required)
  # 設定内容: このCIDRロケーションを追加するCIDRコレクションのIDを指定します。
  # 設定可能な値: 有効なCIDRコレクションID（aws_route53_cidr_collectionリソースのidを参照）
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-ipbased.html
  cidr_collection_id = aws_route53_cidr_collection.example.id

  # name (Required)
  # 設定内容: CIDRロケーションの名前を指定します。
  # 設定可能な値: 1〜16文字の英数字、アンダースコア、ハイフン。先頭は英数字である必要があります。
  # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_CidrCollectionChange.html
  name = "office"

  #-------------------------------------------------------------
  # CIDRブロック設定
  #-------------------------------------------------------------

  # cidr_blocks (Required)
  # 設定内容: このロケーションに関連付けるCIDRブロックのセットを指定します。
  # 設定可能な値:
  #   - IPv4: /1〜/24のCIDRブロック形式（例: "200.5.3.0/24"）
  #   - IPv6: /1〜/48のCIDRブロック形式（例: "2001:db8::/48"）
  #   - 1〜1000件のCIDRブロックを指定可能
  # 注意: より長いCIDR（より狭い範囲）が一致する場合、そちらが優先されます。
  #       CIDRコレクション内のブロックは他のロケーションのブロックと重複できません。
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-ipbased.html
  cidr_blocks = [
    "200.5.3.0/24",
    "200.6.3.0/24",
  ]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: (非推奨) CIDRコレクションIDとCIDRロケーション名を連結した値。
#---------------------------------------------------------------
