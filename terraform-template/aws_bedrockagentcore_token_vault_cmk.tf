#---------------------------------------------------------------
# AWS Bedrock AgentCore Token Vault CMK
#---------------------------------------------------------------
#
# Bedrock AgentのトークンボールトのKMS暗号化キー（CMK）を管理するリソースです。
# トークンボールトは、OAuth2認証情報やAPIキーなどの機密情報を
# 安全に保存するためのセキュアストレージで、このリソースはその暗号化設定を管理します。
#
# AWS公式ドキュメント:
#   - Token Vaults概要: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/token-vaults.html
#   - セキュリティ設定: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/security.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagentcore_token_vault_cmk
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagentcore_token_vault_cmk" "example" {
  #-------------------------------------------------------------
  # トークンボールト設定
  #-------------------------------------------------------------

  # token_vault_id (Optional)
  # 設定内容: トークンボールトの一意な識別子を指定します。
  # 設定可能な値: 文字列
  # 省略時: "default" が使用されます
  # 注意: デフォルトのトークンボールトを使用する場合は省略可能です。
  token_vault_id = null

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # KMS暗号化設定（必須）
  #-------------------------------------------------------------

  # kms_configuration (Required)
  # 設定内容: トークンボールトのKMS暗号化設定を指定します。
  # 注意: トークンボールトのセキュリティに関わる重要な設定です。
  kms_configuration {
    # key_type (Required)
    # 設定内容: 使用するKMSキーのタイプを指定します。
    # 設定可能な値:
    #   - "CustomerManagedKey": カスタマー管理キー（kms_key_arnの指定が必要）
    #   - "ServiceManagedKey": サービス管理キー（AWS側で自動管理）
    # 関連機能: KMS暗号化
    #   CustomerManagedKeyを選択すると、独自のKMSキーで暗号化を管理でき、
    #   キーのローテーション、アクセスポリシー、監査ログを制御できます。
    key_type = "CustomerManagedKey"

    # kms_key_arn (Optional)
    # 設定内容: カスタマー管理キーを使用する場合のKMSキーのARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    # 省略時: key_typeが"ServiceManagedKey"の場合は不要
    # 注意: key_typeが"CustomerManagedKey"の場合は必須です。
    # 関連機能: カスタム暗号化
    #   KMSキーのポリシーでbedrock-agentcore.amazonaws.comによる
    #   暗号化/復号化を許可する必要があります。
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースID（token_vault_id,region形式）
#
# - token_vault_id: トークンボールトの識別子
#
# - region: リソースが管理されているリージョン
#
# - kms_configuration: KMS設定の詳細
#   - key_type: 設定されたKMSキータイプ
#   - kms_key_arn: 設定されたKMSキーARN（CustomerManagedKeyの場合）
#
#---------------------------------------------------------------
# 削除時の注意事項
#---------------------------------------------------------------
# このリソースを削除した場合、Terraformの状態からのみ削除され、
# 実際のトークンボールトのCMK設定は変更されません。
# 実際のKMS設定を変更する場合は、AWSコンソールまたはAWS CLIを使用してください。
#---------------------------------------------------------------
