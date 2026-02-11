#---------------------------------------------------------------
# AWS Certificate Manager Certificate Validation
#---------------------------------------------------------------
#
# ACM証明書の検証プロセスが完了するのを待機するリソースです。
# aws_acm_certificateおよびaws_route53_record等の他のリソースと組み合わせて使用され、
# DNS検証またはメール検証による証明書の検証を実装し、検証が完了するまで待機します。
#
# 警告: このリソースは検証ワークフローの一部を実装するものです。
# AWS上の実際のエンティティを表すものではないため、このリソース単体の変更や
# 削除は即座に実質的な影響を与えません。
#
# AWS公式ドキュメント:
#   - ドメイン所有権の検証: https://docs.aws.amazon.com/acm/latest/userguide/domain-ownership-validation.html
#   - DNS検証: https://docs.aws.amazon.com/acm/latest/userguide/dns-validation.html
#   - メール検証: https://docs.aws.amazon.com/acm/latest/userguide/email-validation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_acm_certificate_validation" "example" {
  #-------------------------------------------------------------
  # 証明書設定
  #-------------------------------------------------------------

  # certificate_arn (Required)
  # 設定内容: 検証対象のACM証明書のARNを指定します。
  # 設定可能な値: 有効なACM証明書のARN
  # 用途: aws_acm_certificateリソースで作成された証明書のARNを指定し、
  #       その証明書の検証が完了するまでTerraformの実行を待機させます。
  # 関連機能: AWS Certificate Manager 証明書検証
  #   ACMは証明書を発行する前に、証明書リクエストで指定された全てのドメイン名を
  #   所有または管理していることを証明する必要があります。
  #   - https://docs.aws.amazon.com/acm/latest/userguide/domain-ownership-validation.html
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # DNS検証設定
  #-------------------------------------------------------------

  # validation_record_fqdns (Optional)
  # 設定内容: 検証を実装するFQDN（完全修飾ドメイン名）のリストを指定します。
  # 設定可能な値: 文字列のセット（DNS検証レコードのFQDN）
  # 用途: DNS検証メソッドを使用するACM証明書でのみ有効です。
  #       これを設定することで、リソースは追加の健全性チェックを実装でき、
  #       検証を実装しているリソース（例: aws_route53_record）への
  #       明示的な依存関係を持つことができます。
  # 関連機能: AWS Certificate Manager DNS検証
  #   DNS検証では、ACMがCNAMEレコードを提供し、それをDNSデータベースに追加することで
  #   ドメイン所有権を証明します。Route 53を使用している場合は自動的にレコードを
  #   作成でき、DNS検証された証明書は使用中かつDNSレコードが存在する限り自動更新されます。
  #   - https://docs.aws.amazon.com/acm/latest/userguide/dns-validation.html
  # 注意: メール検証を使用する証明書では、このパラメータは不要です（nullのまま）。
  validation_record_fqdns = [
    "_abc123.example.com",
    "_def456.www.example.com"
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: CloudFrontで使用する証明書はus-east-1リージョンにリクエストする必要があります。
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 用途: 検証完了の待機時間を調整できます。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時の最大待機時間を指定します。
    # 設定可能な値: 時間を示す文字列（例: "45m", "1h30m"）
    # デフォルト: 45m（45分）
    # 用途: DNS検証レコードの伝播やメール検証の応答を待つ時間を設定します。
    #       DNS伝播には時間がかかる場合があるため、必要に応じて延長できます。
    create = "45m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 証明書が発行された時刻（RFC3339形式のタイムスタンプ）
#---------------------------------------------------------------
