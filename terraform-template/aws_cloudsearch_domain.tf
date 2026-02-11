# ================================================================================
# Terraform AWS Resource Template: aws_cloudsearch_domain
# ================================================================================
# Generated: 2026-01-18
# Provider Version: hashicorp/aws 6.28.0
#
# NOTE: このテンプレートは生成時点(2026-01-18)のAWS Provider 6.28.0の仕様に基づいています。
#       最新の仕様や詳細な説明については、必ず公式ドキュメントを確認してください。
# ================================================================================

resource "aws_cloudsearch_domain" "example" {
  # ================================================================================
  # Required Arguments
  # ================================================================================

  # name - (Required) CloudSearchドメインの名前
  # CloudSearchドメインを一意に識別する名前を指定します。
  # 参考: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/creating-managing-domains.html
  name = "example-domain"

  # ================================================================================
  # Optional Arguments
  # ================================================================================

  # multi_az - (Optional) 高可用性のために第2アベイラビリティゾーンに追加インスタンスを維持するかどうか
  # trueに設定すると、複数のアベイラビリティゾーンにドメインのインスタンスを配置し、
  # 可用性を向上させます。デフォルトはfalseです。
  # 参考: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/creating-managing-domains.html
  multi_az = false

  # region - (Optional) このリソースが管理されるリージョン
  # ドメインを作成するAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ================================================================================
  # Nested Block: endpoint_options
  # ================================================================================
  # ドメインエンドポイントのオプション設定
  # HTTPSの強制やTLSセキュリティポリシーを設定できます。
  # 参考: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/configuring-domain-endpoint-options.html
  # 参考: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/API_DomainEndpointOptions.html
  endpoint_options {
    # enforce_https - (Optional) ドメインへのすべてのリクエストがHTTPS経由で到達することを要求するかどうか
    # trueに設定すると、すべてのトラフィックがHTTPSで暗号化されます。
    # セキュリティ向上のためtrueの使用が推奨されます。デフォルトはfalseです。
    enforce_https = true

    # tls_security_policy - (Optional) 最低限必要なTLSバージョン
    # 有効な値:
    #   - Policy-Min-TLS-1-0-2019-07 (デフォルト)
    #   - Policy-Min-TLS-1-2-2019-07 (新しいクライアントには推奨)
    # 参考: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/API_DomainEndpointOptions.html
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  # ================================================================================
  # Nested Block: scaling_parameters
  # ================================================================================
  # ドメインのスケーリングパラメータ設定
  # 検索インスタンスタイプやレプリケーション数を事前設定できます。
  # CloudSearchはデータ量とトラフィックに基づいて自動的にスケールしますが、
  # ここで指定した値を下回ることはありません。
  # 参考: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/API_UpdateScalingParameters.html
  scaling_parameters {
    # desired_instance_type - (Optional) ドメインに事前設定したいインスタンスタイプ
    # 有効な値: search.small, search.medium, search.large, search.xlarge, search.2xlarge
    # 参考: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/API_ScalingParameters.html
    desired_instance_type = "search.medium"

    # desired_partition_count - (Optional) 事前設定したいパーティション数
    # インスタンスタイプとして search.2xlarge を選択した場合のみ有効です。
    # パーティションにより、データを複数の検索インスタンスに分散できます。
    # desired_partition_count = 1

    # desired_replication_count - (Optional) 各インデックスパーティションに対して事前設定したいレプリカ数
    # レプリカを増やすことで、検索クエリのスループットと可用性が向上します。
    # desired_replication_count = 1
  }

  # ================================================================================
  # Nested Block: index_field
  # ================================================================================
  # ドメインに追加されるドキュメントのインデックスフィールド定義
  # 各フィールドは検索対象データの構造を定義します。
  # 参考: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/configuring-index-fields.html
  # 参考: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/API_IndexField.html

  # テキストフィールドの例
  index_field {
    # name - (Required) フィールドの一意な名前
    # フィールド名は文字で始まり、1文字以上64文字以下である必要があります。
    # 使用可能な文字: a-z (小文字)、0-9、_ (アンダースコア)
    # 予約語 "score" は使用できません。
    # 参考: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/API_IndexField.html
    name = "title"

    # type - (Required) フィールドのタイプ
    # 有効な値:
    #   - date, date-array: 日付と日付配列
    #   - double, double-array: 倍精度浮動小数点数と配列
    #   - int, int-array: 64ビット符号付き整数と配列
    #   - literal, literal-array: リテラル文字列と配列(完全一致検索用)
    #   - text, text-array: テキスト文字列と配列(全文検索用)
    # 参考: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/API_IndexField.html
    type = "text"

    # analysis_scheme - (Optional) textフィールドに使用する分析スキーム
    # 言語固有のテキスト処理オプション(トークン化、ステミング等)を指定します。
    # 例: "_en_default_" (英語のデフォルトスキーム)
    # textおよびtext-arrayタイプのフィールドでのみ使用可能です。
    analysis_scheme = "_en_default_"

    # default_value - (Optional) ドキュメントデータでフィールドに値が指定されていない場合のデフォルト値
    # 最大1024文字まで指定可能です。
    # default_value = ""

    # facet - (Optional) ファセット情報を取得できるようにするかどうか
    # trueに設定すると、検索結果の絞り込みやフィルタリングに使用できます。
    # date, literal, int, double, date-array, literal-array, int-array, double-arrayタイプで使用可能です。
    # 参考: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/how-search-works.html
    facet = false

    # highlight - (Optional) ハイライト情報を有効にするかどうか
    # trueに設定すると、検索結果内でマッチした箇所をハイライト表示できます。
    # textおよびtext-arrayタイプのフィールドで使用可能です。
    highlight = true

    # return - (Optional) 検索可能なすべてのフィールドの値を返すことを有効にするかどうか
    # trueに設定すると、検索結果にこのフィールドの値を含めることができます。
    return = true

    # search - (Optional) このインデックスを検索可能にするかどうか
    # trueに設定すると、このフィールドを検索クエリの対象にできます。
    search = true

    # sort - (Optional) プロパティをソート可能にするかどうか
    # trueに設定すると、このフィールドで検索結果をソートできます。
    # int, double, date, literal タイプのフィールドで使用可能です。
    sort = false

    # source_fields - (Optional) フィールドにマップするソースフィールドのカンマ区切りリスト
    # ソースフィールドを指定すると、あるフィールドから別のフィールドにデータをコピーし、
    # 異なるオプション設定で同じソースデータを使用できます。
    # source_fields = ""
  }

  # 数値フィールドの例 (double)
  index_field {
    name   = "price"
    type   = "double"
    search = true
    facet  = true
    return = true
    sort   = true

    # source_fields - 他のフィールドからデータをコピーする場合に指定
    # source_fields = "original_price"
  }

  # 整数フィールドの例
  index_field {
    name   = "year"
    type   = "int"
    search = true
    facet  = true
    return = true
    sort   = true
  }

  # リテラルフィールドの例 (完全一致検索用)
  index_field {
    name   = "category"
    type   = "literal"
    search = true
    facet  = true
    return = true
    sort   = true
  }

  # 日付フィールドの例
  index_field {
    name   = "published_date"
    type   = "date"
    search = true
    facet  = true
    return = true
    sort   = true
  }

  # 配列フィールドの例 (literal-array)
  index_field {
    name   = "tags"
    type   = "literal-array"
    search = true
    facet  = true
    return = true
  }

  # テキスト配列フィールドの例
  index_field {
    name           = "descriptions"
    type           = "text-array"
    search         = true
    return         = true
    analysis_scheme = "_en_default_"
  }

  # ================================================================================
  # Nested Block: timeouts
  # ================================================================================
  # リソース操作のタイムアウト設定
  timeouts {
    # create - (Optional) リソース作成時のタイムアウト時間
    # デフォルトは30分です。
    create = "30m"

    # update - (Optional) リソース更新時のタイムアウト時間
    # デフォルトは30分です。
    update = "30m"

    # delete - (Optional) リソース削除時のタイムアウト時間
    # デフォルトは20分です。
    delete = "20m"
  }
}

# ================================================================================
# Computed Attributes (Read-Only)
# ================================================================================
# 以下の属性はTerraformによって自動的に計算され、読み取り専用です。
# これらは output ブロックや他のリソースの参照として使用できます。

# arn - ドメインのARN
# 例: output "domain_arn" { value = aws_cloudsearch_domain.example.arn }

# document_service_endpoint - 検索ドメイン内のドキュメントを更新するためのサービスエンドポイント
# 例: output "doc_endpoint" { value = aws_cloudsearch_domain.example.document_service_endpoint }

# domain_id - ドメインの内部生成された一意識別子
# 例: output "domain_id" { value = aws_cloudsearch_domain.example.domain_id }

# search_service_endpoint - 検索ドメインから検索結果をリクエストするためのサービスエンドポイント
# 例: output "search_endpoint" { value = aws_cloudsearch_domain.example.search_service_endpoint }

# ================================================================================
# 参考リンク
# ================================================================================
# - Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudsearch_domain
# - AWS CloudSearch ドキュメント: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/
# - ドメインエンドポイントオプション: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/configuring-domain-endpoint-options.html
# - インデックスフィールド設定: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/configuring-index-fields.html
# - スケーリングパラメータ: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/API_UpdateScalingParameters.html
# - DomainEndpointOptions API: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/API_DomainEndpointOptions.html
# - IndexField API: https://docs.aws.amazon.com/cloudsearch/latest/developerguide/API_IndexField.html
