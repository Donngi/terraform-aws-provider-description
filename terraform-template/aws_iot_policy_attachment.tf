#---------------------------------------------------------------
# AWS IoT ポリシーアタッチメント
#---------------------------------------------------------------
#
# AWS IoT ポリシーをプリンシパル（証明書、Amazon Cognito ID、またはその他の
# AWS IoT リソース）にアタッチするリソースです。
# IoT ポリシーはデバイスが AWS IoT Core リソースに対して実行できる操作を
# 制御するアクセス許可を定義します。
#
# AWS公式ドキュメント:
#   - IoT ポリシー: https://docs.aws.amazon.com/iot/latest/developerguide/iot-policies.html
#   - ポリシーのアタッチ: https://docs.aws.amazon.com/iot/latest/developerguide/attach-policy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_policy_attachment" "example" {
  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: アタッチする IoT ポリシーの名前を指定します。
  # 設定可能な値: 既存の AWS IoT ポリシー名の文字列
  policy = "example-iot-policy"

  # target (Required)
  # 設定内容: ポリシーをアタッチするターゲット（プリンシパル）の ARN を指定します。
  # 設定可能な値: IoT 証明書の ARN、Amazon Cognito Identity の ARN、
  #              またはその他の AWS IoT プリンシパルの ARN
  # 注意: 証明書をターゲットとする場合は証明書の ARN を指定します。
  target = "arn:aws:iot:ap-northeast-1:123456789012:cert/example-certificate-id"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシーアタッチメントの識別子（policy と target の組み合わせ）
#---------------------------------------------------------------
