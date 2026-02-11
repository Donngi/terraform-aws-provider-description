#---------------------------------------------------------------
# AWS Clean Rooms Configured Table
#---------------------------------------------------------------
#
# AWS Clean Roomsの設定済みテーブル（Configured Table）をプロビジョニングする
# リソースです。設定済みテーブルは、AWS Glue Data Catalogに存在する既存の
# テーブルへの参照を表し、コラボレーション内でデータを安全に分析・共有する
# ために使用されます。
#
# AWS公式ドキュメント:
#   - AWS Clean Rooms概要: https://docs.aws.amazon.com/clean-rooms/latest/userguide/what-is.html
#   - 設定済みテーブルの作成: https://docs.aws.amazon.com/clean-rooms/latest/userguide/create-configured-table.html
#   - 設定済みテーブルの概念: https://docs.aws.amazon.com/clean-rooms/latest/userguide/working-with-configured-tables.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cleanrooms_configured_table
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cleanrooms_configured_table" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 設定済みテーブルの名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "example-configured-table"

  # description (Optional)
  # 設定内容: 設定済みテーブルの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: テーブルの目的や内容を他のコラボレーションメンバーに説明するために使用
  description = "Example configured table for AWS Clean Rooms collaboration"

  #-------------------------------------------------------------
  # 分析メソッド設定
  #-------------------------------------------------------------

  # analysis_method (Required)
  # 設定内容: 設定済みテーブルの分析メソッドを指定します。
  # 設定可能な値:
  #   - "DIRECT_QUERY": テーブルに対して直接クエリを実行可能
  # 注意: 現時点では "DIRECT_QUERY" のみがサポートされています
  # 関連機能: AWS Clean Rooms 分析ルール
  #   分析ルールにより、SQLクエリの制限と出力制約を設定できます。
  #   - https://docs.aws.amazon.com/clean-rooms/latest/userguide/analysis-rules.html
  analysis_method = "DIRECT_QUERY"

  #-------------------------------------------------------------
  # カラム設定
  #-------------------------------------------------------------

  # allowed_columns (Required, Forces new resource)
  # 設定内容: 設定済みテーブルに含める参照テーブルのカラムを指定します。
  # 設定可能な値: カラム名の集合（set）
  # 注意: この設定を変更すると、リソースが再作成されます
  # 用途: コラボレーションで共有・分析可能なカラムを制限するために使用
  allowed_columns = [
    "column1",
    "column2",
    "column3",
  ]

  #-------------------------------------------------------------
  # テーブル参照設定
  #-------------------------------------------------------------

  # table_reference (Required, Forces new resource)
  # 設定内容: 設定済みテーブルの作成に使用するAWS Glueテーブルへの参照を指定します。
  # 注意: この設定を変更すると、リソースが再作成されます
  # 関連機能: AWS Glue Data Catalog
  #   AWS GlueのData Catalogに登録されているテーブルを参照します。
  #   - https://docs.aws.amazon.com/glue/latest/dg/what-is-glue.html
  table_reference {
    # database_name (Required, Forces new resource)
    # 設定内容: AWS Glueデータベースの名前を指定します。
    # 設定可能な値: AWS Glue Data Catalog内の有効なデータベース名
    database_name = "example_database"

    # table_name (Required, Forces new resource)
    # 設定内容: 設定済みテーブルの作成に使用するAWS Glueテーブルの名前を指定します。
    # 設定可能な値: 指定したデータベース内の有効なテーブル名
    table_name = "example_table"
  }

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
  # 用途: リソースの識別、コスト配分、アクセス制御などに使用
  tags = {
    Name        = "example-configured-table"
    Environment = "production"
    Project     = "clean-rooms-collaboration"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新・削除操作のタイムアウトを指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 設定済みテーブルのAmazon Resource Name (ARN)
#
# - id: 設定済みテーブルのID
#
# - create_time: 設定済みテーブルが作成された日時
#
# - update_time: 設定済みテーブルが最後に更新された日時
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
