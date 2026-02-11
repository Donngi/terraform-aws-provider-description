#---------------------------------------------------------------
# Amazon Kinesis Data Streams Resource Policy
#---------------------------------------------------------------
#
# Amazon Kinesis Data Streams のリソースベースポリシーを管理するリソース。
# データストリームまたは登録済みコンシューマへのクロスアカウントアクセスを
# 制御するためのリソースポリシーを設定します。
#
# ユースケース:
#   - 別のAWSアカウントからのKinesisストリームへのアクセス許可
#   - クロスアカウントLambda関数によるストリームの読み取り
#   - クロスアカウントKCLコンシューマによるデータ処理
#   - 登録済みコンシューマ（Enhanced Fan-Out）への細かいアクセス制御
#
# 注意事項:
#   - 既存のリソースポリシーを更新する場合、既存のポリシーは置き換えられます
#   - サーバー側暗号化が有効な場合、AWS管理のKMSキーではなくカスタマーマネージド
#     キーを使用し、KMSのクロスアカウント共有も設定する必要があります
#   - ポリシーには必ずプリンシパルのIDと許可するアクションを含める必要があります
#
# AWS公式ドキュメント:
#   - Share access using resource-based policies:
#     https://docs.aws.amazon.com/streams/latest/dev/resource-based-policy-examples.html
#   - Controlling access to Amazon Kinesis Data Streams resources using IAM:
#     https://docs.aws.amazon.com/streams/latest/dev/controlling-access.html
#   - PutResourcePolicy API:
#     https://docs.aws.amazon.com/kinesis/latest/APIReference/API_PutResourcePolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kinesis_resource_policy" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # resource_arn - (Required) データストリームまたは登録済みコンシューマのARN
  #
  # ポリシーをアタッチする対象リソースのAmazon Resource Name (ARN)を指定します。
  # 以下のいずれかのパターンに一致する必要があります:
  #
  # データストリームのパターン:
  #   arn:aws.*:kinesis:.*:\d{12}:.*stream/\S+
  #   例: arn:aws:kinesis:us-east-1:123456789012:stream/my-stream
  #
  # 登録済みコンシューマのパターン:
  #   ^(arn):aws.*:kinesis:.*:\d{12}:.*stream\/[a-zA-Z0-9_.-]+\/consumer\/[a-zA-Z0-9_.-]+:[0-9]+
  #   例: arn:aws:kinesis:us-east-1:123456789012:stream/my-stream/consumer/my-consumer:1234567890
  #
  # 注意:
  #   - ARNは1文字以上2048文字以下である必要があります
  #   - 指定したARNのリソースが存在しない場合、ResourceNotFoundExceptionが発生します
  #   - リソースがACTIVE状態でない場合、ResourceInUseExceptionが発生します
  #
  # 関連:
  #   - aws_kinesis_stream.arn でデータストリームのARNを参照可能
  #
  resource_arn = aws_kinesis_stream.example.arn

  # policy - (Required) リソースポリシードキュメント
  #
  # JSON形式のIAMポリシードキュメントを指定します。
  # このポリシーはプリンシパル（アクセス元）とそのプリンシパルに許可する
  # アクションを定義する必要があります。
  #
  # ポリシーに含めるべき要素:
  #   - Version: ポリシー言語のバージョン（通常は "2012-10-17"）
  #   - Statement: ポリシーステートメントの配列
  #     - Effect: "Allow" または "Deny"
  #     - Principal: アクセスを許可/拒否するAWSアカウントやIAMエンティティ
  #     - Action: 許可/拒否するKinesis Data Streamsのアクション
  #     - Resource: 対象となるリソースのARN
  #
  # 主なKinesis Data Streamsアクション:
  #   - kinesis:DescribeStream - ストリームの詳細情報の取得
  #   - kinesis:DescribeStreamSummary - ストリームのサマリー情報の取得
  #   - kinesis:GetRecords - レコードの読み取り
  #   - kinesis:GetShardIterator - シャードイテレータの取得
  #   - kinesis:ListShards - シャードのリスト取得
  #   - kinesis:PutRecord - 単一レコードの書き込み
  #   - kinesis:PutRecords - 複数レコードの書き込み
  #   - kinesis:SubscribeToShard - Enhanced Fan-Out用のサブスクリプション
  #
  # Lambda関数の場合の推奨アクション:
  #   kinesis:DescribeStream, kinesis:DescribeStreamSummary,
  #   kinesis:GetRecords, kinesis:GetShardIterator,
  #   kinesis:ListShards, kinesis:SubscribeToShard
  #
  # 注意:
  #   - ポリシーを更新すると既存のポリシーが完全に置き換えられます
  #   - Lambda関数のイベントソースマッピングの場合、
  #     kinesis:DescribeStreamアクションを必ず含めてください
  #   - サーバー側暗号化が有効な場合、KMSキーへのアクセス権限も別途必要です
  #
  # 例: クロスアカウントのLambda関数にストリームへの読み取りアクセスを許可
  #
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "CrossAccountLambdaReadPolicy"
    Statement = [
      {
        Sid    = "AllowLambdaReadAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:role/lambda-execution-role"
        }
        Action = [
          "kinesis:DescribeStream",
          "kinesis:DescribeStreamSummary",
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:ListShards",
          "kinesis:SubscribeToShard"
        ]
        Resource = aws_kinesis_stream.example.arn
      }
    ]
  })

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # region - (Optional) このリソースが管理されるリージョン
  #
  # リソースを管理するAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定で指定されたリージョンがデフォルトとして使用されます。
  #
  # 利用可能なリージョンの例:
  #   - us-east-1 (バージニア北部)
  #   - us-west-2 (オレゴン)
  #   - eu-west-1 (アイルランド)
  #   - ap-northeast-1 (東京)
  #   など、Kinesis Data Streamsがサポートする全リージョン
  #
  # 注意:
  #   - リージョンエンドポイントの詳細は以下を参照:
  #     https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースでは以下の属性がエクスポートされます:
#
# (このリソースには追加のエクスポート属性はありません。
#  設定した引数（resource_arn, policy, region）が参照可能です。)
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
#
# Kinesis Resource Policyはresource_arnを使用してインポートできます:
#
# terraform import aws_kinesis_resource_policy.example arn:aws:kinesis:us-east-1:123456789012:stream/my-stream
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: クロスアカウントのLambda関数に読み取りアクセスを許可
resource "aws_kinesis_resource_policy" "lambda_cross_account" {
  resource_arn = aws_kinesis_stream.main.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::111122223333:role/lambda-kinesis-role"
        }
        Action = [
          "kinesis:DescribeStream",
          "kinesis:DescribeStreamSummary",
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:ListShards",
          "kinesis:SubscribeToShard"
        ]
        Resource = aws_kinesis_stream.main.arn
      }
    ]
  })
}

# 例2: 複数アカウントに書き込みアクセスを許可
resource "aws_kinesis_resource_policy" "multi_account_write" {
  resource_arn = aws_kinesis_stream.shared.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::111122223333:root",
            "arn:aws:iam::444455556666:root"
          ]
        }
        Action = [
          "kinesis:DescribeStreamSummary",
          "kinesis:ListShards",
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ]
        Resource = aws_kinesis_stream.shared.arn
      }
    ]
  })
}

# 例3: 登録済みコンシューマ（Enhanced Fan-Out）への細かいアクセス制御
resource "aws_kinesis_resource_policy" "consumer_policy" {
  resource_arn = aws_kinesis_stream.main.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowConsumerAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::111122223333:role/consumer-role"
        }
        Action = [
          "kinesis:DescribeStreamConsumer",
          "kinesis:SubscribeToShard"
        ]
        Resource = "${aws_kinesis_stream.main.arn}/consumer/*"
      }
    ]
  })
}
