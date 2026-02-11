#---------------------------------------------------------------
# AWS Route53 CIDR Collection
#---------------------------------------------------------------
#
# Route53 CIDR Collectionは、IPベースルーティングで使用するCIDRブロックの
# 論理グループを定義するリソースです。CIDR Collectionは複数のCIDRロケーションを
# 含むことができ、各ロケーションには複数のCIDRブロックを関連付けることができます。
#
# ユースケース:
#   - ユーザーのIPアドレスに基づいてDNSルーティングを最適化
#   - 地理的位置とIPアドレスの組み合わせによるトラフィック制御
#   - 特定のIPレンジからのトラフィックを最適なエンドポイントにルーティング
#
# 重要な制約:
#   - CIDR Collectionは空の状態で作成可能ですが、IPベースルーティングレコードで
#     使用するには、CIDRロケーションとブロックを追加する必要があります
#   - CIDR Collectionを削除する前に、すべてのCIDRロケーションを削除する必要があります
#   - プライベートホストゾーンのレコードでは使用できません
#
# AWS公式ドキュメント:
#   - IP-based routing概要: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-ipbased.html
#   - CIDR Collection作成: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-creating-cidr-collection.html
#   - CreateCidrCollection API: https://docs.aws.amazon.com/Route53/latest/APIReference/API_CreateCidrCollection.html
#   - CIDR locations管理: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-working-with-cidr-locations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_cidr_collection
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_cidr_collection" "example" {
  #-------------------------------------------------------------
  # CIDR Collection基本設定 (Required)
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: CIDR Collectionの一意な名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  # 制約事項:
  #   - 同一アカウント内で一意である必要があります
  #   - 作成後に変更すると新しいリソースが作成されます（リソースの再作成）
  # 命名規則の推奨:
  #   - 目的を明確にする名前を使用（例: "production-ip-routing", "regional-cidr-blocks"）
  #   - 環境やリージョンを含める（例: "prod-us-east-cidr", "staging-eu-west-cidr"）
  # 用途:
  #   - Route53のIPベースルーティングレコードでこの名前を参照します
  #   - 複数のレコードセットで同じCIDR Collectionを共有できます
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-creating-cidr-collection.html
  name = "example-cidr-collection"

  #-------------------------------------------------------------
  # 補足情報
  #-------------------------------------------------------------
  # CIDR Collectionは作成後、以下のリソースと組み合わせて使用します:
  #
  # 1. aws_route53_cidr_location: CIDRロケーションを定義
  #    - ロケーション名とCIDRブロックのセットを管理
  #    - IPv4は/0〜/24、IPv6は/0〜/48の範囲をサポート
  #
  # 2. aws_route53_record: IPベースルーティングレコードを作成
  #    - routing_policy = "ip-based"を指定
  #    - cidr_routing_config ブロックでCIDR Collectionとロケーションを参照
  #
  # IPベースルーティングの仕組み:
  #   1. DNSクエリの送信元IPアドレスを取得
  #   2. CIDR Collectionに定義されたCIDRブロックと照合
  #   3. 最も長いプレフィックスマッチ（longest prefix match）を適用
  #   4. マッチしたCIDRロケーションに関連付けられたレコードを返す
  #
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-ipbased.html
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: CIDR CollectionのID
#       形式: Route53によって自動生成される一意な識別子
#       用途: 他のリソース（aws_route53_cidr_locationなど）でこのCollectionを参照する際に使用
#
# - arn: CIDR CollectionのAmazon Resource Name (ARN)
#       形式: arn:aws:route53:::cidrcollection/{collection-id}
#       用途: IAMポリシーやリソースベースのポリシーで使用
#
# - version: CIDR Collectionの最新バージョン番号
#       説明: Collectionが更新されるたびにバージョン番号が増加します
#       用途: 変更追跡や監査目的で使用
#

#---------------------------------------------------------------
# CIDR Collectionを作成した後、CIDRロケーションを追加する例:
#
# resource "aws_route53_cidr_location" "example_location" {
#   cidr_collection_id = aws_route53_cidr_collection.example.id
#   name               = "example-location-us-east"
#
#---------------------------------------------------------------
