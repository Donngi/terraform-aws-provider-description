#---------------------------------------------------------------
# Amazon Route 53 Records Exclusive
#---------------------------------------------------------------
#
# aws_route53_records_exclusiveは、Route 53ホストゾーン内のリソースレコードセットを
# 排他的に管理するためのリソースです。このリソースは指定されたホストゾーン内の
# 全てのリソースレコードセットを所有し、Terraformの設定に存在しないレコードセットを
# 自動的に削除します。
#
# 重要な注意事項:
#   - このリソースはホストゾーン内のリソースレコードセットの排他的所有権を持ちます。
#     明示的に設定されていないレコードセットは削除されます。
#   - ホストゾーンのプロビジョニング時に自動作成されるデフォルトのNSおよびSOAレコードは
#     このリソースに含めないでください。含めると読み取り操作でこれらが無視されるため、
#     永続的なドリフトが発生します。
#   - このリソースを削除しても、設定されたレコードセット自体は削除されません。
#     Terraformによる設定の調整管理が停止するだけです。
#   - aws_route53_recordリソースと並行して使用する場合は、
#     同等のresource_record_set引数を持つことを確認してください。
#
# AWS公式ドキュメント:
#   - ChangeResourceRecordSets API: https://docs.aws.amazon.com/Route53/latest/APIReference/API_ChangeResourceRecordSets.html
#   - リソースレコードセットの操作: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/rrsets-working-with.html
#   - ルーティングポリシー: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_records_exclusive
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_records_exclusive" "example" {
  #-------------------------------------------------------------
  # ホストゾーン設定
  #-------------------------------------------------------------

  # zone_id (Required)
  # 設定内容: リソースレコードセットを含むホストゾーンのIDを指定します。
  # 設定可能な値: 有効なRoute 53ホストゾーンID
  # 用途: 排他的に管理対象とするホストゾーンを特定します。
  # 注意: このリソースはzone_idで指定したホストゾーン内の全レコードセットを管理下に置きます。
  #       aws_route53_zone.example.zone_idなどの参照式で指定することを推奨します。
  zone_id = "Z1234567890ABCDEF"

  #-------------------------------------------------------------
  # リソースレコードセット設定
  #-------------------------------------------------------------

  # resource_record_set (Optional)
  # 設定内容: ホストゾーンに関連付けるリソースレコードセットを指定します。
  # 用途: ホストゾーン内の全てのDNSレコードセットを宣言的に定義します。
  # 注意: このブロックを省略するか空にすることで、ホストゾーンにレコードセットを
  #       持たないことを強制できます（デフォルトのNS/SOAレコードは除く）。
  #       複数のresource_record_setブロックを記述することで複数のレコードを管理できます。
  resource_record_set {
    #-----------------------------------------------------------
    # レコード基本設定
    #-----------------------------------------------------------

    # name (Required)
    # 設定内容: DNSレコードの名前を指定します。
    # 設定可能な値: 完全修飾ドメイン名（例: subdomain.example.com）
    # 用途: 解決されるDNS名を特定します。
    name = "subdomain.example.com"

    # type (Optional)
    # 設定内容: DNSレコードのタイプを指定します。
    # 設定可能な値:
    #   - A: IPv4アドレス
    #   - AAAA: IPv6アドレス
    #   - CAA: 認証局認可
    #   - CNAME: 正規名（エイリアス）
    #   - DS: 委任署名者（DNSSEC）
    #   - MX: メール交換
    #   - NAPTR: 名前オーソリティポインタ
    #   - NS: ネームサーバー
    #   - PTR: ポインタ
    #   - SOA: 権威開始
    #   - SPF: 送信者ポリシーフレームワーク
    #   - SRV: サービスロケータ
    #   - TXT: テキスト
    #   - TLSA: TLS認証
    #   - SSHFP: SSHフィンガープリント
    #   - SVCB: サービスバインディング
    #   - HTTPS: HTTPSサービスバインディング
    # 省略時: 設定なし
    # 注意: resource_recordsまたはalias_targetのいずれか一方を必ず指定してください。
    type = "A"

    # ttl (Optional)
    # 設定内容: リソースレコードのキャッシュ時間（TTL）を秒単位で指定します。
    # 設定可能な値: 0以上の整数値（秒単位）
    # 省略時: エイリアスレコード以外では必須
    # 注意: エイリアスレコード（alias_targetブロックを使用する場合）ではttlを指定できません。
    #       通常のレコード（resource_recordsを使用する場合）では必須です。
    ttl = 300

    #-----------------------------------------------------------
    # レコードの値
    #-----------------------------------------------------------

    # resource_records (Optional)
    # 設定内容: DNSレコードの値を指定します。
    # 用途: 通常のDNSレコード（エイリアス以外）の値を定義します。
    # 注意: alias_targetと排他的関係にあります。どちらか一方を指定してください。
    #       非エイリアスレコードでは必須です。複数のresource_recordsブロックを
    #       記述することで複数の値（例: 複数のIPアドレス）を設定できます。
    resource_records {
      # value (Required)
      # 設定内容: DNSレコードの値を指定します。
      # 設定可能な値: レコードタイプに応じた値
      #   - A: IPv4アドレス（例: 192.0.2.1）
      #   - AAAA: IPv6アドレス（例: 2001:db8::1）
      #   - CNAME: ドメイン名（例: example.com）
      #   - MX: 優先度とメールサーバー（例: 10 mail.example.com）
      #   - TXT: テキスト文字列（ダブルクォートで囲む）（例: "v=spf1 include:example.com ~all"）
      value = "192.0.2.1"
    }

    #-----------------------------------------------------------
    # エイリアスターゲット設定
    #-----------------------------------------------------------

    # alias_target (Optional)
    # 設定内容: エイリアスレコードのターゲットを指定します。
    # 用途: CloudFront、ELB、S3ウェブサイト、Global Acceleratorなどの
    #       AWSリソースへのエイリアスレコードを作成します。
    # 注意: resource_recordsと排他的関係にあります。どちらか一方を指定してください。
    #       エイリアスレコードではttlを指定しないでください。
    alias_target {
      # dns_name (Required)
      # 設定内容: ターゲットリソースのDNSドメイン名を指定します。
      # 設定可能な値: ELBのDNS名、CloudFrontのドメイン名など
      dns_name = "example-lb.us-east-1.elb.amazonaws.com"

      # evaluate_target_health (Required)
      # 設定内容: ターゲットのヘルスチェックを評価してDNSクエリへの応答を判断するかを指定します。
      # 設定可能な値:
      #   - true: ヘルスチェックを評価してDNSルーティングを制御
      #   - false: ヘルスチェックを評価しない
      # 注意: リソースタイプによって追加要件がある場合があります。
      #       AWSドキュメントで対象リソースの要件を確認してください。
      evaluate_target_health = true

      # hosted_zone_id (Required)
      # 設定内容: ターゲットリソースのホストゾーンIDを指定します。
      # 設定可能な値: CloudFront、S3バケット、ELB、Global Accelerator、
      #              またはRoute 53ホストゾーンのホストゾーンID
      hosted_zone_id = "Z35SXDOTRQ7X7K"
    }

    #-----------------------------------------------------------
    # フェイルオーバールーティング設定
    #-----------------------------------------------------------

    # failover (Optional)
    # 設定内容: フェイルオーバーリソースレコードのタイプを指定します。
    # 設定可能な値:
    #   - PRIMARY: プライマリフェイルオーバーレコード
    #   - SECONDARY: セカンダリフェイルオーバーレコード
    # 省略時: フェイルオーバールーティングを使用しない
    # 注意: failoverを使用する場合はset_identifierも必須です。
    #       詳細はAWSのDNSフェイルオーバードキュメントを参照してください。
    #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover.html
    failover = null

    # health_check_id (Optional)
    # 設定内容: レコードに関連付けるヘルスチェックのIDを指定します。
    # 設定可能な値: 有効なRoute 53ヘルスチェックID
    # 省略時: ヘルスチェックを関連付けない
    # 用途: フェイルオーバールーティングやレイテンシールーティングと組み合わせて
    #       エンドポイントの可用性を監視します。
    health_check_id = null

    #-----------------------------------------------------------
    # 識別子設定
    #-----------------------------------------------------------

    # set_identifier (Optional)
    # 設定内容: 同じ名前とタイプの組み合わせを持つ複数のレコードセットを区別する識別子を指定します。
    # 設定可能な値: 任意の文字列（128文字以内）
    # 省略時: 設定なし
    # 注意: cidr_routing_config、failover、geolocation、geoproximity_location、
    #       multi_value_answer、region、またはweightを使用する場合は必須です。
    set_identifier = null

    #-----------------------------------------------------------
    # 重み付けルーティング設定
    #-----------------------------------------------------------

    # weight (Optional)
    # 設定内容: 重み付けルーティングポリシーでのトラフィック比率を指定します。
    # 設定可能な値: 0〜255の整数値
    # 省略時: 設定なし
    # 用途: 複数のレコードセット間でトラフィックを指定した比率で分散します。
    #       0を設定するとそのレコードにはトラフィックが送られません。
    # 注意: weightを使用する場合はset_identifierも必須です。
    weight = null

    #-----------------------------------------------------------
    # レイテンシールーティング設定
    #-----------------------------------------------------------

    # region (Optional)
    # 設定内容: DNSトラフィックが転送されるリソースが存在するAWSリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョン名（例: ap-northeast-1, us-east-1）
    # 省略時: 設定なし
    # 用途: レイテンシーベースルーティングポリシーで使用します。
    #       Route 53がユーザーに最も低いレイテンシーを提供するリージョンにトラフィックを転送します。
    # 注意: regionを使用する場合はset_identifierも必須です。
    #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-latency
    region = null

    #-----------------------------------------------------------
    # 複数値応答ルーティング設定
    #-----------------------------------------------------------

    # multi_value_answer (Optional)
    # 設定内容: 複数値応答レコードとして設定するかを指定します。
    # 設定可能な値:
    #   - true: 複数値応答ルーティングを有効化（複数のリソースへのトラフィックをランダムに分散）
    #   - false: 複数値応答ルーティングを無効化
    # 省略時: 設定なし
    # 注意: multi_value_answerを使用する場合はset_identifierも必須です。
    multi_value_answer = null

    #-----------------------------------------------------------
    # トラフィックポリシー設定
    #-----------------------------------------------------------

    # traffic_policy_instance_id (Optional)
    # 設定内容: Route 53がこのリソースレコードセットを作成したトラフィックポリシーインスタンスのIDを指定します。
    # 設定可能な値: 有効なトラフィックポリシーインスタンスID
    # 省略時: 設定なし
    # 注意: トラフィックポリシーインスタンスに関連するレコードセットを削除する場合は
    #       DeleteTrafficPolicyInstance APIを使用してください。
    #       ChangeResourceRecordSets APIで削除してもトラフィックポリシーインスタンス自体は
    #       削除されず、課金が継続します。
    traffic_policy_instance_id = null

    #-----------------------------------------------------------
    # 地理的位置情報ルーティング設定
    #-----------------------------------------------------------

    # geolocation (Optional)
    # 設定内容: DNSクエリの地理的な発信元に基づいてRoute 53の応答を制御する設定を指定します。
    # 用途: 地理的位置情報ルーティングポリシーで使用します。
    # 注意: geolocationを使用する場合はset_identifierも必須です。
    geolocation {
      # continent_code (Optional)
      # 設定内容: 大陸コードを指定します。
      # 設定可能な値:
      #   AF (アフリカ)、AN (南極)、AS (アジア)、EU (欧州)、
      #   OC (オセアニア)、NA (北米)、SA (南米)
      # 省略時: 設定なし
      # 注意: continent_code、country_code、subdivision_codeのいずれか一つを指定してください。
      continent_code = null

      # country_code (Optional)
      # 設定内容: 国コードを指定します。
      # 設定可能な値: ISO 3166-1 alpha-2形式の2文字の国コード（例: JP, US）
      #   "*" を指定するとデフォルトの地理的ルーティングレコードとして機能します。
      # 省略時: 設定なし
      country_code = null

      # subdivision_code (Optional)
      # 設定内容: 地域（州・都道府県）コードを指定します。
      # 設定可能な値: country_codeがUSの場合は米国の州コード（例: NY, CA）
      # 省略時: 設定なし
      # 注意: subdivision_codeを使用する場合はcountry_codeも必須です。
      subdivision_code = null
    }

    #-----------------------------------------------------------
    # 地理近接性ルーティング設定
    #-----------------------------------------------------------

    # geoproximity_location (Optional)
    # 設定内容: 地理近接性ルーティング設定を指定します。
    # 用途: ユーザーとリソースの地理的距離に基づいてトラフィックを転送します。
    # 注意: geoproximity_locationを使用する場合はset_identifierも必須です。
    geoproximity_location {
      # aws_region (Optional)
      # 設定内容: DNSトラフィックの転送先となるAWSリソースが存在するリージョンを指定します。
      # 設定可能な値: 有効なAWSリージョン名（例: ap-northeast-1, us-east-1）
      # 省略時: 設定なし
      aws_region = null

      # bias (Optional)
      # 設定内容: Route 53がトラフィックを転送する地理的範囲を拡大または縮小する値を指定します。
      # 設定可能な値:
      #   - 1〜99: 地理的範囲を拡大
      #   - -1〜-99: 地理的範囲を縮小
      # 省略時: 設定なし
      # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-geoproximity.html
      bias = null

      # local_zone_group (Optional)
      # 設定内容: AWSローカルゾーングループを指定します。
      # 設定可能な値: ローカルゾーングループ識別子
      # 省略時: 設定なし
      # 参考: aws ec2 describe-availability-zones CLIコマンドで確認できます。
      local_zone_group = null

      # coordinates (Optional)
      # 設定内容: 地理近接性リソースレコードの座標を指定します。
      # 用途: AWSリージョン外のリソース（オンプレミスなど）に対して地理的位置を指定します。
      # 注意: aws_regionまたはlocal_zone_groupを指定する場合はcoordinatesを省略してください。
      coordinates {
        # latitude (Required)
        # 設定内容: 地球表面上の南北方向の座標（緯度）を指定します。
        # 設定可能な値: -90〜90の数値を文字列で指定
        latitude = "35.6762"

        # longitude (Required)
        # 設定内容: 地球表面上の東西方向の座標（経度）を指定します。
        # 設定可能な値: -180〜180の数値を文字列で指定
        longitude = "139.6503"
      }
    }

    #-----------------------------------------------------------
    # CIDRルーティング設定
    #-----------------------------------------------------------

    # cidr_routing_config (Optional)
    # 設定内容: IPベースルーティングのCIDR設定を指定します。
    # 用途: クライアントのIPアドレスに基づいてDNSクエリをルーティングします。
    # 注意: cidr_routing_configを使用する場合はset_identifierも必須です。
    cidr_routing_config {
      # collection_id (Required)
      # 設定内容: CIDRコレクションのIDを指定します。
      # 設定可能な値: 有効なRoute 53 CIDRコレクションID
      # 参考: aws_route53_cidr_collectionリソースを参照
      collection_id = "a1b2c3d4-e5f6-7890-abcd-ef1234567890"

      # location_name (Required)
      # 設定内容: CIDRコレクションのロケーション名を指定します。
      # 設定可能な値: 有効なCIDRロケーション名
      #   "*" を指定するとデフォルトCIDRレコードとして機能します。
      #   デフォルトレコードでもcollection_idは必須です。
      # 参考: aws_route53_cidr_locationリソースを参照
      location_name = "example-location"
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 用途: デフォルトのタイムアウト時間では不十分な場合に調整します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "2h45m"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    create = null

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "2h45m"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ホストゾーンのzone_idと同一の値。リソースの一意な識別子。
#
# - zone_id: リソースレコードセットを含むホストゾーンのID。
#
#---------------------------------------------------------------
