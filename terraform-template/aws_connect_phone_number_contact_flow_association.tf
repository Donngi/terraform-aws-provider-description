################################################################################
# Terraform Template: aws_connect_phone_number_contact_flow_association
################################################################################
# 生成日: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-19)の AWS Provider 6.28.0 仕様に基づいています
# - 最新の仕様や変更については、必ず公式ドキュメントをご確認ください
# - Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/connect_phone_number_contact_flow_association
################################################################################

################################################################################
# リソース概要
################################################################################
# aws_connect_phone_number_contact_flow_association は、Amazon Connect インスタンスに
# 要求された電話番号にフロー(コンタクトフロー)を関連付けるためのリソースです。
#
# このリソースを使用することで、特定の電話番号に着信があった際に、どのコンタクト
# フローを実行するかを定義できます。
#
# AWS公式ドキュメント:
# - AssociatePhoneNumberContactFlow API: https://docs.aws.amazon.com/connect/latest/APIReference/API_AssociatePhoneNumberContactFlow.html
# - 電話番号をフローに関連付ける: https://docs.aws.amazon.com/connect/latest/adminguide/associate-claimed-ported-phone-number-to-flow.html
################################################################################

resource "aws_connect_phone_number_contact_flow_association" "example" {
  ################################################################################
  # 必須パラメータ (Required Parameters)
  ################################################################################

  # contact_flow_id - (必須) コンタクトフローの識別子
  #
  # Amazon Connect インスタンス内のコンタクトフロー(IVR フロー)の一意の識別子です。
  # このフローは公開済み(published)である必要があります。
  #
  # 形式: UUID または ARN
  # 例: "12345678-1234-1234-1234-123456789012"
  #
  # 参考:
  # - 公開済みのフローのみがリストに表示されます
  # - aws_connect_contact_flow リソースの contact_flow_id 属性を参照可能
  contact_flow_id = "12345678-1234-1234-1234-123456789012"

  # instance_id - (必須) Amazon Connect インスタンス ID
  #
  # 電話番号とコンタクトフローが属する Amazon Connect インスタンスの一意の識別子です。
  #
  # 形式: UUID または ARN
  # 例: "aaaaaaaa-bbbb-cccc-dddd-111111111111"
  #
  # 参考:
  # - aws_connect_instance リソースの id 属性を参照可能
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"

  # phone_number_id - (必須) 電話番号 ID
  #
  # Amazon Connect インスタンスに要求(claim)された電話番号の一意の識別子です。
  #
  # 形式: UUID または完全な電話番号 ARN
  # 例: "cccccccc-dddd-eeee-ffff-222222222222"
  #
  # 注意事項:
  # - 電話番号がトラフィック配信グループに要求されている場合で、トラフィック配信
  #   グループと同じ AWS リージョンからリクエストを行う場合は、完全な電話番号 ARN
  #   または UUID 値を PhoneNumberId に使用できます
  # - 別の AWS リージョンからリクエストを行う場合は、完全な電話番号 ARN が必要です
  #
  # 参考:
  # - aws_connect_phone_number リソースの id 属性を参照可能
  phone_number_id = "cccccccc-dddd-eeee-ffff-222222222222"

  ################################################################################
  # オプションパラメータ (Optional Parameters)
  ################################################################################

  # region - (オプション) リソースが管理されるリージョン
  #
  # このリソースが管理される AWS リージョンを指定します。
  # 指定しない場合、プロバイダー設定で設定されたリージョンがデフォルトで使用されます。
  #
  # 形式: AWS リージョンコード
  # 例: "us-east-1", "ap-northeast-1"
  #
  # 参考:
  # - AWS リージョナルエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - プロバイダー設定: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # デフォルト: プロバイダー設定のリージョン
  # region = "us-east-1"
}

################################################################################
# 使用例 (Example Usage)
################################################################################
#
# 以下は、Amazon Connect の電話番号にコンタクトフローを関連付ける完全な例です:
#
# resource "aws_connect_instance" "example" {
#   identity_management_type = "CONNECT_MANAGED"
#   inbound_calls_enabled    = true
#   outbound_calls_enabled   = true
# }
#
# resource "aws_connect_contact_flow" "example" {
#   instance_id = aws_connect_instance.example.id
#   name        = "Example Contact Flow"
#   type        = "CONTACT_FLOW"
#   content     = jsonencode({
#     Version     = "2019-10-30"
#     StartAction = "12345678-1234-1234-1234-123456789012"
#     Actions = [
#       {
#         Identifier = "12345678-1234-1234-1234-123456789012"
#         Type       = "MessageParticipant"
#         Parameters = {
#           Text = "Hello, welcome to our contact center."
#         }
#         Transitions = {
#           NextAction = "aaaaaaaa-bbbb-cccc-dddd-111111111111"
#         }
#       },
#       {
#         Identifier = "aaaaaaaa-bbbb-cccc-dddd-111111111111"
#         Type       = "DisconnectParticipant"
#         Parameters = {}
#       }
#     ]
#   })
# }
#
# resource "aws_connect_phone_number" "example" {
#   country_code   = "US"
#   type           = "DID"
#   target_arn     = aws_connect_instance.example.arn
# }
#
# resource "aws_connect_phone_number_contact_flow_association" "example" {
#   phone_number_id = aws_connect_phone_number.example.id
#   instance_id     = aws_connect_instance.example.id
#   contact_flow_id = aws_connect_contact_flow.example.contact_flow_id
# }
#
################################################################################
