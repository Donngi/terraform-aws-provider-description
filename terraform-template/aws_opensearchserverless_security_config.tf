#---------------------------------------------------------------
# Amazon OpenSearch Serverless Security Config
#---------------------------------------------------------------
#
# Amazon OpenSearch ServerlessのSAML認証セキュリティ設定をプロビジョニングするリソースです。
# このリソースは、OpenSearch DashboardsへのSingle Sign-On (SSO)を実装するための
# SAML認証プロバイダーを定義します。IAM Identity Center、Okta、Keycloak、
# Active Directory Federation Services (AD FS)、Auth0などの既存のIDプロバイダーを
# 使用してユーザー認証を行うことができます。
#
# AWS公式ドキュメント:
#   - SAML authentication for OpenSearch Serverless: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-saml.html
#   - Security overview: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-security.html
#   - CreateSecurityConfig API: https://docs.aws.amazon.com/opensearch-service/latest/ServerlessAPIReference/API_CreateSecurityConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_config
#
# Provider Version: 6.28.0
# Generated: 2026-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearchserverless_security_config" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: セキュリティ設定の名前を指定します。
  # 設定可能な値: 1文字以上の文字列
  # 注意: リソース作成後は変更できません（Forces new resource）
  name = "example-saml-config"

  # type (Required, Forces new resource)
  # 設定内容: セキュリティ設定のタイプを指定します。
  # 設定可能な値: "saml" (現在はSAML認証のみサポート)
  # 注意: リソース作成後は変更できません（Forces new resource）
  type = "saml"

  # description (Optional)
  # 設定内容: セキュリティ設定の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  # 用途: セキュリティ設定の目的や用途を文書化する際に使用
  description = "SAML authentication configuration for production environment"

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
  # SAML認証設定
  #-------------------------------------------------------------

  # saml_options (Required)
  # 設定内容: SAML認証の詳細設定を定義するブロックです。
  # 注意: typeが"saml"の場合は必須
  # 関連機能: OpenSearch Serverless SAML認証
  #   IDプロバイダー（IdP）を使用したSingle Sign-On認証を実装。
  #   ユーザーは既存の企業アカウントでOpenSearch Dashboardsにアクセス可能。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-saml.html
  saml_options {
    # metadata (Required)
    # 設定内容: IDプロバイダーから生成されたXML IdPメタデータファイルの内容を指定します。
    # 設定可能な値: XML形式の文字列（1-51200文字）
    # 用途: SAMLアサーションコンシューマーサービス(ACS) URLやエンティティIDなどの
    #       IdP設定情報を提供
    # 参考: IDプロバイダーの管理コンソールからメタデータXMLをダウンロードし、
    #       file()関数で読み込むか、直接文字列として指定
    metadata = file("${path.module}/idp-metadata.xml")

    # group_attribute (Optional)
    # 設定内容: SAML統合に使用するグループ属性の名前を指定します。
    # 設定可能な値: 英数字、+、,、.、@、-の組み合わせ（1-2048文字）
    # 省略時: グループ属性は使用されません
    # 用途: SAML アサーション内のグループ属性をデータアクセスポリシーの
    #       プリンシパルとして使用する場合に指定
    # 参考: IDプロバイダーで設定したグループ属性名（例: "groups", "memberOf"）を指定
    #       - https://docs.aws.amazon.com/opensearch-service/latest/ServerlessAPIReference/API_SamlConfigOptions.html
    group_attribute = "groups"

    # session_timeout (Optional)
    # 設定内容: SAMLセッションのタイムアウト時間を分単位で指定します。
    # 設定可能な値: 5-720の整数（5分から12時間）
    # 省略時: 60（60分 = 1時間）
    # 用途: セキュリティ要件に応じてセッションの有効期間を調整
    # 注意: タイムアウト後、ユーザーは再認証が必要になります
    session_timeout = 480

    # user_attribute (Optional)
    # 設定内容: SAML統合に使用するユーザー属性の名前を指定します。
    # 設定可能な値: 英数字、+、,、.、@、-の組み合わせ（1-2048文字）
    # 省略時: ユーザー属性は使用されません
    # 用途: SAML アサーション内のユーザー属性をデータアクセスポリシーの
    #       プリンシパルとして使用する場合に指定
    # 参考: IDプロバイダーで設定したユーザー属性名（例: "nameid", "email", "uid"）を指定
    #       - https://docs.aws.amazon.com/opensearch-service/latest/ServerlessAPIReference/API_SamlConfigOptions.html
    user_attribute = "nameid"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: セキュリティ設定の一意の識別子
#
# - config_version: 設定のバージョン番号。設定が更新されるたびに自動的にインクリメントされます
#---------------------------------------------------------------
