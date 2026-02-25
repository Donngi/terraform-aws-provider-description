#---------------------------------------------------------------
# AWS IAM Role Policy Attachment
#---------------------------------------------------------------
#
# AWS IAM (Identity & Access Management) ロールにマネージドポリシーを
# アタッチするためのTerraformリソースです。
#
# このリソースを使用することで、IAMロールに対して特定のIAMポリシー（マネージドポリシー）を
# アタッチし、そのロールを引き受けるエンティティ（EC2インスタンス、Lambda関数、
# IAMユーザー等）に対して権限を付与できます。
#
# 主な特徴:
# - IAMロールへのマネージドポリシーの直接アタッチ
# - AWS管理ポリシーおよびカスタマー管理ポリシーの両方に対応
# - EC2インスタンスプロファイル、Lambda実行ロール、ECSタスクロール等に適用可能
#
# 重要な注意事項:
# 1. このリソースは非排他的なアタッチメントです
#    このリソースで管理していないポリシーが手動でアタッチされても削除しません。
#    排他的管理が必要な場合は aws_iam_role_policies_exclusive を使用してください。
#
# 2. aws_iam_role_policies_exclusive との併用
#    aws_iam_role_policies_exclusive リソースと併用する場合、
#    このリソースでアタッチするポリシーARNを policy_arns 引数にも含める必要があります。
#    含めない場合、排他的リソースがこのリソースのアタッチメントを削除します。
#
# 3. 1ロールあたりのポリシー上限
#    1つのIAMロールにアタッチできるマネージドポリシーは最大10個です。
#    （デフォルトクォータ、サービスクォータの引き上げ申請も可能）
#
# 4. 差分ドリフトの考慮
#    コンソール等でポリシーを手動でアタッチした場合、Terraform の plan で差分が出ます。
#    Terraformによる管理外のポリシーを検知したい場合は import を活用してください。
#
# ユースケース:
# - EC2インスタンスプロファイルのロールにS3アクセス権限を付与する
# - Lambda関数の実行ロールにCloudWatchログ出力権限を付与する
# - ECSタスクロールに必要なAWSサービスへのアクセス権限を付与する
# - 最小権限の原則に基づいてカスタムポリシーをロールに紐付ける
#
# AWS公式ドキュメント:
#   - IAM ロールの概要: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
#   - ロールへのポリシーのアタッチ: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-attach-detach.html
#   - 管理ポリシーとインラインポリシー: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
#   - IAM クォータ: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_iam-quotas.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "example" {
  #-------------------------------------------------------------
  # ロール設定
  #-------------------------------------------------------------

  # role (Required)
  # 設定内容: マネージドポリシーをアタッチする対象のIAMロール名を指定します。
  # 設定可能な値: 有効なIAMロール名（既存のロールが対象）
  # 省略時: 省略不可（必須項目）
  # 制約事項:
  #   - 事前に作成済みのIAMロールを指定する必要があります
  #   - ロール名は1〜64文字、英数字および + = , . @ - _ が使用可能
  #   - 同一AWSアカウント内でユニークなロール名であること
  # 推奨: aws_iam_role リソースの name 属性を参照することでリソース間の依存関係が明示できます。
  #   - 例: aws_iam_role.example.name
  role = aws_iam_role.example.name

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy_arn (Required)
  # 設定内容: ロールにアタッチするIAMマネージドポリシーのARNを指定します。
  # 設定可能な値:
  #   - AWS管理ポリシーのARN（例: "arn:aws:iam::aws:policy/ReadOnlyAccess"）
  #   - カスタマー管理ポリシーのARN（例: aws_iam_policy.example.arn）
  # 省略時: 省略不可（必須項目）
  # ARNの形式:
  #   - AWS管理ポリシー: arn:aws:iam::aws:policy/<PolicyName>
  #   - カスタマー管理ポリシー: arn:aws:iam::<AccountId>:policy/<PolicyName>
  # 代表的なAWS管理ポリシー:
  #   - "arn:aws:iam::aws:policy/ReadOnlyAccess"                          # 読み取り専用アクセス
  #   - "arn:aws:iam::aws:policy/AdministratorAccess"                     # 管理者アクセス
  #   - "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"                  # S3 読み取り専用
  #   - "arn:aws:iam::aws:policy/AWSLambdaBasicExecutionRole"             # Lambda 基本実行ロール
  #   - "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"      # ECR 読み取り専用
  #   - "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"                # CloudWatch Logs フルアクセス
  # 注意: 1ロールあたりのアタッチ可能なマネージドポリシー数はデフォルトで最大10個です。
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
#
# id - ロール名とポリシーARNを組み合わせた一意のID
#        形式: <role_name>/<policy_arn>
#        例: my-role/arn:aws:iam::aws:policy/ReadOnlyAccess
#
#---------------------------------------------------------------
