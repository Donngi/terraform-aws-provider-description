#---------------------------------------------------------------
# AWS Bedrock AgentCore API Key Credential Provider
#---------------------------------------------------------------
#
# Amazon Bedrock AgentCoreのAPIキー認証情報プロバイダーをプロビジョニングするリソースです。
# APIキー認証情報プロバイダーは、エージェントランタイムがAPIキーベースの認証を使用する
# 外部サービスとセキュアに認証するための機能を提供します。
#
# AWS公式ドキュメント:
#   - Bedrock AgentCore Identity: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity-getting-started-cognito.html
#   - CreateApiKeyCredentialProvider API: https://docs.aws.amazon.com/bedrock-agentcore-control/latest/APIReference/API_CreateApiKeyCredentialProvider.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagentcore_api_key_credential_provider
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagentcore_api_key_credential_provider" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces replacement)
  # 設定内容: APIキー認証情報プロバイダーの名前を指定します。
  # 設定可能な値: 文字列
  # 注意: 変更すると既存リソースが削除され再作成されます。
  name = "example-api-key-provider"

  #-------------------------------------------------------------
  # APIキー設定（標準方式）
  #-------------------------------------------------------------

  # api_key (Optional, Sensitive)
  # 設定内容: APIキーの値を指定します。
  # 設定可能な値: 文字列
  # 注意: api_key_woとは排他的（どちらか一方のみ指定可能）。
  #       この値はTerraformのplan出力やログに表示されます。
  #       本番環境ではapi_key_wo（Write-Only方式）の使用を推奨します。
  api_key = "your-api-key-here"

  #-------------------------------------------------------------
  # APIキー設定（Write-Only方式 - 本番環境推奨）
  #-------------------------------------------------------------

  # api_key_wo (Optional, Sensitive, Write-Only)
  # 設定内容: Write-Only APIキーの値を指定します。
  # 設定可能な値: 文字列
  # 注意: api_keyとは排他的（どちらか一方のみ指定可能）。
  #       api_key_wo_versionと一緒に使用する必要があります。
  #       Write-Only引数はHashiCorp Terraform 1.11.0以降でサポートされています。
  # api_key_wo = "your-api-key-here"

  # api_key_wo_version (Optional)
  # 設定内容: Write-Only APIキーの更新をトリガーするためのバージョン番号を指定します。
  # 設定可能な値: 数値
  # 用途: api_key_woを更新する必要がある場合、この値をインクリメントしてください。
  # api_key_wo_version = 1

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグのキー・バリューマップを指定します。
  # 省略時: タグなし（プロバイダーレベルのdefault_tagsは適用される）
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name = "example-api-key-provider"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - credential_provider_arn: APIキー認証情報プロバイダーのAmazon Resource Name (ARN)
#
# - api_key_secret_arn: APIキーを含むAWS Secrets ManagerシークレットのARN
#   - secret_arn: AWS Secrets Manager内のシークレットのARN
#
# - tags_all: プロバイダーレベルのdefault_tagsを含む全タグのマップ
#---------------------------------------------------------------
