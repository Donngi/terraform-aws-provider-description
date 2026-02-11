################################################################################
# AWS Redshift Serverless Custom Domain Association
################################################################################
# リソース概要:
#   Amazon Redshift Serverless ワークグループにカスタムドメイン名を関連付けるための
#   リソースです。ACM証明書を使用してカスタムドメインを設定し、デフォルトのエンド
#   ポイントの代わりに独自のドメイン名でRedshift Serverlessに接続できるようにします。
#
# ユースケース:
#   - ワークグループに独自のドメイン名（例: analytics.example.com）を割り当て
#   - SSL証明書による安全な接続の確立
#   - ブランド化されたエンドポイントの提供
#   - sslmode=verify-full での接続（カスタムドメインでのみ機能）
#
# 前提条件:
#   - AWS Certificate Manager (ACM) で検証済みの証明書が必要
#   - Redshift Serverless ワークグループが作成済みであること
#   - DNS に CNAME レコードを作成する必要がある
#   - 必要な IAM 権限: redshiftServerless:CreateCustomDomainAssociation, acm:DescribeCertificate
#
# 注意事項:
#   - カスタムドメイン関連付けの変更後、接続まで最大30秒の遅延が発生する可能性があります
#   - sslmode=verify-full はカスタムドメインでのみ動作し、デフォルトエンドポイントでは使用できません
#   - デフォルトエンドポイントには他の SSL モード（sslmode=verify-ca など）を使用できます
#
# 参考ドキュメント:
#   - Terraform: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_custom_domain_association
#   - AWS API: https://docs.aws.amazon.com/redshift-serverless/latest/APIReference/API_CreateCustomDomainAssociation.html
#   - カスタムドメイン設定: https://docs.aws.amazon.com/redshift/latest/mgmt/connecting-connection-CNAME-create-custom-domain.html
################################################################################

resource "aws_redshiftserverless_custom_domain_association" "example" {
  # ワークグループ名（必須）
  # Redshift Serverless ワークグループの名前を指定します。
  # このワークグループにカスタムドメインが関連付けられます。
  #
  # 例: "my-analytics-workgroup", "production-workgroup"
  workgroup_name = aws_redshiftserverless_workgroup.example.workgroup_name

  # カスタムドメイン名（必須）
  # ワークグループに関連付けるカスタムドメイン名を指定します。
  # このドメインに対して DNS の CNAME レコードを設定する必要があります。
  #
  # 形式: 完全修飾ドメイン名（FQDN）
  # 例: "analytics.example.com", "redshift.mycompany.com"
  #
  # 注意: ドメインの DNS 設定で、このカスタムドメインから Redshift Serverless の
  #      デフォルトエンドポイントへの CNAME レコードを作成する必要があります。
  custom_domain_name = "analytics.example.com"

  # カスタムドメイン証明書 ARN（必須）
  # AWS Certificate Manager (ACM) で管理される証明書の ARN を指定します。
  # この証明書は、custom_domain_name に対して検証済みである必要があります。
  #
  # 形式: arn:aws:acm:<region>:<account-id>:certificate/<certificate-id>
  # 例: "arn:aws:acm:us-east-1:123456789012:certificate/abcd1234-5678-90ef-ghij-klmnopqrstuv"
  #
  # 要件:
  #   - 証明書は custom_domain_name と一致する必要があります
  #   - 証明書は検証済み（Issued）状態である必要があります
  #   - ワイルドカード証明書も使用可能（例: *.example.com）
  custom_domain_certificate_arn = aws_acm_certificate.example.arn

  # リージョン（オプション）
  # このリソースを管理するリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のデフォルトリージョンが使用されます。
  #
  # 例: "us-east-1", "ap-northeast-1"
  #
  # 注意: ACM 証明書も同じリージョンに存在する必要があります。
  # region = "us-east-1"
}

################################################################################
# 計算される属性（Computed Attributes）
################################################################################
# 以下の属性は Terraform によって自動的に設定され、読み取り専用です:
#
# - id
#   リソースの一意識別子
#   形式: <workgroup_name>,<custom_domain_name>
#
# - custom_domain_certificate_expiry_time
#   証明書の有効期限日時
#   形式: RFC3339 タイムスタンプ
#   例: "2025-12-31T23:59:59Z"
#   用途: 証明書の更新時期を把握するために使用
#
# これらの属性は output ブロックで参照できます:
# output "certificate_expiry" {
#   value = aws_redshiftserverless_custom_domain_association.example.custom_domain_certificate_expiry_time
# }

################################################################################
# 完全な使用例
################################################################################

# ACM 証明書の作成
resource "aws_acm_certificate" "example" {
  domain_name       = "analytics.example.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "redshift-serverless-cert"
  }
}

# DNS 検証レコード（Route 53 の例）
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.example.zone_id
}

# 証明書の検証待機
resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.example.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Redshift Serverless 名前空間
resource "aws_redshiftserverless_namespace" "example" {
  namespace_name = "example-namespace"

  tags = {
    Name = "example-namespace"
  }
}

# Redshift Serverless ワークグループ
resource "aws_redshiftserverless_workgroup" "example" {
  workgroup_name = "example-workgroup"
  namespace_name = aws_redshiftserverless_namespace.example.namespace_name

  tags = {
    Name = "example-workgroup"
  }
}

# カスタムドメイン関連付け
# resource "aws_redshiftserverless_custom_domain_association" "example" {
#   workgroup_name                = aws_redshiftserverless_workgroup.example.workgroup_name
#   custom_domain_name            = "analytics.example.com"
#   custom_domain_certificate_arn = aws_acm_certificate_validation.example.certificate_arn
# }

# CNAME レコードの作成（カスタムドメインからワークグループエンドポイントへ）
resource "aws_route53_record" "custom_domain" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "analytics.example.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_redshiftserverless_workgroup.example.endpoint[0].address]
}

################################################################################
# 出力例
################################################################################

output "custom_domain_name" {
  description = "設定されたカスタムドメイン名"
  value       = aws_redshiftserverless_custom_domain_association.example.custom_domain_name
}

output "certificate_expiry_time" {
  description = "証明書の有効期限"
  value       = aws_redshiftserverless_custom_domain_association.example.custom_domain_certificate_expiry_time
}

output "workgroup_endpoint" {
  description = "ワークグループのエンドポイント（CNAME レコード設定用）"
  value       = aws_redshiftserverless_workgroup.example.endpoint[0].address
}

################################################################################
# トラブルシューティング
################################################################################
#
# 1. 証明書の検証エラー
#    - ACM 証明書が "Issued" 状態であることを確認
#    - DNS 検証レコードが正しく設定されていることを確認
#    - 証明書のドメイン名とカスタムドメイン名が一致していることを確認
#
# 2. 接続エラー
#    - CNAME レコードが正しく設定されているか確認
#    - DNS の伝播に時間がかかる場合があるため、最大30秒待機
#    - sslmode=verify-full を使用している場合は、カスタムドメインで接続していることを確認
#
# 3. IAM 権限エラー
#    - redshiftServerless:CreateCustomDomainAssociation 権限があることを確認
#    - acm:DescribeCertificate 権限があることを確認
#
# 4. 証明書の更新
#    - custom_domain_certificate_expiry_time を監視
#    - 証明書の期限切れ前に新しい証明書を作成し、関連付けを更新
#    - AWS Certificate Manager の自動更新機能の使用を推奨
#
################################################################################

################################################################################
# ベストプラクティス
################################################################################
#
# 1. 証明書管理
#    - ACM の自動更新機能を有効にする（DNS 検証方式を使用）
#    - 証明書の有効期限を監視するアラートを設定
#    - ワイルドカード証明書の使用を検討（複数のサブドメインに対応）
#
# 2. DNS 設定
#    - CNAME レコードの TTL を適切に設定（通常は300秒）
#    - DNS フェイルオーバー設定を検討
#    - Route 53 ヘルスチェックとの統合を検討
#
# 3. セキュリティ
#    - sslmode=verify-full を使用して完全な SSL 検証を実施
#    - 証明書の有効期限を定期的に確認
#    - アクセスログを有効にして監視
#
# 4. 高可用性
#    - マルチ AZ 構成を使用
#    - 定期的なバックアップの実施
#    - ディザスタリカバリ計画の策定
#
# 5. コスト最適化
#    - ACM 証明書は無料（パブリック証明書の場合）
#    - 不要なワークグループは停止または削除
#    - リソースタグを使用したコスト配分の追跡
#
################################################################################
