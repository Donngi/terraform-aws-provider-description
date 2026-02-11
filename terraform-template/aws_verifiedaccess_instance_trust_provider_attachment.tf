#---------------------------------------------------------------
# AWS Verified Access Instance Trust Provider Attachment
#---------------------------------------------------------------
#
# AWS Verified Access インスタンスにトラストプロバイダーをアタッチするリソース。
# Verified Access は、選択したトラストプロバイダーからの信頼データとアクセスポリシー
# に基づいてアプリケーションへのアクセスを許可するサービスです。
#
# トラストプロバイダーは以下の種類があります:
# - ユーザーベース (IAM Identity Center または OIDC)
# - デバイスベース (Jamf, CrowdStrike, JumpCloud)
#
# AWS公式ドキュメント:
#   - AttachVerifiedAccessTrustProvider API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AttachVerifiedAccessTrustProvider.html
#   - Verified Access instances: https://docs.aws.amazon.com/verified-access/latest/ug/create-verified-access-instance.html
#   - How Verified Access works: https://docs.aws.amazon.com/verified-access/latest/ug/how-it-works.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/verifiedaccess_instance_trust_provider_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_verifiedaccess_instance_trust_provider_attachment" "example" {

  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # verifiedaccess_instance_id (Required)
  # 設定内容: トラストプロバイダーをアタッチする Verified Access インスタンスの ID
  # 設定可能な値: Verified Access インスタンスのリソース ID (vai-xxxxxxxxx 形式)
  # 省略時: 必須項目のため指定が必要
  # 関連機能: Verified Access Instance
  #   アプリケーションリクエストを評価し、セキュリティ要件に基づいてアクセスを許可する単位
  #   https://docs.aws.amazon.com/verified-access/latest/ug/create-verified-access-instance.html
  verifiedaccess_instance_id = aws_verifiedaccess_instance.example.id

  # verifiedaccess_trust_provider_id (Required)
  # 設定内容: アタッチする Verified Access トラストプロバイダーの ID
  # 設定可能な値: Verified Access トラストプロバイダーのリソース ID (vatp-xxxxxxxxx 形式)
  # 省略時: 必須項目のため指定が必要
  # 関連機能: Verified Access Trust Provider
  #   ユーザー ID またはデバイスセキュリティ状態を管理し、Verified Access に送信
  #   https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_VerifiedAccessTrustProvider.html
  verifiedaccess_trust_provider_id = aws_verifiedaccess_trust_provider.example.id

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースが管理されるリージョン
  # 設定可能な値: AWS リージョンコード (us-east-1, ap-northeast-1 など)
  # 省略時: プロバイダー設定のリージョンが使用される
  # 関連機能: Regional Endpoints
  #   リージョナルエンドポイントの詳細について
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# - id: 一意な ID。verifiedaccess_instance_id と verifiedaccess_trust_provider_id を
#       "/" で結合した形式 (例: vai-xxx/vatp-yyy)
#---------------------------------------------------------------
