# AWS Config Configuration Recorder Status (aws_config_configuration_recorder_status)
#---------------------------------------------------------------------------------------
# AWS Config設定レコーダーの有効化/無効化を管理
#
# Provider Version: 6.28.0
# Generated: 2025-01-XX
# NOTE: This is an auto-generated annotated template
#
# AWS Configは、AWSリソースの設定変更を記録・評価するサービスです。
# このリソースは、設定レコーダーの記録状態（有効/無効）を制御します。
# 設定レコーダーを有効化すると、対象リソースの設定変更が記録され始めます。
#
# 主な用途:
#   - AWS Configによる設定記録の開始/停止
#   - コンプライアンス監査の有効化/無効化
#   - リソース設定変更の追跡制御
#   - マルチリージョン環境での設定記録管理
#
# 前提条件:
#   - aws_config_configuration_recorderリソースが作成済みであること
#   - 設定記録用のS3バケットとIAMロールが設定済みであること
#   - AWS Config配信チャネル(aws_config_delivery_channel)が作成済みであること
#
# 制限事項:
#   - 1つのAWSアカウント・リージョンにつき、1つの設定レコーダーのみ作成可能
#   - 設定レコーダーを有効化するには、配信チャネルが必要
#   - 記録を開始すると、S3バケットへの書き込み料金が発生
#
# 参考資料:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder_status
#   - https://docs.aws.amazon.com/config/latest/developerguide/stop-start-recorder.html

#---------------------------------------------------------------------------------------
# 基本設定
#---------------------------------------------------------------------------------------

resource "aws_config_configuration_recorder_status" "example" {
  # 設定レコーダー名
  # 設定内容: 制御対象のAWS Config設定レコーダーの名前
  # 関連リソース: aws_config_configuration_recorder.name と一致させる必要がある
  # 命名規則: 1-256文字、英数字とハイフンのみ使用可能
  name = "example-recorder"

  # レコーダーの有効化状態
  # 設定内容: 設定レコーダーの記録を有効化するかどうか
  # 設定可能な値:
  #   - true:  設定レコーダーを有効化し、リソース設定の記録を開始
  #   - false: 設定レコーダーを無効化し、記録を停止
  # 注意事項:
  #   - trueに設定する前に、配信チャネル(aws_config_delivery_channel)が作成済みであること
  #   - 無効化すると、新しい設定変更は記録されないが、過去の記録は保持される
  is_enabled = true

  # リージョン指定（オプション）
  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  # 用途: マルチリージョン環境で明示的にリージョンを指定する場合に使用
  region = null
}

#---------------------------------------------------------------------------------------
# マルチリージョン設定例
#---------------------------------------------------------------------------------------

# 明示的なリージョン指定
# resource "aws_config_configuration_recorder_status" "tokyo" {
#   name       = "tokyo-recorder"
#   is_enabled = true
#   region     = "ap-northeast-1"
# }

# resource "aws_config_configuration_recorder_status" "osaka" {
#   name       = "osaka-recorder"
#   is_enabled = true
#   region     = "ap-northeast-3"
# }

#---------------------------------------------------------------------------------------
# 他リソースとの連携例
#---------------------------------------------------------------------------------------

# 設定レコーダーとステータスの完全な構成
# resource "aws_config_configuration_recorder" "example" {
#   name     = "example-recorder"
#   role_arn = aws_iam_role.config.arn
#
#   recording_group {
#     all_supported = true
#   }
# }
#
# resource "aws_config_delivery_channel" "example" {
#   name           = "example-channel"
#   s3_bucket_name = aws_s3_bucket.config.bucket
#
#   depends_on = [aws_config_configuration_recorder.example]
# }
#
# resource "aws_config_configuration_recorder_status" "example" {
#   name       = aws_config_configuration_recorder.example.name
#   is_enabled = true
#
#   # 配信チャネルが作成された後に有効化
#   depends_on = [aws_config_delivery_channel.example]
# }

#---------------------------------------------------------------------------------------
# Attributes Reference (参照可能な属性)
#---------------------------------------------------------------------------------------
# このリソースでは以下の属性が参照可能です:
#
# - id                    リソース識別子（通常はレコーダー名と同じ）
# - name                  設定レコーダーの名前
# - is_enabled            レコーダーの有効化状態（true/false）
# - region                リソースが管理されるAWSリージョン
