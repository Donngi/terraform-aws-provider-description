#---------------------------------------------------------------
# VPC Endpoint Policy
#---------------------------------------------------------------
#
# VPCエンドポイントに対してアクセス制御を行うためのポリシーを管理します。
# エンドポイントポリシーは、VPCエンドポイント経由でAWSサービスにアクセスする際に、
# どのAWSプリンシパル（ユーザー、ロール等）がそのエンドポイントを使用できるかを制御するための
# リソースベースポリシーです。
#
# エンドポイントポリシーは、IDベースポリシーやリソースベースポリシーを上書きまたは置き換えることはなく、
# エンドポイントからAWSサービスへのアクセスを制御する追加のレイヤーとして機能します。
#
# 【主な特徴】
# - Interface EndpointとGateway Endpointの両方に対応
# - IAMポリシー言語を使用したJSON形式のポリシー文書
# - Principalエレメントが必須（Gateway Endpointの場合は"*"を指定し、aws:PrincipalArnで制御）
# - ポリシーサイズの上限は20,480文字（空白を含む）
# - すべてのAWSサービスがエンドポイントポリシーをサポートしているわけではない
#
# AWS公式ドキュメント:
#   - VPCエンドポイントポリシーを使用したアクセス制御: https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints-access.html
#   - VPC Endpoints: https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_endpoint_policy" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # VPCエンドポイントID
  # - ポリシーを適用する対象のVPCエンドポイントのIDを指定
  # - aws_vpc_endpoint リソースで作成したエンドポイントのIDを参照
  # - 例: aws_vpc_endpoint.example.id
  vpc_endpoint_id = "vpce-1a2b3c4d"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # エンドポイントポリシー
  # - VPCエンドポイント経由でのアクセスを制御するIAMポリシー文書（JSON形式）
  # - Principalエレメントを含む必要がある
  # - Gateway Endpointの場合、Principalは"*"を指定し、条件キー（aws:PrincipalArn）で制御
  # - Interface Endpointの場合、Principalに具体的なARNを指定可能
  # - 最大サイズ: 20,480文字（空白を含む）
  # - デフォルト: フルアクセスを許可するポリシーが適用される
  # - jsonencode()関数を使用してHCL構造をJSON文字列に変換することを推奨
  # - ポリシー更新後、反映まで数分かかる場合がある
  #
  # 【Interface Endpointのポリシー例】
  # policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Sid    = "AllowS3Access"
  #       Effect = "Allow"
  #       Principal = {
  #         AWS = "arn:aws:iam::123456789012:role/MyRole"
  #       }
  #       Action   = "s3:*"
  #       Resource = "*"
  #     }
  #   ]
  # })
  #
  # 【Gateway Endpointのポリシー例（DynamoDB）】
  # policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Sid    = "AllowDynamoDBAccess"
  #       Effect = "Allow"
  #       Principal = "*"
  #       Action   = "dynamodb:*"
  #       Resource = "*"
  #       Condition = {
  #         StringEquals = {
  #           "aws:PrincipalArn" = "arn:aws:iam::123456789012:user/endpointuser"
  #         }
  #       }
  #     }
  #   ]
  # })
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowAll"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "*"
        Resource = "*"
      }
    ]
  })

  # リージョン
  # - このリソースを管理するAWSリージョンを指定
  # - 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用される
  # - 例: "us-east-1", "ap-northeast-1"
  # - 通常はプロバイダーレベルで設定するため、明示的な指定は不要なケースが多い
  # region = "ap-northeast-1"

  # リソースID
  # - Terraformがこのリソースをステートファイルで識別するために使用するID
  # - 通常はTerraformが自動的に設定するため、明示的な指定は不要
  # - VPCエンドポイントのIDがリソースIDとして使用される
  # - computed属性でもあるため、値を読み取ることも可能
  # id = null

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # 作成タイムアウト
    # - ポリシーの作成処理が完了するまでの最大待機時間
    # - デフォルト: 10m（10分）
    # - 形式: "Xm"（X分）または"Xh"（X時間）
    # create = "10m"

    # 削除タイムアウト
    # - ポリシーの削除処理が完了するまでの最大待機時間
    # - デフォルト: 10m（10分）
    # - 形式: "Xm"（X分）または"Xh"（X時間）
    # delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed属性）:
#
# - id: VPCエンドポイントのID
#       ポリシーが適用されているVPCエンドポイントの識別子
#       他のリソースでの参照や、データソースでの検索に使用可能
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: S3 Interface Endpoint用のポリシー
# resource "aws_vpc_endpoint_policy" "s3_interface" {
#   vpc_endpoint_id = aws_vpc_endpoint.s3_interface.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowS3ListBucket"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::123456789012:role/MyApplicationRole"
#         }
#         Action = [
#           "s3:ListBucket",
#           "s3:GetObject"
#         ]
#         Resource = [
#           "arn:aws:s3:::my-bucket",
#           "arn:aws:s3:::my-bucket/*"
#         ]
#       }
#     ]
#   })
# }

# 例2: DynamoDB Gateway Endpoint用のポリシー
# resource "aws_vpc_endpoint_policy" "dynamodb_gateway" {
#   vpc_endpoint_id = aws_vpc_endpoint.dynamodb_gateway.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid       = "AllowDynamoDBAccess"
#         Effect    = "Allow"
#         Principal = "*"
#         Action = [
#           "dynamodb:Query",
#           "dynamodb:Scan",
#           "dynamodb:GetItem"
#         ]
#         Resource = "*"
#         Condition = {
#           StringEquals = {
#             "aws:PrincipalArn" = [
#               "arn:aws:iam::123456789012:role/DataProcessingRole",
#               "arn:aws:iam::123456789012:role/AnalyticsRole"
#             ]
#           }
#         }
#       }
#     ]
#   })
# }

# 例3: 特定のVPCからのアクセスのみを許可するポリシー
# resource "aws_vpc_endpoint_policy" "restricted" {
#   vpc_endpoint_id = aws_vpc_endpoint.example.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid       = "RestrictToVPC"
#         Effect    = "Allow"
#         Principal = "*"
#         Action    = "*"
#         Resource  = "*"
#         Condition = {
#           StringEquals = {
#             "aws:SourceVpc" = aws_vpc.example.id
#           }
#         }
#       }
#     ]
#   })
# }
