#-------
# AWS Data Pipeline - Pipeline リソース定義
#-------
# Provider Version: 6.28.0
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/datapipeline_pipeline
#
# 用途: データ処理ワークフローの定義と実行を自動化するパイプラインを作成
# 補足: ETL処理、データ移行、定期的なデータ処理などのワークフローを定義
# 関連: aws_datapipeline_pipeline_definition（パイプライン定義）
#       aws_iam_role（パイプライン実行ロール）
# ドキュメント: https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/what-is-datapipeline.html
#
# NOTE: このリソースはパイプライン本体のみを作成します。
#       パイプライン定義（オブジェクト、アクティビティ等）の設定には
#       AWS CLIまたはaws_datapipeline_pipeline_definitionリソースを使用してください。
#-------

#-------
# 基本設定
#-------
resource "aws_datapipeline_pipeline" "example" {
  # パイプライン名
  # 設定内容: パイプラインを識別するための一意の名前
  # 設定可能な値: 1〜1024文字の文字列（英数字、ハイフン、アンダースコアを使用可能）
  name = "example-pipeline"

  # パイプラインの説明
  # 設定内容: パイプラインの目的や処理内容を説明するテキスト
  # 省略時: 説明なし
  description = "Example data pipeline for ETL processing"

  #-------
  # リソース配置設定
  #-------
  # リージョン設定
  # 設定内容: パイプラインを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: パイプライン作成後のリージョン変更は不可（再作成が必要）
  region = "us-east-1"

  #-------
  # タグ設定
  #-------
  # リソースタグ
  # 設定内容: パイプラインに付与するキー・バリュー形式のメタデータ
  # 用途: コスト管理、リソース分類、アクセス制御などに使用
  tags = {
    Environment = "Production"
    Application = "DataProcessing"
    ManagedBy   = "Terraform"
  }
}

#-------
# Attributes Reference (参照可能な属性)
#-------
# このリソース作成後に参照できる属性:
#
# id - パイプラインの一意識別子（AWS割り当て）
#      形式: df-xxxxxxxxxx の形式
#      用途: 他リソースからの参照、パイプライン定義の関連付け
#
# region - パイプラインが配置されているリージョン
#          省略時はプロバイダー設定のリージョンが設定される
#
# tags_all - リソースに割り当てられた全タグのマップ
#            プロバイダーレベルのデフォルトタグも含む
#
# 参照例:
#   aws_datapipeline_pipeline.example.id
#   aws_datapipeline_pipeline.example.region
#-------
