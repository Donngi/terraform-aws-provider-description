#---------------------------------------------------------------
# AWS IAM Policy Attachment
#---------------------------------------------------------------
#
# AWS IAM (Identity & Access Management) マネージドポリシーを
# ユーザー・グループ・ロールに一括アタッチするためのTerraformリソースです。
#
# このリソースを使用することで、単一のIAMマネージドポリシーを
# 複数のユーザー・グループ・ロールに対して同時にアタッチできます。
#
# 主な特徴:
# - 1つのポリシーをユーザー・グループ・ロールに横断的にアタッチ
# - AWS管理ポリシーおよびカスタマー管理ポリシーの両方に対応
# - アタッチ先のユーザー・グループ・ロールはセットで管理（排他的）
#
# 重要な注意事項:
# 1. このリソースは排他的なアタッチメントです
#    Terraformの管理外で同じポリシーが別のエンティティにアタッチされていた場合、
#    このリソースの apply 時にそのアタッチメントが削除されます。
#    排他的管理が不要な場合は以下のリソースを検討してください:
#      - aws_iam_user_policy_attachment（ユーザー個別）
#      - aws_iam_group_policy_attachment（グループ個別）
#      - aws_iam_role_policy_attachment（ロール個別）
#
# 2. 複数のポリシーをアタッチする場合
#    このリソースは1つのポリシーのみ管理します。
#    複数のポリシーをアタッチするには、このリソースを複数定義してください。
#
# 3. エンティティの上限
#    users / groups / roles いずれかを空リストにすることも可能です。
#    ただし、IAMエンティティへのポリシーアタッチ数の上限（デフォルト10個）に注意してください。
#
# ユースケース:
# - 共通の読み取り専用ポリシーを複数のロールとグループに同時に付与する
# - 特定のサービスアカウント（ユーザー）とロールに同じ権限セットを適用する
# - 組織全体で共通のセキュリティポリシーを横断的に適用する
#
# AWS公式ドキュメント:
#   - IAM ポリシーのアタッチ: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-attach-detach.html
#   - 管理ポリシーとインラインポリシー: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
#   - IAM クォータ: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_iam-quotas.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_policy_attachment" "example" {
  #-------------------------------------------------------------
  # アタッチメント識別情報
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: このポリシーアタッチメントに付与する名前を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 省略不可（必須項目）
  # 注意: この名前はAWSリソースの識別子として使用されます。
  #       同一アカウント・リージョン内でユニークである必要があります。
  name = "example-policy-attachment"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy_arn (Required)
  # 設定内容: アタッチするIAMマネージドポリシーのARNを指定します。
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
  #   - "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"   # S3 読み取り専用
  #   - "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"  # EC2 読み取り専用
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"

  #-------------------------------------------------------------
  # アタッチ先エンティティ
  #-------------------------------------------------------------

  # users (Optional)
  # 設定内容: このポリシーをアタッチするIAMユーザー名のセットを指定します。
  # 設定可能な値: IAMユーザー名の文字列セット
  # 省略時: [] （空セット、ユーザーへのアタッチなし）
  # 注意: ここに指定しないユーザーへの同ポリシーのアタッチは、
  #       apply 時に削除されます（排他的管理）。
  #       ユーザー個別の非排他的管理には aws_iam_user_policy_attachment を使用してください。
  users = []

  # groups (Optional)
  # 設定内容: このポリシーをアタッチするIAMグループ名のセットを指定します。
  # 設定可能な値: IAMグループ名の文字列セット
  # 省略時: [] （空セット、グループへのアタッチなし）
  # 注意: ここに指定しないグループへの同ポリシーのアタッチは、
  #       apply 時に削除されます（排他的管理）。
  #       グループ個別の非排他的管理には aws_iam_group_policy_attachment を使用してください。
  groups = []

  # roles (Optional)
  # 設定内容: このポリシーをアタッチするIAMロール名のセットを指定します。
  # 設定可能な値: IAMロール名の文字列セット
  # 省略時: [] （空セット、ロールへのアタッチなし）
  # 注意: ここに指定しないロールへの同ポリシーのアタッチは、
  #       apply 時に削除されます（排他的管理）。
  #       ロール個別の非排他的管理には aws_iam_role_policy_attachment を使用してください。
  roles = []
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
#
# id - アタッチメントを識別するID
#        形式: アタッチメント名（name 引数の値と同一）
#
#---------------------------------------------------------------
