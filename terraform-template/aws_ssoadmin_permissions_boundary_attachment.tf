#---------------------------------------------------------------
# AWS SSO Admin Permissions Boundary Attachment
#---------------------------------------------------------------
#
# AWS IAM Identity Center (旧AWS SSO) の Permission Set に
# パーミッションバウンダリーポリシーをアタッチするリソースです。
# パーミッションバウンダリーは、IAMエンティティに付与できる最大権限を制限し、
# 権限昇格を防止するセキュリティメカニズムです。
#
# 注意: 1つのPermission Setに対してアタッチできるパーミッションバウンダリーは
#       最大1つです。同じPermission Setに対して複数の
#       aws_ssoadmin_permissions_boundary_attachmentを定義すると、
#       永続的な差分が発生します。
#
# AWS公式ドキュメント:
#   - IAM Identity Center概要: https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html
#   - パーミッションバウンダリー: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_boundaries.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permissions_boundary_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_permissions_boundary_attachment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # instance_arn (Required)
  # 設定内容: SSO インスタンスの Amazon Resource Name (ARN) を指定します。
  # 設定可能な値: 有効な SSO インスタンス ARN
  # 注意: リソース作成後の変更はできません（Forces new resource）
  # 関連機能: IAM Identity Center インスタンス
  #   data "aws_ssoadmin_instances" を使用してインスタンスARNを取得できます。
  #   - https://docs.aws.amazon.com/singlesignon/latest/userguide/step1.html
  instance_arn = tolist(data.aws_ssoadmin_instances.example.arns)[0]

  # permission_set_arn (Required)
  # 設定内容: パーミッションバウンダリーをアタッチする Permission Set の ARN を指定します。
  # 設定可能な値: 有効な Permission Set ARN
  # 注意: リソース作成後の変更はできません（Forces new resource）
  # 関連機能: SSO Permission Set
  #   aws_ssoadmin_permission_set リソースで作成した Permission Set の ARN を参照できます。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set
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
  # パーミッションバウンダリー設定
  #-------------------------------------------------------------

  # permissions_boundary (Required)
  # 設定内容: パーミッションバウンダリーとして使用するポリシーを指定するブロックです。
  # 注意: managed_policy_arn または customer_managed_policy_reference の
  #       いずれか一方を指定します。両方同時に指定することはできません。
  #       リソース作成後の変更はできません（Forces new resource）
  permissions_boundary {
    # managed_policy_arn (Optional)
    # 設定内容: パーミッションバウンダリーとして使用する AWS マネージドポリシーの ARN を指定します。
    # 設定可能な値: 有効な AWS マネージド IAM ポリシー ARN
    # 注意: customer_managed_policy_reference と同時に指定できません
    # カスタマーマネージドポリシー参照 (customer_managed_policy_reference)
    #-----------------------------------------------------------
    # パーミッションバウンダリーとしてカスタマーマネージドポリシーを使用する場合に指定します。
    # managed_policy_arn の代わりに使用します。
    # 注意: managed_policy_arn と同時に指定できません。
    #       リソース作成後の変更はできません（Forces new resource）
    # customer_managed_policy_reference {
    #   # name (Required)
    #   # 設定内容: カスタマーマネージド IAM ポリシーの名前を指定します。
    #   # 設定可能な値: 既存の IAM ポリシー名
    #   # 注意: リソース作成後の変更はできません（Forces new resource）
    #   name = "MyCustomPermissionsBoundary"
    #
    #   # path (Optional)
    #   # 設定内容: IAM ポリシーのパスを指定します。
    #   # 設定可能な値: "/" で始まるパス文字列
    #   # 省略時: "/"
    #   # 注意: リソース作成後の変更はできません（Forces new resource）
    #   # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-friendly-names
    #   path = "/"
    # }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を指定します。
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: リソース作成時のタイムアウト時間
  #   # 設定可能な値: 時間を表す文字列（例: "10m", "30s"）
  #   create = "10m"
  #
  #   # delete (Optional)
  #   # 設定内容: リソース削除時のタイムアウト時間
  #   # 設定可能な値: 時間を表す文字列（例: "10m", "30s"）
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Permission Set ARN と SSO Instance ARN をカンマ区切りで
#        結合した文字列
#---------------------------------------------------------------
