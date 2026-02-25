#---------------------------------------------------------------
# AWS Glue Data Quality Ruleset
#---------------------------------------------------------------
#
# AWS Glue データ品質ルールセットをプロビジョニングするリソースです。
# データ品質ルールセットはDQDL（Data Quality Definition Language）で記述したルールを
# 定義し、Glueカタログのテーブルに関連付けることでデータ品質評価を実行できます。
# ルールセットはデータの完全性、一意性、型チェックなどの多様な品質指標を検証します。
#
# AWS公式ドキュメント:
#   - Glue Data Qualityの概要: https://docs.aws.amazon.com/glue/latest/dg/glue-data-quality.html
#   - DQDLリファレンス: https://docs.aws.amazon.com/glue/latest/dg/dqdl.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_data_quality_ruleset
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_data_quality_ruleset" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: データ品質ルールセットの一意な名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列（最大255文字）
  # 注意: 変更するとリソースが再作成されます。
  name = "example-ruleset"

  # ruleset (Required)
  # 設定内容: DQDL（Data Quality Definition Language）形式のルール定義文字列を指定します。
  # 設定可能な値: 有効なDQDL構文の文字列。主なルールの例:
  #   - Completeness "列名" between 0.0 and 1.0 : 完全性チェック（NULLでない値の割合）
  #   - Uniqueness "列名" > 0.95               : 一意性チェック
  #   - ColumnValues "列名" > 0                 : 列値の条件チェック
  #   - IsComplete "列名"                       : 列がNULLでないことを確認
  #   - IsUnique "列名"                         : 列が一意であることを確認
  #   - ColumnCount = 5                         : 列数のチェック
  #   - RowCount > 100                          : 行数のチェック
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/dqdl.html
  ruleset = "Rules = [Completeness \"colA\" between 0.4 and 0.8]"

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
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: データ品質ルールセットの説明文を指定します。
  # 設定可能な値: 任意の文字列（最大2048文字）
  # 省略時: 説明なし
  description = "Example Glue Data Quality Ruleset"

  #-------------------------------------------------------------
  # ターゲットテーブル設定
  #-------------------------------------------------------------

  # target_table (Optional, Forces new resource)
  # 設定内容: ルールセットに関連付けるGlueカタログのテーブルを指定する設定ブロックです。
  # 指定するとルールセットがそのテーブルに紐付けられ、データ品質評価実行時に参照されます。
  # 注意: 変更するとリソースが再作成されます。
  target_table {

    # database_name (Required, Forces new resource)
    # 設定内容: 対象テーブルが存在するGlueカタログのデータベース名を指定します。
    # 設定可能な値: 既存のGlueデータカタログデータベース名
    # 注意: 変更するとリソースが再作成されます。
    database_name = "example_database"

    # table_name (Required, Forces new resource)
    # 設定内容: データ品質評価の対象となるGlueカタログのテーブル名を指定します。
    # 設定可能な値: 既存のGlueカタログテーブル名
    # 注意: 変更するとリソースが再作成されます。
    table_name = "example_table"

    # catalog_id (Optional, Forces new resource)
    # 設定内容: 対象テーブルが存在するGlueカタログのアカウントIDを指定します。
    # 設定可能な値: 12桁のAWSアカウントID
    # 省略時: プロバイダーが使用しているAWSアカウントのカタログを使用
    # 注意: 変更するとリソースが再作成されます。
    catalog_id = null
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 参考: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-ruleset"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: データ品質ルールセットのAmazon Resource Name (ARN)
# - created_on: ルールセットが作成された日時
# - last_modified_on: ルールセットが最後に変更された日時
# - recommendation_run_id: 推奨実行からルールセットが作成された場合の実行ID
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
