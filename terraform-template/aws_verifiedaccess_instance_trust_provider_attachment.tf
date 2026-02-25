#---------------------------------------------------------------
# AWS Verified Access Instance Trust Provider Attachment
#---------------------------------------------------------------
#
# AWS Verified Access InstanceとTrust Providerの関連付けを管理するリソースです。
# Verified Access InstanceにTrust Providerをアタッチすることで、
# インスタンス配下のグループやエンドポイントで当該Trust Providerの
# 認証・認可情報を利用できるようになります。
#
# AWS公式ドキュメント:
#   - Verified Access Trust Providers: https://docs.aws.amazon.com/verified-access/latest/ug/trust-providers.html
#   - AttachVerifiedAccessTrustProvider API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AttachVerifiedAccessTrustProvider.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/verifiedaccess_instance_trust_provider_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_verifiedaccess_instance_trust_provider_attachment" "example" {
  #-------------------------------------------------------------
  # 関連付け設定
  #-------------------------------------------------------------

  # verifiedaccess_instance_id (Required)
  # 設定内容: Trust Providerをアタッチする対象のVerified Access InstanceのIDを指定します。
  # 設定可能な値: 有効なVerified Access InstanceのID（例: vai-0ce000c0b7643abea）
  # 関連機能: Verified Access Instance
  #   Verified Access Instanceは、Trust ProviderとVerified Accessグループを
  #   統合する基盤となるコンポーネントです。1つのインスタンスに複数の
  #   Trust Providerをアタッチできます。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/trust-providers.html
  verifiedaccess_instance_id = "vai-0ce000c0b7643abea"

  # verifiedaccess_trust_provider_id (Required)
  # 設定内容: アタッチするVerified Access Trust ProviderのIDを指定します。
  # 設定可能な値: 有効なVerified Access Trust ProviderのID（例: vatp-0bb32de759a3e19e7）
  # 関連機能: Verified Access Trust Provider
  #   Trust Providerは、ユーザーやデバイスのアイデンティティ情報を提供するサービスです。
  #   ユーザーベース（IAM Identity Center, OIDCなど）またはデバイスベース
  #   （Jamf Pro, VMware Carbon Black, Crowdstrikeなど）のTrust Providerが利用できます。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/trust-providers.html
  verifiedaccess_trust_provider_id = "vatp-0bb32de759a3e19e7"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Verified Access InstanceのIDとTrust ProviderのIDを
#       コンマで結合した値（例: vai-0ce000c0b7643abea,vatp-0bb32de759a3e19e7）
#---------------------------------------------------------------
