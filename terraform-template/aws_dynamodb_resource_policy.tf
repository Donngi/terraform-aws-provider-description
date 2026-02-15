# aws_dynamodb_resource_policy
# Terraform Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/dynamodb_resource_policy
# Provider Version: 6.28.0
# Generated: 2026-02-14
#-------
# NOTE:
# リソースベースポリシーを用いることで、DynamoDBテーブルやストリームに対するアクセス権限を
# テーブル単位で定義できます。IAMポリシーとは異なり、リソース側でアクセス制御を一元管理できるため、
# クロスアカウントアクセスや特定条件下でのアクセス許可を簡素化できます。

#-------
# リソース定義
#-------
resource "aws_dynamodb_resource_policy" "example" {
  #-------
  # 必須設定
  #-------

  # 設定内容: ポリシーをアタッチするDynamoDBリソースのARN
  # 設定可能な値: DynamoDBテーブルまたはストリームの完全修飾ARN
  # 補足: テーブルARNまたはストリームARNを指定します
  resource_arn = "arn:aws:dynamodb:us-east-1:123456789012:table/ExampleTable"

  # 設定内容: リソースベースポリシーのJSON形式のドキュメント
  # 設定可能な値: 最大20KBまでのIAMポリシードキュメント
  # 補足: Principal、Action、Resource要素を含むJSON形式のポリシーを指定します
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Resource = "arn:aws:dynamodb:us-east-1:123456789012:table/ExampleTable"
      }
    ]
  })

  #-------
  # アクセス制御設定
  #-------

  # 設定内容: 自分自身へのリソースアクセスを削除する際の確認フラグ
  # 設定可能な値: true（確認済み）、false（未確認）
  # 省略時: 自動的にtrueが設定されます
  # 補足: ポリシー更新時に自分自身のアクセス権限を削除する場合、trueを設定して確認を示します
  confirm_remove_self_resource_access = true

  #-------
  # リージョン設定
  #-------

  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: us-east-1、ap-northeast-1などの有効なリージョンコード
  # 省略時: プロバイダーで設定されたリージョンが使用されます
  # 補足: 通常は省略し、プロバイダーのリージョン設定に従います
  region = "us-east-1"
}

#-------
# Attributes Reference
#-------
# id - リソースの一意識別子（resource_arnと同値）
# revision_id - ポリシーのリビジョンID（更新ごとに変更されます）
# region - リソースが管理されているリージョン
