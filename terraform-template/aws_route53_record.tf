#---------------------------------------------------------------
# Amazon Route 53 レコード
#---------------------------------------------------------------
#
# Amazon Route 53のDNSレコードをプロビジョニングするリソースです。
# ホストゾーン内にA/AAAA/CNAME/MX等のDNSレコードを作成・管理します。
# シンプルルーティングからフェイルオーバー・地理的ルーティング等の
# 高度なルーティングポリシーまで対応しています。
#
# AWS公式ドキュメント:
#   - Route 53 レコードの操作: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/rrsets-working-with.html
#   - サポートされるDNSレコードタイプ: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/ResourceRecordTypes.html
#   - ルーティングポリシーの選択: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_record" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # zone_id (Required)
  # 設定内容: レコードを作成するホストゾーンのIDを指定します。
  # 設定可能な値: Route 53ホストゾーンのID文字列
  zone_id = "Z1234567890ABCDEFGHIJ"

  # name (Required)
  # 設定内容: DNSレコードの名前（ドメイン名またはサブドメイン名）を指定します。
  # 設定可能な値: ホストゾーンに属するドメイン名（例: www.example.com、example.com）
  # 注意: ワイルドカード（*）はNSレコードには使用不可
  name = "www.example.com"

  # type (Required)
  # 設定内容: DNSレコードのタイプを指定します。
  # 設定可能な値:
  #   - "A"      : IPv4アドレスへのルーティング
  #   - "AAAA"   : IPv6アドレスへのルーティング
  #   - "CAA"    : 証明書発行認可（Certificate Authority Authorization）
  #   - "CNAME"  : 別のドメイン名へのエイリアス
  #   - "DS"     : DNSSEC署名の委任署名者レコード
  #   - "HTTPS"  : HTTPSサービスバインディング
  #   - "MX"     : メールサーバーの指定
  #   - "NAPTR"  : 正規表現を使ったドメイン名の書き換えルール
  #   - "NS"     : ホストゾーンのネームサーバー
  #   - "PTR"    : IPアドレスからドメイン名への逆引き
  #   - "SOA"    : ホストゾーンの権威情報
  #   - "SPF"    : 送信者ポリシーフレームワーク（現在はTXTレコード推奨）
  #   - "SRV"    : サービスロケーター
  #   - "SSHFP"  : SSHフィンガープリントの検証
  #   - "SVCB"   : サービスバインディング
  #   - "TLSA"   : TLS証明書の検証（DANE）
  #   - "TXT"    : テキストデータ
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/ResourceRecordTypes.html
  type = "A"

  #-------------------------------------------------------------
  # レコード値・TTL設定
  #-------------------------------------------------------------

  # ttl (Optional)
  # 設定内容: DNSレコードのTTL（Time to Live）を秒単位で指定します。
  # 設定可能な値: 正の整数（秒）
  # 省略時: aliasブロック使用時は省略必須。非エイリアスレコードでは必須
  # 注意: aliasブロックとは共存不可
  ttl = 300

  # records (Optional)
  # 設定内容: レコードの値（IPアドレス、ドメイン名等）のリストを指定します。
  # 設定可能な値: レコードタイプに応じた値の文字列セット
  #   - Aレコード: IPv4アドレス（例: "203.0.113.1"）
  #   - AAAAレコード: IPv6アドレス
  #   - CNAMEレコード: 完全修飾ドメイン名
  #   - MXレコード: "優先度 メールサーバー" の形式（例: "10 mail.example.com"）
  #   - TXTレコード: 255文字超の場合は \"\" で分割（例: "first255chars\"\"morecharacters"）
  # 省略時: aliasブロック使用時は省略必須。非エイリアスレコードでは必須
  # 注意: aliasブロックとは共存不可
  records = ["203.0.113.1"]

  #-------------------------------------------------------------
  # 上書き設定
  #-------------------------------------------------------------

  # allow_overwrite (Optional)
  # 設定内容: 既存のRoute 53レコードをTerraformで上書き作成することを許可するかを指定します。
  # 設定可能な値:
  #   - true : 既存レコードの上書きを許可（NSレコードやSOAレコードの管理に使用）
  #   - false: 既存レコードが存在する場合はエラー
  # 省略時: false（上書きしない）
  # 注意: Terraform以外からの変更やTerraform内の他リソースによる上書きを防ぐ設定ではありません。
  #       ほとんどの環境で推奨されない設定です。
  allow_overwrite = false

  #-------------------------------------------------------------
  # ヘルスチェック設定
  #-------------------------------------------------------------

  # health_check_id (Optional)
  # 設定内容: このレコードに関連付けるRoute 53ヘルスチェックのIDを指定します。
  # 設定可能な値: aws_route53_health_checkリソースのID
  # 省略時: ヘルスチェックを関連付けない
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover-types.html
  health_check_id = null

  #-------------------------------------------------------------
  # ルーティングポリシー識別子設定
  #-------------------------------------------------------------

  # set_identifier (Optional)
  # 設定内容: 同一名前・タイプ・ルーティングポリシーを持つ複数レコードを区別するための
  #           一意識別子を指定します。
  # 設定可能な値: 任意の一意の文字列
  # 省略時: シンプルルーティング使用時は省略可。その他のルーティングポリシー使用時は必須
  # 注意: cidr_routing_policy、failover_routing_policy、geolocation_routing_policy、
  #       geoproximity_routing_policy、latency_routing_policy、
  #       multivalue_answer_routing_policy、weighted_routing_policyのいずれかを
  #       使用する場合は必須
  set_identifier = null

  #-------------------------------------------------------------
  # マルチバリューアンサールーティングポリシー設定
  #-------------------------------------------------------------

  # multivalue_answer_routing_policy (Optional)
  # 設定内容: マルチバリューアンサールーティングポリシーを有効にするかを指定します。
  # 設定可能な値:
  #   - true : マルチバリューアンサールーティングを有効化（最大8件の健全なレコードをランダムに返答）
  #   - false: 無効
  # 省略時: false（マルチバリューアンサールーティングを使用しない）
  # 注意: 他のルーティングポリシー（alias/cidr/failover/geolocation/geoproximity/latency/weighted）とは共存不可
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html
  multivalue_answer_routing_policy = null

  #-------------------------------------------------------------
  # エイリアスレコード設定
  #-------------------------------------------------------------

  # alias (Optional)
  # 設定内容: AWSリソース（ELB、CloudFront、S3等）へのエイリアスレコードを設定します。
  # 注意: recordsおよびttlとは共存不可
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-values-alias.html
  alias {
    # name (Required)
    # 設定内容: エイリアス先のAWSリソースのDNS名を指定します。
    # 設定可能な値: CloudFrontディストリビューション、S3バケット、ELB、
    #              AWS Global Accelerator、または別ホストゾーンのレコードセットのDNS名
    name = "example-alb-1234567890.ap-northeast-1.elb.amazonaws.com"

    # zone_id (Required)
    # 設定内容: エイリアス先のAWSリソースのホストゾーンIDを指定します。
    # 設定可能な値: CloudFront、S3、ELB、AWS Global Acceleratorなどのホストゾーン固有ID
    # 参考: 各リソース（例: aws_lb.zone_id）の属性から参照可能
    zone_id = "Z14GRHDCWA56QT"

    # evaluate_target_health (Required)
    # 設定内容: エイリアス先リソースのヘルスチェック結果に基づいてDNS応答を決定するかを指定します。
    # 設定可能な値:
    #   - true : エイリアス先が不健全な場合、このレコードは応答から除外される
    #   - false: ヘルスチェック結果に関わらず常にこのレコードを返す
    # 注意: リソースタイプによって特別な要件がある場合があります。
    # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-values.html#rrsets-values-alias-evaluate-target-health
    evaluate_target_health = true
  }

  #-------------------------------------------------------------
  # CIDRルーティングポリシー設定
  #-------------------------------------------------------------

  # cidr_routing_policy (Optional)
  # 設定内容: リクエスト元のIPネットワーク範囲に基づくルーティングポリシーを設定します。
  # 注意: 他のルーティングポリシーとは共存不可。set_identifierが必須
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-values-ipbased.html
  cidr_routing_policy {
    # collection_id (Required)
    # 設定内容: CIDRコレクションのIDを指定します。
    # 設定可能な値: aws_route53_cidr_collectionリソースのID
    collection_id = "example-cidr-collection-id"

    # location_name (Required)
    # 設定内容: CIDRコレクション内のロケーション名を指定します。
    # 設定可能な値: aws_route53_cidr_locationリソースのlocation名。
    #              "*"を指定するとデフォルトCIDRレコードを作成（collection_idは引き続き必須）
    location_name = "ap-northeast-1"
  }

  #-------------------------------------------------------------
  # フェイルオーバールーティングポリシー設定
  #-------------------------------------------------------------

  # failover_routing_policy (Optional)
  # 設定内容: ヘルスチェックの状態に基づくアクティブ-パッシブフェイルオーバーの
  #           ルーティングポリシーを設定します。
  # 注意: 他のルーティングポリシーとは共存不可。set_identifierが必須
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover-types.html
  failover_routing_policy {
    # type (Required)
    # 設定内容: フェイルオーバーのロールを指定します。
    # 設定可能な値:
    #   - "PRIMARY"  : プライマリリソース。ヘルスチェックが正常な間、このレコードが使用される
    #   - "SECONDARY": セカンダリリソース。プライマリが不健全になった場合に使用される
    # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover-configuring-options.html#dns-failover-failover-rrsets
    type = "PRIMARY"
  }

  #-------------------------------------------------------------
  # 地理的ルーティングポリシー設定
  #-------------------------------------------------------------

  # geolocation_routing_policy (Optional)
  # 設定内容: リクエスト元の地理的位置に基づくルーティングポリシーを設定します。
  # 注意: 他のルーティングポリシーとは共存不可。set_identifierが必須
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html
  geolocation_routing_policy {
    # continent (Optional)
    # 設定内容: 対象とする大陸の2文字コードを指定します。
    # 設定可能な値:
    #   - "AF": アフリカ
    #   - "AN": 南極
    #   - "AS": アジア
    #   - "EU": ヨーロッパ
    #   - "OC": オセアニア
    #   - "NA": 北アメリカ
    #   - "SA": 南アメリカ
    # 注意: continentとcountryはどちらか一方のみ指定可能
    # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_GetGeoLocation.html
    continent = "AS"

    # country (Optional)
    # 設定内容: 対象とする国の2文字ISOコードを指定します。
    # 設定可能な値: 2文字のISO 3166-1 alpha-2 国コード、または "*"（デフォルトレコード）
    # 注意: continentとcountryはどちらか一方のみ指定可能
    country = null

    # subdivision (Optional)
    # 設定内容: 対象とする国内の行政区分（州・都道府県等）コードを指定します。
    # 設定可能な値: 行政区分コード（countryと組み合わせて使用）
    # 省略時: 行政区分によるルーティングを使用しない
    subdivision = null
  }

  #-------------------------------------------------------------
  # 近接性ルーティングポリシー設定
  #-------------------------------------------------------------

  # geoproximity_routing_policy (Optional)
  # 設定内容: リクエスト元とAWSリソースの地理的近接性に基づくルーティングポリシーを設定します。
  # 注意: 他のルーティングポリシーとは共存不可。set_identifierが必須
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-geoproximity.html
  geoproximity_routing_policy {
    # aws_region (Optional)
    # 設定内容: リソースが存在するAWSリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1）
    # 省略時: AWSリージョン以外のリソース（座標指定やLocal Zone）使用時は省略
    aws_region = "ap-northeast-1"

    # local_zone_group (Optional)
    # 設定内容: リソースが存在するAWS Local Zoneグループを指定します。
    # 設定可能な値: AWS Local Zoneグループ名
    # 省略時: Local Zoneを使用しない場合は省略
    # 参考: https://docs.aws.amazon.com/local-zones/latest/ug/available-local-zones.html
    local_zone_group = null

    # bias (Optional)
    # 設定内容: このリソースへのトラフィックを増減させるバイアス値を指定します。
    # 設定可能な値: -90〜90の整数
    #   - 正の値: より多くのトラフィックをこのリソースにルーティング
    #   - 負の値: より少ないトラフィックをこのリソースにルーティング
    # 省略時: バイアスなし（0相当）
    # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-geoproximity.html
    bias = 0

    # coordinates (Optional)
    # 設定内容: AWSリソース以外（オンプレミス等）のリソース位置を緯度・経度で指定します。
    # 注意: aws_regionまたはlocal_zone_groupと排他的
    coordinates {
      # latitude (Required)
      # 設定内容: リソースの緯度を指定します。
      # 設定可能な値: -90.000〜90.000の数値文字列
      latitude = "35.68"

      # longitude (Required)
      # 設定内容: リソースの経度を指定します。
      # 設定可能な値: -180.000〜180.000の数値文字列
      longitude = "139.76"
    }
  }

  #-------------------------------------------------------------
  # レイテンシールーティングポリシー設定
  #-------------------------------------------------------------

  # latency_routing_policy (Optional)
  # 設定内容: リクエスト元とAWSリージョン間のレイテンシーに基づくルーティングポリシーを設定します。
  # 注意: 他のルーティングポリシーとは共存不可。set_identifierが必須
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-latency
  latency_routing_policy {
    # region (Required)
    # 設定内容: レイテンシーを測定する対象のAWSリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1、us-east-1）
    # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-latency
    region = "ap-northeast-1"
  }

  #-------------------------------------------------------------
  # 重み付きルーティングポリシー設定
  #-------------------------------------------------------------

  # weighted_routing_policy (Optional)
  # 設定内容: 指定した重みの比率に基づいてトラフィックを分散するルーティングポリシーを設定します。
  # 注意: 他のルーティングポリシーとは共存不可。set_identifierが必須
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-weighted
  weighted_routing_policy {
    # weight (Required)
    # 設定内容: このレコードへのトラフィック比重を指定します。
    # 設定可能な値: 0〜255の整数
    #   - 0: このレコードへのルーティングを停止（他のレコードが全トラフィックを処理）
    #   - 1〜255: 合計重みに対するこのレコードの割合でトラフィックを分散
    # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-weighted
    weight = 100
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定します。
  timeouts {
    # create (Optional)
    # 設定内容: レコード作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30m"、"1h"等のGoの時間フォーマット文字列
    # 省略時: プロバイダーのデフォルト値を使用
    create = "30m"

    # update (Optional)
    # 設定内容: レコード更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30m"、"1h"等のGoの時間フォーマット文字列
    # 省略時: プロバイダーのデフォルト値を使用
    update = "30m"

    # delete (Optional)
    # 設定内容: レコード削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30m"、"1h"等のGoの時間フォーマット文字列
    # 省略時: プロバイダーのデフォルト値を使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - fqdn: ゾーンドメインとnameから構築された完全修飾ドメイン名 (FQDN)
#---------------------------------------------------------------
