# ==============================================================================
# AWS Route 53 Resolver DNSSEC Configuration
# ==============================================================================
# Route 53 Resolver DNSSEC設定は、VPCのDNSSEC検証を有効化・管理します
#
# 【DNSSECとは】
# - DNS Security Extensions（DNSSEC）は、DNSレスポンスの真正性を検証する仕組み
# - DNSスプーフィングやキャッシュポイズニング攻撃からの保護を提供
# - パブリックDNS名に対する再帰的DNS解決時にVPC Resolverが適用
#
# 【主な用途】
# - VPCからのDNSクエリのセキュリティ強化
# - DNS応答の改ざん検出
# - コンプライアンス要件の満たす暗号化検証
#
# 【重要な注意点】
# - DNSSEC検証の有効化はDNS解決に影響を与える可能性があり、中断が発生する場合がある
# - 他のDNSリゾルバーへクエリを転送する場合、そのリゾルバーもDNSSEC検証を適用する必要がある
# - VPC Resolverは自身でのDNSSEC検証は現在サポートしていない（DNSSEC OKおよびChecking Disabledビットは無視される）
# - 有効化・無効化には数分かかる
#
# 【セキュリティベストプラクティス】
# - 特定のセキュリティ要件やコンプライアンス要件がある組織に推奨
# - DNS Firewallルールと組み合わせて使用し、多層防御を実現
# - CloudWatchアラームを設定してDNSSEC検証エラーを監視
# - DNS zone walking攻撃に注意（エンドポイントがスロットリングされた場合はAWSサポートに連絡）
#
# 【関連リソース】
# - aws_vpc: DNSSEC検証を有効化するVPC
# - aws_route53_hosted_zone_dnssec: ホストゾーンのDNSSEC署名設定（別リソース）
# - aws_route53_resolver_rule: Resolver転送ルール
# - aws_route53_resolver_firewall_rule_group: DNS Firewallルールグループ
#
# 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_dnssec_config
# ==============================================================================

resource "aws_route53_resolver_dnssec_config" "example" {
  # --------------------------------------------------------------------------
  # 必須パラメータ
  # --------------------------------------------------------------------------

  # resource_id (必須)
  # - DNSSEC検証ステータスを更新する仮想プライベートクラウド（VPC）のID
  # - VPCは DNS support と DNS hostnames を有効化する必要がある
  # - 一つのVPCに対して一つのDNSSEC設定のみ作成可能
  # - Type: string
  # - 例: vpc-0123456789abcdef0
  resource_id = aws_vpc.example.id

  # --------------------------------------------------------------------------
  # オプションパラメータ
  # --------------------------------------------------------------------------

  # region (オプション)
  # - このリソースが管理されるリージョン
  # - プロバイダー設定のリージョンがデフォルト値となる
  # - 異なるリージョンのVPCに対してDNSSEC設定を管理する場合に指定
  # - Type: string
  # - 例: us-east-1, ap-northeast-1
  # region = "us-east-1"

  # --------------------------------------------------------------------------
  # Computed Attributes（読み取り専用）
  # --------------------------------------------------------------------------
  # これらの属性は作成後に参照可能です：
  #
  # - arn
  #   DNSSEC検証設定のARN
  #   例: arn:aws:route53resolver:us-east-1:123456789012:resolver-dnssec-config/rdc-0123456789abcdef0
  #
  # - id
  #   DNSSEC検証設定のID（resource_idと同じ値）
  #
  # - owner_id
  #   DNSSEC検証設定のVPCを所有するアカウントID
  #   例: 123456789012
  #
  # - validation_status
  #   DNSSEC設定の検証ステータス
  #   取りうる値:
  #   - ENABLING: DNSSEC検証を有効化中
  #   - ENABLED: DNSSEC検証が有効
  #   - DISABLING: DNSSEC検証を無効化中
  #   - DISABLED: DNSSEC検証が無効（デフォルト）
  #   - UPDATING_TO_USE_LOCAL_RESOURCE_SETTING: ローカルリソース設定を使用するように更新中
  #   - USE_LOCAL_RESOURCE_SETTING: ローカルリソース設定を使用
  #
  # --------------------------------------------------------------------------
  # 使用例での参照方法
  # --------------------------------------------------------------------------
  # ARNを参照: aws_route53_resolver_dnssec_config.example.arn
  # 検証ステータスを参照: aws_route53_resolver_dnssec_config.example.validation_status
}

# ==============================================================================
# 前提条件リソースの例
# ==============================================================================

# VPCリソースの例（DNSSEC検証を有効化するVPC）
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  # DNSSECを使用するにはこれらの設定が必要
  enable_dns_support   = true # DNS解決を有効化
  enable_dns_hostnames = true # DNSホスト名を有効化

  tags = {
    Name = "dnssec-enabled-vpc"
  }
}

# ==============================================================================
# 使用パターン例
# ==============================================================================

# パターン1: 基本的なDNSSEC検証設定
# - 単一VPCでのDNSSEC検証有効化
# - 最もシンプルな設定
resource "aws_route53_resolver_dnssec_config" "basic" {
  resource_id = aws_vpc.main.id
}

# パターン2: 特定リージョンでのDNSSEC検証設定
# - プロバイダーとは異なるリージョンで管理する場合
# - マルチリージョン構成で有用
resource "aws_route53_resolver_dnssec_config" "specific_region" {
  resource_id = aws_vpc.us_east_1.id
  region      = "us-east-1"
}

# パターン3: CloudWatchアラームと連携したDNSSEC監視
# - DNSSEC検証の状態変化を監視
# - validation_statusを使用した条件分岐
resource "aws_route53_resolver_dnssec_config" "monitored" {
  resource_id = aws_vpc.production.id
}

# validation_statusを条件として使用する例
output "dnssec_enabled" {
  description = "DNSSEC検証が完全に有効化されているかどうか"
  value       = aws_route53_resolver_dnssec_config.monitored.validation_status == "ENABLED"
}

# ==============================================================================
# セキュリティ考慮事項
# ==============================================================================

# 1. DNSSEC検証有効化前の準備
#    - CloudWatchアラームを設定してエラー通知を受け取る
#    - 親DNSゾーンがDSレコードをサポートしているか確認
#    - 段階的にロールアウト（テスト環境 -> 本番環境）

# 2. 影響範囲の理解
#    - VPC内のすべてのDNSクエリに影響
#    - DNSSEC署名のないドメインへのクエリは影響を受けない
#    - 不正なDNSSEC署名の場合はSERVFAILエラーを返す

# 3. DNS Firewallとの併用
#    - DNSSEC検証と併せてDNS Firewallを使用し、悪意のあるドメインをブロック
#    - Route 53 Resolver DNS Firewall Advancedで高度な脅威検出を実現

# 4. ログとモニタリング
#    - Route 53 Resolver query loggingを有効化してDNSトラフィックを可視化
#    - DNSSEC検証失敗のパターンを分析し、セキュリティルールを調整

# ==============================================================================
# トラブルシューティング
# ==============================================================================

# 問題: DNSSEC検証有効化後にDNS解決が失敗する
# 原因: 対象ドメインのDNSSEC設定が不正、またはDNS Firewallがブロックしている
# 対策:
# - query loggingを確認し、失敗しているドメインを特定
# - dig +dnssec コマンドで外部からDNSSEC検証を確認
# - 一時的に無効化して問題の切り分けを実施

# 問題: validation_statusがENABLINGのまま進まない
# 原因: VPCの設定が不完全、またはAWS側の問題
# 対策:
# - VPCのenable_dns_supportとenable_dns_hostnamesがtrueであることを確認
# - 数分待機（通常5-10分で完了）
# - AWSサポートに連絡

# 問題: DNS zone walking攻撃によるスロットリング
# 原因: 攻撃者がDNSSEC署名済みゾーンからすべてのコンテンツを取得しようとしている
# 対策:
# - Route 53 Resolver endpointのスロットリングメトリクスを監視
# - AWSサポートに連絡して対策を相談

# ==============================================================================
# コスト最適化
# ==============================================================================

# DNSSEC検証自体に追加コストはかかりませんが、関連するコストに注意：
# - Route 53 Resolver query logging: クエリログの保存コスト（CloudWatch Logs/S3/Kinesis Data Firehose）
# - DNS Firewall: ルールグループとドメインリストの数に応じた料金
# - CloudWatch Alarms: アラームの数に応じた料金

# ==============================================================================
# 参考リンク
# ==============================================================================
# - DNSSEC検証の有効化ガイド:
#   https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dnssec-validation.html
# - DNSSEC署名設定（ホストゾーン用）:
#   https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec.html
# - Route 53 Resolver DNS Firewall:
#   https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall.html
# - VPC Resolverのベストプラクティス:
#   https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/best-practices-resolver.html
