#---------------------------------------------------------------
# IAM Policy
#---------------------------------------------------------------
#
# AWS IAM (Identity and Access Management) の顧客管理ポリシー (Customer Managed Policy) を
# プロビジョニングするリソースです。
# IAMポリシーは、AWSリソースへのアクセス許可を定義するJSONドキュメントで、
# ユーザー、グループ、ロールにアタッチすることができます。
#
# AWS公式ドキュメント:
#   - CreatePolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreatePolicy.html
#   - IAM Policies (User Guide): https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage.html
#   - IAM Identifiers: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_policy" "example" {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # 必須パラメータ
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # policy - (Required) ポリシードキュメント
  # IAMポリシードキュメントをJSON形式で指定します。
  # Terraformの jsonencode() 関数または aws_iam_policy_document データソースの使用を強く推奨します。
  # これにより、TerraformのHCL構文からJSONへシームレスに変換でき、フォーマット不整合や
  # ホワイトスペースの問題を回避できます。
  #
  # ポリシードキュメントには以下の要素が含まれます:
  #   - Version: ポリシー言語のバージョン (通常は "2012-10-17")
  #   - Statement: 1つ以上の個別ステートメント
  #     - Effect: "Allow" または "Deny"
  #     - Action: 許可または拒否するアクション
  #     - Resource: アクションが適用されるリソースのARN
  #
  # 参考:
  #   - AWS IAM Policy Guide: https://learn.hashicorp.com/terraform/aws/iam-policy
  #   - jsonencode function: https://developer.hashicorp.com/terraform/language/functions/jsonencode
  #
  # 型: string (JSON形式)
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
        ]
        Resource = "*"
      },
    ]
  })


  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # オプションパラメータ
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # name - (Optional) ポリシーの名前
  # IAMポリシーのフレンドリー名を指定します。
  # この名前はAWSアカウント内で一意である必要があります。
  # 省略した場合、Terraformがランダムで一意な名前を自動生成します。
  #
  # 名前の制約:
  #   - 長さ: 1～128文字
  #   - 使用可能文字: 英数字、プラス(+)、イコール(=)、カンマ(,)、ピリオド(.)、
  #                    アットマーク(@)、アンダースコア(_)、ハイフン(-)
  #   - アカウント内で一意であること (大文字小文字は区別されない)
  #
  # 注意:
  #   - Forces new resource: この値を変更すると、リソースが再作成されます
  #   - name_prefix と同時には指定できません
  #
  # 型: string
  name = "example-policy"

  # name_prefix - (Optional) ポリシー名のプレフィックス
  # 指定したプレフィックスで始まる一意な名前を自動生成します。
  # Terraformが自動的にランダムな文字列を追加して一意性を保証します。
  #
  # 用途:
  #   - 命名規則に従いつつ一意性を確保したい場合に便利
  #   - 同じプレフィックスを持つ複数のリソースを管理する場合
  #
  # 注意:
  #   - Forces new resource: この値を変更すると、リソースが再作成されます
  #   - name と同時には指定できません (Conflicts with name)
  #
  # 型: string
  # name_prefix = "example-policy-"

  # description - (Optional) ポリシーの説明
  # IAMポリシーの説明文を指定します。
  # ポリシーで定義されている権限について説明を記載する用途で使用されます。
  # この説明は作成後は変更できません (イミュータブル)。
  #
  # 制約:
  #   - 最大長: 1000文字
  #
  # 注意:
  #   - Forces new resource: この値を変更すると、リソースが再作成されます
  #
  # 型: string
  description = "Example IAM policy for EC2 describe permissions"

  # path - (Optional) ポリシーのパス
  # IAMポリシーを作成するパスを指定します。
  # パスはポリシーを組織構造に沿って整理するために使用できます。
  # デフォルト値は "/" です。
  #
  # パスの制約:
  #   - スラッシュ(/)で始まり、スラッシュで終わる必要があります
  #   - 例: "/", "/division_abc/", "/division_abc/subdivision_xyz/"
  #   - 使用可能文字: a-z, A-Z, 0-9, スラッシュ(/)、プラス(+)、イコール(=)、
  #                    カンマ(,)、ピリオド(.)、アットマーク(@)、ハイフン(-)、
  #                    アンダースコア(_)
  #   - 長さ: 1～512文字
  #
  # 用途:
  #   - 組織の部門や製品ラインごとにポリシーをグループ化
  #   - ポリシーのARNにパスが含まれ、ワイルドカードでまとめて参照可能
  #
  # 参考:
  #   - IAM Identifiers: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html
  #
  # 型: string
  # path = "/"

  # delay_after_policy_creation_in_ms - (Optional) ポリシー作成後の待機時間
  # ポリシーを作成した後、デフォルトバージョンとして設定する前に待機するミリ秒数です。
  # 非常に高いS3 I/O負荷がある環境では必要になる場合があります。
  #
  # 用途:
  #   - IAMの結果整合性に起因する一時的なエラーを回避
  #   - 特定の環境でのレースコンディションの回避
  #
  # 注意:
  #   - 通常の使用では不要です
  #   - 値が大きいほど、リソース作成時間が長くなります
  #
  # 型: number (ミリ秒)
  # delay_after_policy_creation_in_ms = 1000

  # tags - (Optional) リソースタグ
  # IAMポリシーに付与するタグのマップです。
  # タグを使用して、リソースの分類、検索、コスト配分などを行います。
  #
  # 注意:
  #   - provider の default_tags 設定ブロックで定義されたタグがある場合、
  #     同じキーを持つタグはこちらで上書きされます
  #   - tags_all 属性には、このタグとプロバイダーレベルのタグがマージされて表示されます
  #
  # 型: map(string)
  # tags = {
  #   Environment = "production"
  #   Project     = "example-project"
  #   ManagedBy   = "terraform"
  # }

  # tags_all - (Optional) 全てのタグ (プロバイダーレベル含む)
  # このリソースに割り当てられる全てのタグのマップです。
  # ここには、tags で指定したタグと、プロバイダーの default_tags で指定されたタグが
  # 両方含まれます。
  #
  # 注意:
  #   - 通常は明示的に設定する必要はありません
  #   - Terraformが自動的に tags と provider default_tags をマージして設定します
  #   - 明示的に設定する場合、tags と default_tags の内容を含める必要があります
  #
  # 参考:
  #   - Default Tags: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  #
  # 型: map(string)
  # tags_all = {}

  # id - (Optional) リソースID
  # Terraformによって管理されるリソースの識別子です。
  # IAMポリシーの場合、ARNがIDとして使用されます。
  #
  # 注意:
  #   - 通常は明示的に設定しません (Terraform が自動管理)
  #   - computed: true なので、リソース作成後に自動的に設定されます
  #
  # 型: string
  # id = null
}


#---------------------------------------------------------------
# Attributes Reference (Computed)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です (入力はできません)
#
# arn - (Computed)
#   AWSによって割り当てられたポリシーのARN (Amazon Resource Name)
#   例: arn:aws:iam::123456789012:policy/example-policy
#   用途: ポリシーをユーザー、グループ、ロールにアタッチする際に使用
#   参照方法: aws_iam_policy.example.arn
#
# attachment_count - (Computed)
#   このポリシーがアタッチされているエンティティ(ユーザー、グループ、ロール)の数
#   型: number
#   参照方法: aws_iam_policy.example.attachment_count
#
# policy_id - (Computed)
#   ポリシーの一意識別子 (Unique ID)
#   例: ANPAI23HZ27SI6FQMGNQ2
#   注意: ポリシー名を再利用した場合でも、この識別子は常に一意
#   参照方法: aws_iam_policy.example.policy_id
#
# tags_all - (Computed when not explicitly set)
#   このリソースに割り当てられている全てのタグ (プロバイダーのdefault_tagsを含む)
#   参照方法: aws_iam_policy.example.tags_all
#
#---------------------------------------------------------------


#---------------------------------------------------------------
# 使用例: aws_iam_policy_document データソースとの組み合わせ
#---------------------------------------------------------------
# aws_iam_policy_document データソースを使用することで、
# ポリシードキュメントをより構造化された方法で定義できます。
#
# data "aws_iam_policy_document" "example" {
#   statement {
#     sid    = "AllowEC2Describe"
#     effect = "Allow"
#
#     actions = [
#       "ec2:DescribeInstances",
#       "ec2:DescribeVolumes",
#       "ec2:DescribeSnapshots",
#     ]
#
#     resources = ["*"]
#   }
#
#   statement {
#     sid    = "AllowS3ReadOnly"
#     effect = "Allow"
#
#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket",
#     ]
#
#     resources = [
#       "arn:aws:s3:::example-bucket",
#       "arn:aws:s3:::example-bucket/*",
#     ]
#   }
# }
#
# resource "aws_iam_policy" "example" {
#   name        = "example-policy"
#   description = "Example policy using aws_iam_policy_document"
#   policy      = data.aws_iam_policy_document.example.json
# }
#---------------------------------------------------------------


#---------------------------------------------------------------
# 使用例: ポリシーをIAMロールにアタッチ
#---------------------------------------------------------------
# resource "aws_iam_role_policy_attachment" "example" {
#   role       = aws_iam_role.example.name
#   policy_arn = aws_iam_policy.example.arn
# }
#---------------------------------------------------------------
