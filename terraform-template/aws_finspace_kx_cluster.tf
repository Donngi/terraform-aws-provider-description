#---------------------------------------------------------------
# Amazon FinSpace Kx Cluster
#---------------------------------------------------------------
#
# Amazon FinSpace Managed kdb Insights クラスターをプロビジョニングする。
# kdbプロセスを実行するコンピュートリソースのセットで、資本市場データの
# プライベートデータ処理・分析ハブを構築できる。リアルタイムおよび
# 履歴データへのアクセスと高性能分析を提供する。
#
# 重要: Amazon FinSpaceは2026年10月7日にサポート終了予定。
#       2025年10月7日以降は新規顧客の受け入れを停止。
#
# クラスタータイプ:
#   - HDB (Historical Database): 履歴データベース。読み取り専用。
#   - RDB (Realtime Database): リアルタイムデータベース。savedownストレージが必要。
#   - GATEWAY: プロセス間のデータアクセスを可能にするゲートウェイ。
#   - GP (General Purpose): 開発用の汎用クラスター。ノード数は1固定。
#   - Tickerplant: フィードハンドラーからのサブスクリプション。単一ノードのみ。
#
# AWS公式ドキュメント:
#   - Managed kdb Insights clusters: https://docs.aws.amazon.com/finspace/latest/userguide/finspace-managed-kdb-clusters.html
#   - Cluster types: https://docs.aws.amazon.com/finspace/latest/userguide/kdb-cluster-types.html
#   - API Reference: https://docs.aws.amazon.com/finspace/latest/management-api/API_CreateKxCluster.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/finspace_kx_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_finspace_kx_cluster" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # クラスターの一意の名前
  name = "my-kx-cluster"

  # FinSpace Kx環境の一意の識別子
  # aws_finspace_kx_environment リソースのIDを参照
  environment_id = "example-environment-id"

  # クラスターのタイプ
  # 指定可能な値:
  #   - HDB: 履歴データベース。読み取り専用アクセス。マウントされたデータベースからのみデータにアクセス可能。
  #   - RDB: リアルタイムデータベース。メモリにデータを保持し、日次でHDBにsavedown。savedown_storage_configurationが必須。
  #   - GATEWAY: kdbシステム内のプロセス間データアクセスを可能にする。書き込み可能なローカルストレージ不要。
  #   - GP: 汎用クラスター。開発時の高速イテレーション用。ノード数は1固定。オートスケーリング非対応。SINGLE AZモードのみ。
  #   - Tickerplant: IAM権限に基づくフィードハンドラーへのサブスクリプション。RDB、他のTickerplant、RTSへのパブリッシュ。単一ノードのみ。
  type = "HDB"

  # FinSpace Managed kdbのバージョン
  # 例: "1.0"
  release_label = "1.0"

  # クラスターに割り当てる可用性ゾーン数
  # 指定可能な値:
  #   - SINGLE: クラスターごとに1つのAZを割り当て
  #   - MULTI: クラスターごとにすべてのAZを割り当て
  az_mode = "SINGLE"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # 可用性ゾーンの識別子（az_mode = "SINGLE"の場合に必須）
  # 例: "use1-az2", "apne1-az1"
  availability_zone_id = "use1-az2"

  # クラスターの説明
  description = "Example FinSpace Kx Cluster for historical data analysis"

  # クラスターが別のクラスターにアクセスする際に引き受けるIAMロールのARN
  # クラスター間アクセスに必要な権限セットを定義
  execution_role = "arn:aws:iam::123456789012:role/finspace-cluster-execution-role"

  # クラスター起動時に実行されるQプログラムへのパス
  # カスタムコードを含む.zipファイル内の相対パス。ファイル名自体を含む必要がある。
  # 例: "somedir/init.q"
  initialization_script = "scripts/init.q"

  # クラスター内で利用可能にするキーバリューペアのリスト
  # kdb環境変数として設定される
  command_line_arguments = {
    "ENV_VAR_1" = "value1"
    "ENV_VAR_2" = "value2"
  }

  # リソースタグ
  # プロバイダーのdefault_tagsと統合される
  tags = {
    Name        = "example-kx-cluster"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # リージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用される
  # 通常はプロバイダーレベルで設定するため、明示的な指定は不要
  # region = "us-east-1"

  #---------------------------------------------------------------
  # 必須ブロック: capacity_configuration
  #---------------------------------------------------------------
  # クラスターのメタデータ構造
  # 必要なCPU、インスタンスメモリ、インスタンス数などの情報を含む
  capacity_configuration {
    # ホストコンピューターのハードウェアを決定するノードタイプ
    # 各ノードタイプは異なるメモリとストレージ容量を提供
    # 指定可能な値:
    #   - kx.s.large: 12 GiBメモリ、2 vCPU
    #   - kx.s.xlarge: 27 GiBメモリ、4 vCPU
    #   - kx.s.2xlarge: 54 GiBメモリ、8 vCPU
    #   - kx.s.4xlarge: 108 GiBメモリ、16 vCPU
    #   - kx.s.8xlarge: 216 GiBメモリ、32 vCPU
    #   - kx.s.16xlarge: 432 GiBメモリ、64 vCPU
    #   - kx.s.32xlarge: 864 GiBメモリ、128 vCPU
    node_type = "kx.s.2xlarge"

    # クラスター内で実行されるインスタンス数
    # 最小1、最大5
    node_count = 2
  }

  #---------------------------------------------------------------
  # 必須ブロック: vpc_configuration
  #---------------------------------------------------------------
  # クラスターのPrivateLinkエンドポイントが存在するネットワークの設定詳細
  vpc_configuration {
    # VPCエンドポイントの識別子
    vpc_id = "vpc-12345678"

    # VPCエンドポイントENIに適用されるセキュリティグループの一意の識別子
    security_group_ids = ["sg-12345678"]

    # クラスターネットワーク設定のIPアドレスタイプ
    # 指定可能な値: "IP_V4" (IPアドレスバージョン4)
    ip_address_type = "IP_V4"

    # サブネットIDのリスト
    # クラスターがデプロイされるサブネット
    subnet_ids = ["subnet-12345678"]
  }

  #---------------------------------------------------------------
  # オプションブロック: auto_scaling_configuration
  #---------------------------------------------------------------
  # FinSpaceがクラスター内のノードをスケールイン/スケールアウトする際の設定
  # HDBクラスターのみサポート。スケーリンググループでは利用不可（専用クラスターのみ）。
  # CPU使用率に基づいて自動的にノード数を調整。
  # auto_scaling_configuration {
  #   # スケールイン/スケールアウトのために追跡するメトリック
  #   # 例: CPU_UTILIZATION_PERCENTAGE（クラスター内全ノードの平均CPU使用率）
  #   auto_scaling_metric = "CPU_UTILIZATION_PERCENTAGE"
  #
  #   # スケール可能な最小ノード数
  #   # 最小1、max_node_count未満である必要がある
  #   # クラスター内のノードが複数のAZに属する場合、最小3である必要がある
  #   min_node_count = 2
  #
  #   # スケール可能な最大ノード数
  #   # 5を超えることはできない
  #   max_node_count = 5
  #
  #   # 選択したauto_scaling_metricの目標値（パーセンテージ）
  #   # メトリックがこの値を下回るとスケールイン、上回るとスケールアウト
  #   # 0〜100の範囲で設定可能
  #   metric_target = 70
  #
  #   # スケールインイベント後、次のスケーリングイベントを開始するまでの待機時間（秒）
  #   scale_in_cooldown_seconds = 300
  #
  #   # スケールアウトイベント後、次のスケーリングイベントを開始するまでの待機時間（秒）
  #   scale_out_cooldown_seconds = 60
  # }

  #---------------------------------------------------------------
  # オプションブロック: cache_storage_configurations
  #---------------------------------------------------------------
  # クラスターに関連付けられた読み取り専用キャッシュストレージの設定
  # FSx Lustreとして保存され、S3ストアから読み取る
  # 複数のキャッシュストレージ設定を指定可能
  # 専用クラスターのみサポート。スケーリンググループではdataviewsを使用。
  # cache_storage_configurations {
  #   # ディスクキャッシュのタイプ
  #   # 指定可能な値:
  #   #   - CACHE_1000: 1000 MB/s のディスクアクセススループット
  #   #   - CACHE_250: 250 MB/s のディスクアクセススループット
  #   #   - CACHE_12: 12 MB/s のディスクアクセススループット
  #   type = "CACHE_1000"
  #
  #   # キャッシュのサイズ（ギガバイト）
  #   # キャッシュされるデータ量に応じて、create/updateタイムアウトの調整が必要な場合がある（最大18時間）
  #   size = 1200
  # }

  #---------------------------------------------------------------
  # オプションブロック: code
  #---------------------------------------------------------------
  # データ分析時にクラスター内で使用するカスタムコードの詳細
  # S3ソースバケット、場所、オブジェクトバージョン、クラスターに読み込まれる相対パスで構成
  # code {
  #   # S3バケットの一意の名前
  #   s3_bucket = "my-finspace-code-bucket"
  #
  #   # クラスター起動時に読み込まれるコードを含む.zipファイルへのフルS3パス（バケット名を除く）
  #   s3_key = "code/cluster-code.zip"
  #
  #   # S3オブジェクトのバージョン
  #   # バージョニングが有効な場合、特定のバージョンを指定可能
  #   s3_object_version = "v1.0.0"
  # }

  #---------------------------------------------------------------
  # オプションブロック: database
  #---------------------------------------------------------------
  # クエリに利用可能なKXデータベース
  # 複数のデータベースを指定可能
  # HDBおよびGPクラスタータイプで使用
  # database {
  #   # KXデータベースの名前
  #   database_name = "my-kx-database"
  #
  #   # クラスターに関連付けられたchangesetの一意の識別子
  #   changeset_id = "changeset-123"
  #
  #   # ディスク上の履歴データをキャッシュするために使用されるデータビューの名前
  #   # クラスター作成後は別のデータビュー名に更新できない
  #   # 意図しない動作を防ぐため、lifecycle ignore_changesの使用を推奨
  #   dataview_name = "my-dataview"
  #
  #   # ディスクキャッシュの設定（オプション）
  #   # マウントされたKXデータベースからの読み取りパフォーマンスを向上させる
  #   cache_configurations {
  #     # ディスクキャッシュのタイプ
  #     # CACHE_1000, CACHE_250, CACHE_12のいずれか
  #     cache_type = "CACHE_1000"
  #
  #     # キャッシュするデータベース内のパス
  #     # 複数のパスを指定可能
  #     db_paths = ["/"]
  #   }
  # }

  #---------------------------------------------------------------
  # オプションブロック: savedown_storage_configuration
  #---------------------------------------------------------------
  # savedownプロセス中にデータを一時的に保持するために使用される
  # 書き込み可能なストレージスペースのサイズとタイプ
  # type = "RDB" を選択した場合に必須
  # このストレージスペースに書き込まれたすべてのデータは、クラスターノードの再起動時に失われる
  # savedown_storage_configuration {
  #   # 書き込み可能なストレージスペースのタイプ
  #   # 指定可能な値:
  #   #   - SDS01: 3000 IOPSおよびio2 EBSボリュームタイプを表す
  #   type = "SDS01"
  #
  #   # 一時ストレージのサイズ（ギガバイト）
  #   # 10〜16000の範囲で指定
  #   size = 100
  #
  #   # 書き込み可能なsavedownストレージとして使用するkdbボリュームの名前
  #   volume_name = "my-savedown-volume"
  # }

  #---------------------------------------------------------------
  # オプションブロック: scaling_group_configuration
  #---------------------------------------------------------------
  # スケーリンググループの設定詳細を保存する構造
  # クラスターをスケーリンググループ上で実行する場合に使用
  # scaling_group_configuration {
  #   # kdbスケーリンググループの一意の識別子
  #   scaling_group_name = "my-scaling-group"
  #
  #   # スケーリンググループホスト上でこのkdbクラスターの各ノードに予約する最小メモリ量
  #   # MB単位で指定
  #   memory_reservation = 100000
  #
  #   # kdbクラスターノードの数
  #   node_count = 2
  #
  #   # スケーリンググループホスト上でこのkdbクラスターの各ノードに予約するvCPU数（オプション）
  #   cpu = 8
  #
  #   # kdbクラスターが使用できるメモリ量のオプションのハードリミット
  #   # MB単位で指定
  #   memory_limit = 150000
  # }

  #---------------------------------------------------------------
  # オプションブロック: tickerplant_log_configuration
  #---------------------------------------------------------------
  # Tickerplantログを保存するための設定
  # クラスタータイプがTickerplantの場合、クラスター上のTPボリュームの場所は
  # グローバル変数 .aws.tp_log_path を使用して利用可能
  # tickerplant_log_configuration {
  #   # クラスターにマウントされるボリュームのリスト
  #   # TickerplantログをTerraform管理するボリュームに保存
  #   tickerplant_log_volumes = ["volume-1", "volume-2"]
  # }

  #---------------------------------------------------------------
  # オプションブロック: timeouts
  #---------------------------------------------------------------
  # リソースの作成、更新、削除のタイムアウト設定
  # キャッシュされるデータ量に応じて、create/updateタイムアウトを
  # デフォルトの4時間から最大18時間まで調整する必要がある場合がある
  timeouts {
    # 作成タイムアウト（デフォルト: 4h）
    create = "18h"

    # 更新タイムアウト（デフォルト: 4h）
    update = "18h"

    # 削除タイムアウト（デフォルト: 1h）
    delete = "1h"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only、設定不可）:
#
# - arn: KXクラスターのAmazon Resource Name (ARN)識別子
# - created_timestamp: FinSpaceでクラスターが作成されたタイムスタンプ
#   エポック時間（秒）で表現。例: 2021年11月1日12:00:00 PM UTC = 1635768000
# - id: 環境IDとクラスター名をカンマで区切った文字列
# - last_modified_timestamp: FinSpaceでクラスターが最後に更新されたタイムスタンプ
#   エポック時間（秒）で表現。例: 2021年11月1日12:00:00 PM UTC = 1635768000
# - status: クラスターのステータス（例: CREATING, ACTIVE, DELETING, DELETED）
# - status_reason: ステータスの理由を示す文字列
# - tags_all: リソースに割り当てられたタグのマップ
#   プロバイダーのdefault_tagsから継承されたものを含む
#
#---------------------------------------------------------------
