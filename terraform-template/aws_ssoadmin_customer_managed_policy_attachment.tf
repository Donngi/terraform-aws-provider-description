#---------------------------------------------------------------
# AWS IAM Identity Center カスタマー管理ポリシーアタッチメント
#---------------------------------------------------------------
#
# AWS IAM Identity Center（旧AWS SSO）のPermission Setに
# カスタマー管理ポリシーをアタッチするためのリソースです。
# このリソースを使用することで、各AWSアカウントで作成した
# IAMカスタマー管理ポリシーをPermission Setに関連付けることができます。
#
# AWS公式ドキュメント:
#   - AttachCustomerManagedPolicyReferenceToPermissionSet API: https://docs.aws.amazon.com/singlesignon/latest/APIReference/API_AttachCustomerManagedPolicyReferenceToPermissionSet.html
#   - IAM Identity CenterでのIAMポリシーの使用: https://docs.aws.amazon.com/singlesignon/latest/userguide/howtocmp.html
#   - Permission Setのカスタム権限: https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetcustom.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_customer_managed_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_customer_managed_policy_attachment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # instance_arn (Required, Forces new resource)
  # 設定内容: 操作を実行するIAM Identity CenterインスタンスのARNを指定します。
  # 設定可能な値: 有効なIAM Identity CenterインスタンスのARN
  # 注意: この値を変更すると、リソースが再作成されます。
  # 参考: https://docs.aws.amazon.com/singlesignon/latest/APIReference/API_AttachCustomerManagedPolicyReferenceToPermissionSet.html
  instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef"

  # permission_set_arn (Required, Forces new resource)
  # 設定内容: カスタマー管理ポリシーをアタッチするPermission SetのARNを指定します。
  # 設定可能な値: 有効なPermission SetのARN
  # 注意: この値を変更すると、リソースが再作成されます。
  # 参考: https://docs.aws.amazon.com/singlesignon/latest/APIReference/API_AttachCustomerManagedPolicyReferenceToPermissionSet.html
  permission_set_arn = "arn:aws:sso:::permissionSet/ssoins-1234567890abcdef/ps-1234567890abcdef"

  # id (Optional)
  # 設定内容: Terraformリソース識別子。通常は自動生成されます。
  # 設定可能な値: 文字列（ポリシー名、ポリシーパス、Permission Set ARN、SSO Instance ARNをカンマで結合した形式）
  # 省略時: Terraformが自動生成します。
  # 注意: 通常は明示的に設定する必要はありません。
  # id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # カスタマー管理ポリシー参照
  #-------------------------------------------------------------

  # customer_managed_policy_reference (Required, Forces new resource)
  # 設定内容: アタッチするカスタマー管理ポリシーの名前とパスを指定します。
  # 注意:
  #   - このブロックは必須で、最小1個、最大1個のブロックを指定する必要があります。
  #   - この値を変更すると、リソースが再作成されます。
  #   - ポリシーは、Permission Setを割り当てる各AWSアカウントに存在している必要があります。
  #   - ポリシー名は、管理アカウントと各メンバーアカウントで一致している必要があります。
  # 参考: https://docs.aws.amazon.com/singlesignon/latest/userguide/howtocmp.html
  customer_managed_policy_reference {
    # name (Required, Forces new resource)
    # 設定内容: アタッチするカスタマー管理IAMポリシーの名前を指定します。
    # 設定可能な値: 有効なIAMポリシー名（1-128文字の英数字と+-=._:/@）
    # 注意:
    #   - この値を変更すると、リソースが再作成されます。
    #   - 指定したポリシーは、Permission Setを割り当てる各AWSアカウントに存在している必要があります。
    # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-friendly-names
    name = "MyCustomPolicy"

    # path (Optional, Forces new resource)
    # 設定内容: アタッチするIAMポリシーのパスを指定します。
    # 設定可能な値: 有効なIAMパス（スラッシュで始まり、スラッシュで終わる文字列）
    # 省略時: "/" がデフォルト値として使用されます。
    # 注意: この値を変更すると、リソースが再作成されます。
    # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-friendly-names
    path = "/"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を指定します。
  # 省略時: デフォルトのタイムアウト値が使用されます。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    create = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシー名、ポリシーパス、Permission SetのARN、
#       SSO InstanceのARNをカンマ(`,`)で結合した文字列。
#       形式: "{policy_name},{policy_path},{permission_set_arn},{instance_arn}"
#---------------------------------------------------------------

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
# 警告: このリソースを aws_ssoadmin_customer_managed_policy_attachments_exclusive
#       リソースと同じPermission Setに対して同時に使用しないでください。
#       競合が発生し、カスタマー管理ポリシーが削除される可能性があります。
#
# 自動プロビジョニング: このリソースを作成すると、自動的にPermission Setが
#                      プロビジョニングされ、割り当てられたすべてのアカウントに
#                      対応する更新が適用されます。
#                      参考: https://docs.aws.amazon.com/singlesignon/latest/APIReference/API_ProvisionPermissionSet.html
#---------------------------------------------------------------
