################################################################################
# aws_dynamodb_global_secondary_index
################################################################################
# リソース概要:
# DynamoDBテーブルにGlobal Secondary Index（GSI）を追加・管理するリソース。
# GSIはテーブルの主キー以外の属性で効率的なクエリを実行できるようにするインデックス。
#
# 重要な制約事項:
# - このリソースは実験的機能（experimental feature）
# - 環境変数 TF_AWS_EXPERIMENT_dynamodb_global_secondary_index を設定する必要がある
# - aws_dynamodb_tableのglobal_secondary_indexブロックと併用禁止（競合が発生）
# - スキーマやビヘイビアは予告なく変更される可能性がある
# - 後方互換性の保証対象外
#
# フィードバック:
# https://github.com/hashicorp/terraform-provider-aws/issues/45640
#
# AWS公式ドキュメント:
# - Using Global Secondary Indexes: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GSI.html
# - Managing GSIs: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GSI.OnlineOps.html
# - GSI Throttling: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/gsi-throttling.html
# - API Reference: https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_GlobalSecondaryIndex.html
################################################################################

resource "aws_dynamodb_global_secondary_index" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # table_name - (必須) このインデックスが属するテーブルの名前
  # Type: string
  #
  # 説明:
  # - GSIを追加するDynamoDBテーブルの名前を指定
  # - aws_dynamodb_tableリソースの名前属性を参照するのが一般的
  table_name = "example-table"

  # index_name - (必須) インデックスの名前
  # Type: string
  # Length: 3-255文字
  #
  # 説明:
  # - テーブル内の他の全てのインデックスと一意である必要がある
  # - インデックス名はクエリ実行時に指定する
  # - 命名規則: ユースケースを反映した分かりやすい名前を推奨
  #   例: "GameTitleIndex", "UserEmailIndex", "CreatedAtIndex"
  index_name = "GameTitleIndex"

  # key_schema - (必須) キースキーマ定義のセット
  # Type: block (複数可)
  #
  # 説明:
  # - 最低1つのHASH（パーティションキー）要素が必須
  # - HASH要素は必ずRANGE要素より前に配置する必要がある
  # - key_schemaの値を変更するとリソースが再作成される
  # - GSIのキースキーマはベーステーブルと異なるものを指定可能
  #
  # 設計上の考慮事項:
  # - パーティションキー: データの分散に使用される属性を選択
  # - ソートキー: 範囲クエリを実行したい属性を選択
  # - マルチ属性キー: 複数の属性を組み合わせたキーも設定可能
  key_schema {
    # attribute_name - (必須) 属性の名前
    # Type: string
    #
    # 説明:
    # - ベーステーブルのattributeブロックで定義された属性名を指定
    # - データ型はベーステーブルの定義と一致する必要がある
    attribute_name = "GameTitle"

    # attribute_type - (必須) インデックス内の属性のタイプ
    # Type: string
    # Valid values: "S" (string), "N" (number), "B" (binary)
    #
    # 説明:
    # - S: 文字列型（例: "PlayerName", "Email"）
    # - N: 数値型（例: "Score", "Price", "Quantity"）
    # - B: バイナリ型（例: 画像データ、暗号化キー）
    # - ベーステーブルの対応する属性のデータ型と一致する必要がある
    attribute_type = "S"

    # key_type - (必須) キーのタイプ
    # Type: string
    # Valid values: "HASH", "RANGE"
    #
    # 説明:
    # - HASH: パーティションキー（必須、1つのみ指定可能）
    # - RANGE: ソートキー（オプション、1つのみ指定可能）
    # - HASHキーはデータの分散とパーティショニングに使用される
    # - RANGEキーは同じパーティション内でのソートとレンジクエリに使用される
    key_type = "HASH"
  }

  # ソートキーを追加する場合の例:
  # key_schema {
  #   attribute_name = "CreatedAt"
  #   attribute_type = "N"
  #   key_type       = "RANGE"
  # }

  # projection - (必須) インデックスに含める属性の設定
  # Type: block (単一)
  #
  # 説明:
  # - ベーステーブルからGSIにコピーする属性を定義
  # - プロジェクションタイプによってストレージコストとクエリの柔軟性が変わる
  # - インデックスのサイズとコストは投影する属性数とデータサイズに依存
  projection {
    # projection_type - (必須) インデックスに含める属性のセット
    # Type: string
    # Valid values: "ALL", "INCLUDE", "KEYS_ONLY"
    #
    # 説明と選択ガイド:
    #
    # 1. KEYS_ONLY:
    #    - テーブルのキー属性とインデックスのキー属性のみ
    #    - ストレージコスト最小、書き込みコスト最小
    #    - クエリでキー以外の属性が必要な場合は追加のフェッチが必要
    #    - 使用場面: キーのみでクエリが完結する場合
    #
    # 2. INCLUDE:
    #    - KEYS_ONLYの属性に加えて、non_key_attributesで指定した属性を含む
    #    - ストレージコスト中程度、書き込みコスト中程度
    #    - よく使用する属性だけを選択的に含めることでコストと性能のバランスを取る
    #    - 使用場面: 特定の属性セットのみがクエリで必要な場合
    #
    # 3. ALL:
    #    - ベーステーブルの全属性をインデックスに投影
    #    - ストレージコスト最大、書き込みコスト最大
    #    - 追加のフェッチ不要で最大のクエリ柔軟性
    #    - 使用場面: 様々な属性の組み合わせでクエリする必要がある場合
    #
    # 選択基準:
    # - クエリパターンが明確 → KEYS_ONLY または INCLUDE
    # - クエリパターンが不明確または多様 → ALL
    # - コスト最適化優先 → KEYS_ONLY または INCLUDE
    # - クエリ性能優先 → ALL
    projection_type = "INCLUDE"

    # non_key_attributes - (オプション) インデックスに含める追加属性
    # Type: list(string)
    #
    # 説明:
    # - projection_typeが"INCLUDE"の場合のみ有効
    # - キー属性以外でクエリ結果に含めたい属性を指定
    # - 指定した属性はストレージと書き込みコストに影響する
    # - アプリケーションのクエリ要件に基づいて必要最小限の属性を指定することを推奨
    #
    # 例: ユーザー関連のクエリでよく使用する属性
    non_key_attributes = ["UserId", "CreatedAt"]
  }

  ################################################################################
  # オプションパラメータ - スループット設定
  ################################################################################

  # provisioned_throughput - (オプション) プロビジョンドスループット設定
  # Type: block (単一)
  #
  # 説明:
  # - テーブルのbilling_modeが"PROVISIONED"の場合は必須
  # - GSIはベーステーブルとは独立してスループットを消費する
  # - GSIの容量が不足するとベーステーブルへの書き込みがスロットリングされる（GSI back-pressure）
  #
  # 重要な考慮事項:
  # - GSIのパーティションキーによってホットスポットが発生する可能性がある
  # - ベーステーブルの書き込み活動に対応できる十分な容量を確保すること
  # - GSIへの書き込みは非同期で処理される（eventually consistent）
  #
  # CloudWatchメトリクス:
  # - OnlineIndexConsumedWriteCapacity: GSIが消費した書き込み容量
  # - OnlineIndexThrottleEvents: スロットリングイベントの回数
  provisioned_throughput {
    # read_capacity_units - (必須) 読み取りキャパシティユニット数
    # Type: number
    #
    # 説明:
    # - 1 RCU = 最大4KBのアイテムに対して1秒あたり1回の強整合性読み取り
    # - 1 RCU = 最大4KBのアイテムに対して1秒あたり2回の結果整合性読み取り
    # - GSIは結果整合性読み取りのみをサポート
    # - 読み取りコストはインデックスエントリのサイズに依存
    #
    # 設定ガイド:
    # - 予想されるクエリのピーク負荷を考慮
    # - アイテムサイズとクエリ頻度から必要なRCUを計算
    # - Auto Scalingの設定を推奨
    read_capacity_units = 10

    # write_capacity_units - (必須) 書き込みキャパシティユニット数
    # Type: number
    #
    # 説明:
    # - 1 WCU = 最大1KBのアイテムに対して1秒あたり1回の書き込み
    # - ベーステーブルへの書き込みがGSIの更新を引き起こす
    # - インデックス化された属性の更新・削除で追加のWCUが消費される
    #
    # 重要な注意点:
    # - GSIのWCU不足はベーステーブルの書き込みスロットリングを引き起こす
    # - ベーステーブルの書き込みレートと同等以上の容量が必要
    # - プロジェクションタイプ（ALL/INCLUDE/KEYS_ONLY）で消費量が変わる
    #
    # 設定ガイド:
    # - ベーステーブルのWCUと同等以上を推奨
    # - バーストトラフィックを考慮して余裕を持たせる
    # - CloudWatchでスロットリングを監視
    write_capacity_units = 10
  }

  # on_demand_throughput - (オプション) オンデマンドスループット設定
  # Type: block (単一)
  #
  # 説明:
  # - テーブルのbilling_modeが"PAY_PER_REQUEST"の場合のみ有効
  # - 読み取りと書き込みの最大ユニット数を設定
  # - オンデマンドモードでは自動的にスケールするが、上限を設定可能
  #
  # 使用場面:
  # - ワークロードが予測不可能な場合
  # - トラフィックが散発的な場合
  # - 管理オーバーヘッドを削減したい場合
  #
  # on_demand_throughput {
  #   # max_read_request_units - (オプション) 最大読み取りリクエストユニット
  #   # Type: number
  #   #
  #   # 説明:
  #   # - GSIが処理できる最大の読み取りリクエスト数の上限
  #   # - 設定しない場合、DynamoDBのデフォルト上限が適用される
  #   # - 予期しないコスト増加を防ぐための安全機構
  #   max_read_request_units = 50000
  #
  #   # max_write_request_units - (オプション) 最大書き込みリクエストユニット
  #   # Type: number
  #   #
  #   # 説明:
  #   # - GSIが処理できる最大の書き込みリクエスト数の上限
  #   # - この上限を超えるとスロットリングが発生
  #   # - ベーステーブルへの書き込みもスロットリングされる可能性がある
  #   max_write_request_units = 50000
  # }

  # warm_throughput - (オプション) ウォームスループット設定
  # Type: block (単一)
  #
  # 説明:
  # - テーブルとインデックスを事前にウォームアップしてトラフィック急増に備える
  # - 大規模イベントや新規テーブルの初期トラフィックに対応
  # - 非同期操作で、設定中も他のテーブル更新が可能
  # - デフォルト: 4,000 WCUs、12,000 RCUs
  #
  # 使用場面:
  # - 新しいオンデマンドテーブルで高い初期トラフィックが予想される場合
  # - 大規模イベント（セール、ライブ配信など）の準備
  # - DynamoDBへの移行準備
  #
  # コスト:
  # - 現在のウォームスループットと新しい値の差分に対する一回限りの料金
  # - リージョンごとのプロビジョンドWCU/RCUのコストで計算
  #
  # warm_throughput {
  #   # read_units_per_second - (必須) 即座にサポート可能な読み取り操作数
  #   # Type: number
  #   #
  #   # 説明:
  #   # - インデックスが瞬時にサポートできる1秒あたりの読み取り操作数
  #   # - ピークスループットの計算に基づいて設定
  #   # - 使用量の増加に応じて自動的に拡張される
  #   read_units_per_second = 15000
  #
  #   # write_units_per_second - (必須) 即座にサポート可能な書き込み操作数
  #   # Type: number
  #   #
  #   # 説明:
  #   # - インデックスが瞬時にサポートできる1秒あたりの書き込み操作数
  #   # - アプリケーションのピーク書き込み要求を考慮
  #   # - GSI back-pressureを防ぐため十分な値を設定
  #   write_units_per_second = 5000
  # }

  ################################################################################
  # オプションパラメータ - その他
  ################################################################################

  # region - (オプション) リソースが管理されるリージョン
  # Type: string
  # Default: プロバイダー設定のリージョン
  #
  # 説明:
  # - このリソースを管理するAWSリージョンを明示的に指定
  # - 指定しない場合、プロバイダーの設定が使用される
  # - グローバルテーブルを使用する場合、各リージョンでGSIを管理可能
  #
  # 使用場面:
  # - マルチリージョン構成で特定リージョンのGSIを管理する場合
  # - リージョン間で異なるGSI設定を適用する場合
  #
  # region = "us-west-2"

  ################################################################################
  # Attributes Reference (読み取り専用)
  ################################################################################
  # 以下の属性は、リソース作成後に参照可能です:
  #
  # - arn - GSIのARN (Amazon Resource Name)
  #   説明: IAMポリシーやCloudWatch監視などで使用する一意の識別子
  #   例: "arn:aws:dynamodb:us-east-1:123456789012:table/example-table/index/GameTitleIndex"
  #
  ################################################################################

  ################################################################################
  # 設計ベストプラクティス
  ################################################################################
  #
  # 1. キー設計:
  #    - パーティションキー: 高いカーディナリティの属性を選択してホットパーティションを回避
  #    - ソートキー: 範囲クエリやソートが必要な属性を選択
  #    - 複合キー: 複数属性の組み合わせでクエリパターンを最適化
  #
  # 2. プロジェクション戦略:
  #    - クエリパターンが明確な場合: KEYS_ONLY または INCLUDE でコスト最適化
  #    - クエリパターンが多様な場合: ALL でクエリ柔軟性を確保
  #    - 頻繁にアクセスする属性のみを含めてストレージコストを削減
  #
  # 3. スループット管理:
  #    - プロビジョンドモード: Auto Scalingを設定して需要変動に対応
  #    - オンデマンドモード: 予測不可能なワークロードに適している
  #    - GSIのWCUはベーステーブル以上を確保してback-pressureを回避
  #
  # 4. 監視とトラブルシューティング:
  #    - CloudWatchメトリクスでスロットリングを監視
  #    - OnlineIndexConsumedWriteCapacity: GSIの書き込み消費量
  #    - OnlineIndexThrottleEvents: スロットリング発生回数
  #    - OnlineIndexPercentageProgress: インデックス作成の進捗（作成時）
  #
  # 5. コスト最適化:
  #    - 不要な属性の投影を避ける（INCLUDE または KEYS_ONLY）
  #    - 使用されていないGSIは削除する
  #    - プロビジョンドモードでAuto Scalingを活用
  #    - ウォームスループットは必要な場合のみ使用
  #
  # 6. スロットリング回避:
  #    - GSIのパーティションキーの分散性を確保
  #    - 十分なWCUを割り当ててGSI back-pressureを防止
  #    - バーストトラフィックに備えてバッファを確保
  #    - CloudWatchアラームで異常を早期検知
  #
  # 7. 制約事項:
  #    - テーブルごとに最大20個のGSI
  #    - キー属性はString、Number、Binaryのスカラー型のみ
  #    - GSIの更新は非同期で最終的整合性
  #    - GSIの作成中もテーブルは使用可能だが、パフォーマンスに影響する可能性がある
  #
  ################################################################################
  # エラーハンドリングとトラブルシューティング
  ################################################################################
  #
  # 1. GSI Provisioned Capacity Exceeded:
  #    原因: GSIの書き込み容量が不足
  #    解決策: GSIのWCUを増やす、Auto Scalingを有効化
  #
  # 2. GSI On-Demand Maximum Throughput Exceeded:
  #    原因: オンデマンドテーブルのGSI書き込み操作が上限を超過
  #    解決策: max_write_request_unitsを増やす、ワークロードを分散
  #
  # 3. GSI Partition Limits Exceeded:
  #    原因: 個々のGSIパーティションがスループット上限を超過
  #    解決策: パーティションキーの分散性を改善、キー設計を見直す
  #
  # 4. GSI Account Limits Exceeded:
  #    原因: リージョン内のアカウントレベルのスループット上限を超過
  #    解決策: AWSサポートに上限緩和を依頼
  #
  # 5. GSI Back-Pressure:
  #    原因: GSIの容量不足によりベーステーブルの書き込みがスロットリング
  #    解決策: GSIのスループットを増やす、不要なGSIを削除、プロジェクションを最適化
  #
  ################################################################################
  # 参考リンク
  ################################################################################
  #
  # Terraform AWS Provider:
  # - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_global_secondary_index
  #
  # AWS公式ドキュメント:
  # - Using GSIs: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GSI.html
  # - Managing GSIs: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GSI.OnlineOps.html
  # - GSI Throttling: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/gsi-throttling.html
  # - Warm Throughput: https://aws.amazon.com/blogs/database/pre-warming-amazon-dynamodb-tables-with-warm-throughput/
  # - API Reference: https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_GlobalSecondaryIndex.html
  #
  # フィードバック:
  # - https://github.com/hashicorp/terraform-provider-aws/issues/45640
  #
  ################################################################################
}

################################################################################
# 使用例: 完全な構成
################################################################################

# 例1: プロビジョンドモードのテーブルとGSI
resource "aws_dynamodb_table" "game_scores" {
  name           = "GameScores"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }

  attribute {
    name = "TopScore"
    type = "N"
  }

  # GSIで使用する属性を定義（key_schemaで参照されるもの）
  attribute {
    name = "GameTitleTopScore"
    type = "S"
  }
}

# ゲームタイトルでクエリするためのGSI
resource "aws_dynamodb_global_secondary_index" "game_title_index" {
  table_name = aws_dynamodb_table.game_scores.name
  index_name = "GameTitleIndex"

  key_schema {
    attribute_name = "GameTitle"
    attribute_type = "S"
    key_type       = "HASH"
  }

  key_schema {
    attribute_name = "TopScore"
    attribute_type = "N"
    key_type       = "RANGE"
  }

  projection {
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }

  provisioned_throughput {
    read_capacity_units  = 10
    write_capacity_units = 10
  }
}

# 例2: オンデマンドモードのテーブルとGSI
resource "aws_dynamodb_table" "user_activity" {
  name         = "UserActivity"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserId"
  range_key    = "Timestamp"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "N"
  }

  attribute {
    name = "ActivityType"
    type = "S"
  }
}

resource "aws_dynamodb_global_secondary_index" "activity_type_index" {
  table_name = aws_dynamodb_table.user_activity.name
  index_name = "ActivityTypeIndex"

  key_schema {
    attribute_name = "ActivityType"
    attribute_type = "S"
    key_type       = "HASH"
  }

  key_schema {
    attribute_name = "Timestamp"
    attribute_type = "N"
    key_type       = "RANGE"
  }

  projection {
    projection_type = "ALL"
  }

  on_demand_throughput {
    max_read_request_units  = 50000
    max_write_request_units = 50000
  }
}

# 例3: ウォームスループットを使用した大規模イベント対応
resource "aws_dynamodb_table" "event_registrations" {
  name         = "EventRegistrations"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "EventId"
  range_key    = "UserId"

  attribute {
    name = "EventId"
    type = "S"
  }

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "RegistrationTime"
    type = "N"
  }
}

resource "aws_dynamodb_global_secondary_index" "registration_time_index" {
  table_name = aws_dynamodb_table.event_registrations.name
  index_name = "RegistrationTimeIndex"

  key_schema {
    attribute_name = "EventId"
    attribute_type = "S"
    key_type       = "HASH"
  }

  key_schema {
    attribute_name = "RegistrationTime"
    attribute_type = "N"
    key_type       = "RANGE"
  }

  projection {
    projection_type = "KEYS_ONLY"
  }

  # 大規模イベント開始に備えて事前にウォームアップ
  warm_throughput {
    read_units_per_second  = 20000
    write_units_per_second = 10000
  }
}

# 例4: Auto Scalingを使用したプロビジョンドモード（別途aws_appautoscaling_*リソースが必要）
resource "aws_dynamodb_table" "products" {
  name           = "Products"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "ProductId"

  attribute {
    name = "ProductId"
    type = "S"
  }

  attribute {
    name = "Category"
    type = "S"
  }

  attribute {
    name = "Price"
    type = "N"
  }
}

resource "aws_dynamodb_global_secondary_index" "category_price_index" {
  table_name = aws_dynamodb_table.products.name
  index_name = "CategoryPriceIndex"

  key_schema {
    attribute_name = "Category"
    attribute_type = "S"
    key_type       = "HASH"
  }

  key_schema {
    attribute_name = "Price"
    attribute_type = "N"
    key_type       = "RANGE"
  }

  projection {
    projection_type    = "INCLUDE"
    non_key_attributes = ["ProductId", "Name", "Description"]
  }

  provisioned_throughput {
    read_capacity_units  = 5
    write_capacity_units = 5
  }
}

# Auto Scalingターゲットの設定例（GSIの読み取り容量）
# resource "aws_appautoscaling_target" "gsi_read_target" {
#   max_capacity       = 100
#   min_capacity       = 5
#   resource_id        = "table/${aws_dynamodb_table.products.name}/index/${aws_dynamodb_global_secondary_index.category_price_index.index_name}"
#   scalable_dimension = "dynamodb:index:ReadCapacityUnits"
#   service_namespace  = "dynamodb"
# }
#
# resource "aws_appautoscaling_policy" "gsi_read_policy" {
#   name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.gsi_read_target.resource_id}"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.gsi_read_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.gsi_read_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.gsi_read_target.service_namespace
#
#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "DynamoDBReadCapacityUtilization"
#     }
#     target_value = 70.0
#   }
# }
