# ================================================================================
# Terraform Template: aws_chime_voice_connector_termination
# ================================================================================
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# NOTE: このテンプレートは生成時点(2026-01-18)の情報です。
#       最新の仕様については公式ドキュメントをご確認ください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chime_voice_connector_termination
# ================================================================================

# Amazon Chime Voice Connector Termination
# Enable Termination settings to control outbound calling from your SIP infrastructure.
#
# 関連ドキュメント:
# - Resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chime_voice_connector_termination
# - API Reference: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_PutVoiceConnectorTermination.html
# - User Guide: https://docs.aws.amazon.com/chime-sdk/latest/ag/edit-voicecon.html

resource "aws_chime_voice_connector_termination" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # voice_connector_id - (Required) The Amazon Chime Voice Connector ID.
  # このターミネーション設定を適用するVoice ConnectorのID。
  # Type: string
  voice_connector_id = "abcdef1ghij2klmno3pqr4"

  # cidr_allow_list - (Required) The IP addresses allowed to make calls, in CIDR format.
  # アウトバウンドコールを許可するIPアドレスのリスト（CIDR形式）。
  # SIPインフラストラクチャからの発信を制御するために使用。
  # 例: ["50.35.78.96/31", "203.0.113.0/24"]
  # Type: set(string)
  # Reference: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_Termination.html
  cidr_allow_list = ["50.35.78.96/31"]

  # calling_regions - (Required) The countries to which calls are allowed, in ISO 3166-1 alpha-2 format.
  # 発信を許可する国のリスト（ISO 3166-1 alpha-2形式）。
  # 例: ["US", "CA", "GB", "JP"]
  # Amazon Chime SDKは国際発信に制限があるため、必要な国を明示的に指定。
  # Type: set(string)
  # Reference: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_Termination.html
  calling_regions = ["US", "CA"]

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # disabled - (Optional) When termination settings are disabled, outbound calls can not be made.
  # ターミネーション設定を無効化するかどうか。
  # trueに設定すると、アウトバウンドコールができなくなる。
  # デフォルト: false
  # Type: bool
  # Reference: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_Termination.html
  disabled = false

  # cps_limit - (Optional) The limit on calls per second. Max value based on account service quota. Default value of `1`.
  # 1秒あたりの最大コール数（CPS: Calls Per Second）。
  # アカウントのサービスクォータに基づいて最大値が決定される。
  # デフォルト: 1
  # Type: number
  # Reference: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_Termination.html
  cps_limit = 1

  # default_phone_number - (Optional) The default caller ID phone number.
  # デフォルトの発信者番号（Caller ID）。
  # E.164形式（例: +12065551212）で指定。
  # パターン: +?[1-9]\\d{1,14}
  # Type: string
  # Reference: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_Termination.html
  default_phone_number = "+12065551212"

  # id - (Optional) Terraform resource identifier.
  # Terraformリソース識別子。通常は自動生成されるため指定不要。
  # Type: string (computed)
  # id = "abcdef1ghij2klmno3pqr4"

  # region - (Optional) Region where this resource will be managed.
  # このリソースが管理されるAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用される。
  # Type: string (computed)
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

# ================================================================================
# Outputs (参考)
# ================================================================================

# output "termination_id" {
#   description = "The Amazon Chime Voice Connector ID"
#   value       = aws_chime_voice_connector_termination.example.id
# }
