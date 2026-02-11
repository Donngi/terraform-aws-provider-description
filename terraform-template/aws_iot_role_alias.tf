#---------------------------------------------------------------
# AWS IoT Role Alias
#---------------------------------------------------------------
#
# AWS IoT Role Aliasリソースをプロビジョニングします。
# Role Aliasは、IoTデバイスがX.509証明書を使用してAWS認証情報を取得するための
# IAMロールへのエイリアスを提供します。デバイスはこのエイリアスを通じて
# 一時的な認証情報（アクセスキー、シークレットキー、セッショントークン）を
# 取得し、他のAWSサービスへの直接呼び出しを実行できます。
#
# AWS公式ドキュメント:
#   - Authorizing direct calls to AWS services: https://docs.aws.amazon.com/iot/latest/developerguide/authorizing-direct-aws.html
#   - RoleAliasDescription API Reference: https://docs.aws.amazon.com/iot/latest/apireference/API_RoleAliasDescription.html
#   - Role alias overly permissive: https://docs.aws.amazon.com/iot-device-defender/latest/devguide/audit-chk-iot-role-alias-permissive.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_role_alias
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_role_alias" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # (Required) ロールエイリアスの名前
  # - 1〜128文字の英数字と =, @, - 記号のみ使用可能
  # - 大文字小文字を区別します
  # - デバイスがAWS認証情報を要求する際に、このエイリアス名を指定します
  # - エイリアス名はプライマリキーとして機能し、一意である必要があります
  # 例: "Thermostat-dynamodb-access-role-alias"
  alias = "your-role-alias-name"

  # (Required) このロールエイリアスが参照するIAMロールのARN
  # - credentials.iot.amazonaws.comをプリンシパルとする信頼ポリシーが必要
  # - IoTデバイスがアクセスするAWSサービスへの適切な権限ポリシーをアタッチ
  # - ロールの最大セッション期間は credential_duration 以上である必要があります
  # 例: "arn:aws:iam::123456789012:role/IoTDeviceRole"
  role_arn = aws_iam_role.example.arn

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # (Optional) 認証情報の有効期間（秒単位）
  # - 最小値: 900秒（15分）
  # - 最大値: 43200秒（12時間）
  # - デフォルト: 3600秒（1時間）
  # - 指定した値は、参照先IAMロールの最大セッション期間以下である必要があります
  # - 長い有効期間を設定することで、認証情報プロバイダーへの呼び出し回数を削減できます
  # - デバイスが認証情報をキャッシュする時間を考慮して設定してください
  credential_duration = 3600

  # (Optional) リージョンの指定
  # - このリソースが管理されるAWSリージョン
  # - 省略時はプロバイダー設定のリージョンが使用されます
  # - 明示的に指定することで、マルチリージョン構成を管理できます
  # 例: "us-east-1"
  # region = "us-east-1"

  # (Optional) リソースタグ
  # - キーと値のペアでリソースにメタデータを付与
  # - プロバイダーのdefault_tagsと併用可能
  # - 重複するキーはこちらの設定が優先されます
  # - コスト配分、リソース管理、セキュリティポリシーの適用に使用
  tags = {
    Name        = "example-iot-role-alias"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # (Optional) すべてのタグ（プロバイダーのdefault_tagsを含む）
  # - 通常は明示的に設定する必要はありません
  # - プロバイダーレベルのdefault_tagsと個別のtagsがマージされます
  # - 読み取り専用として使用されることが多いです
  # tags_all = {}
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です:
#
# - arn
#   このロールエイリアスにAWSが割り当てたARN
#   例: "arn:aws:iot:us-east-1:123456789012:rolealias/your-role-alias-name"
#   用途: IoTポリシーでiot:AssumeRoleWithCertificateアクションの許可に使用
#
# - id
#   リソースの識別子（通常はエイリアス名と同じ）
#
# - tags_all
#   プロバイダーのdefault_tagsを含む、リソースに割り当てられたすべてのタグ
#
#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# 1. IAMロールの信頼ポリシーに以下を設定:
#    {
#      "Version": "2012-10-17",
#      "Statement": {
#        "Effect": "Allow",
#        "Principal": {"Service": "credentials.iot.amazonaws.com"},
#        "Action": "sts:AssumeRole"
#      }
#    }
#
# 2. デバイス証明書にアタッチするIoTポリシーに以下を設定:
#    {
#      "Version": "2012-10-17",
#      "Statement": [{
#        "Effect": "Allow",
#        "Action": "iot:AssumeRoleWithCertificate",
#        "Resource": "arn:aws:iot:REGION:ACCOUNT:rolealias/ALIAS_NAME"
#      }]
#    }
#
# 3. デバイスから認証情報を取得:
#    curl --cert device.crt --key device.key \
#         -H "x-amzn-iot-thingname: my-thing" \
#         https://ACCOUNT_ID.credentials.iot.REGION.amazonaws.com/role-aliases/ALIAS_NAME/credentials
#
#---------------------------------------------------------------
# セキュリティ上の注意事項
#---------------------------------------------------------------
# - ロールエイリアスに過度に広範な権限を付与しないでください
# - デバイスが必要とする最小限の権限のみを付与してください
# - IAMポリシーで以下のコンテキスト変数を使用して権限を制限できます:
#   * credentials-iot:ThingName
#   * credentials-iot:ThingTypeName
#   * credentials-iot:AwsCertificateId
# - AWS IoT Device Defenderの監査機能を使用して、過度に広範な権限を検出できます
#
#---------------------------------------------------------------
