#---------------------------------------------------------------
# AWS Glue ML Transform
#---------------------------------------------------------------
#
# AWS Glue機械学習トランスフォームをプロビジョニングします。
# 主にFindMatchesアルゴリズムを使用してデータセット内の一致レコードを
# 検出するための機械学習変換を定義します。
#
# AWS公式ドキュメント:
#   - Tutorial: Creating a machine learning transform with AWS Glue:
#     https://docs.aws.amazon.com/glue/latest/dg/machine-learning-transform-tutorial.html
#   - FindMatches Class:
#     https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-crawler-pyspark-transforms-findmatches.html
#   - Teaching the Find Matches transform:
#     https://docs.aws.amazon.com/glue/latest/dg/machine-learning-teaching.html
#   - FindMatches Metrics:
#     https://docs.aws.amazon.com/glue/latest/webapi/API_FindMatchesMetrics.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_ml_transform
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_ml_transform" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (Required) ML Transformに割り当てる名前
  # アカウント内で一意である必要があります
  name = "example-ml-transform"

  # (Required) このML Transformに関連付けられるIAMロールのARN
  # Glue MLジョブの実行に必要な権限を持つロールを指定します
  role_arn = "arn:aws:iam::123456789012:role/glue-ml-transform-role"

  #---------------------------------------------------------------
  # Input Record Tables (Required)
  #---------------------------------------------------------------
  # トランスフォームで使用するGlueテーブル定義のリスト
  # 最低1つのテーブルを指定する必要があります
  input_record_tables {
    # (Required) AWS Glue Data Catalogのデータベース名
    database_name = "example_database"

    # (Required) AWS Glue Data Catalogのテーブル名
    table_name = "example_table"

    # (Optional) AWS Glue Data Catalogの一意識別子
    # 未指定の場合、現在のアカウントのカタログIDが使用されます
    # catalog_id = "123456789012"

    # (Optional) Glue接続名
    # JDBCデータソースなどの接続が必要な場合に指定します
    # connection_name = "example-connection"
  }

  #---------------------------------------------------------------
  # Parameters (Required)
  #---------------------------------------------------------------
  # トランスフォームタイプに固有のアルゴリズムパラメータ
  parameters {
    # (Required) 機械学習トランスフォームのタイプ
    # 現在は "FIND_MATCHES" のみがサポートされています
    # 参照: https://docs.aws.amazon.com/glue/latest/dg/add-job-machine-learning-transform.html
    transform_type = "FIND_MATCHES"

    # Find Matchesアルゴリズムのパラメータ
    find_matches_parameters {
      # (Optional) ソーステーブルの行を一意に識別するカラムの名前
      # このカラムは重複レコードの検出に使用されます
      primary_key_column_name = "id"

      # (Optional) 精度とコストのバランスを調整する際に選択される値
      # 0.0から1.0の範囲で指定します
      # 高い値ほど精度が向上しますがコストが増加します
      # accuracy_cost_trade_off = 0.5

      # (Optional) ユーザーが提供したラベルに一致するように出力を強制するか
      # trueに設定すると、提供されたラベルが必ず尊重されます
      # enforce_provided_labels = false

      # (Optional) 精度と再現率のバランスを調整する際に選択される値
      # 0.0から1.0の範囲で指定します
      # 高い値ほど再現率が向上し、低い値ほど精度が向上します
      # precision_recall_trade_off = 0.5
    }
  }

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (Optional) ML Transformの説明
  # トランスフォームの用途や目的を記述します
  # description = "Example ML Transform for finding duplicate records"

  # (Optional) 使用するGlueのバージョン（例: "1.0", "2.0", "3.0"）
  # 利用可能なバージョンについては以下を参照:
  # https://docs.aws.amazon.com/glue/latest/dg/release-notes.html
  # glue_version = "3.0"

  # (Optional) このトランスフォームのタスク実行に割り当てられるGlue DPU数
  # 2から100までの範囲で指定可能（デフォルト: 10）
  # number_of_workers および worker_type と相互排他的なオプションです
  # max_capacity = 10

  # (Optional) ML Transformが失敗した場合の最大再試行回数
  # max_retries = 0

  # (Optional) ML Transformのタイムアウト（分単位）
  # デフォルトは2880分（48時間）です
  # timeout = 2880

  # (Optional) ML Transform実行時に割り当てられる定義済みワーカータイプ
  # "Standard", "G.1X", "G.2X" のいずれかを指定します
  # number_of_workers と併用する必要があります
  # worker_type = "G.1X"

  # (Optional) ML Transform実行時に割り当てられるワーカー数
  # worker_type と併用する必要があります
  # number_of_workers = 5

  # (Optional) リソースに適用するタグのキーバリューマップ
  # provider default_tagsと併用可能です
  # tags = {
  #   Environment = "production"
  #   Application = "data-quality"
  # }

  # (Optional) リージョン指定
  # 指定しない場合はプロバイダー設定のリージョンが使用されます
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed only）:
#
# - arn         : Glue ML TransformのAmazon Resource Name (ARN)
# - id          : Glue ML Transform ID
# - label_count : このトランスフォームで利用可能なラベルの数
# - schema      : このトランスフォームが受け付けるスキーマを表すオブジェクト
#                 各要素には以下が含まれます:
#                 - name      : カラム名
#                 - data_type : カラムのデータタイプ
# - tags_all    : リソースに割り当てられたタグのマップ
#                 （provider default_tagsを含む）
#---------------------------------------------------------------
