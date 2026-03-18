#---------------------------------------------------------------
# AWS IAM Identity Center カスタマー管理ポリシーアタッチメント（排他管理）
#---------------------------------------------------------------
#
# AWS IAM Identity Center（旧AWS SSO）のPermission Setに対する
# カスタマー管理ポリシーのアタッチメントを排他的に管理するリソースです。
# このリソースを使用すると、Terraformは設定に定義されていない
# カスタマー管理ポリシーをPermission Setから自動的に削除します。
#
# 重要: aws_ssoadmin_customer_managed_policy_attachment リソースと
#       同じPermission Setに対して同時に使用しないでください。
#       競合が発生し、ポリシーが意図せず削除される可能性があります。
#
# AWS公式ドキュメント:
#   - IAM Identity CenterでのIAMポリシーの使用: https://docs.aws.amazon.com/singlesignon/latest/userguide/howtocmp.html
#   - Permission Setのカスタム権限: https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetcustom.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_customer_managed_policy_attachments_exclusive
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_customer_managed_policy_attachments_exclusive" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # instance_arn (Required)
  # 設定内容: 操作を実行するIAM Identity CenterインスタンスのARNを指定します。
  # 設定可能な値: 有効なIAM Identity CenterインスタンスのARN
  instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef"

  # permission_set_arn (Required)
  # 設定内容: カスタマー管理ポリシーを排他的に管理するPermission SetのARNを指定します。
  # 設定可能な値: 有効なPermission SetのARN
  permission_set_arn = "arn:aws:sso:::permissionSet/ssoins-1234567890abcdef/ps-1234567890abcdef"

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

  # customer_managed_policy_reference (Optional)
  # 設定内容: Permission Setにアタッチするカスタマー管理ポリシーを指定します。
  # 注意:
  #   - このリソースは排他管理のため、ここに定義されていないポリシーは
  #     Permission Setから自動的に削除されます。
  #   - ブロックを省略すると、すべてのカスタマー管理ポリシーが削除されます。
  #   - ポリシーは、Permission Setを割り当てる各AWSアカウントに存在している必要があります。
  # 参考: https://docs.aws.amazon.com/singlesignon/latest/userguide/howtocmp.html
  customer_managed_policy_reference {
    # name (Required)
    # 設定内容: アタッチするカスタマー管理IAMポリシーの名前を指定します。
    # 設定可能な値: 有効なIAMポリシー名（1-128文字の英数字と+-=._:/@）
    # 注意: 指定したポリシーは、Permission Setを割り当てる各AWSアカウントに存在している必要があります。
    # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-friendly-names
    name = "MyCustomPolicy"

    # path (Optional)
    # 設定内容: アタッチするIAMポリシーのパスを指定します。
    # 設定可能な値: 有効なIAMパス（スラッシュで始まり、スラッシュで終わる文字列）
    # 省略時: "/" がデフォルト値として使用されます。
    # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-friendly-names
    path = "/"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新操作のタイムアウト時間を指定します。
  # 省略時: デフォルトのタイムアウト値が使用されます。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは追加の属性をエクスポートしません。
#
# 注意: このリソースを削除しても、アタッチされているカスタマー管理
#       ポリシーは自動的には削除されません。Terraformによる排他管理が
#       解除されるだけで、既存のアタッチメントはそのまま維持されます。
#---------------------------------------------------------------
