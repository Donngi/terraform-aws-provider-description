#---------------------------------------------------------------
# AWS IAM Group Membership
#---------------------------------------------------------------
#
# IAMグループのメンバーシップ（ユーザーの所属）を管理する
# Terraformリソースです。指定したIAMユーザーのリストを
# IAMグループに一括で紐付けます。
#
# 主な特徴:
# - IAMグループに所属するユーザーを宣言的に管理
# - 同一グループに対して複数のリソースを使用すると
#   不整合が生じるため、1グループ1リソースが原則
# - ユーザーリストの変更（追加・削除）はin-placeで反映
#
# 重要な注意事項:
# 1. 排他的管理の挙動
#    このリソースは指定されたグループのメンバーシップを
#    排他的に管理します。同一グループを別のリソースで
#    管理すると、互いに設定を上書きし合い、不整合が生じます。
#
# 2. aws_iam_user_group_membershipとの違い
#    ユーザー側を起点に管理したい場合は、
#    aws_iam_user_group_membership リソースを使用してください。
#    こちらは排他的管理を行わないため、複数リソースの共存が可能です。
#
# 3. ユーザーの事前作成
#    usersに指定するIAMユーザーは事前に作成されている
#    必要があります。存在しないユーザーを指定するとエラーになります。
#
# ユースケース:
# - チームや役割ごとのグループにユーザーをまとめて割り当てる場合
# - グループメンバーシップをコードで一元管理したい場合
# - 新しいメンバーの追加・離脱をTerraformで管理したい場合
#
# AWS公式ドキュメント:
#   - IAM Groups: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups.html
#   - AddUserToGroup API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_AddUserToGroup.html
#   - RemoveUserFromGroup API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_RemoveUserFromGroup.html
#   - GetGroup API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_GetGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_group_membership
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_group_membership" "example" {
  #-------------------------------------------------------------
  # メンバーシップの識別名 (Required)
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: このグループメンバーシップリソースを識別するための名前を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 省略不可（必須項目）
  #
  # この値はAWS APIに送信される識別子であり、Terraform内での管理名です。
  # グループ名と同一にしておくと管理しやすくなります。
  name = "tf-example-group-membership"

  #-------------------------------------------------------------
  # メンバーシップを適用するIAMグループ (Required)
  #-------------------------------------------------------------

  # group (Required)
  # 設定内容: ユーザーを所属させるIAMグループの名前を指定します。
  # 設定可能な値: 既存のIAMグループ名（1〜128文字）
  # 省略時: 省略不可（必須項目）
  #
  # 注意事項:
  #   - 同一グループを複数の aws_iam_group_membership リソースで
  #     管理すると不整合が発生します。1グループにつき1リソースを使用してください。
  #   - aws_iam_group リソースで作成したグループを参照する場合は
  #     aws_iam_group.example.name のように指定することを推奨します。
  group = aws_iam_group.example.name

  #-------------------------------------------------------------
  # グループに所属させるIAMユーザーのリスト (Required)
  #-------------------------------------------------------------

  # users (Required)
  # 設定内容: グループのメンバーとするIAMユーザー名のセットを指定します。
  # データ型: set(string) - 文字列のセット（重複なし、順序なし）
  # 省略時: 省略不可（必須項目）
  #
  # 動作の詳細:
  #   - このリストに含まれるユーザーのみがグループに所属します。
  #   - リストから削除されたユーザーは次回のapply時にグループから除外されます。
  #   - 空のリスト [] を指定するとグループのメンバーが0人になります。
  #   - aws_iam_user リソースで作成したユーザーを参照する場合は
  #     aws_iam_user.example.name のように指定することを推奨します。
  #
  # 設定例:
  #   users = [
  #     aws_iam_user.alice.name,
  #     aws_iam_user.bob.name,
  #   ]
  users = [
    aws_iam_user.example.name,
  ]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
#
# id          - リソースの識別子。name と同じ値が設定されます。
# name        - 設定したメンバーシップの識別名。
# group       - 設定したIAMグループ名。
# users       - グループに所属するIAMユーザー名のリスト。
#
