#---------------------------------------------------------------
# Amazon DocumentDB Cluster Instance
#---------------------------------------------------------------
#
# Amazon DocumentDBクラスターインスタンスをプロビジョニングするリソースです。
# クラスターインスタンスは、DocumentDBクラスター内の単一インスタンスの属性を定義します。
# プライマリとレプリカを明示的に指定する必要はなく、インスタンスを追加するだけで
# DocumentDBが自動的にレプリケーションを管理します。
#
# AWS公式ドキュメント:
#   - Amazon DocumentDB開発者ガイド: https://docs.aws.amazon.com/documentdb/latest/developerguide/what-is.html
#   - インスタンスクラス: https://docs.aws.amazon.com/documentdb/latest/developerguide/db-instance-classes.html#db-instance-class-specs
#   - Performance Insights: https://docs.aws.amazon.com/documentdb/latest/developerguide/performance-insights.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_instance
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_docdb_cluster_instance" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # cluster_identifier (Required)
  # 設定内容: このインスタンスが所属するDocumentDBクラスターの識別子を指定します。
  # 設定可能な値: 既存のaws_docdb_clusterリソースのIDまたはクラスター識別子
  # 関連リソース: aws_docdb_cluster
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster
  cluster_identifier = aws_docdb_cluster.example.id

  # instance_class (Required)
  # 設定内容: インスタンスに使用するインスタンスクラスを指定します。
  # 設定可能な値: db.r5.large, db.r5.xlarge, db.r5.2xlarge, db.r5.4xlarge,
  #               db.r5.12xlarge, db.r5.24xlarge, db.r6g.large, db.r6g.xlarge,
  #               db.r6g.2xlarge, db.r6g.4xlarge, db.r6g.8xlarge, db.r6g.12xlarge,
  #               db.r6g.16xlarge, db.t3.medium など
  # 参考:
  #   - スケーリングとインスタンスクラス: https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-manage-performance.html#db-cluster-manage-scaling-instance
  #   - インスタンスクラスの仕様: https://docs.aws.amazon.com/documentdb/latest/developerguide/db-instance-classes.html#db-instance-class-specs
  #   - データソース aws_docdb_orderable_db_instance で利用可能なインスタンスクラスを確認可能
  instance_class = "db.r5.large"

  #-------------------------------------------------------------
  # 識別子設定
  #-------------------------------------------------------------

  # identifier (Optional)
  # 設定内容: DocumentDBインスタンスの識別子を指定します。
  # 設定可能な値: 1〜63文字の英数字またはハイフン
  # 省略時: Terraformがランダムでユニークな識別子を自動生成
  # 注意: リソース作成後の変更はできません（Forces new resource）
  #       identifier_prefixと同時に指定することはできません
  identifier = "docdb-instance-example"

  # identifier_prefix (Optional)
  # 設定内容: 指定したプレフィックスで始まるユニークな識別子を生成します。
  # 設定可能な値: 1〜63文字から自動生成される接尾辞を引いた長さのプレフィックス
  # 省略時: 使用されない
  # 注意: リソース作成後の変更はできません（Forces new resource）
  #       identifierと同時に指定することはできません
  # identifier_prefix = "docdb-"

  #-------------------------------------------------------------
  # エンジン設定
  #-------------------------------------------------------------

  # engine (Optional)
  # 設定内容: データベースエンジンの名前を指定します。
  # 設定可能な値: "docdb" のみ
  # 省略時: "docdb"
  engine = "docdb"

  #-------------------------------------------------------------
  # 可用性設定
  #-------------------------------------------------------------

  # availability_zone (Optional)
  # 設定内容: DBインスタンスを作成するEC2アベイラビリティーゾーンを指定します。
  # 設定可能な値: 有効なAWSアベイラビリティーゾーン（例: us-east-1a, ap-northeast-1a）
  # 省略時: AWSが自動的に選択
  # 参考: https://docs.aws.amazon.com/documentdb/latest/developerguide/API_CreateDBInstance.html
  availability_zone = null

  # promotion_tier (Optional)
  # 設定内容: インスタンスレベルのフェイルオーバー優先度を指定します。
  # 設定可能な値: 0〜15の整数
  # 省略時: 0
  # 関連機能: フェイルオーバー
  #   数値が小さいほど、ライターへの昇格優先度が高くなります。
  #   同じ優先度のインスタンスが複数ある場合、インスタンスサイズが大きいものが優先されます。
  promotion_tier = 0

  #-------------------------------------------------------------
  # メンテナンス設定
  #-------------------------------------------------------------

  # apply_immediately (Optional)
  # 設定内容: データベースの変更を即座に適用するか、次のメンテナンスウィンドウで適用するかを指定します。
  # 設定可能な値: true, false
  # 省略時: false
  # 注意: trueに設定すると、変更が即座に適用されますが、
  #       実行中のクエリに影響を与える可能性があります。
  #       本番環境では慎重に使用してください。
  apply_immediately = false

  # auto_minor_version_upgrade (Optional)
  # 設定内容: マイナーバージョンの自動アップグレードを有効にするかを指定します。
  # 設定可能な値: true, false
  # 省略時: true
  # 注意: Amazon DocumentDBではこのパラメータは適用されません。
  #       DocumentDBは設定値に関係なくマイナーバージョンの自動アップグレードを実行しません。
  #       参考: https://docs.aws.amazon.com/documentdb/latest/developerguide/API_DBInstance.html
  auto_minor_version_upgrade = true

  # preferred_maintenance_window (Optional)
  # 設定内容: システムメンテナンスを実行できる週次の時間範囲を指定します。
  # 設定可能な値: "ddd:hh24:mi-ddd:hh24:mi" 形式（UTCで指定）
  #               例: "Mon:00:00-Mon:03:00"
  # 省略時: AWSが自動的に30分間のウィンドウを選択
  # 注意: メンテナンスウィンドウは30分以上必要です
  preferred_maintenance_window = "Sun:05:00-Sun:06:00"

  #-------------------------------------------------------------
  # 証明書設定
  #-------------------------------------------------------------

  # ca_cert_identifier (Optional)
  # 設定内容: DBインスタンスの認証局（CA）証明書の識別子を指定します。
  # 設定可能な値: 有効なCA証明書識別子（例: "rds-ca-2019", "rds-ca-rsa2048-g1"）
  # 省略時: AWSがデフォルトのCA証明書を使用
  # 関連機能: SSL/TLS接続
  #   DocumentDBクラスターへの接続時にSSL/TLSを使用する場合に必要です。
  ca_cert_identifier = null

  #-------------------------------------------------------------
  # Performance Insights設定
  #-------------------------------------------------------------

  # enable_performance_insights (Optional)
  # 設定内容: Performance Insightsを有効にするかを指定します。
  # 設定可能な値: true, false
  # 省略時: false
  # 関連機能: Performance Insights
  #   DBインスタンスのパフォーマンスを監視・分析するための機能です。
  #   CPU使用率、待機イベント、SQLクエリのパフォーマンスを可視化できます。
  #   参考: https://docs.aws.amazon.com/documentdb/latest/developerguide/performance-insights.html
  enable_performance_insights = false

  # performance_insights_kms_key_id (Optional)
  # 設定内容: Performance Insightsデータを暗号化するためのKMSキーを指定します。
  # 設定可能な値: KMSキーのARN、キーID、エイリアスARN、またはエイリアス名
  # 省略時: AWSアカウントのデフォルトKMSキーを使用
  # 注意: enable_performance_insightsがtrueの場合にのみ有効
  performance_insights_kms_key_id = null

  #-------------------------------------------------------------
  # スナップショット設定
  #-------------------------------------------------------------

  # copy_tags_to_snapshot (Optional)
  # 設定内容: DBインスタンスのタグをスナップショットにコピーするかを指定します。
  # 設定可能な値: true, false
  # 省略時: false
  copy_tags_to_snapshot = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

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
    Name        = "docdb-instance-example"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成、更新、削除操作のタイムアウトを設定します。
  timeouts {
    # create (Optional)
    # 設定内容: インスタンス作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "90m", "2h"）
    # 省略時: 90m
    create = "90m"

    # update (Optional)
    # 設定内容: インスタンス更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "90m", "2h"）
    # 省略時: 90m
    update = "90m"

    # delete (Optional)
    # 設定内容: インスタンス削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "90m", "2h"）
    # 省略時: 90m
    delete = "90m"
  }
}

#---------------------------------------------------------------
# 関連リソースの例
#---------------------------------------------------------------
# DocumentDBクラスターの例（インスタンスが所属するクラスター）
#
# resource "aws_docdb_cluster" "example" {
#   cluster_identifier      = "docdb-cluster-example"
#   engine                  = "docdb"
#   master_username         = "admin"
#   master_password         = "password123"
#   backup_retention_period = 5
#   preferred_backup_window = "07:00-09:00"
#   skip_final_snapshot     = true
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: クラスターインスタンスのAmazon Resource Name (ARN)
#
# - db_subnet_group_name: このDBインスタンスに関連付けられたDBサブネットグループ
#
# - dbi_resource_id: リージョン内でユニークな、DBインスタンスの不変識別子
#
# - endpoint: このインスタンスのDNSアドレス。書き込み可能でない場合があります。
#
# - engine_version: データベースエンジンのバージョン
#
# - kms_key_id: クラスターに設定されている場合の、KMS暗号化キーのARN
#
# - port: データベースのポート番号
#
# - preferred_backup_window: 自動バックアップが有効な場合に、
#                            自動バックアップが作成される日次の時間範囲
#
# - publicly_accessible: インスタンスにパブリックIPアドレスが関連付けられているか
#
# - storage_encrypted: DBクラスターが暗号化されているかどうか
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - writer: このインスタンスが書き込み可能かどうか。
#           Falseの場合、このインスタンスはリードレプリカです。
#---------------------------------------------------------------
