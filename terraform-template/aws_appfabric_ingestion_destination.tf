#---------------------------------------------------------------
# AWS AppFabric Ingestion Destination
#---------------------------------------------------------------
#
# AWS AppFabricのIngestion Destinationをプロビジョニングするリソースです。
# Ingestion Destinationは、アプリケーションから取り込まれた監査ログの
# 保存先を定義します。保存先としてAmazon S3バケットまたは
# Amazon Data Firehoseを指定できます。
#
# AWS公式ドキュメント:
#   - AppFabric概要: https://docs.aws.amazon.com/appfabric/latest/adminguide/what-is-appfabric.html
#   - 用語と概念: https://docs.aws.amazon.com/appfabric/latest/adminguide/terminology.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appfabric_ingestion_destination
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appfabric_ingestion_destination" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # app_bundle_arn (Required)
  # 設定内容: リクエストに使用するApp BundleのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なAppFabric App Bundle ARN
  # 関連機能: AppFabric App Bundle
  #   App Bundleは、アプリ認可とIngestionを格納するコンテナです。
  #   AWSアカウントごと、リージョンごとに1つ作成できます。
  #   - https://docs.aws.amazon.com/appfabric/latest/adminguide/terminology.html
  app_bundle_arn = "arn:aws:appfabric:ap-northeast-1:123456789012:appbundle/a1b2c3d4-5678-90ab-cdef-example11111"

  # ingestion_arn (Required)
  # 設定内容: リクエストに使用するIngestionのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なAppFabric Ingestion ARN
  # 関連機能: AppFabric Ingestion
  #   Ingestionは、アプリ認可を使用してアプリケーションのパブリックAPIから
  #   監査ログを取得し、1つ以上の宛先に配信します。
  #   - https://docs.aws.amazon.com/appfabric/latest/adminguide/terminology.html
  ingestion_arn = "arn:aws:appfabric:ap-northeast-1:123456789012:appbundle/a1b2c3d4-5678-90ab-cdef-example11111/ingestion/a1b2c3d4-5678-90ab-cdef-example22222"

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
  # 処理設定 (Processing Configuration)
  #-------------------------------------------------------------
  # 取り込まれたデータの処理方法を設定します。

  processing_configuration {
    # audit_log (Required)
    # 設定内容: 監査ログの処理設定を指定します。
    audit_log {
      # format (Required)
      # 設定内容: 監査ログのフォーマットを指定します。
      # 設定可能な値:
      #   - "json": JSON形式で出力
      #   - "parquet": Apache Parquet形式で出力（S3宛先の場合のみ使用可能）
      # 関連機能: 監査ログ出力形式
      #   JSONはリアルタイム分析やストリーム処理に適しています。
      #   Parquetは列指向フォーマットで、大規模データの分析に効率的です。
      format = "json"

      # schema (Required)
      # 設定内容: 監査ログのイベントスキーマを指定します。
      # 設定可能な値:
      #   - "raw": ソースアプリケーションが使用する元のスキーマを保持
      #   - "ocsf": Open Cybersecurity Schema Framework (OCSF) で正規化
      # 関連機能: Open Cybersecurity Schema Framework (OCSF)
      #   OCSFは、ベンダーに依存しないコアセキュリティスキーマを提供する
      #   オープンソースプロジェクトです。AppFabricはこのスキーマを拡張して
      #   SaaS中心のイベント構造を作成します。
      #   - https://docs.aws.amazon.com/appfabric/latest/adminguide/ocsf-schema.html
      schema = "ocsf"
    }
  }

  #-------------------------------------------------------------
  # 宛先設定 (Destination Configuration)
  #-------------------------------------------------------------
  # 取り込まれたデータの保存先を設定します。

  destination_configuration {
    # audit_log (Required)
    # 設定内容: 監査ログの宛先設定を指定します。
    audit_log {
      # destination (Required)
      # 設定内容: 監査ログの宛先を指定します。
      # 注意: firehose_streamまたはs3_bucketのいずれか1つのみ指定可能
      destination {
        #-----------------------------------------------------------
        # S3バケット宛先 (オプション1)
        #-----------------------------------------------------------
        # Amazon S3バケットを宛先として使用する場合に設定します。

        s3_bucket {
          # bucket_name (Required)
          # 設定内容: Amazon S3バケットの名前を指定します。
          # 設定可能な値: 有効なS3バケット名
          bucket_name = "my-appfabric-audit-logs-bucket"

          # prefix (Optional)
          # 設定内容: 使用するオブジェクトキーのプレフィックスを指定します。
          # 設定可能な値: 有効なS3オブジェクトキープレフィックス
          # 省略時: バケットのルートに保存
          prefix = "appfabric/audit-logs/"
        }

        #-----------------------------------------------------------
        # Firehose Stream宛先 (オプション2)
        #-----------------------------------------------------------
        # Amazon Data Firehose配信ストリームを宛先として使用する場合に設定します。
        # 注意: s3_bucketと排他的（どちらか一方のみ指定可能）

        # firehose_stream {
        #   # stream_name (Required)
        #   # 設定内容: Amazon Data Firehose配信ストリームの名前を指定します。
        #   # 設定可能な値: 有効なFirehose配信ストリーム名
        #   # 関連機能: Amazon Data Firehose
        #   #   リアルタイムストリーミングデータを配信するためのフルマネージドサービスです。
        #   #   Amazon Security Lakeなど他のサービスとの統合に使用できます。
        #   #   - https://docs.aws.amazon.com/firehose/latest/dev/what-is-this-service.html
        #   stream_name = "my-appfabric-delivery-stream"
        # }
      }
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-appfabric-ingestion-destination"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
  # 有効な時間単位: "s" (秒), "m" (分), "h" (時間)
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Ingestion DestinationのAmazon Resource Name (ARN)
#
# - id: リソースの識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
