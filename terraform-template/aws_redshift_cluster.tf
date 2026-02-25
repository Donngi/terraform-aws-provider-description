#---------------------------------------------------------------
# Amazon Redshift Cluster
#---------------------------------------------------------------
#
# Amazon Redshiftのプロビジョニングされたクラスターをプロビジョニングするリソースです。
# Redshiftはリーダーノードと1つ以上のコンピュートノードで構成される
# 大規模並列処理（MPP）データウェアハウスサービスです。
# RA3インスタンスではコンピュートとストレージを独立してスケールできます。
#
# AWS公式ドキュメント:
#   - プロビジョニングされたクラスター概要: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-clusters.html
#   - クラスターの作成: https://docs.aws.amazon.com/redshift/latest/mgmt/create-cluster.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_cluster" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # cluster_identifier (Required)
  # 設定内容: クラスターの一意な識別子を指定します。
  # 設定可能な値: 小文字の英数字およびハイフンで構成された文字列
  # 注意: 必ず小文字で指定してください。
  cluster_identifier = "tf-redshift-cluster"

  # node_type (Required)
  # 設定内容: クラスターにプロビジョニングするノードタイプを指定します。
  # 設定可能な値:
  #   - "ra3.xlplus": RA3ノード（2 vCPU、16 GiB RAM、マネージドストレージ）
  #   - "ra3.4xlarge": RA3ノード（12 vCPU、96 GiB RAM、マネージドストレージ）
  #   - "ra3.16xlarge": RA3ノード（48 vCPU、384 GiB RAM、マネージドストレージ）
  #   - "dc2.large": DC2ノード（2 vCPU、15 GiB RAM、160 GB SSD）
  #   - "dc2.8xlarge": DC2ノード（32 vCPU、244 GiB RAM、2560 GB SSD）
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-clusters.html
  node_type = "dc2.large"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # クラスター構成設定
  #-------------------------------------------------------------

  # cluster_type (Optional)
  # 設定内容: クラスタータイプを指定します。
  # 設定可能な値:
  #   - "single-node": シングルノードクラスター
  #   - "multi-node": マルチノードクラスター（number_of_nodesが必須）
  # 省略時: AWSが自動で決定
  cluster_type = "single-node"

  # number_of_nodes (Optional)
  # 設定内容: クラスターのコンピュートノード数を指定します。
  # 設定可能な値: 1以上の整数
  # 省略時: 1
  # 注意: cluster_type が "multi-node" の場合は必須です。
  number_of_nodes = 1

  # cluster_version (Optional)
  # 設定内容: クラスターに展開するAmazon Redshiftエンジンのバージョンを指定します。
  # 設定可能な値: 有効なRedshiftエンジンバージョン文字列
  # 省略時: AWSが最新の安定バージョンを使用
  cluster_version = null

  # allow_version_upgrade (Optional)
  # 設定内容: メンテナンスウィンドウ中にRedshiftエンジンのメジャーバージョンアップグレードを
  #           許可するかを指定します。
  # 設定可能な値:
  #   - true: メジャーバージョンアップグレードを許可
  #   - false: メジャーバージョンアップグレードを禁止
  # 省略時: true
  allow_version_upgrade = true

  # apply_immediately (Optional)
  # 設定内容: クラスターの変更を即時に適用するか、次のメンテナンスウィンドウまで待機するかを指定します。
  # 設定可能な値:
  #   - true: 即時適用
  #   - false: 次のメンテナンスウィンドウで適用
  # 省略時: false
  apply_immediately = false

  # maintenance_track_name (Optional)
  # 設定内容: 復元されたクラスターのメンテナンストラック名を指定します。
  # 設定可能な値:
  #   - "current": 現在のトラック（最新リリース）
  #   - "trailing": 直前のトラック
  # 省略時: "current"
  maintenance_track_name = "current"

  #-------------------------------------------------------------
  # データベース設定
  #-------------------------------------------------------------

  # database_name (Optional)
  # 設定内容: クラスター作成時に最初に作成するデータベース名を指定します。
  # 設定可能な値: 英小文字、数字、アンダースコアで構成された文字列
  # 省略時: AWSが "dev" というデフォルトデータベースを作成します。
  database_name = "mydb"

  # master_username (Optional)
  # 設定内容: マスターDBユーザーのユーザー名を指定します。
  # 設定可能な値: 英字で始まる英数字とアンダースコアで構成された文字列
  # 注意: snapshot_identifierを指定する場合を除き必須です。
  master_username = "admin"

  # master_password (Optional)
  # 設定内容: マスターDBユーザーのパスワードを指定します。
  # 設定可能な値: 8文字以上で大文字・小文字・数字をそれぞれ1文字以上含む文字列
  # 省略時: manage_master_password=trueまたはmaster_password_woを使用する場合は不要
  # 注意: manage_master_password および master_password_wo と排他的。
  #       パスワードはstateファイルに平文で保存されます。
  master_password = null

  # master_password_wo (Optional, Write-Only)
  # 設定内容: マスターDBユーザーのWrite-Only専用パスワードを指定します。
  #           Terraform 1.11.0以降で使用可能なWrite-Only引数です。
  # 設定可能な値: 8文字以上で大文字・小文字・数字をそれぞれ1文字以上含む文字列
  # 省略時: manage_master_password=trueまたはmaster_passwordを使用する場合は不要
  # 注意: manage_master_password および master_password と排他的。
  master_password_wo = null

  # master_password_wo_version (Optional)
  # 設定内容: master_password_wo の更新をトリガーするバージョン番号を指定します。
  #           master_password_wo を変更する際にこの値をインクリメントすることで更新が適用されます。
  # 設定可能な値: 整数
  # 省略時: null
  master_password_wo_version = null

  # manage_master_password (Optional)
  # 設定内容: AWS Secrets Managerを使用してクラスターの管理者認証情報を管理するかを指定します。
  # 設定可能な値:
  #   - true: Secrets Managerで認証情報を管理
  #   - false: 手動でパスワードを管理
  # 省略時: false
  # 注意: master_password および master_password_wo と排他的。
  manage_master_password = false

  # master_password_secret_kms_key_id (Optional)
  # 設定内容: クラスター管理者認証情報のシークレットを暗号化するKMSキーのIDを指定します。
  # 設定可能な値: 有効なKMSキーID
  # 省略時: AWSが管理するキーを使用
  master_password_secret_kms_key_id = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # cluster_subnet_group_name (Optional)
  # 設定内容: クラスターに関連付けるサブネットグループ名を指定します。
  # 設定可能な値: 有効なRedshiftサブネットグループ名
  # 省略時: クラスターはVPC外にデプロイされます。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-cluster-subnet-groups.html
  cluster_subnet_group_name = null

  # vpc_security_group_ids (Optional)
  # 設定内容: クラスターに関連付けるVPCセキュリティグループIDのリストを指定します。
  # 設定可能な値: 有効なVPCセキュリティグループIDのセット
  # 省略時: AWSがデフォルトのVPCセキュリティグループを使用
  vpc_security_group_ids = ["sg-12345678"]

  # availability_zone (Optional)
  # 設定内容: クラスターをプロビジョニングするAZを指定します。
  # 設定可能な値: 有効なAZコード（例: ap-northeast-1a）
  # 省略時: AWSが自動で選択
  # 注意: availability_zone_relocation_enabled が true の場合のみ変更可能です。
  availability_zone = null

  # availability_zone_relocation_enabled (Optional)
  # 設定内容: クラスターを別のAZに再配置できるようにするかを指定します。
  # 設定可能な値:
  #   - true: AZ再配置を有効化
  #   - false: AZ再配置を無効化
  # 省略時: false
  # 注意: RA3インスタンスファミリーのクラスターでのみ利用可能です。
  availability_zone_relocation_enabled = false

  # enhanced_vpc_routing (Optional)
  # 設定内容: 拡張VPCルーティングを有効にするかを指定します。
  # 設定可能な値:
  #   - true: 拡張VPCルーティングを有効化（クラスターとデータリポジトリ間のトラフィックをVPC経由に強制）
  #   - false: 拡張VPCルーティングを無効化
  # 省略時: AWSが自動で決定
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/enhanced-vpc-routing.html
  enhanced_vpc_routing = false

  # publicly_accessible (Optional)
  # 設定内容: クラスターをパブリックネットワークからアクセス可能にするかを指定します。
  # 設定可能な値:
  #   - true: パブリックアクセスを有効化
  #   - false: パブリックアクセスを無効化
  # 省略時: false
  publicly_accessible = false

  # elastic_ip (Optional)
  # 設定内容: クラスターに割り当てるElastic IP (EIP)アドレスを指定します。
  # 設定可能な値: 有効なElastic IPアドレス
  # 省略時: EIPを使用しない
  # 注意: publicly_accessible が true の場合のみ有効です。
  elastic_ip = null

  # port (Optional)
  # 設定内容: クラスターが受信接続を受け付けるポート番号を指定します。
  # 設定可能な値: 1115〜65535 の整数
  # 省略時: 5439
  port = 5439

  # multi_az (Optional)
  # 設定内容: Redshiftクラスターをマルチ AZ 構成にするかを指定します。
  # 設定可能な値:
  #   - true: マルチAZ構成を有効化
  #   - false: シングルAZ構成
  # 省略時: false
  multi_az = false

  #-------------------------------------------------------------
  # パラメーターグループ・メンテナンス設定
  #-------------------------------------------------------------

  # cluster_parameter_group_name (Optional)
  # 設定内容: クラスターに関連付けるパラメーターグループ名を指定します。
  # 設定可能な値: 有効なRedshiftパラメーターグループ名
  # 省略時: AWSがデフォルトのパラメーターグループを使用
  cluster_parameter_group_name = null

  # preferred_maintenance_window (Optional)
  # 設定内容: 自動クラスターメンテナンスを実行する週次時間帯（UTC）を指定します。
  # 設定可能な値: "ddd:hh24:mi-ddd:hh24:mi" 形式の文字列（例: "sun:05:00-sun:09:00"）
  # 省略時: AWSがデフォルトのメンテナンスウィンドウを割り当て
  preferred_maintenance_window = "sun:05:00-sun:09:00"

  #-------------------------------------------------------------
  # スナップショット・バックアップ設定
  #-------------------------------------------------------------

  # automated_snapshot_retention_period (Optional)
  # 設定内容: 自動スナップショットを保持する日数を指定します。
  # 設定可能な値: 0〜35 の整数（0 で自動スナップショットを無効化）
  # 省略時: 1
  automated_snapshot_retention_period = 1

  # manual_snapshot_retention_period (Optional)
  # 設定内容: 手動スナップショットのデフォルト保持日数を指定します。
  # 設定可能な値: -1（無期限）または 1〜3653 の整数
  # 省略時: -1
  # 注意: この設定は既存スナップショットの保持期間には影響しません。
  manual_snapshot_retention_period = -1

  # skip_final_snapshot (Optional)
  # 設定内容: クラスター削除前に最終スナップショットを作成しないかを指定します。
  # 設定可能な値:
  #   - true: 最終スナップショットを作成しない
  #   - false: 最終スナップショットを作成する
  # 省略時: false
  # 注意: false の場合は final_snapshot_identifier の指定が必要です。
  skip_final_snapshot = false

  # final_snapshot_identifier (Optional)
  # 設定内容: クラスター削除直前に作成する最終スナップショットの識別子を指定します。
  # 設定可能な値: 有効なスナップショット識別子文字列
  # 省略時: skip_final_snapshot が false の場合は必須
  # 注意: skip_final_snapshot が false の場合に必須です。
  final_snapshot_identifier = "tf-redshift-cluster-final-snapshot"

  # snapshot_identifier (Optional)
  # 設定内容: 新しいクラスターの作成元となるスナップショット名を指定します。
  # 設定可能な値: 有効なスナップショット識別子文字列
  # 注意: snapshot_arn と排他的です。
  snapshot_identifier = null

  # snapshot_arn (Optional)
  # 設定内容: 新しいクラスターの作成元となるスナップショットのARNを指定します。
  # 設定可能な値: 有効なスナップショットARN
  # 注意: snapshot_identifier と排他的です。
  snapshot_arn = null

  # snapshot_cluster_identifier (Optional)
  # 設定内容: ソーススナップショットが作成されたクラスターの名前を指定します。
  # 設定可能な値: 有効なクラスター識別子文字列
  # 省略時: null
  snapshot_cluster_identifier = null

  # owner_account (Optional)
  # 設定内容: スナップショットの作成またはコピーに使用されたAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 自分のアカウントのスナップショットを復元する場合は不要
  # 注意: 所有していないスナップショットを復元する場合は必須です。
  owner_account = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encrypted (Optional)
  # 設定内容: クラスターのデータを保存時に暗号化するかを指定します。
  # 設定可能な値: "true" または "false" の文字列
  # 省略時: "true"
  # 注意: このプロパティは文字列型（bool型ではない）です。
  encrypted = "true"

  # kms_key_id (Optional)
  # 設定内容: データ暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: AWSが管理するキーを使用
  # 注意: encrypted を true に設定した場合のみ有効です。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-db-encryption.html
  kms_key_id = null

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # iam_roles (Optional)
  # 設定内容: クラスターに関連付けるIAMロールARNのリストを指定します。
  # 設定可能な値: 有効なIAMロールARNのセット（最大10個）
  # 省略時: IAMロールを関連付けない
  iam_roles = []

  # default_iam_role_arn (Optional)
  # 設定内容: クラスター作成時にデフォルトとして設定するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN（iam_roles に含まれているものである必要があります）
  # 省略時: AWSが自動で決定
  # 注意: aws_redshift_cluster_iam_roles リソースの default_iam_role_arn と競合しないよう注意してください。
  default_iam_role_arn = null

  #-------------------------------------------------------------
  # AQUA設定
  #-------------------------------------------------------------

  # aqua_configuration_status (Optional, 非推奨)
  # 設定内容: スナップショットから復元後のクラスターのAQUA（Advanced Query Accelerator）設定を指定します。
  # 設定可能な値: "auto"（AWS APIではサポート終了。常に "auto" が返されます）
  # 省略時: AWSが自動で設定（常に "auto"）
  # 注意: このプロパティは非推奨です。AWS APIでサポートが終了しています。
  aqua_configuration_status = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-clusters.html
  tags = {
    Name        = "tf-redshift-cluster"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: クラスター作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの時間文字列
    # 省略時: プロバイダーのデフォルト値を使用
    create = "75m"

    # update (Optional)
    # 設定内容: クラスター更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの時間文字列
    # 省略時: プロバイダーのデフォルト値を使用
    update = "75m"

    # delete (Optional)
    # 設定内容: クラスター削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの時間文字列
    # 省略時: プロバイダーのデフォルト値を使用
    delete = "40m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: クラスターのAmazon Resource Name (ARN)
# - id: RedshiftクラスターID（cluster_identifier と同じ値）
# - endpoint: クラスターの接続エンドポイント
# - dns_name: クラスターのDNS名
# - cluster_namespace_arn: クラスターの名前空間ARN
# - cluster_public_key: クラスターの公開鍵
# - cluster_revision_number: クラスター内データベースの特定リビジョン番号
# - cluster_nodes: クラスター内ノードのリスト（node_role, private_ip_address, public_ip_address を含む）
# - master_password_secret_arn: クラスター管理者認証情報シークレットのARN
# - tags_all: プロバイダーのdefault_tags設定から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
