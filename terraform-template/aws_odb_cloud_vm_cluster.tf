#---------------------------------------------------------------
# AWS ODB Cloud VM Cluster
#---------------------------------------------------------------
#
# Oracle Database@AWS の Exadata VM クラスターをプロビジョニングするリソースです。
# VM クラスターは Oracle RAC (Real Application Clusters) と Oracle Grid Infrastructure
# を含む Exadata インフラストラクチャ上の仮想マシンの集合です。
# 1 つ以上の Oracle Exadata データベースを VM クラスター上に作成できます。
# 共有インフラストラクチャを使用する場合は ARN を使用して VM クラスターを作成します。
#
# AWS公式ドキュメント:
#   - Oracle Database@AWS ユーザーガイド: https://docs.aws.amazon.com/odb/latest/UserGuide/what-is-odb.html
#   - VM クラスターの作成: https://docs.aws.amazon.com/odb/latest/APIReference/API_CreateCloudVmCluster.html
#   - Oracle Database@AWS の仕組み: https://docs.aws.amazon.com/odb/latest/UserGuide/how-it-works.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/odb_cloud_vm_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_odb_cloud_vm_cluster" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # display_name (Required, Forces new resource)
  # 設定内容: VM クラスターのユーザーフレンドリーな名前を指定します。
  # 設定可能な値: 任意の文字列
  display_name = "my-vm-cluster"

  # cpu_core_count (Required, Forces new resource)
  # 設定内容: VM クラスターで有効化する CPU コア数を指定します。
  # 設定可能な値: 正の整数。Exadata インフラストラクチャのシェイプに応じた有効な値
  cpu_core_count = 6

  # gi_version (Required, Forces new resource)
  # 設定内容: Oracle Grid Infrastructure (GI) の有効なソフトウェアバージョンを指定します。
  # 設定可能な値: ListGiVersions API を使用して Exadata インフラストラクチャのシェイプに応じた有効な値を取得
  #   例: "19.0.0.0", "23.0.0.0"
  # 参考: https://docs.aws.amazon.com/odb/latest/APIReference/API_ListGiVersions.html
  gi_version = "23.0.0.0"

  # hostname_prefix (Required, Forces new resource)
  # 設定内容: VM クラスターのホスト名プレフィックスを指定します。
  # 設定可能な値: 英数字とハイフンで構成される文字列
  #   - "localhost" または "hostname" は使用不可
  #   - "-version" を含めることは不可
  #   - ホスト名とドメインの結合は最大 63 文字
  #   - サブネット内で一意であること
  hostname_prefix = "myhost"

  # ssh_public_keys (Required, Forces new resource)
  # 設定内容: VM クラスターへの SSH アクセスに使用する 1 つ以上のキーペアの公開鍵を指定します。
  # 設定可能な値: SSH 公開鍵文字列のセット
  ssh_public_keys = ["ssh-rsa AAAA...your-public-key user@host"]

  # data_storage_size_in_tbs (Required, Forces new resource)
  # 設定内容: VM クラスターに割り当てるデータディスクグループのサイズをテラバイト (TB) で指定します。
  # 設定可能な値: 正の数値（小数可）
  data_storage_size_in_tbs = 20.0

  # db_servers (Required, Forces new resource)
  # 設定内容: VM クラスターのデータベースサーバーのリストを指定します。
  # 設定可能な値: データベースサーバー識別子の文字列セット
  # 参考: https://docs.aws.amazon.com/odb/latest/APIReference/API_ListDbServers.html
  db_servers = ["db-server-1", "db-server-2"]

  #-------------------------------------------------------------
  # インフラストラクチャ・ネットワーク設定
  #-------------------------------------------------------------

  # cloud_exadata_infrastructure_id (Optional, Forces new resource)
  # 設定内容: この VM クラスターの Exadata インフラストラクチャの一意の識別子を指定します。
  # 設定可能な値: 有効な ODB Cloud Exadata Infrastructure の ID
  # 注意: cloud_exadata_infrastructure_id と odb_network_id の組み合わせ、
  #       または cloud_exadata_infrastructure_arn と odb_network_arn の組み合わせのいずれかを使用すること。
  #       共有インフラストラクチャを使用する場合は ARN を使用すること。
  cloud_exadata_infrastructure_id = "<cloud_exadata_infrastructure_id>"

  # cloud_exadata_infrastructure_arn (Optional, Forces new resource)
  # 設定内容: この VM クラスターの Exadata インフラストラクチャの ARN を指定します。
  # 設定可能な値: 有効な ODB Cloud Exadata Infrastructure の ARN
  # 注意: cloud_exadata_infrastructure_id と odb_network_id の組み合わせ、
  #       または cloud_exadata_infrastructure_arn と odb_network_arn の組み合わせのいずれかを使用すること。
  #       共有インフラストラクチャを使用する場合は ARN を使用すること。
  cloud_exadata_infrastructure_arn = null

  # odb_network_id (Optional, Forces new resource)
  # 設定内容: VM クラスターの ODB ネットワークの一意の識別子を指定します。
  # 設定可能な値: 有効な ODB ネットワーク ID
  # 注意: cloud_exadata_infrastructure_id と odb_network_id の組み合わせ、
  #       または cloud_exadata_infrastructure_arn と odb_network_arn の組み合わせのいずれかを使用すること。
  odb_network_id = "<odb_network_id>"

  # odb_network_arn (Optional, Forces new resource)
  # 設定内容: VM クラスターの ODB ネットワークの ARN を指定します。
  # 設定可能な値: 有効な ODB ネットワーク ARN
  # 注意: cloud_exadata_infrastructure_id と odb_network_id の組み合わせ、
  #       または cloud_exadata_infrastructure_arn と odb_network_arn の組み合わせのいずれかを使用すること。
  odb_network_arn = null

  #-------------------------------------------------------------
  # クラスター名設定
  #-------------------------------------------------------------

  # cluster_name (Optional, Forces new resource)
  # 設定内容: Grid Infrastructure (GI) クラスターの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 自動的に割り当てられます。
  cluster_name = null

  #-------------------------------------------------------------
  # ストレージ・メモリ設定
  #-------------------------------------------------------------

  # db_node_storage_size_in_gbs (Optional, Forces new resource)
  # 設定内容: VM クラスターに割り当てるローカルノードストレージのサイズをギガバイト (GB) で指定します。
  # 設定可能な値: 正の数値（小数可）
  # 省略時: Exadata インフラストラクチャのデフォルト値が適用されます。
  db_node_storage_size_in_gbs = 120.0

  # memory_size_in_gbs (Optional, Forces new resource)
  # 設定内容: VM クラスターに割り当てるメモリのサイズをギガバイト (GB) で指定します。
  # 設定可能な値: 正の整数
  # 省略時: Exadata インフラストラクチャのデフォルト値が適用されます。
  memory_size_in_gbs = 60

  #-------------------------------------------------------------
  # バックアップ・ディスクグループ設定
  #-------------------------------------------------------------

  # is_local_backup_enabled (Optional, Forces new resource)
  # 設定内容: VM クラスターのローカル Exadata ストレージへのデータベースバックアップを有効にするかを指定します。
  # 設定可能な値:
  #   - true: ローカルバックアップを有効化
  #   - false: ローカルバックアップを無効化
  # 省略時: false
  is_local_backup_enabled = true

  # is_sparse_diskgroup_enabled (Optional, Forces new resource)
  # 設定内容: VM クラスターにスパースディスクグループを作成するかを指定します。
  # 設定可能な値:
  #   - true: スパースディスクグループを作成
  #   - false: スパースディスクグループを作成しない
  # 省略時: false
  is_sparse_diskgroup_enabled = false

  #-------------------------------------------------------------
  # ライセンス設定
  #-------------------------------------------------------------

  # license_model (Optional, Forces new resource)
  # 設定内容: VM クラスターに適用する Oracle ライセンスモデルを指定します。
  # 設定可能な値:
  #   - "LICENSE_INCLUDED": ライセンスを含む（デフォルト）。AWS 利用料に Oracle ライセンス料が含まれます。
  #   - "BRING_YOUR_OWN_LICENSE": 既存ライセンスを持ち込む (BYOL)。既存の Oracle ライセンスを使用します。
  # 省略時: "LICENSE_INCLUDED"
  license_model = "LICENSE_INCLUDED"

  #-------------------------------------------------------------
  # ネットワーク・リスナー設定
  #-------------------------------------------------------------

  # scan_listener_port_tcp (Optional, Forces new resource)
  # 設定内容: SCAN (Single Client Access Name) リスナーへの TCP 接続のポート番号を指定します。
  # 設定可能な値: 1024～8999 の整数。ただし以下のポートは除く: 2484, 6100, 6200, 7060, 7070, 7085, 7879
  # 省略時: 1521
  scan_listener_port_tcp = 1521

  #-------------------------------------------------------------
  # タイムゾーン設定
  #-------------------------------------------------------------

  # timezone (Optional, Forces new resource)
  # 設定内容: VM クラスターのタイムゾーンを指定します。
  # 設定可能な値: 有効な IANA タイムゾーン識別子（例: "UTC", "America/New_York", "Asia/Tokyo"）
  # 省略時: システムのデフォルトタイムゾーンが使用されます。
  timezone = "UTC"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 診断データ収集設定
  #-------------------------------------------------------------

  # data_collection_options (Required, Forces new resource)
  # 設定内容: VM クラスターの各種診断データ収集オプションの設定ブロックです。
  # 関連機能: Oracle Exadata 診断データ収集
  #   診断イベント、ヘルス監視、インシデントログの収集を制御します。
  #   - https://docs.aws.amazon.com/odb/latest/UserGuide/what-is-odb.html
  data_collection_options {

    # is_diagnostics_events_enabled (Required)
    # 設定内容: 診断イベントの収集を有効にするかを指定します。
    # 設定可能な値:
    #   - true: 診断イベントの収集を有効化
    #   - false: 診断イベントの収集を無効化
    is_diagnostics_events_enabled = true

    # is_health_monitoring_enabled (Required)
    # 設定内容: ヘルスモニタリングの収集を有効にするかを指定します。
    # 設定可能な値:
    #   - true: ヘルスモニタリングを有効化
    #   - false: ヘルスモニタリングを無効化
    is_health_monitoring_enabled = true

    # is_incident_logs_enabled (Required)
    # 設定内容: インシデントログの収集を有効にするかを指定します。
    # 設定可能な値:
    #   - true: インシデントログの収集を有効化
    #   - false: インシデントログの収集を無効化
    is_incident_logs_enabled = true
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  # 設定可能な値: "30s", "5m", "2h" 等の時間文字列（s: 秒, m: 分, h: 時間）
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 省略時: プロバイダーのデフォルト値が適用されます。
    create = "120m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 省略時: プロバイダーのデフォルト値が適用されます。
    update = "120m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 省略時: プロバイダーのデフォルト値が適用されます。
    delete = "120m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-vm-cluster"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VM クラスターの一意の識別子 / arn: ARN / ocid: OCID
# - oci_url: OCI 上のリソース HTTPS リンク / oci_resource_anchor_name: OCI リソースアンカー名
# - compute_model: コンピュートモデル (ECPU または OCPU)
# - disk_redundancy: 冗長タイプ (NORMAL: 2-way, HIGH: 3-way)
# - domain: ドメイン名 / gi_version_computed: GI の完全なバージョン
# - hostname_prefix_computed: ホスト名 / iorm_config_cache: IORM 設定キャッシュ詳細
# - last_update_history_entry_id: 最新メンテナンス更新履歴エントリの OCID
# - listener_port: リスナーポート番号 / node_count: ノード総数
# - percent_progress: 現在の操作の進捗率
# - scan_dns_name: SCAN IP アドレスの FQDN
# - scan_dns_record_id: SCAN IP の DNS レコードの OCID
# - scan_ip_ids: SCAN IP アドレスの OCID リスト
# - shape: Exadata インフラストラクチャのハードウェアモデル名
# - status: ライフサイクルステータス / status_reason: ステータスの詳細
# - storage_size_in_gbs: ローカルノードストレージ (GB)
# - system_version: OS バージョン / created_at: 作成タイムスタンプ
# - vip_ids: 仮想 IP (VIP) アドレスのリスト
# - tags_all: プロバイダーの default_tags から継承されたタグを含む全タグマップ
#---------------------------------------------------------------
