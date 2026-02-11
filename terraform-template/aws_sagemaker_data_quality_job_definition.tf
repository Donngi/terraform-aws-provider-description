# ====================================================================
# AWS SageMaker Data Quality Job Definition - Annotated Terraform Template
# ====================================================================
# 生成日: 2026-02-04
# Provider: hashicorp/aws
# Version: 6.28.0
#
# このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_data_quality_job_definition
# ====================================================================

# AWS SageMaker Data Quality Job Definition リソース
# 機械学習モデルの推論データの品質を監視するためのジョブ定義を作成します。
# 本番環境のデータが学習データと乖離していないか（データドリフト）を自動的に検出し、
# モデルの精度低下を早期に発見することができます。
#
# 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html
resource "aws_sagemaker_data_quality_job_definition" "example" {
  # ========================================
  # 必須パラメータ
  # ========================================

  # データ品質アプリケーション仕様（必須）
  # 監視ジョブを実行するコンテナの設定を行います。
  # SageMaker が提供する事前構築済みコンテナまたはカスタムコンテナを指定できます。
  #
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_DataQualityAppSpecification.html
  data_quality_app_specification {
    # コンテナイメージURI（必須）
    # データ品質監視ジョブを実行するコンテナイメージのURIを指定します。
    # SageMaker が提供する事前構築済みの監視コンテナイメージを使用する場合は、
    # aws_sagemaker_prebuilt_ecr_image データソースで取得できます。
    #
    # 例: 123456789012.dkr.ecr.us-east-1.amazonaws.com/sagemaker-model-monitor-analyzer
    image_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/sagemaker-model-monitor-analyzer"

    # 環境変数（オプション）
    # 監視ジョブのコンテナ内で設定される環境変数のマップです。
    # カスタムスクリプトや設定に必要なパラメータを渡すことができます。
    environment = {
      DATASET_FORMAT      = "csv"
      DATASET_SOURCE      = "/opt/ml/processing/input"
      OUTPUT_PATH         = "/opt/ml/processing/output"
      PUBLISH_CLOUDWATCH  = "Enabled"
    }

    # レコード前処理スクリプトURI（オプション）
    # 各データレコードを分析前に処理するスクリプトのS3 URIを指定します。
    # Base64デコードやJSON形式への変換など、データの前処理に使用されます。
    # SageMaker の事前構築済みコンテナを使用する場合にのみ適用されます。
    record_preprocessor_source_uri = "s3://my-bucket/scripts/preprocess.py"

    # 分析後処理スクリプトURI（オプション）
    # 分析完了後に実行されるスクリプトのS3 URIを指定します。
    # カスタムレポート生成やアラート送信などの後処理に使用されます。
    # SageMaker の事前構築済みコンテナを使用する場合にのみ適用されます。
    post_analytics_processor_source_uri = "s3://my-bucket/scripts/postprocess.py"
  }

  # データ品質ジョブ入力設定（必須）
  # 監視対象のデータソースを指定します。
  # エンドポイントまたはバッチ変換ジョブのどちらか一方を指定します。
  data_quality_job_input {
    # エンドポイント入力（オプション - batch_transform_input と排他）
    # リアルタイム推論エンドポイントから取得したデータを監視します。
    # エンドポイントで data_capture_config を有効にしておく必要があります。
    endpoint_input {
      # エンドポイント名（必須）
      # 監視対象のSageMakerエンドポイント名を指定します。
      # このエンドポイントではデータキャプチャが有効化されている必要があります。
      endpoint_name = "my-endpoint"

      # ローカルパス（オプション）
      # コンテナ内でエンドポイントデータが利用可能になるファイルシステムのパスです。
      # デフォルト値: /opt/ml/processing/input
      local_path = "/opt/ml/processing/input"

      # S3データ分散タイプ（オプション）
      # S3内のデータの分散方法を指定します。
      # 有効な値:
      #   - FullyReplicated: すべてのデータを各インスタンスに複製（デフォルト）
      #   - ShardedByS3Key: S3キーでシャーディングして分散
      s3_data_distribution_type = "FullyReplicated"

      # S3入力モード（オプション）
      # データ転送モードを指定します。
      # 有効な値:
      #   - File: ファイル全体をダウンロード（小規模データ向け、デフォルト）
      #   - Pipe: ストリーミングで読み込み（大規模データ向け）
      s3_input_mode = "File"
    }

    # バッチ変換入力（オプション - endpoint_input と排他）
    # バッチ変換ジョブから取得したデータを監視します。
    # batch_transform_input {
    #   # データキャプチャ先S3 URI（必須）
    #   # データキャプチャ結果が保存されているS3の場所を指定します。
    #   data_captured_destination_s3_uri = "s3://my-bucket/data-capture/"
    #
    #   # データセット形式（必須）
    #   # バッチ変換ジョブのデータセット形式を指定します。
    #   dataset_format {
    #     # CSV形式（オプション - json と排他）
    #     csv {
    #       # ヘッダー有無（オプション）
    #       # CSVデータがヘッダー行を含むかどうかを指定します。
    #       header = true
    #     }
    #
    #     # JSON形式（オプション - csv と排他）
    #     # json {
    #     #   # 行単位JSON（オプション）
    #     #   # ファイルを1行ごとにJSONオブジェクトとして読み込むかを指定します。
    #     #   line = true
    #     # }
    #   }
    #
    #   # ローカルパス（オプション）
    #   # コンテナ内でデータが利用可能になるファイルシステムのパスです。
    #   # デフォルト値: /opt/ml/processing/input
    #   local_path = "/opt/ml/processing/input"
    #
    #   # S3データ分散タイプ（オプション）
    #   # S3内のデータの分散方法を指定します。
    #   # 有効な値: FullyReplicated、ShardedByS3Key
    #   s3_data_distribution_type = "FullyReplicated"
    #
    #   # S3入力モード（オプション）
    #   # データ転送モードを指定します。
    #   # 有効な値: File、Pipe
    #   s3_input_mode = "File"
    # }
  }

  # データ品質ジョブ出力設定（必須）
  # 監視ジョブの出力先を設定します。
  # 分析結果、統計情報、制約違反レポートなどが出力されます。
  data_quality_job_output_config {
    # 監視出力設定（必須）
    # 監視ジョブの出力先を定義します。
    monitoring_outputs {
      # S3出力設定（必須）
      # 監視結果をS3に保存する設定です。
      s3_output {
        # S3 URI（必須）
        # 監視ジョブの結果を保存するS3の場所を指定します。
        # ここに statistics.json、constraint_violations.json などが保存されます。
        s3_uri = "s3://my-bucket/monitoring-output/"

        # ローカルパス（オプション）
        # コンテナ内の出力データが保存されるローカルパスです。
        # デフォルト値: /opt/ml/processing/output
        local_path = "/opt/ml/processing/output"

        # S3アップロードモード（オプション）
        # 結果のアップロードタイミングを指定します。
        # 有効な値:
        #   - Continuous: 結果を継続的にアップロード
        #   - EndOfJob: ジョブ完了後にアップロード
        s3_upload_mode = "EndOfJob"
      }
    }

    # KMSキーID（オプション）
    # S3サーバー側暗号化に使用するAWS KMSキーを指定します。
    # モデルアーティファクトやジョブ結果の暗号化に使用されます。
    kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  # ジョブリソース設定（必須）
  # 監視ジョブを実行するコンピュートリソースを定義します。
  job_resources {
    # クラスター設定（必須）
    # 処理ジョブを実行するMLコンピュートクラスターの設定です。
    cluster_config {
      # インスタンス数（必須）
      # モデル監視ジョブで使用するMLコンピュートインスタンスの数を指定します。
      # 分散処理ジョブの場合は1より大きい値を指定します。
      instance_count = 1

      # インスタンスタイプ（必須）
      # 処理ジョブで使用するMLコンピュートインスタンスのタイプを指定します。
      # 有効な値: ml.t3.medium、ml.m5.large、ml.m5.xlarge など
      #
      # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-available-instance-types.html
      instance_type = "ml.t3.medium"

      # ボリュームサイズ（必須）
      # プロビジョニングするMLストレージボリュームのサイズ（GB）を指定します。
      # データセットのサイズに応じて十分な容量を確保してください。
      volume_size_in_gb = 20

      # ボリューム暗号化KMSキーID（オプション）
      # MLコンピュートインスタンスに接続されたストレージボリュームの
      # データ暗号化に使用するAWS KMSキーを指定します。
      volume_kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    }
  }

  # ロールARN（必須）
  # SageMakerがユーザーの代わりにタスクを実行するために引き受けることができる
  # IAMロールのARNを指定します。
  # このロールには、S3へのアクセス、CloudWatch Logsへの書き込みなどの権限が必要です。
  #
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-roles.html
  role_arn = "arn:aws:iam::123456789012:role/SageMakerExecutionRole"

  # ========================================
  # オプションパラメータ
  # ========================================

  # ジョブ定義名（オプション）
  # データ品質ジョブ定義の名前を指定します。
  # 省略した場合、Terraform がランダムで一意な名前を割り当てます。
  # 名前は AWS アカウントとリージョン内で一意である必要があります。
  name = "my-data-quality-job-definition"

  # データ品質ベースライン設定（オプション）
  # 監視ジョブの制約とベースラインを設定します。
  # ベースラインジョブで生成された制約と統計情報を参照します。
  data_quality_baseline_config {
    # 制約リソース（オプション）
    # データ品質の制約条件を定義したリソースの場所を指定します。
    constraints_resource {
      # S3 URI（オプション）
      # 制約リソースファイル（constraints.json）が保存されているS3 URIを指定します。
      # ベースラインジョブで生成された制約ファイルを参照します。
      s3_uri = "s3://my-bucket/baseline/constraints.json"
    }

    # 統計リソース（オプション）
    # データの統計情報を定義したリソースの場所を指定します。
    statistics_resource {
      # S3 URI（オプション）
      # 統計リソースファイル（statistics.json）が保存されているS3 URIを指定します。
      # ベースラインジョブで生成された統計ファイルを参照します。
      s3_uri = "s3://my-bucket/baseline/statistics.json"
    }
  }

  # ネットワーク設定（オプション）
  # 監視ジョブのネットワーク構成を指定します。
  network_config {
    # コンテナ間トラフィック暗号化の有効化（オプション）
    # 監視ジョブで使用されるインスタンス間のすべての通信を暗号化するかを指定します。
    # true を選択すると、分散ジョブのセキュリティが向上しますが、処理時間が長くなる可能性があります。
    enable_inter_container_traffic_encryption = false

    # ネットワーク隔離の有効化（オプション）
    # 監視ジョブで使用されるコンテナへの、およびコンテナからの
    # インバウンドおよびアウトバウンドのネットワーク呼び出しを許可するかを指定します。
    enable_network_isolation = false

    # VPC設定（オプション）
    # トレーニングジョブとホストされたモデルがアクセスできるVPCを指定します。
    # VPCを設定することで、トレーニングおよびモデルコンテナへのアクセスを制御できます。
    vpc_config {
      # セキュリティグループID（必須）
      # VPCセキュリティグループIDを指定します（sg-xxxxxxxx形式）。
      # subnets フィールドで指定されたVPCのセキュリティグループを指定します。
      security_group_ids = [
        "sg-0123456789abcdef0"
      ]

      # サブネット（必須）
      # トレーニングジョブまたはモデルを接続するVPC内のサブネットのIDを指定します。
      # 高可用性のため、複数のアベイラビリティゾーンのサブネットを指定することを推奨します。
      subnets = [
        "subnet-0123456789abcdef0",
        "subnet-0123456789abcdef1"
      ]
    }
  }

  # 停止条件（オプション）
  # 監視ジョブが停止されるまでの実行時間の制限を設定します。
  stopping_condition {
    # 最大実行時間（必須）
    # 監視ジョブの最大実行時間を秒単位で指定します。
    # この時間を超えるとジョブは自動的に停止されます。
    # デフォルトは3600秒（1時間）です。
    max_runtime_in_seconds = 3600
  }

  # リージョン（オプション）
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # タグ（オプション）
  # リソースに割り当てるタグのマップを指定します。
  # プロバイダーの default_tags 設定ブロックと組み合わせて使用できます。
  # タグはリソースの管理、コスト配分、アクセス制御などに使用されます。
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    Team        = "ml-ops"
    Purpose     = "data-quality-monitoring"
    ManagedBy   = "terraform"
  }

  # tags_all
  # デフォルトタグとリソースタグを統合したすべてのタグのマップです。
  # 通常は Terraform によって自動的に管理されるため、明示的な指定は不要です。
  # プロバイダーの default_tags と tags を統合した結果がここに反映されます。
  # tags_all = {}
}

# ====================================================================
# 出力例（参考）
# ====================================================================
# 以下の computed 属性は、リソース作成後に参照可能です。

# output "data_quality_job_definition_arn" {
#   description = "ARN of the SageMaker Data Quality Job Definition"
#   value       = aws_sagemaker_data_quality_job_definition.example.arn
# }
#
# output "data_quality_job_definition_name" {
#   description = "Name of the SageMaker Data Quality Job Definition"
#   value       = aws_sagemaker_data_quality_job_definition.example.name
# }

# ====================================================================
# 使用例: 事前構築済みコンテナイメージの取得
# ====================================================================
# SageMaker が提供する事前構築済みの監視コンテナイメージを使用する場合

# data "aws_sagemaker_prebuilt_ecr_image" "monitor" {
#   repository_name = "sagemaker-model-monitor-analyzer"
#   image_tag       = "latest"
# }
#
# resource "aws_sagemaker_data_quality_job_definition" "with_prebuilt_image" {
#   name = "prebuilt-image-example"
#
#   data_quality_app_specification {
#     image_uri = data.aws_sagemaker_prebuilt_ecr_image.monitor.registry_path
#   }
#
#   data_quality_job_input {
#     endpoint_input {
#       endpoint_name = aws_sagemaker_endpoint.example.name
#     }
#   }
#
#   data_quality_job_output_config {
#     monitoring_outputs {
#       s3_output {
#         s3_uri = "s3://my-bucket/output/"
#       }
#     }
#   }
#
#   job_resources {
#     cluster_config {
#       instance_count    = 1
#       instance_type     = "ml.t3.medium"
#       volume_size_in_gb = 20
#     }
#   }
#
#   role_arn = aws_iam_role.sagemaker_role.arn
# }

# ====================================================================
# 関連リソース
# ====================================================================
# - aws_sagemaker_monitoring_schedule: データ品質監視ジョブの実行スケジュールを定義
# - aws_sagemaker_endpoint: 監視対象のリアルタイム推論エンドポイント
# - aws_sagemaker_model_quality_job_definition: モデル品質監視ジョブ定義
# - aws_sagemaker_model_bias_job_definition: モデルバイアス監視ジョブ定義
# - aws_sagemaker_model_explainability_job_definition: モデル説明可能性監視ジョブ定義
#
# 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html
