#---------------------------------------------------------------
# RDS Aurora Cluster Database Activity Stream
#---------------------------------------------------------------
#
# RDS Auroraクラスターのデータベースアクティビティストリームを管理するリソースです。
# Database Activity Streamsは、データベースアクティビティをリアルタイムで
# ストリーミングし、データベースアクセスの監視、監査、コンプライアンス要件への
# 対応を可能にします。
#
# 重要な制限事項:
#   - このリソースは常にApplyImmediatelyパラメータをtrueで実行します
#   - 少なくとも1つのaws_rds_cluster_instanceの作成が必要です
#   - 以下のリージョンでは利用できません: cn-north-1, cn-northwest-1, us-gov-east-1, us-gov-west-1
#
# AWS公式ドキュメント:
#   - Database Activity Streams概要: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/DBActivityStreams.html
#   - 監視とログ記録: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Overview.LoggingAndMonitoring.html
#   - RDS API リファレンス (StartActivityStream): https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_StartActivityStream.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_activity_stream
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_cluster_activity_stream" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # resource_arn (Required, Forces new resource)
  # 設定内容: データベースアクティビティストリームを作成するDBクラスターのARNを指定します。
  # 設定可能な値: 有効なRDS AuroraクラスターのARN
  # 用途: アクティビティストリームを関連付けるクラスターの識別
  # 注意: この値を変更すると、リソースが再作成されます
  # 関連機能: RDS クラスターARN
  #   アクティビティストリームは特定のAuroraクラスターに紐づきます。
  #   Auroraクラスターはaws_rds_clusterリソースで作成されます。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/DBActivityStreams.html
  resource_arn = aws_rds_cluster.example.arn

  # mode (Required, Forces new resource)
  # 設定内容: データベースアクティビティストリームのモードを指定します。
  # 設定可能な値:
  #   - "sync": 同期モード。データベースセッションがアクティビティストリームイベントを同期的に処理
  #   - "async": 非同期モード。データベースセッションがアクティビティストリームイベントを非同期的に処理
  # 用途: データベースパフォーマンスと監査要件のバランスを調整
  # 注意: この値を変更すると、リソースが再作成されます
  # 関連機能: Database Activity Streams モード
  #   - sync: より高い監査保証が必要な場合に使用。わずかなパフォーマンス影響あり
  #   - async: パフォーマンスを優先する場合に使用。監査イベントが非同期で記録
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/DBActivityStreams.html#DBActivityStreams.Overview
  mode = "async"

  # kms_key_id (Required, Forces new resource)
  # 設定内容: データベースアクティビティストリーム内のメッセージを暗号化するための
  #          AWS KMS キーの識別子を指定します。
  # 設定可能な値: KMSキーのARN、キーID、エイリアスARN、またはエイリアス名
  # 用途: アクティビティストリームデータの暗号化に使用
  # 注意: この値を変更すると、リソースが再作成されます
  # 関連機能: KMS暗号化
  #   アクティビティストリームのデータは常に暗号化されます。
  #   指定したKMSキーでデータを暗号化し、Kinesisストリームに送信します。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/DBActivityStreams.html#DBActivityStreams.Enabling
  kms_key_id = aws_kms_key.example.key_id

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # engine_native_audit_fields_included (Optional, Forces new resource)
  # 設定内容: データベースアクティビティストリームにエンジンネイティブの監査フィールドを
  #          含めるかどうかを指定します。
  # 設定可能な値:
  #   - true: エンジンネイティブ監査フィールドを含める
  #   - false: エンジンネイティブ監査フィールドを含めない (デフォルト)
  # 用途: Oracleデータベースインスタンスでのみ適用されるオプション
  # 注意: この値を変更すると、リソースが再作成されます
  # 省略時: false (含めない)
  # 関連機能: Oracle統合監査
  #   OracleデータベースのネイティブUnified Audit Trail情報をストリームに含めます。
  #   Oracle Database専用の追加監査情報を取得できます。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/DBActivityStreams.html
  engine_native_audit_fields_included = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: 以下のリージョンではこのリソースは利用できません
  #   - cn-north-1 (中国 北京)
  #   - cn-northwest-1 (中国 寧夏)
  #   - us-gov-east-1 (AWS GovCloud 米国東部)
  #   - us-gov-west-1 (AWS GovCloud 米国西部)
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はDBクラスターのARNと同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # 依存関係の設定
  #-------------------------------------------------------------
  # 重要: このリソースは少なくとも1つのRDSクラスターインスタンスが
  #       作成されていることに依存します。
  #       レースコンディションを避けるため、明示的な依存関係を設定してください。
  #
  # depends_on = [aws_rds_cluster_instance.example]
  depends_on = [aws_rds_cluster_instance.example]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: DBクラスターのAmazon Resource Name (ARN)
#
# - kinesis_stream_name: データベースアクティビティストリームに使用される
#   Amazon Kinesisデータストリームの名前
#   このストリームからアクティビティデータを読み取ることができます
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# この設定例では、以下のリソースが必要です:
#
# 1. RDS Aurora Cluster (aws_rds_cluster)
# 2. RDS Cluster Instance (aws_rds_cluster_instance) - 最低1つ
# 3. KMS Key (aws_kms_key) - アクティビティストリームの暗号化用
#
# 完全な例:
#
# resource "aws_rds_cluster" "example" {
#   cluster_identifier = "aurora-cluster-demo"
#   availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
#---------------------------------------------------------------
