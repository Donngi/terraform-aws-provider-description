# ==============================================================================
# AWS DataZone User Profile - Annotated Template
# ==============================================================================
# Generated: 2026-01-22
# Provider Version: 6.28.0
#
# このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datazone_user_profile
# ==============================================================================

resource "aws_datazone_user_profile" "example" {
  # ------------------------------------------------------------------------------
  # 必須パラメータ (Required Parameters)
  # ------------------------------------------------------------------------------

  # Amazon DataZone ドメインの識別子
  # パターン: dzd[-_][a-zA-Z0-9_-]{1,36}
  # 関連リソース: aws_datazone_domain
  # 参考: https://docs.aws.amazon.com/datazone/latest/userguide/user-management-console.html
  domain_identifier = "dzd_example123456"

  # ユーザーの識別子
  # - IAM ユーザーの場合: IAM ユーザーまたはロールの ARN を指定
  #   例: "arn:aws:iam::123456789012:user/example-user"
  #   例: "arn:aws:iam::123456789012:role/example-role"
  # - SSO ユーザーの場合: AWS IAM Identity Center のユーザー ID を指定
  #   例: "906769c8-1234-5678-9abc-def012345678"
  # 参考: https://docs.aws.amazon.com/datazone/latest/APIReference/API_GetUserProfile.html
  user_identifier = "arn:aws:iam::123456789012:user/example-user"

  # ------------------------------------------------------------------------------
  # オプションパラメータ (Optional Parameters)
  # ------------------------------------------------------------------------------

  # リージョンの指定
  # このリソースが管理されるリージョンを指定します。
  # 省略した場合は、プロバイダー設定のリージョンが使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ユーザープロファイルのステータス
  # 有効な値:
  # - "ASSIGNED"     : ユーザーが Amazon DataZone の使用に割り当てられている
  # - "NOT_ASSIGNED" : ユーザーが Amazon DataZone の使用から割り当て解除されている
  # - "ACTIVATED"    : ユーザーが API 呼び出し、CLI コマンド発行、または
  #                    Amazon DataZone ポータルへのアクセスを行った
  # - "DEACTIVATED"  : ユーザーが Amazon DataZone データポータルを使用できない
  #
  # 注意:
  # - IAM ユーザーの場合、ステータスは手動で設定できます
  # - SSO ユーザーの場合、初回アクセス時に自動的に "ACTIVATED" になります
  # - "DEACTIVATED" に設定すると、ユーザーはデータポータルにアクセスできなくなります
  #   プログラマティックアクセスを制限するには別途 IAM ポリシーが必要です
  # 参考: https://docs.aws.amazon.com/datazone/latest/userguide/user-management-console.html
  # status = "ASSIGNED"

  # ユーザーのタイプ
  # 有効な値:
  # - "IAM" : AWS Identity and Access Management (IAM) ユーザーまたはロール
  #           IAM ユーザーは AWS アカウント内で作成され、IAM ポリシーを通じて
  #           Amazon DataZone ドメインへのアクセス権限を取得します
  # - "SSO" : AWS IAM Identity Center (旧 AWS SSO) のユーザー
  #           外部 ID プロバイダーと同期され、シングルサインオンでアクセスします
  #
  # 注意:
  # - user_identifier に指定する値は、このタイプに応じて異なります
  # - IAM の場合: IAM ユーザーまたはロールの ARN
  # - SSO の場合: IAM Identity Center のユーザー ID
  # - 明示的に指定しない場合、Terraform が user_identifier から自動推測します
  # 参考: https://docs.aws.amazon.com/datazone/latest/APIReference/API_UserProfileSummary.html
  # user_type = "IAM"

  # ------------------------------------------------------------------------------
  # タイムアウト設定 (Timeouts)
  # ------------------------------------------------------------------------------

  # リソース作成・更新時のタイムアウト設定
  # データプレーンの処理に時間がかかる場合に調整します
  # 参考: https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts
  timeouts {
    # 作成時のタイムアウト
    # デフォルト: 標準タイムアウト
    # 形式: "30s"（秒）、"2h45m"（時間・分）など
    # create = "30m"

    # 更新時のタイムアウト
    # デフォルト: 標準タイムアウト
    # 形式: "30s"（秒）、"2h45m"（時間・分）など
    # update = "30m"
  }
}

# ==============================================================================
# Computed Attributes (読み取り専用の出力属性)
# ==============================================================================
# これらの属性はリソース作成後に参照可能ですが、設定することはできません。
#
# - id
#   ユーザープロファイルの識別子
#   パターン: ([0-9a-f]{10}-|)[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}
#   参照方法: aws_datazone_user_profile.example.id
#
# - type
#   ユーザープロファイルのタイプ（"IAM" または "SSO"）
#   user_type パラメータで設定した値、または自動推測された値が返されます
#   参照方法: aws_datazone_user_profile.example.type
#
# - details
#   ユーザープロファイルの詳細情報
#   Union 型のオブジェクトで、iam または sso のいずれか一方のみが含まれます
#
#   IAM ユーザーの場合:
#     details.iam.arn - IAM ユーザーまたはロールの ARN
#
#   SSO ユーザーの場合:
#     details.sso.first_name - SSO ユーザーの名
#     details.sso.last_name  - SSO ユーザーの姓
#     details.sso.user_name  - SSO ユーザーのユーザー名
#
#   参照方法:
#     aws_datazone_user_profile.example.details
#     aws_datazone_user_profile.example.details[0].iam[0].arn
#     aws_datazone_user_profile.example.details[0].sso[0].user_name
#
#   参考: https://docs.aws.amazon.com/datazone/latest/APIReference/API_UserProfileDetails.html
# ==============================================================================

# ==============================================================================
# 使用例
# ==============================================================================

# Example 1: IAM ユーザーのプロファイル作成
resource "aws_datazone_user_profile" "iam_user_example" {
  domain_identifier = aws_datazone_domain.example.id
  user_identifier   = aws_iam_user.data_analyst.arn
  user_type         = "IAM"
  status            = "ASSIGNED"
}

# Example 2: IAM ロールのプロファイル作成
resource "aws_datazone_user_profile" "iam_role_example" {
  domain_identifier = aws_datazone_domain.example.id
  user_identifier   = aws_iam_role.data_engineer.arn
  user_type         = "IAM"
  status            = "ACTIVATED"
}

# Example 3: SSO ユーザーのプロファイル作成
# 注: SSO ユーザーの場合、user_identifier は IAM Identity Center のユーザー ID
resource "aws_datazone_user_profile" "sso_user_example" {
  domain_identifier = aws_datazone_domain.example.id
  user_identifier   = "906769c8-1234-5678-9abc-def012345678"
  user_type         = "SSO"

  # SSO ユーザーは初回ポータルアクセス時に自動的に ACTIVATED になるため
  # 通常は status を明示的に設定する必要はありません
}

# Example 4: 特定リージョンでのプロファイル作成
resource "aws_datazone_user_profile" "regional_example" {
  domain_identifier = aws_datazone_domain.example.id
  user_identifier   = aws_iam_user.regional_user.arn
  user_type         = "IAM"
  region            = "eu-west-1"
}

# ==============================================================================
# 関連リソース
# ==============================================================================
# - aws_datazone_domain           : DataZone ドメインの作成
# - aws_datazone_project          : DataZone プロジェクトの作成
# - aws_iam_user                  : IAM ユーザーの作成
# - aws_iam_role                  : IAM ロールの作成
# - aws_identitystore_user        : IAM Identity Center ユーザーの管理
#
# 参考ドキュメント:
# - Terraform Provider AWS: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datazone_user_profile
# - AWS DataZone User Management: https://docs.aws.amazon.com/datazone/latest/userguide/user-management-console.html
# - AWS DataZone API Reference: https://docs.aws.amazon.com/datazone/latest/APIReference/API_GetUserProfile.html
# ==============================================================================
