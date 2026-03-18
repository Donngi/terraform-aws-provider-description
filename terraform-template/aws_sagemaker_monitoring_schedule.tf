#---------------------------------------------------------------
# Amazon SageMaker Monitoring Schedule
#---------------------------------------------------------------
#
# Amazon SageMaker AI のモニタリングスケジュールを管理するリソースです。
# モデルの品質やデータ品質を継続的に監視し、ドリフトや異常を検出します。
#
# モニタリングタイプ:
#   - DataQuality: データ品質の監視（欠損値、異常値、分布のドリフトなど）
#   - ModelQuality: モデル品質の監視（精度、再現率、F1スコアなど）
#   - ModelBias: モデルバイアスの監視（公平性指標の評価）
#   - ModelExplainability: モデルの説明可能性の監視（特徴量の重要度など）
#
# 利用パターン:
#   1. 事前定義参照: monitoring_job_definition_name で既存のジョブ定義を参照
#   2. インライン定義: monitoring_job_definition ブロックでジョブ定義を直接記述
#
# AWS公式ドキュメント:
#   - SageMaker Model Monitor 概要: https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html
#   - モニタリングジョブのスケジューリング: https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-scheduling.html
#   - データ品質モニタリング: https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html
#   - API リファレンス: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateMonitoringSchedule.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_monitoring_schedule
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_monitoring_schedule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Computed)
  # 設定内容: モニタリングスケジュールの名前を指定します。
  # 設定可能な値: 1-63文字の英数字とハイフン。AWSアカウント・リージョン内で一意である必要があります
  # 省略時: Terraformが自動的にランダムな一意の名前を割り当てます
  # 関連機能: SageMaker モニタリングスケジュール名
  #   モニタリングスケジュールを識別するための名前。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-scheduling.html
  name = "example-monitoring-schedule"

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # モニタリングスケジュール設定
  #-------------------------------------------------------------

  # monitoring_schedule_config (Required)
  # 設定内容: モニタリングスケジュールの詳細設定を指定します。
  # 用途: モニタリングジョブの定義名、監視タイプ、実行スケジュール、
  #       またはインラインのジョブ定義を設定
  monitoring_schedule_config {

    # monitoring_job_definition_name (Optional)
    # 設定内容: スケジュールするモニタリングジョブ定義の名前を指定します。
    # 設定可能な値: 既存のモニタリングジョブ定義名
    #   - aws_sagemaker_data_quality_job_definition で作成した定義名
    #   - aws_sagemaker_model_quality_job_definition で作成した定義名
    #   - aws_sagemaker_model_bias_job_definition で作成した定義名
    #   - aws_sagemaker_model_explainability_job_definition で作成した定義名
    # 省略時: monitoring_job_definition ブロックでインライン定義を使用
    # 関連機能: SageMaker モニタリングジョブ定義
    #   事前に作成したジョブ定義を参照してモニタリングを実行。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html
    monitoring_job_definition_name = "example-data-quality-job-definition"

    # monitoring_type (Required)
    # 設定内容: スケジュールするモニタリングジョブのタイプを指定します。
    # 設定可能な値:
    #   - "DataQuality": データ品質の監視（欠損値、型の不一致、分布のドリフトなど）
    #   - "ModelQuality": モデル品質の監視（精度、再現率、F1スコアなど）
    #   - "ModelBias": モデルのバイアス監視（公平性指標の評価）
    #   - "ModelExplainability": モデルの説明可能性の監視（特徴量の重要度など）
    # 関連機能: SageMaker モニタリングタイプ
    #   監視目的に応じて適切なタイプを選択。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html
    monitoring_type = "DataQuality"

    #-------------------------------------------------------------
    # スケジュール設定
    #-------------------------------------------------------------

    # schedule_config (Optional)
    # 設定内容: モニタリングジョブの実行スケジュールを設定します。
    # 用途: 定期的なモニタリングの頻度を制御
    # 省略時: モニタリングは自動的にスケジュール実行されません
    schedule_config {

      # schedule_expression (Required)
      # 設定内容: モニタリングスケジュールの詳細を記述するcron式を指定します。
      # 設定可能な値: AWS cron式形式
      #   - 例: "cron(0 * ? * * *)" → 毎時0分に実行
      #   - 例: "cron(0 0 ? * * *)" → 毎日0時0分に実行
      #   - 例: "cron(0 */6 ? * * *)" → 6時間ごとに実行
      # フォーマット: cron(分 時 日 月 曜日 年)
      # 関連機能: CloudWatch Events Schedule Expressions
      #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html
      schedule_expression = "cron(0 * ? * * *)"
    }

    #-------------------------------------------------------------
    # インラインモニタリングジョブ定義
    #-------------------------------------------------------------

    # monitoring_job_definition (Optional)
    # 設定内容: モニタリングジョブをインラインで定義します。
    # 用途: 別途ジョブ定義リソースを作成せずに、スケジュール内で直接ジョブ定義を記述
    # 省略時: monitoring_job_definition_name で既存のジョブ定義を参照
    # 注意: monitoring_job_definition_name との併用も可能ですが、通常はどちらか一方を使用
    # monitoring_job_definition {

    #   # role_arn (Required)
    #   # 設定内容: SageMaker AIがタスクを実行するために引き受けるIAMロールのARNを指定します。
    #   # 設定可能な値: 有効なIAMロールARN
    #   # 注意: ロールにはS3へのアクセス権限やCloudWatchへの書き込み権限が必要です。
    #   role_arn = "arn:aws:iam::123456789012:role/sagemaker-monitoring-role"

    #   # environment (Optional)
    #   # 設定内容: Dockerコンテナに設定する環境変数のマップを指定します。
    #   # 設定可能な値: 文字列のキーバリューマップ
    #   # 省略時: 環境変数は設定されません
    #   environment = {
    #     PUBLISH_CLOUDWATCH_METRICS = "Enabled"
    #   }

    #   #-------------------------------------------------------------
    #   # ベースライン設定
    #   #-------------------------------------------------------------

    #   # baseline (Optional)
    #   # 設定内容: データの制約と統計のベースライン設定を指定します。
    #   # 用途: トレーニングデータから生成した制約・統計情報を参照してドリフトを検出
    #   baseline {

    #     # baselining_job_name (Optional)
    #     # 設定内容: ベースラインジョブの名前を指定します。
    #     # 設定可能な値: 既存のベースラインジョブ名
    #     # 省略時: ベースラインジョブ名は設定されません
    #     baselining_job_name = null

    #     # constraints_resource (Optional)
    #     # 設定内容: 制約リソースの設定ブロックです。
    #     constraints_resource {

    #       # s3_uri (Optional)
    #       # 設定内容: 制約リソースのAmazon S3 URIを指定します。
    #       # 設定可能な値: 有効なAmazon S3 URI（constraints.jsonファイルを指す）
    #       # 省略時: 制約リソースは使用されません
    #       s3_uri = "s3://my-monitoring-bucket/baseline/constraints.json"
    #     }

    #     # statistics_resource (Optional)
    #     # 設定内容: 統計リソースの設定ブロックです。
    #     statistics_resource {

    #       # s3_uri (Optional)
    #       # 設定内容: 統計リソースのAmazon S3 URIを指定します。
    #       # 設定可能な値: 有効なAmazon S3 URI（statistics.jsonファイルを指す）
    #       # 省略時: 統計リソースは使用されません
    #       s3_uri = "s3://my-monitoring-bucket/baseline/statistics.json"
    #     }
    #   }

    #   #-------------------------------------------------------------
    #   # アプリケーション仕様設定
    #   #-------------------------------------------------------------

    #   # monitoring_app_specification (Required)
    #   # 設定内容: 監視ジョブを実行するコンテナの仕様を指定します。
    #   # 関連機能: SageMaker Model Monitor コンテナ設定
    #   #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html
    #   monitoring_app_specification {

    #     # image_uri (Required)
    #     # 設定内容: 監視ジョブを実行するコンテナイメージのURIを指定します。
    #     # 設定可能な値: 有効なECRイメージURI（SageMaker提供の組み込みイメージまたはカスタムイメージ）
    #     image_uri = "123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/sagemaker-model-monitor-analyzer:latest"

    #     # container_arguments (Optional)
    #     # 設定内容: 監視ジョブを実行するコンテナに渡す引数のリストを指定します。
    #     # 設定可能な値: 文字列のリスト
    #     # 省略時: コンテナ引数は設定されません
    #     container_arguments = null

    #     # container_entrypoint (Optional)
    #     # 設定内容: 監視ジョブを実行するコンテナのエントリポイントを指定します。
    #     # 設定可能な値: 文字列のリスト
    #     # 省略時: コンテナイメージのデフォルトエントリポイントを使用
    #     container_entrypoint = null

    #     # record_preprocessor_source_uri (Optional)
    #     # 設定内容: 分析前に各行に対して呼び出されるスクリプトのS3 URIを指定します。
    #     # 設定可能な値: 有効なAmazon S3 URI
    #     # 省略時: 前処理スクリプトは使用されません
    #     record_preprocessor_source_uri = null

    #     # post_analytics_processor_source_uri (Optional)
    #     # 設定内容: 分析実行後に呼び出されるスクリプトのS3 URIを指定します。
    #     # 設定可能な値: 有効なAmazon S3 URI
    #     # 省略時: 後処理スクリプトは使用されません
    #     post_analytics_processor_source_uri = null
    #   }

    #   #-------------------------------------------------------------
    #   # モニタリング入力設定
    #   #-------------------------------------------------------------

    #   # monitoring_inputs (Required)
    #   # 設定内容: 監視ジョブの入力データソースを指定します。
    #   # 注意: endpoint_input と batch_transform_input のどちらか一方を指定
    #   monitoring_inputs {

    #     # endpoint_input (Optional)
    #     # 設定内容: エンドポイントを入力ソースとして使用する場合の設定ブロックです。
    #     endpoint_input {

    #       # endpoint_name (Required)
    #       # 設定内容: DataCaptureConfigが有効なエンドポイント名を指定します。
    #       # 設定可能な値: 既存のSageMakerエンドポイント名
    #       endpoint_name = "my-sagemaker-endpoint"

    #       # local_path (Required)
    #       # 設定内容: コンテナからエンドポイントデータにアクセスするパスを指定します。
    #       # 設定可能な値: 有効なローカルファイルシステムパス
    #       local_path = "/opt/ml/processing/input"

    #       # s3_input_mode (Optional, Computed)
    #       # 設定内容: 監視ジョブのデータ転送に使用する入力モードを指定します。
    #       # 設定可能な値:
    #       #   - "Pipe": パイプモード。大規模データセットに推奨
    #       #   - "File": ファイルモード。小規模データに適用
    #       # 省略時: AWSのデフォルト値を使用
    #       s3_input_mode = "File"

    #       # s3_data_distribution_type (Optional, Computed)
    #       # 設定内容: Amazon S3上の入力データの分散方式を指定します。
    #       # 設定可能な値:
    #       #   - "FullyReplicated": 全データを全インスタンスにレプリケート
    #       #   - "ShardedByS3Key": S3キーによりデータをシャーディング
    #       # 省略時: AWSのデフォルト値を使用
    #       s3_data_distribution_type = "FullyReplicated"

    #       # start_time_offset (Optional)
    #       # 設定内容: 監視ジョブが開始時刻から差し引く時間を指定します。
    #       # 設定可能な値: ISO 8601 duration形式（例: "-PT1H" で1時間前）
    #       # 省略時: オフセットなし
    #       start_time_offset = null

    #       # end_time_offset (Optional)
    #       # 設定内容: 監視ジョブが終了時刻から差し引く時間を指定します。
    #       # 設定可能な値: ISO 8601 duration形式（例: "-PT0H" で現在時刻）
    #       # 省略時: オフセットなし
    #       end_time_offset = null

    #       # features_attribute (Optional)
    #       # 設定内容: 入力データの特徴量属性名を指定します。
    #       # 設定可能な値: 属性名の文字列
    #       # 省略時: 特徴量属性は自動判定
    #       features_attribute = null

    #       # inference_attribute (Optional)
    #       # 設定内容: 推論結果のグラウンドトゥルースラベルを表す属性名を指定します。
    #       # 設定可能な値: 属性名の文字列
    #       # 省略時: 推論属性は自動判定
    #       inference_attribute = null

    #       # probability_attribute (Optional)
    #       # 設定内容: 分類問題でクラス確率を表す属性名を指定します。
    #       # 設定可能な値: 属性名の文字列
    #       # 省略時: 確率属性は自動判定
    #       probability_attribute = null

    #       # probability_threshold_attribute (Optional)
    #       # 設定内容: 陽性結果として評価するクラス確率の閾値を指定します。
    #       # 設定可能な値: 0.0〜1.0の数値
    #       # 省略時: 閾値は設定されません
    #       probability_threshold_attribute = null

    #       # exclude_features_attribute (Optional)
    #       # 設定内容: 分析から除外する入力データの属性を指定します。
    #       # 設定可能な値: 属性名の文字列
    #       # 省略時: 全属性が分析対象
    #       exclude_features_attribute = null
    #     }

    #     # batch_transform_input (Optional)
    #     # 設定内容: バッチ変換ジョブを入力ソースとして使用する場合の設定ブロックです。
    #     # 注意: endpoint_input と排他的。どちらか一方のみ指定可能
    #     # batch_transform_input {

    #     #   # data_captured_destination_s3_uri (Required)
    #     #   # 設定内容: データキャプチャに使用するAmazon S3の場所を指定します。
    #     #   # 設定可能な値: 有効なAmazon S3 URI
    #     #   data_captured_destination_s3_uri = "s3://my-bucket/data-capture/"

    #     #   # local_path (Required)
    #     #   # 設定内容: コンテナからバッチ変換データにアクセスするパスを指定します。
    #     #   # 設定可能な値: 有効なローカルファイルシステムパス
    #     #   local_path = "/opt/ml/processing/input"

    #     #   # dataset_format (Required)
    #     #   # 設定内容: バッチ変換ジョブのデータセットフォーマットを指定します。
    #     #   dataset_format {

    #     #     # csv (Optional)
    #     #     # 設定内容: CSVデータセットの設定ブロックです。
    #     #     csv {

    #     #       # header (Optional)
    #     #       # 設定内容: CSVデータにヘッダー行が含まれるかを指定します。
    #     #       # 設定可能な値: true / false
    #     #       # 省略時: false
    #     #       header = true
    #     #     }

    #     #     # json (Optional)
    #     #     # 設定内容: JSONデータセットの設定ブロックです。
    #     #     # json {

    #     #     #   # line (Optional)
    #     #     #   # 設定内容: JSONLines形式として読み込むかを指定します。
    #     #     #   # 設定可能な値: true / false
    #     #     #   # 省略時: false
    #     #     #   line = true
    #     #     # }
    #     #   }

    #     #   # s3_input_mode (Optional, Computed)
    #     #   # 設定内容: データ転送に使用する入力モードを指定します。
    #     #   # 設定可能な値: "Pipe" / "File"
    #     #   # 省略時: AWSのデフォルト値を使用
    #     #   s3_input_mode = "File"

    #     #   # s3_data_distribution_type (Optional, Computed)
    #     #   # 設定内容: S3上の入力データの分散方式を指定します。
    #     #   # 設定可能な値: "FullyReplicated" / "ShardedByS3Key"
    #     #   # 省略時: AWSのデフォルト値を使用
    #     #   s3_data_distribution_type = "FullyReplicated"

    #     #   # start_time_offset (Optional)
    #     #   # 設定内容: 開始時刻から差し引く時間を指定します。
    #     #   # 設定可能な値: ISO 8601 duration形式
    #     #   # 省略時: オフセットなし
    #     #   start_time_offset = null

    #     #   # end_time_offset (Optional)
    #     #   # 設定内容: 終了時刻から差し引く時間を指定します。
    #     #   # 設定可能な値: ISO 8601 duration形式
    #     #   # 省略時: オフセットなし
    #     #   end_time_offset = null

    #     #   # features_attribute (Optional)
    #     #   # 設定内容: 入力データの特徴量属性名を指定します。
    #     #   # 省略時: 特徴量属性は自動判定
    #     #   features_attribute = null

    #     #   # inference_attribute (Optional)
    #     #   # 設定内容: グラウンドトゥルースラベルを表す属性名を指定します。
    #     #   # 省略時: 推論属性は自動判定
    #     #   inference_attribute = null

    #     #   # probability_attribute (Optional)
    #     #   # 設定内容: クラス確率を表す属性名を指定します。
    #     #   # 省略時: 確率属性は自動判定
    #     #   probability_attribute = null

    #     #   # probability_threshold_attribute (Optional)
    #     #   # 設定内容: 陽性結果の確率閾値を指定します。
    #     #   # 設定可能な値: 0.0〜1.0の数値
    #     #   # 省略時: 閾値は設定されません
    #     #   probability_threshold_attribute = null

    #     #   # exclude_features_attribute (Optional)
    #     #   # 設定内容: 分析から除外する属性を指定します。
    #     #   # 省略時: 全属性が分析対象
    #     #   exclude_features_attribute = null
    #     # }
    #   }

    #   #-------------------------------------------------------------
    #   # モニタリング出力設定
    #   #-------------------------------------------------------------

    #   # monitoring_output_config (Required)
    #   # 設定内容: 監視ジョブの出力設定を指定します。
    #   # 関連機能: SageMaker Model Monitor 出力設定
    #   #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html
    #   monitoring_output_config {

    #     # kms_key_id (Optional)
    #     # 設定内容: S3サーバーサイド暗号化で結果を暗号化するKMSキーを指定します。
    #     # 設定可能な値: 有効なKMSキーARNまたはキーID
    #     # 省略時: デフォルトのS3管理キーが使用されます
    #     kms_key_id = null

    #     # monitoring_outputs (Required)
    #     # 設定内容: 監視ジョブの出力先を指定するブロックです。
    #     monitoring_outputs {

    #       # s3_output (Required)
    #       # 設定内容: 監視ジョブの結果を保存するS3ストレージの設定ブロックです。
    #       s3_output {

    #         # s3_uri (Required)
    #         # 設定内容: 監視ジョブの結果を保存するS3 URIを指定します。
    #         # 設定可能な値: 有効なAmazon S3 URI
    #         s3_uri = "s3://my-monitoring-bucket/output/"

    #         # local_path (Required)
    #         # 設定内容: 監視ジョブの結果を保存するローカルパスを指定します。
    #         # 設定可能な値: 有効なローカルファイルシステムの絶対パス
    #         local_path = "/opt/ml/processing/output"

    #         # s3_upload_mode (Optional, Computed)
    #         # 設定内容: 結果をアップロードするタイミングを指定します。
    #         # 設定可能な値:
    #         #   - "Continuous": ジョブ実行中に継続的にアップロード
    #         #   - "EndOfJob": ジョブ完了後にまとめてアップロード
    #         # 省略時: AWSのデフォルト値を使用
    #         s3_upload_mode = "EndOfJob"
    #       }
    #     }
    #   }

    #   #-------------------------------------------------------------
    #   # モニタリングリソース設定
    #   #-------------------------------------------------------------

    #   # monitoring_resources (Required)
    #   # 設定内容: 監視ジョブを実行するためのリソースを指定します。
    #   monitoring_resources {

    #     # cluster_config (Required)
    #     # 設定内容: 処理ジョブの実行に使用するクラスターリソースの設定ブロックです。
    #     cluster_config {

    #       # instance_count (Required)
    #       # 設定内容: モデル監視ジョブで使用するMLコンピューティングインスタンスの数を指定します。
    #       # 設定可能な値: 正の整数
    #       instance_count = 1

    #       # instance_type (Required)
    #       # 設定内容: 処理ジョブで使用するMLコンピューティングインスタンスタイプを指定します。
    #       # 設定可能な値: ml.t3.medium, ml.m5.xlarge, ml.c5.xlarge 等のSageMaker対応インスタンスタイプ
    #       instance_type = "ml.t3.medium"

    #       # volume_size_in_gb (Required)
    #       # 設定内容: プロビジョニングするMLストレージボリュームのサイズをGBで指定します。
    #       # 設定可能な値: 正の整数（GB単位）
    #       volume_size_in_gb = 20

    #       # volume_kms_key_id (Optional)
    #       # 設定内容: ストレージボリュームのデータを暗号化するKMSキーを指定します。
    #       # 設定可能な値: 有効なKMSキーARNまたはキーID
    #       # 省略時: デフォルトのAWS管理キーが使用されます
    #       volume_kms_key_id = null
    #     }
    #   }

    #   #-------------------------------------------------------------
    #   # ネットワーク設定
    #   #-------------------------------------------------------------

    #   # network_config (Optional)
    #   # 設定内容: 監視ジョブのネットワーク設定を指定します。
    #   # network_config {

    #   #   # enable_inter_container_traffic_encryption (Optional)
    #   #   # 設定内容: インスタンス間の通信を暗号化するかを指定します。
    #   #   # 設定可能な値: true / false
    #   #   # 省略時: false
    #   #   enable_inter_container_traffic_encryption = false

    #   #   # enable_network_isolation (Optional)
    #   #   # 設定内容: コンテナのネットワーク分離を有効にするかを指定します。
    #   #   # 設定可能な値: true / false
    #   #   # 省略時: false
    #   #   enable_network_isolation = false

    #   #   # vpc_config (Optional)
    #   #   # 設定内容: VPCアクセスの設定ブロックです。
    #   #   vpc_config {

    #   #     # security_group_ids (Required)
    #   #     # 設定内容: VPCのセキュリティグループIDのセットを指定します。
    #   #     # 設定可能な値: sg-xxxxxxxx 形式の有効なセキュリティグループID
    #   #     security_group_ids = ["sg-12345678"]

    #   #     # subnets (Required)
    #   #     # 設定内容: VPC内のサブネットIDのセットを指定します。
    #   #     # 設定可能な値: 有効なサブネットID
    #   #     # 注意: 高可用性のため複数AZにわたるサブネットの指定を推奨
    #   #     subnets = ["subnet-12345678", "subnet-87654321"]
    #   #   }
    #   # }

    #   #-------------------------------------------------------------
    #   # 停止条件設定
    #   #-------------------------------------------------------------

    #   # stopping_condition (Optional)
    #   # 設定内容: 監視ジョブの実行時間制限を設定します。
    #   # stopping_condition {

    #   #   # max_runtime_in_seconds (Optional, Computed)
    #   #   # 設定内容: 監視ジョブが実行できる最大時間（秒単位）を指定します。
    #   #   # 設定可能な値: 正の整数（秒単位）
    #   #   # 省略時: SageMakerのデフォルト値が使用されます
    #   #   max_runtime_in_seconds = 3600
    #   # }
    # }
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
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/tagging.html
  tags = {
    Name        = "example-monitoring-schedule"
    Environment = "production"
    Purpose     = "data-quality-monitoring"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: モニタリングスケジュールのAmazon Resource Name (ARN)
# - name: モニタリングスケジュールの名前
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
