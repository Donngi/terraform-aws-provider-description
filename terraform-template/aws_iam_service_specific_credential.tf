#---------------------------------------------------------------
# AWS IAM Service Specific Credential
#---------------------------------------------------------------
#
# IAMユーザーに対してサービス固有の認証情報をプロビジョニングするリソースです。
# サービス固有の認証情報はユーザー名とパスワードのペア、またはAPIキーで構成され、
# 特定のAWSサービス（Amazon Bedrock、AWS CodeCommit、Amazon Keyspaces等）への
# 認証に使用します。各IAMユーザーはサポートされているサービスごとに
# 最大2セットのサービス固有の認証情報を保持できます。
#
# AWS公式ドキュメント:
#   - IAMユーザーのサービス固有の認証情報: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_service-specific-creds.html
#   - CreateServiceSpecificCredential API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateServiceSpecificCredential.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_specific_credential
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_service_specific_credential" "example" {
  #-------------------------------------------------------------
  # サービス設定
  #-------------------------------------------------------------

  # service_name (Required)
  # 設定内容: 認証情報を作成する対象のAWSサービスのエンドポイント名を指定します。
  # 設定可能な値:
  #   - "codecommit.amazonaws.com": AWS CodeCommit用
  #   - "bedrock.amazonaws.com": Amazon Bedrock用
  #   - "cassandra.us-east-1.amazonaws.com": Amazon Keyspaces (Apache Cassandra)用
  # 参考: https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateServiceSpecificCredential.html
  service_name = "codecommit.amazonaws.com"

  #-------------------------------------------------------------
  # ユーザー設定
  #-------------------------------------------------------------

  # user_name (Required)
  # 設定内容: 認証情報を関連付けるIAMユーザーの名前を指定します。
  # 設定可能な値: 既存のIAMユーザー名（1〜64文字）
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_service-specific-creds.html
  user_name = "example-user"

  #-------------------------------------------------------------
  # 有効期限設定
  #-------------------------------------------------------------

  # credential_age_days (Optional)
  # 設定内容: Amazon Bedrock APIキーの有効期限を日数で指定します。
  # 設定可能な値: 正の整数（日数）
  # 省略時: 有効期限なし（無期限）
  # 注意: このパラメータはAmazon Bedrock（bedrock.amazonaws.com）向けのAPIキー
  #       にのみ適用されます。CodeCommitやKeyspacesには使用できません。
  # 参考: https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateServiceSpecificCredential.html
  credential_age_days = null

  #-------------------------------------------------------------
  # ステータス設定
  #-------------------------------------------------------------

  # status (Optional)
  # 設定内容: サービス固有の認証情報のステータスを指定します。
  # 設定可能な値:
  #   - "Active": 認証情報を有効化します（デフォルト）
  #   - "Inactive": 認証情報を無効化します（一時的に使用停止にする場合に使用）
  # 省略時: "Active"（認証情報は有効な状態で作成されます）
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_service-specific-creds.html
  status = "Active"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: "service_name:user_name:service_specific_credential_id" 形式の識別子
# - service_specific_credential_id: サービス固有の認証情報の一意識別子
# - service_user_name: 生成されたユーザー名（例: jane-at-123456789012）
# - service_password: 生成されたパスワード（センシティブ値・作成時のみ取得可能）
# - service_credential_alias: Bedrock APIキーの公開部分（Bedrock専用）
# - service_credential_secret: Bedrock APIキーの秘密部分（センシティブ値・Bedrock専用）
# - create_date: 認証情報が作成された日時（RFC3339形式）
# - expiration_date: 認証情報の有効期限日時（RFC3339形式・Bedrock専用）
#---------------------------------------------------------------
