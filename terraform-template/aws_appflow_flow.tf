#---------------------------------------------------------------
# AWS AppFlow Flow
#---------------------------------------------------------------
#
# Amazon AppFlowのフローをプロビジョニングするリソースです。
# AppFlowは、SaaSアプリケーションとAWSサービス間でデータを安全に
# 転送するためのフルマネージド統合サービスです。
#
# AWS公式ドキュメント:
#   - AppFlow概要: https://docs.aws.amazon.com/appflow/latest/userguide/what-is-appflow.html
#   - フローの作成: https://docs.aws.amazon.com/appflow/latest/userguide/create-flow.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appflow_flow
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appflow_flow" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: フローの名前を指定します。
  # 設定可能な値: 文字列（AWSアカウント内で一意である必要があります）
  name = "example-flow"

  # description (Optional)
  # 設定内容: 作成するフローの説明を指定します。
  # 設定可能な値: 任意の文字列
  description = "Example AppFlow flow for data transfer"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_arn (Optional)
  # 設定内容: 暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: Amazon AppFlowが管理するKMSキーを使用
  # 関連機能: データ暗号化
  #   AppFlowはデータを転送中および保存時に暗号化します。
  #   独自のKMSキーを指定することで、より細かいアクセス制御が可能です。
  kms_arn = null

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
    Name        = "example-appflow-flow"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # ソースフロー設定 (source_flow_config)
  #-------------------------------------------------------------
  # Amazon AppFlowがソースコネクタからデータを取得する方法を制御します。

  source_flow_config {
    # connector_type (Required)
    # 設定内容: ソースコネクタのタイプを指定します。
    # 設定可能な値:
    #   - "Salesforce": Salesforce
    #   - "Singular": Singular
    #   - "Slack": Slack
    #   - "Redshift": Amazon Redshift
    #   - "S3": Amazon S3
    #   - "Marketo": Marketo
    #   - "Googleanalytics": Google Analytics
    #   - "Zendesk": Zendesk
    #   - "Servicenow": ServiceNow
    #   - "Datadog": Datadog
    #   - "Trendmicro": Trend Micro
    #   - "Snowflake": Snowflake
    #   - "Dynatrace": Dynatrace
    #   - "Infornexus": Infor Nexus
    #   - "Amplitude": Amplitude
    #   - "Veeva": Veeva
    #   - "SAPOData": SAP OData
    #   - "CustomConnector": カスタムコネクタ
    connector_type = "S3"

    # api_version (Optional)
    # 設定内容: ソースコネクタが使用するAPIバージョンを指定します。
    # 設定可能な値: コネクタに応じた有効なAPIバージョン文字列
    api_version = null

    # connector_profile_name (Optional)
    # 設定内容: コネクタプロファイルの名前を指定します。
    # 設定可能な値: AWSアカウント内で一意のコネクタプロファイル名
    # 注意: S3などの一部のコネクタではプロファイル不要
    connector_profile_name = null

    #-----------------------------------------------------------
    # インクリメンタルプル設定 (incremental_pull_config)
    #-----------------------------------------------------------
    # スケジュールされたインクリメンタルデータプルの設定を定義します。

    incremental_pull_config {
      # datetime_type_field_name (Optional)
      # 設定内容: インクリメンタルレコードをインポートする際の基準となる
      #           日時/タイムスタンプフィールドを指定します。
      # 設定可能な値: ソースデータ内の日時型フィールド名
      datetime_type_field_name = null
    }

    #-----------------------------------------------------------
    # ソースコネクタプロパティ (source_connector_properties)
    #-----------------------------------------------------------
    # 特定のコネクタをクエリするために必要な情報を格納します。
    # 使用するコネクタに応じて適切なブロックを1つ選択します。

    source_connector_properties {

      #---------------------------------------------------------
      # Amazon S3 ソースプロパティ
      #---------------------------------------------------------
      s3 {
        # bucket_name (Required)
        # 設定内容: ソースファイルが保存されているS3バケット名を指定します。
        # 設定可能な値: 有効なS3バケット名
        bucket_name = "example-source-bucket"

        # bucket_prefix (Required)
        # 設定内容: ソースファイルのS3オブジェクトキープレフィックスを指定します。
        # 設定可能な値: S3オブジェクトキープレフィックス
        bucket_prefix = "source-data/"

        # S3入力フォーマット設定
        s3_input_format_config {
          # s3_input_file_type (Optional)
          # 設定内容: AppFlowがS3バケットから取得するファイルタイプを指定します。
          # 設定可能な値:
          #   - "CSV": CSVファイル
          #   - "JSON": JSONファイル
          s3_input_file_type = "CSV"
        }
      }

      #---------------------------------------------------------
      # Amplitude ソースプロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # amplitude {
      #   # object (Required)
      #   # 設定内容: フローソースで指定されたオブジェクトを指定します。
      #   object = "example-object"
      # }

      #---------------------------------------------------------
      # Custom Connector ソースプロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # custom_connector {
      #   # entity_name (Required)
      #   # 設定内容: カスタムコネクタでソースとして指定されたエンティティを指定します。
      #   entity_name = "example-entity"
      #
      #   # custom_properties (Optional)
      #   # 設定内容: カスタムコネクタ固有のカスタムプロパティを指定します。
      #   # 設定可能な値: 最大50項目のキーと値のマップ
      #   custom_properties = {
      #     key1 = "value1"
      #   }
      # }

      #---------------------------------------------------------
      # Datadog ソースプロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # datadog {
      #   # object (Required)
      #   # 設定内容: フローソースで指定されたオブジェクトを指定します。
      #   object = "example-object"
      # }

      #---------------------------------------------------------
      # Dynatrace ソースプロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # dynatrace {
      #   # object (Required)
      #   # 設定内容: フローソースで指定されたオブジェクトを指定します。
      #   object = "example-object"
      # }

      #---------------------------------------------------------
      # Google Analytics ソースプロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # google_analytics {
      #   # object (Required)
      #   # 設定内容: フローソースで指定されたオブジェクトを指定します。
      #   object = "example-object"
      # }

      #---------------------------------------------------------
      # Infor Nexus ソースプロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # infor_nexus {
      #   # object (Required)
      #   # 設定内容: フローソースで指定されたオブジェクトを指定します。
      #   object = "example-object"
      # }

      #---------------------------------------------------------
      # Marketo ソースプロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # marketo {
      #   # object (Required)
      #   # 設定内容: フローソースで指定されたオブジェクトを指定します。
      #   object = "example-object"
      # }

      #---------------------------------------------------------
      # Salesforce ソースプロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # salesforce {
      #   # object (Required)
      #   # 設定内容: Salesforceフローソースで指定されたオブジェクトを指定します。
      #   object = "Account"
      #
      #   # enable_dynamic_field_update (Optional)
      #   # 設定内容: フロー実行中にSalesforceオブジェクトの新しいフィールドを
      #   #           動的にフェッチするかどうかを指定します。
      #   # 設定可能な値: true / false
      #   enable_dynamic_field_update = false
      #
      #   # include_deleted_records (Optional)
      #   # 設定内容: フロー実行に削除されたファイルを含めるかどうかを指定します。
      #   # 設定可能な値: true / false
      #   include_deleted_records = false
      #
      #   # data_transfer_api (Optional)
      #   # 設定内容: Salesforceへのデータ転送時に使用するAPIを指定します。
      #   # 設定可能な値: "AUTOMATIC", "BULKV2", "REST_SYNC"
      #   data_transfer_api = "AUTOMATIC"
      # }

      #---------------------------------------------------------
      # SAP OData ソースプロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # sapo_data {
      #   # object_path (Required)
      #   # 設定内容: SAPODataフローソースで指定されたオブジェクトパスを指定します。
      #   object_path = "/sap/opu/odata/sap/API_EXAMPLE"
      #
      #   # ページネーション設定
      #   pagination_config {
      #     # max_page_size (Required)
      #     # 設定内容: SAPアプリケーションからの応答の各ページでAppFlowが
      #     #           受信するレコードの最大数を指定します。
      #     max_page_size = 1000
      #   }
      #
      #   # 並列処理設定
      #   parallelism_config {
      #     # max_page_size (Required)
      #     # 設定内容: SAPアプリケーションからデータを取得する際にAppFlowが
      #     #           同時に実行するプロセスの最大数を指定します。
      #     max_page_size = 5
      #   }
      # }

      #---------------------------------------------------------
      # ServiceNow ソースプロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # service_now {
      #   # object (Required)
      #   # 設定内容: フローソースで指定されたオブジェクトを指定します。
      #   object = "incident"
      # }

      #---------------------------------------------------------
      # Singular ソースプロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # singular {
      #   # object (Required)
      #   # 設定内容: フローソースで指定されたオブジェクトを指定します。
      #   object = "example-object"
      # }

      #---------------------------------------------------------
      # Slack ソースプロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # slack {
      #   # object (Required)
      #   # 設定内容: フローソースで指定されたオブジェクトを指定します。
      #   object = "conversations"
      # }

      #---------------------------------------------------------
      # Trend Micro ソースプロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # trendmicro {
      #   # object (Required)
      #   # 設定内容: フローソースで指定されたオブジェクトを指定します。
      #   object = "example-object"
      # }

      #---------------------------------------------------------
      # Veeva ソースプロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # veeva {
      #   # object (Required)
      #   # 設定内容: Veevaフローソースで指定されたオブジェクトを指定します。
      #   object = "documents"
      #
      #   # document_type (Optional)
      #   # 設定内容: Veevaドキュメント抽出フローで指定されたドキュメントタイプを指定します。
      #   document_type = null
      #
      #   # include_all_versions (Optional)
      #   # 設定内容: Veevaドキュメント抽出フローにすべてのバージョンのファイルを
      #   #           含めるかどうかを指定します。
      #   # 設定可能な値: true / false
      #   include_all_versions = false
      #
      #   # include_renditions (Optional)
      #   # 設定内容: Veevaドキュメント抽出フローにファイルのレンディションを
      #   #           含めるかどうかを指定します。
      #   # 設定可能な値: true / false
      #   include_renditions = false
      #
      #   # include_source_files (Optional)
      #   # 設定内容: Veevaドキュメント抽出フローにソースファイルを含めるかどうかを指定します。
      #   # 設定可能な値: true / false
      #   include_source_files = false
      # }

      #---------------------------------------------------------
      # Zendesk ソースプロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # zendesk {
      #   # object (Required)
      #   # 設定内容: フローソースで指定されたオブジェクトを指定します。
      #   object = "tickets"
      # }
    }
  }

  #-------------------------------------------------------------
  # 宛先フロー設定 (destination_flow_config)
  #-------------------------------------------------------------
  # Amazon AppFlowが宛先コネクタにデータを配置する方法を制御します。
  # 複数の宛先を設定可能です。

  destination_flow_config {
    # connector_type (Required)
    # 設定内容: 宛先コネクタのタイプを指定します。
    # 設定可能な値:
    #   - "Salesforce": Salesforce
    #   - "Redshift": Amazon Redshift
    #   - "S3": Amazon S3
    #   - "Marketo": Marketo
    #   - "Zendesk": Zendesk
    #   - "Snowflake": Snowflake
    #   - "EventBridge": Amazon EventBridge
    #   - "LookoutMetrics": Amazon Lookout for Metrics
    #   - "Upsolver": Upsolver
    #   - "Honeycode": Amazon Honeycode
    #   - "CustomerProfiles": Amazon Connect Customer Profiles
    #   - "SAPOData": SAP OData
    #   - "CustomConnector": カスタムコネクタ
    connector_type = "S3"

    # api_version (Optional)
    # 設定内容: 宛先コネクタが使用するAPIバージョンを指定します。
    # 設定可能な値: コネクタに応じた有効なAPIバージョン文字列
    api_version = null

    # connector_profile_name (Optional)
    # 設定内容: コネクタプロファイルの名前を指定します。
    # 設定可能な値: AWSアカウント内で一意のコネクタプロファイル名
    # 注意: S3などの一部のコネクタではプロファイル不要
    connector_profile_name = null

    #-----------------------------------------------------------
    # 宛先コネクタプロパティ (destination_connector_properties)
    #-----------------------------------------------------------
    # 特定のコネクタをクエリするために必要な情報を格納します。
    # 使用するコネクタに応じて適切なブロックを1つ選択します。

    destination_connector_properties {

      #---------------------------------------------------------
      # Amazon S3 宛先プロパティ
      #---------------------------------------------------------
      s3 {
        # bucket_name (Required)
        # 設定内容: AppFlowが転送データを配置するS3バケット名を指定します。
        # 設定可能な値: 有効なS3バケット名
        bucket_name = "example-destination-bucket"

        # bucket_prefix (Optional)
        # 設定内容: 宛先ファイルのS3オブジェクトキープレフィックスを指定します。
        # 設定可能な値: S3オブジェクトキープレフィックス
        bucket_prefix = "destination-data/"

        # S3出力フォーマット設定
        s3_output_format_config {
          # file_type (Optional)
          # 設定内容: AppFlowがS3バケットに配置するファイルタイプを指定します。
          # 設定可能な値:
          #   - "CSV": CSVファイル
          #   - "JSON": JSONファイル
          #   - "PARQUET": Parquetファイル
          file_type = "JSON"

          # preserve_source_data_typing (Optional)
          # 設定内容: ソースシステムのデータ型を保持するかどうかを指定します。
          # 設定可能な値: true / false
          # 注意: Parquetファイルタイプでのみ有効
          preserve_source_data_typing = null

          # 集約設定
          aggregation_config {
            # aggregation_type (Optional)
            # 設定内容: フローレコードを単一ファイルに集約するか、
            #           非集約のままにするかを指定します。
            # 設定可能な値:
            #   - "None": 集約しない
            #   - "SingleFile": 単一ファイルに集約
            aggregation_type = "None"

            # target_file_size (Optional)
            # 設定内容: 各出力ファイルの目標ファイルサイズ（MB単位）を指定します。
            # 設定可能な値: 整数値
            target_file_size = null
          }

          # プレフィックス設定
          prefix_config {
            # prefix_type (Optional)
            # 設定内容: プレフィックスのフォーマットと適用対象を指定します。
            # 設定可能な値:
            #   - "FILENAME": ファイル名のみ
            #   - "PATH": パスのみ
            #   - "PATH_AND_FILENAME": パスとファイル名の両方
            prefix_type = "PATH"

            # prefix_format (Optional)
            # 設定内容: プレフィックスに含まれる粒度のレベルを指定します。
            # 設定可能な値:
            #   - "YEAR": 年
            #   - "MONTH": 月
            #   - "DAY": 日
            #   - "HOUR": 時
            #   - "MINUTE": 分
            prefix_format = null

            # prefix_hierarchy (Optional)
            # 設定内容: 宛先ファイルパスに含める要素を指定します。
            # 設定可能な値:
            #   - "EXECUTION_ID": 実行ID
            #   - "SCHEMA_VERSION": スキーマバージョン
            prefix_hierarchy = null
          }
        }
      }

      #---------------------------------------------------------
      # Custom Connector 宛先プロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # custom_connector {
      #   # entity_name (Required)
      #   # 設定内容: カスタムコネクタで宛先として指定されたエンティティを指定します。
      #   entity_name = "example-entity"
      #
      #   # custom_properties (Optional)
      #   # 設定内容: カスタムコネクタ固有のカスタムプロパティを指定します。
      #   # 設定可能な値: 最大50項目のキーと値のマップ
      #   custom_properties = {
      #     key1 = "value1"
      #   }
      #
      #   # id_field_names (Optional)
      #   # 設定内容: 更新、削除、アップサート操作時にIDとして使用するフィールド名を指定します。
      #   id_field_names = ["id"]
      #
      #   # write_operation_type (Optional)
      #   # 設定内容: カスタムコネクタを宛先として使用する際の書き込み操作タイプを指定します。
      #   # 設定可能な値: "INSERT", "UPSERT", "UPDATE", "DELETE"
      #   write_operation_type = "INSERT"
      #
      #   # エラーハンドリング設定
      #   error_handling_config {
      #     # bucket_name (Optional)
      #     # 設定内容: エラー情報を保存するS3バケット名を指定します。
      #     bucket_name = "error-bucket"
      #
      #     # bucket_prefix (Optional)
      #     # 設定内容: エラー情報のS3バケットプレフィックスを指定します。
      #     bucket_prefix = "errors/"
      #
      #     # fail_on_first_destination_error (Optional)
      #     # 設定内容: 最初のエラー発生時にフローを失敗させるかどうかを指定します。
      #     # 設定可能な値: true / false
      #     fail_on_first_destination_error = true
      #   }
      # }

      #---------------------------------------------------------
      # Customer Profiles 宛先プロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # customer_profiles {
      #   # domain_name (Required)
      #   # 設定内容: Amazon Connect Customer Profilesドメインの一意の名前を指定します。
      #   domain_name = "example-domain"
      #
      #   # object_type_name (Optional)
      #   # 設定内容: Customer Profilesフロー宛先で指定されたオブジェクトを指定します。
      #   object_type_name = null
      # }

      #---------------------------------------------------------
      # EventBridge 宛先プロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # event_bridge {
      #   # object (Required)
      #   # 設定内容: フロー宛先で指定されたオブジェクトを指定します。
      #   object = "example-event-bus"
      #
      #   # エラーハンドリング設定
      #   error_handling_config {
      #     bucket_name                     = "error-bucket"
      #     bucket_prefix                   = "errors/"
      #     fail_on_first_destination_error = true
      #   }
      # }

      #---------------------------------------------------------
      # Honeycode 宛先プロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # honeycode {
      #   # object (Required)
      #   # 設定内容: フロー宛先で指定されたオブジェクトを指定します。
      #   object = "example-table"
      #
      #   # エラーハンドリング設定
      #   error_handling_config {
      #     bucket_name                     = "error-bucket"
      #     bucket_prefix                   = "errors/"
      #     fail_on_first_destination_error = true
      #   }
      # }

      #---------------------------------------------------------
      # Lookout for Metrics 宛先プロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # lookout_metrics {
      #   # このブロックは属性を持ちません
      # }

      #---------------------------------------------------------
      # Marketo 宛先プロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # marketo {
      #   # object (Required)
      #   # 設定内容: フロー宛先で指定されたオブジェクトを指定します。
      #   object = "leads"
      #
      #   # エラーハンドリング設定
      #   error_handling_config {
      #     bucket_name                     = "error-bucket"
      #     bucket_prefix                   = "errors/"
      #     fail_on_first_destination_error = true
      #   }
      # }

      #---------------------------------------------------------
      # Redshift 宛先プロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # redshift {
      #   # intermediate_bucket_name (Required)
      #   # 設定内容: AppFlowがRedshiftにデータを移動する際に使用する中間バケットを指定します。
      #   intermediate_bucket_name = "intermediate-bucket"
      #
      #   # object (Required)
      #   # 設定内容: Redshiftフロー宛先で指定されたオブジェクトを指定します。
      #   object = "example_table"
      #
      #   # bucket_prefix (Optional)
      #   # 設定内容: 宛先ファイルのオブジェクトキープレフィックスを指定します。
      #   bucket_prefix = null
      #
      #   # エラーハンドリング設定
      #   error_handling_config {
      #     bucket_name                     = "error-bucket"
      #     bucket_prefix                   = "errors/"
      #     fail_on_first_destination_error = true
      #   }
      # }

      #---------------------------------------------------------
      # Salesforce 宛先プロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # salesforce {
      #   # object (Required)
      #   # 設定内容: フロー宛先で指定されたオブジェクトを指定します。
      #   object = "Account"
      #
      #   # id_field_names (Optional)
      #   # 設定内容: 更新または削除操作時にIDとして使用するフィールド名を指定します。
      #   id_field_names = ["Id"]
      #
      #   # write_operation_type (Optional)
      #   # 設定内容: Salesforceで実行する書き込み操作タイプを指定します。
      #   # 設定可能な値: "INSERT", "UPSERT", "UPDATE", "DELETE"
      #   # 注意: UPSERTの場合、id_field_namesが必須
      #   write_operation_type = "INSERT"
      #
      #   # data_transfer_api (Optional)
      #   # 設定内容: Salesforceへのデータ転送時にAppFlowが使用するAPIを指定します。
      #   data_transfer_api = null
      #
      #   # エラーハンドリング設定
      #   error_handling_config {
      #     bucket_name                     = "error-bucket"
      #     bucket_prefix                   = "errors/"
      #     fail_on_first_destination_error = true
      #   }
      # }

      #---------------------------------------------------------
      # SAP OData 宛先プロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # sapo_data {
      #   # object_path (Required)
      #   # 設定内容: SAPODataフロー宛先で指定されたオブジェクトパスを指定します。
      #   object_path = "/sap/opu/odata/sap/API_EXAMPLE"
      #
      #   # id_field_names (Optional)
      #   # 設定内容: 更新または削除操作時にIDとして使用するフィールド名を指定します。
      #   id_field_names = ["key"]
      #
      #   # write_operation_type (Optional)
      #   # 設定内容: 宛先コネクタで実行可能な書き込み操作を指定します。
      #   # 設定可能な値: "INSERT", "UPSERT", "UPDATE", "DELETE"
      #   # 省略時: INSERT
      #   write_operation_type = "INSERT"
      #
      #   # エラーハンドリング設定
      #   error_handling_config {
      #     bucket_name                     = "error-bucket"
      #     bucket_prefix                   = "errors/"
      #     fail_on_first_destination_error = true
      #   }
      #
      #   # 成功レスポンスハンドリング設定
      #   success_response_handling_config {
      #     # bucket_name (Optional)
      #     # 設定内容: 成功レスポンスを保存するS3バケット名を指定します。
      #     bucket_name = "success-bucket"
      #
      #     # bucket_prefix (Optional)
      #     # 設定内容: 成功レスポンスのS3バケットプレフィックスを指定します。
      #     bucket_prefix = "success/"
      #   }
      # }

      #---------------------------------------------------------
      # Snowflake 宛先プロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # snowflake {
      #   # intermediate_bucket_name (Required)
      #   # 設定内容: AppFlowがSnowflakeにデータを移動する際に使用する中間バケットを指定します。
      #   intermediate_bucket_name = "intermediate-bucket"
      #
      #   # object (Required)
      #   # 設定内容: Snowflakeフロー宛先で指定されたオブジェクトを指定します。
      #   object = "example_table"
      #
      #   # bucket_prefix (Optional)
      #   # 設定内容: 宛先ファイルのオブジェクトキープレフィックスを指定します。
      #   bucket_prefix = null
      #
      #   # エラーハンドリング設定
      #   error_handling_config {
      #     bucket_name                     = "error-bucket"
      #     bucket_prefix                   = "errors/"
      #     fail_on_first_destination_error = true
      #   }
      # }

      #---------------------------------------------------------
      # Upsolver 宛先プロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # upsolver {
      #   # bucket_name (Required)
      #   # 設定内容: AppFlowが転送データを配置するUpsolver S3バケット名を指定します。
      #   # 注意: "upsolver-appflow"で始まる必要があります
      #   bucket_name = "upsolver-appflow-example"
      #
      #   # bucket_prefix (Optional)
      #   # 設定内容: Upsolver S3バケットのオブジェクトキープレフィックスを指定します。
      #   bucket_prefix = null
      #
      #   # S3出力フォーマット設定 (Required)
      #   s3_output_format_config {
      #     # file_type (Optional)
      #     # 設定内容: AppFlowがUpsolver S3バケットに配置するファイルタイプを指定します。
      #     # 設定可能な値: "CSV", "JSON", "PARQUET"
      #     file_type = "JSON"
      #
      #     # 集約設定
      #     aggregation_config {
      #       # aggregation_type (Optional)
      #       # 設定内容: フローレコードを単一ファイルに集約するか、
      #       #           非集約のままにするかを指定します。
      #       # 設定可能な値: "None", "SingleFile"
      #       aggregation_type = "None"
      #     }
      #
      #     # プレフィックス設定 (Required)
      #     prefix_config {
      #       # prefix_type (Required)
      #       # 設定内容: プレフィックスのフォーマットと適用対象を指定します。
      #       # 設定可能な値: "FILENAME", "PATH", "PATH_AND_FILENAME"
      #       prefix_type = "PATH"
      #
      #       # prefix_format (Optional)
      #       # 設定内容: プレフィックスに含まれる粒度のレベルを指定します。
      #       # 設定可能な値: "YEAR", "MONTH", "DAY", "HOUR", "MINUTE"
      #       prefix_format = null
      #
      #       # prefix_hierarchy (Optional)
      #       # 設定内容: 宛先ファイルパスに含める要素を指定します。
      #       # 設定可能な値: "EXECUTION_ID", "SCHEMA_VERSION"
      #       prefix_hierarchy = null
      #     }
      #   }
      # }

      #---------------------------------------------------------
      # Zendesk 宛先プロパティ (使用時はコメント解除)
      #---------------------------------------------------------
      # zendesk {
      #   # object (Required)
      #   # 設定内容: フロー宛先で指定されたオブジェクトを指定します。
      #   object = "tickets"
      #
      #   # id_field_names (Optional)
      #   # 設定内容: 更新または削除操作時にIDとして使用するフィールド名を指定します。
      #   id_field_names = ["id"]
      #
      #   # write_operation_type (Optional)
      #   # 設定内容: Zendeskで実行する書き込み操作タイプを指定します。
      #   # 設定可能な値: "INSERT", "UPSERT", "UPDATE", "DELETE"
      #   # 注意: UPSERTの場合、id_field_namesが必須
      #   write_operation_type = "INSERT"
      #
      #   # エラーハンドリング設定
      #   error_handling_config {
      #     bucket_name                     = "error-bucket"
      #     bucket_prefix                   = "errors/"
      #     fail_on_first_destination_error = true
      #   }
      # }
    }
  }

  #-------------------------------------------------------------
  # タスク設定 (task)
  #-------------------------------------------------------------
  # フロー実行中にAppFlowがデータに対して実行するタスクを定義します。
  # 複数のタスクを設定可能です。

  task {
    # task_type (Required)
    # 設定内容: AppFlowが実行するタスクの種類を指定します。
    # 設定可能な値:
    #   - "Arithmetic": 算術演算
    #   - "Filter": フィルタリング
    #   - "Map": フィールドマッピング
    #   - "Map_all": すべてのフィールドをマッピング
    #   - "Mask": データマスキング
    #   - "Merge": フィールドのマージ
    #   - "Passthrough": パススルー（変換なし）
    #   - "Truncate": データの切り捨て
    #   - "Validate": データ検証
    task_type = "Map"

    # source_fields (Optional)
    # 設定内容: タスクが適用されるソースフィールドを指定します。
    # 設定可能な値: ソースデータ内のフィールド名のリスト
    source_fields = ["exampleField"]

    # destination_field (Optional)
    # 設定内容: 宛先コネクタ内のフィールド、またはソースフィールドの
    #           検証対象となるフィールド値を指定します。
    # 設定可能な値: 宛先データ内のフィールド名
    destination_field = "exampleField"

    # task_properties (Optional)
    # 設定内容: タスク関連の情報を格納するマップを指定します。
    # 設定可能なキー:
    #   - "VALUE": 値
    #   - "VALUES": 複数の値
    #   - "DATA_TYPE": データ型
    #   - "UPPER_BOUND": 上限
    #   - "LOWER_BOUND": 下限
    #   - "SOURCE_DATA_TYPE": ソースデータ型
    #   - "DESTINATION_DATA_TYPE": 宛先データ型
    #   - "VALIDATION_ACTION": 検証アクション
    #   - "MASK_VALUE": マスク値
    #   - "MASK_LENGTH": マスク長
    #   - "TRUNCATE_LENGTH": 切り捨て長
    #   - "MATH_OPERATION_FIELDS_ORDER": 算術演算フィールドの順序
    #   - "CONCAT_FORMAT": 連結フォーマット
    #   - "SUBFIELD_CATEGORY_MAP": サブフィールドカテゴリマップ
    #   - "EXCLUDE_SOURCE_FIELDS_LIST": 除外するソースフィールドリスト
    task_properties = {}

    #-----------------------------------------------------------
    # コネクタオペレーター設定 (connector_operator)
    #-----------------------------------------------------------
    # 提供されたソースフィールドに対して実行される操作を指定します。
    # 使用するソースコネクタに応じて適切な属性を設定します。

    connector_operator {
      # s3 (Optional)
      # 設定内容: S3ソースフィールドに対して実行される操作を指定します。
      # 設定可能な値:
      #   - "PROJECTION": 射影
      #   - "LESS_THAN": より小さい
      #   - "GREATER_THAN": より大きい
      #   - "BETWEEN": 範囲内
      #   - "LESS_THAN_OR_EQUAL_TO": 以下
      #   - "GREATER_THAN_OR_EQUAL_TO": 以上
      #   - "EQUAL_TO": 等しい
      #   - "NOT_EQUAL_TO": 等しくない
      #   - "ADDITION": 加算
      #   - "MULTIPLICATION": 乗算
      #   - "DIVISION": 除算
      #   - "SUBTRACTION": 減算
      #   - "MASK_ALL": すべてマスク
      #   - "MASK_FIRST_N": 最初のN文字をマスク
      #   - "MASK_LAST_N": 最後のN文字をマスク
      #   - "VALIDATE_NON_NULL": NULL以外を検証
      #   - "VALIDATE_NON_ZERO": ゼロ以外を検証
      #   - "VALIDATE_NON_NEGATIVE": 負でないことを検証
      #   - "VALIDATE_NUMERIC": 数値であることを検証
      #   - "NO_OP": 操作なし
      s3 = "NO_OP"

      # amplitude (Optional)
      # 設定内容: Amplitudeソースフィールドに対して実行される操作を指定します。
      # 設定可能な値: "BETWEEN"
      # amplitude = null

      # custom_connector (Optional)
      # 設定内容: カスタムコネクタソースフィールドに対して実行される操作を指定します。
      # 設定可能な値: "PROJECTION", "LESS_THAN", "GREATER_THAN", "CONTAINS", "BETWEEN",
      #   "LESS_THAN_OR_EQUAL_TO", "GREATER_THAN_OR_EQUAL_TO", "EQUAL_TO", "NOT_EQUAL_TO",
      #   "ADDITION", "MULTIPLICATION", "DIVISION", "SUBTRACTION", "MASK_ALL",
      #   "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL", "VALIDATE_NON_ZERO",
      #   "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
      # custom_connector = null

      # datadog (Optional)
      # 設定内容: Datadogソースフィールドに対して実行される操作を指定します。
      # 設定可能な値: "PROJECTION", "BETWEEN", "EQUAL_TO", "ADDITION", "MULTIPLICATION",
      #   "DIVISION", "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N",
      #   "VALIDATE_NON_NULL", "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE",
      #   "VALIDATE_NUMERIC", "NO_OP"
      # datadog = null

      # dynatrace (Optional)
      # 設定内容: Dynatraceソースフィールドに対して実行される操作を指定します。
      # 設定可能な値: "PROJECTION", "BETWEEN", "EQUAL_TO", "ADDITION", "MULTIPLICATION",
      #   "DIVISION", "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N",
      #   "VALIDATE_NON_NULL", "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE",
      #   "VALIDATE_NUMERIC", "NO_OP"
      # dynatrace = null

      # google_analytics (Optional)
      # 設定内容: Google Analyticsソースフィールドに対して実行される操作を指定します。
      # 設定可能な値: "PROJECTION", "BETWEEN"
      # google_analytics = null

      # infor_nexus (Optional)
      # 設定内容: Infor Nexusソースフィールドに対して実行される操作を指定します。
      # 設定可能な値: "PROJECTION", "BETWEEN", "EQUAL_TO", "ADDITION", "MULTIPLICATION",
      #   "DIVISION", "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N",
      #   "VALIDATE_NON_NULL", "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE",
      #   "VALIDATE_NUMERIC", "NO_OP"
      # infor_nexus = null

      # marketo (Optional)
      # 設定内容: Marketoソースフィールドに対して実行される操作を指定します。
      # 設定可能な値: "PROJECTION", "BETWEEN", "EQUAL_TO", "ADDITION", "MULTIPLICATION",
      #   "DIVISION", "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N",
      #   "VALIDATE_NON_NULL", "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE",
      #   "VALIDATE_NUMERIC", "NO_OP"
      # marketo = null

      # salesforce (Optional)
      # 設定内容: Salesforceソースフィールドに対して実行される操作を指定します。
      # 設定可能な値: "PROJECTION", "LESS_THAN", "GREATER_THAN", "CONTAINS", "BETWEEN",
      #   "LESS_THAN_OR_EQUAL_TO", "GREATER_THAN_OR_EQUAL_TO", "EQUAL_TO", "NOT_EQUAL_TO",
      #   "ADDITION", "MULTIPLICATION", "DIVISION", "SUBTRACTION", "MASK_ALL",
      #   "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL", "VALIDATE_NON_ZERO",
      #   "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
      # salesforce = null

      # sapo_data (Optional)
      # 設定内容: SAPODataソースフィールドに対して実行される操作を指定します。
      # 設定可能な値: "PROJECTION", "LESS_THAN", "GREATER_THAN", "CONTAINS", "BETWEEN",
      #   "LESS_THAN_OR_EQUAL_TO", "GREATER_THAN_OR_EQUAL_TO", "EQUAL_TO", "NOT_EQUAL_TO",
      #   "ADDITION", "MULTIPLICATION", "DIVISION", "SUBTRACTION", "MASK_ALL",
      #   "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL", "VALIDATE_NON_ZERO",
      #   "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
      # sapo_data = null

      # service_now (Optional)
      # 設定内容: ServiceNowソースフィールドに対して実行される操作を指定します。
      # 設定可能な値: "PROJECTION", "LESS_THAN", "GREATER_THAN", "CONTAINS", "BETWEEN",
      #   "LESS_THAN_OR_EQUAL_TO", "GREATER_THAN_OR_EQUAL_TO", "EQUAL_TO", "NOT_EQUAL_TO",
      #   "ADDITION", "MULTIPLICATION", "DIVISION", "SUBTRACTION", "MASK_ALL",
      #   "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL", "VALIDATE_NON_ZERO",
      #   "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
      # service_now = null

      # singular (Optional)
      # 設定内容: Singularソースフィールドに対して実行される操作を指定します。
      # 設定可能な値: "PROJECTION", "EQUAL_TO", "ADDITION", "MULTIPLICATION",
      #   "DIVISION", "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N",
      #   "VALIDATE_NON_NULL", "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE",
      #   "VALIDATE_NUMERIC", "NO_OP"
      # singular = null

      # slack (Optional)
      # 設定内容: Slackソースフィールドに対して実行される操作を指定します。
      # 設定可能な値: "PROJECTION", "LESS_THAN", "GREATER_THAN", "BETWEEN",
      #   "LESS_THAN_OR_EQUAL_TO", "GREATER_THAN_OR_EQUAL_TO", "EQUAL_TO",
      #   "ADDITION", "MULTIPLICATION", "DIVISION", "SUBTRACTION", "MASK_ALL",
      #   "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL", "VALIDATE_NON_ZERO",
      #   "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
      # slack = null

      # trendmicro (Optional)
      # 設定内容: Trend Microソースフィールドに対して実行される操作を指定します。
      # 設定可能な値: "PROJECTION", "EQUAL_TO", "ADDITION", "MULTIPLICATION",
      #   "DIVISION", "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N",
      #   "VALIDATE_NON_NULL", "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE",
      #   "VALIDATE_NUMERIC", "NO_OP"
      # trendmicro = null

      # veeva (Optional)
      # 設定内容: Veevaソースフィールドに対して実行される操作を指定します。
      # 設定可能な値: "PROJECTION", "LESS_THAN", "GREATER_THAN", "CONTAINS", "BETWEEN",
      #   "LESS_THAN_OR_EQUAL_TO", "GREATER_THAN_OR_EQUAL_TO", "EQUAL_TO", "NOT_EQUAL_TO",
      #   "ADDITION", "MULTIPLICATION", "DIVISION", "SUBTRACTION", "MASK_ALL",
      #   "MASK_FIRST_N", "MASK_LAST_N", "VALIDATE_NON_NULL", "VALIDATE_NON_ZERO",
      #   "VALIDATE_NON_NEGATIVE", "VALIDATE_NUMERIC", "NO_OP"
      # veeva = null

      # zendesk (Optional)
      # 設定内容: Zendeskソースフィールドに対して実行される操作を指定します。
      # 設定可能な値: "PROJECTION", "GREATER_THAN", "ADDITION", "MULTIPLICATION",
      #   "DIVISION", "SUBTRACTION", "MASK_ALL", "MASK_FIRST_N", "MASK_LAST_N",
      #   "VALIDATE_NON_NULL", "VALIDATE_NON_ZERO", "VALIDATE_NON_NEGATIVE",
      #   "VALIDATE_NUMERIC", "NO_OP"
      # zendesk = null
    }
  }

  #-------------------------------------------------------------
  # トリガー設定 (trigger_config)
  #-------------------------------------------------------------
  # フローをいつ、どのように実行するかを制御します。

  trigger_config {
    # trigger_type (Required)
    # 設定内容: フロートリガーのタイプを指定します。
    # 設定可能な値:
    #   - "Scheduled": スケジュールに基づいて実行
    #   - "Event": イベントに基づいて実行
    #   - "OnDemand": オンデマンドで手動実行
    trigger_type = "OnDemand"

    #-----------------------------------------------------------
    # トリガープロパティ (trigger_properties)
    #-----------------------------------------------------------
    # スケジュールトリガーの詳細設定を定義します。
    # trigger_typeが"Scheduled"の場合に設定します。

    # trigger_properties {
    #   scheduled {
    #     # schedule_expression (Required)
    #     # 設定内容: スケジュールの実行頻度を決定するスケジュール式を指定します。
    #     # 設定可能な値: rate式（例: rate(5minutes), rate(1hour), rate(1day)）
    #     schedule_expression = "rate(1hour)"
    #
    #     # data_pull_mode (Optional)
    #     # 設定内容: 各フロー実行でインクリメンタルデータ転送を行うか、
    #     #           完全なデータ転送を行うかを指定します。
    #     # 設定可能な値:
    #     #   - "Incremental": 前回以降の差分データのみ転送
    #     #   - "Complete": 完全なデータセットを転送
    #     data_pull_mode = "Incremental"
    #
    #     # first_execution_from (Optional)
    #     # 設定内容: 最初のフロー実行でコネクタからインポートするレコードの
    #     #           日付範囲を指定します。
    #     # 設定可能な値: 有効なRFC3339タイムスタンプ
    #     first_execution_from = null
    #
    #     # schedule_start_time (Optional)
    #     # 設定内容: スケジュールトリガーフローの開始予定時刻を指定します。
    #     # 設定可能な値: 有効なRFC3339タイムスタンプ
    #     schedule_start_time = null
    #
    #     # schedule_end_time (Optional)
    #     # 設定内容: スケジュールトリガーフローの終了予定時刻を指定します。
    #     # 設定可能な値: 有効なRFC3339タイムスタンプ
    #     schedule_end_time = null
    #
    #     # schedule_offset (Optional)
    #     # 設定内容: スケジュールトリガーフローの時間間隔に追加されるオプションの
    #     #           オフセット（秒単位）を指定します。
    #     # 設定可能な値: 0〜36000の整数
    #     schedule_offset = null
    #
    #     # timezone (Optional)
    #     # 設定内容: スケジュールトリガーフローの日時を参照する際に使用する
    #     #           タイムゾーンを指定します。
    #     # 設定可能な値: タイムゾーン名（例: "America/New_York", "Asia/Tokyo"）
    #     timezone = "Asia/Tokyo"
    #   }
    # }
  }

  #-------------------------------------------------------------
  # メタデータカタログ設定 (metadata_catalog_config) - Optional
  #-------------------------------------------------------------
  # AppFlowがフローによって転送されるデータをカタログ化する際の
  # 設定を定義します。データをカタログ化する際、AppFlowはメタデータを
  # データカタログに保存します。

  # metadata_catalog_config {
  #   # Glue Data Catalog設定
  #   glue_data_catalog {
  #     # database_name (Required)
  #     # 設定内容: AppFlowが作成するメタデータテーブルを保存する
  #     #           既存のGlueデータベースの名前を指定します。
  #     database_name = "example_database"
  #
  #     # role_arn (Required)
  #     # 設定内容: AppFlowにData Catalogテーブル、データベース、
  #     #           パーティションを作成するために必要な権限を付与する
  #     #           IAMロールのARNを指定します。
  #     role_arn = "arn:aws:iam::123456789012:role/appflow-glue-role"
  #
  #     # table_prefix (Required)
  #     # 設定内容: AppFlowがS3バケット内のフォルダ名に適用する
  #     #           命名プレフィックスを指定します。
  #     table_prefix = "appflow_"
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: フローのAmazon Resource Name (ARN)
#
# - flow_status: フローの現在のステータス
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
