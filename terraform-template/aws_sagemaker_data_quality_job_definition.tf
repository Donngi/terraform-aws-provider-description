#---------------------------------------------------------------
# Amazon SageMaker Data Quality Job Definition
#---------------------------------------------------------------
#
# Amazon SageMaker Model Monitorのデータ品質監視ジョブ定義をプロビジョニングするリソースです。
# 本番環境のMLモデルに対してデータドリフトやデータ品質の問題を自動検出するために
# 使用する監視ジョブの設定を定義します。リアルタイムエンドポイントまたは
# バッチ変換ジョブの入力データを対象として監視できます。
#
# AWS公式ドキュメント:
#   - データ品質モニタリング概要: https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html
#   - CreateDataQualityJobDefinition API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateDataQualityJobDefinition.html
#   - Model Monitor: https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_data_quality_job_definition
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_data_quality_job_definition" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: データ品質ジョブ定義の名前を指定します。
  # 設定可能な値: 1-63文字の英数字とハイフン
  # 省略時: Terraformがランダムな一意の名前を生成します。
  name = "my-data-quality-job-definition"

  # role_arn (Required)
  # 設定内容: SageMaker AIがタスクを実行するために引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: ロールにはS3へのアクセス権限やCloudWatchへの書き込み権限が必要です。
  role_arn = "arn:aws:iam::123456789012:role/sagemaker-monitoring-role"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # アプリケーション仕様設定
  #-------------------------------------------------------------

  # data_quality_app_specification (Required)
  # 設定内容: 監視ジョブを実行するコンテナの仕様を指定するブロックです。
  # 関連機能: SageMaker Model Monitor コンテナ設定
  #   データ品質監視ジョブで使用するDockerコンテナのイメージやスクリプトを設定します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html
  data_quality_app_specification {

    # image_uri (Required)
    # 設定内容: データ品質監視ジョブを実行するコンテナイメージのURIを指定します。
    # 設定可能な値: 有効なECRイメージURI（SageMaker提供の組み込みイメージまたはカスタムイメージ）
    # 参考: aws_sagemaker_prebuilt_ecr_image データソースを使用して組み込みイメージのURIを取得可能
    image_uri = "123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/sagemaker-model-monitor-analyzer:latest"

    # environment (Optional)
    # 設定内容: 監視ジョブを実行するコンテナに設定する環境変数のマップを指定します。
    # 設定可能な値: 文字列のキーバリューマップ
    # 省略時: 環境変数は設定されません。
    environment = {
      PUBLISH_CLOUDWATCH_METRICS = "Enabled"
    }

    # record_preprocessor_source_uri (Optional)
    # 設定内容: 分析前に各行に対して呼び出されるスクリプトのAmazon S3 URIを指定します。
    # 設定可能な値: 有効なAmazon S3 URI
    # 省略時: 前処理スクリプトは使用されません。
    # 注意: 組み込み（ファーストパーティ）コンテナにのみ適用されます。
    #       ペイロードをbase64デコードしてフラット化されたJSONに変換するために使用できます。
    record_preprocessor_source_uri = null

    # post_analytics_processor_source_uri (Optional)
    # 設定内容: 分析実行後に呼び出されるスクリプトのAmazon S3 URIを指定します。
    # 設定可能な値: 有効なAmazon S3 URI
    # 省略時: 後処理スクリプトは使用されません。
    # 注意: 組み込み（ファーストパーティ）コンテナにのみ適用されます。
    post_analytics_processor_source_uri = null
  }

  #-------------------------------------------------------------
  # ベースライン設定
  #-------------------------------------------------------------

  # data_quality_baseline_config (Optional)
  # 設定内容: 監視ジョブの制約とベースラインを設定するブロックです。
  # 関連機能: SageMaker Model Monitor ベースライン
  #   トレーニングデータに基づいて作成したベースラインの制約・統計情報を参照して
  #   データドリフトを検出します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html
  data_quality_baseline_config {

    # constraints_resource (Optional)
    # 設定内容: 監視ジョブの制約リソースを指定するブロックです。
    # 設定内容: ベースラインジョブで生成された制約ファイルのS3の場所を参照します。
    constraints_resource {

      # s3_uri (Optional)
      # 設定内容: 制約リソースのAmazon S3 URIを指定します。
      # 設定可能な値: 有効なAmazon S3 URI（constraints.jsonファイルを指す）
      # 省略時: 制約リソースは使用されません。
      s3_uri = "s3://my-monitoring-bucket/baseline/constraints.json"
    }

    # statistics_resource (Optional)
    # 設定内容: 監視ジョブの統計リソースを指定するブロックです。
    # 設定内容: ベースラインジョブで生成された統計情報ファイルのS3の場所を参照します。
    statistics_resource {

      # s3_uri (Optional)
      # 設定内容: 統計リソースのAmazon S3 URIを指定します。
      # 設定可能な値: 有効なAmazon S3 URI（statistics.jsonファイルを指す）
      # 省略時: 統計リソースは使用されません。
      s3_uri = "s3://my-monitoring-bucket/baseline/statistics.json"
    }
  }

  #-------------------------------------------------------------
  # ジョブ入力設定
  #-------------------------------------------------------------

  # data_quality_job_input (Required)
  # 設定内容: 監視ジョブの入力データソースを指定するブロックです。
  # 注意: batch_transform_input と endpoint_input のどちらか一方を指定します。
  # 関連機能: SageMaker Model Monitor 入力設定
  #   リアルタイムエンドポイントまたはバッチ変換ジョブのキャプチャデータを監視対象にします。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-schedule-data-monitor.html
  data_quality_job_input {

    # endpoint_input (Optional)
    # 設定内容: エンドポイントを入力ソースとして使用する場合の設定ブロックです。
    # 設定内容: data_capture_configが有効なリアルタイムエンドポイントを対象とします。
    endpoint_input {

      # endpoint_name (Required)
      # 設定内容: data_capture_configが有効な顧客アカウントのエンドポイント名を指定します。
      # 設定可能な値: 既存のSageMakerエンドポイント名
      endpoint_name = "my-sagemaker-endpoint"

      # local_path (Optional)
      # 設定内容: コンテナからエンドポイントデータにアクセスするファイルシステムのパスを指定します。
      # 設定可能な値: 有効なローカルファイルシステムパス
      # 省略時: /opt/ml/processing/input が使用されます。
      local_path = "/opt/ml/processing/input"

      # s3_input_mode (Optional)
      # 設定内容: 監視ジョブのデータ転送に使用する入力モードを指定します。
      # 設定可能な値:
      #   - "Pipe": パイプモード。大規模データセットに推奨。ストリーミングで転送
      #   - "File": ファイルモード。メモリに収まる小規模ファイルに適用
      # 省略時: "File" が使用されます。
      s3_input_mode = "File"

      # s3_data_distribution_type (Optional)
      # 設定内容: Amazon S3上の入力データの分散方式を指定します。
      # 設定可能な値:
      #   - "FullyReplicated": 全データを全インスタンスにレプリケート
      #   - "ShardedByS3Key": S3キーによりデータをシャーディング
      # 省略時: "FullyReplicated" が使用されます。
      s3_data_distribution_type = "FullyReplicated"
    }

    # batch_transform_input (Optional)
    # 設定内容: バッチ変換ジョブを入力ソースとして使用する場合の設定ブロックです。
    # 注意: endpoint_input と排他的。どちらか一方のみ指定可能です。
    # batch_transform_input {

    #   # data_captured_destination_s3_uri (Required)
    #   # 設定内容: データキャプチャに使用するAmazon S3の場所を指定します。
    #   # 設定可能な値: 有効なAmazon S3 URI
    #   data_captured_destination_s3_uri = "s3://my-bucket/data-capture/"

    #   # dataset_format (Required)
    #   # 設定内容: バッチ変換ジョブのデータセットフォーマットを指定するブロックです。
    #   dataset_format {

    #     # csv (Optional)
    #     # 設定内容: 監視ジョブで使用するCSVデータセットの設定ブロックです。
    #     csv {

    #       # header (Optional)
    #       # 設定内容: CSVデータにヘッダー行が含まれるかを指定します。
    #       # 設定可能な値:
    #       #   - true: ヘッダー行あり
    #       #   - false: ヘッダー行なし
    #       # 省略時: false
    #       header = true
    #     }

    #     # json (Optional)
    #     # 設定内容: 監視ジョブで使用するJSONデータセットの設定ブロックです。
    #     json {

    #       # line (Optional)
    #       # 設定内容: ファイルを1行1JSONオブジェクトとして読み込むかを指定します。
    #       # 設定可能な値:
    #       #   - true: JSONLines形式（1行1オブジェクト）として読み込む
    #       #   - false: 標準JSON形式として読み込む
    #       # 省略時: false
    #       line = true
    #     }
    #   }

    #   # local_path (Optional)
    #   # 設定内容: コンテナからバッチ変換データにアクセスするファイルシステムのパスを指定します。
    #   # 設定可能な値: 有効なローカルファイルシステムパス
    #   # 省略時: /opt/ml/processing/input が使用されます。
    #   local_path = "/opt/ml/processing/input"

    #   # s3_input_mode (Optional)
    #   # 設定内容: 監視ジョブのデータ転送に使用する入力モードを指定します。
    #   # 設定可能な値:
    #   #   - "Pipe": パイプモード。大規模データセットに推奨
    #   #   - "File": ファイルモード。小規模ファイルに適用
    #   # 省略時: "File" が使用されます。
    #   s3_input_mode = "File"

    #   # s3_data_distribution_type (Optional)
    #   # 設定内容: Amazon S3上の入力データの分散方式を指定します。
    #   # 設定可能な値:
    #   #   - "FullyReplicated": 全データを全インスタンスにレプリケート
    #   #   - "ShardedByS3Key": S3キーによりデータをシャーディング
    #   # 省略時: "FullyReplicated" が使用されます。
    #   s3_data_distribution_type = "FullyReplicated"
    # }
  }

  #-------------------------------------------------------------
  # ジョブ出力設定
  #-------------------------------------------------------------

  # data_quality_job_output_config (Required)
  # 設定内容: 監視ジョブの出力設定を指定するブロックです。
  # 関連機能: SageMaker Model Monitor 出力設定
  #   定期的な監視ジョブの出力がアップロードされる場所と暗号化設定を定義します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html
  data_quality_job_output_config {

    # kms_key_id (Optional)
    # 設定内容: Amazon S3サーバーサイド暗号化でモデルアーティファクトを暗号化するために
    #           使用するAWS KMSキーを指定します。
    # 設定可能な値: 有効なKMSキーARNまたはキーID
    # 省略時: 暗号化にはデフォルトのS3管理キーが使用されます。
    kms_key_id = null

    # monitoring_outputs (Required)
    # 設定内容: 監視ジョブの出力先を指定するブロックです。
    # 設定内容: 定期的な監視ジョブの出力がアップロードされる場所を定義します。
    monitoring_outputs {

      # s3_output (Required)
      # 設定内容: 監視ジョブの結果を保存するAmazon S3ストレージの設定ブロックです。
      s3_output {

        # s3_uri (Required)
        # 設定内容: SageMaker AIが監視ジョブの結果を保存するAmazon S3のURIを指定します。
        # 設定可能な値: 有効なAmazon S3 URI
        s3_uri = "s3://my-monitoring-bucket/output/"

        # local_path (Optional)
        # 設定内容: SageMaker AIが監視ジョブの結果を保存するローカルパスを指定します。
        # 設定可能な値: 有力なローカルファイルシステムの絶対パス
        # 省略時: /opt/ml/processing/output が使用されます。
        local_path = "/opt/ml/processing/output"

        # s3_upload_mode (Optional)
        # 設定内容: 監視ジョブの結果をアップロードするタイミングを指定します。
        # 設定可能な値:
        #   - "Continuous": ジョブ実行中に継続的にアップロード
        #   - "EndOfJob": ジョブ完了後にまとめてアップロード
        # 省略時: "Continuous" が使用されます。
        s3_upload_mode = "EndOfJob"
      }
    }
  }

  #-------------------------------------------------------------
  # ジョブリソース設定
  #-------------------------------------------------------------

  # job_resources (Required)
  # 設定内容: 監視ジョブを実行するためのリソースを指定するブロックです。
  # 関連機能: SageMaker Model Monitor クラスター設定
  #   MLコンピューティングインスタンスの数やタイプ、ストレージサイズを設定します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html
  job_resources {

    # cluster_config (Required)
    # 設定内容: 処理ジョブの実行に使用するクラスターリソースの設定ブロックです。
    cluster_config {

      # instance_count (Required)
      # 設定内容: モデル監視ジョブで使用するMLコンピューティングインスタンスの数を指定します。
      # 設定可能な値: 正の整数
      # 注意: 分散処理ジョブの場合は1より大きい値を指定してください。
      instance_count = 1

      # instance_type (Required)
      # 設定内容: 処理ジョブで使用するMLコンピューティングインスタンスタイプを指定します。
      # 設定可能な値: ml.t3.medium, ml.m5.xlarge, ml.c5.xlarge 等のSageMaker対応インスタンスタイプ
      instance_type = "ml.t3.medium"

      # volume_size_in_gb (Required)
      # 設定内容: プロビジョニングするMLストレージボリュームのサイズをGBで指定します。
      # 設定可能な値: 正の整数（GB単位）
      # 注意: 監視シナリオに十分なMLストレージを指定する必要があります。
      volume_size_in_gb = 20

      # volume_kms_key_id (Optional)
      # 設定内容: モデル監視ジョブを実行するMLコンピューティングインスタンスに
      #           アタッチされたストレージボリュームのデータを暗号化するKMSキーを指定します。
      # 設定可能な値: 有効なKMSキーARNまたはキーID
      # 省略時: 暗号化にはデフォルトのAWS管理キーが使用されます。
      volume_kms_key_id = null
    }
  }

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # network_config (Optional)
  # 設定内容: 監視ジョブのネットワーク設定を指定するブロックです。
  # 関連機能: SageMaker Model Monitor ネットワーク設定
  #   VPC内のリソースへのアクセスやコンテナ間通信の暗号化を設定します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html
  network_config {

    # enable_inter_container_traffic_encryption (Optional)
    # 設定内容: 監視ジョブで使用するインスタンス間のすべての通信を暗号化するかを指定します。
    # 設定可能な値:
    #   - true: 通信を暗号化。分散ジョブのセキュリティが向上しますが、処理時間が延びる可能性があります
    #   - false: 通信を暗号化しない
    # 省略時: false
    enable_inter_container_traffic_encryption = false

    # enable_network_isolation (Optional)
    # 設定内容: 監視ジョブのコンテナへのインバウンド/アウトバウンドのネットワーク呼び出しを
    #           許可するかを指定します。
    # 設定可能な値:
    #   - true: ネットワーク分離を有効化。外部への通信をブロック
    #   - false: 通常のネットワークアクセスを許可
    # 省略時: false
    enable_network_isolation = false

    # vpc_config (Optional)
    # 設定内容: トレーニングジョブとホストモデルがアクセスするVPCの設定ブロックです。
    # 関連機能: SageMaker VPCアクセス設定
    #   VPC内のリソース（RDS、ElastiCache等）へのアクセスを制御します。
    #   カスタムVPCでSageMaker Studioを起動する場合は、VPCエンドポイントの作成が必要です。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html
    vpc_config {

      # security_group_ids (Required)
      # 設定内容: VPCに対して指定するセキュリティグループIDのセットを指定します。
      # 設定可能な値: sg-xxxxxxxx 形式の有効なセキュリティグループIDのセット
      # 注意: subnets フィールドで指定したVPCのセキュリティグループを指定してください。
      security_group_ids = ["sg-12345678"]

      # subnets (Required)
      # 設定内容: トレーニングジョブまたはモデルを接続するVPC内のサブネットIDのセットを指定します。
      # 設定可能な値: 有効なサブネットIDのセット
      # 注意: 高可用性のため、複数のアベイラビリティゾーンにわたるサブネットの指定を推奨します。
      subnets = ["subnet-12345678", "subnet-87654321"]
    }
  }

  #-------------------------------------------------------------
  # 停止条件設定
  #-------------------------------------------------------------

  # stopping_condition (Optional)
  # 設定内容: 監視ジョブが停止するまでの実行時間制限を設定するブロックです。
  # 関連機能: SageMaker Model Monitor 停止条件
  #   実行時間の上限を設定することで、長時間実行されるジョブを自動的に停止できます。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html
  stopping_condition {

    # max_runtime_in_seconds (Optional)
    # 設定内容: 監視ジョブが実行できる最大時間（秒単位）を指定します。
    # 設定可能な値: 正の整数（秒単位）
    # 省略時: SageMakerのデフォルト値が使用されます。
    max_runtime_in_seconds = 3600
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されません。
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-data-quality-job-definition"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: データ品質ジョブ定義に割り当てられたAmazon Resource Name (ARN)
# - name: データ品質ジョブ定義の名前
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
