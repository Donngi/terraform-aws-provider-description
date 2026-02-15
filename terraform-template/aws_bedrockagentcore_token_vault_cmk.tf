#---------------------------------------------------------------
# Amazon Bedrock AgentCore Token Vault カスタマー管理キー
#---------------------------------------------------------------
#
# Amazon Bedrock AgentCore Identity のトークンボルトに対する
# カスタマー管理キー(CMK)を設定します。
#
# デフォルトでは、Bedrock はトークンボルトのデータを AWS 所有キーで暗号化しますが、
# このリソースを使用することで、カスタマー管理キーによる暗号化を有効化できます。
# CMK を使用することで、キーポリシー、キーローテーション、削除などを
# お客様側で管理できるようになります。
#
# 注意事項:
# - Bedrock AgentCore のトークンボルト暗号化は単一リージョンの対称 KMS キーのみをサポート
# - マルチリージョンキーおよび非対称キーは使用不可
# - キーエイリアスでの設定は不可（KMS キー ARN のみ使用可能）
#
# AWS公式ドキュメント:
#   - Data encryption: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity-data-encryption.html
#   - SetTokenVaultCMK API: https://docs.aws.amazon.com/bedrock-agentcore-control/latest/APIReference/API_SetTokenVaultCMK.html
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
  # トークンボルト識別設定
  #-------------------------------------------------------------

  # token_vault_id (Optional, Computed)
  # 設定内容: カスタマー管理キーを設定するトークンボルトの一意な識別子
  # 制約: 1～64 文字の英数字、ハイフン、アンダースコア（パターン: [a-zA-Z0-9\-_]+）
  # 省略時: デフォルトのトークンボルトが使用されます
  # 参考: https://docs.aws.amazon.com/bedrock-agentcore-control/latest/APIReference/API_SetTokenVaultCMK.html
  token_vault_id = "my-token-vault"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースが管理されるリージョンを指定します
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  #-------------------------------------------------------------
  # KMS 暗号化設定
  #-------------------------------------------------------------

  # kms_configuration (Optional)
  # 設定内容: トークンボルトの暗号化に使用する AWS KMS キーの設定を定義します
  # 参考: https://docs.aws.amazon.com/bedrock-agentcore-control/latest/APIReference/API_KmsConfiguration.html
  kms_configuration {
    # key_type (Required)
    # 設定内容: KMS キーのタイプを指定します
    # 設定可能な値:
    #   - CustomerManagedKey: お客様が AWS KMS で作成・管理する KMS キー（推奨）
    #   - ServiceManagedKey: AWS が管理する KMS キー
    # 注意: CustomerManagedKey を選択した場合は kms_key_arn の指定が必須です
    key_type = "CustomerManagedKey"

    # kms_key_arn (Optional)
    # 設定内容: カスタマー管理キーの Amazon Resource Name (ARN) を指定します
    # 制約:
    #   - 1～2048 文字
    #   - 形式: arn:aws:kms:<region>:<account-id>:key/<key-id>
    #   - 単一リージョンの対称 KMS キーのみサポート
    #   - マルチリージョンキー・非対称キー・キーエイリアスは使用不可
    # 省略時: key_type が ServiceManagedKey の場合のみ省略可能
    # 注意: key_type が CustomerManagedKey の場合は必須です
    # 参考: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity-data-encryption.html
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - token_vault_id: トークンボルトの一意な識別子
# - region: リソースが管理されているリージョン
