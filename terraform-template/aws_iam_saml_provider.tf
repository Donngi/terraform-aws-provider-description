#---------------------------------------------------------------
# AWS IAM SAML Provider
#---------------------------------------------------------------
#
# IAM SAML 2.0 IDプロバイダーをプロビジョニングするリソースです。
# SAMLプロバイダーは外部のアイデンティティプロバイダー（IdP）を記述し、
# IAMロールの信頼ポリシーのプリンシパルとして使用することで、
# フェデレーションユーザーがWebベースのシングルサインオン（SSO）や
# APIアクセスのためにロールを引き受けることができます。
#
# AWS公式ドキュメント:
#   - SAML 2.0 フェデレーション: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_saml.html
#   - IAM SAMLプロバイダーAPI: https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateSAMLProvider.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_saml_provider
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_saml_provider" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 作成するSAMLプロバイダーの名前を指定します。
  # 設定可能な値: 1-128文字の英数字およびハイフン・アンダースコア・カンマ・ピリオド・アットマーク（=, +, -を含む）
  # 注意: このリソースはForces new resourceではないため、名前の変更は新しいリソースの作成を伴います
  # 参考: https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateSAMLProvider.html
  name = "my-saml-provider"

  # saml_metadata_document (Required)
  # 設定内容: SAML 2.0をサポートするアイデンティティプロバイダーが生成したXMLドキュメントを指定します。
  # 設定可能な値: IdPのSAMLメタデータXMLドキュメントの内容（最大10MB）
  #   - XMLには発行者名、有効期限情報、SAML認証応答の検証に使用するキーが含まれます
  # 注意: AWSをSPとしてIdPに登録した際にIdPから提供されるメタデータXMLファイルを使用します
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_saml.html
  saml_metadata_document = file("saml-metadata.xml")

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします
  tags = {
    Name        = "my-saml-provider"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: SAMLプロバイダーのAmazon Resource Name (ARN)
#        IAMロールの信頼ポリシーのプリンシパルとして使用します
#
# - saml_provider_uuid: SAMLプロバイダーに割り当てられた一意の識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - valid_until: SAMLプロバイダーの有効期限日時（RFC1123形式）
#                例: Mon, 02 Jan 2006 15:04:05 MST
#---------------------------------------------------------------
