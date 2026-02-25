#---------------------------------------------------------------
# Amazon GuardDuty メンバーアカウント
#---------------------------------------------------------------
#
# Amazon GuardDutyの管理者アカウントにメンバーアカウントを追加し、
# 招待を送信・管理するリソースです。
# メンバーアカウントへの招待受諾は aws_guardduty_invite_accepter リソースを使用します。
#
# AWS公式ドキュメント:
#   - GuardDuty マルチアカウント管理: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_accounts.html
#   - 招待によるアカウント管理: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_invitations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_member
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_member" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # detector_id (Required)
  # 設定内容: メンバーアカウントを追加するGuardDuty管理者アカウントのディテクターIDを指定します。
  # 設定可能な値: 有効なGuardDutyディテクターIDの文字列
  detector_id = "abc123def456"

  # account_id (Required)
  # 設定内容: メンバーとして追加するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  account_id = "123456789012"

  # email (Required)
  # 設定内容: メンバーアカウントに関連付けられたメールアドレスを指定します。
  # 設定可能な値: 有効なメールアドレス文字列
  email = "member@example.com"

  #-------------------------------------------------------------
  # 招待設定
  #-------------------------------------------------------------

  # invite (Optional)
  # 設定内容: GuardDutyメンバーとしてアカウントへ招待を送信するかを指定します。
  # 設定可能な値:
  #   - true: 招待を送信する
  #   - false (デフォルト): 招待を送信しない
  # 省略時: false
  # 注意: relationship_status が Disabled、Enabled、Invited、EmailVerificationInProgress
  #       のいずれかの場合、Terraform stateの値は true となります。
  #       招待の再送信が必要かどうかはこのstatusで判断されます。
  invite = true

  # invitation_message (Optional)
  # 設定内容: 招待に添付するメッセージ文字列を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: メッセージなしで招待を送信します。
  invitation_message = "GuardDutyへの参加招待です。承認をお願いします。"

  # disable_email_notification (Optional)
  # 設定内容: 招待送信時にメンバーアカウントへメール通知を送信しないかを指定します。
  # 設定可能な値:
  #   - true: メール通知を送信しない
  #   - false (デフォルト): メール通知を送信する
  # 省略時: false
  disable_email_notification = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのduration形式の文字列（例: "60s", "10m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    create = "60s"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: Goのduration形式の文字列（例: "60s", "10m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    update = "60s"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - relationship_status: メンバーアカウントと管理者アカウントの関係ステータス。
#                        詳細は Amazon GuardDuty API リファレンスを参照してください。
#                        https://docs.aws.amazon.com/guardduty/latest/ug/get-members.html
#---------------------------------------------------------------
