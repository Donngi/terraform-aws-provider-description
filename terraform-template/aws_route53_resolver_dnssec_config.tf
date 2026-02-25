#---------------------------------------------------------------
# AWS Route53 Resolver DNSSEC Config
#---------------------------------------------------------------
#
# Route53 Resolver DNSSEC Configは、VPCに関連付けられたRoute53 Resolverの
# DNSSEC検証を有効または無効にするリソースです。
# DNSSEC（DNS Security Extensions）を有効化することで、DNSレスポンスの
# 真正性と完全性を検証し、DNSスプーフィングやキャッシュポイズニング攻撃を防ぎます。
#
# ユースケース:
#   - セキュリティポリシーに基づくDNSSEC検証の強制
#   - DNS応答の改ざんやなりすましを防ぐセキュリティ強化
#   - コンプライアンス要件によるDNS通信の完全性保護
#
# 重要な制約:
#   - VPCごとに1つのDNSSEC設定のみ作成可能です
#   - 設定変更はENABLING/DISABLINGの中間状態を経て完了します
#   - プライベートホストゾーンのDNSSEC検証には対応していません
#   - DNSSEC検証が有効な場合、署名されていないDNSレスポンスは拒否されます
#
# AWS公式ドキュメント:
#   - DNSSEC検証の概要: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dnssec-validation.html
#   - DNSSEC検証の有効化: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dnssec-validation-enable.html
#   - UpdateResolverDnssecConfig API: https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53resolver_UpdateResolverDnssecConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_dnssec_config
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_resolver_dnssec_config" "example" {
  #-------------------------------------------------------------
  # 基本設定 (Required)
  #-------------------------------------------------------------

  # resource_id (Required)
  # 設定内容: DNSSEC検証を有効化するVPCのIDを指定します。
  # 設定可能な値: VPCのID文字列（例: "vpc-0123456789abcdef0"）
  # 省略時: 設定必須のため省略不可
  # 制約事項:
  #   - 指定するVPCは同一リージョン内に存在する必要があります
  #   - 1つのVPCに対して1つのDNSSEC設定のみ作成可能です
  # 用途:
  #   - DNSSEC検証を有効にする対象VPCを特定します
  #   - 通常はaws_vpcリソースのidを参照します
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dnssec-validation.html
  resource_id = aws_vpc.example.id

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 制約事項:
  #   - 指定するVPCと同じリージョンを指定する必要があります
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: DNSSEC設定のID
#       形式: Route53 Resolverによって自動生成される一意な識別子
#
# - arn: DNSSEC設定のAmazon Resource Name (ARN)
#       形式: arn:aws:route53resolver:{region}:{account-id}:resolver-dnssec-config/{id}
#       用途: IAMポリシーやリソースベースのポリシーで使用
#
# - owner_id: VPCを所有するアカウントのID
#       説明: VPCのオーナーアカウントIDが返されます
#
# - validation_status: DNSSEC検証の現在のステータス
#       設定可能な値: "ENABLING", "ENABLED", "DISABLING", "DISABLED"
#       説明: 設定変更は中間状態を経て完了します
#
