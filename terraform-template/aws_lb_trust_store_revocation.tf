#---------------------------------------------------------------
# AWS Load Balancer Trust Store Revocation
#---------------------------------------------------------------
#
# ELBv2 (Elastic Load Balancing v2) の Trust Store に対して、クライアント証明書の
# 失効リスト (CRL: Certificate Revocation List) を設定するリソースです。
# Application Load Balancer で mTLS (mutual TLS) 認証を行う際に、
# 失効した証明書を持つクライアントからの接続を拒否するために使用します。
#
# Trust Store は ALB Listener で使用する CA 証明書バンドルを管理し、
# このリソースは失効した証明書のリストを S3 バケットから読み込んで
# Trust Store に追加します。
#
# AWS公式ドキュメント:
#   - mTLS 認証の概要: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/mutual-authentication.html
#   - Trust Store の管理: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/mutual-authentication-trust-stores.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_trust_store_revocation
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_trust_store_revocation" "example" {
  #-------------------------------------------------------------
  # Trust Store 設定
  #-------------------------------------------------------------

  # trust_store_arn (Required)
  # 設定内容: 失効リストを追加する Trust Store の ARN を指定します。
  # 設定可能な値: aws_lb_trust_store リソースの ARN
  # 注意: Trust Store は事前に作成されている必要があります。
  # 参考: aws_lb_trust_store リソースで作成した Trust Store を参照します。
  trust_store_arn = aws_lb_trust_store.example.arn

  #-------------------------------------------------------------
  # 失効リスト (CRL) の S3 設定
  #-------------------------------------------------------------

  # revocations_s3_bucket (Required)
  # 設定内容: 証明書失効リスト (CRL) を格納している S3 バケット名を指定します。
  # 設定可能な値: 有効な S3 バケット名
  # 注意:
  #   - S3 バケットは ALB と同じリージョンに存在する必要があります。
  #   - ALB サービスがバケットにアクセスできるよう、適切なバケットポリシーが必要です。
  #   - CRL ファイルは PEM 形式である必要があります。
  revocations_s3_bucket = "my-alb-trust-store-revocations"

  # revocations_s3_key (Required)
  # 設定内容: S3 バケット内の CRL ファイルのオブジェクトキー (パス) を指定します。
  # 設定可能な値: S3 オブジェクトキー
  # 注意:
  #   - ファイルは PEM 形式の CRL である必要があります。
  #   - 最大サイズは 375,000 バイトです。
  # 例: "crl/client-crl.pem" または "trust-store/revocations/crl.pem"
  revocations_s3_key = "crl/client-crl.pem"

  # revocations_s3_object_version (Optional)
  # 設定内容: S3 バケットのバージョニングが有効な場合、使用する CRL ファイルの
  #           バージョン ID を指定します。
  # 設定可能な値: S3 オブジェクトのバージョン ID
  # 省略時: 最新バージョンが使用されます。
  # 注意:
  #   - S3 バケットでバージョニングが有効な場合に使用できます。
  #   - 特定のバージョンを固定したい場合に指定します。
  revocations_s3_object_version = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Trust Store、S3 バケット、ALB は同じリージョンに存在する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Trust Store ARN と RevocationId の組み合わせ
#       フォーマット: ${trust_store_arn},{revocation_id}
#
# - revocation_id: AWS が割り当てた失効リスト ID (数値)
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: Trust Store と Revocation の完全な設定
#---------------------------------------------------------------
#
# resource "aws_lb_trust_store" "example" {
#   name = "my-trust-store"
#
#   ca_certificates_bundle_s3_bucket = "my-alb-trust-store-ca"
#   ca_certificates_bundle_s3_key    = "ca/ca-bundle.pem"
# }
#
# resource "aws_lb_trust_store_revocation" "example" {
#   trust_store_arn = aws_lb_trust_store.example.arn
#
#   revocations_s3_bucket = "my-alb-trust-store-revocations"
#   revocations_s3_key    = "crl/client-crl.pem"
# }
#
# resource "aws_lb_listener" "example" {
#   load_balancer_arn = aws_lb.example.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
#   certificate_arn   = aws_acm_certificate.example.arn
#
#   mutual_authentication {
#     mode            = "verify"
#     trust_store_arn = aws_lb_trust_store.example.arn
#   }
#
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.example.arn
#   }
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# S3 バケットポリシーの例
#---------------------------------------------------------------
# ALB サービスが S3 バケットにアクセスできるようにするためのポリシー例:
#
# resource "aws_s3_bucket_policy" "revocations" {
#   bucket = aws_s3_bucket.revocations.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowELBServiceToReadCRL"
#         Effect = "Allow"
#         Principal = {
#           Service = "elasticloadbalancing.amazonaws.com"
#         }
#         Action = [
#           "s3:GetObject",
#           "s3:GetObjectVersion"
#         ]
#         Resource = "${aws_s3_bucket.revocations.arn}/*"
#       }
#     ]
#   })
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# CRL ファイルの要件
#---------------------------------------------------------------
# - ファイル形式: PEM 形式 (Privacy Enhanced Mail)
# - 最大サイズ: 375,000 バイト
# - エンコーディング: UTF-8
# - ファイル拡張子: .pem、.crl などが一般的
#
# CRL ファイルは以下のような構造になります:
# -----BEGIN X509 CRL-----
# (Base64 エンコードされた CRL データ)
# -----END X509 CRL-----
#
# CRL には失効した証明書のシリアル番号と失効日時が含まれます。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 運用上の考慮事項
#---------------------------------------------------------------
# 1. CRL の更新
#    - CRL は定期的に更新する必要があります（通常は日次または週次）
#    - S3 に新しい CRL をアップロードすると、ALB は自動的に更新を検知します
#
# 2. 複数の CRL
#    - 1 つの Trust Store に複数の Revocation リソースを追加できます
#    - 異なる CA の CRL を個別に管理する場合に有効です
#
# 3. mTLS 認証との統合
#    - Trust Store に CA 証明書バンドルが設定されている必要があります
#    - Listener で mutual_authentication を設定する必要があります
#    - mode を "verify" に設定すると、CRL チェックが有効になります
#
# 4. モニタリング
#    - CloudWatch メトリクスで失効証明書による接続拒否を監視できます
#    - ALB アクセスログで失敗した mTLS 認証を追跡できます
#
# 5. パフォーマンス
#    - CRL が大きくなると、証明書検証のパフォーマンスに影響する可能性があります
#    - OCSP (Online Certificate Status Protocol) の使用も検討してください
#---------------------------------------------------------------
