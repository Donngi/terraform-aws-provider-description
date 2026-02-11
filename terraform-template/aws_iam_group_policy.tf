#---------------------------------------------------------------
# IAM Group Policy
#---------------------------------------------------------------
#
# IAMグループにインラインポリシーをアタッチするリソース。
# グループに所属する全ユーザーに対して権限を付与する際に使用します。
#
# インラインポリシーは特定のグループに直接埋め込まれるポリシーで、
# 再利用を前提としない場合に適しています。複数のグループで同じポリシーを
# 使用する場合は、マネージドポリシー(aws_iam_policy + aws_iam_group_policy_attachment)
# の使用を検討してください。
#
# AWS公式ドキュメント:
#   - PutGroupPolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_PutGroupPolicy.html
#   - GetGroupPolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_GetGroupPolicy.html
#   - DeleteGroupPolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_DeleteGroupPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_group_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_group_policy" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # group - (Required) ポリシーをアタッチするIAMグループの名前
  #
  # IAMグループ名を指定します。既存のグループである必要があります。
  # aws_iam_groupリソースで作成したグループを参照する場合は、
  # aws_iam_group.example.name のように指定します。
  #
  # 制約:
  #   - 長さ: 1-128文字
  #   - 使用可能文字: 英数字と以下の特殊文字 += , . @ - _
  #   - スペース不可
  #
  # 例:
  #   group = "developers"
  #   group = aws_iam_group.my_developers.name
  group = "example-group"

  # policy - (Required) ポリシードキュメント（JSON形式）
  #
  # IAMポリシーをJSON形式で指定します。このポリシーにより、グループに
  # 所属するユーザーが実行できるAWSアクションが定義されます。
  #
  # ベストプラクティス:
  #   1. jsonencode()関数を使用してTerraformの構文で記述
  #   2. aws_iam_policy_documentデータソースを使用して構造化
  #   3. 最小権限の原則に従い、必要な権限のみを付与
  #
  # ポリシードキュメントの構成要素:
  #   - Version: ポリシー言語のバージョン（通常 "2012-10-17"）
  #   - Statement: 権限の配列
  #     - Effect: "Allow" または "Deny"
  #     - Action: 許可/拒否するアクション（例: "s3:GetObject"）
  #     - Resource: 対象となるAWSリソースのARN
  #     - Condition: (オプション) 条件付きアクセス制御
  #
  # 制約:
  #   - 最大サイズ: 2,048文字（URL-encoded form）
  #   - 6,144文字（URL-encoded不使用時）
  #
  # 参考:
  #   - IAM Policy Document Guide: https://learn.hashicorp.com/terraform/aws/iam-policy
  #
  # 例1: jsonencode()を使用
  #   policy = jsonencode({
  #     Version = "2012-10-17"
  #     Statement = [
  #       {
  #         Effect = "Allow"
  #         Action = ["ec2:Describe*"]
  #         Resource = "*"
  #       }
  #     ]
  #   })
  #
  # 例2: aws_iam_policy_documentを使用
  #   policy = data.aws_iam_policy_document.example.json
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "arn:aws:s3:::example-bucket/*"
      }
    ]
  })

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # name - (Optional) ポリシーの名前
  #
  # ポリシーに付ける名前を指定します。省略した場合、Terraformが
  # ランダムでユニークな名前を自動生成します。
  #
  # name_prefixとの競合:
  #   nameとname_prefixは同時に指定できません。どちらか一方のみ使用してください。
  #
  # 制約:
  #   - 長さ: 1-128文字
  #   - 使用可能文字: 英数字と以下の特殊文字 += , . @ - _
  #   - スペース不可
  #
  # 例:
  #   name = "my_developer_policy"
  #   name = "s3-read-only-policy"
  name = "example-policy"

  # name_prefix - (Optional) 名前のプレフィックス
  #
  # 指定したプレフィックスで始まるユニークな名前を自動生成します。
  # 同じ設定を複数環境にデプロイする際や、名前の衝突を避けたい場合に便利です。
  #
  # nameとの競合:
  #   nameとname_prefixは同時に指定できません。どちらか一方のみ使用してください。
  #
  # 動作:
  #   指定したプレフィックスにランダムな文字列が付加されます。
  #   例: name_prefix = "app-" → 生成される名前: "app-20231225123456789012345678"
  #
  # 制約:
  #   - 最大長: 128文字（生成される名前全体）
  #   - 使用可能文字: 英数字と以下の特殊文字 += , . @ - _
  #
  # 例:
  #   name_prefix = "prod-"
  #   name_prefix = "dev-policy-"
  # name_prefix = "example-"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - id
#     グループポリシーのID
#     フォーマット: "{group_name}:{policy_name}"
#     例: "developers:my_developer_policy"
#     用途: 他のリソースからこのポリシーを参照する際に使用
#
# - group
#     ポリシーがアタッチされているグループ名
#     入力値がそのまま返されます
#
# - name
#     ポリシーの名前
#     自動生成された場合は生成された名前が返されます
#
# - policy
#     グループにアタッチされているポリシードキュメント
#     JSON形式の文字列として返されます
#
# 使用例:
#   output "policy_id" {
#     value = aws_iam_group_policy.example.id
#   }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Important Notes
#---------------------------------------------------------------
#
# 1. インラインポリシー vs マネージドポリシー
#    - インラインポリシー（このリソース）:
#      特定のグループ専用、再利用不可、グループ削除時に自動削除
#    - マネージドポリシー（aws_iam_policy）:
#      複数のグループ/ユーザー/ロールで再利用可能
#
# 2. ポリシーの制限
#    - 1グループあたりのインラインポリシー数: 上限あり（AWS側の制限）
#    - ポリシードキュメントサイズ: 2,048〜6,144文字
#
# 3. jsonencode()の推奨
#    生のJSON文字列ではなくjsonencode()関数を使用することで:
#    - Terraformの構文チェックが有効
#    - フォーマットの一貫性が保たれる
#    - ホワイトスペースの問題を回避
#
# 4. 最小権限の原則
#    - 必要最小限の権限のみを付与
#    - Resource指定で対象リソースを限定
#    - 条件（Condition）を使用して細かい制御
#
# 5. 変更の影響
#    - policyの変更は即座に反映されます
#    - グループに所属する全ユーザーに影響します
#    - 本番環境での変更は慎重に実施してください
#
#---------------------------------------------------------------
