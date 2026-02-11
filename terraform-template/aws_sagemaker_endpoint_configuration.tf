#---------------------------------------------------------------
# Amazon SageMaker Endpoint Configuration
#---------------------------------------------------------------
#
# Amazon SageMaker AIのエンドポイント設定をプロビジョニングするリソースです。
# エンドポイント設定では、デプロイするモデル、使用するMLコンピューティングインスタンスのタイプと数、
# 非同期推論、データキャプチャ、暗号化などの設定を定義します。
#
# AWS公式ドキュメント:
#   - CreateEndpointConfig API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateEndpointConfig.html
#   - SageMaker Inference Options: https://docs.aws.amazon.com/sagemaker/latest/dg/deploy-model-options.html
#   - Data Capture: https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-capture.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_endpoint_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_endpoint_configuration" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: エンドポイント設定の名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  name = "my-endpoint-config"

  # name_prefix (Optional)
  # 設定内容: エンドポイント設定名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

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
  # IAMロール設定
  #-------------------------------------------------------------

  # execution_role_arn (Optional)
  # 設定内容: SageMaker AIがユーザーに代わってアクションを実行するために引き受けることができるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 省略時: 指定なし
  # 注意: production_variantsでmodel_nameが指定されていない場合（Inference Componentsをサポートする場合）は必須です。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateEndpointConfig.html
  execution_role_arn = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_arn (Optional)
  # 設定内容: エンドポイントをホストするMLコンピューティングインスタンスに接続されたストレージボリューム上のデータを暗号化するためにSageMaker AIが使用するAWS KMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: 暗号化なし
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateEndpointConfig.html
  kms_key_arn = null

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
    Name        = "my-endpoint-config"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # Production Variants設定（必須）
  #-------------------------------------------------------------

  # production_variants (Required)
  # 設定内容: このエンドポイントでホストする各モデルを定義します。
  # 設定可能な値: リストブロック（1〜10個）
  # 関連機能: Production Variant
  #   デプロイするモデルとそのリソース（MLコンピューティングインスタンスの数と種類）を指定します。
  #   複数のモデルをホストする場合、VariantWeightを割り当ててトラフィック配分を指定できます。
  #   - https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateEndpointConfig.html
  production_variants {
    # variant_name (Optional)
    # 設定内容: バリアントの名前を指定します。
    # 設定可能な値: 文字列
    # 省略時: Terraformがランダムな一意の名前を生成します。
    variant_name = "variant-1"

    # model_name (Optional)
    # 設定内容: 使用するモデルの名前を指定します。
    # 設定可能な値: SageMakerモデルリソースの名前
    # 省略時: 指定なし
    # 注意: Inference Componentsを使用する場合を除き必須です（その場合はexecution_role_arnをエンドポイント設定レベルで指定する必要があります）。
    model_name = "my-model"

    # initial_instance_count (Optional)
    # 設定内容: オートスケーリングに使用する初期インスタンス数を指定します。
    # 設定可能な値: 正の整数
    # 省略時: 指定なし
    initial_instance_count = 1

    # instance_type (Optional)
    # 設定内容: 起動するインスタンスのタイプを指定します。
    # 設定可能な値: MLインスタンスタイプ（例: ml.t2.medium, ml.m5.xlarge, ml.p3.2xlarge）
    # 省略時: 指定なし
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/deploy-model-options.html
    instance_type = "ml.t2.medium"

    # initial_variant_weight (Optional)
    # 設定内容: エンドポイント設定で指定したすべてのモデル間の初期トラフィック配分を指定します。
    # 設定可能な値: 数値（0以上）
    # 省略時: 1.0
    # 注意: model_nameが設定されていない場合（Inference Componentsエンドポイント）は無視されます。
    initial_variant_weight = 1.0

    # accelerator_type (Optional)
    # 設定内容: プロダクションバリアントに使用するElastic Inference (EI)インスタンスのサイズを指定します。
    # 設定可能な値: EIアクセラレータタイプ（例: ml.eia1.medium, ml.eia2.xlarge）
    # 省略時: 指定なし
    accelerator_type = null

    # volume_size_in_gb (Optional)
    # 設定内容: プロダクションバリアントに関連付けられた個々の推論インスタンスに接続されたMLストレージボリュームのサイズ（GB単位）を指定します。
    # 設定可能な値: 1〜512の整数
    # 省略時: デフォルト値が使用されます
    volume_size_in_gb = null

    # container_startup_health_check_timeout_in_seconds (Optional)
    # 設定内容: SageMaker AIホスティングがヘルスチェックを通過するための推論コンテナのタイムアウト値（秒単位）を指定します。
    # 設定可能な値: 60〜3600の整数
    # 省略時: デフォルト値が使用されます
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/your-algorithms-inference-code.html#your-algorithms-inference-algo-ping-requests
    container_startup_health_check_timeout_in_seconds = null

    # model_data_download_timeout_in_seconds (Optional)
    # 設定内容: S3からこのプロダクションバリアントに関連付けられた個々の推論インスタンスにホストするモデルをダウンロードして抽出するためのタイムアウト値（秒単位）を指定します。
    # 設定可能な値: 60〜3600の整数
    # 省略時: デフォルト値が使用されます
    model_data_download_timeout_in_seconds = null

    # enable_ssm_access (Optional)
    # 設定内容: エンドポイントの背後にあるプロダクションバリアントに対してネイティブAWS SSMアクセスを有効にするかを指定します。
    # 設定可能な値:
    #   - true: SSMアクセスを有効化
    #   - false (デフォルト): SSMアクセスを無効化
    # 省略時: false
    # 注意: model_nameが設定されていない場合（Inference Componentsエンドポイント）は無視されます。
    enable_ssm_access = null

    # inference_ami_version (Optional)
    # 設定内容: 事前構成されたAMIイメージのコレクションからのオプションを指定します。各イメージはAWSによってソフトウェアとドライバーのバージョンのセットで構成されています。AWSはさまざまな機械学習ワークロード向けにこれらの構成を最適化しています。
    # 設定可能な値: AMIバージョン文字列
    # 省略時: 指定なし
    inference_ami_version = null

    #-----------------------------------------------------------
    # Serverless設定
    #-----------------------------------------------------------

    # serverless_config (Optional)
    # 設定内容: サーバーレス推論の設定を指定します。
    # 設定可能な値: ブロック
    # 省略時: 指定なし
    # 関連機能: Serverless Inference
    #   間欠的または予測不可能なトラフィックパターンに最適です。インフラストラクチャを管理し、自動的にスケーリングします。
    #   ペイロードサイズは最大4MB、処理時間は最大60秒をサポートします。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/deploy-model-options.html
    # serverless_config {
    #   # max_concurrency (Required)
    #   # 設定内容: サーバーレスエンドポイントが処理できる同時呼び出しの最大数を指定します。
    #   # 設定可能な値: 1〜200の整数
    #   max_concurrency = 10
    #
    #   # memory_size_in_mb (Required)
    #   # 設定内容: サーバーレスエンドポイントのメモリサイズを指定します。
    #   # 設定可能な値: 1024, 2048, 3072, 4096, 5120, 6144（1GB単位）
    #   memory_size_in_mb = 2048
    #
    #   # provisioned_concurrency (Optional)
    #   # 設定内容: サーバーレスエンドポイントに割り当てるプロビジョンド同時実行数を指定します。
    #   # 設定可能な値: 1〜200の整数（max_concurrency以下）
    #   # 省略時: 指定なし
    #   provisioned_concurrency = null
    # }

    #-----------------------------------------------------------
    # Managed Instance Scaling設定
    #-----------------------------------------------------------

    # managed_instance_scaling (Optional)
    # 設定内容: トラフィックの増減に応じてエンドポイントがスケールアップまたはスケールダウンする際にプロビジョニングするインスタンス数の範囲を制御します。
    # 設定可能な値: ブロック
    # 省略時: 指定なし
    # managed_instance_scaling {
    #   # status (Optional)
    #   # 設定内容: マネージドインスタンススケーリングが有効かどうかを指定します。
    #   # 設定可能な値:
    #   #   - "ENABLED": 有効化
    #   #   - "DISABLED": 無効化
    #   # 省略時: 指定なし
    #   status = "ENABLED"
    #
    #   # min_instance_count (Optional)
    #   # 設定内容: トラフィックの減少に対応してエンドポイントがスケールダウンする際に保持する必要がある最小インスタンス数を指定します。
    #   # 設定可能な値: 正の整数
    #   # 省略時: 指定なし
    #   min_instance_count = 1
    #
    #   # max_instance_count (Optional)
    #   # 設定内容: トラフィックの増加に対応してエンドポイントがスケールアップする際にプロビジョニングできる最大インスタンス数を指定します。
    #   # 設定可能な値: 正の整数
    #   # 省略時: 指定なし
    #   max_instance_count = 10
    # }

    #-----------------------------------------------------------
    # Routing設定
    #-----------------------------------------------------------

    # routing_config (Optional)
    # 設定内容: エンドポイントが受信トラフィックをルーティングする方法を指定します。
    # 設定可能な値: ブロック
    # 省略時: 指定なし
    # routing_config {
    #   # routing_strategy (Required)
    #   # 設定内容: エンドポイントが受信トラフィックをルーティングする方法を指定します。
    #   # 設定可能な値:
    #   #   - "LEAST_OUTSTANDING_REQUESTS": 処理能力の高い特定のインスタンスにリクエストをルーティング
    #   #   - "RANDOM": 各リクエストをランダムに選択されたインスタンスにルーティング
    #   routing_strategy = "LEAST_OUTSTANDING_REQUESTS"
    # }

    #-----------------------------------------------------------
    # Core Dump設定
    #-----------------------------------------------------------

    # core_dump_config (Optional)
    # 設定内容: プロセスがクラッシュした際のモデルコンテナからのコアダンプ設定を指定します。
    # 設定可能な値: ブロック
    # 省略時: 指定なし
    # core_dump_config {
    #   # destination_s3_uri (Required)
    #   # 設定内容: コアダンプを送信するS3バケットを指定します。
    #   # 設定可能な値: S3 URI
    #   destination_s3_uri = "s3://my-bucket/core-dumps/"
    #
    #   # kms_key_id (Optional for production_variants, Required for shadow_production_variants)
    #   # 設定内容: SageMaker AIがS3サーバー側暗号化を使用してコアダンプデータを暗号化するために使用するKMSキーを指定します。
    #   # 設定可能な値: KMSキーID、キーARN、エイリアス名、またはエイリアス名ARN
    #   # 省略時: 指定なし（production_variantsの場合）
    #   # 注意: shadow_production_variantsの場合は必須です。
    #   kms_key_id = null
    # }
  }

  #-------------------------------------------------------------
  # Shadow Production Variants設定
  #-------------------------------------------------------------

  # shadow_production_variants (Optional)
  # 設定内容: production_variantsで指定したモデルからレプリケートされたプロダクショントラフィックを使用してシャドウモードでこのエンドポイントでホストするモデルを定義します。
  # 設定可能な値: リストブロック（最大10個）
  # 省略時: 指定なし
  # 注意: このフィールドを使用する場合、production_variantsには1つのバリアントのみ、shadow_production_variantsには1つのバリアントのみ指定できます。
  # 関連機能: Shadow Testing
  #   新しいモデルを本番環境にデプロイする前に、ライブ推論リクエストを使用して現在デプロイされているモデルと比較評価できます。
  #   - https://docs.aws.amazon.com/sagemaker-ai/deploy/
  # 注意: shadow_production_variantsの構造はproduction_variantsと同じです。
  # shadow_production_variants {
  #   variant_name           = "shadow-variant-1"
  #   model_name             = "my-shadow-model"
  #   initial_instance_count = 1
  #   instance_type          = "ml.t2.medium"
  # }

  #-------------------------------------------------------------
  # Data Capture設定
  #-------------------------------------------------------------

  # data_capture_config (Optional)
  # 設定内容: SageMaker AIモデルエンドポイントの入力/出力をキャプチャするパラメータを指定します。
  # 設定可能な値: ブロック
  # 省略時: 指定なし
  # 関連機能: Data Capture
  #   エンドポイントの入力と出力をAmazon S3にログ記録して、トレーニング、デバッグ、監視に使用できます。
  #   キャプチャされたデータは、Amazon SageMaker Model Monitorでデータとモデル品質の分析に使用できます。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-capture.html
  # data_capture_config {
  #   # destination_s3_uri (Required)
  #   # 設定内容: キャプチャされたデータを保存するS3の場所のURLを指定します。
  #   # 設定可能な値: S3 URI
  #   destination_s3_uri = "s3://my-bucket/data-capture/"
  #
  #   # initial_sampling_percentage (Required)
  #   # 設定内容: キャプチャするデータの割合を指定します。
  #   # 設定可能な値: 0〜100の整数
  #   # 注意: トラフィックの多いエンドポイントには低い値が推奨されます。
  #   initial_sampling_percentage = 100
  #
  #   # enable_capture (Optional)
  #   # 設定内容: データキャプチャを有効にするフラグを指定します。
  #   # 設定可能な値:
  #   #   - true: 有効化
  #   #   - false (デフォルト): 無効化
  #   # 省略時: false
  #   enable_capture = true
  #
  #   # kms_key_id (Optional)
  #   # 設定内容: SageMaker AIがS3上のキャプチャされたデータを暗号化するために使用するKMSキーのARNを指定します。
  #   # 設定可能な値: KMSキーARN
  #   # 省略時: 暗号化なし
  #   # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_DataCaptureConfig.html
  #   kms_key_id = null
  #
  #   #---------------------------------------------------------
  #   # Capture Options設定（必須）
  #   #---------------------------------------------------------
  #
  #   # capture_options (Required)
  #   # 設定内容: キャプチャするデータを指定します。
  #   # 設定可能な値: リストブロック（1〜2個）
  #   capture_options {
  #     # capture_mode (Required)
  #     # 設定内容: キャプチャするデータを指定します。
  #     # 設定可能な値:
  #     #   - "Input": 入力のみ
  #     #   - "Output": 出力のみ
  #     #   - "InputAndOutput": 入力と出力の両方
  #     capture_mode = "Input"
  #   }
  #
  #   capture_options {
  #     capture_mode = "Output"
  #   }
  #
  #   #---------------------------------------------------------
  #   # Capture Content Type Header設定
  #   #---------------------------------------------------------
  #
  #   # capture_content_type_header (Optional)
  #   # 設定内容: キャプチャするコンテンツタイプヘッダーを指定します。
  #   # 設定可能な値: ブロック
  #   # 省略時: 指定なし（SageMaker AIはデータをbase64エンコードします）
  #   # capture_content_type_header {
  #   #   # csv_content_types (Optional)
  #   #   # 設定内容: キャプチャするCSVコンテンツタイプヘッダーを指定します。
  #   #   # 設定可能な値: 文字列のセット
  #   #   # 省略時: 指定なし
  #   #   # 注意: csv_content_typesまたはjson_content_typesのいずれかが必須です。
  #   #   csv_content_types = ["text/csv"]
  #   #
  #   #   # json_content_types (Optional)
  #   #   # 設定内容: キャプチャするJSONコンテンツタイプヘッダーを指定します。
  #   #   # 設定可能な値: 文字列のセット
  #   #   # 省略時: 指定なし
  #   #   # 注意: json_content_typesまたはcsv_content_typesのいずれかが必須です。
  #   #   json_content_types = ["application/json"]
  #   # }
  # }

  #-------------------------------------------------------------
  # Async Inference設定
  #-------------------------------------------------------------

  # async_inference_config (Optional)
  # 設定内容: エンドポイントが非同期推論を実行する方法を指定します。
  # 設定可能な値: ブロック
  # 省略時: 指定なし
  # 関連機能: Asynchronous Inference
  #   大きなペイロード（最大1GB）または長い処理時間（最大1時間）を持つリクエストをキューイングするのに最適です。
  #   リクエストがない場合は0にスケールダウンできます。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/deploy-model-options.html
  # async_inference_config {
  #   #---------------------------------------------------------
  #   # Client設定
  #   #---------------------------------------------------------
  #
  #   # client_config (Optional)
  #   # 設定内容: SageMaker AIが非同期推論中にモデルコンテナと対話するために使用するクライアントの動作を設定します。
  #   # 設定可能な値: ブロック
  #   # 省略時: 指定なし
  #   # client_config {
  #   #   # max_concurrent_invocations_per_instance (Optional)
  #   #   # 設定内容: SageMaker AIクライアントがモデルコンテナに送信する同時リクエストの最大数を指定します。
  #   #   # 設定可能な値: 正の整数
  #   #   # 省略時: SageMaker AIが最適な値を選択します
  #   #   max_concurrent_invocations_per_instance = null
  #   # }
  #
  #   #---------------------------------------------------------
  #   # Output設定（必須）
  #   #---------------------------------------------------------
  #
  #   # output_config (Required)
  #   # 設定内容: 非同期推論呼び出し出力の設定を指定します。
  #   # 設定可能な値: ブロック
  #   output_config {
  #     # s3_output_path (Required)
  #     # 設定内容: 推論レスポンスをアップロードするS3の場所を指定します。
  #     # 設定可能な値: S3 URI
  #     s3_output_path = "s3://my-bucket/async-inference-output/"
  #
  #     # s3_failure_path (Optional)
  #     # 設定内容: 失敗した推論レスポンスをアップロードするS3の場所を指定します。
  #     # 設定可能な値: S3 URI
  #     # 省略時: 指定なし
  #     s3_failure_path = "s3://my-bucket/async-inference-failures/"
  #
  #     # kms_key_id (Optional)
  #     # 設定内容: SageMaker AIがS3の非同期推論出力を暗号化するために使用するKMSキーを指定します。
  #     # 設定可能な値: KMSキーID、キーARN、エイリアス名、またはエイリアス名ARN
  #     # 省略時: 暗号化なし
  #     kms_key_id = null
  #
  #     #-------------------------------------------------------
  #     # Notification設定
  #     #-------------------------------------------------------
  #
  #     # notification_config (Optional)
  #     # 設定内容: 非同期推論の推論結果の通知設定を指定します。
  #     # 設定可能な値: ブロック
  #     # 省略時: 指定なし
  #     # notification_config {
  #     #   # success_topic (Optional)
  #     #   # 設定内容: 推論が正常に完了したときに通知を投稿するSNSトピックを指定します。
  #     #   # 設定可能な値: SNSトピックARN
  #     #   # 省略時: 成功時に通知は送信されません
  #     #   success_topic = null
  #     #
  #     #   # error_topic (Optional)
  #     #   # 設定内容: 推論が失敗したときに通知を投稿するSNSトピックを指定します。
  #     #   # 設定可能な値: SNSトピックARN
  #     #   # 省略時: 失敗時に通知は送信されません
  #     #   error_topic = null
  #     #
  #     #   # include_inference_response_in (Optional)
  #     #   # 設定内容: 推論レスポンスを含めるSNSトピックを指定します。
  #     #   # 設定可能な値:
  #     #   #   - "SUCCESS_NOTIFICATION_TOPIC": 成功通知トピックに含める
  #     #   #   - "ERROR_NOTIFICATION_TOPIC": エラー通知トピックに含める
  #     #   # 省略時: 指定なし
  #     #   include_inference_response_in = []
  #     # }
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AWSによってこのエンドポイント設定に割り当てられたARN
#
# - name: エンドポイント設定の名前
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
