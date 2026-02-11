#---------------------------------------------------------------
# Oracle Database@AWS Cloud VM Cluster
#---------------------------------------------------------------
#
# Oracle Database@AWS用のCloud VMクラスターを作成します。
# Cloud VMクラスターは、Oracle Grid Infrastructure (GI)を実行する
# 仮想マシンのクラスターであり、Oracle Exadataインフラストラクチャ上で
# Oracle Databaseを実行するための基盤を提供します。
#
# AWS公式ドキュメント:
#   - Oracle Database@AWS User Guide: https://docs.aws.amazon.com/odb/latest/UserGuide/what-is-odb.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/odb_cloud_vm_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_odb_cloud_vm_cluster" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # display_name (必須)
  # VMクラスターのユーザーフレンドリーな名前。
  # 変更すると新しいリソースが作成されます。
  display_name = "example-vm-cluster"

  # cpu_core_count (必須)
  # VMクラスターで有効にするCPUコア数。
  # 変更すると新しいリソースが作成されます。
  cpu_core_count = 6

  # data_storage_size_in_tbs (必須)
  # VMクラスターに割り当てるデータディスクグループのサイズ（テラバイト単位）。
  # 変更すると新しいリソースが作成されます。
  data_storage_size_in_tbs = 20.0

  # db_servers (必須)
  # VMクラスター用のデータベースサーバーのリスト。
  # 変更すると新しいリソースが作成されます。
  # 型: set(string)
  db_servers = [
    "db-server-1",
    "db-server-2",
  ]

  # gi_version (必須)
  # Oracle Grid Infrastructure (GI)の有効なソフトウェアバージョン。
  # 有効な値のリストを取得するには、ListGiVersions操作を使用し、
  # Exadataインフラストラクチャのシェイプを指定します。
  # 例: 19.0.0.0, 23.0.0.0
  # 変更すると新しいリソースが作成されます。
  gi_version = "23.0.0.0"

  # hostname_prefix (必須)
  # VMクラスターのホスト名プレフィックス。
  # 制約:
  #   - "localhost"または"hostname"は使用不可
  #   - "-version"を含めることはできない
  #   - ホスト名とドメインの合計長は63文字以内
  #   - サブネット内で一意である必要がある
  # 変更すると新しいリソースが作成されます。
  hostname_prefix = "example"

  # ssh_public_keys (必須)
  # VMクラスターへのSSHアクセスに使用する1つ以上のキーペアの公開鍵部分。
  # 変更すると新しいリソースが作成されます。
  # 型: set(string)
  ssh_public_keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ...",
  ]

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # cloud_exadata_infrastructure_id (オプション)
  # このVMクラスター用のExadataインフラストラクチャの一意識別子。
  # cloud_exadata_infrastructure_idとodb_network_idの組み合わせ、
  # またはcloud_exadata_infrastructure_arnとodb_network_arnの組み合わせを使用する必要があります。
  # 変更すると新しいリソースが作成されます。
  # cloud_exadata_infrastructure_id = "oci-1234567890abcdef"

  # cloud_exadata_infrastructure_arn (オプション)
  # このVMクラスター用のExadataインフラストラクチャのARN。
  # cloud_exadata_infrastructure_idとodb_network_idの組み合わせ、
  # またはcloud_exadata_infrastructure_arnとodb_network_arnの組み合わせを使用する必要があります。
  # 変更すると新しいリソースが作成されます。
  # cloud_exadata_infrastructure_arn = "arn:aws:odb:us-east-1:123456789012:cloud-exadata-infrastructure/example"

  # odb_network_id (オプション)
  # VMクラスター用のODBネットワークの一意識別子。
  # cloud_exadata_infrastructure_idとodb_network_idの組み合わせ、
  # またはcloud_exadata_infrastructure_arnとodb_network_arnの組み合わせを使用する必要があります。
  # 変更すると新しいリソースが作成されます。
  # odb_network_id = "oci-abcdef1234567890"

  # odb_network_arn (オプション)
  # VMクラスター用のODBネットワークのARN。
  # cloud_exadata_infrastructure_idとodb_network_idの組み合わせ、
  # またはcloud_exadata_infrastructure_arnとodb_network_arnの組み合わせを使用する必要があります。
  # 変更すると新しいリソースが作成されます。
  # odb_network_arn = "arn:aws:odb:us-east-1:123456789012:odb-network/example"

  # cluster_name (オプション)
  # Grid Infrastructure (GI)クラスターの名前。
  # 変更すると新しいリソースが作成されます。
  # cluster_name = "my-cluster"

  # db_node_storage_size_in_gbs (オプション)
  # VMクラスターに割り当てるローカルノードストレージの量（ギガバイト単位）。
  # 変更すると新しいリソースが作成されます。
  # db_node_storage_size_in_gbs = 120

  # is_local_backup_enabled (オプション)
  # VMクラスターのローカルExadataストレージへのデータベースバックアップを有効にするかどうかを指定します。
  # 変更すると新しいリソースが作成されます。
  # is_local_backup_enabled = true

  # is_sparse_diskgroup_enabled (オプション)
  # VMクラスター用のスパースディスクグループを作成するかどうかを指定します。
  # 変更すると新しいリソースが作成されます。
  # is_sparse_diskgroup_enabled = true

  # license_model (オプション)
  # VMクラスターに適用するOracleライセンスモデル。
  # デフォルト: LICENSE_INCLUDED
  # 有効な値:
  #   - LICENSE_INCLUDED: ライセンス込み
  #   - BRING_YOUR_OWN_LICENSE: 既存ライセンスの持ち込み（BYOL）
  # 変更すると新しいリソースが作成されます。
  # license_model = "LICENSE_INCLUDED"

  # memory_size_in_gbs (オプション)
  # VMクラスターに割り当てるメモリの量（ギガバイト単位）。
  # 変更すると新しいリソースが作成されます。
  # memory_size_in_gbs = 60

  # scan_listener_port_tcp (オプション)
  # シングルクライアントアクセス名（SCAN）リスナーへのTCP接続のポート番号。
  # 有効な値: 1024～8999（以下を除く: 2484, 6100, 6200, 7060, 7070, 7085, 7879）
  # デフォルト: 1521
  # 変更すると新しいリソースが作成されます。
  # scan_listener_port_tcp = 1521

  # timezone (オプション)
  # VMクラスターの構成されたタイムゾーン。
  # 変更すると新しいリソースが作成されます。
  # timezone = "UTC"

  # region (オプション)
  # このリソースが管理されるリージョン。
  # デフォルトはプロバイダー設定で設定されたリージョン。
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags (オプション)
  # VMクラスターに割り当てるタグのマップ。
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたタグを上書きします。
  # 型: map(string)
  # tags = {
  #   Environment = "production"
  #   Project     = "oracle-db"
  # }

  #---------------------------------------------------------------
  # ネストブロック (Block Types)
  #---------------------------------------------------------------

  # data_collection_options (オプション)
  # VMクラスターの各種診断収集オプションの設定。
  # 変更すると新しいリソースが作成されます。
  # data_collection_options {
  #   # is_diagnostics_events_enabled (必須)
  #   # 診断イベントの収集を有効にするかどうか。
  #   is_diagnostics_events_enabled = true
  #
  #   # is_health_monitoring_enabled (必須)
  #   # ヘルスモニタリングを有効にするかどうか。
  #   is_health_monitoring_enabled = true
  #
  #   # is_incident_logs_enabled (必須)
  #   # インシデントログの収集を有効にするかどうか。
  #   is_incident_logs_enabled = true
  # }

  # timeouts (オプション)
  # 各操作のタイムアウト設定。
  # 値は "30s"、"2h45m" などの形式で指定します。
  # 有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
  # timeouts {
  #   # create (オプション)
  #   # リソース作成のタイムアウト。
  #   create = "2h"
  #
  #   # update (オプション)
  #   # リソース更新のタイムアウト。
  #   update = "2h"
  #
  #   # delete (オプション)
  #   # リソース削除のタイムアウト。
  #   delete = "2h"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# id
#   VMクラスターの一意識別子。
#
# arn
#   Cloud VMクラスターのAmazon Resource Name (ARN)。
#
# compute_model
#   インスタンス作成またはクローン時に使用されるコンピュートモデル
#   （ECPUまたはOCPU）。ECPUは仮想化されたコンピュートユニット、
#   OCPUはハイパースレッディング対応の物理プロセッサコアです。
#
# created_at
#   VMクラスターが作成されたタイムスタンプ。
#
# disk_redundancy
#   VMクラスターの冗長性タイプ: NORMAL（2ウェイ）またはHIGH（3ウェイ）。
#
# domain
#   VMクラスターに関連付けられたドメイン名。
#
# gi_version_computed
#   Oracle Grid Infrastructure (GI)の完全なソフトウェアバージョン。
#
# hostname_prefix_computed
#   VMクラスターのホスト名（計算された値）。
#
# iorm_config_cache
#   VMクラスターのExadata IORM（I/O Resource Manager）設定キャッシュの詳細。
#   構造:
#     - db_plans: データベースプランのリスト
#       - db_name: データベース名
#       - flash_cache_limit: フラッシュキャッシュ制限
#       - share: 共有値
#     - lifecycle_details: ライフサイクルの詳細
#     - lifecycle_state: ライフサイクル状態
#     - objective: 目標
#
# last_update_history_entry_id
#   最新のメンテナンス更新履歴エントリのOCID。
#
# listener_port
#   VMクラスターで構成されたリスナーポート番号。
#
# node_count
#   VMクラスター内のノードの総数。
#
# oci_resource_anchor_name
#   VMクラスターに関連付けられたOCIリソースアンカーの名前。
#
# oci_url
#   OCI内のVMクラスターリソースへのHTTPSリンク。
#
# ocid
#   VMクラスターのOCID（Oracle Cloud Identifier）。
#
# percent_progress
#   VMクラスターの現在の操作の進捗率。
#
# scan_dns_name
#   VMクラスターに関連付けられたSCAN IPアドレスの完全修飾ドメイン名（FQDN）。
#
# scan_dns_record_id
#   VMクラスターにリンクされたSCAN IPのDNSレコードのOCID。
#
# scan_ip_ids
#   VMクラスターに関連付けられたSCAN IPアドレスのOCIDのリスト。
#
# shape
#   VMクラスターを実行するExadataインフラストラクチャのハードウェアモデル名。
#
# status
#   VMクラスターの現在のライフサイクルステータス。
#
# status_reason
#   VMクラスターの現在のステータスに関する追加情報。
#
# storage_size_in_gbs
#   VMクラスターに割り当てられたローカルノードストレージ（ギガバイト単位）。
#
# system_version
#   VMクラスター用に選択されたイメージのオペレーティングシステムバージョン。
#
# tags_all
#   ユーザー定義タグとプロバイダー定義タグの組み合わせ。
#
# vip_ids
#   VMクラスターに割り当てられた仮想IP（VIP）アドレス。
#   CRSはフェイルオーバーサポート用にノードごとに1つのVIPを割り当てます。
#
#---------------------------------------------------------------
