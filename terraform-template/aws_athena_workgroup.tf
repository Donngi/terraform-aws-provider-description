#---------------------------------------------------------------
# AWS Athena Workgroup
#---------------------------------------------------------------
#
# Amazon Athena ワークグループをプロビジョニングするリソースです。
# ワークグループを使用すると、クエリの実行を分離し、チームアクセスを制御し、
# ワークグループ全体の設定を適用し、クエリメトリクスとコストを追跡できます。
#
# AWS公式ドキュメント:
#   - Athenaワークグループ概要: https://docs.aws.amazon.com/athena/latest/ug/workgroups-manage-queries-control-costs.html
#   - ワークグループの管理: https://docs.aws.amazon.com/athena/latest/ug/workgroups-create-update-delete.html
#   - WorkGroupConfiguration API: https://docs.aws.amazon.com/athena/latest/APIReference/API_WorkGroupConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_workgroup
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_athena_workgroup" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ワークグループの名前を指定します。
  # 設定可能な値: 文字列（最大128文字、英数字、ハイフン、アンダースコアのみ）
  name = "example-workgroup"

  # description (Optional)
  # 設定内容: ワークグループの説明を指定します。
  # 設定可能な値: 任意の文字列
  description = "Example Athena workgroup for analytics queries"

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
  # 状態設定
  #-------------------------------------------------------------

  # state (Optional)
  # 設定内容: ワークグループの状態を指定します。
  # 設定可能な値:
  #   - "ENABLED" (デフォルト): ワークグループが有効。クエリを実行可能
  #   - "DISABLED": ワークグループが無効。クエリの実行が防止される
  # 関連機能: ワークグループ状態管理
  #   ワークグループを無効にすると、そのワークグループでのクエリ実行を防止できます。
  #   - https://docs.aws.amazon.com/athena/latest/ug/workgroups-create-update-delete.html
  state = "ENABLED"

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: ワークグループに名前付きクエリが含まれていても削除するかを指定します。
  # 設定可能な値:
  #   - true: 名前付きクエリが含まれていても削除
  #   - false (デフォルト): 名前付きクエリがある場合は削除失敗
  force_destroy = false

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
    Name        = "example-workgroup"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # ワークグループ設定
  #-------------------------------------------------------------

  # configuration (Optional)
  # 設定内容: ワークグループのさまざまな設定を含む設定ブロックです。
  configuration {
    #-----------------------------------------------------------
    # クエリ実行設定
    #-----------------------------------------------------------

    # enforce_workgroup_configuration (Optional)
    # 設定内容: ワークグループ設定がクライアント側の設定を上書きするかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): ワークグループ設定がクライアント側設定を上書き
    #   - false: クライアント側設定を使用
    # 関連機能: ワークグループ設定オーバーライド
    #   trueの場合、クエリ結果の場所や暗号化設定などがワークグループで強制されます。
    #   - https://docs.aws.amazon.com/athena/latest/ug/workgroups-settings-override.html
    enforce_workgroup_configuration = true

    # bytes_scanned_cutoff_per_query (Optional)
    # 設定内容: 単一クエリでスキャンできるデータ量の上限（バイト単位）を指定します。
    # 設定可能な値: 10485760（10MB）以上の整数
    # 省略時: 制限なし
    # 関連機能: データ使用量制御
    #   クエリコストを制御し、意図しない大規模スキャンを防止します。
    #   - https://docs.aws.amazon.com/athena/latest/ug/workgroups-manage-queries-control-costs.html
    bytes_scanned_cutoff_per_query = null

    # enable_minimum_encryption_configuration (Optional)
    # 設定内容: クエリおよび計算結果に対して最小暗号化レベルを強制するかを指定します。
    # 設定可能な値:
    #   - true: Amazon S3に書き込まれる結果に最小暗号化レベルを強制
    #   - false: 暗号化を強制しない
    enable_minimum_encryption_configuration = null

    # execution_role (Optional)
    # 設定内容: ノートブックセッションおよびIAM Identity Center有効ワークグループで
    #          ユーザーリソースにアクセスするためのロールARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 注意: IAM Identity Center有効ワークグループでは必須
    execution_role = null

    #-----------------------------------------------------------
    # メトリクス設定
    #-----------------------------------------------------------

    # publish_cloudwatch_metrics_enabled (Optional)
    # 設定内容: CloudWatchメトリクスを有効にするかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): CloudWatchメトリクスを有効化
    #   - false: CloudWatchメトリクスを無効化
    # 関連機能: Athenaクエリメトリクス
    #   クエリの実行時間、スキャンしたデータ量などのメトリクスをCloudWatchに発行します。
    publish_cloudwatch_metrics_enabled = true

    #-----------------------------------------------------------
    # S3アクセス設定
    #-----------------------------------------------------------

    # requester_pays_enabled (Optional)
    # 設定内容: Requester Paysバケットへのクエリを許可するかを指定します。
    # 設定可能な値:
    #   - true: Requester Paysバケットへのクエリを許可
    #   - false (デフォルト): Requester Paysバケットへのクエリを拒否
    # 関連機能: S3 Requester Pays
    #   - https://docs.aws.amazon.com/AmazonS3/latest/dev/RequesterPaysBuckets.html
    requester_pays_enabled = false

    #-----------------------------------------------------------
    # エンジンバージョン設定
    #-----------------------------------------------------------

    # engine_version (Optional)
    # 設定内容: Athenaエンジンのバージョン設定を指定します。
    # 関連機能: Athenaエンジンバージョニング
    #   - https://docs.aws.amazon.com/athena/latest/ug/engine-versions.html
    engine_version {
      # selected_engine_version (Optional)
      # 設定内容: 使用するエンジンバージョンを指定します。
      # 設定可能な値:
      #   - "AUTO" (デフォルト): Athenaが自動的に最適なバージョンを選択
      #   - "Athena engine version 2": 特定のバージョンを指定
      #   - "Athena engine version 3": 特定のバージョンを指定
      selected_engine_version = "AUTO"

      # effective_engine_version (Read-only)
      # 説明: 実際にクエリで使用されるエンジンバージョン。
      #       selected_engine_versionが"AUTO"の場合、Athenaが選択したバージョンが返されます。
    }

    #-----------------------------------------------------------
    # IAM Identity Center設定
    #-----------------------------------------------------------

    # identity_center_configuration (Optional)
    # 設定内容: IAM Identity Center有効ワークグループの設定を指定します。
    identity_center_configuration {
      # enable_identity_center (Optional)
      # 設定内容: ワークグループがIAM Identity Centerをサポートするかを指定します。
      # 設定可能な値:
      #   - true: IAM Identity Centerサポートを有効化
      #   - false: IAM Identity Centerサポートを無効化
      enable_identity_center = null

      # identity_center_instance_arn (Optional)
      # 設定内容: ワークグループに関連付けるIAM Identity CenterインスタンスのARNを指定します。
      # 設定可能な値: 有効なIAM Identity CenterインスタンスARN
      identity_center_instance_arn = null
    }

    #-----------------------------------------------------------
    # カスタマーコンテンツ暗号化設定
    #-----------------------------------------------------------

    # customer_content_encryption_configuration (Optional)
    # 設定内容: Athenaでユーザーのデータストアを暗号化するためのKMSキー設定を指定します。
    #          この設定はAthenaノートブック用のPySparkエンジンに適用されます。
    customer_content_encryption_configuration {
      # kms_key (Optional - ドキュメントではRequired)
      # 設定内容: ユーザーのデータストアを暗号化するカスタマーマネージドKMSキーのARNを指定します。
      # 設定可能な値: 有効なKMSキーARN
      kms_key = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    }

    #-----------------------------------------------------------
    # クエリ結果設定
    #-----------------------------------------------------------

    # result_configuration (Optional)
    # 設定内容: クエリ結果の保存場所と暗号化設定を指定します。
    result_configuration {
      # output_location (Optional)
      # 設定内容: クエリ結果を保存するS3の場所を指定します。
      # 設定可能な値: S3 URI（例: s3://bucket-name/path/）
      # 関連機能: クエリ結果の保存
      #   - https://docs.aws.amazon.com/athena/latest/ug/querying.html
      output_location = "s3://example-athena-results-bucket/output/"

      # expected_bucket_owner (Optional)
      # 設定内容: S3バケットの所有者として期待するAWSアカウントIDを指定します。
      # 設定可能な値: 12桁のAWSアカウントID
      # 用途: バケット所有者の検証によるセキュリティ強化
      expected_bucket_owner = null

      # acl_configuration (Optional)
      # 設定内容: クエリ結果に適用するS3 ACL設定を指定します。
      acl_configuration {
        # s3_acl_option (Required)
        # 設定内容: Athenaがクエリ結果を保存する際に指定するS3 ACLを指定します。
        # 設定可能な値:
        #   - "BUCKET_OWNER_FULL_CONTROL": バケット所有者に完全な制御権を付与
        s3_acl_option = "BUCKET_OWNER_FULL_CONTROL"
      }

      # encryption_configuration (Optional)
      # 設定内容: クエリ結果の暗号化設定を指定します。
      encryption_configuration {
        # encryption_option (Optional)
        # 設定内容: 暗号化オプションを指定します。
        # 設定可能な値:
        #   - "SSE_S3": S3マネージドキーによるサーバー側暗号化
        #   - "SSE_KMS": KMSマネージドキーによるサーバー側暗号化
        #   - "CSE_KMS": KMSマネージドキーによるクライアント側暗号化
        encryption_option = "SSE_KMS"

        # kms_key_arn (Optional)
        # 設定内容: SSE_KMSまたはCSE_KMSの場合に使用するKMSキーのARNを指定します。
        # 設定可能な値: 有効なKMSキーARN
        kms_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
      }
    }

    #-----------------------------------------------------------
    # S3アクセスグラント設定
    #-----------------------------------------------------------

    # query_results_s3_access_grants_configuration (Optional)
    # 設定内容: クエリ結果に対するAmazon S3アクセスグラントの設定を指定します。
    # 関連機能: S3 Access Grants
    #   S3アクセスグラントを使用して、クエリ結果へのきめ細かなアクセス制御を実現します。
    query_results_s3_access_grants_configuration {
      # enable_s3_access_grants (Required)
      # 設定内容: クエリ結果に対してS3アクセスグラントを有効にするかを指定します。
      # 設定可能な値:
      #   - true: S3アクセスグラントを有効化
      #   - false: S3アクセスグラントを無効化
      enable_s3_access_grants = false

      # authentication_type (Required)
      # 設定内容: S3アクセスグラントに使用する認証タイプを指定します。
      # 設定可能な値:
      #   - "DIRECTORY_IDENTITY": ディレクトリベースのID認証
      authentication_type = "DIRECTORY_IDENTITY"

      # create_user_level_prefix (Optional)
      # 設定内容: クエリ結果出力場所にユーザーIDをS3パスプレフィックスとして追加するかを指定します。
      # 設定可能な値:
      #   - true: ユーザーIDプレフィックスを追加
      #   - false (デフォルト): プレフィックスを追加しない
      create_user_level_prefix = false
    }

    #-----------------------------------------------------------
    # マネージドクエリ結果設定
    #-----------------------------------------------------------

    # managed_query_results_configuration (Optional)
    # 設定内容: Athena所有のストレージにクエリ結果を保存するための設定を指定します。
    managed_query_results_configuration {
      # enabled (Optional)
      # 設定内容: Athena所有のストレージにクエリ結果を保存するかを指定します。
      # 設定可能な値:
      #   - true: Athena所有ストレージに結果を保存
      #   - false (デフォルト): result_configuration.output_locationで指定した場所に保存
      # 注意: trueの場合、result_configuration.output_locationを設定できません。
      enabled = false

      # encryption_configuration (Optional)
      # 設定内容: マネージドクエリ結果の暗号化設定を指定します。
      encryption_configuration {
        # kms_key (Optional)
        # 設定内容: マネージドクエリ結果を暗号化するKMSキーのARNを指定します。
        # 設定可能な値: 有効なKMSキーARN
        kms_key = null
      }
    }

    #-----------------------------------------------------------
    # モニタリング設定（Apache Spark エンジン専用）
    #-----------------------------------------------------------

    # monitoring_configuration (Optional)
    # 設定内容: マネージドログ永続化とログ配信の設定を指定します。
    #          Apache Sparkエンジンにのみ適用されます。
    monitoring_configuration {
      # cloud_watch_logging_configuration (Optional)
      # 設定内容: CloudWatch Logsへのログ配信設定を指定します。
      cloud_watch_logging_configuration {
        # enabled (Required)
        # 設定内容: CloudWatchロギングを有効にするかを指定します。
        # 設定可能な値:
        #   - true: CloudWatchロギングを有効化
        #   - false: CloudWatchロギングを無効化
        enabled = true

        # log_group (Optional)
        # 設定内容: ログを発行するCloudWatch Logsロググループ名を指定します。
        # 設定可能な値: 有効なロググループ名
        log_group = "/aws/athena/spark-logs"

        # log_stream_name_prefix (Optional)
        # 設定内容: CloudWatchログストリーム名のプレフィックスを指定します。
        # 設定可能な値: 任意の文字列
        log_stream_name_prefix = "example-"

        # log_type (Optional, Repeatable)
        # 設定内容: CloudWatchに配信するログタイプを指定します。
        log_type {
          # key (Required)
          # 設定内容: ログを配信するワーカーのタイプを指定します。
          # 設定可能な値: "SPARK_DRIVER", "SPARK_EXECUTOR"
          key = "SPARK_DRIVER"

          # values (Required)
          # 設定内容: 配信するログタイプのリストを指定します。
          # 設定可能な値: ["STDOUT", "STDERR"]
          values = ["STDOUT", "STDERR"]
        }
      }

      # managed_logging_configuration (Optional)
      # 設定内容: マネージドログ永続化の設定を指定します。
      managed_logging_configuration {
        # enabled (Required)
        # 設定内容: マネージドログ永続化を有効にするかを指定します。
        # 設定可能な値:
        #   - true: マネージドログ永続化を有効化
        #   - false: マネージドログ永続化を無効化
        enabled = false

        # kms_key (Optional)
        # 設定内容: マネージドログ永続化に保存されるログを暗号化するKMSキーのARNを指定します。
        # 設定可能な値: 有効なKMSキーARN
        kms_key = null
      }

      # s3_logging_configuration (Optional)
      # 設定内容: S3バケットへのログ配信設定を指定します。
      s3_logging_configuration {
        # enabled (Required)
        # 設定内容: S3ロギングを有効にするかを指定します。
        # 設定可能な値:
        #   - true: S3ロギングを有効化
        #   - false: S3ロギングを無効化
        enabled = false

        # log_location (Optional)
        # 設定内容: ログを発行するS3の場所を指定します。
        # 設定可能な値: S3 URI（例: s3://bucket-name/prefix/）
        log_location = null

        # kms_key (Optional)
        # 設定内容: S3に発行されるログを暗号化するKMSキーのARNを指定します。
        # 設定可能な値: 有効なKMSキーARN
        kms_key = null
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ワークグループのAmazon Resource Name (ARN)
#
# - id: ワークグループ名
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - configuration.engine_version.effective_engine_version:
#   実際にクエリで使用されるエンジンバージョン。
#   selected_engine_versionが"AUTO"の場合、Athenaが選択したバージョンが返されます。
#---------------------------------------------------------------
