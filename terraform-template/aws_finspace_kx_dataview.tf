#---------------------------------------------------------------
# AWS FinSpace Kx Dataview
#---------------------------------------------------------------
#
# FinSpace Managed kdb Insights データベースのスナップショット（dataview）を作成します。
# Dataviewは、kdbクラスターにマウント可能な、階層型ストレージ機能とプリウォーム
# キャッシュを備えたデータベーススナップショットです。スケーリンググループ上の
# クラスターでのみ利用可能で、専用クラスターではサポートされていません。
#
# AWS公式ドキュメント:
#   - CreateKxDataview API: https://docs.aws.amazon.com/finspace/latest/management-api/API_CreateKxDataview.html
#   - Dataviews for querying data: https://docs.aws.amazon.com/finspace/latest/userguide/finspace-managed-kdb-dataviews.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/finspace_kx_dataview
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 重要: Amazon FinSpaceは2026年10月7日にサポート終了予定です。
#       2025年10月7日以降、新規顧客の受け入れは停止されます。
#
#---------------------------------------------------------------

resource "aws_finspace_kx_dataview" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # dataviewの一意識別子
  # - 3〜63文字の英数字、ハイフン、アンダースコアが使用可能
  # - 英数字で開始・終了する必要があります
  name = "my-kx-dataview"

  # dataviewを作成するKx環境の一意識別子
  # 参照: aws_finspace_kx_environment リソースのID
  environment_id = "your-environment-id"

  # dataviewを作成するデータベースの名前
  # 参照: aws_finspace_kx_database リソースの名前
  database_name = "your-database-name"

  # クラスター毎に割り当てるアベイラビリティゾーンの数
  # - "SINGLE": クラスター毎に1つのAZを割り当て
  # - "MULTI": クラスター毎に全てのAZを割り当て
  az_mode = "SINGLE"

  # 新しいchangesetを取り込む際に、将来の追加・修正を自動的にdataviewに適用するかどうか
  # - true: 自動更新dataview（最新データを常に反映）
  # - false: 静的dataview（手動更新が必要）
  # デフォルト: false
  # 注意: read_write = true の場合、auto_update は false である必要があります
  auto_update = false

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # アベイラビリティゾーンの識別子
  # ボリュームをアタッチする場合、ボリュームはdataviewと同じAZに存在する必要があります
  # 例: "use1-az2"
  availability_zone_id = null

  # データ取り込みに使用するデータベースchangesetの一意識別子
  # 指定しない場合、最新のchangesetが使用されます
  changeset_id = null

  # dataviewの説明
  # 用途や目的を記載することで、管理を容易にします
  description = null

  # dataviewを書き込み可能にして、データベースメンテナンスを実行するかどうか
  # 注意事項:
  # - 部分的な書き込み可能dataviewは作成できません（データベース全体のパスを提供する必要があります）
  # - 書き込み可能dataviewでは更新を実行できないため、auto_update = false である必要があります
  # - 書き込み可能dataviewには一意のボリュームを使用する必要があります
  # - 作成後、read-onlyに変更することはできません
  # デフォルト: false（読み取り専用）
  read_write = null

  # リソースが管理されるAWSリージョン
  # 未指定の場合、プロバイダー設定のリージョンが使用されます
  region = null

  # リソースに割り当てるタグ（キー・バリューのマップ）
  # provider の default_tags と組み合わせて使用できます
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # プロバイダーの default_tags を含む、全てのタグのマップ
  # 通常は computed 属性として自動的に管理されますが、明示的に設定も可能
  tags_all = null

  # Terraform がリソース操作を管理する際に使用する一意のID
  # 通常は自動生成されますが、インポート時などに明示的に指定可能
  # フォーマット: "environment_id,database_name,dataview_name"
  id = null

  #---------------------------------------------------------------
  # ネストブロック: segment_configurations
  #---------------------------------------------------------------
  # 選択した各ボリュームに配置するデータのデータベースパスを含む設定
  # 各セグメントは、ボリューム毎に一意のデータベースパスを持つ必要があります
  # データベースパスを明示的に指定しない場合、デフォルトのS3/オブジェクトストア
  # セグメントを通じてクラスターからアクセス可能になります

  segment_configurations {
    # 各選択したボリュームに配置するデータのデータベースパス（必須）
    # 各セグメントは、ボリューム毎に一意のデータベースパスを持つ必要があります
    # ワイルドカードを使用可能:
    # - "/*": 全てのパーティション
    # - "/2023.01.*": 特定の月の全パーティション
    # - "/2023.01.01": 特定のパーティション
    db_paths = ["/*"]

    # dataviewにアタッチするボリュームの名前（必須）
    # このボリュームは、アタッチ先のdataviewと同じAZに存在する必要があります
    # 参照: aws_finspace_kx_volume リソースの名前
    volume_name = "your-volume-name"

    # 特定のファイルやデータベースの列にアクセスする際に、
    # 選択したデータベースパスでオンデマンドキャッシングを有効にするかどうか
    # - true: 必要に応じてファイルを最小限ロード（パフォーマンスと容量のバランス）
    # - false: 全てキャッシュ（高速だが容量が必要）
    # デフォルト: false
    on_demand = null
  }

  #---------------------------------------------------------------
  # ネストブロック: timeouts
  #---------------------------------------------------------------
  # リソース操作のタイムアウト設定
  # キャッシュのタイプやKxボリュームのサイズによっては、
  # 作成/更新タイムアウトを最大24時間、削除タイムアウトを12時間まで増やす必要があります

  timeouts {
    # リソース作成のタイムアウト
    # 大規模なボリュームの場合、24時間まで設定可能
    # 例: "24h", "30m", "1h30m"
    create = null

    # リソース更新のタイムアウト
    # 大規模なボリュームの場合、24時間まで設定可能
    update = null

    # リソース削除のタイムアウト
    # 大規模なボリュームの場合、12時間まで設定可能
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性は computed のみで、リソース作成後に参照可能です
#
# - arn                     - KX dataviewのAmazon Resource Name (ARN)
# - created_timestamp       - dataviewがFinSpaceで作成されたタイムスタンプ（エポックミリ秒）
#                             例: 1635768000000 (2021-11-01 12:00:00 UTC)
# - id                      - environment ID, database name, dataview nameをカンマ区切りで
#                             結合した文字列
# - last_modified_timestamp - dataviewがFinSpaceで最後に更新されたタイムスタンプ（エポックミリ秒）
# - status                  - dataviewのステータス（作成中、利用可能、削除中など）
# - tags_all                - provider の default_tags を含む、全てのタグのマップ
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
/*
# 基本的な使用例
resource "aws_finspace_kx_dataview" "example" {
  name                 = "my-tf-kx-dataview"
  environment_id       = aws_finspace_kx_environment.example.id
  database_name        = aws_finspace_kx_database.example.name
  availability_zone_id = "use1-az2"
  description          = "Terraform managed Kx Dataview"
  az_mode              = "SINGLE"
  auto_update          = true

  segment_configurations {
    volume_name = aws_finspace_kx_volume.example.name
    db_paths    = ["/*"]
  }

  timeouts {
    create = "24h"
    update = "24h"
    delete = "12h"
  }
}

# 複数セグメントを持つdataview
resource "aws_finspace_kx_dataview" "multi_segment" {
  name           = "multi-segment-dataview"
  environment_id = aws_finspace_kx_environment.example.id
  database_name  = aws_finspace_kx_database.example.name
  az_mode        = "SINGLE"
  auto_update    = false

  # 2023年のデータを高速ボリュームに配置
  segment_configurations {
    volume_name = aws_finspace_kx_volume.fast.name
    db_paths    = ["/2023.*"]
    on_demand   = false
  }

  # それ以前のデータを標準ボリュームに配置
  segment_configurations {
    volume_name = aws_finspace_kx_volume.standard.name
    db_paths    = ["/202[0-2].*"]
    on_demand   = true
  }
}

# 書き込み可能dataview（データベースメンテナンス用）
resource "aws_finspace_kx_dataview" "writable" {
  name           = "writable-dataview"
  environment_id = aws_finspace_kx_environment.example.id
  database_name  = aws_finspace_kx_database.example.name
  az_mode        = "SINGLE"
  auto_update    = false  # 書き込み可能の場合は false が必須
  read_write     = true

  segment_configurations {
    volume_name = aws_finspace_kx_volume.unique.name
    db_paths    = ["/*"]  # 書き込み可能dataviewは全体パスが必要
  }
}
*/
