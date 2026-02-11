#---------------------------------------------------------------
# AWS Shield Advanced Protection
#---------------------------------------------------------------
#
# AWS Shield Advancedの保護をプロビジョニングするリソースです。
# 特定のAWSリソースに対してDDoS攻撃からの高度な保護を有効にします。
# 保護対象として指定できるリソースは、Amazon CloudFrontディストリビューション、
# Elastic Load Balancingロードバランサー（ALB、CLB、NLB）、
# AWS Global Accelerator標準アクセラレーター、
# Amazon EC2 Elastic IPアドレス、Amazon Route 53ホストゾーンです。
#
# AWS公式ドキュメント:
#   - AWS ShieldとShield Advancedの仕組み: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-overview.html
#   - Shield Advancedが保護するAWSリソースの一覧: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-advanced-summary-protected-resources.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection
#
# Provider Version: 6.28.0
# Generated: 2026-02-08
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_shield_protection" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Shield Advanced保護のフレンドリーな名前を指定します。
  # 設定可能な値: 任意の文字列
  # 注意: 保護を識別するための名前です。AWSコンソールやAPIで参照時に使用されます。
  name = "example-protection"

  # resource_arn (Required)
  # 設定内容: 保護対象のAWSリソースのARN（Amazon Resource Name）を指定します。
  # 設定可能な値: 以下のリソースタイプの有効なARN
  #   - Amazon CloudFrontディストリビューション: arn:aws:cloudfront::account-id:distribution/distribution-id
  #   - Application Load Balancer: arn:aws:elasticloadbalancing:region:account-id:loadbalancer/app/...
  #   - Classic Load Balancer: arn:aws:elasticloadbalancing:region:account-id:loadbalancer/...
  #   - Network Load Balancer: arn:aws:elasticloadbalancing:region:account-id:loadbalancer/net/...
  #   - AWS Global Accelerator標準アクセラレーター: arn:aws:globalaccelerator::account-id:accelerator/accelerator-id
  #   - Amazon EC2 Elastic IPアドレス: arn:aws:ec2:region:account-id:eip-allocation/allocation-id
  #   - Amazon Route 53ホストゾーン: arn:aws:route53:::hostedzone/hosted-zone-id
  # 関連機能: AWS Shield Advanced 保護対象リソース
  #   Shield Advancedで保護を有効にしたリソースに対して、DDoS攻撃の高度な検出と
  #   緩和が行われます。保護はリソースごとに明示的に指定する必要があります。
  #   Shield Advancedは自動的にリソースを保護しません。
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/ddos-advanced-summary-protected-resources.html
  # 注意: リソースは事前に存在している必要があります。
  #       また、AWS Shield Advancedのサブスクリプションが有効である必要があります。
  resource_arn = "arn:aws:ec2:ap-northeast-1:123456789012:eip-allocation/eipalloc-0123456789abcdef0"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-protection"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Shield Advanced保護オブジェクトの一意の識別子（ID）
#
# - arn: Shield Advanced保護のAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
