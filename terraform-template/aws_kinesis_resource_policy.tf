#---------------------------------------------------------------
# Amazon Kinesis Data Streams Resource Policy
#---------------------------------------------------------------
#
# Amazon Kinesis Data Streams のデータストリームまたはコンシューマーに
# リソースベースポリシーをアタッチするリソースです。
# クロスアカウントアクセスの許可に使用します。
#
# AWS公式ドキュメント:
#   - Kinesis Data Streams リソースベースポリシー: https://docs.aws.amazon.com/streams/latest/dev/resource-based-policy-examples.html
#   - PutResourcePolicy API: https://docs.aws.amazon.com/kinesis/latest/APIReference/API_PutResourcePolicy.html
#   - Kinesis Data Streams アクセス制御: https://docs.aws.amazon.com/streams/latest/dev/controlling-access.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kinesis_resource_policy" "example" {
  #-------------------------------------------------------------
  # 対象リソース設定
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: ポリシーをアタッチするデータストリームまたはコンシューマーのARNを指定します。
  # 設定可能な値: 有効なKinesis Data StreamsのデータストリームまたはコンシューマーのARN
  # 参考: https://docs.aws.amazon.com/kinesis/latest/APIReference/API_PutResourcePolicy.html
  resource_arn = aws_kinesis_stream.example.arn

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: リソースにアタッチするIAMポリシードキュメントをJSON形式で指定します。
  # 設定可能な値: 有効なJSONポリシードキュメント文字列
  # 注意: クロスアカウントアクセスを許可する場合、呼び出し元のIDはリソースオーナーの
  #       アカウントに属している必要があります。
  # 参考: https://docs.aws.amazon.com/streams/latest/dev/resource-based-policy-examples.html
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "writePolicy"
    Statement = [
      {
        Sid    = "writestatement"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "kinesis:DescribeStreamSummary",
          "kinesis:ListShards",
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ]
        Resource = aws_kinesis_stream.example.arn
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
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースポリシーがアタッチされたデータストリームまたはコンシューマーのARN
#---------------------------------------------------------------
