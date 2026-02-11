#---------------------------------------------------------------
# AWS MemoryDB Cluster
#---------------------------------------------------------------
#
# Amazon MemoryDB for Redisのクラスタをプロビジョニングするリソースです。
# MemoryDBクラスタは、単一のデータセットを提供する1つ以上のノードの集合であり、
# シャードに分割されたデータを管理します。各シャードはプライマリノードと
# 最大5つのレプリカノードで構成され、高可用性とスケーラビリティを提供します。
#
# AWS公式ドキュメント:
#   - MemoryDB概要: https://docs.aws.amazon.com/memorydb/latest/devguide/what-is-memorydb-for-redis.html
#   - MemoryDBコンポーネント: https://docs.aws.amazon.com/memorydb/latest/devguide/components.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/memorydb_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_memorydb_cluster" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: クラスタの名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  name = "my-cluster"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: クラスタ名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # acl_name (Required)
  # 設定内容: クラスタに関連付けるアクセスコントロールリスト（ACL）の名前を指定します。
  # 設定可能な値: 有効なACL名（例: "open-access"）
  # 関連機能: MemoryDB Access Control Lists (ACLs)
  #   ACLはユーザーのコレクションであり、アクセス文字列を使用してValkey/Redis OSS
  #   コマンドとデータへのアクセスを認可します。
  #   - https://docs.aws.amazon.com/memorydb/latest/devguide/clusters.acls.html
  acl_name = "open-access"

  # node_type (Required)
  # 設定内容: クラスタ内のノードのコンピュートおよびメモリ容量を指定します。
  # 設定可能な値: サポートされているノードタイプ（例: db.t4g.small, db.r7g.large）
  # 関連機能: MemoryDB ノードタイプ
  #   クラスタのコンピューティングとメモリ容量を決定します。
  #   ニーズに応じて異なるノードタイプを選択でき、後から変更も可能です。
  #   - https://docs.aws.amazon.com/memorydb/latest/devguide/nodes.supportedtypes.html
  # 参考: 垂直スケーリング
  #   - https://docs.aws.amazon.com/memorydb/latest/devguide/cluster-vertical-scaling.html
  node_type = "db.t4g.small"

  #-------------------------------------------------------------
  # エンジン設定
  #-------------------------------------------------------------

  # engine (Optional)
  # 設定内容: ノード上で実行されるエンジンを指定します。
  # 設定可能な値:
  #   - "redis": Redis OSS エンジン
  #   - "valkey": Valkey エンジン
  # 省略時: デフォルトのエンジンが使用されます。
  engine = "redis"

  # engine_version (Optional)
  # 設定内容: クラスタに使用するエンジンのバージョン番号を指定します。
  # 設定可能な値: サポートされているエンジンバージョン（例: "7.1", "7.0", "6.2"）
  # 省略時: デフォルトのバージョンが使用されます。
  # 注意: ダウングレードはサポートされていません。
  # 関連機能: MemoryDB エンジンバージョン
  #   各エンジンバージョンには独自のサポート機能とパラメータがあります。
  #   バージョン7.1以降ではベクトル検索機能が追加されています。
  #   - https://docs.aws.amazon.com/memorydb/latest/devguide/engine-versions.html
  engine_version = "7.1"

  # auto_minor_version_upgrade (Optional, Forces new resource)
  # 設定内容: クラスタの起動後にマイナーエンジンバージョンのアップグレードを
  #           自動的に受信するかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 自動アップグレードを有効化
  #   - false: 自動アップグレードを無効化
  auto_minor_version_upgrade = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # クラスタ構成設定
  #-------------------------------------------------------------

  # num_shards (Optional)
  # 設定内容: クラスタ内のシャード数を指定します。
  # 設定可能な値: 1～500の整数
  # 省略時: 1（シングルシャード構成）
  # 関連機能: MemoryDB シャーディング
  #   シャードは1～6個のノードのグループで、1つがプライマリ書き込みノード、
  #   残りが読み取りレプリカとして機能します。クラスタは最大500シャードまで
  #   サポートします。
  #   - https://docs.aws.amazon.com/memorydb/latest/devguide/shards.html
  num_shards = 2

  # num_replicas_per_shard (Optional)
  # 設定内容: 各シャードに適用するレプリカの数を指定します。
  # 設定可能な値: 0～5の整数
  # 省略時: 1（つまり各シャードに2つのノード）
  # 関連機能: MemoryDB レプリケーション
  #   各シャードはプライマリノードと最大5つのレプリカノードで構成されます。
  #   レプリカはフェイルオーバー時にプライマリに昇格できます。
  #   - https://docs.aws.amazon.com/memorydb/latest/devguide/replication.html
  num_replicas_per_shard = 1

  # data_tiering (Optional, Forces new resource)
  # 設定内容: データ階層化を有効にするかを指定します。
  # 設定可能な値:
  #   - true: データ階層化を有効化
  #   - false: データ階層化を無効化
  # 注意: このオプションは一部のインスタンスタイプでサポートされていません。
  # 関連機能: MemoryDB データ階層化
  #   データをメモリとSSD間で自動的に移動させることでコストを最適化します。
  #   - https://docs.aws.amazon.com/memorydb/latest/devguide/data-tiering.html
  data_tiering = false

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # subnet_group_name (Optional, Forces new resource)
  # 設定内容: クラスタに使用するサブネットグループの名前を指定します。
  # 設定可能な値: 有効なサブネットグループ名
  # 省略時: デフォルトVPCのサブネットで構成されるサブネットグループ
  # 関連機能: MemoryDB サブネットグループ
  #   サブネットグループはVPC環境で実行されるクラスタに指定するサブネットの
  #   コレクション（通常はプライベート）です。
  #   - https://docs.aws.amazon.com/memorydb/latest/devguide/subnetgroups.html
  subnet_group_name = null

  # security_group_ids (Optional)
  # 設定内容: このクラスタに関連付けるVPCセキュリティグループIDのセットを指定します。
  # 設定可能な値: セキュリティグループIDのリスト
  security_group_ids = []

  # port (Optional, Forces new resource)
  # 設定内容: 各ノードが接続を受け付けるポート番号を指定します。
  # 設定可能な値: 有効なポート番号
  # 省略時: 6379（Redisのデフォルトポート）
  port = 6379

  # tls_enabled (Optional, Forces new resource)
  # 設定内容: クラスタの転送中暗号化を有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): TLS暗号化を有効化
  #   - false: TLS暗号化を無効化
  # 注意: falseに設定する場合、acl_nameは"open-access"である必要があります。
  tls_enabled = true

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_arn (Optional, Forces new resource)
  # 設定内容: クラスタの保存時暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 関連機能: MemoryDB 保存時暗号化
  #   AWS KMS CMKを使用してクラスタデータを暗号化します。
  kms_key_arn = null

  #-------------------------------------------------------------
  # パラメータグループ設定
  #-------------------------------------------------------------

  # parameter_group_name (Optional)
  # 設定内容: クラスタに関連付けるパラメータグループの名前を指定します。
  # 設定可能な値: 有効なパラメータグループ名
  # 省略時: デフォルトのパラメータグループが使用されます。
  # 関連機能: MemoryDB パラメータグループ
  #   パラメータグループはクラスタ上のエンジンのランタイム設定を管理する
  #   簡単な方法です。パラメータはメモリ使用量、アイテムサイズなどを制御します。
  #   - https://docs.aws.amazon.com/memorydb/latest/devguide/parametergroups.html
  parameter_group_name = null

  #-------------------------------------------------------------
  # メンテナンス設定
  #-------------------------------------------------------------

  # maintenance_window (Optional)
  # 設定内容: クラスタのメンテナンスを実行する週単位の時間範囲を指定します。
  # 設定可能な値: ddd:hh24:mi-ddd:hh24:mi形式の範囲（24時間制UTC）
  #              最小メンテナンスウィンドウは60分間
  # 省略時: 自動的に割り当てられます。
  # 例: "sun:23:00-mon:01:30"
  # 注意: 低使用時間帯にメンテナンスウィンドウを設定することを推奨
  maintenance_window = "sun:23:00-mon:01:30"

  #-------------------------------------------------------------
  # スナップショット設定
  #-------------------------------------------------------------

  # snapshot_retention_limit (Optional)
  # 設定内容: MemoryDBが自動スナップショットを削除するまでの保持日数を指定します。
  # 設定可能な値: 0～35の整数
  # 省略時: 0（自動バックアップが無効）
  # 注意: 0に設定すると自動バックアップが無効になります。
  # 関連機能: MemoryDB スナップショット
  #   MemoryDBはクラスタの自動および手動スナップショットをサポートします。
  snapshot_retention_limit = 7

  # snapshot_window (Optional)
  # 設定内容: MemoryDBがシャードの日次スナップショットを開始する時間範囲（UTC）を指定します。
  # 設定可能な値: hh24:mi-hh24:mi形式（例: "05:00-09:00"）
  # 省略時: 自動的に割り当てられます。
  snapshot_window = "05:00-09:00"

  # snapshot_name (Optional, Forces new resource)
  # 設定内容: 新しいクラスタにデータを復元するスナップショットの名前を指定します。
  # 設定可能な値: 有効なスナップショット名
  # 注意: 新規クラスタ作成時にスナップショットからデータを復元する場合に使用
  snapshot_name = null

  # snapshot_arns (Optional, Forces new resource)
  # 設定内容: S3に保存されているRDBスナップショットファイルを一意に識別するARNのリストを指定します。
  # 設定可能な値: スナップショットARNのリスト
  # 注意: ARN内のオブジェクト名にカンマを含めることはできません。
  #      スナップショットファイルは新しいクラスタにデータを入力するために使用されます。
  snapshot_arns = []

  # final_snapshot_name (Optional)
  # 設定内容: このリソースが削除される際に作成される最終クラスタスナップショットの名前を指定します。
  # 設定可能な値: スナップショット名として有効な文字列
  # 省略時: 最終スナップショットは作成されません。
  # 用途: クラスタ削除前にデータのバックアップを保持したい場合に使用
  final_snapshot_name = null

  #-------------------------------------------------------------
  # 通知設定
  #-------------------------------------------------------------

  # sns_topic_arn (Optional)
  # 設定内容: クラスタ通知の送信先となるSNSトピックのARNを指定します。
  # 設定可能な値: 有効なSNSトピックARN
  # 関連機能: MemoryDB イベント通知
  #   クラスタイベント（フェイルオーバー、メンテナンスなど）の通知を
  #   SNSトピック経由で受信できます。
  sns_topic_arn = null

  #-------------------------------------------------------------
  # マルチリージョン設定
  #-------------------------------------------------------------

  # multi_region_cluster_name (Optional)
  # 設定内容: aws_memorydb_multi_region_clusterで指定されたマルチリージョン
  #           クラスタ識別子を指定します。
  # 設定可能な値: 有効なマルチリージョンクラスタ名
  # 関連機能: MemoryDB マルチリージョンクラスタ
  #   マルチリージョンアプリケーションの高可用性と低レイテンシを実現します。
  #   - https://docs.aws.amazon.com/memorydb/latest/devguide/engine-versions.html
  multi_region_cluster_name = null

  #-------------------------------------------------------------
  # 説明・メタデータ設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: クラスタの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: "Managed by Terraform"
  description = "My MemoryDB cluster"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-memorydb-cluster"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: クラスタ作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "2h"）
    create = null

    # update (Optional)
    # 設定内容: クラスタ更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "2h"）
    update = null

    # delete (Optional)
    # 設定内容: クラスタ削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "2h"）
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: nameと同じ値
#
# - arn: クラスタのAmazon Resource Name (ARN)
#
# - cluster_endpoint: クラスタ構成エンドポイント
#   - address: クラスタ構成エンドポイントのDNSホスト名
#   - port: クラスタ構成エンドポイントがリッスンしているポート番号
#
# - engine_patch_version: クラスタが使用しているエンジンのパッチバージョン番号
#
# - shards: このクラスタ内のシャードのセット
#   - name: このシャードの名前
#   - num_nodes: このシャード内の個別ノード数
#   - slots: このシャードのキースペース（例: "0-16383"）
#   - nodes: このシャード内のノードのセット
#     - availability_zone: ノードが存在するアベイラビリティゾーン
#     - create_time: ノードが作成された日時（例: "2022-01-01T21:00:00Z"）
#     - name: このノードの名前
#     - endpoint:
#       - address: ノードのDNSホスト名
#---------------------------------------------------------------
