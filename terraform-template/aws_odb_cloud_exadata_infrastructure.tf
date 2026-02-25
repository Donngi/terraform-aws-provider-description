#---------------------------------------------------------------
# AWS Oracle Database@AWS Cloud Exadata Infrastructure
#---------------------------------------------------------------
#
# Oracle Database@AWS (ODB@AWS) の Exadata インフラストラクチャを
# プロビジョニングするリソースです。
# Oracle Cloud Infrastructure (OCI) が管理する Exadata ハードウェアを
# AWS データセンター内の指定したアベイラビリティゾーンに配置します。
# このリソースは Oracle Exadata Database Service の基盤となります。
#
# AWS公式ドキュメント:
#   - Oracle Database@AWS とは: https://docs.aws.amazon.com/odb/latest/UserGuide/what-is-odb.html
#   - Oracle Database@AWS の使い方: https://docs.aws.amazon.com/odb/latest/UserGuide/how-it-works.html
#   - Oracle Database@AWS 入門: https://docs.aws.amazon.com/odb/latest/UserGuide/getting-started.html
#   - CloudExadataInfrastructure API: https://docs.aws.amazon.com/odb/latest/APIReference/API_CloudExadataInfrastructure.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/odb_cloud_exadata_infrastructure
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_odb_cloud_exadata_infrastructure" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # display_name (Required, Forces new resource)
  # 設定内容: Exadata インフラストラクチャのユーザーフレンドリーな表示名を指定します。
  # 設定可能な値: 文字列
  # 注意: この値を変更すると、Terraform は新しいリソースを作成します。
  display_name = "my-exa-infra"

  # shape (Required, Forces new resource)
  # 設定内容: Exadata インフラストラクチャのモデル名を指定します。
  # 設定可能な値: "Exadata.X9M", "Exadata.X11M" など、Oracle が提供するシェイプ名
  # 注意: この値を変更すると、Terraform は新しいリソースを作成します。
  # 参考: https://docs.aws.amazon.com/odb/latest/UserGuide/getting-started.html
  shape = "Exadata.X11M"

  # availability_zone_id (Required, Forces new resource)
  # 設定内容: Exadata インフラストラクチャを配置するアベイラビリティゾーンの ID を指定します。
  # 設定可能な値: 有効な AWS AZ ID（例: use1-az6）
  # 注意: この値を変更すると、Terraform は新しいリソースを作成します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  availability_zone_id = "use1-az6"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # アベイラビリティゾーン設定
  #-------------------------------------------------------------

  # availability_zone (Optional)
  # 設定内容: Exadata インフラストラクチャが配置されるアベイラビリティゾーン名を指定します。
  # 設定可能な値: 有効なAZ名（例: us-east-1a）
  # 省略時: Terraform または AWS が自動的に決定します。
  # 注意: この値を変更すると、Terraform は新しいリソースを作成します。
  #       availability_zone_id との組み合わせで使用します。
  availability_zone = null

  #-------------------------------------------------------------
  # コンピューティング・ストレージ設定
  #-------------------------------------------------------------

  # compute_count (Optional)
  # 設定内容: Exadata インフラストラクチャ上で有効化するコンピュートインスタンスの数を指定します。
  # 設定可能な値: 正の整数。Exadata シェイプによって最小・最大値が異なります。
  # 省略時: AWS または OCI がデフォルト値を設定します。
  # 注意: この値を変更すると、Terraform は新しいリソースを作成します。
  compute_count = 2

  # storage_count (Optional)
  # 設定内容: Exadata インフラストラクチャ上で有効化するストレージサーバーの数を指定します。
  # 設定可能な値: 正の整数。Exadata シェイプによって最小・最大値が異なります。
  # 省略時: AWS または OCI がデフォルト値を設定します。
  # 注意: この値を変更すると、Terraform は新しいリソースを作成します。
  storage_count = 3

  #-------------------------------------------------------------
  # サーバータイプ設定
  #-------------------------------------------------------------

  # database_server_type (Optional, Forces new resource)
  # 設定内容: Exadata インフラストラクチャのデータベースサーバーモデルタイプを指定します。
  # 設定可能な値: ListDbSystemShapes オペレーションで取得できる有効なモデル名
  #              例: "X11M"（Exadata.X11M シェイプでは必須）
  # 省略時: シェイプによってはデフォルトのサーバータイプが使用されます。
  # 注意: Exadata.X11M シェイプでは必須パラメータです。
  #       この値を変更すると、Terraform は新しいリソースを作成します。
  database_server_type = "X11M"

  # storage_server_type (Optional, Forces new resource)
  # 設定内容: Exadata インフラストラクチャのストレージサーバーモデルタイプを指定します。
  # 設定可能な値: ListDbSystemShapes オペレーションで取得できる有効なモデル名
  #              例: "X11M-HC"（Exadata.X11M シェイプでは必須）
  # 省略時: シェイプによってはデフォルトのサーバータイプが使用されます。
  # 注意: Exadata.X11M シェイプでは必須パラメータです。
  #       この値を変更すると、Terraform は新しいリソースを作成します。
  storage_server_type = "X11M-HC"

  #-------------------------------------------------------------
  # 顧客連絡先設定
  #-------------------------------------------------------------

  # customer_contacts_to_send_to_oci (Optional, Forces new resource)
  # 設定内容: Exadata インフラストラクチャのメンテナンス更新に関する Oracle からの
  #           通知を受け取る連絡先のメールアドレスのセットを指定します。
  # 設定可能な値: email フィールドを持つオブジェクトのセット
  # 省略時: Oracle からの通知は設定された連絡先に送信されません。
  # 注意: この値を変更すると、Terraform は新しいリソースを作成します。
  customer_contacts_to_send_to_oci = [
    { email = "admin@example.com" },
    { email = "ops@example.com" },
  ]

  #-------------------------------------------------------------
  # メンテナンスウィンドウ設定
  #-------------------------------------------------------------

  # maintenance_window (Optional)
  # 設定内容: Exadata インフラストラクチャのメンテナンスウィンドウのスケジュール詳細を
  #           指定します。パッチ適用とシステム更新はこのウィンドウ内に実施されます。
  # 参考: https://docs.aws.amazon.com/odb/latest/UserGuide/getting-started.html
  maintenance_window {

    #-----------------------------------------------------------
    # メンテナンスウィンドウ - メンテナンス設定
    #-----------------------------------------------------------

    # preference (Required)
    # 設定内容: メンテナンスウィンドウのスケジューリング設定の優先度を指定します。
    # 設定可能な値:
    #   - "NO_PREFERENCE": スケジュールをOCIに任せます
    #   - "CUSTOM_PREFERENCE": カスタムスケジュールを指定します
    preference = "CUSTOM_PREFERENCE"

    # patching_mode (Required)
    # 設定内容: メンテナンスウィンドウのパッチ適用モードを指定します。
    # 設定可能な値:
    #   - "ROLLING": ローリングアップデート方式でパッチを適用（ダウンタイムを最小化）
    #   - "NONROLLING": 一括でパッチを適用
    patching_mode = "ROLLING"

    # is_custom_action_timeout_enabled (Required)
    # 設定内容: メンテナンスウィンドウのカスタムアクションタイムアウトを有効にするかを指定します。
    # 設定可能な値:
    #   - true: カスタムタイムアウトを有効化
    #   - false: カスタムタイムアウトを無効化
    is_custom_action_timeout_enabled = true

    # custom_action_timeout_in_mins (Required)
    # 設定内容: メンテナンスウィンドウのカスタムアクションタイムアウトを分単位で指定します。
    # 設定可能な値: 正の整数（分）
    custom_action_timeout_in_mins = 16

    #-----------------------------------------------------------
    # メンテナンスウィンドウ - スケジュール設定
    #-----------------------------------------------------------

    # days_of_week (Optional)
    # 設定内容: メンテナンスを実施できる曜日のセットを指定します。
    # 設定可能な値: name フィールドを持つオブジェクトのセット
    #   name に指定できる値: "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY",
    #                        "FRIDAY", "SATURDAY", "SUNDAY"
    # 省略時: preference が "CUSTOM_PREFERENCE" でない場合は不要です。
    days_of_week = [
      { name = "MONDAY" },
      { name = "TUESDAY" },
    ]

    # hours_of_day (Optional)
    # 設定内容: メンテナンスを実施できる時間帯（UTC 時）のセットを指定します。
    # 設定可能な値: 0 〜 23 の整数のセット
    # 省略時: preference が "CUSTOM_PREFERENCE" でない場合は不要です。
    hours_of_day = [11, 16]

    # lead_time_in_weeks (Optional)
    # 設定内容: メンテナンスウィンドウの前のリードタイム（週数）を指定します。
    # 設定可能な値: 正の整数（週）
    # 省略時: AWS または OCI がデフォルト値を設定します。
    lead_time_in_weeks = 3

    # months (Optional)
    # 設定内容: メンテナンスを実施できる月のセットを指定します。
    # 設定可能な値: name フィールドを持つオブジェクトのセット
    #   name に指定できる値: "JANUARY", "FEBRUARY", "MARCH", "APRIL",
    #                        "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER",
    #                        "OCTOBER", "NOVEMBER", "DECEMBER"
    # 省略時: preference が "CUSTOM_PREFERENCE" でない場合は不要です。
    months = [
      { name = "FEBRUARY" },
      { name = "MAY" },
      { name = "AUGUST" },
      { name = "NOVEMBER" },
    ]

    # weeks_of_month (Optional)
    # 設定内容: メンテナンスを実施できる月内の週番号のセットを指定します。
    # 設定可能な値: 1 〜 4 の整数のセット（第1週〜第4週）
    # 省略時: preference が "CUSTOM_PREFERENCE" でない場合は不要です。
    weeks_of_month = [2, 4]
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: Exadata インフラストラクチャリソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されません。
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-exa-infra"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # Exadata インフラストラクチャのプロビジョニングには時間がかかるため、
  # 必要に応じてタイムアウト値を調整してください。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの期間文字列（s=秒, m=分, h=時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    create = "3h"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの期間文字列（s=秒, m=分, h=時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    update = "3h"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの期間文字列（s=秒, m=分, h=時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    delete = "3h"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Exadata インフラストラクチャの一意の識別子
# - arn: Amazon Resource Name (ARN)
# - ocid: OCI における識別子 (OCID)
# - oci_url: OCI コンソールへの HTTPS リンク
# - oci_resource_anchor_name: OCI リソースアンカーの名前
# - status / status_reason: 現在のステータスと補足情報
# - percent_progress: 現在の操作の進捗率（パーセント）
# - created_at: 作成日時
# - compute_model: コンピュートモデル（ECPU または OCPU）
# - cpu_count / max_cpu_count: 割り当て済み・最大 CPU コア数
# - memory_size_in_gbs / max_memory_in_gbs: 割り当て済み・最大メモリ量（GB）
# - activated_storage_count / additional_storage_count: ストレージサーバー数
# - available_storage_size_in_gbs / total_storage_size_in_gbs: ストレージ量（GB）
# - data_storage_size_in_tbs / max_data_storage_in_tbs: データストレージ量（TB）
# - db_node_storage_size_in_gbs / max_db_node_storage_size_in_gbs: ノードストレージ（GB）
# - db_server_version / monthly_db_server_version: DBサーバーのバージョン
# - storage_server_version / monthly_storage_server_version: ストレージサーバーのバージョン
# - last_maintenance_run_id / next_maintenance_run_id: メンテナンス実行の OCID
# - tags_all: プロバイダーの default_tags 設定を含む全タグのマップ
#---------------------------------------------------------------
