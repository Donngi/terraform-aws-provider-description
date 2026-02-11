#---------------------------------------------------------------
# Amazon VPC Lattice Domain Verification
#
# VPC Lattice のカスタムドメイン名の所有権を検証するリソースです。
# カスタムドメインを VPC Lattice リソースに関連付ける前に、
# ドメイン所有権の検証プロセスを開始します。
# DNS に TXT レコードを追加して所有権を証明します。
#
# AWS Documentation:
# https://docs.aws.amazon.com/vpc-lattice/latest/ug/create-and-verify.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpclattice_domain_verification
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
#
# NOTE: このテンプレートは参考例です。実際の環境に応じて
# 設定値を調整してください。
#---------------------------------------------------------------

resource "aws_vpclattice_domain_verification" "example" {
  #-------------------------------------------------------------
  # Required Settings
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: 所有権を検証するドメイン名
  # 設定可能な値: 完全修飾ドメイン名（FQDN）（3～255文字）
  # 省略時: 必須のため省略不可
  # 関連機能: Custom Domain Names - https://aws.amazon.com/blogs/networking-and-content-delivery/custom-domain-names-for-vpc-lattice-resources/
  domain_name = "example.com"

  #-------------------------------------------------------------
  # Optional Settings
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: リソースを管理するリージョン
  # 設定可能な値: AWS リージョンコード（us-east-1、ap-northeast-1 など）
  # 省略時: プロバイダー設定のリージョン
  # 関連機能: AWS Regions - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "ap-northeast-1"

  #-------------------------------------------------------------
  # Tagging
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし（プロバイダーの default_tags は適用される）
  # 関連機能: AWS Resource Tagging - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-domain-verification"
    Environment = "production"
    Purpose     = "domain-verification"
  }

  # tags_all は computed なので設定不要
  # provider の default_tags と tags がマージされた結果
}

#---------------------------------------------------------------
# DNS TXT Record Example
#
# ドメイン検証を完了するには、DNS に TXT レコードを追加する必要があります。
# Route 53 を使用する場合の例:
#---------------------------------------------------------------

# resource "aws_route53_record" "domain_verification" {
#   zone_id = aws_route53_zone.example.zone_id
#   name    = aws_vpclattice_domain_verification.example.txt_record_name
#   type    = "TXT"
#   ttl     = 300
#   records = [aws_vpclattice_domain_verification.example.txt_record_value]
# }

#---------------------------------------------------------------
# Attributes Reference
#
# 以下の属性は Terraform によって自動的に設定されます（computed-only）
#
# - id: ドメイン検証の ID（20文字固定長）
#   例: dv-0123456789abcdef0
# - arn: ドメイン検証の ARN
#   例: arn:aws:vpc-lattice:ap-northeast-1:123456789012:domainverification/dv-0123456789abcdef0
# - created_at: ドメイン検証が作成された日時（ISO-8601 形式）
#   例: 2026-02-09T12:34:56Z
# - last_verified_time: ドメインが最後に正常に検証された日時（ISO-8601 形式）
#   例: 2026-02-09T13:00:00Z
# - status: ドメイン検証プロセスの現在のステータス
#   値: VERIFIED（検証済み）、PENDING（保留中）、VERIFICATION_TIMED_OUT（タイムアウト）
# - txt_record_name: ドメイン検証のために作成する必要がある TXT レコードの名前
#   例: _vpc-lattice-challenge.example.com
# - txt_record_value: TXT レコードに追加する必要がある値
#   例: vpc-lattice-challenge-abc123def456
#
# 参照例:
# output "txt_record_for_dns" {
#   value = {
#     name  = aws_vpclattice_domain_verification.example.txt_record_name
#     value = aws_vpclattice_domain_verification.example.txt_record_value
#---------------------------------------------------------------
