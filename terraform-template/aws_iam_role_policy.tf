#---------------------------------------------------------------
# IAM Role Inline Policy
#---------------------------------------------------------------
#
# IAMロールにインラインポリシーをアタッチするためのリソース。
# インラインポリシーはロールに直接埋め込まれ、そのロール専用のポリシーとして機能します。
#
# 重要な注意事項:
#   - このリソースは aws_iam_role の inline_policy 引数と併用できません
#   - 両方を使用すると、Terraform が永続的な差分を表示します
#   - 多くの場合、マネージドポリシー（aws_iam_role_policy_attachment）の使用が推奨されます
#   - インラインポリシーは、ポリシーとロールの1対1の厳密な関係が必要な場合に使用します
#
# AWS公式ドキュメント:
#   - IAM インラインポリシーとマネージドポリシーの選択: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies-choosing-managed-or-inline.html
#   - PutRolePolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_PutRolePolicy.html
#   - GetRolePolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_GetRolePolicy.html
#   - IAM Best Practices: https://aws.amazon.com/iam/resources/best-practices/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_role_policy" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ポリシードキュメント（JSON形式の文字列）
  # ロールに付与する権限を定義するIAMポリシードキュメント。
  #
  # 推奨事項:
  #   - jsonencode() 関数を使用してTerraformの式をJSON形式に変換
  #   - または aws_iam_policy_document データソースを使用
  #   - これにより、フォーマットの不一致、空白の不整合、その他のJSON固有の問題を回避
  #
  # ポリシードキュメントの構造:
  #   - Version: ポリシー言語のバージョン（通常 "2012-10-17"）
  #   - Statement: 権限を定義するステートメントの配列
  #     - Effect: "Allow" または "Deny"
  #     - Action: 許可または拒否するアクションのリスト
  #     - Resource: アクションが適用されるリソースのARN
  #     - Condition (オプション): 条件付きアクセス制御
  #
  # セキュリティのベストプラクティス:
  #   - 最小権限の原則に従う
  #   - Action と Resource に "*" を使用しない（可能な限り）
  #   - ワイルドカードサービスアクション（service:*）を避ける
  #
  # 例:
  #   policy = jsonencode({
  #     Version = "2012-10-17"
  #     Statement = [
  #       {
  #         Action = [
  #           "ec2:Describe*",
  #           "s3:GetObject"
  #         ]
  #         Effect   = "Allow"
  #         Resource = "*"
  #       }
  #     ]
  #   })
  #
  # または aws_iam_policy_document を使用:
  #   policy = data.aws_iam_policy_document.example.json
  #
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements.html
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  # ポリシーをアタッチするIAMロールの名前
  # このロールにインラインポリシーが埋め込まれます。
  #
  # 指定方法:
  #   - ロール名の文字列を直接指定
  #   - または他のリソースへの参照（例: aws_iam_role.example.name）
  #
  # 制約:
  #   - ロール名は既存のIAMロールである必要があります
  #   - 形式: 英数字、プラス(+)、等号(=)、カンマ(,)、ピリオド(.)、アットマーク(@)、アンダースコア(_)、ハイフン(-)
  #   - 最大長: 64文字
  #
  # 例:
  #   role = "my-application-role"
  #   role = aws_iam_role.example.name
  #   role = aws_iam_role.example.id
  role = aws_iam_role.example.name

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # ポリシー名
  # ロールにアタッチされるインラインポリシーの名前。
  #
  # 動作:
  #   - 指定しない場合、Terraformがランダムでユニークな名前を自動生成
  #   - name_prefix と同時に指定することはできません（競合）
  #
  # 制約:
  #   - 形式: 英数字、プラス(+)、等号(=)、カンマ(,)、ピリオド(.)、アットマーク(@)、アンダースコア(_)、ハイフン(-)
  #   - 最大長: 128文字
  #   - スペースは使用不可
  #
  # 例:
  #   name = "s3-read-only-policy"
  #   name = "ec2-describe-policy"
  #
  # 推奨事項:
  #   - 明示的な名前を指定すると、AWS Console での識別が容易
  #   - 動的な環境では name_prefix の使用を検討
  name = "example-policy"

  # ポリシー名のプレフィックス
  # 指定したプレフィックスで始まるユニークな名前を生成します。
  #
  # 動作:
  #   - Terraformが指定されたプレフィックスにランダムな文字列を追加
  #   - name と同時に指定することはできません（競合）
  #
  # 使用場面:
  #   - 同じ設定から複数のインスタンスを作成する場合
  #   - 動的な環境で名前の衝突を避けたい場合
  #   - 一貫した命名規則を保ちつつ、ユニーク性を確保したい場合
  #
  # 制約:
  #   - 形式: 英数字、プラス(+)、等号(=)、カンマ(,)、ピリオド(.)、アットマーク(@)、アンダースコア(_)、ハイフン(-)
  #   - プレフィックス + 生成された文字列の合計が128文字以内
  #
  # 例:
  #   name_prefix = "app-"  # 結果: "app-20230815123456789012345678"
  #   name_prefix = "prod-lambda-"
  #
  # 注意:
  #   - name と name_prefix は排他的です（どちらか一方のみ指定可能）
  # name_prefix = "example-"

  # ID (computed only - テンプレートには含めない)
  # このパラメータは Terraform によって自動的に計算されます。
  # フォーマット: <role_name>:<policy_name>
  #
  # 注意: id は optional かつ computed ですが、通常はユーザーが指定せず、
  # Terraform が自動生成するため、テンプレートでは明示的に設定しません。
}


#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
#
# このリソースをデプロイすると、以下の属性が参照可能になります:
#
# - id
#     リソースの一意識別子
#     フォーマット: <role_name>:<policy_name>
#     例: "my-role:my-policy"
#
#     使用例:
#       output "policy_id" {
#         value = aws_iam_role_policy.example.id
#       }
#
# - name
#     ポリシー名（指定した場合はその値、未指定の場合は生成された名前）
#
#     使用例:
#       output "policy_name" {
#         value = aws_iam_role_policy.example.name
#       }
#
# - role
#     ポリシーがアタッチされているロール名
#
#     使用例:
#       output "attached_role" {
#         value = aws_iam_role_policy.example.role
#       }
#
# - policy
#     ポリシードキュメント（JSON形式）
#
#     使用例:
#       output "policy_document" {
#         value = aws_iam_role_policy.example.policy
#       }
#


#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: 基本的な使用方法（jsonencode を使用）
resource "aws_iam_role_policy" "basic_example" {
  name = "basic-policy"
  role = aws_iam_role.example.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::my-bucket",
          "arn:aws:s3:::my-bucket/*"
        ]
      }
    ]
  })
}

# 例2: aws_iam_policy_document を使用
data "aws_iam_policy_document" "example" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeImages"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::my-bucket/*"
    ]
  }
}

resource "aws_iam_role_policy" "policy_document_example" {
  name   = "policy-document-example"
  role   = aws_iam_role.example.name
  policy = data.aws_iam_policy_document.example.json
}

# 例3: name_prefix を使用した動的な命名
resource "aws_iam_role_policy" "dynamic_example" {
  name_prefix = "app-policy-"
  role        = aws_iam_role.example.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["dynamodb:*"]
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:*:*:table/my-table"
      }
    ]
  })
}

# 例4: 複数のステートメントを持つポリシー
resource "aws_iam_role_policy" "multi_statement_example" {
  name = "multi-statement-policy"
  role = aws_iam_role.example.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEC2Describe"
        Action = ["ec2:Describe*"]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Sid = "AllowS3ReadWrite"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect = "Allow"
        Resource = "arn:aws:s3:::my-bucket/*"
      },
      {
        Sid = "AllowLogsWrite"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# IAMロールの定義例（参考）
resource "aws_iam_role" "example" {
  name = "example-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}


#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
#
# 既存のIAMロールインラインポリシーは以下の形式でインポートできます:
#
# terraform import aws_iam_role_policy.example role_name:policy_name
#
# 例:
#   terraform import aws_iam_role_policy.example my-role:my-policy
#
# インポート後は、terraform state show コマンドで設定を確認し、
# Terraformコードに反映してください。
