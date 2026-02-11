#---------------------------------------------------------------
# IAM SAML Provider
#---------------------------------------------------------------
#
# IAM SAML 2.0 IDプロバイダーを作成します。
# SAML 2.0ベースのフェデレーションを使用して、外部IDプロバイダー（IdP）で
# 認証されたユーザーがAWSリソースにアクセスできるようにします。
#
# ユースケース:
#   - 企業の既存IDプロバイダー（Okta、Azure AD、Google Workspaceなど）を使用したSSO
#   - フェデレーテッドユーザーへのIAMロールの一時的な認証情報の提供
#   - SAML 2.0標準に準拠したシングルサインオン（SSO）の実装
#
# AWS公式ドキュメント:
#   - SAML 2.0 federation: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_saml.html
#   - Create a SAML identity provider: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_saml.html
#   - CreateSAMLProvider API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateSAMLProvider.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_saml_provider
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_saml_provider" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # SAMLプロバイダーの名前
  #
  # 制約:
  #   - 最大128文字
  #   - 英数字、プラス記号（+）、等号（=）、カンマ（,）、ピリオド（.）、
  #     アットマーク（@）、アンダースコア（_）、ハイフン（-）が使用可能
  #
  # 例: "MyCompanySAMLProvider", "OktaProvider", "AzureADProvider"
  name = "example-saml-provider"

  # SAMLメタデータドキュメント
  #
  # SAML 2.0をサポートするIDプロバイダーによって生成されたXMLドキュメント。
  # このメタデータには以下の情報が含まれます:
  #   - 発行者の名前
  #   - 有効期限情報
  #   - SAML認証レスポンスの検証に使用する鍵
  #
  # 要件:
  #   - UTF-8エンコーディング
  #   - 最大10MB
  #   - SAML 2.0標準に準拠したXML形式
  #
  # 一般的な取得方法:
  #   - IdPの管理コンソールからメタデータXMLファイルをダウンロード
  #   - IdPのメタデータURLからダウンロード
  #
  # 例:
  #   - file("saml-metadata.xml")
  #   - file("path/to/idp-metadata.xml")
  #   - data.http.saml_metadata.body （URLから動的に取得する場合）
  saml_metadata_document = file("saml-metadata.xml")

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # リソースタグ
  #
  # SAMLプロバイダーに割り当てるタグのマップ。
  # プロバイダーレベルの default_tags と組み合わせて使用できます。
  #
  # ベストプラクティス:
  #   - 環境、所有者、コストセンターなどの識別情報を含める
  #   - 組織のタグ付け戦略に従う
  #
  # 例:
  #   tags = {
  #     Environment = "production"
  #     ManagedBy   = "Terraform"
  #     Owner       = "security-team"
  #     Purpose     = "SSO-Integration"
  #   }
  tags = {
    Name        = "example-saml-provider"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - arn
#     SAMLプロバイダーに割り当てられたAmazon Resource Name (ARN)
#     形式: arn:aws:iam::{account-id}:saml-provider/{provider-name}
#     IAMロールの信頼ポリシーでこのARNを使用します
#
# - id
#     SAMLプロバイダーのID（ARNと同じ値）
#
# - saml_provider_uuid
#     SAMLプロバイダーに割り当てられた一意の識別子
#     AWS内部で使用される UUID 形式の値
#
# - tags_all
#     リソースに割り当てられた全てのタグのマップ
#     プロバイダーのdefault_tagsから継承されたタグを含む
#
# - valid_until
#     SAMLプロバイダーの有効期限（RFC1123形式）
#     例: "Mon, 02 Jan 2006 15:04:05 MST"
#     メタデータドキュメントから自動的に抽出されます
#     この日時を過ぎるとプロバイダーは無効になります
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: IAMロールとの統合
#---------------------------------------------------------------
#
# SAMLプロバイダーを使用するには、対応するIAMロールを作成する必要があります。
# 以下は基本的な統合例です:
#
# # SAML フェデレーション用のIAMロール
# resource "aws_iam_role" "saml_role" {
#   name = "saml-federated-role"
#
#   # SAMLプロバイダーを信頼するポリシー
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Federated = aws_iam_saml_provider.example.arn
#         }
#         Action = "sts:AssumeRoleWithSAML"
#         Condition = {
#           StringEquals = {
#             "SAML:aud" = "https://signin.aws.amazon.com/saml"
#           }
#         }
#       }
#     ]
#   })
# }
#
# # ロールにポリシーをアタッチ
# resource "aws_iam_role_policy_attachment" "saml_role_policy" {
#   role       = aws_iam_role.saml_role.name
#   policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 運用上の注意事項
#---------------------------------------------------------------
#
# 1. メタデータの更新:
#    - IdPの証明書ローテーション時にはメタデータドキュメントを更新する必要があります
#    - メタデータの更新はプロバイダーリソースの再作成を伴います
#
# 2. セキュリティベストプラクティス:
#    - SAML応答の暗号化を有効化することを推奨
#    - IAMロールの信頼ポリシーで SAML属性による条件を使用してアクセスを制限
#    - 定期的にアクセスログを監査
#
# 3. 有効期限の管理:
#    - valid_until 属性を監視し、期限切れ前にメタデータを更新
#    - CloudWatch Alarms を設定して期限切れを事前に検知
#
# 4. 削除時の影響:
#    - SAMLプロバイダーを削除すると、それを参照する全てのIAMロールが機能しなくなります
#    - 削除前に依存するリソースを確認してください
#
#---------------------------------------------------------------
