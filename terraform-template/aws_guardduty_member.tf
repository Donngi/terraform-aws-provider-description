#---------------------------------------------------------------
# GuardDuty Member Account
#---------------------------------------------------------------
#
# GuardDutyのメンバーアカウントを管理するリソース。
# 管理者アカウントが他のAWSアカウントをGuardDutyメンバーとして
# 招待・管理する際に使用します。
#
# 注意: メンバーアカウント側で招待を承諾する場合は、
#       aws_guardduty_invite_accepter リソースを使用してください。
#
# AWS公式ドキュメント:
#   - Managing GuardDuty accounts by invitation:
#     https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_invitations.html
#   - Adding accounts by invitation:
#     https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_become_console.html
#   - InviteMembers API Reference:
#     https://docs.aws.amazon.com/guardduty/latest/APIReference/API_InviteMembers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_member
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_member" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # メンバーアカウントのAWSアカウントID
  # GuardDutyに追加したいAWSアカウントの12桁のIDを指定します。
  account_id = "123456789012"

  # GuardDuty検出器のID
  # メンバーアカウントを作成する管理者アカウント側のGuardDuty検出器IDを指定します。
  # 通常は aws_guardduty_detector リソースの id 属性を参照します。
  detector_id = "00b00fd5aecc0ab60a708659477e9617"

  # メンバーアカウントのメールアドレス
  # 招待通知やアカウント管理に使用されるメールアドレスを指定します。
  # 招待を送信する場合は有効なメールアドレスが必要です。
  email = "member-account@example.com"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # アカウントをGuardDutyメンバーとして招待するかどうか
  # true: 招待を送信します
  # false: 招待を送信しません（デフォルト）
  #
  # relationship_statusが以下の場合に招待の送信が必要と判断されます:
  # - Disabled
  # - Enabled
  # - Invited
  # - EmailVerificationInProgress
  # invite = true

  # 招待メッセージ
  # メンバーアカウントへの招待時に含めるカスタムメッセージを指定します。
  # invite = true の場合にのみ有効です。
  # invitation_message = "Please accept this GuardDuty invitation to join our security monitoring."

  # メール通知を無効化するかどうか
  # true: メール通知を送信しません
  # false: メール通知を送信します（デフォルト）
  #
  # 注意: 招待メールは米国東部（バージニア北部）リージョンの
  #       メール検証サービスを経由するため、リージョン間の
  #       データ転送が発生する可能性があります。
  # disable_email_notification = false

  # リソースを管理するAWSリージョン
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  # GuardDutyはリージョナルサービスのため、各リージョンで個別に設定が必要です。
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------

  # タイムアウト設定
  # リソースの作成・更新操作のタイムアウト時間を指定します。
  timeouts {
    # 作成操作のタイムアウト（デフォルト: 60秒）
    # create = "60s"

    # 更新操作のタイムアウト（デフォルト: 60秒）
    # update = "60s"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - id
#     リソースのID（Terraformによって自動生成）
#     形式: {detector_id}:{account_id}
#
# - relationship_status
#     管理者アカウントとメンバーアカウント間の関係ステータス
#     可能な値:
#     - Created: メンバーアカウントが作成されたが、まだ招待されていない
#     - Invited: 招待が送信され、承諾待ち
#     - Disabled: 関係が無効化されている
#     - Enabled: メンバーアカウントが有効で、GuardDutyが稼働中
#     - Removed: メンバーアカウントが削除された
#     - Resigned: メンバーアカウントが関係を解除した
#     - EmailVerificationInProgress: メール検証が進行中
#     - EmailVerificationFailed: メール検証が失敗
#
#     詳細: https://docs.aws.amazon.com/guardduty/latest/ug/get-members.html
#
# - region
#     リソースが管理されているAWSリージョン
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Usage Notes
#---------------------------------------------------------------
#
# 1. 招待ベースの管理について
#    - AWS Organizationsを使用した管理が推奨されています
#    - 招待ベースの場合、メンバーアカウントで明示的に招待を承諾する必要があります
#    - 招待を承諾するには aws_guardduty_invite_accepter リソースを使用します
#
# 2. メンバーアカウントの要件
#    - メンバーアカウント側でGuardDutyが有効化されている必要があります
#    - 各アカウントは1つの管理者アカウントからの招待のみ承諾できます
#
# 3. アカウントの削除と再招待
#    - 関連付けを解除したアカウントの情報は保持されます
#    - 同じアカウントを再招待する場合、CreateMembers APIの再実行は不要です
#    - メンバーアカウントの詳細情報を完全に削除するには DeleteMembers APIを使用します
#
# 4. リージョン考慮事項
#    - GuardDutyはリージョナルサービスです
#    - 複数リージョンで管理する場合は、各リージョンで個別に設定が必要です
#
# 5. データ転送
#    - メール検証サービスは米国東部（バージニア北部）リージョンでのみ動作します
#    - 他リージョンで招待を送信する場合、リージョン間データ転送が発生する可能性があります
#
#---------------------------------------------------------------
