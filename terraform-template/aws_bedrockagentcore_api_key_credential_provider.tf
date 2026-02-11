#---------------------------------------------------------------
# AWS Bedrock AgentCore API Key Credential Provider
#---------------------------------------------------------------
#
# Amazon Bedrock AgentCoreのAPIキー認証情報プロバイダーをプロビジョニングするリソースです。
# APIキー認証情報プロバイダーは、エージェントランタイムがAPIキーベースの認証を使用する
# 外部サービスと安全に認証するための機能を提供します。
#
# AWS公式ドキュメント:
#   - Credential Provider設定: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/resource-providers.html
#   - APIキーの追加: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity-add-api-key.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagentcore_api_key_credential_provider
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagentcore_api_key_credential_provider" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: APIキー認証情報プロバイダーの名前を指定します。
  # 設定可能な値: 1-128文字の文字列
  # 注意: リソース作成後に変更するとリソースが再作成されます。
  name = "example-api-key-provider"

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
  # APIキー設定（標準方式）
  #-------------------------------------------------------------

  # api_key (Optional, Sensitive)
  # 設定内容: APIキーの値を指定します。
  # 設定可能な値: 1-65536文字の文字列
  # 注意:
  #   - api_key_wo と排他的（どちらか一方のみ指定可能）
  #   - この値はTerraformのplanやログに表示されます
  #   - 本番環境ではセキュリティ上の理由から api_key_wo の使用を推奨
  api_key = "your-api-key-here"

  #-------------------------------------------------------------
  # APIキー設定（書き込み専用方式 - 本番環境推奨）
  #-------------------------------------------------------------
  # Write-Only引数は HashiCorp Terraform 1.11.0以降で利用可能です。
  # 詳細: https://developer.hashicorp.com/terraform/language/resources/ephemeral#write-only-arguments

  # api_key_wo (Optional, Sensitive)
  # 設定内容: 書き込み専用のAPIキー値を指定します。
  # 設定可能な値: 文字列
  # 注意:
  #   - api_key と排他的（どちらか一方のみ指定可能）
  #   - api_key_wo_version と併用が必要
  #   - Terraform plan/state に値が保存されないためセキュリティが向上
  # api_key_wo = "your-api-key-here"

  # api_key_wo_version (Optional)
  # 設定内容: 書き込み専用APIキーの更新をトリガーするためのバージョン番号を指定します。
  # 設定可能な値: 数値
  # 注意:
  #   - api_key_wo と併用が必要
  #   - api_key_wo を更新する場合はこの値をインクリメントしてください
  # api_key_wo_version = 1
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - credential_provider_arn: APIキー認証情報プロバイダーのAmazon Resource Name (ARN)
#
# - api_key_secret_arn: APIキーを含むAWS Secrets ManagerシークレットのARN情報
#     - secret_arn: Secrets Manager内のシークレットのARN
#---------------------------------------------------------------
