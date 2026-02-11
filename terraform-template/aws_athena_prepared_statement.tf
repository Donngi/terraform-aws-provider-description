#---------------------------------------------------------------
# AWS Athena Prepared Statement
#---------------------------------------------------------------
#
# Amazon Athenaのプリペアドステートメントをプロビジョニングするリソースです。
# プリペアドステートメントは、パラメータ化されたクエリを事前に定義し、
# 異なるパラメータ値で再実行できるようにします。SQLインジェクション攻撃を
# 防ぐセキュリティ機能としても有効です。
#
# AWS公式ドキュメント:
#   - Athena パラメータ化クエリ: https://docs.aws.amazon.com/athena/latest/ug/querying-with-prepared-statements.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_prepared_statement
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_athena_prepared_statement" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: プリペアドステートメントの名前を指定します。
  # 設定可能な値: 1-256文字の文字列
  # 注意: ワークグループ内で一意である必要があります。
  name = "my_prepared_statement"

  # workgroup (Required)
  # 設定内容: プリペアドステートメントが属するワークグループの名前を指定します。
  # 設定可能な値: 有効なAthenaワークグループ名
  # 関連機能: Athena ワークグループ
  #   プリペアドステートメントはワークグループ固有であり、
  #   そのワークグループ内でのみ実行可能です。
  #   - https://docs.aws.amazon.com/athena/latest/ug/workgroups.html
  workgroup = aws_athena_workgroup.example.name

  # query_statement (Required)
  # 設定内容: プリペアドステートメントのクエリ文字列を指定します。
  # 設定可能な値: パラメータプレースホルダー（?）を含むSQL文
  # 関連機能: Athena パラメータ化クエリ
  #   クエリ内の ? はパラメータプレースホルダーとして機能します。
  #   EXECUTE文でパラメータ値を指定して実行します。
  #   対応するステートメント: SELECT, INSERT INTO, CTAS, UNLOAD
  #   - https://docs.aws.amazon.com/athena/latest/ug/querying-with-prepared-statements.html
  # 注意:
  #   - パラメータ（?）はWHERE句でのみ使用可能
  #   - クォート内（'?' や "?"）では使用不可
  #   - Athenaエンジンバージョン2以上が必要
  query_statement = "SELECT * FROM my_database.my_table WHERE id = ?"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: プリペアドステートメントの簡単な説明を指定します。
  # 設定可能な値: 最大1024文字の文字列
  # 省略時: 説明なし
  description = "Example prepared statement for querying my_table by id"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: プリペアドステートメントのID
#---------------------------------------------------------------
