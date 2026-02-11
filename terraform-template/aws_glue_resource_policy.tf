#---------------------------------------------------------------
# AWS Glue Resource Policy
#---------------------------------------------------------------
#
# AWS Glue のデータカタログに対するリソースベースのポリシーを管理します。
# リージョンごとに1つのみ存在できます。
#
# このリソースは、AWS Glue データカタログへのアクセスを制御するための
# リソースベースポリシーを定義します。クロスアカウントアクセスや
# 同一アカウント内の詳細なアクセス制御に使用されます。
#
# AWS公式ドキュメント:
#   - Resource-based policy examples for AWS Glue: https://docs.aws.amazon.com/glue/latest/dg/security_iam_resource-based-policy-examples.html
#   - How AWS Glue works with IAM: https://docs.aws.amazon.com/glue/latest/dg/security_iam_service-with-iam.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_resource_policy" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # policy - (必須) AWS Glue データカタログに適用するポリシー
  # JSON形式のIAMポリシードキュメントを指定します。
  #
  # 制約事項:
  # - ポリシードキュメントのサイズは10KB以下
  # - 各ステートメントにPrincipalまたはNotPrincipalブロックが必須
  # - Principalには有効な既存のプリンシパルを指定（ワイルドカードパターンは不可）
  # - ResourceブロックのARNはポリシーがアタッチされるカタログに属するリソースのみ
  # - ARNは arn:aws:glue:region:account-id:(pattern) の形式に準拠
  # - ポリシー作成者自身をロックアウトするポリシーは作成不可
  #
  # 注意: IAMポリシーとリソースポリシーの両方が伝播するまで数秒かかります
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = {
          AWS = ["arn:aws:iam::123456789012:user/example-user"]
        }
        Effect = "Allow"
        Action = [
          "glue:*"
        ]
        Resource = [
          "arn:aws:glue:us-east-1:123456789012:*"
        ]
      }
    ]
  })

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # enable_hybrid - (オプション) クロスアカウントアクセス許可の両方の方法を使用していることを示す
  # 有効な値: "TRUE" または "FALSE"
  #
  # 注意: このフィールドは読み取り時に返されないため、Terraformはドリフト検出を行いません
  # デフォルト: 未設定
  enable_hybrid = "TRUE"

  # id - (オプション) リソースのID
  # 通常は明示的に指定する必要はありません。
  # Terraform によって自動的に計算されます。
  # デフォルト: 自動生成
  # id = "glue-resource-policy-id"

  # region - (オプション) このリソースが管理されるリージョン
  # プロバイダー設定のリージョンがデフォルトとして使用されます。
  # マルチリージョン構成で明示的にリージョンを指定する場合に使用します。
  # デフォルト: プロバイダー設定のリージョン
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed属性）:
#
# - id: リソースのID（リージョン名と同じ）
# - region: リソースが管理されているリージョン
#
# これらの属性は他のリソースやデータソースから参照できます:
# aws_glue_resource_policy.example.id
# aws_glue_resource_policy.example.region
#---------------------------------------------------------------
