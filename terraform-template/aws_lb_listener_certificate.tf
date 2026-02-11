# ========================================
# Resource: aws_lb_listener_certificate
# ========================================
# Provider Version: 6.28.0
# Resource Type: aws_lb_listener_certificate
# Description: Provides a Load Balancer Listener Certificate resource.
#
# このリソースは追加の証明書用であり、リスナーのデフォルト証明書を置き換えるものではありません。
# デフォルト証明書はaws_lb_listenerリソースで設定します。
#
# Note: aws_alb_listener_certificateはaws_lb_listener_certificateとして知られています。
# 機能は同一です。
#
# AWS Documentation:
# - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/https-listener-certificates.html
# - https://docs.aws.amazon.com/elasticloadbalancing/latest/network/tls-listener-certificates.html
# - https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_AddListenerCertificates.html
#
# Use Cases:
# - Application Load BalancerまたはNetwork Load Balancerの単一HTTPSリスナーで複数ドメインをサポート
# - SNI (Server Name Indication)を使用して、同一ポートで異なるSSL/TLS証明書を提供
# - マルチテナントアプリケーションで各テナントに異なる証明書を提供
# - 複数のカスタムドメインに対応するためにリスナーに追加証明書を関連付け
#
# ========================================

resource "aws_lb_listener_certificate" "example" {
  # ========================================
  # Required Arguments
  # ========================================

  # listener_arn - (Required, Forces New Resource)
  # Type: string
  # Description: 証明書をアタッチするリスナーのARN
  #
  # このARNはHTTPSリスナー(Application Load Balancer)またはTLSリスナー(Network Load Balancer)を
  # 指している必要があります。リスナーには既にデフォルト証明書が設定されている必要があります。
  #
  # この値を変更すると、リソースが再作成されます。
  #
  # Example:
  # listener_arn = "arn:aws:elasticloadbalancing:us-west-2:123456789012:listener/app/my-load-balancer/50dc6c495c0c9188/f2f7dc8efc522ab2"
  # listener_arn = aws_lb_listener.front_end.arn
  #
  listener_arn = aws_lb_listener.front_end.arn

  # certificate_arn - (Required, Forces New Resource)
  # Type: string
  # Description: リスナーにアタッチする証明書のARN
  #
  # この証明書はAWS Certificate Manager (ACM)で作成された証明書、またはIAMにインポートされた証明書である
  # 必要があります。ACMの使用が推奨されます(自動更新のサポートとElastic Load Balancingとの統合)。
  #
  # 証明書のドメイン名は、保護したいカスタムドメイン名レコードと一致する必要があります。
  # ワイルドカード証明書(例: *.example.com)を使用して、同一ドメイン内の複数のサブドメインを保護できます。
  #
  # この値を変更すると、リソースが再作成されます。
  #
  # サポートされる証明書タイプ:
  # - RSAキー (2048ビット、4096ビット)
  # - ECDSA (Elliptic Curve Digital Signature Algorithm)
  #
  # 注意: 証明書には有効期限があります。ACM証明書は自動的に更新されますが、
  # インポートされた証明書は手動で監視および更新する必要があります。
  #
  # Example:
  # certificate_arn = "arn:aws:acm:us-west-2:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  # certificate_arn = aws_acm_certificate.example.arn
  #
  certificate_arn = aws_acm_certificate.example.arn

  # ========================================
  # Optional Arguments
  # ========================================

  # region - (Optional)
  # Type: string
  # Default: プロバイダー設定のリージョン
  # Description: このリソースが管理されるリージョン
  #
  # 通常、プロバイダーレベルで設定されたリージョンがデフォルトで使用されます。
  # マルチリージョン構成で明示的に指定する場合にのみ使用します。
  #
  # Example:
  # region = "us-west-2"
  #
  # region = "us-west-2"

  # ========================================
  # Attributes Reference
  # ========================================
  # 以下の属性がエクスポートされ、他のリソースで参照可能です:
  #
  # id - リスナーARNと証明書ARNをアンダースコア(_)で区切った文字列
  #      Format: "<listener_arn>_<certificate_arn>"
  #

  # ========================================
  # Import
  # ========================================
  # Load Balancer Listener Certificatesは以下の形式でインポートできます:
  # terraform import aws_lb_listener_certificate.example <listener_arn>_<certificate_arn>
  #
  # Example:
  # terraform import aws_lb_listener_certificate.example \
  #   arn:aws:elasticloadbalancing:us-west-2:123456789012:listener/app/my-load-balancer/50dc6c495c0c9188/f2f7dc8efc522ab2_arn:aws:acm:us-west-2:123456789012:certificate/12345678-1234-1234-1234-123456789012
  #

  # ========================================
  # Dependencies & Lifecycle
  # ========================================
  # このリソースは以下に依存します:
  # - aws_lb_listener (リスナーが先に存在する必要があります)
  # - aws_acm_certificate または IAMにインポートされた証明書
  #
  # lifecycle {
  #   create_before_destroy = true  # 証明書更新時のダウンタイムを防ぐ
  # }

  # ========================================
  # Notes & Best Practices
  # ========================================
  # 1. デフォルト証明書との関係:
  #    - このリソースは「追加」証明書用です
  #    - リスナーのデフォルト証明書はaws_lb_listenerで設定します
  #    - SNIを使用しないクライアントにはデフォルト証明書が提供されます
  #
  # 2. スマート証明書選択アルゴリズム:
  #    ロードバランサーは以下の基準で最適な証明書を選択します:
  #    - 公開鍵アルゴリズム
  #    - ハッシュアルゴリズム
  #    - キー長
  #    - 有効期間
  #
  # 3. 証明書の制限:
  #    - リスナーあたり最大25個の証明書(デフォルト証明書を含む)
  #    - この制限に達すると、TooManyCertificatesエラーが発生します
  #
  # 4. 証明書の更新:
  #    - ACM証明書: 有効期限の60日前から自動更新が開始されます
  #    - インポート証明書: 手動で更新する必要があります
  #    - 証明書の更新・置換は、インフライトのリクエストに影響しません
  #
  # 5. セキュリティのベストプラクティス:
  #    - AWS Certificate Manager (ACM)の使用を推奨
  #    - 強力なキーアルゴリズムを使用 (RSA 2048ビット以上、またはECDSA)
  #    - 証明書の有効期限を定期的に監視
  #    - ワイルドカード証明書の使用を検討(複数のサブドメインを保護)
  #
  # 6. マルチドメインのサポート:
  #    - 同一リスナーで複数のドメインをサポートするために複数の証明書を追加できます
  #    - SNI (Server Name Indication)により、クライアントが要求したホスト名に基づいて
  #      適切な証明書が選択されます
  #
  # 7. エラーハンドリング:
  #    - CertificateNotFound: 指定された証明書が存在しません
  #    - ListenerNotFound: 指定されたリスナーが存在しません
  #    - TooManyCertificates: リスナーあたりの証明書数の上限に達しました
  #
}

# ========================================
# Complete Example: Multi-Domain HTTPS Setup
# ========================================
# 以下は、Application Load Balancerで複数ドメインをサポートする完全な例です

# ACM証明書の作成
resource "aws_acm_certificate" "example" {
  domain_name       = "example.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# 追加ドメイン用のACM証明書
resource "aws_acm_certificate" "additional" {
  domain_name       = "another-example.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Application Load Balancer
resource "aws_lb" "front_end" {
  name               = "front-end-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-12345678", "subnet-87654321"]

  enable_deletion_protection = false
}

# ターゲットグループ
resource "aws_lb_target_group" "front_end" {
  name     = "front-end-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-12345678"
}

# HTTPSリスナー(デフォルト証明書付き)
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.example.arn  # デフォルト証明書

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}

# 追加証明書のアタッチ(SNI用)
resource "aws_lb_listener_certificate" "example" {
  listener_arn    = aws_lb_listener.front_end.arn
  certificate_arn = aws_acm_certificate.additional.arn
}

# ========================================
# Advanced Example: Multiple Additional Certificates
# ========================================
# 複数の追加証明書を管理する例

variable "additional_domains" {
  type = map(string)
  default = {
    "domain1" = "www.example.com"
    "domain2" = "api.example.com"
    "domain3" = "admin.example.com"
  }
}

# 各ドメイン用の証明書を作成
resource "aws_acm_certificate" "multi_domain" {
  for_each = var.additional_domains

  domain_name       = each.value
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = each.key
    Domain      = each.value
    Environment = "production"
  }
}

# 各証明書をリスナーにアタッチ
resource "aws_lb_listener_certificate" "multi_domain" {
  for_each = aws_acm_certificate.multi_domain

  listener_arn    = aws_lb_listener.front_end.arn
  certificate_arn = each.value.arn

  # 証明書更新時のダウンタイムを防ぐ
  lifecycle {
    create_before_destroy = true
  }
}
