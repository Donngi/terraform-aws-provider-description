#---------------------------------------------------------------
# AWS CloudWatch Log Destination Policy
#---------------------------------------------------------------
#
# CloudWatch Logsのデスティネーションに対するアクセスポリシーを
# プロビジョニングするリソースです。
#
# デスティネーションポリシーは、他のAWSアカウントがクロスアカウント
# サブスクリプションを通じてログデータを送信できるようにするための
# リソースベースのポリシーを定義します。
#
# AWS公式ドキュメント:
#   - CloudWatch Logsアクセス管理概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/iam-access-control-overview-cwl.html
#   - クロスアカウントサブスクリプション設定: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Cross-Account-Log_Subscription-New.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_destination_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_log_destination_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # destination_name (Required)
  # 設定内容: アクセスポリシーを適用するデスティネーションの名前を指定します。
  # 設定可能な値: 既存のCloudWatch Logsデスティネーションの名前
  # 関連機能: CloudWatch Logs デスティネーション
  #   デスティネーションは、クロスアカウントログサブスクリプションの
  #   ターゲットとして機能するリソースです。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CrossAccountSubscriptions.html
  destination_name = "my-log-destination"

  # access_policy (Required)
  # 設定内容: デスティネーションに関連付けるアクセスポリシードキュメントを指定します。
  # 設定可能な値: JSON形式のIAMポリシードキュメント文字列
  # 関連機能: CloudWatch Logs リソースベースポリシー
  #   どのAWSアカウントがこのデスティネーションに対してサブスクリプション
  #   フィルターを作成できるかを制御します。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/iam-access-control-overview-cwl.html
  # 注意: aws_iam_policy_documentデータソースを使用してポリシーを生成することを推奨
  access_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCrossAccountSubscription"
        Effect = "Allow"
        Principal = {
          AWS = "123456789012"
        }
        Action   = "logs:PutSubscriptionFilter"
        Resource = "arn:aws:logs:ap-northeast-1:987654321098:destination:my-log-destination"
      }
    ]
  })

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # force_update (Optional)
  # 設定内容: 組織IDへの権限付与に変更する際に強制更新を行うかを指定します。
  # 設定可能な値:
  #   - true: 既存のデスティネーションポリシーを更新して、個別のAWSアカウントへの
  #           権限付与から組織ID全体への権限付与に変更する場合に指定
  #   - false (デフォルト): 通常の更新動作
  # 用途: 個別アカウントへの権限付与から組織全体への権限付与に移行する際に使用
  force_update = null

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
#
# # デスティネーションリソース
# resource "aws_cloudwatch_log_destination" "example" {
#   name       = "my-log-destination"
#   role_arn   = aws_iam_role.cloudwatch_to_kinesis.arn
#   target_arn = aws_kinesis_stream.log_stream.arn
# }
#
# # ポリシードキュメント定義
# data "aws_iam_policy_document" "destination_policy" {
#   statement {
#     effect = "Allow"
#
#     principals {
#       type        = "AWS"
#       identifiers = ["123456789012"]
#     }
#
#     actions   = ["logs:PutSubscriptionFilter"]
#     resources = [aws_cloudwatch_log_destination.example.arn]
#   }
# }
#
# # デスティネーションポリシー
# resource "aws_cloudwatch_log_destination_policy" "example" {
#   destination_name = aws_cloudwatch_log_destination.example.name
#   access_policy    = data.aws_iam_policy_document.destination_policy.json
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: デスティネーション名と同じ値
#---------------------------------------------------------------
