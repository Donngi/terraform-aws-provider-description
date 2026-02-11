# ============================================================================
# AWS Data Pipeline - Pipeline Resource Template
# ============================================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# このテンプレートは生成時点でのリソース仕様に基づいています。
# 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datapipeline_pipeline
# ============================================================================

# ============================================================================
# 重要な注意事項
# ============================================================================
# AWS Data Pipeline は新規顧客には提供されていません。
# 既存のお客様は引き続きサービスを通常通り使用できます。
# 既存ワークロードの移行について: https://aws.amazon.com/blogs/big-data/migrate-workloads-from-aws-data-pipeline/
# ============================================================================

resource "aws_datapipeline_pipeline" "example" {
  # ============================================================================
  # 必須パラメータ (Required)
  # ============================================================================

  # name - (必須) パイプラインの名前
  # パイプラインを識別するための一意の名前を指定します。
  # パイプライン定義はデータ管理のビジネスロジックを指定し、
  # パイプラインはタスクのスケジューリングと実行を行います。
  # 型: string
  # 参考: https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/what-is-datapipeline.html
  name = "tf-pipeline-example"

  # ============================================================================
  # オプションパラメータ (Optional)
  # ============================================================================

  # description - (オプション) パイプラインの説明
  # パイプラインの目的や内容を説明するテキストを指定します。
  # パイプラインの識別や管理を容易にするために使用されます。
  # 型: string
  # デフォルト: null
  description = "Example Data Pipeline created with Terraform"

  # id - (オプション/Computed) リソースID
  # Terraformが管理するリソースの一意の識別子。
  # 通常は指定せず、Terraformが自動的に管理します。
  # 型: string
  # デフォルト: computed
  # id = null

  # region - (オプション/Computed) リージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定で指定されたリージョンが使用されます。
  # AWS Data Pipelineはリージョナルサービスであり、パイプラインは
  # 特定のリージョンに作成されます。複数リージョンにまたがるリソースを
  # 使用する場合は、各リージョンにパイプラインを作成する必要があります。
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags - (オプション) タグのマップ
  # リソースに割り当てるタグを指定します。
  # タグはリソースの整理、検索、コスト配分に使用されます。
  # provider の default_tags 設定ブロックと併用する場合、
  # 同じキーのタグはこちらで上書きされます。
  # 型: map(string)
  # デフォルト: null
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "development"
    ManagedBy   = "terraform"
    Purpose     = "data-processing"
  }

  # tags_all - (オプション/Computed) 全てのタグ
  # リソースに割り当てられた全てのタグ（プロバイダーのdefault_tagsから
  # 継承されたタグを含む）のマップ。
  # 通常は指定せず、Terraformが自動的に管理します。
  # 型: map(string)
  # デフォルト: computed
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags_all = null
}

# ============================================================================
# 使用例: パイプライン定義の追加
# ============================================================================
# パイプラインの作成後、aws_datapipeline_pipeline_definition リソースを
# 使用してパイプライン定義を追加できます。
# パイプライン定義にはデータソース、処理アクティビティ、スケジュールなどの
# ビジネスロジックが含まれます。
#
# 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datapipeline_pipeline_definition
# ============================================================================

# ============================================================================
# AWS Data Pipeline の概要
# ============================================================================
# AWS Data Pipelineは、データの移動と変換を自動化するウェブサービスです。
# データドリブンなワークフローを定義でき、タスクは前のタスクの
# 正常な完了に依存させることができます。
#
# 主な構成要素:
# - Pipeline Definition: データ管理のビジネスロジックを指定
# - Pipeline: タスクをスケジューリングして実行
# - Task Runner: タスクをポーリングして実行
#
# 一般的な用途:
# - Amazon Redshiftへのデータロード
# - 非構造化データの分析
# - AWSログデータのロード
# - データのバックアップとリカバリ
# - Amazon EMRクラスターの定期実行
#
# 参考リンク:
# - AWS Data Pipeline概要: https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/what-is-datapipeline.html
# - パイプライン管理: https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/dp-managing-pipeline.html
# - 料金: https://aws.amazon.com/datapipeline/pricing/
# ============================================================================
