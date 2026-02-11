#---------------------------------------
# Bedrock AgentCore API Key Credential Provider
#---------------------------------------
# APIキー認証を使用する外部サービスとの統合を可能にする認証プロバイダー
# エージェントランタイムが外部APIに安全にアクセスするための資格情報管理を提供
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
#
# NOTE:
#   api_keyはTerraformの出力とログに平文で記録されるため本番環境では非推奨です
#   本番環境ではapi_key_wo（書き込み専用）の使用を強く推奨します（Terraform 1.11.0以降が必要）
#   api_keyとapi_key_woは排他的で同時使用できません
#   nameの変更はリソースの強制的な再作成を引き起こします
#
# Terraform設定例
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/bedrockagentcore_api_key_credential_provider
#---------------------------------------

#---------------------------------------
# 基本設定
#---------------------------------------
resource "aws_bedrockagentcore_api_key_credential_provider" "example" {
  # 設定内容: APIキー認証プロバイダーの一意の識別名
  # 省略時: 省略不可（必須パラメータ）
  name = "example-api-key-provider"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（us-east-1, ap-northeast-1等）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

  #---------------------------------------
  # 認証情報設定（標準方式）
  #---------------------------------------
  # 設定内容: 外部サービス認証用のAPIキー（機密情報）
  # 設定可能な値: 有効なAPIキー文字列
  # 省略時: api_key_woを使用する場合は省略可能
  api_key = "your-api-key-here"

  #---------------------------------------
  # 認証情報設定（書き込み専用方式・本番推奨）
  #---------------------------------------
  # 設定内容: 書き込み専用APIキー（機密情報・Terraform 1.11.0以降）
  # 設定可能な値: 有効なAPIキー文字列
  # 省略時: api_keyを使用する場合は省略可能
  api_key_wo = "your-api-key-here"

  # 設定内容: APIキー更新トリガー用のバージョン番号
  # 設定可能な値: 正の整数（APIキー更新時にインクリメント）
  # 省略時: api_key_wo未使用時は省略可能
  api_key_wo_version = 1
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# credential_provider_arn: APIキー認証プロバイダーのARN
# api_key_secret_arn: AWS Secrets Managerに自動作成されたシークレットのARN情報（secret_arnフィールドを含む）
