#---------------------------------------------------------------
# Amazon Route 53 Traffic Policy
#---------------------------------------------------------------
#
# Amazon Route 53 Traffic Policyは、トラフィックのルーティングを設定するための
# 複雑なルーティングポリシーを定義できる機能です。
# Traffic Policyは以下のルーティング戦略を組み合わせることができます:
#   - フェイルオーバールーティング: プライマリとセカンダリの構成で可用性を向上
#   - 地理的位置情報ルーティング: ユーザーの地理的位置に基づいてトラフィックを分散
#   - 地理近接性ルーティング: ユーザーとリソースの地理的距離に基づいてルーティング
#   - レイテンシールーティング: 最も低いレイテンシーのリージョンへルーティング
#   - 複数値応答ルーティング: 複数のIPアドレスをランダムに返却
#   - 重み付けルーティング: 重み付けに基づいてトラフィックを分散
#
# AWS公式ドキュメント:
#   - Traffic Flow概要: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/traffic-flow.html
#   - Traffic Policy作成: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/traffic-policies.html
#   - Traffic Policy Document形式: https://docs.aws.amazon.com/Route53/latest/APIReference/api-policies-traffic-policy-document-format.html
#   - Route 53 API リファレンス: https://docs.aws.amazon.com/Route53/latest/APIReference/API_TrafficPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_traffic_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_traffic_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: トラフィックポリシーの名前を指定します。
  # 設定可能な値: 1〜512文字の文字列
  # 用途: トラフィックポリシーを識別するための名前
  # 注意: 同じAWSアカウント内で一意である必要があります
  # 関連機能: Route 53 Traffic Policy
  #   トラフィックポリシーの管理と識別に使用されます。
  #   名前はバージョン間で共有され、新しいバージョンを作成する際も同じ名前を使用します。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/traffic-policies.html
  name = "example-traffic-policy"

  # comment (Optional)
  # 設定内容: トラフィックポリシーに対する説明やコメントを指定します。
  # 設定可能な値: 最大1024文字の文字列
  # 省略時: コメントは設定されません
  # 用途: トラフィックポリシーの目的や使用方法を説明するために使用
  # 関連機能: Route 53 Traffic Policy メタデータ
  #   ポリシーの管理を容易にするための補足情報として機能します。
  #   - https://docs.aws.amazon.com/Route53/latest/APIReference/API_TrafficPolicy.html
  comment = "Example traffic policy for load balancing and failover"

  #-------------------------------------------------------------
  # トラフィックポリシードキュメント
  #-------------------------------------------------------------

  # document (Required)
  # 設定内容: トラフィックポリシーの定義をJSON形式で指定します。
  # 設定可能な値: JSON形式のトラフィックポリシードキュメント
  # 用途: ルーティングロジックとエンドポイント設定を定義
  # 注意: このJSONドキュメントはRoute 53固有の形式に従う必要があります
  # 関連機能: Route 53 Traffic Policy Document Format
  #   トラフィックポリシードキュメントは以下の要素を含みます:
  #   - AWSPolicyFormatVersion: ポリシーのバージョン (2015-10-01 または 2023-05-09)
  #   - RecordType: DNSレコードタイプ (A, AAAA, CNAME, MX, NS, PTR, SOA, SPF, SRV, TXT)
  #   - StartEndpoint/StartRule: トラフィックポリシーの開始点
  #   - Endpoints: エンドポイント定義
  #   - Rules: ルーティングルール定義 (failover, geo, geoproximity, latency, multivalue, weighted)
  #   - https://docs.aws.amazon.com/Route53/latest/APIReference/api-policies-traffic-policy-document-format.html
  document = jsonencode({
    AWSPolicyFormatVersion = "2015-10-01"
    RecordType             = "A"
    StartEndpoint          = "endpoint-start-example"

    # エンドポイント定義
    # 各エンドポイントには以下を含めることができます:
    #   - Type: エンドポイントタイプ (value, cloudfront, application-load-balancer,
    #           elastic-load-balancer, network-load-balancer, elastic-beanstalk, s3-website)
    #   - Value: エンドポイントの値 (IPアドレス、ドメイン名など)
    #   - Region: S3 website エンドポイントの場合のみ必須
    Endpoints = {
      endpoint-start-example = {
        Type  = "value"
        Value = "192.0.2.1"
      }
      endpoint-secondary = {
        Type  = "value"
        Value = "192.0.2.2"
      }
    }

    # ルール定義
    # 以下のルールタイプが利用可能:
    #   - failover: フェイルオーバールーティング
    #   - geo: 地理的位置情報ルーティング
    #   - geoproximity: 地理近接性ルーティング
    #   - latency: レイテンシールーティング
    #   - multivalue: 複数値応答ルーティング
    #   - weighted: 重み付けルーティング
    Rules = {}
  })

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 用途: リソースの分類、コスト配分、アクセス制御などに使用
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/tagging-resources.html
  tags = {
    Name        = "example-traffic-policy"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。トラフィックポリシーの一意な識別子
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: トラフィックポリシーのAmazon Resource Name (ARN)
#
# - id: トラフィックポリシーのID
#
# - type: トラフィックポリシーで作成されるリソースレコードセットのDNSタイプ
#   (documentで指定したRecordTypeの値)
#
# - version: トラフィックポリシーのバージョン番号
#   このリソースが更新されるたびに、AWSによって自動的にインクリメントされます。
#   新しいバージョンは既存のトラフィックポリシーインスタンスに影響しません。
#   トラフィックポリシーインスタンスを更新して新しいバージョンを適用する必要があります。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 以下は、フェイルオーバー、レイテンシー、地理的位置情報を組み合わせた
# 高度なトラフィックポリシーの例です:

resource "aws_route53_traffic_policy" "advanced_example" {
  name    = "advanced-multi-region-policy"
#---------------------------------------------------------------
