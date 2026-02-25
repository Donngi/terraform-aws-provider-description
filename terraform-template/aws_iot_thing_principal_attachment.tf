#---------------------------------------------------------------
# AWS IoT Thing プリンシパルアタッチメント
#---------------------------------------------------------------
#
# AWS IoT Thing にプリンシパル（X.509 証明書または Amazon Cognito Identity）を
# アタッチするリソースです。Thing とプリンシパルを関連付けることで、
# デバイス認証と Thing のアクセス制御を組み合わせて管理できます。
#
# AWS公式ドキュメント:
#   - IoT Thing プリンシパル: https://docs.aws.amazon.com/iot/latest/developerguide/thing-registry.html
#   - プリンシパルのアタッチ: https://docs.aws.amazon.com/iot/latest/developerguide/attach-cert-thing.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_thing_principal_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_thing_principal_attachment" "example" {
  #-------------------------------------------------------------
  # Thing 設定
  #-------------------------------------------------------------

  # thing (Required)
  # 設定内容: プリンシパルをアタッチする IoT Thing の名前を指定します。
  # 設定可能な値: 既存の AWS IoT Thing 名の文字列
  thing = "example-iot-thing"

  #-------------------------------------------------------------
  # プリンシパル設定
  #-------------------------------------------------------------

  # principal (Required)
  # 設定内容: Thing にアタッチするプリンシパルの ARN を指定します。
  # 設定可能な値: X.509 証明書の ARN（arn:aws:iot:region:account-id:cert/certificate-id）、
  #              または Amazon Cognito Identity の ARN
  # 注意: プリンシパルは事前に AWS IoT Core に登録されている必要があります。
  principal = "arn:aws:iot:ap-northeast-1:123456789012:cert/example-certificate-id"

  # thing_principal_type (Optional)
  # 設定内容: Thing にアタッチするプリンシパルの種別を指定します。
  # 設定可能な値: "EXCLUSIVE_THING"（排他的アタッチメント）などの種別文字列
  # 省略時: デフォルトの種別が自動的に設定されます。
  thing_principal_type = null

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
# - id: Thing プリンシパルアタッチメントの識別子（thing と principal の組み合わせ）
#---------------------------------------------------------------
