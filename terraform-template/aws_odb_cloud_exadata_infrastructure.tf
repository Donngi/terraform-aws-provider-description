#---------------------------------------------------------------
# Oracle Database@AWS Cloud Exadata Infrastructure
#---------------------------------------------------------------
#
# Oracle Database@AWS用のExadataインフラストラクチャをプロビジョニングする。
# Oracle Exadata Database Serviceを実行するための基盤となるハードウェア
# （データベースサーバーとストレージサーバー）を構成する。
#
# AWS公式ドキュメント:
#   - Oracle Database@AWSの仕組み: https://docs.aws.amazon.com/odb/latest/UserGuide/how-it-works.html
#   - Oracle Database@AWSとは: https://docs.aws.amazon.com/odb/latest/UserGuide/what-is-odb.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/odb_cloud_exadata_infrastructure
#
# Provider Version: 6.28.0
# Generated: 2025-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_odb_cloud_exadata_infrastructure" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # display_name (Required, string)
  # Exadataインフラストラクチャのユーザーフレンドリーな表示名。
  # 変更すると新しいリソースが作成される。
  display_name = "my-exadata-infrastructure"

  # shape (Required, string)
  # Exadataインフラストラクチャのモデル名。
  # 利用可能な値:
  #   - "Exadata.X9M"  - X9Mシェイプ
  #   - "Exadata.X11M" - X11Mシェイプ（database_server_typeとstorage_server_typeが必須）
  # 変更すると新しいリソースが作成される。
  shape = "Exadata.X9M"

  # availability_zone_id (Required, string)
  # Exadataインフラストラクチャが配置されるアベイラビリティゾーンのID。
  # AZ名（us-east-1aなど）ではなく、AZ ID（use1-az6など）を指定する。
  # 変更すると新しいリソースが作成される。
  availability_zone_id = "use1-az6"

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # availability_zone (Optional, string)
  # Exadataインフラストラクチャが配置されるアベイラビリティゾーンの名前。
  # availability_zone_idを指定した場合、この値は自動的に設定される。
  # 変更すると新しいリソースが作成される。
  # availability_zone = "us-east-1a"

  # compute_count (Optional, number)
  # Exadataインフラストラクチャ内のコンピュートインスタンス（データベースサーバー）の数。
  # 最小値はシェイプによって異なる。
  compute_count = 2

  # storage_count (Optional, number)
  # Exadataインフラストラクチャでアクティブ化されるストレージサーバーの数。
  # 最小値はシェイプによって異なる。
  storage_count = 3

  # database_server_type (Optional, string)
  # Exadataインフラストラクチャのデータベースサーバーモデルタイプ。
  # 有効なモデル名のリストはListDbSystemShapes操作で取得可能。
  # Exadata.X11Mシェイプでは必須。
  # 変更すると新しいリソースが作成される。
  # database_server_type = "X11M"

  # storage_server_type (Optional, string)
  # Exadataインフラストラクチャのストレージサーバーモデルタイプ。
  # 有効なモデル名のリストはListDbSystemShapes操作で取得可能。
  # Exadata.X11Mシェイプでは必須。
  # 変更すると新しいリソースが作成される。
  # storage_server_type = "X11M-HC"

  # customer_contacts_to_send_to_oci (Optional, set of object)
  # Oracleからメンテナンス更新の通知を受け取る連絡先のメールアドレス。
  # 変更すると新しいリソースが作成される。
  # customer_contacts_to_send_to_oci = [
  #   {
  #     email = "admin@example.com"
  #   },
  #   {
  #     email = "dba@example.com"
  #   }
  # ]

  # region (Optional, string)
  # このリソースが管理されるAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用される。
  # region = "us-east-1"

  # tags (Optional, map of string)
  # Exadataインフラストラクチャに割り当てるタグのマップ。
  # プロバイダーレベルのdefault_tags設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きする。
  # tags = {
  #   Environment = "production"
  #   Project     = "oracle-migration"
  # }

  #---------------------------------------------------------------
  # maintenance_window ブロック (Optional)
  #---------------------------------------------------------------
  # メンテナンスウィンドウのスケジューリング詳細。
  # パッチ適用やシステム更新はメンテナンスウィンドウ中に行われる。
  #
  # maintenance_window {
  #   #-------------------------------------------------------------
  #   # maintenance_window 必須属性
  #   #-------------------------------------------------------------
  #
  #   # custom_action_timeout_in_mins (Required, number)
  #   # メンテナンスウィンドウのカスタムアクションタイムアウト（分単位）。
  #   custom_action_timeout_in_mins = 16
  #
  #   # is_custom_action_timeout_enabled (Required, bool)
  #   # メンテナンスウィンドウでカスタムアクションタイムアウトが有効かどうか。
  #   is_custom_action_timeout_enabled = true
  #
  #   # patching_mode (Required, string)
  #   # メンテナンスウィンドウのパッチ適用モード。
  #   # 利用可能な値:
  #   #   - "ROLLING"      - ローリング方式（ダウンタイム最小）
  #   #   - "NONROLLING"   - 非ローリング方式（一括適用）
  #   patching_mode = "ROLLING"
  #
  #   # preference (Required, string)
  #   # メンテナンスウィンドウスケジューリングの設定。
  #   # 利用可能な値:
  #   #   - "NO_PREFERENCE"     - システムが自動的にスケジュール
  #   #   - "CUSTOM_PREFERENCE" - カスタムスケジュールを使用
  #   preference = "CUSTOM_PREFERENCE"
  #
  #   #-------------------------------------------------------------
  #   # maintenance_window オプション属性
  #   #-------------------------------------------------------------
  #
  #   # days_of_week (Optional, set of object)
  #   # メンテナンスを実行できる曜日。
  #   # preferenceが"CUSTOM_PREFERENCE"の場合に使用。
  #   # 利用可能な値: MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
  #   # days_of_week = [
  #   #   { name = "MONDAY" },
  #   #   { name = "TUESDAY" }
  #   # ]
  #
  #   # hours_of_day (Optional, set of number)
  #   # メンテナンスを実行できる時間（0-23のUTC時刻）。
  #   # preferenceが"CUSTOM_PREFERENCE"の場合に使用。
  #   # hours_of_day = [11, 16]
  #
  #   # lead_time_in_weeks (Optional, number)
  #   # メンテナンスウィンドウ前のリードタイム（週単位）。
  #   # lead_time_in_weeks = 3
  #
  #   # months (Optional, set of object)
  #   # メンテナンスを実行できる月。
  #   # 四半期ごとのメンテナンスウィンドウの場合、4つの月を指定。
  #   # 利用可能な値: JANUARY, FEBRUARY, MARCH, APRIL, MAY, JUNE,
  #   #              JULY, AUGUST, SEPTEMBER, OCTOBER, NOVEMBER, DECEMBER
  #   # months = [
  #   #   { name = "FEBRUARY" },
  #   #   { name = "MAY" },
  #   #   { name = "AUGUST" },
  #   #   { name = "NOVEMBER" }
  #   # ]
  #
  #   # weeks_of_month (Optional, set of number)
  #   # メンテナンスを実行できる月の週番号（1-4）。
  #   # weeks_of_month = [2, 4]
  # }

  #---------------------------------------------------------------
  # timeouts ブロック (Optional)
  #---------------------------------------------------------------
  # リソース操作のタイムアウト設定。
  # 指定しない場合、デフォルトのタイムアウト値が使用される。
  #
  # timeouts {
  #   # create (Optional, string)
  #   # リソース作成のタイムアウト。
  #   # 有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
  #   # 例: "30s", "2h45m"
  #   # create = "12h"
  #
  #   # update (Optional, string)
  #   # リソース更新のタイムアウト。
  #   # update = "2h"
  #
  #   # delete (Optional, string)
  #   # リソース削除のタイムアウト。
  #   # delete = "2h"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性がエクスポートされる（computed only属性）:
#
# - id                            : Exadataインフラストラクチャの一意識別子
# - arn                           : ExadataインフラストラクチャのAmazon Resource Name (ARN)
# - ocid                          : ExadataインフラストラクチャのOracle Cloud Identifier (OCID)
# - oci_url                       : OCIでのExadataインフラストラクチャへのHTTPSリンク
# - oci_resource_anchor_name      : ExadataインフラストラクチャのOCIリソースアンカー名
# - status                        : Exadataインフラストラクチャの現在のステータス
# - status_reason                 : Exadataインフラストラクチャのステータスに関する追加情報
# - percent_progress              : 現在の操作の進捗率（パーセンテージ）
# - created_at                    : Exadataインフラストラクチャが作成された日時
#
# コンピュート関連:
# - compute_model                 : コンピュートモデル（ECPUまたはOCPU）
# - cpu_count                     : 割り当てられたCPUコアの総数
# - max_cpu_count                 : 利用可能なCPUコアの総数
# - memory_size_in_gbs            : 割り当てられたメモリ量（GB）
# - max_memory_in_gbs             : 利用可能なメモリの総量（GB）
#
# ストレージ関連:
# - activated_storage_count       : リクエストされたストレージサーバーの数
# - additional_storage_count      : 追加のストレージサーバーの数
# - available_storage_size_in_gbs : 利用可能なストレージ量（GB）
# - total_storage_size_in_gbs     : 総ストレージ量（GB）
# - data_storage_size_in_tbs      : データディスクグループのサイズ（TB）
# - max_data_storage_in_tbs       : 利用可能なデータディスクグループの総量（TB）
# - db_node_storage_size_in_gbs   : ローカルノードストレージのサイズ（GB）
# - max_db_node_storage_size_in_gbs : 利用可能なローカルノードストレージの総量（GB）
#
# ソフトウェアバージョン関連:
# - db_server_version             : データベースサーバーのソフトウェアバージョン
# - storage_server_version        : ストレージサーバーのソフトウェアバージョン
# - monthly_db_server_version     : データベースサーバーの月次ソフトウェアバージョン
# - monthly_storage_server_version : ストレージサーバーの月次ソフトウェアバージョン
#
# メンテナンス関連:
# - last_maintenance_run_id       : 最後のメンテナンス実行のOCID
# - next_maintenance_run_id       : 次のメンテナンス実行のOCID
#
# タグ関連:
# - tags_all                      : プロバイダーのdefault_tagsを含む全タグのマップ
