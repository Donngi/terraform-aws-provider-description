################################################################################
# Route 53 Record
################################################################################
# Route 53のDNSレコードを管理するリソース
#
# 主な用途:
# - 標準的なDNSレコード（A, AAAA, CNAME, MX, TXTなど）の作成
# - エイリアスレコードによるAWSリソース（ELB, CloudFront, S3など）への参照
# - 高度なルーティングポリシー（重み付け、レイテンシー、位置情報ベース等）の設定
# - ヘルスチェックと連携したフェイルオーバー構成
#
# ベストプラクティス:
# - aliasを使用する場合、ttlとrecordsは指定不要（排他的）
# - ルーティングポリシーを使用する場合、set_identifierが必須
# - allow_overwriteは既存レコードを上書きする必要がある場合のみ使用
# - TTL値は変更頻度とクエリ負荷のバランスを考慮して設定

resource "aws_route53_record" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # (Required) ホストゾーンID
  # レコードを作成するRoute 53ホストゾーンのIDを指定
  zone_id = "Z2ABCDEFGHIJK" # aws_route53_zone.primary.zone_id

  # (Required) レコード名
  # 作成するDNSレコードの名前（例: "www.example.com", "example.com"）
  # ホストゾーンと同じ名前の場合は空文字列も可能
  name = "www.example.com"

  # (Required) レコードタイプ
  # サポートされる値: A, AAAA, CAA, CNAME, DS, HTTPS, MX, NAPTR, NS, PTR,
  #                    SOA, SPF, SRV, SSHFP, SVCB, TLSA, TXT
  #
  # 主なレコードタイプ:
  # - A: IPv4アドレスへのマッピング
  # - AAAA: IPv6アドレスへのマッピング
  # - CNAME: 別のドメイン名へのエイリアス
  # - MX: メールサーバーの指定
  # - TXT: テキスト情報（SPF, DKIM等）
  type = "A"

  ################################################################################
  # 標準レコード設定（aliasと排他的）
  ################################################################################

  # (Optional/Required for non-alias records) TTL（秒単位）
  # DNSリゾルバがこのレコードをキャッシュする時間
  #
  # 推奨値:
  # - 頻繁に変更する場合: 300秒（5分）
  # - 通常の使用: 3600秒（1時間）
  # - ほとんど変更しない場合: 86400秒（24時間）
  #
  # 注意: aliasレコードの場合は指定不要
  ttl = 300

  # (Optional/Required for non-alias records) レコード値のリスト
  # DNSクエリに対して返される値
  #
  # 例:
  # - Aレコード: ["192.0.2.1", "192.0.2.2"]
  # - CNAMEレコード: ["example.com"]
  # - MXレコード: ["10 mail.example.com"]
  # - TXTレコード: ["v=spf1 include:_spf.example.com ~all"]
  #
  # 255文字を超える値（DKIM等）の場合は \"\" で分割:
  # ["first255characters\"\"morecharacters"]
  #
  # 注意: aliasレコードの場合は指定不要
  records = ["192.0.2.1"]

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # (Optional) ルーティングポリシー識別子
  # 複数のレコードを区別するための一意な識別子
  #
  # 必須となる場合:
  # - cidr_routing_policy使用時
  # - failover_routing_policy使用時
  # - geolocation_routing_policy使用時
  # - geoproximity_routing_policy使用時
  # - latency_routing_policy使用時
  # - multivalue_answer_routing_policy使用時
  # - weighted_routing_policy使用時
  # set_identifier = "primary-record"

  # (Optional) ヘルスチェックID
  # このレコードに関連付けるRoute 53ヘルスチェックのID
  # フェイルオーバーやルーティングポリシーと組み合わせて使用
  # health_check_id = aws_route53_health_check.example.id

  # (Optional) 上書き許可フラグ
  # 既存のレコードを上書きすることを許可するか
  # デフォルト: false
  #
  # 注意:
  # - 本番環境では通常falseのままにすることを推奨
  # - 既存のレコードを確実に上書きする必要がある場合のみtrue
  # - NS/SOAレコードの管理で使用することが多い
  # allow_overwrite = false

  # (Optional) マルチバリュー応答ルーティングポリシー
  # trueに設定すると、Route 53は最大8つの正常なレコードをランダムに返す
  # 他のルーティングポリシーとは排他的
  # multivalue_answer_routing_policy = true

  ################################################################################
  # エイリアスレコード設定（ttl/recordsと排他的）
  ################################################################################
  # AWSリソース（ELB, CloudFront, S3, Global Accelerator等）へのエイリアス
  #
  # 利点:
  # - Zone Apexでの使用が可能
  # - クエリ課金が不要
  # - 自動的にIPアドレスの変更に追従
  #
  # 例: ELB, ALB, NLB, CloudFront, S3 Website, API Gateway, Global Accelerator等

  # alias {
  #   # (Required) ターゲットリソースのDNS名
  #   # 例:
  #   # - ELB: aws_elb.main.dns_name
  #   # - CloudFront: aws_cloudfront_distribution.main.domain_name
  #   # - S3: aws_s3_bucket.main.website_endpoint
  #   name = "example-elb-1234567890.us-east-1.elb.amazonaws.com"
  #
  #   # (Required) ターゲットリソースのホストゾーンID
  #   # 例:
  #   # - ELB: aws_elb.main.zone_id
  #   # - CloudFront: Z2FDTNDATAQYW2（固定値）
  #   # - S3: リージョンごとに異なる（aws_s3_bucket.main.hosted_zone_id）
  #   zone_id = "Z35SXDOTRQ7X7K"
  #
  #   # (Required) ターゲットヘルスの評価
  #   # trueの場合、ターゲットリソースのヘルスチェック結果に基づいて応答
  #   #
  #   # 推奨設定:
  #   # - ELB/ALB/NLB: true（ELBのヘルスチェックを使用）
  #   # - CloudFront: false（CloudFrontは独自のヘルスチェック機構を持つ）
  #   # - S3: false（ヘルスチェック不要）
  #   evaluate_target_health = true
  # }

  ################################################################################
  # ルーティングポリシー（相互排他的）
  ################################################################################

  #-----------------------------------------------------------------------------
  # CIDRルーティングポリシー
  #-----------------------------------------------------------------------------
  # リクエスト元のIPアドレス範囲に基づいてトラフィックをルーティング
  #
  # 使用例:
  # - 特定のIPレンジからのアクセスを専用エンドポイントに誘導
  # - 地理的なIP分布に基づく詳細なルーティング制御

  # cidr_routing_policy {
  #   # (Required) CIDRコレクションID
  #   # aws_route53_cidr_collectionリソースで作成したコレクションのID
  #   collection_id = aws_route53_cidr_collection.example.id
  #
  #   # (Required) CIDRロケーション名
  #   # aws_route53_cidr_locationリソースで定義したロケーション名
  #   # アスタリスク "*" を使用してデフォルトレコードを作成可能
  #   # デフォルトレコードでもcollection_idは必須
  #   location_name = "office-network"
  # }

  #-----------------------------------------------------------------------------
  # フェイルオーバールーティングポリシー
  #-----------------------------------------------------------------------------
  # プライマリとセカンダリのレコードを設定し、ヘルスチェックに基づいて自動切替
  #
  # 使用例:
  # - アクティブ/パッシブ構成のフェイルオーバー
  # - DR（災害復旧）サイトへの自動切替

  # failover_routing_policy {
  #   # (Required) フェイルオーバータイプ
  #   # - PRIMARY: プライマリレコード（ヘルスチェックが正常な場合に返される）
  #   # - SECONDARY: セカンダリレコード（プライマリが不健全な場合に返される）
  #   #
  #   # 通常、PRIMARYとSECONDARYの2つのレコードをペアで作成
  #   type = "PRIMARY"
  # }

  #-----------------------------------------------------------------------------
  # 位置情報ルーティングポリシー
  #-----------------------------------------------------------------------------
  # リクエスト元の地理的位置に基づいてトラフィックをルーティング
  #
  # 使用例:
  # - 地域ごとに異なるコンテンツを配信
  # - 規制要件により特定地域からのアクセスを制限
  # - 地域ごとに最適化されたエンドポイントへのルーティング

  # geolocation_routing_policy {
  #   # (Optional) 大陸コード
  #   # 2文字のコード（例: NA=北米, EU=ヨーロッパ, AS=アジア）
  #   # continentまたはcountryのいずれかが必須
  #   # continent = "NA"
  #
  #   # (Optional) 国コード
  #   # 2文字のISO国コード（例: US, JP, GB）
  #   # または "*" でデフォルトレコードを指定
  #   # country = "JP"
  #
  #   # (Optional) 地域コード（州/県）
  #   # 国内の細かい地域を指定する場合に使用
  #   # 例: US-CA（カリフォルニア州）, JP-13（東京都）
  #   # subdivision = "13"
  # }

  #-----------------------------------------------------------------------------
  # 地理的近接性ルーティングポリシー
  #-----------------------------------------------------------------------------
  # リソースとユーザーの地理的な近接性に基づいてトラフィックをルーティング
  # バイアス値で特定リソースへのトラフィック量を調整可能
  #
  # 使用例:
  # - 地理的に最も近いエンドポイントへのルーティング
  # - 段階的な地域移行（バイアス値を調整してトラフィックシフト）

  # geoproximity_routing_policy {
  #   # (Optional) AWSリージョン
  #   # AWSリソースが存在するリージョン
  #   # aws_regionまたはcoordinatesのいずれかが必要
  #   # aws_region = "ap-northeast-1"
  #
  #   # (Optional) バイアス値
  #   # -90から90の範囲でトラフィックの偏りを調整
  #   # - 正の値: このリソースへのトラフィックを増やす
  #   # - 負の値: このリソースへのトラフィックを減らす
  #   # - 0: デフォルトの地理的近接性のみを使用
  #   # bias = 10
  #
  #   # (Optional) ローカルゾーングループ
  #   # AWSローカルゾーンのグループ名
  #   # local_zone_group = "us-east-1-bos-1"
  #
  #   # (Optional) 座標
  #   # AWS以外のリソースの位置を緯度経度で指定
  #   # coordinates {
  #     # (Required) 緯度
  #     # 文字列形式で指定（例: "35.6762"）
  #     latitude = "35.6762"
  #
  #     # (Required) 経度
  #     # 文字列形式で指定（例: "139.6503"）
  #     longitude = "139.6503"
  #   # }
  # }

  #-----------------------------------------------------------------------------
  # レイテンシールーティングポリシー
  #-----------------------------------------------------------------------------
  # ユーザーから最も低レイテンシーのAWSリージョンへトラフィックをルーティング
  #
  # 使用例:
  # - グローバルアプリケーションのパフォーマンス最適化
  # - 複数リージョンでの冗長化構成

  # latency_routing_policy {
  #   # (Required) AWSリージョン
  #   # レイテンシーを測定する基準となるリージョン
  #   #
  #   # 通常、複数のレコードを異なるリージョンで作成し、
  #   # Route 53が自動的に最も低レイテンシーのものを選択
  #   region = "ap-northeast-1"
  # }

  #-----------------------------------------------------------------------------
  # 重み付けルーティングポリシー
  #-----------------------------------------------------------------------------
  # 指定した割合でトラフィックを複数のリソースに分散
  #
  # 使用例:
  # - A/Bテスト（90:10などの割合でトラフィック分散）
  # - カナリアデプロイメント（少量のトラフィックを新バージョンに）
  # - 負荷分散

  # weighted_routing_policy {
  #   # (Required) 重み
  #   # 0以上の整数値
  #   #
  #   # 計算式: 特定レコードへのトラフィック = weight / (全レコードのweightの合計)
  #   #
  #   # 例:
  #   # - レコードA weight=90, レコードB weight=10 → 90%:10%の分散
  #   # - weight=0 の場合、そのレコードにはトラフィックが送られない
  #   weight = 10
  # }

  ################################################################################
  # タイムアウト設定
  ################################################################################

  # timeouts {
  #   # (Optional) 作成タイムアウト
  #   # デフォルト: 30分
  #   # create = "30m"
  #
  #   # (Optional) 更新タイムアウト
  #   # デフォルト: 30分
  #   # update = "30m"
  #
  #   # (Optional) 削除タイムアウト
  #   # デフォルト: 30分
  #   # delete = "30m"
  # }
}

################################################################################
# 出力値
################################################################################

# レコードの完全修飾ドメイン名（FQDN）
output "route53_record_fqdn" {
  description = "FQDN of the Route 53 record"
  value       = aws_route53_record.example.fqdn
}

# レコード名
output "route53_record_name" {
  description = "Name of the Route 53 record"
  value       = aws_route53_record.example.name
}

################################################################################
# 使用例
################################################################################

# 例1: シンプルなAレコード
# resource "aws_route53_record" "simple" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "www.example.com"
#   type    = "A"
#   ttl     = 300
#   records = ["192.0.2.1"]
# }

# 例2: ELBへのエイリアスレコード
# resource "aws_route53_record" "alb" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "app.example.com"
#   type    = "A"
#
#   alias {
#     name                   = aws_lb.main.dns_name
#     zone_id                = aws_lb.main.zone_id
#     evaluate_target_health = true
#   }
# }

# 例3: 重み付けルーティング（カナリアデプロイメント）
# resource "aws_route53_record" "canary_prod" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "api.example.com"
#   type    = "A"
#   ttl     = 60
#
#   weighted_routing_policy {
#     weight = 95
#   }
#
#   set_identifier = "production"
#   records        = ["192.0.2.1"]
# }
#
# resource "aws_route53_record" "canary_new" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "api.example.com"
#   type    = "A"
#   ttl     = 60
#
#   weighted_routing_policy {
#     weight = 5
#   }
#
#   set_identifier = "canary"
#   records        = ["192.0.2.2"]
# }

# 例4: フェイルオーバー構成
# resource "aws_route53_record" "primary" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "www.example.com"
#   type    = "A"
#   ttl     = 60
#
#   failover_routing_policy {
#     type = "PRIMARY"
#   }
#
#   set_identifier  = "primary"
#   health_check_id = aws_route53_health_check.primary.id
#   records         = ["192.0.2.1"]
# }
#
# resource "aws_route53_record" "secondary" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "www.example.com"
#   type    = "A"
#   ttl     = 60
#
#   failover_routing_policy {
#     type = "SECONDARY"
#   }
#
#   set_identifier = "secondary"
#   records        = ["192.0.2.2"]
# }

# 例5: 位置情報ルーティング
# resource "aws_route53_record" "geo_jp" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "www.example.com"
#   type    = "A"
#   ttl     = 300
#
#   geolocation_routing_policy {
#     country = "JP"
#   }
#
#   set_identifier = "japan"
#   records        = ["192.0.2.10"]
# }
#
# resource "aws_route53_record" "geo_default" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "www.example.com"
#   type    = "A"
#   ttl     = 300
#
#   geolocation_routing_policy {
#     country = "*"
#   }
#
#   set_identifier = "default"
#   records        = ["192.0.2.1"]
# }

# 例6: CloudFrontディストリビューションへのエイリアス
# resource "aws_route53_record" "cloudfront" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "cdn.example.com"
#   type    = "A"
#
#   alias {
#     name                   = aws_cloudfront_distribution.main.domain_name
#     zone_id                = "Z2FDTNDATAQYW2" # CloudFrontの固定ホストゾーンID
#     evaluate_target_health = false
#   }
# }

# 例7: MXレコード
# resource "aws_route53_record" "mx" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "example.com"
#   type    = "MX"
#   ttl     = 3600
#   records = [
#     "10 mail1.example.com",
#     "20 mail2.example.com"
#   ]
# }

# 例8: TXTレコード（SPF）
# resource "aws_route53_record" "spf" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "example.com"
#   type    = "TXT"
#   ttl     = 3600
#   records = ["v=spf1 include:_spf.example.com ~all"]
# }
