#---------------------------------------------------------------
# AWS CloudWatch Log Account Policy
#---------------------------------------------------------------
#
# Amazon CloudWatch Logsのアカウントレベルポリシーをプロビジョニングするリソースです。
# アカウントレベルポリシーは、アカウント内の全ロググループまたは指定したロググループに
# 対して適用されるポリシーを定義します。ポリシータイプには、データ保護、サブスクリプション
# フィルター、フィールドインデックス、トランスフォーマーなどがあります。
#
# AWS公式ドキュメント:
#   - CloudWatch Logs概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html
#   - データ保護ポリシー: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/mask-sensitive-log-data.html
#   - PutAccountPolicy API: https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_PutAccountPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_account_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_log_account_policy" "example" {
  #-------------------------------------------------------------
  # ポリシー名設定
  #-------------------------------------------------------------

  # policy_name (Required)
  # 設定内容: アカウントポリシーの名前を指定します。
  # 設定可能な値: 任意の文字列
  policy_name = "example-policy"

  #-------------------------------------------------------------
  # ポリシータイプ設定
  #-------------------------------------------------------------

  # policy_type (Required)
  # 設定内容: アカウントポリシーのタイプを指定します。
  # 設定可能な値:
  #   - "DATA_PROTECTION_POLICY": 機密データを監査・マスキングするデータ保護ポリシー
  #   - "SUBSCRIPTION_FILTER_POLICY": ログイベントをリアルタイムで他のAWSサービスにフィードするサブスクリプションフィルターポリシー
  #   - "FIELD_INDEX_POLICY": CloudWatch Logs Insightsクエリのパフォーマンス向上のためのフィールドインデックスポリシー
  #   - "TRANSFORMER_POLICY": ログイベントを異なるフォーマットに変換するトランスフォーマーポリシー
  # 注意: アカウントごとに各タイプのポリシーは1つのみ設定可能（または selection_criteria を使用して最大20個まで）
  policy_type = "DATA_PROTECTION_POLICY"

  #-------------------------------------------------------------
  # ポリシードキュメント設定
  #-------------------------------------------------------------

  # policy_document (Required)
  # 設定内容: アカウントポリシーのJSON形式のテキストを指定します。
  # 設定可能な値: ポリシータイプに応じたJSON形式の文字列
  # 関連機能: CloudWatch Logsアカウントポリシー
  #   ポリシータイプごとに異なるフォーマットのJSONドキュメントが必要です。
  #   - DATA_PROTECTION_POLICY: 監査とマスキングの設定を含むJSONブロック
  #   - SUBSCRIPTION_FILTER_POLICY: DestinationArn, FilterPattern, RoleArn等を含むJSON
  #   - FIELD_INDEX_POLICY: インデックス対象のFieldsを含むJSON
  #   - TRANSFORMER_POLICY: プロセッサー設定を含むJSONブロック
  #   - https://docs.aws.amazon.com/cli/latest/reference/logs/put-account-policy.html
  policy_document = jsonencode({
    Name    = "DataProtection"
    Version = "2021-06-01"

    Statement = [
      {
        Sid            = "Audit"
        DataIdentifier = ["arn:aws:dataprotection::aws:data-identifier/EmailAddress"]
        Operation = {
          Audit = {
            FindingsDestination = {}
          }
        }
      },
      {
        Sid            = "Redact"
        DataIdentifier = ["arn:aws:dataprotection::aws:data-identifier/EmailAddress"]
        Operation = {
          Deidentify = {
            MaskConfig = {}
          }
        }
      }
    ]
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

  #-------------------------------------------------------------
  # スコープ設定
  #-------------------------------------------------------------

  # scope (Optional)
  # 設定内容: アカウントポリシーのスコープを指定します。
  # 設定可能な値:
  #   - "ALL" (デフォルト): アカウント内のすべてのロググループに適用
  # 省略時: "ALL"がデフォルト値として使用されます
  scope = null

  #-------------------------------------------------------------
  # 選択条件設定
  #-------------------------------------------------------------

  # selection_criteria (Optional)
  # 設定内容: サブスクリプションフィルターポリシー等を適用するロググループの選択条件を指定します。
  # 設定可能な値: 文字列形式の選択条件
  #   - LogGroupName NOT IN ["excluded_log_group_name"]: 指定したロググループを除外
  #   - LogGroupNamePrefix IN ["prefix1", "prefix2"]: 指定したプレフィックスに一致するロググループのみを対象
  # 関連機能: CloudWatch Logsポリシーの選択条件
  #   SUBSCRIPTION_FILTER_POLICYで使用すると、特定のロググループのみにフィルターを適用可能。
  #   無限ループの防止などに有用です。
  #   - https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_PutAccountPolicy.html
  # 注意: selection_criteria文字列の最大長は25KBです
  selection_criteria = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシー名とポリシータイプをコロン(:)で連結した識別子
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# resource "aws_cloudwatch_log_account_policy" "subscription_filter" {
#   policy_name = "subscription-filter"
#   policy_type = "SUBSCRIPTION_FILTER_POLICY"
#   policy_document = jsonencode(
#     {
#       DestinationArn = aws_lambda_function.example.arn
#       FilterPattern  = "test"
#     }
#   )
#   selection_criteria = "LogGroupName NOT IN [\"excluded_log_group_name\"]"
# }

#---------------------------------------------------------------
# resource "aws_cloudwatch_log_account_policy" "field_index" {
#   policy_name = "field-index"
#   policy_type = "FIELD_INDEX_POLICY"
#   policy_document = jsonencode(
#     {
#       Fields = [
#         "requestId",
#         "sessionId"
#       ]
#     }
#   )
# }
