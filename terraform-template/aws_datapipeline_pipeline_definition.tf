# ==============================================================================
# Terraform Resource Template: aws_datapipeline_pipeline_definition
# ==============================================================================
# Generated: 2026-01-19
# Provider: hashicorp/aws
# Provider Version: 6.28.0
#
# Description:
#   Provides a DataPipeline Pipeline Definition resource. This resource is used
#   to define the objects, parameters, and values that make up a Data Pipeline.
#
# Important Notes:
#   - AWS Data Pipeline is no longer available to new customers, but existing
#     customers can continue using the service.
#   - This template represents the resource configuration at the time of generation.
#   - Always refer to the official documentation for the most up-to-date information.
#
# AWS Documentation:
#   - Pipeline Definition File Syntax: https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/dp-writing-pipeline-definition.html
#   - PutPipelineDefinition API: https://docs.aws.amazon.com/datapipeline/latest/APIReference/API_PutPipelineDefinition.html
#   - Terraform AWS Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datapipeline_pipeline_definition
# ==============================================================================

resource "aws_datapipeline_pipeline_definition" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # pipeline_id (必須)
  # 説明: パイプラインのID。通常、aws_datapipeline_pipelineリソースのIDを参照します。
  # 型: string
  pipeline_id = aws_datapipeline_pipeline.example.id

  # pipeline_object (必須、最小1つ)
  # 説明: パイプラインを定義するオブジェクトの設定ブロック。
  #       パイプラインオブジェクトは、スケジュール、アクティビティ、データノード、
  #       リソースなどのパイプラインコンポーネントを定義します。
  # ドキュメント: https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/dp-writing-pipeline-definition.html
  pipeline_object {
    # id (必須)
    # 説明: オブジェクトのID。パイプライン内で一意である必要があります。
    #       このIDは他のオブジェクトから参照される際に使用されます。
    # 型: string
    id = "Default"

    # name (必須)
    # 説明: オブジェクトの名前。オブジェクトの目的を説明する名前を設定します。
    # 型: string
    name = "Default"

    # field (オプション、複数指定可能)
    # 説明: オブジェクトのプロパティを定義するキー・バリューペアの設定ブロック。
    #       オブジェクトの種類(type)や動作を制御するパラメータを指定します。
    field {
      # key (必須)
      # 説明: フィールド識別子。プロパティ名を指定します。
      #       例: "type", "scheduleType", "workerGroup", "failureAndRerunMode" など
      # 型: string
      key = "workerGroup"

      # string_value (オプション)
      # 説明: フィールド値を文字列として表現します。
      #       ref_valueと排他的に使用されます(どちらか一方のみ指定)。
      # 型: string
      string_value = "workerGroup"

      # ref_value (オプション)
      # 説明: フィールド値を別のオブジェクトのIDとして参照します。
      #       string_valueと排他的に使用されます(どちらか一方のみ指定)。
      # 型: string
      # 例: ref_value = "MySchedule" (別のpipeline_objectのIDを参照)
      # ref_value = "ScheduleId1"
    }

    # 複数のfieldブロックを定義可能
    # field {
    #   key          = "scheduleType"
    #   string_value = "cron"
    # }
  }

  # 追加のpipeline_objectの例: スケジュール定義
  pipeline_object {
    id   = "Schedule"
    name = "Schedule"

    field {
      key          = "type"
      string_value = "Schedule"
    }

    field {
      key          = "startDateTime"
      string_value = "2012-12-12T00:00:00"
    }

    field {
      key          = "period"
      string_value = "1 hour"
    }

    field {
      key          = "endDateTime"
      string_value = "2012-12-21T18:00:00"
    }
  }

  # 追加のpipeline_objectの例: アクティビティ定義
  pipeline_object {
    id   = "SayHello"
    name = "SayHello"

    field {
      key          = "type"
      string_value = "ShellCommandActivity"
    }

    field {
      key          = "command"
      string_value = "echo hello"
    }

    field {
      key          = "parent"
      ref_value    = "Default"
    }

    field {
      key       = "schedule"
      ref_value = "Schedule"
    }
  }

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # region (オプション)
  # 説明: このリソースが管理されるリージョン。
  #       指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 型: string
  # ドキュメント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  # parameter_object (オプション、複数指定可能)
  # 説明: パイプライン定義で使用されるパラメータオブジェクトの設定ブロック。
  #       パラメータ化されたテンプレートを使用する際に、変数を定義します。
  #       パラメータは #{myVariable} の形式で参照されます。
  # ドキュメント: https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/dp-custom-templates.html
  # 制限: パイプライン定義では最大50個のパラメータを使用可能
  #
  # parameter_object {
  #   # id (必須)
  #   # 説明: パラメータオブジェクトのID。パイプライン定義内で一意である必要があります。
  #   # 型: string
  #   id = "myS3InputPath"
  #
  #   # attribute (必須、複数指定可能)
  #   # 説明: パラメータオブジェクトの属性の設定ブロック。
  #   #       パラメータの型、説明、デフォルト値などを定義します。
  #   attribute {
  #     # key (必須)
  #     # 説明: フィールド識別子。属性名を指定します。
  #     #       一般的な属性: "type", "description", "default", "watermark" など
  #     # 型: string
  #     key = "type"
  #
  #     # string_value (必須)
  #     # 説明: フィールド値を文字列として表現します。
  #     # 型: string
  #     string_value = "AWS::S3::ObjectKey"
  #   }
  #
  #   attribute {
  #     key          = "description"
  #     string_value = "S3 input path"
  #   }
  #
  #   attribute {
  #     key          = "default"
  #     string_value = "s3://mybucket/mypath"
  #   }
  # }

  # parameter_value (オプション、複数指定可能)
  # 説明: パイプライン定義で使用されるパラメータ値の設定ブロック。
  #       parameter_objectで定義されたパラメータに具体的な値を設定します。
  # 制限: パラメータ値ファイルのサイズ制限は15KB
  #
  # parameter_value {
  #   # id (必須)
  #   # 説明: パラメータ値のID。parameter_objectで定義されたIDと一致する必要があります。
  #   # 型: string
  #   id = "myS3InputPath"
  #
  #   # string_value (必須)
  #   # 説明: パラメータに設定する値を文字列として表現します。
  #   # 型: string
  #   string_value = "s3://my-actual-bucket/input/"
  # }

  # ============================================================================
  # Computed Attributes (読み取り専用)
  # ============================================================================
  # 以下の属性はTerraformによって自動的に計算され、読み取り専用です。
  # これらの属性はリソース作成後に参照可能です。
  #
  # - id: データパイプライン定義の一意のID
  #
  # 使用例:
  # output "pipeline_definition_id" {
  #   value = aws_datapipeline_pipeline_definition.example.id
  # }
}

# ==============================================================================
# Pipeline Object Types (参考情報)
# ==============================================================================
# 以下は一般的なパイプラインオブジェクトタイプの例です。
# 各オブジェクトタイプには固有のフィールドが必要です。
#
# 1. Schedule (スケジュール)
#    - type: "Schedule"
#    - startDateTime: 開始日時
#    - period: 実行間隔 (例: "1 day", "1 hour")
#    - endDateTime: 終了日時 (オプション)
#
# 2. ShellCommandActivity (シェルコマンドアクティビティ)
#    - type: "ShellCommandActivity"
#    - command: 実行するコマンド
#    - schedule: スケジュールオブジェクトへの参照
#
# 3. S3DataNode (S3データノード)
#    - type: "S3DataNode"
#    - filePath: S3のファイルパス
#    - schedule: スケジュールオブジェクトへの参照
#
# 4. RedshiftDataNode (Redshiftデータノード)
#    - type: "RedshiftDataNode"
#    - tableName: テーブル名
#    - database: データベースオブジェクトへの参照
#    - schedule: スケジュールオブジェクトへの参照
#
# 5. Ec2Resource (EC2リソース)
#    - type: "Ec2Resource"
#    - instanceType: インスタンスタイプ (例: "t2.micro")
#    - schedule: スケジュールオブジェクトへの参照
#
# 6. Default (デフォルトオブジェクト)
#    - すべてのオブジェクトに共通するフィールドを定義
#    - scheduleType, failureAndRerunMode, pipelineLogUri など
#
# 詳細: https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/dp-writing-pipeline-definition.html
# ==============================================================================
