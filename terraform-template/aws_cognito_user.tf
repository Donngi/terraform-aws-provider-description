# ============================================================================
# Terraform Resource Template: aws_cognito_user
# ============================================================================
# Generated: 2026-01-19
# Provider: hashicorp/aws
# Provider Version: 6.28.0
#
# このテンプレートは生成時点での情報に基づいています。
# 最新の仕様については、必ず公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user
# ============================================================================

# aws_cognito_user
# Amazon Cognito User Pool内にユーザーを作成・管理するためのリソース
# 管理者によるユーザー作成、属性設定、一時パスワードの発行などをサポート
#
# 公式ドキュメント:
# - Terraform: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user
# - AWS API: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminCreateUser.html
# - User Attributes: https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-attributes.html

resource "aws_cognito_user" "example" {
  # ============================================================================
  # 必須パラメータ (Required)
  # ============================================================================

  # user_pool_id
  # 型: string (required)
  # ユーザーが作成されるUser PoolのID
  # User Pool作成後は変更できません
  # 参考: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools.html
  user_pool_id = aws_cognito_user_pool.example.id

  # username
  # 型: string (required)
  # ユーザー名（User Pool内で一意である必要あり）
  # UTF-8文字列で1〜128文字の範囲
  # ユーザー作成後は変更できません
  # 参考: https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-attributes.html
  username = "example_user"

  # ============================================================================
  # オプションパラメータ (Optional)
  # ============================================================================

  # attributes
  # 型: map(string) (optional)
  # ユーザーの属性と属性値を設定するマップ
  # 標準属性（email, phone_number等）とカスタム属性の両方を設定可能
  # カスタム属性は不変（immutable）の場合、ユーザー作成時のみ設定可能
  # 参考: https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-attributes.html
  attributes = {
    email          = "user@example.com"
    email_verified = "true"
    phone_number   = "+819012345678"
    # カスタム属性の例（User Poolのスキーマで定義されている必要あり）
    # custom:department = "engineering"
  }

  # client_metadata
  # 型: map(string) (optional)
  # ユーザー作成時にトリガーされるカスタムワークフロー用のカスタムキー値ペア
  # Lambda triggerがUser Poolに設定されていない場合、このパラメータは機能しません
  # Amazon Cognitoはこの値を保存しません（Lambdaトリガーでのみ利用可能）
  # 参考: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-identity-pools-working-with-aws-lambda-triggers.html
  client_metadata = {
    key1 = "value1"
    key2 = "value2"
  }

  # desired_delivery_mediums
  # 型: set(string) (optional)
  # ウェルカムメッセージの送信方法（EMAIL、SMS、またはその両方）
  # EMAILを指定する場合、attributes内でemailを指定する必要あり
  # SMSを指定する場合、attributes内でphone_numberを指定する必要あり
  # デフォルト: ["SMS"]
  # Amazon Cognitoはこの値を保存しません
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminCreateUser.html
  desired_delivery_mediums = ["EMAIL"]

  # enabled
  # 型: bool (optional)
  # ユーザー作成後に有効化するかどうかを指定
  # ウェルカムメッセージはこの設定に関わらず送信されます（message_actionで制御可能）
  # デフォルト: true
  enabled = true

  # force_alias_creation
  # 型: bool (optional)
  # trueに設定し、attributes内のphone_numberまたはemailが既に別ユーザーのエイリアスとして
  # 存在する場合、Amazon Cognitoはそのエイリアスを新しく作成されたユーザーに移行します
  # 以前のユーザーはそのエイリアスを使用してログインできなくなります
  # デフォルト: false
  # Amazon Cognitoはこの値を保存しません
  force_alias_creation = false

  # id
  # 型: string (optional, computed)
  # リソースのID（通常は自動生成されるため明示的な設定は不要）
  # フォーマット: user_pool_id/username
  # id = "computed_automatically"

  # message_action
  # 型: string (optional)
  # メッセージ送信の動作を制御
  # - "RESEND": 既存ユーザーへの招待メッセージを再送信し、有効期限をリセット
  # - "SUPPRESS": メッセージ送信を抑制
  # Amazon Cognitoはこの値を保存しません
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminCreateUser.html
  message_action = "SUPPRESS"

  # password
  # 型: string (optional, sensitive)
  # ユーザーの永続パスワード
  # User Poolのパスワードポリシーに準拠する必要があります
  # ウェルカムメッセージには常にtemporary_passwordのみが含まれます
  # message_actionでメッセージ送信を抑制可能
  # Amazon Cognitoはこの値を保存しません
  # temporary_passwordと競合します（どちらか一方のみ指定可能）
  # 注: このパラメータをクリアしてもCognito内のユーザーパスワードはリセットされません
  # password = "SecurePassword123!"

  # region
  # 型: string (optional, computed)
  # このリソースが管理されるリージョン
  # デフォルトはプロバイダー設定で指定されたリージョン
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # temporary_password
  # 型: string (optional, sensitive)
  # ユーザーの一時パスワード
  # ユーザーは初回サインイン時にこのパスワードを変更する必要があります（FORCE_CHANGE_PASSWORD状態）
  # passwordと競合します（どちらか一方のみ指定可能）
  # 注: このパラメータをクリアしてもCognito内のユーザーパスワードはリセットされません
  temporary_password = "TempPassword123!"

  # validation_data
  # 型: map(string) (optional)
  # カスタムバリデーション用のユーザー属性と属性値の配列
  # 登録可能なユーザーアカウントの種類を制限するなどの用途で使用
  # Amazon Cognitoはこの値を保存しません
  # 参考: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-identity-pools-working-with-aws-lambda-triggers.html
  validation_data = {
    validation_key1 = "validation_value1"
  }

  # ============================================================================
  # Computed属性（読み取り専用）
  # ============================================================================
  # 以下の属性はTerraformによって自動的に計算され、設定できません:
  #
  # - creation_date: ユーザー作成日時（RFC3339形式）
  # - last_modified_date: ユーザー最終更新日時（RFC3339形式）
  # - mfa_setting_list: ユーザーのMFA設定一覧
  # - preferred_mfa_setting: ユーザーの優先MFA設定
  # - status: ユーザーの現在のステータス（FORCE_CHANGE_PASSWORD、CONFIRMED等）
  # - sub: 一意のユーザーID（再割り当て不可）
  # ============================================================================
}
