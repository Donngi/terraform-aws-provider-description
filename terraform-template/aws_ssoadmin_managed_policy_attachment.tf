#---------------------------------------------------------------
# AWS SSO Admin Managed Policy Attachment
#---------------------------------------------------------------
#
# AWS IAM Identity Center（旧AWS SSO）のPermission Setに
# IAMマネージドポリシーをアタッチするリソースです。
# マネージドポリシーをPermission Setに関連付けることで、
# 割り当てられたアカウントのユーザーに対してポリシーで定義された
# 権限を付与します。
#
# NOTE: このリソースを作成すると、Permission Setが自動的に
#       プロビジョニングされ、割り当てられたすべてのアカウントに
#       対応する更新が適用されます。
#
# WARNING: 同じPermission Setに対して
#          aws_ssoadmin_managed_policy_attachments_exclusive リソースと
#          併用しないでください。競合が発生し、マネージドポリシーが
#          削除される可能性があります。
#
# AWS公式ドキュメント:
#   - IAM Identity Center概要: https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html
#   - Permission Set: https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetsconcept.html
#   - ProvisionPermissionSet API: https://docs.aws.amazon.com/singlesignon/latest/APIReference/API_ProvisionPermissionSet.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_managed_policy_attachment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # instance_arn (Required)
  # 設定内容: 操作が実行されるSSOインスタンスのARNを指定します。
  # 設定可能な値: IAM Identity CenterインスタンスのARN
  # 注意: リソース作成後の変更はできません（Forces new resource）
  # 補足: data "aws_ssoadmin_instances" を使って動的に取得するのが一般的です。
  instance_arn = tolist(data.aws_ssoadmin_instances.example.arns)[0]

  # managed_policy_arn (Required)
  # 設定内容: Permission SetにアタッチするマネージドポリシーのARNを指定します。
  # 設定可能な値: IAMマネージドポリシーのARN
  # 注意: リソース作成後の変更はできません（Forces new resource）
  # 例:
  #   - AWS管理ポリシー: "arn:aws:iam::aws:policy/ReadOnlyAccess"
  #   - カスタム管理ポリシー: "arn:aws:iam::123456789012:policy/MyCustomPolicy"
  # 関連機能: IAMマネージドポリシー
  #   AWS管理ポリシーまたはカスタマー管理ポリシーを指定できます。
  #   - https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"

  # permission_set_arn (Required)
  # 設定内容: マネージドポリシーをアタッチするPermission SetのARNを指定します。
  # 設定可能な値: SSO Permission SetのARN
  # 注意: リソース作成後の変更はできません（Forces new resource）
  # 補足: aws_ssoadmin_permission_set リソースから参照するのが一般的です。
  permission_set_arn = aws_ssoadmin_permission_set.example.arn

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
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を指定します。
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: リソース作成時のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間を表す文字列（例: "10m", "30s"）
  #   create = "10m"
  #
  #   # delete (Optional)
  #   # 設定内容: リソース削除時のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間を表す文字列（例: "10m", "30s"）
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: マネージドポリシーARN、Permission Set ARN、SSOインスタンスARNを
#        カンマ区切りで結合した文字列
#
# - managed_policy_name: IAMマネージドポリシーの名前
#---------------------------------------------------------------
