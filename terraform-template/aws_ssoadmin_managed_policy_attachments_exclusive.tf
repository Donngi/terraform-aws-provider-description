#---------------------------------------------------------------
# AWS IAM Identity Center マネージドポリシーアタッチメント排他管理
#---------------------------------------------------------------
#
# AWS IAM Identity Center（旧AWS SSO）のPermission Setにアタッチされた
# マネージドポリシーを排他的に管理するリソースです。
# このリソースで定義されていないマネージドポリシーがPermission Setに
# アタッチされている場合、Terraformがそれらを自動的に削除します。
#
# NOTE: このリソースを破棄（destroy）しても、アタッチ済みのマネージドポリシーは
#       デタッチされません。Terraformによる管理が解除されるだけで、
#       Permission Setは破棄時点のポリシーを保持し続けます。
#
# WARNING: 同じPermission Setに対して
#          aws_ssoadmin_managed_policy_attachment リソースと
#          併用しないでください。競合が発生し、マネージドポリシーが
#          削除される可能性があります。
#
# AWS公式ドキュメント:
#   - IAM Identity Center概要: https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html
#   - Permission Set: https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetsconcept.html
#   - マネージドポリシーの使用: https://docs.aws.amazon.com/singlesignon/latest/userguide/howtocmp.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachments_exclusive
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_managed_policy_attachments_exclusive" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # instance_arn (Required)
  # 設定内容: 操作を実行するIAM Identity CenterインスタンスのARNを指定します。
  # 設定可能な値: 有効なIAM Identity CenterインスタンスのARN
  # 補足: data "aws_ssoadmin_instances" を使って動的に取得するのが一般的です。
  instance_arn = tolist(data.aws_ssoadmin_instances.example.arns)[0]

  # permission_set_arn (Required)
  # 設定内容: マネージドポリシーを排他的に管理するPermission SetのARNを指定します。
  # 設定可能な値: 有効なSSO Permission SetのARN
  # 補足: aws_ssoadmin_permission_set リソースから参照するのが一般的です。
  permission_set_arn = aws_ssoadmin_permission_set.example.arn

  # managed_policy_arns (Required)
  # 設定内容: Permission SetにアタッチするIAMマネージドポリシーのARNセットを指定します。
  # 設定可能な値: IAMマネージドポリシーARNのセット（空セットも可）
  # 注意: ここに含まれないマネージドポリシーはPermission Setから自動的にデタッチされます。
  # 例:
  #   - AWS管理ポリシー: "arn:aws:iam::aws:policy/ReadOnlyAccess"
  #   - カスタム管理ポリシー: "arn:aws:iam::123456789012:policy/MyCustomPolicy"
  #   - 空セット（全ポリシーをデタッチ）: []
  # 関連機能: IAMマネージドポリシー
  #   AWS管理ポリシーまたはカスタマー管理ポリシーを指定できます。
  #   - https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新操作のタイムアウト時間を指定します。
  # 省略時: デフォルトのタイムアウト値が使用されます。
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: リソース作成のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
  #   create = "10m"
  #
  #   # update (Optional)
  #   # 設定内容: リソース更新のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
  #   update = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - instance_arn: SSOインスタンスのARN
# - permission_set_arn: Permission SetのARN
# - managed_policy_arns: アタッチされたマネージドポリシーARNのセット
# - region: リソースが管理されるリージョン
#---------------------------------------------------------------
