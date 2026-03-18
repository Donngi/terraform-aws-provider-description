#---------------------------------------------------------------
# Amazon SageMaker Labeling Job
#---------------------------------------------------------------
#
# Amazon SageMaker Ground Truthのラベリングジョブをプロビジョニングするリソースです。
# ラベリングジョブは、機械学習モデルのトレーニングに必要なデータセットへのラベル付けを
# ヒューマンワーカーに委託するためのワークフローを定義します。
# S3上のマニフェストファイルまたはSNSトピック経由のストリーミングデータを入力として、
# ワーカーチームによるアノテーション作業と結果の集約を自動的に管理します。
#
# AWS公式ドキュメント:
#   - Ground Truthの概要: https://docs.aws.amazon.com/sagemaker/latest/dg/sms.html
#   - ラベリングジョブの作成: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-create-labeling-job-api.html
#   - 組み込みタスクタイプ: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-task-types.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_labeling_job
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_labeling_job" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # labeling_job_name (Required)
  # 設定内容: ラベリングジョブの名前を指定します。
  # 設定可能な値: 1-63文字の英数字、ハイフン
  labeling_job_name = "my-labeling-job"

  # label_attribute_name (Required)
  # 設定内容: 出力マニフェストファイルでラベルに使用する属性名を指定します。
  # 設定可能な値: 文字列（出力マニフェストのラベルキーとして使用される）
  label_attribute_name = "label1"

  # role_arn (Required)
  # 設定内容: データラベリング中にSageMaker AIがタスクを実行するために引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: S3へのアクセス権限、Lambda関数の呼び出し権限などが必要です。
  role_arn = "arn:aws:iam::123456789012:role/sagemaker-labeling-role"

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
  # ラベルカテゴリ設定
  #-------------------------------------------------------------

  # label_category_config_s3_uri (Optional)
  # 設定内容: データオブジェクトのラベル付けに使用するカテゴリを定義するファイルのS3 URIを指定します。
  # 設定可能な値: 有効なS3 URI（カテゴリ定義JSONファイルを指す）
  # 省略時: カテゴリ設定ファイルは使用されません
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-named-entity-recg.html
  label_category_config_s3_uri = "s3://my-labeling-bucket/label-categories/categories.json"

  #-------------------------------------------------------------
  # ヒューマンタスク設定
  #-------------------------------------------------------------

  # human_task_config (Required)
  # 設定内容: ヒューマンワーカーがラベリングタスクを完了するために必要な設定情報のブロックです。
  # 関連機能: Ground Truth ヒューマンタスク設定
  #   ワーカーチーム、タスクUI、アノテーション集約Lambda関数などを定義します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/sms-create-labeling-job-api.html
  human_task_config {

    # number_of_human_workers_per_data_object (Required)
    # 設定内容: 各データオブジェクトにラベル付けするヒューマンワーカーの数を指定します。
    # 設定可能な値: 正の整数（通常1〜9）
    number_of_human_workers_per_data_object = 1

    # task_title (Required)
    # 設定内容: ヒューマンワーカータスクのタイトルを指定します。
    # 設定可能な値: 文字列
    task_title = "Named Entity Recognition task"

    # task_description (Required)
    # 設定内容: ヒューマンワーカータスクの説明を指定します。
    # 設定可能な値: 文字列
    task_description = "Apply the labels provided to specific words or phrases within the larger text block."

    # task_time_limit_in_seconds (Required)
    # 設定内容: ワーカーがタスクを完了するために与えられる時間（秒）を指定します。
    # 設定可能な値: 正の整数（秒単位）
    task_time_limit_in_seconds = 28800

    # workteam_arn (Required)
    # 設定内容: タスクを割り当てるワークチームのARNを指定します。
    # 設定可能な値:
    #   - プライベートワークチームのARN: aws_sagemaker_workteam リソースのARN
    #   - パブリックワークフォース（Amazon Mechanical Turk）のARN:
    #     arn:aws:sagemaker:<region>:394669845002:workteam/public-crowd/default
    workteam_arn = "arn:aws:sagemaker:ap-northeast-1:123456789012:workteam/private-crowd/example-team"

    # pre_human_task_lambda_arn (Optional)
    # 設定内容: データオブジェクトをヒューマンワーカーに送信する前に実行されるLambda関数のARNを指定します。
    # 設定可能な値: 有効なLambda関数ARN（AWSが提供する組み込みLambda関数、またはカスタムLambda関数）
    # 省略時: 前処理Lambda関数は使用されません
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-task-types.html
    pre_human_task_lambda_arn = "arn:aws:lambda:ap-northeast-1:081040173940:function:PRE-NamedEntityRecognition"

    # task_availability_lifetime_in_seconds (Optional)
    # 設定内容: タスクがヒューマンワーカーに利用可能な期間（秒）を指定します。
    # 設定可能な値: 正の整数（秒単位）
    # 省略時: デフォルト値が適用されます
    task_availability_lifetime_in_seconds = 86400

    # max_concurrent_task_count (Optional)
    # 設定内容: ヒューマンワーカーが同時にラベル付けできるデータオブジェクトの最大数を指定します。
    # 設定可能な値: 正の整数
    # 省略時: デフォルト値が適用されます
    max_concurrent_task_count = null

    # task_keywords (Optional)
    # 設定内容: ワーカーがタスクを検索しやすくするためのキーワードを指定します。
    # 設定可能な値: 文字列のセット
    # 省略時: キーワードなし
    task_keywords = ["NER", "テキスト", "ラベリング"]

    #-------------------------------------------------------------
    # UIテンプレート設定
    #-------------------------------------------------------------

    # ui_config (Optional)
    # 設定内容: ワーカーUIとラベリングツールのテンプレート設定ブロックです。
    # 関連機能: Ground Truth カスタムタスクテンプレート
    #   human_task_ui_arn または ui_template_s3_uri のどちらか一方を指定します。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/sms-custom-templates.html
    ui_config {

      # human_task_ui_arn (Optional)
      # 設定内容: ワーカータスクテンプレート（ヒューマンタスクUI）のARNを指定します。
      # 設定可能な値: aws_sagemaker_human_task_ui リソースのARN、またはAWS提供の組み込みUIのARN
      # 省略時: ui_template_s3_uri を代わりに使用
      human_task_ui_arn = "arn:aws:sagemaker:ap-northeast-1:394669845002:human-task-ui/NamedEntityRecognition"

      # ui_template_s3_uri (Optional)
      # 設定内容: ワーカータスクテンプレートのS3 URIを指定します。
      # 設定可能な値: 有効なS3 URI（HTMLテンプレートファイルを指す）
      # 省略時: human_task_ui_arn を代わりに使用
      # ui_template_s3_uri = "s3://my-labeling-bucket/ui-template/template.html"
    }

    #-------------------------------------------------------------
    # アノテーション集約設定
    #-------------------------------------------------------------

    # annotation_consolidation_config (Optional)
    # 設定内容: 複数のヒューマンワーカーからのアノテーションを集約する方法を設定するブロックです。
    # 関連機能: Ground Truth アノテーション集約
    #   複数ワーカーの回答から最終ラベルを決定するLambda関数を指定します。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/sms-annotation-consolidation.html
    annotation_consolidation_config {

      # annotation_consolidation_lambda_arn (Required)
      # 設定内容: アノテーション集約と出力データ処理のロジックを実装するLambda関数のARNを指定します。
      # 設定可能な値: 有効なLambda関数ARN（AWSが提供する組み込みLambda関数、またはカスタムLambda関数）
      # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-annotation-consolidation.html
      annotation_consolidation_lambda_arn = "arn:aws:lambda:ap-northeast-1:081040173940:function:ACS-NamedEntityRecognition"
    }

    #-------------------------------------------------------------
    # パブリックワークフォース報酬設定
    #-------------------------------------------------------------

    # public_workforce_task_price (Optional)
    # 設定内容: Amazon Mechanical Turkワーカーに支払う報酬金額の設定ブロックです。
    # 関連機能: Amazon Mechanical Turk ワークフォース
    #   パブリックワークフォースを使用する場合にのみ設定します。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/sms-workforce-management-public.html
    # public_workforce_task_price {

    #   # amount_in_usd (Optional)
    #   # 設定内容: 米国ドル建てで支払う報酬金額の設定ブロックです。
    #   amount_in_usd {

    #     # dollars (Optional)
    #     # 設定内容: 報酬金額のドル単位の整数部分を指定します。
    #     # 設定可能な値: 0以上の整数
    #     # 省略時: 0
    #     dollars = 0

    #     # cents (Optional)
    #     # 設定内容: 報酬金額のセント単位の端数部分を指定します。
    #     # 設定可能な値: 0〜99の整数
    #     # 省略時: 0
    #     cents = 1

    #     # tenth_fractions_of_a_cent (Optional)
    #     # 設定内容: 報酬金額の1/10セント単位の端数部分を指定します。
    #     # 設定可能な値: 0〜9の整数
    #     # 省略時: 0
    #     tenth_fractions_of_a_cent = 2
    #   }
    # }
  }

  #-------------------------------------------------------------
  # 入力データ設定
  #-------------------------------------------------------------

  # input_config (Required)
  # 設定内容: ラベリングジョブの入力データを指定するブロックです。
  # 関連機能: Ground Truth 入力データ
  #   S3マニフェストファイルまたはSNSトピック経由でラベリング対象データを指定します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/sms-data-input.html
  input_config {

    # data_source (Required)
    # 設定内容: 入力データの場所を指定するブロックです。
    # 注意: s3_data_source と sns_data_source のどちらか一方を指定します。
    data_source {

      # s3_data_source (Optional)
      # 設定内容: S3上の入力データオブジェクトの場所を指定するブロックです。
      # 注意: sns_data_source と排他的。バッチラベリングジョブで使用します。
      # s3_data_source {

      #   # manifest_s3_uri (Required)
      #   # 設定内容: 入力データオブジェクトを記述したマニフェストファイルのS3 URIを指定します。
      #   # 設定可能な値: 有効なS3 URI（マニフェストJSONファイルを指す）
      #   manifest_s3_uri = "s3://my-labeling-bucket/input/manifest.json"
      # }

      # sns_data_source (Optional)
      # 設定内容: ストリーミングラベリングジョブで使用するSNSデータソースの設定ブロックです。
      # 注意: s3_data_source と排他的。ストリーミングラベリングジョブで使用します。
      sns_data_source {

        # sns_topic_arn (Required)
        # 設定内容: SNS入力トピックのARNを指定します。
        # 設定可能な値: 有効なSNSトピックARN
        sns_topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:labeling-input-topic"
      }
    }

    # data_attributes (Optional)
    # 設定内容: データの属性に関する設定ブロックです。
    # 関連機能: コンテンツ分類
    #   データに個人情報やアダルトコンテンツが含まれていないことを宣言します。
    data_attributes {

      # content_classifiers (Optional)
      # 設定内容: コンテンツが特定のカテゴリに該当しないことを宣言します。
      # 設定可能な値:
      #   - "FreeOfPersonallyIdentifiableInformation": 個人情報を含まない
      #   - "FreeOfAdultContent": アダルトコンテンツを含まない
      # 省略時: コンテンツ分類は宣言されません
      content_classifiers = ["FreeOfPersonallyIdentifiableInformation", "FreeOfAdultContent"]
    }
  }

  #-------------------------------------------------------------
  # 出力データ設定
  #-------------------------------------------------------------

  # output_config (Required)
  # 設定内容: ラベリング結果の出力先を指定するブロックです。
  # 関連機能: Ground Truth 出力データ
  #   ラベリング結果のマニフェストファイルやアノテーションデータの保存先を定義します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/sms-data-output.html
  output_config {

    # s3_output_path (Required)
    # 設定内容: 出力データを書き込むS3の場所を指定します。
    # 設定可能な値: 有効なS3 URIパス
    s3_output_path = "s3://my-labeling-bucket/output/"

    # kms_key_id (Optional)
    # 設定内容: 出力データの暗号化に使用するKMSキーIDを指定します。
    # 設定可能な値: 有効なKMSキーARNまたはキーID
    # 省略時: デフォルトのS3暗号化が適用されます
    kms_key_id = null

    # sns_topic_arn (Optional)
    # 設定内容: 出力通知を送信するSNSトピックのARNを指定します。
    # 設定可能な値: 有効なSNSトピックARN
    # 省略時: SNS通知は送信されません
    sns_topic_arn = null
  }

  #-------------------------------------------------------------
  # 自動ラベリングアルゴリズム設定
  #-------------------------------------------------------------

  # labeling_job_algorithms_config (Optional)
  # 設定内容: 自動データラベリングに必要な情報を設定するブロックです。
  # 関連機能: Ground Truth 自動データラベリング
  #   アクティブラーニングを使用して、ヒューマンワーカーのラベルから学習し、
  #   残りのデータオブジェクトに自動的にラベルを付与します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/sms-automated-labeling.html
  # labeling_job_algorithms_config {

  #   # labeling_job_algorithm_specification_arn (Required)
  #   # 設定内容: 自動ラベリングに使用するアルゴリズムのARNを指定します。
  #   # 設定可能な値: AWSが提供する組み込みアルゴリズムのARN
  #   # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-automated-labeling.html
  #   labeling_job_algorithm_specification_arn = "arn:aws:sagemaker:ap-northeast-1:081040173940:labeling-job-algorithm-specification/image-classification"

  #   # initial_active_learning_model_arn (Optional)
  #   # 設定内容: アクティブラーニングの初期モデルとして使用するモデルのARNを指定します。
  #   # 設定可能な値: 有効なSageMakerモデルARN
  #   # 省略時: アルゴリズムがゼロからモデルをトレーニングします
  #   initial_active_learning_model_arn = null

  #   # labeling_job_resource_config (Optional)
  #   # 設定内容: ラベリングジョブのリソース設定ブロックです。
  #   labeling_job_resource_config {

  #     # volume_kms_key_id (Optional)
  #     # 設定内容: 自動データラベリングのトレーニング・推論ジョブに使用するMLコンピューティング
  #     #           インスタンスのストレージボリュームを暗号化するKMSキーIDを指定します。
  #     # 設定可能な値: 有効なKMSキーARNまたはキーID
  #     # 省略時: デフォルトのAWS管理キーが使用されます
  #     volume_kms_key_id = null

  #     # vpc_config (Optional)
  #     # 設定内容: SageMakerジョブがアクセスするVPCの設定ブロックです。
  #     # vpc_config {

  #     #   # security_group_ids (Required)
  #     #   # 設定内容: VPCセキュリティグループIDのセットを指定します。
  #     #   # 設定可能な値: sg-xxxxxxxx 形式の有効なセキュリティグループIDのセット
  #     #   security_group_ids = ["sg-12345678"]

  #     #   # subnets (Required)
  #     #   # 設定内容: VPC内のサブネットIDのセットを指定します。
  #     #   # 設定可能な値: 有効なサブネットIDのセット
  #     #   subnets = ["subnet-12345678", "subnet-87654321"]
  #     # }
  #   }
  # }

  #-------------------------------------------------------------
  # 停止条件設定
  #-------------------------------------------------------------

  # stopping_conditions (Optional)
  # 設定内容: ラベリングジョブを停止する条件を設定します。
  # 設定可能な値: max_human_labeled_object_count または max_percentage_of_input_dataset_labeled の
  #               いずれか、または両方を指定します。いずれかの条件が満たされるとジョブは自動停止します。
  # 省略時: ジョブは全データオブジェクトのラベル付けが完了するまで実行されます
  stopping_conditions {
    max_human_labeled_object_count         = 1000
    max_percentage_of_input_dataset_labeled = 100
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "my-labeling-job"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - labeling_job_arn: ラベリングジョブのARN
# - labeling_job_status: ラベリングジョブの処理ステータス
# - job_reference_code: ラベリングジョブの一部として行われた作業の一意識別子
# - failure_reason: ジョブが失敗した場合の失敗理由
# - label_counters: ラベル付けされたオブジェクト数の内訳
#   - human_labeled: ヒューマンワーカーがラベル付けした総数
#   - machine_labeled: 自動ラベリングで処理された総数
#   - total_labeled: ラベル付けされた総数
#   - unlabeled: 未ラベルの総数
#   - failed_non_retryable_error: エラーによりラベル付け不可の総数
# - tags_all: default_tagsから継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
