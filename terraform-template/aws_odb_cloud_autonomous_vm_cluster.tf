#---------------------------------------------------------------
# AWS ODB Cloud Autonomous VM Cluster
#---------------------------------------------------------------
#
# Oracle Database@AWS の Autonomous VM クラスターをプロビジョニングするリソースです。
# Autonomous VM クラスターは、Oracle Exadata インフラストラクチャ上で Oracle
# Autonomous Database on Dedicated Exadata Infrastructure を実行するための
# フルマネージドなデータベースクラスターです。機械学習と AI を活用してキー管理タスクを
# 自動化します。
#
# AWS公式ドキュメント:
#   - Oracle Database@AWS ユーザーガイド: https://docs.aws.amazon.com/odb/latest/UserGuide/what-is-odb.html
#   - Autonomous VM クラスターの概要: https://docs.aws.amazon.com/odb/latest/UserGuide/how-it-works.html
#   - CreateCloudAutonomousVmCluster API: https://docs.aws.amazon.com/odb/latest/APIReference/API_CreateCloudAutonomousVmCluster.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/odb_cloud_autonomous_vm_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_odb_cloud_autonomous_vm_cluster" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # display_name (Required, Forces new resource)
  # 設定内容: Autonomous VM クラスターの表示名を指定します。
  # 設定可能な値: 文字列
  display_name = "my_autonomous_vm_cluster"

  # description (Optional)
  # 設定内容: Autonomous VM クラスターの説明を指定します。
  # 設定可能な値: 任意の文字列
  description = "My Autonomous VM Cluster"

  #-------------------------------------------------------------
  # インフラストラクチャ設定
  #-------------------------------------------------------------

  # cloud_exadata_infrastructure_id (Required, Forces new resource)
  # 設定内容: Autonomous VM クラスターを作成する Exadata インフラストラクチャの ID を指定します。
  # 設定可能な値: 有効な ODB Cloud Exadata Infrastructure の ID
  # 注意: cloud_exadata_infrastructure_id と odb_network_id の組み合わせが必須です。
  cloud_exadata_infrastructure_id = "aws-ocid1.cloudexadatainfrastructure.oc1.example"

  # odb_network_id (Required, Forces new resource)
  # 設定内容: この Autonomous VM クラスターに関連付ける ODB ネットワークの一意識別子を指定します。
  # 設定可能な値: 有効な ODB ネットワーク ID
  # 注意: cloud_exadata_infrastructure_id と odb_network_id の組み合わせが必須です。
  odb_network_id = "aws-ocid1.odbnetwork.oc1.example"

  # db_servers (Required, Forces new resource)
  # 設定内容: Autonomous VM クラスターを構成するデータベースサーバーの ID セットを指定します。
  # 設定可能な値: 有効なデータベースサーバー ID のセット（Exadata インフラストラクチャを参照）
  db_servers = ["db-server-id-1", "db-server-id-2"]

  #-------------------------------------------------------------
  # コンピュートリソース設定
  #-------------------------------------------------------------

  # cpu_core_count_per_node (Required, Forces new resource)
  # 設定内容: Autonomous VM クラスター内の各ノードで有効化する CPU コア数を指定します。
  # 設定可能な値: 正の整数（Exadata インフラストラクチャのスペックに依存）
  cpu_core_count_per_node = 40

  # memory_per_oracle_compute_unit_in_gbs (Required, Forces new resource)
  # 設定内容: Oracle Compute Unit ごとに割り当てるメモリ量を GB 単位で指定します。
  # 設定可能な値: 正の整数（GB）
  memory_per_oracle_compute_unit_in_gbs = 2

  #-------------------------------------------------------------
  # ストレージ設定
  #-------------------------------------------------------------

  # autonomous_data_storage_size_in_tbs (Required)
  # 設定内容: Autonomous VM クラスター内の Autonomous Database に割り当てるデータストレージサイズを TB 単位で指定します。
  # 設定可能な値: 正の数値（TB）
  autonomous_data_storage_size_in_tbs = 5

  # total_container_databases (Required, Forces new resource)
  # 設定内容: 割り当てられたローカルストレージで作成できる Autonomous Container Database の総数を指定します。
  # 設定可能な値: 正の整数
  total_container_databases = 1

  #-------------------------------------------------------------
  # ネットワーク接続設定
  #-------------------------------------------------------------

  # scan_listener_port_non_tls (Required, Forces new resource)
  # 設定内容: 非 TLS (TCP) プロトコル用の SCAN リスナーポートを指定します。
  # 設定可能な値: 有効なポート番号（デフォルトは 1521）
  scan_listener_port_non_tls = 1521

  # scan_listener_port_tls (Required, Forces new resource)
  # 設定内容: TLS (TCP) プロトコル用の SCAN リスナーポートを指定します。
  # 設定可能な値: 有効なポート番号（デフォルトは 2484）
  scan_listener_port_tls = 2484

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # is_mtls_enabled_vm_cluster (Optional, Forces new resource)
  # 設定内容: Autonomous VM クラスターで相互 TLS (mTLS) 認証を有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: mTLS 認証を有効化
  #   - false: mTLS 認証を無効化
  # 省略時: プロバイダーのデフォルト値が使用されます
  is_mtls_enabled_vm_cluster = true

  #-------------------------------------------------------------
  # ライセンス設定
  #-------------------------------------------------------------

  # license_model (Optional, Forces new resource)
  # 設定内容: Autonomous VM クラスターのライセンスモデルを指定します。
  # 設定可能な値:
  #   - "LICENSE_INCLUDED": Oracle ライセンスを含む価格モデル
  #   - "BRING_YOUR_OWN_LICENSE": 既存の Oracle ライセンスを持ち込む価格モデル（BYOL）
  # 省略時: プロバイダーのデフォルト値が使用されます
  license_model = "LICENSE_INCLUDED"

  #-------------------------------------------------------------
  # タイムゾーン設定
  #-------------------------------------------------------------

  # time_zone (Optional, Forces new resource)
  # 設定内容: Autonomous VM クラスターのタイムゾーンを指定します。
  # 設定可能な値: 有効な IANA タイムゾーン識別子（例: "UTC", "US/Eastern", "Asia/Tokyo"）
  # 省略時: デフォルトのタイムゾーンが使用されます
  time_zone = "UTC"

  #-------------------------------------------------------------
  # メンテナンスウィンドウ設定
  #-------------------------------------------------------------

  # maintenance_window (Required)
  # 設定内容: Autonomous VM クラスターのメンテナンスウィンドウ設定ブロックです。
  # 関連機能: Oracle Database@AWS メンテナンスウィンドウ
  #   メンテナンスが実行できる時間帯を制御します。カスタム設定または優先設定なしから選択できます。
  #   - https://docs.aws.amazon.com/odb/latest/UserGuide/getting-started.html
  maintenance_window {

    # preference (Required)
    # 設定内容: メンテナンスウィンドウスケジューリングの優先設定を指定します。
    # 設定可能な値:
    #   - "NO_PREFERENCE": スケジューリングの優先設定なし（システムがメンテナンス時間を選択）
    #   - "CUSTOM_PREFERENCE": カスタムメンテナンスウィンドウ設定を使用
    preference = "CUSTOM_PREFERENCE"

    # days_of_week (Optional)
    # 設定内容: メンテナンスを実行できる曜日のセットを指定します。
    # 設定可能な値: 曜日名を持つオブジェクトのセット
    #   name の有効な値: "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"
    # 省略時: すべての曜日が対象となります
    days_of_week = [{ name = "MONDAY" }, { name = "TUESDAY" }]

    # hours_of_day (Optional)
    # 設定内容: メンテナンスを実行できる時刻（時間）のセットを指定します。
    # 設定可能な値: 0 〜 23 の整数のセット（UTC 時間）
    # 省略時: すべての時間帯が対象となります
    hours_of_day = [4, 16]

    # lead_time_in_weeks (Optional)
    # 設定内容: メンテナンスウィンドウ前のリードタイム（週数）を指定します。
    # 設定可能な値: 正の整数（週）
    # 省略時: デフォルトのリードタイムが使用されます
    lead_time_in_weeks = 3

    # months (Optional)
    # 設定内容: メンテナンスを実行できる月のセットを指定します。
    # 設定可能な値: 月名を持つオブジェクトのセット
    #   name の有効な値: "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE",
    #                    "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"
    # 省略時: すべての月が対象となります
    months = [{ name = "FEBRUARY" }, { name = "MAY" }, { name = "AUGUST" }, { name = "NOVEMBER" }]

    # weeks_of_month (Optional)
    # 設定内容: メンテナンスを実行できる月内の週のセットを指定します。
    # 設定可能な値: 1 〜 4 の整数のセット（月の第何週かを示す）
    # 省略時: すべての週が対象となります
    weeks_of_month = [2, 4]
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: us-east-1, us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと一致するキーを持つタグは、
  #       プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-autonomous-vm-cluster"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの期間文字列（s: 秒, m: 分, h: 時間）
    create = "60m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの期間文字列（s: 秒, m: 分, h: 時間）
    update = "60m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの期間文字列（s: 秒, m: 分, h: 時間）
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id / arn / ocid: クラスターの識別子（AWS ID, ARN, Oracle OCID）
# - status / status_reason: クラスターのステータスと詳細理由
# - compute_model / shape: コンピュートモデル（ECPU/OCPU）と Exadata シェイプ
# - cpu_core_count / cpu_percentage: 総 CPU コア数と使用率
# - available_cpus / provisioned_cpus / reclaimable_cpus / reserved_cpus: CPU 内訳
# - memory_size_in_gbs: 総メモリ量（GB）
# - data_storage_size_in_gbs / data_storage_size_in_tbs: 総データストレージ容量
# - odb_node_storage_size_in_gbs / exadata_storage_in_tbs_lowest_scaled_value: ノード・スケール下限ストレージ
# - autonomous_data_storage_percentage / available_autonomous_data_storage_size_in_tbs: Autonomous ストレージ状況
# - available_container_databases / provisionable_autonomous_container_databases: 利用可能な CDB 数
# - provisioned_autonomous_container_databases / non_provisionable_autonomous_container_databases: CDB 状況
# - max_acds_lowest_scaled_value: Autonomous CDB 最大数のスケールダウン下限値
# - percent_progress: 現在の操作の進捗率（%）
# - node_count: データベースサーバーノード数
# - hostname / domain: ホスト名とドメイン名
# - oci_url / oci_resource_anchor_name: OCI コンソール URL と OCI リソースアンカー名
# - created_at: クラスター作成日時
# - time_database_ssl_certificate_expires / time_ords_certificate_expires: 証明書有効期限
# - tags_all: プロバイダーの default_tags を含む全タグマップ
#---------------------------------------------------------------
