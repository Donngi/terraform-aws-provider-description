#---------------------------------------------------------------
# AWS SESv2 Account Suppression Attributes
#---------------------------------------------------------------
#
# Amazon SES (Simple Email Service) v2のアカウントレベルのサプレッションリスト設定を
# 管理するリソースです。サプレッションリストは、バウンスやクレームなどの理由で
# メール送信を抑制するメールアドレスを管理します。このリソースでは、
# どの理由でアドレスをサプレッションリストに追加するかを制御します。
#
# AWS公式ドキュメント:
#   - サプレッションリストの使用: https://docs.aws.amazon.com/ses/latest/dg/sending-email-suppression-list.html
#   - PutAccountSuppressionAttributes API: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_PutAccountSuppressionAttributes.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_account_suppression_attributes
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sesv2_account_suppression_attributes" "example" {
  #-------------------------------------------------------------
  # サプレッションリスト設定
  #-------------------------------------------------------------

  # suppressed_reasons (Required)
  # 設定内容: アカウントレベルのサプレッションリストにメールアドレスを追加する理由を指定します。
  # 設定可能な値:
  #   - "BOUNCE": ハードバウンスが発生したメールアドレスを自動的にサプレッションリストへ追加します。
  #   - "COMPLAINT": 受信者がスパム報告（クレーム）を行ったメールアドレスを自動的にサプレッションリストへ追加します。
  # 省略時: サプレッションリストへの自動追加は行われません（空セット相当）。
  # 注意: 空のセットを指定するとサプレッション機能が無効化されます。
  #       BOUNCEとCOMPLAINTの両方を指定することで、バウンスとクレームの両方を対象にできます。
  suppressed_reasons = ["BOUNCE", "COMPLAINT"]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アカウントサプレッション属性の識別子（Terraform内部管理用）
#---------------------------------------------------------------
