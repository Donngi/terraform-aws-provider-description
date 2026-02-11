#---------------------------------------------------------------
# AWS Glue Data Quality Ruleset
#---------------------------------------------------------------
#
# AWS Glue Data Quality Rulesetは、データ品質を評価するためのルールセット
# を定義します。Data Quality Definition Language (DQDL)を使用してルールを
# 記述し、AWS Glueテーブルのデータ品質をチェックします。
#
# AWS公式ドキュメント:
#   - Data Quality rule builder: https://docs.aws.amazon.com/glue/latest/dg/data-quality-rule-builder.html
#   - Getting started with AWS Glue Data Quality: https://docs.aws.amazon.com/glue/latest/dg/data-quality-getting-started.html
#   - Data Quality API: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-data-quality-api.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_data_quality_ruleset
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_data_quality_ruleset" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # データ品質ルールセットの名前
  # - 新しいリソースを強制的に作成します（Forces new resource）
  # - AWS Glueアカウント内で一意である必要があります
  name = "example-ruleset"

  # Data Quality Definition Language (DQDL)ルールセット
  # - AWS Glueのデータ品質ルールを記述するDQDLを使用します
  # - 例: "Rules = [Completeness \"colA\" between 0.4 and 0.8]"
  # - 複数のルールをカンマで区切って記述できます
  # - 26種類の組み込みルールタイプが利用可能です
  # - 詳細: https://docs.aws.amazon.com/glue/latest/dg/data-quality-rule-builder.html
  ruleset = "Rules = [Completeness \"column_name\" between 0.4 and 0.8]"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # データ品質ルールセットの説明
  # - ルールセットの目的や内容を説明するテキスト
  # - 最大2048文字まで
  description = "Example data quality ruleset for monitoring data completeness"

  # AWSリージョン
  # - このリソースが管理されるリージョンを指定します
  # - 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # - 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # リソースタグ
  # - Key-Value形式のタグマップ
  # - プロバイダーのdefault_tagsと組み合わせて使用できます
  # - タグはコスト配分、リソース管理、アクセス制御に使用できます
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "data-quality-monitoring"
  }

  #---------------------------------------------------------------
  # ネストブロック: target_table
  #---------------------------------------------------------------
  # データ品質ルールセットに関連付けられるターゲットテーブル
  # - 指定すると、このルールセットは特定のGlueテーブルに関連付けられます
  # - 最大1つのtarget_tableブロックを指定できます
  # - 新しいリソースを強制的に作成します（Forces new resource）

  target_table {
    # AWS Glueテーブルが存在するデータベース名（必須）
    # - 新しいリソースを強制的に作成します（Forces new resource）
    database_name = "example_database"

    # AWS Glueテーブルの名前（必須）
    # - 新しいリソースを強制的に作成します（Forces new resource）
    table_name = "example_table"

    # AWS Glueテーブルが存在するカタログID（オプション）
    # - 指定しない場合、現在のアカウントのカタログIDが使用されます
    # - 新しいリソースを強制的に作成します（Forces new resource）
    # - クロスアカウントアクセスの場合に使用します
    # catalog_id = "123456789012"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はTerraform実行後に参照可能です（computed）:
#
# - arn
#     AWS Glue Data Quality RulesetのARN
#     例: arn:aws:glue:us-east-1:123456789012:dataQualityRuleset/example-ruleset
#
# - created_on
#     データ品質ルールセットが作成された日時
#     RFC3339形式のタイムスタンプ
#
# - id
#     リソースID（通常はnameと同じ値）
#
# - last_modified_on
#     データ品質ルールセットが最後に変更された日時
#     RFC3339形式のタイムスタンプ
#
# - recommendation_run_id
#     推奨実行からルールセットが作成された場合、2つをリンクするために生成された実行ID
#     手動で作成されたルールセットの場合は空
#
# - tags_all
#     リソースに割り当てられたすべてのタグのマップ
#     プロバイダーのdefault_tagsから継承されたタグを含む
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のAWS Glue Data Quality Rulesetは以下のコマンドでインポートできます:
#
# terraform import aws_glue_data_quality_ruleset.example example-ruleset
#
# nameパラメータを使用してインポートします。
#---------------------------------------------------------------
