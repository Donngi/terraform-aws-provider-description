#---------------------------------------------------------------
# Amazon GuardDuty Invite Accepter
#---------------------------------------------------------------
#
# GuardDutyのメンバーアカウント側で使用するリソース。
# 管理アカウント（Administrator Account）からの招待を受け入れ、
# GuardDutyのマルチアカウント管理構成に参加する。
#
# このリソースは以下の動作を行います：
# - 作成時：保留中の招待を受け入れ
# - 読み取り時：Detectorが正しいプライマリアカウントを持つことを確認
# - 削除時：プライマリアカウントとの関連付けを解除
#
# 注意：GuardDutyではAWS Organizationsによる管理を推奨していますが、
# 招待ベースの管理方法が必要な場合にこのリソースを使用します。
#
# AWS公式ドキュメント:
#   - Managing GuardDuty accounts by invitation:
#     https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_invitations.html
#   - AcceptAdministratorInvitation API:
#     https://docs.aws.amazon.com/guardduty/latest/APIReference/API_AcceptAdministratorInvitation.html
#   - Administrator and member account relationships:
#     https://docs.aws.amazon.com/guardduty/latest/ug/administrator_member_relationships.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_invite_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_invite_accepter" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # メンバーアカウント側のGuardDuty Detector ID
  # メンバーアカウント（招待を受ける側）で有効化されたGuardDuty DetectorのID
  # GuardDutyコンソールまたはListDetectors APIで確認可能
  # 例: "12abc34d567e8fa901bc2d34e56789f0"
  detector_id = "your-member-detector-id"

  # 管理アカウント（Administrator Account）のAWSアカウントID
  # 招待を送信した管理アカウントのAWSアカウントID（12桁の数字）
  # この管理アカウントからの招待が事前に送信されている必要がある
  # 例: "123456789012"
  master_account_id = "123456789012"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # リソースID
  # (Optional) 通常は指定不要。Terraformが自動的にdetector_idを使用してIDを生成
  #
  # このリソースの一意の識別子を明示的に指定したい場合に使用
  # 未指定の場合、detector_idと同じ値が自動的に使用される
  #
  # id = "custom-resource-id"

  # このリソースを管理するAWSリージョン
  # (Optional) デフォルトはプロバイダー設定で指定されたリージョン
  #
  # GuardDutyはリージョナルサービスのため、各リージョンで個別に設定が必要
  # マルチリージョン構成の場合、各リージョンでこのリソースを作成する
  #
  # 例: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Timeouts Configuration
  #---------------------------------------------------------------

  # リソース作成時のタイムアウト設定
  # (Optional) デフォルトは適切な値が自動設定される
  #
  # 招待の受け入れ処理は通常数秒で完了するが、
  # ネットワーク遅延や一時的なサービス遅延に対応するため設定可能
  #
  # timeouts {
  #   create = "5m"  # 作成タイムアウト（例: "5m", "10m"）
  # }

  #---------------------------------------------------------------
  # Dependencies and Lifecycle
  #---------------------------------------------------------------

  # このリソースは以下に依存する必要があります：
  # 1. メンバーアカウント側でaws_guardduty_detectorが有効化されていること
  # 2. 管理アカウント側でaws_guardduty_memberリソースが作成され、
  #    invite = trueで招待が送信されていること
  #
  # 推奨される依存関係の設定例：
  # depends_on = [aws_guardduty_member.example]
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします：
#
# - id
#     リソースのID（通常はdetector_idと同じ値）
#     Computed属性（Terraformが自動生成）
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例：マルチアカウント構成
#---------------------------------------------------------------
#
# 管理アカウントとメンバーアカウントで異なるプロバイダーエイリアスを使用する例：
#
# provider "aws" {
#   alias = "administrator"
# }
#
# provider "aws" {
#   alias = "member"
# }
#
# # 管理アカウント側：Detector作成
# resource "aws_guardduty_detector" "administrator" {
#   provider = aws.administrator
#   enable   = true
# }
#
# # メンバーアカウント側：Detector作成
# resource "aws_guardduty_detector" "member" {
#   provider = aws.member
#   enable   = true
# }
#
# # 管理アカウント側：メンバーを追加して招待
# resource "aws_guardduty_member" "member" {
#   provider    = aws.administrator
#   account_id  = aws_guardduty_detector.member.account_id
#   detector_id = aws_guardduty_detector.administrator.id
#   email       = "security-team@example.com"
#   invite      = true  # 招待を送信
# }
#
# # メンバーアカウント側：招待を受け入れ
# resource "aws_guardduty_invite_accepter" "member" {
#   provider = aws.member
#
#   detector_id       = aws_guardduty_detector.member.id
#   master_account_id = aws_guardduty_detector.administrator.account_id
#
#   depends_on = [aws_guardduty_member.member]
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
#
# 1. 招待の事前送信が必須
#    - このリソースを作成する前に、管理アカウント側から
#      aws_guardduty_memberリソースでinvite = trueを設定し、
#      招待を送信しておく必要があります
#
# 2. リージョナルサービス
#    - GuardDutyはリージョンごとに独立したサービス
#    - マルチリージョン構成の場合、各リージョンで個別に設定が必要
#
# 3. 招待の管理方法
#    - GuardDutyでは、AWS Organizationsを使用した管理を推奨
#    - 招待ベースの方法は、Organizationsが使用できない場合や
#      異なる組織間でアカウントを関連付ける必要がある場合に使用
#
# 4. 関連付けの解除
#    - このリソースを削除すると、メンバーアカウントは管理アカウントから
#      自動的に関連付けが解除される
#    - 再度関連付けるには、新たに招待プロセスが必要
#
# 5. 既存の関連付け
#    - メンバーアカウントは、同時に1つの管理アカウントとのみ
#      関連付けできる
#    - 別の管理アカウントの招待を受け入れる場合、先に既存の
#      関連付けを解除する必要がある
#
# 6. クロスリージョンのデータ転送
#    - 招待のメール検証サービスがUS East (N. Virginia)リージョンでのみ
#      動作するため、クロスリージョンのデータ転送が発生する可能性がある
#
#---------------------------------------------------------------
