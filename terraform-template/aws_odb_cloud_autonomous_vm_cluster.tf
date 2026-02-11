#---------------------------------------------------------------
# Oracle Database@AWS Cloud Autonomous VM Cluster
#---------------------------------------------------------------
#
# Oracle Database@AWS において、Autonomous VM Cluster（自律型VMクラスター）を
# 管理するリソース。Autonomous VM Clusterは、Oracle Exadata Infrastructure上で
# 稼働し、Autonomous Container Database (ACD) をホストするための仮想マシン
# クラスターを提供する。機械学習とAIを活用した完全マネージド型のデータベース
# 環境を構築できる。
#
# AWS公式ドキュメント:
#   - Oracle Database@AWS User Guide: https://docs.aws.amazon.com/odb/latest/UserGuide/what-is-odb.html
#   - CloudAutonomousVmCluster API Reference: https://docs.aws.amazon.com/odb/latest/APIReference/API_CloudAutonomousVmCluster.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/odb_cloud_autonomous_vm_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_odb_cloud_autonomous_vm_cluster" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # cloud_exadata_infrastructure_id (必須・変更時は再作成)
  # このAutonomous VM ClusterをホストするOracle Exadata Infrastructureの
  # 一意識別子。aws_odb_cloud_exadata_infrastructure リソースで作成された
  # インフラストラクチャIDを指定する。
  cloud_exadata_infrastructure_id = "<aws_odb_cloud_exadata_infrastructure_id>"

  # odb_network_id (必須・変更時は再作成)
  # このAutonomous VM Clusterに関連付けるODBネットワークの一意識別子。
  # ODBネットワークは、AWS Availability Zone内でOCIインフラストラクチャを
  # ホストするプライベートな分離ネットワーク。
  odb_network_id = "<aws_odb_network_id>"

  # display_name (必須・変更時は再作成)
  # Autonomous VM Clusterの表示名。AWSコンソールやAPIで
  # クラスターを識別するために使用される。
  display_name = "my-autonomous-vm-cluster"

  # autonomous_data_storage_size_in_tbs (必須・変更時は再作成)
  # Autonomous VM Cluster内のAutonomous Databaseに割り当てるデータ
  # ストレージサイズ（テラバイト単位）。クラスター内の全データベースが
  # 共有するストレージ容量。
  # 例: 5 (5TB)
  autonomous_data_storage_size_in_tbs = 5

  # memory_per_oracle_compute_unit_in_gbs (必須・変更時は再作成)
  # Oracle Compute Unit (OCU) あたりに割り当てるメモリ量（ギガバイト単位）。
  # Autonomous Databaseのパフォーマンスに影響する重要なパラメータ。
  # 例: 2
  memory_per_oracle_compute_unit_in_gbs = 2

  # total_container_databases (必須・変更時は再作成)
  # 割り当てられたローカルストレージで作成可能なAutonomous Container
  # Database (ACD) の最大数。ACDは複数のAutonomous Databaseを
  # 論理的にグループ化するコンテナ。
  # 例: 1
  total_container_databases = 1

  # cpu_core_count_per_node (必須・変更時は再作成)
  # Autonomous VM Cluster内の各ノードで有効化するCPUコア数。
  # クラスター全体のコンピューティング能力を決定する。
  # 例: 40
  cpu_core_count_per_node = 40

  # db_servers (必須・変更時は再作成)
  # Autonomous VM Cluster内のデータベースサーバーのID一覧。
  # Cloud Exadata Infrastructureに含まれるDBサーバーから選択する。
  # 最低1つのDBサーバーが必要。
  # 例: ["db-server-1-id", "db-server-2-id"]
  db_servers = ["<my_db_server_id>"]

  # scan_listener_port_tls (必須・変更時は再作成)
  # TLS (TCP) プロトコル用のSCAN（Single Client Access Name）リスナーポート。
  # セキュアな暗号化接続に使用される。デフォルトは2484。
  # 例: 2484, 8561
  scan_listener_port_tls = 2484

  # scan_listener_port_non_tls (必須・変更時は再作成)
  # 非TLS (TCP) プロトコル用のSCANリスナーポート。
  # 暗号化なしの接続に使用される。デフォルトは1521。
  # 例: 1521, 1024
  scan_listener_port_non_tls = 1521

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # description (オプション)
  # Autonomous VM Clusterの説明文。クラスターの用途や
  # 構成に関する情報を記録するために使用。
  # 例: "Production autonomous VM cluster for enterprise applications"
  description = null

  # license_model (オプション・変更時は再作成)
  # Autonomous VM Clusterのライセンスモデル。
  # - "LICENSE_INCLUDED": Oracleライセンスが含まれる（ライセンス料込み）
  # - "BRING_YOUR_OWN_LICENSE": 既存のOracleライセンスを持ち込む（BYOL）
  # 未指定時はサービスデフォルトが適用される。
  license_model = "LICENSE_INCLUDED"

  # is_mtls_enabled_vm_cluster (オプション・変更時は再作成)
  # Autonomous VM Clusterで相互TLS (mTLS) 認証を有効にするかどうか。
  # mTLSを有効にすると、クライアントとサーバー間の双方向認証が必要となり、
  # セキュリティが強化される。
  # 例: true, false
  is_mtls_enabled_vm_cluster = null

  # time_zone (オプション・変更時は再作成)
  # Autonomous VM Clusterのタイムゾーン設定。
  # 標準のタイムゾーン識別子（例: "UTC", "America/New_York", "Asia/Tokyo"）を指定。
  # 例: "UTC"
  time_zone = null

  # region (オプション)
  # このリソースを管理するAWSリージョン。
  # 未指定時はプロバイダー設定のリージョンが使用される。
  # Oracle Database@AWSは特定のリージョンでのみサポートされる
  # （例: us-east-1, us-west-2, ap-northeast-1, us-east-2, eu-central-1）。
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # tags (オプション)
  # リソースに割り当てるタグのマップ。
  # プロバイダーレベルの default_tags が設定されている場合、
  # 同じキーのタグはリソースレベルの値で上書きされる。
  # 例: { "Environment" = "production", "Project" = "database-migration" }
  tags = {
    "Environment" = "production"
    "ManagedBy"   = "terraform"
  }

  #---------------------------------------------------------------
  # maintenance_window ブロック (必須)
  #---------------------------------------------------------------
  # Autonomous VM Clusterのメンテナンスウィンドウ設定。
  # メンテナンス作業（パッチ適用、更新等）を実行する時間枠を定義する。

  maintenance_window {
    # preference (必須・変更時は再作成)
    # メンテナンスウィンドウのスケジューリング設定。
    # - "NO_PREFERENCE": システムが自動的にメンテナンス時間を選択
    # - "CUSTOM_PREFERENCE": カスタムのメンテナンススケジュールを指定
    preference = "NO_PREFERENCE"

    # days_of_week (オプション・変更時は再作成)
    # メンテナンスを実行できる曜日のリスト。
    # オブジェクトのセットで、各オブジェクトは "name" キーを持つ。
    # 値: "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"
    # preference が "CUSTOM_PREFERENCE" の場合に使用。
    # 例: [{ name = "MONDAY" }, { name = "TUESDAY" }]
    # days_of_week = [{ name = "MONDAY" }, { name = "TUESDAY" }]

    # hours_of_day (オプション・変更時は再作成)
    # メンテナンスを実行できる時間帯（0-23の時刻）のセット。
    # UTC時刻で指定。preference が "CUSTOM_PREFERENCE" の場合に使用。
    # 例: [4, 16] (午前4時と午後4時)
    # hours_of_day = [4, 16]

    # lead_time_in_weeks (オプション・変更時は再作成)
    # メンテナンスウィンドウ前のリードタイム（週単位）。
    # メンテナンス通知を事前に受け取る期間を指定。
    # 例: 3 (3週間前に通知)
    # lead_time_in_weeks = 3

    # months (オプション・変更時は再作成)
    # メンテナンスを実行できる月のリスト。
    # オブジェクトのセットで、各オブジェクトは "name" キーを持つ。
    # 値: "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE",
    #      "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"
    # preference が "CUSTOM_PREFERENCE" の場合に使用。
    # 例: [{ name = "FEBRUARY" }, { name = "MAY" }, { name = "AUGUST" }, { name = "NOVEMBER" }]
    # months = [{ name = "FEBRUARY" }, { name = "MAY" }, { name = "AUGUST" }, { name = "NOVEMBER" }]

    # weeks_of_month (オプション・変更時は再作成)
    # メンテナンスを実行できる月内の週（1-4）のセット。
    # preference が "CUSTOM_PREFERENCE" の場合に使用。
    # 例: [2, 4] (第2週と第4週)
    # weeks_of_month = [2, 4]
  }

  #---------------------------------------------------------------
  # timeouts ブロック (オプション)
  #---------------------------------------------------------------
  # 各操作のタイムアウト設定。時間は "30s", "2h45m" などの形式で指定。
  # Autonomous VM Clusterの作成には長時間かかる場合があるため、
  # 適切なタイムアウト値の設定が推奨される。

  # timeouts {
  #   # create: リソース作成のタイムアウト
  #   # Autonomous VM Clusterのプロビジョニングには時間がかかるため、
  #   # 十分な時間を設定することを推奨。
  #   # 例: "2h" (2時間)
  #   create = "2h"
  #
  #   # update: リソース更新のタイムアウト
  #   # 例: "1h" (1時間)
  #   update = "1h"
  #
  #   # delete: リソース削除のタイムアウト
  #   # 例: "1h" (1時間)
  #   delete = "1h"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能（Computed属性）:
#
# arn:
#   Autonomous VM ClusterのAmazon Resource Name (ARN)。
#
# id:
#   Autonomous VM Clusterの一意識別子。
#
# autonomous_data_storage_percentage:
#   Autonomous VM Clusterでの現在の操作の進捗状況（パーセンテージ）。
#
# available_autonomous_data_storage_size_in_tbs:
#   Autonomous Databaseに利用可能なデータストレージ容量（TB単位）。
#
# available_container_databases:
#   現在利用可能なストレージで作成可能なAutonomous CDBの数。
#
# available_cpus:
#   Autonomous Databaseに割り当て可能なCPUコア数。
#
# compute_model:
#   Autonomous VM Clusterのコンピュートモデル。
#   値: "ECPU" または "OCPU"
#
# cpu_core_count:
#   Autonomous VM Cluster内の総CPUコア数。
#
# cpu_percentage:
#   Autonomous VM Clusterで使用中のCPUコアの割合。
#
# created_at:
#   Autonomous VM Clusterが作成された日時。
#
# data_storage_size_in_gbs:
#   Autonomous VM Clusterに割り当てられた総データストレージ（GB単位）。
#
# data_storage_size_in_tbs:
#   Autonomous VM Clusterに割り当てられた総データストレージ（TB単位）。
#
# domain:
#   Autonomous VM Clusterのドメイン名。
#
# exadata_storage_in_tbs_lowest_scaled_value:
#   Exadataストレージをスケールダウンできる最小値（TB単位）。
#
# hostname:
#   Autonomous VM Clusterのホスト名。
#
# max_acds_lowest_scaled_value:
#   Autonomous CDBの最大数をスケールダウンできる最小値。
#
# memory_size_in_gbs:
#   Autonomous VM Clusterに割り当てられた総メモリ量（GB単位）。
#
# node_count:
#   Autonomous VM Cluster内のデータベースサーバーノード数。
#
# non_provisionable_autonomous_container_databases:
#   リソース制約によりプロビジョニングできないAutonomous CDBの数。
#
# oci_resource_anchor_name:
#   このAutonomous VM Clusterに関連付けられたOCIリソースアンカー名。
#
# oci_url:
#   このAutonomous VM ClusterのOCIコンソールページにアクセスするためのURL。
#
# ocid:
#   Autonomous VM ClusterのOracle Cloud Identifier (OCID)。
#
# odb_node_storage_size_in_gbs:
#   Autonomous VM Clusterに割り当てられたローカルノードストレージ（GB単位）。
#
# percent_progress:
#   Autonomous VM Clusterでの現在の操作の進捗状況（パーセンテージ）。
#
# provisionable_autonomous_container_databases:
#   Autonomous VM Clusterでプロビジョニング可能なAutonomous CDBの数。
#
# provisioned_autonomous_container_databases:
#   Autonomous VM Clusterで現在プロビジョニングされているAutonomous CDBの数。
#
# provisioned_cpus:
#   Autonomous VM ClusterでプロビジョニングされているCPU数。
#
# reclaimable_cpus:
#   終了またはスケールダウンされたAutonomous Databaseから
#   回収可能なCPUコア数。
#
# reserved_cpus:
#   システム運用と冗長性のために予約されたCPUコア数。
#
# shape:
#   Autonomous VM ClusterのExadataインフラストラクチャのシェイプ。
#
# status:
#   Autonomous VM Clusterの状態。
#   値: "CREATING", "AVAILABLE", "UPDATING", "DELETING", "DELETED", "FAILED"
#
# status_reason:
#   Autonomous VM Clusterの現在の状態に関する追加情報。
#
# tags_all:
#   ユーザー定義タグとプロバイダー定義タグの組み合わせ。
#
# time_database_ssl_certificate_expires:
#   データベースSSL証明書の有効期限日時。
#
# time_ords_certificate_expires:
#   ORDS証明書の有効期限日時。
