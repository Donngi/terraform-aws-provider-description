#---------------------------------------------------------------
# AWS ACM PCA Policy
#---------------------------------------------------------------
#
# AWS Private Certificate Authority（プライベートCA）にリソースベースの
# ポリシーをアタッチするためのリソースです。
# リソースベースポリシーにより、クロスアカウントでのCA共有や、
# 他のAWSアカウント・AWS Organizationsへのアクセス権限付与が可能になります。
#
# AWS公式ドキュメント:
#   - ACM PCA リソースベースポリシー: https://docs.aws.amazon.com/privateca/latest/userguide/pca-rbp.html
#   - PutPolicy API: https://docs.aws.amazon.com/privateca/latest/APIReference/API_PutPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acmpca_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_acmpca_policy" "example" {
  #-------------------------------------------------------------
  # リソースARN設定
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: ポリシーを関連付けるプライベートCAのARNを指定します。
  # 設定可能な値: 有効なACM PCA（プライベートCA）のARN
  # 関連機能: AWS Private Certificate Authority
  #   プライベートCAを使用して、組織内の内部リソース用にプライベート証明書を
  #   発行・管理できます。リソースベースポリシーにより、他のアカウントから
  #   このCAを使用した証明書発行が可能になります。
  #   - https://docs.aws.amazon.com/privateca/latest/userguide/pca-rbp.html
  resource_arn = aws_acmpca_certificate_authority.example.arn

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: プライベートCAにアタッチするJSON形式のIAMポリシーを指定します。
  # 設定可能な値: 有効なJSON形式のIAMポリシードキュメント
  # 関連機能: ACM PCA リソースベースポリシー
  #   リソースベースポリシーにより、以下のようなアクセス制御が可能です:
  #   - クロスアカウントでの証明書発行許可
  #   - AWS Organizationsへのアクセス権限付与
  #   - ACMユーザーが他のアカウントのCAで署名された証明書を発行
  #   - 使用可能な証明書テンプレートの制限
  #   - https://docs.aws.amazon.com/privateca/latest/userguide/pca-rbp.html
  # 注意: ACMがクロスアカウント証明書の自動更新を管理するには、
  #       ACMユーザーがService Linked Role (SLR)を設定する必要があります。
  policy = data.aws_iam_policy_document.example.json

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
# IAMポリシードキュメントの例
#---------------------------------------------------------------
# 以下は、プライベートCAへのアクセスを許可するポリシーの例です。
# 実際の使用時は、適切なアカウントID、ARN、アクションを指定してください。
#---------------------------------------------------------------

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "example" {
  # ステートメント1: CAの情報取得と証明書の取得を許可
  statement {
    sid    = "AllowReadOperations"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    actions = [
      "acm-pca:DescribeCertificateAuthority",
      "acm-pca:GetCertificate",
      "acm-pca:GetCertificateAuthorityCertificate",
      "acm-pca:ListPermissions",
      "acm-pca:ListTags",
    ]

    resources = [aws_acmpca_certificate_authority.example.arn]
  }

  # ステートメント2: 特定のテンプレートを使用した証明書発行を許可
  statement {
    sid    = "AllowIssueCertificate"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    actions   = ["acm-pca:IssueCertificate"]
    resources = [aws_acmpca_certificate_authority.example.arn]

    # 証明書テンプレートを制限する条件
    condition {
      test     = "StringEquals"
      variable = "acm-pca:TemplateArn"
      values   = ["arn:aws:acm-pca:::template/EndEntityCertificate/V1"]
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースARNと同じ値
#
#---------------------------------------------------------------
