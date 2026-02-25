#---------------------------------------------------------------
# AWS IAM Group Policy Attachment
#---------------------------------------------------------------
#
# AWS IAM (Identity & Access Management) グループにマネージドポリシーを
# アタッチするためのTerraformリソースです。
#
# このリソースを使用することで、IAMグループに対して特定のIAMポリシー（マネージドポリシー）を
# アタッチし、グループに所属するすべてのユーザーに対して権限を一括で付与できます。
#
# 主な特徴:
# - IAMグループへのマネージドポリシーの直接アタッチ
# - AWS管理ポリシーおよびカスタマー管理ポリシーの両方に対応
# - グループに所属するすべてのユーザーへの権限の一括適用
#
# 重要な注意事項:
# 1. このリソースは非排他的なアタッチメントです
#    このリソースで管理していないポリシーが手動でアタッチされても削除しません。
#    排他的管理が必要な場合は aws_iam_group_policy_attachments_exclusive を使用してください。
#
# 2. aws_iam_group_policy_attachments_exclusive との併用
#    aws_iam_group_policy_attachments_exclusive リソースと併用する場合、
#    このリソースでアタッチするポリシーARNを policy_arns 引数にも含める必要があります。
#    含めない場合、排他的リソースがこのリソースのアタッチメントを削除します。
#
# 3. 1グループあたりのポリシー上限
#    1つのIAMグループにアタッチできるマネージドポリシーは最大10個です。
#    （デフォルトクォータ、サービスクォータの引き上げ申請も可能）
#
# 4. 差分ドリフトの考慮
#    コンソール等でポリシーを手動でアタッチした場合、Terraform の plan で差分が出ます。
#    Terraformによる管理外のポリシーを検知したい場合は import を活用してください。
#
# ユースケース:
# - 開発チームのIAMグループに共通の開発者権限を付与する
# - ReadOnlyアクセスなどのAWS管理ポリシーをグループに適用する
# - 最小権限の原則に基づいてカスタムポリシーをグループに紐付ける
# - 複数のユーザーに同じ権限セットを効率的に割り当てる
#
# AWS公式ドキュメント:
#   - IAM グループの概要: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups.html
#   - グループへのポリシーのアタッチ: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups_manage_attach-policy.html
#   - 管理ポリシーとインラインポリシー: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
#   - IAM クォータ: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_iam-quotas.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_group_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_group_policy_attachment" "example" {
  #-------------------------------------------------------------
  # グループ設定
  #-------------------------------------------------------------

  # group (Required)
  # 設定内容: マネージドポリシーをアタッチする対象のIAMグループ名を指定します。
  # 設定可能な値: 有効なIAMグループ名（既存のグループが対象）
  # 省略時: 省略不可（必須項目）
  # 制約事項:
  #   - 事前に作成済みのIAMグループを指定する必要があります
  #   - グループ名は1〜128文字、英数字および + = , . @ - _ が使用可能
  #   - 同一AWSアカウント内でユニークなグループ名であること
  # 推奨: aws_iam_group リソースの name 属性を参照することでリソース間の依存関係が明示できます。
  #   - 例: aws_iam_group.example.name
  group = aws_iam_group.example.name

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy_arn (Required)
  # 設定内容: グループにアタッチするIAMマネージドポリシーのARNを指定します。
  # 設定可能な値:
  #   - AWS管理ポリシーのARN（例: "arn:aws:iam::aws:policy/ReadOnlyAccess"）
  #   - カスタマー管理ポリシーのARN（例: aws_iam_policy.example.arn）
  # 省略時: 省略不可（必須項目）
  # ARNの形式:
  #   - AWS管理ポリシー: arn:aws:iam::aws:policy/<PolicyName>
  #   - カスタマー管理ポリシー: arn:aws:iam::<AccountId>:policy/<PolicyName>
  # 代表的なAWS管理ポリシー:
  #   - "arn:aws:iam::aws:policy/ReadOnlyAccess"           # 読み取り専用アクセス
  #   - "arn:aws:iam::aws:policy/AdministratorAccess"      # 管理者アクセス
  #   - "arn:aws:iam::aws:policy/PowerUserAccess"          # パワーユーザーアクセス
  #   - "arn:aws:iam::aws:policy/AWSLambda_FullAccess"     # Lambda フルアクセス
  #   - "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"   # S3 読み取り専用
  #   - "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"  # EC2 読み取り専用
  # 注意: 1グループあたりのアタッチ可能なマネージドポリシー数はデフォルトで最大10個です。
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
#
# id - グループ名とポリシーARNを組み合わせた一意のID
#        形式: <group_name>/<policy_arn>
#        例: developers/arn:aws:iam::aws:policy/ReadOnlyAccess
#
#---------------------------------------------------------------
