#---------------------------------------------------------------
# AWS SES Domain DKIM
#---------------------------------------------------------------
#
# Amazon SESドメインのDKIM（DomainKeys Identified Mail）トークンを生成するリソースです。
# 生成されたDKIMトークンをDNSのCNAMEレコードとして設定することで、
# Amazon SESがメール送信時にDKIM署名を付与できるようになります。
# ドメインの所有権確認はaws_ses_domain_identityリソースで事前に行う必要があります。
#
# AWS公式ドキュメント:
#   - Amazon SES Easy DKIM: https://docs.aws.amazon.com/ses/latest/dg/send-email-authentication-dkim-easy.html
#   - DKIM DNSレコードの設定: https://docs.aws.amazon.com/ses/latest/dg/send-email-authentication-dkim-easy-setup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_dkim
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ses_domain_dkim" "example" {
  #-------------------------------------------------------------
  # ドメイン設定
  #-------------------------------------------------------------

  # domain (Required)
  # 設定内容: DKIMトークンを生成する対象の検証済みドメイン名を指定します。
  # 設定可能な値: aws_ses_domain_identityで検証済みのドメイン名文字列
  # 参考: https://docs.aws.amazon.com/ses/latest/dg/send-email-authentication-dkim-easy.html
  domain = "example.com"

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
# - dkim_tokens: SESが生成したDKIMトークンのリスト（3件）。
#                各トークンを {token}._domainkey.{domain} 形式のCNAME
#                レコードとしてDNSに登録することでDKIM署名が有効になります。
#---------------------------------------------------------------
