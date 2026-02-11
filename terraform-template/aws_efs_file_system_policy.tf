#---------------------------------------------------------------
# EFS File System Policy
#---------------------------------------------------------------
#
# EFS ファイルシステムに対するリソースベースのアクセスポリシーを管理します。
# IAM リソースベースポリシーとして、どのプリンシパル（AWS アカウント、ユーザー、ロール等）が
# どの条件下でファイルシステムに対してどのアクションを実行できるかを制御します。
#
# 主な用途:
#   - NFS クライアントの IAM ベース認証制御
#   - ClientMount（読み取り）、ClientWrite（書き込み）、ClientRootAccess（root アクセス）の制御
#   - 特定の IP アドレスやマウントターゲット経由のアクセス制限
#   - EFS Access Point を使用したアクセス制御
#
# AWS公式ドキュメント:
#   - Resource-based policy examples: https://docs.aws.amazon.com/efs/latest/ug/security_iam_resource-based-policy-examples.html
#   - Using IAM to control file system access: https://docs.aws.amazon.com/efs/latest/ug/iam-access-control-nfs-efs.html
#   - PutFileSystemPolicy API: https://docs.aws.amazon.com/efs/latest/ug/API_PutFileSystemPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/efs_file_system_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_efs_file_system_policy" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # file_system_id - (Required) EFS ファイルシステムの ID
  # 
  # ポリシーを適用する対象の EFS ファイルシステムを指定します。
  # 形式: fs-xxxxxxxx (例: fs-ccfc0d65)
  # 
  # 参考: https://docs.aws.amazon.com/efs/latest/ug/API_PutFileSystemPolicy.html
  file_system_id = aws_efs_file_system.example.id

  # policy - (Required) JSON 形式のファイルシステムポリシー
  # 
  # EFS ファイルシステムに適用する IAM リソースベースポリシーを JSON 形式で指定します。
  # 各ファイルシステムには正確に 1 つのポリシーが存在し、明示的に設定しない場合は
  # デフォルトポリシー（すべての匿名クライアントにフルアクセス許可）が適用されます。
  # 
  # ポリシーの制限:
  #   - 最大 20,000 文字
  #   - 複数のポリシーステートメントを含めることが可能
  # 
  # 主なアクション:
  #   - elasticfilesystem:ClientMount      : 読み取り専用アクセス
  #   - elasticfilesystem:ClientWrite      : 書き込みアクセス
  #   - elasticfilesystem:ClientRootAccess : root アクセス
  # 
  # 主な Condition Keys:
  #   - aws:SecureTransport                    : TLS 接続の強制
  #   - aws:SourceIp                           : 特定 IP アドレスからのアクセス制限
  #   - elasticfilesystem:AccessPointArn       : Access Point 経由のアクセス制限
  #   - elasticfilesystem:AccessedViaMountTarget : マウントターゲット経由のアクセス制限
  # 
  # 使用例:
  #   - data.aws_iam_policy_document を使用して動的に生成（推奨）
  #   - jsonencode() を使用して HCL から JSON に変換
  #   - 直接 JSON 文字列を記述
  # 
  # 参考: https://docs.aws.amazon.com/efs/latest/ug/access-control-overview.html#access-control-manage-access-intro-resource-policies
  policy = data.aws_iam_policy_document.example.json

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # bypass_policy_lockout_safety_check - (Optional) ポリシーロックアウト安全チェックのバイパス
  # 
  # ポリシーロックアウト安全チェックをバイパスするかどうかを指定します。
  # このチェックは、リクエストで指定されたポリシーが、リクエストを行っているプリンシパル自身を
  # 将来の PutFileSystemPolicy リクエストからロックアウトするかどうかを判定します。
  # 
  # デフォルト値: false
  # 
  # true を設定する場合:
  #   - リクエストを行っているプリンシパルが、以降このファイルシステムに対して
  #     PutFileSystemPolicy リクエストを行えなくなることを意図している場合のみ設定してください
  # 
  # 注意事項:
  #   - ポリシーが有効な間に IAM ユーザーやロールを削除・再作成すると、
  #     そのユーザー/ロールはファイルシステムからロックアウトされます
  #   - 誤って設定すると、ファイルシステムポリシーの変更ができなくなる可能性があります
  # 
  # 参考: https://docs.aws.amazon.com/efs/latest/ug/API_PutFileSystemPolicy.html
  bypass_policy_lockout_safety_check = false

  # region - (Optional) リソースを管理するリージョン
  # 
  # このリソースを管理する AWS リージョンを指定します。
  # 省略した場合は、プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # 
  # 使用例:
  #   - マルチリージョン構成で特定リージョンにリソースを明示的に配置する場合
  #   - プロバイダーのデフォルトリージョンとは異なるリージョンで管理する場合
  # 
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Attributes Reference
  #---------------------------------------------------------------
  # 以下の属性は computed 属性であり、リソース作成後に参照可能です:
  #
  # - id : ファイルシステムを識別する ID（例: fs-ccfc0d65）
  #---------------------------------------------------------------
}

#---------------------------------------------------------------
# Example: Complete EFS File System Policy Configuration
#---------------------------------------------------------------

# Example 1: Secure Transport Required Policy
# TLS 接続を強制し、読み取り・書き込みアクセスを許可するポリシー
/*
data "aws_iam_policy_document" "secure_transport" {
  statement {
    sid    = "RequireSecureTransport"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
    ]

    resources = [aws_efs_file_system.example.arn]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  }
}

resource "aws_efs_file_system_policy" "secure_transport" {
  file_system_id = aws_efs_file_system.example.id
  policy         = data.aws_iam_policy_document.secure_transport.json
}
*/

# Example 2: Read-Only Access for Specific Role
# 特定の IAM ロールに読み取り専用アクセスを許可するポリシー
/*
data "aws_iam_policy_document" "readonly" {
  statement {
    sid    = "ReadOnlyAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.example.arn]
    }

    actions = [
      "elasticfilesystem:ClientMount",
    ]

    resources = [aws_efs_file_system.example.arn]
  }
}

resource "aws_efs_file_system_policy" "readonly" {
  file_system_id = aws_efs_file_system.example.id
  policy         = data.aws_iam_policy_document.readonly.json
}
*/

# Example 3: Access via Access Point
# EFS Access Point 経由のアクセスのみを許可するポリシー
/*
data "aws_iam_policy_document" "access_point" {
  statement {
    sid    = "AccessViaAccessPoint"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.example.arn]
    }

    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
    ]

    resources = [aws_efs_file_system.example.arn]

    condition {
      test     = "StringEquals"
      variable = "elasticfilesystem:AccessPointArn"
      values   = [aws_efs_access_point.example.arn]
    }
  }
}

resource "aws_efs_file_system_policy" "access_point" {
  file_system_id = aws_efs_file_system.example.id
  policy         = data.aws_iam_policy_document.access_point.json
}
*/

# Example 4: IP-Based Access Control
# 特定の IP アドレスからのアクセスのみを許可するポリシー
/*
data "aws_iam_policy_document" "ip_restricted" {
  statement {
    sid    = "IPBasedAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
    ]

    resources = [aws_efs_file_system.example.arn]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["10.0.0.0/16"]
    }
  }
}

resource "aws_efs_file_system_policy" "ip_restricted" {
  file_system_id = aws_efs_file_system.example.id
  policy         = data.aws_iam_policy_document.ip_restricted.json
}
*/
