#---------------------------------------------------------------
# AWS Bedrock AgentCore Token Vault CMK
#---------------------------------------------------------------
#
# Amazon Bedrock AgentCore IdentityのToken Vaultで使用する
# AWS KMSカスタマーマスターキー（CMK）を管理するリソースです。
# Token VaultはOAuth 2.0トークン、OAuthクライアント資格情報、
# APIキーを安全に保存するための機能であり、このリソースで
# 保存データの暗号化に使用するKMSキーを設定します。
#
# AWS公式ドキュメント:
#   - Data encryption: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity-data-encryption.html
#   - Configure KMS key for Token Vault: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/console-configuration-encryption.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagentcore_token_vault_cmk
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagentcore_token_vault_cmk" "example" {
  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Token Vault ID設定
  #-------------------------------------------------------------

  # token_vault_id (Optional)
  # 設定内容: Token VaultのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: "default"が使用されます
  token_vault_id = "default"

  #-------------------------------------------------------------
  # KMS設定
  #-------------------------------------------------------------

  # kms_configuration (Required)
  # 設定内容: Token Vaultの暗号化に使用するKMSキーの設定を指定します。
  # 関連機能: Amazon Bedrock AgentCore Identity データ暗号化
  #   Token Vault内のデータ（アクセストークン等）は保存時に暗号化されます。
  #   AWS所有キーまたはカスタマーマネージドキーを選択できます。
  #   カスタマーマネージドキーを使用する場合、キーポリシー、ローテーション、
  #   削除スケジュールを自身で管理できます。
  #   - https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity-data-encryption.html
  # 注意:
  #   - マルチリージョンキーや非対称キーはサポートされません
  #   - 単一リージョンの対称KMSキーのみサポートされます
  #   - キーエイリアスではなく、KMSキーARNで指定する必要があります
  kms_configuration {
    # key_type (Required)
    # 設定内容: KMSキーのタイプを指定します。
    # 設定可能な値:
    #   - "CustomerManagedKey": カスタマーマネージドキーを使用
    #     自身でキーポリシー、ローテーション、削除を管理します
    #   - "ServiceManagedKey": AWS所有キーを使用
    #     AWSが管理するキーで、AWS KMSには表示されません
    key_type = "CustomerManagedKey"

    # kms_key_arn (Optional)
    # 設定内容: KMSキーのARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    # 注意:
    #   - key_typeが"CustomerManagedKey"の場合に指定します
    #   - key_typeが"ServiceManagedKey"の場合は不要です
    #   - キーエイリアスではなくARNで指定する必要があります
    #   - 単一リージョンの対称KMSキーのみサポート
    kms_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは入力引数以外の属性をエクスポートしません。
#
# 注意: このリソースを削除してもCMK設定は変更されず、
#       Terraform stateからリソースが削除されるのみです。
#---------------------------------------------------------------
