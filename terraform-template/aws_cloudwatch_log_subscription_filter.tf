#---------------------------------------
# aws_cloudwatch_log_subscription_filter
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-12
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter
#
# NOTE:
# CloudWatch Logsのログイベントを他のAWSサービスにストリーミング配信するためのフィルタリソースです
# 特定のパターンにマッチするログイベントを抽出してKinesis Stream、Lambda関数、Kinesis Data Firehoseに転送できます
#
# 主な用途:
# - リアルタイムログ処理のためのKinesis Streamへの配信
# - Lambda関数によるログイベント処理
# - Kinesis Data Firehoseを使用したS3やElasticsearchへのログアーカイブ
# - ログベースの監視・アラート基盤の構築
#
# 制約事項:
# - 1つのロググループに対して最大2つのサブスクリプションフィルタを設定可能
# - Kinesis StreamまたはKinesis Data Firehoseへの配信にはIAMロールが必要
# - Lambda関数への配信では、CloudWatch Logsサービスに関数の実行権限を付与する必要があります

#---------------------------------------
# リソース定義
#---------------------------------------

resource "aws_cloudwatch_log_subscription_filter" "example" {

  #---------------------------------------
  # 基本設定
  #---------------------------------------

  # 設定内容: サブスクリプションフィルタの名前
  # 設定可能な値: 1-512文字の英数字、ハイフン、アンダースコア、ピリオド
  # 省略時: 設定必須
  name = "example-subscription-filter"

  # 設定内容: フィルタを適用するロググループ名
  # 設定可能な値: 既存のCloudWatch Logsロググループ名
  # 省略時: 設定必須
  log_group_name = "/aws/lambda/example-function"

  # 設定内容: ログイベントから抽出する条件を定義するフィルタパターン
  # 設定可能な値: CloudWatch Logs Filter Pattern構文に準拠したパターン文字列（空文字列で全ログイベントを抽出）
  # 省略時: 設定必須
  filter_pattern = "[ERROR]"

  #---------------------------------------
  # 配信先設定
  #---------------------------------------

  # 設定内容: ログイベントの配信先となるAWSリソースのARN
  # 設定可能な値: Kinesis Stream、Kinesis Data Firehose、Lambda関数のARN
  # 省略時: 設定必須
  destination_arn = "arn:aws:kinesis:us-east-1:123456789012:stream/example-stream"

  # 設定内容: CloudWatch Logsが配信先リソースにアクセスするために使用するIAMロールのARN
  # 設定可能な値: 適切な信頼ポリシーとアクセス許可を持つIAMロールのARN
  # 省略時: Lambda関数への配信時は不要、Kinesis系への配信時は自動計算または既存値を使用
  role_arn = "arn:aws:iam::123456789012:role/CloudWatchLogsRole"

  #---------------------------------------
  # 配信オプション
  #---------------------------------------

  # 設定内容: Kinesis Streamへの配信時のデータ分散方法
  # 設定可能な値: "Random"（ランダムに分散）、"ByLogStream"（ログストリームごとに同じシャードに配信）
  # 省略時: null（デフォルトの配信方式を使用）
  distribution = "Random"

  # 設定内容: ログ変換後のデータにフィルタを適用するかどうか
  # 設定可能な値: true（変換後に適用）、false（変換前に適用）
  # 省略時: 自動計算されたデフォルト値を使用
  apply_on_transformed_logs = false

  # 設定内容: ログイベントに含めるシステムフィールドのセット
  # 設定可能な値: システムフィールド名の文字列セット
  # 省略時: null（システムフィールドを含めない）
  emit_system_fields = []

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースでは以下の属性が参照可能です:
#
# - id
#   サブスクリプションフィルタの一意な識別子（形式: "log_group_name:filter_name"）
#
# 参照例:
# output "subscription_filter_id" {
#   value = aws_cloudwatch_log_subscription_filter.example.id
# }
