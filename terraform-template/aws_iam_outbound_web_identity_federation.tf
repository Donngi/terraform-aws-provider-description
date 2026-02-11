#---------------------------------------------------------------
# AWS IAM Outbound Web Identity Federation
#---------------------------------------------------------------
#
# AWS Identity and Access Management (IAM) のアウトバウンド
# ウェブIDフェデレーションを管理するリソースです。
#
# この機能により、IAMプリンシパルがAWSアカウントから
# 短命のJSON Web Token (JWT)を取得し、外部サービスへの
# 安全な認証を実現できます。長期的な認証情報を保存する
# 必要がなくなり、セキュリティが向上します。
#
# 主な用途:
#   - 外部クラウドプロバイダーのリソース・サービスへのアクセス
#   - SaaSプロバイダーとの統合
#   - セルフホスト型アプリケーションへの認証
#
# AWS公式ドキュメント:
#   - Outbound Identity Federation概要: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_outbound.html
#   - API Reference: https://docs.aws.amazon.com/IAM/latest/APIReference/API_EnableOutboundWebIdentityFederation.html
#   - ブログ記事: https://aws.amazon.com/blogs/aws/simplify-access-to-external-services-using-aws-iam-outbound-identity-federation/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_outbound_web_identity_federation
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 重要な注意事項:
#   - このリソースを作成すると、IAM Outbound Web Identity Federationが有効化されます
#   - このリソースを削除すると、IAM Outbound Web Identity Federationが無効化されます
#   - 1つのAWSアカウントにつき1つのリソースのみ作成可能です
#
#---------------------------------------------------------------

resource "aws_iam_outbound_web_identity_federation" "example" {
  #-------------------------------------------------------------
  # 設定不要（入力パラメータなし）
  #-------------------------------------------------------------
  #
  # このリソースは入力パラメータを必要としません。
  # リソースを定義するだけで、IAM Outbound Web Identity Federation
  # 機能が有効化され、アカウント固有のissuer URLが発行されます。
  #
  #-------------------------------------------------------------
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - issuer_identifier (String, Computed)
#   AWSアカウント固有のissuer URLです。
#   このURLは、OpenID Connect (OIDC) ディスカバリーエンドポイントをホストします:
#     - /.well-known/openid-configuration
#     - /.well-known/jwks.json
#
#   外部サービスがこのAWSアカウントから発行されたJWTトークンを
#   信頼・検証する際に、このissuer URLを使用して
#   公開鍵とメタデータを取得します。
#
#   使用例:
#     output "issuer_url" {
#       value = aws_iam_outbound_web_identity_federation.example.issuer_identifier
#     }
#
#   トークンの取得方法:
#     IAMプリンシパルは、AWS STS GetWebIdentityToken APIを使用して
#     短命のJWTを取得できます。
#     - API Reference: https://docs.aws.amazon.com/STS/latest/APIReference/API_GetWebIdentityToken.html
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用シナリオ例
#---------------------------------------------------------------
#
# 1. 外部サービスとの統合設定:
#
#    resource "aws_iam_outbound_web_identity_federation" "main" {}
#
#    output "oidc_issuer_url" {
#      description = "OIDC issuer URL for external service configuration"
#      value       = aws_iam_outbound_web_identity_federation.main.issuer_identifier
#    }
#
# 2. Lambda関数からの外部サービスアクセス:
#
#    - Lambda実行ロールにGetWebIdentityToken権限を付与
#    - Lambda関数内でAWS SDK/CLIを使用してJWTを取得
#    - 取得したJWTを使用して外部サービスにアクセス
#
# 3. アクセス制御:
#
#    IAMポリシーを使用して、以下を制御できます:
#      - トークン生成へのアクセス許可
#      - トークンの有効期限
#      - トークンのオーディエンス
#      - 署名アルゴリズム
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# セキュリティ上の考慮事項
#---------------------------------------------------------------
#
# 利点:
#   - 長期的な認証情報の保存が不要
#   - 短命トークン（JWTの有効期限は調整可能）
#   - 暗号署名による検証可能性
#   - 完全な監査証跡（CloudTrailで追跡可能）
#
# ベストプラクティス:
#   - 最小権限の原則に従ったIAMポリシーの設定
#   - トークンの有効期限を最小限に設定
#   - 外部サービス側でのトークン検証実装
#   - CloudTrailログの監視とアラート設定
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 料金
#---------------------------------------------------------------
#
# この機能は追加料金なしで利用可能です。
# すべてのAWS商用リージョン、GovCloud (US)リージョン、
# 中国リージョンで利用できます。
#
#---------------------------------------------------------------
