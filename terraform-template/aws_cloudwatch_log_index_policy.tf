#---------------------------------------------------------------
# AWS CloudWatch Log Index Policy
#---------------------------------------------------------------
#
# Amazon CloudWatch Logsのフィールドインデックスポリシーをプロビジョニングするリソースです。
# フィールドインデックスポリシーは、ログイベント内のフィールドにインデックスを作成し、
# CloudWatch Logs Insightsのクエリパフォーマンスを向上させ、コストを削減します。
#
# フィールドインデックスの特徴:
#   - 最大20個のフィールドをインデックス化可能
#   - インデックス化されたフィールドは最大30日間保持
#   - ファセットとして設定することでインタラクティブなログ分析が可能
#   - Standardログクラスのロググループのみサポート
#
# AWS公式ドキュメント:
#   - フィールドインデックス概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatchLogs-Field-Indexing.html
#   - PutIndexPolicy API: https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_PutIndexPolicy.html
#   - フィールドインデックスの構文とクォータ: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatchLogs-Field-Indexing-Syntax.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_index_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_log_index_policy" "example" {
  #-------------------------------------------------------------
  # ロググループ設定
  #-------------------------------------------------------------

  # log_group_name (Required)
  # 設定内容: インデックスポリシーを適用するロググループの名前を指定します。
  # 設定可能な値: 既存のロググループ名またはロググループARN
  # 注意: ロググループはStandardログクラスである必要があります。
  #       Infrequent AccessログクラスやDeliveryログクラスはサポートされていません。
  log_group_name = aws_cloudwatch_log_group.example.name

  #-------------------------------------------------------------
  # ポリシードキュメント設定
  #-------------------------------------------------------------

  # policy_document (Required)
  # 設定内容: フィールドインデックスポリシーをJSON形式で指定します。
  # 設定可能な値: JSON形式の文字列
  #
  # ポリシードキュメントの構造:
  #   - Fields: インデックス化するフィールド名の配列（FIELD_INDEXタイプ）
  #   - FieldsV2: フィールド名とタイプを指定するオブジェクト
  #     - type: "FIELD_INDEX" または "FACET"
  #       - FIELD_INDEX: クエリパフォーマンス向上用のインデックス
  #       - FACET: インタラクティブな探索とフィルタリング用（Logs Insightsコンソールで使用）
  #
  # 制限事項:
  #   - 最大20フィールドまでインデックス化可能
  #   - 各フィールド名は最大100文字
  #   - フィールド名の一致は大文字小文字を区別（RequestId と requestId は別扱い）
  #   - FieldsとFieldsV2内のフィールド名は重複不可
  #
  # デフォルトインデックス（追加設定不要で利用可能）:
  #   - @logStream, @aws.region, @aws.account, @source.log, traceId
  #
  # 関連機能: CloudWatch Logs フィールドインデックス
  #   ログイベント内の特定フィールドにインデックスを作成することで、
  #   CloudWatch Logs Insightsクエリの処理を高速化し、スキャンコストを削減します。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatchLogs-Field-Indexing.html
  policy_document = jsonencode({
    # 基本的なフィールドインデックスの例（FIELD_INDEXタイプとして作成）
    Fields = ["requestId", "transactionId"]

    # FieldsV2を使用した詳細な設定例
    # FieldsV2 = {
    #   "userId" = {
    #     type = "FIELD_INDEX"
    #   }
    #   "statusCode" = {
    #     type = "FACET"
    #   }
    #   "apiName" = {
    #     type = "FACET"
    #   }
    # }
  })

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# 依存リソース例
#---------------------------------------------------------------

resource "aws_cloudwatch_log_group" "example" {
  name = "example-log-group"

  # インデックスポリシーはStandardログクラスのみサポート
  log_group_class = "STANDARD"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースにはスキーマ上定義された追加のエクスポート属性はありません。
# 標準属性（id等）はTerraformにより自動的にエクスポートされます。
#---------------------------------------------------------------
