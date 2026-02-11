#---------------------------------------------------------------
# IAM Identity Center Permission Set Inline Policy
#---------------------------------------------------------------
#
# IAM Identity Center（旧AWS SSO）の権限セットにインラインポリシーを
# アタッチするリソースです。権限セットは、AWSアカウント間でユーザーに
# 付与する権限のテンプレートとして機能し、インラインポリシーによって
# カスタムのIAM権限を定義できます。
#
# AWS公式ドキュメント:
#   - PutInlinePolicyToPermissionSet API: https://docs.aws.amazon.com/singlesignon/latest/APIReference/API_PutInlinePolicyToPermissionSet.html
#   - カスタム権限の設定: https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetcustom.html
#   - 権限セットの概念: https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetsconcept.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_permission_set_inline_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # inline_policy (Required)
  # 設定内容: 権限セットにアタッチするIAMインラインポリシーをJSON形式で指定します。
  # 設定可能な値: IAMポリシードキュメント（JSON形式の文字列）
  #   - 最小長: 1文字
  #   - 最大長: 32,768文字
  # 関連機能: IAM Identity Center インラインポリシー
  #   権限セットに直接追加されるIAMポリシー。AWS管理ポリシーやカスタマー管理
  #   ポリシーとは異なり、権限セット内に埋め込まれます。1つの権限セットに対して
  #   1つのインラインポリシーのみアタッチ可能です。
  #   - https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetcustom.html
  # 注意:
  #   - jsonencode()関数またはaws_iam_policy_documentデータソースの使用を推奨
  #   - 権限セットが既にアカウント割り当てで参照されている場合、このアクションの後に
  #     ProvisionPermissionSetを呼び出して、対応するIAMポリシー更新を全ての
  #     割り当てられたアカウントに適用する必要があります
  # 参考: https://docs.aws.amazon.com/singlesignon/latest/APIReference/API_PutInlinePolicyToPermissionSet.html
  inline_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ExamplePermission"
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation",
        ]
        Resource = "*"
      }
    ]
  })

  # instance_arn (Required, Forces new resource)
  # 設定内容: IAM Identity Centerインスタンスのアマゾンリソースネーム (ARN) を指定します。
  # 設定可能な値: IAM Identity CenterインスタンスのARN
  #   - 形式: arn:aws(-[a-z]{1,5}){0,3}:sso:::instance/(sso)?ins-[a-zA-Z0-9-.]{16}
  #   - 最小長: 10文字
  #   - 最大長: 1,224文字
  # 関連機能: IAM Identity Center インスタンス
  #   操作が実行されるIAM Identity Centerインスタンス。アカウントごとに1つの
  #   インスタンスが存在します。
  #   - https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html
  # 注意: この値を変更すると、リソースが強制的に再作成されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html
  instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef"

  # permission_set_arn (Required, Forces new resource)
  # 設定内容: インラインポリシーをアタッチする権限セットのARNを指定します。
  # 設定可能な値: 権限セットのARN
  #   - 形式: arn:aws(-[a-z]{1,5}){0,3}:sso:::permissionSet/(sso)?ins-[a-zA-Z0-9-.]{16}/ps-[a-zA-Z0-9-./]{16}
  #   - 最小長: 10文字
  #   - 最大長: 1,224文字
  # 関連機能: IAM Identity Center 権限セット
  #   ユーザーまたはグループに付与する権限の集合を定義するテンプレート。
  #   複数のAWSアカウントにわたって一貫した権限を付与できます。
  #   - https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetsconcept.html
  # 注意: この値を変更すると、リソースが強制的に再作成されます
  # 参考: https://docs.aws.amazon.com/singlesignon/latest/APIReference/API_PermissionSet.html
  permission_set_arn = "arn:aws:sso:::permissionSet/ssoins-1234567890abcdef/ps-1234567890abcdef"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 設定可能な値:
  #   - create: リソース作成時のタイムアウト（例: "10m"）
  #   - delete: リソース削除時のタイムアウト（例: "10m"）
  # 省略時: Terraformのデフォルトタイムアウトを使用
  # 参考: https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts
  timeouts {
    create = "10m"
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 権限セットとSSOインスタンスのAmazon Resource Names (ARNs)。
#       カンマ (`,`) で区切られます。
#---------------------------------------------------------------
