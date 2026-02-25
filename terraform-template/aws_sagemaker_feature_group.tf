#---------------------------------------------------------------
# Amazon SageMaker Feature Group
#---------------------------------------------------------------
#
# Amazon SageMaker Feature Storeのフィーチャーグループを管理するリソースです。
# フィーチャーグループは、機械学習のトレーニングや推論に使用するフィーチャーの
# 論理的なグループを定義し、オンラインストアおよびオフラインストアへの
# フィーチャー値の保存・取得を可能にします。
#
# AWS公式ドキュメント:
#   - CreateFeatureGroup API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateFeatureGroup.html
#   - SageMaker Feature Store: https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store.html
#   - Feature Store概要: https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store-getting-started.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_feature_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_feature_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # feature_group_name (Required)
  # 設定内容: フィーチャーグループの名前を指定します。
  # 設定可能な値: 文字列（1〜64文字、英数字、アンダースコア、ハイフン）
  # 注意: 作成後に変更できません。
  feature_group_name = "my-feature-group"

  # record_identifier_feature_name (Required)
  # 設定内容: レコード識別子として使用するフィーチャーの名前を指定します。
  # 設定可能な値: feature_definitionブロックで定義されたフィーチャー名
  # 注意: このフィーチャーはGetRecord、PutRecord、DeleteRecordのAPIで
  #       レコードを一意に識別するために使用されます。
  record_identifier_feature_name = "customer_id"

  # event_time_feature_name (Required)
  # 設定内容: イベント時刻として使用するフィーチャーの名前を指定します。
  # 設定可能な値: feature_definitionブロックで定義されたフィーチャー名
  # 注意: このフィーチャーはフィーチャー値がレコードに追加された時刻を追跡します。
  #       フィーチャータイプはStringまたはFractionalである必要があります。
  event_time_feature_name = "event_time"

  # role_arn (Required)
  # 設定内容: SageMakerがユーザーに代わってS3やGlueなどのAWSサービスにアクセスするために
  #           引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: オフラインストアを使用する場合、S3とGlueへのアクセス権限が必要です。
  role_arn = "arn:aws:iam::123456789012:role/sagemaker-feature-store-role"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: フィーチャーグループの説明を指定します。
  # 設定可能な値: 文字列（最大128文字）
  # 省略時: 説明なし
  description = null

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #           一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-feature-group"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # フィーチャー定義設定（必須）
  #-------------------------------------------------------------

  # feature_definition (Required)
  # 設定内容: フィーチャーグループに含まれるフィーチャーを定義するリストブロックを指定します。
  # 設定可能な値: リストブロック（1〜2500個）
  # 注意: record_identifier_feature_nameとevent_time_feature_nameで指定した
  #       フィーチャーもこのブロックに含める必要があります。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_FeatureDefinition.html
  feature_definition {
    # feature_name (Optional)
    # 設定内容: フィーチャーの名前を指定します。
    # 設定可能な値: 文字列（1〜64文字、英数字、アンダースコア、ハイフン）
    feature_name = "customer_id"

    # feature_type (Optional)
    # 設定内容: フィーチャーのデータ型を指定します。
    # 設定可能な値:
    #   - "Integral": 整数型
    #   - "Fractional": 浮動小数点型
    #   - "String": 文字列型
    feature_type = "String"

    # collection_type (Optional)
    # 設定内容: フィーチャーのコレクション型を指定します。
    # 設定可能な値:
    #   - "List": リスト型
    #   - "Set": セット型
    #   - "Vector": ベクター型
    # 省略時: スカラー型（コレクションなし）
    collection_type = null

    # collection_config (Optional)
    # 設定内容: コレクション型フィーチャーの追加設定を指定します。
    # 設定可能な値: ブロック
    # 省略時: 指定なし
    # 注意: collection_typeが "Vector" の場合にのみ使用します。
    # collection_config {
    #   # vector_config (Optional)
    #   # 設定内容: ベクター型フィーチャーの設定を指定します。
    #   # 設定可能な値: ブロック（最大1個）
    #   vector_config {
    #     # dimension (Optional)
    #     # 設定内容: ベクターの次元数を指定します。
    #     # 設定可能な値: 正の整数
    #     # 省略時: 指定なし
    #     dimension = 128
    #   }
    # }
  }

  feature_definition {
    feature_name    = "event_time"
    feature_type    = "String"
    collection_type = null
  }

  feature_definition {
    feature_name    = "purchase_amount"
    feature_type    = "Fractional"
    collection_type = null
  }

  feature_definition {
    feature_name    = "product_category"
    feature_type    = "String"
    collection_type = null
  }

  #-------------------------------------------------------------
  # オンラインストア設定
  #-------------------------------------------------------------

  # online_store_config (Optional)
  # 設定内容: フィーチャーグループのオンラインストア設定を指定します。
  # 設定可能な値: ブロック（最大1個）
  # 省略時: オンラインストアは無効
  # 関連機能: Online Store
  #   低レイテンシのリアルタイム推論用フィーチャー値の読み取りと書き込みに使用します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store-getting-started.html
  online_store_config {
    # enable_online_store (Optional)
    # 設定内容: オンラインストアを有効にするかを指定します。
    # 設定可能な値:
    #   - true: オンラインストアを有効化
    #   - false: オンラインストアを無効化
    # 省略時: false
    enable_online_store = true

    # storage_type (Optional)
    # 設定内容: オンラインストアのストレージ種別を指定します。
    # 設定可能な値:
    #   - "Standard": 標準ストレージ（デフォルト）
    #   - "InMemory": インメモリストレージ（低レイテンシ向け）
    # 省略時: "Standard"
    storage_type = "Standard"

    # security_config (Optional)
    # 設定内容: オンラインストアのセキュリティ設定を指定します。
    # 設定可能な値: ブロック（最大1個）
    # 省略時: 暗号化なし
    # security_config {
    #   # kms_key_id (Optional)
    #   # 設定内容: オンラインストアに保存されるデータを暗号化するKMSキーを指定します。
    #   # 設定可能な値: KMSキーID、キーARN、エイリアス名、またはエイリアス名ARN
    #   # 省略時: AWSマネージドキーを使用
    #   kms_key_id = null
    # }

    # ttl_duration (Optional)
    # 設定内容: オンラインストアのレコードの有効期間（TTL）を指定します。
    # 設定可能な値: ブロック（最大1個）
    # 省略時: TTLなし（レコードは無期限に保持）
    # 関連機能: Time-To-Live (TTL)
    #   期限切れのレコードを自動的に削除してストレージコストを最適化します。
    # ttl_duration {
    #   # unit (Optional)
    #   # 設定内容: TTLの時間単位を指定します。
    #   # 設定可能な値:
    #   #   - "Seconds": 秒
    #   #   - "Minutes": 分
    #   #   - "Hours": 時間
    #   #   - "Days": 日
    #   #   - "Weeks": 週
    #   # 省略時: 指定なし
    #   unit = "Days"
    #
    #   # value (Optional)
    #   # 設定内容: TTLの値を指定します。
    #   # 設定可能な値: 正の整数
    #   # 省略時: 指定なし
    #   value = 30
    # }
  }

  #-------------------------------------------------------------
  # オフラインストア設定
  #-------------------------------------------------------------

  # offline_store_config (Optional)
  # 設定内容: フィーチャーグループのオフラインストア設定を指定します。
  # 設定可能な値: ブロック（最大1個）
  # 省略時: オフラインストアは無効
  # 関連機能: Offline Store
  #   S3にフィーチャー値を保存してバッチ変換やモデルのトレーニングに使用します。
  #   Amazon Athenaを使用してオフラインストアのデータにクエリを実行できます。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store-offline.html
  # offline_store_config {
  #   # disable_glue_table_creation (Optional)
  #   # 設定内容: AWS Glueテーブルの自動作成を無効にするかを指定します。
  #   # 設定可能な値:
  #   #   - true: Glueテーブルの作成を無効化
  #   #   - false: Glueテーブルを自動作成（デフォルト）
  #   # 省略時: false
  #   disable_glue_table_creation = false
  #
  #   # table_format (Optional)
  #   # 設定内容: オフラインストアのテーブルフォーマットを指定します。
  #   # 設定可能な値:
  #   #   - "Glue": AWS Glueフォーマット（デフォルト）
  #   #   - "Iceberg": Apache Icebergフォーマット
  #   # 省略時: "Glue"
  #   table_format = "Glue"
  #
  #   #-----------------------------------------------------------
  #   # S3ストレージ設定（必須）
  #   #-----------------------------------------------------------
  #
  #   # s3_storage_config (Required)
  #   # 設定内容: オフラインストアのS3ストレージ設定を指定します。
  #   # 設定可能な値: ブロック（最大1個）
  #   s3_storage_config {
  #     # s3_uri (Required)
  #     # 設定内容: オフラインストアのデータを保存するS3バケットのURIを指定します。
  #     # 設定可能な値: S3 URI（例: s3://my-bucket/feature-store/）
  #     s3_uri = "s3://my-feature-store-bucket/offline-store/"
  #
  #     # kms_key_id (Optional)
  #     # 設定内容: S3に保存されるオフラインストアのデータを暗号化するKMSキーを指定します。
  #     # 設定可能な値: KMSキーID、キーARN、エイリアス名、またはエイリアス名ARN
  #     # 省略時: 暗号化なし
  #     kms_key_id = null
  #
  #     # resolved_output_s3_uri (Computed)
  #     # 設定内容: 実際に使用されるS3 URIを示す読み取り専用属性です（Terraform内部で使用）。
  #     # 省略時: AWSが自動的に設定
  #   }
  #
  #   #-----------------------------------------------------------
  #   # データカタログ設定
  #   #-----------------------------------------------------------
  #
  #   # data_catalog_config (Optional)
  #   # 設定内容: オフラインストアのAWS Glueデータカタログ設定を指定します。
  #   # 設定可能な値: ブロック（最大1個）
  #   # 省略時: SageMakerがデフォルトのカタログ、データベース、テーブル名を使用
  #   # data_catalog_config {
  #   #   # catalog (Optional)
  #   #   # 設定内容: Glueデータカタログのカタログ名を指定します。
  #   #   # 設定可能な値: 文字列
  #   #   # 省略時: AWSが自動的に設定
  #   #   catalog = null
  #   #
  #   #   # database (Optional)
  #   #   # 設定内容: Glueデータカタログのデータベース名を指定します。
  #   #   # 設定可能な値: 文字列
  #   #   # 省略時: AWSが自動的に設定
  #   #   database = null
  #   #
  #   #   # table_name (Optional)
  #   #   # 設定内容: Glueデータカタログのテーブル名を指定します。
  #   #   # 設定可能な値: 文字列
  #   #   # 省略時: AWSが自動的に設定
  #   #   table_name = null
  #   # }
  # }

  #-------------------------------------------------------------
  # スループット設定
  #-------------------------------------------------------------

  # throughput_config (Optional)
  # 設定内容: フィーチャーグループのオンラインストアのスループット設定を指定します。
  # 設定可能な値: ブロック（最大1個）
  # 省略時: オンデマンドスループットモードを使用
  # 関連機能: Throughput Configuration
  #   オンラインストアのスループットをオンデマンドまたはプロビジョン済みで設定できます。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/feature-store-throughput-setting.html
  # throughput_config {
  #   # throughput_mode (Optional)
  #   # 設定内容: スループットモードを指定します。
  #   # 設定可能な値:
  #   #   - "OnDemand": オンデマンド（自動スケーリング）
  #   #   - "Provisioned": プロビジョン済み（固定のスループット）
  #   # 省略時: AWSが自動的に設定（OnDemand）
  #   throughput_mode = "OnDemand"
  #
  #   # provisioned_read_capacity_units (Optional)
  #   # 設定内容: プロビジョン済みスループットモードでの読み取りキャパシティユニット数を指定します。
  #   # 設定可能な値: 正の整数
  #   # 省略時: 指定なし
  #   # 注意: throughput_modeが "Provisioned" の場合に指定します。
  #   provisioned_read_capacity_units = null
  #
  #   # provisioned_write_capacity_units (Optional)
  #   # 設定内容: プロビジョン済みスループットモードでの書き込みキャパシティユニット数を指定します。
  #   # 設定可能な値: 正の整数
  #   # 省略時: 指定なし
  #   # 注意: throughput_modeが "Provisioned" の場合に指定します。
  #   provisioned_write_capacity_units = null
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: フィーチャーグループに割り当てられたARN
#
# - id: フィーチャーグループの名前（feature_group_nameと同じ）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
