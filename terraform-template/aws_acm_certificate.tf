#---------------------------------------------------------------
# AWS Certificate Manager (ACM) Certificate
#---------------------------------------------------------------
#
# AWS Certificate Manager (ACM) の証明書をリクエストおよび管理するリソースです。
# ACM証明書は3つの方法で作成できます:
#   1. Amazon発行: AWSが証明書機関を提供し、自動更新を管理
#   2. インポート証明書: 他の証明書機関が発行した証明書をインポート
#   3. プライベート証明書: ACM Private Certificate Authority を使用して発行
#
# AWS公式ドキュメント:
#   - ACM 概要: https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html
#   - ACM 証明書の特性: https://docs.aws.amazon.com/acm/latest/userguide/acm-certificate-characteristics.html
#   - ACM API リファレンス: https://docs.aws.amazon.com/acm/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_acm_certificate" "example" {
  #-------------------------------------------------------------
  # Amazon発行証明書の設定
  #-------------------------------------------------------------

  # domain_name (Optional, Computed)
  # 設定内容: 証明書を発行するドメイン名を指定します。
  # 設定可能な値: 完全修飾ドメイン名 (FQDN)。ワイルドカード証明書の場合は *.example.com のように指定
  # 用途: Amazon発行証明書またはプライベート証明書の作成時に必須
  # 関連機能: ACM 証明書のドメイン名
  #   証明書で保護する主要なドメインを指定。ワイルドカードを使用して複数のサブドメインを保護可能。
  #   - https://docs.aws.amazon.com/acm/latest/userguide/acm-certificate-characteristics.html
  domain_name = "example.com"

  # subject_alternative_names (Optional, Computed)
  # 設定内容: 証明書に含めるべきSAN (Subject Alternative Names) のセットを指定します。
  # 設定可能な値: ドメイン名の文字列セット。空のリスト [] を設定すると全要素を削除
  # 省略時: domain_nameのみが証明書に含まれます
  # 関連機能: ACM Subject Alternative Names
  #   1つの証明書で複数のドメインを保護可能。domain_nameは自動的にSANsに含まれます。
  #   - https://docs.aws.amazon.com/acm/latest/userguide/acm-certificate-characteristics.html
  subject_alternative_names = ["www.example.com", "api.example.com"]

  # validation_method (Optional, Computed)
  # 設定内容: ドメイン所有権の検証に使用する方法を指定します。
  # 設定可能な値:
  #   - "DNS": DNS検証。推奨方法。Route53等でDNSレコードを追加して検証
  #   - "EMAIL": Eメール検証。ドメインの管理者メールアドレスに検証メールを送信
  # 注意: インポート証明書には設定しないでください
  # 関連機能: ACM ドメイン検証
  #   証明書発行前にドメイン所有権を証明する必要があります。DNS検証は自動更新に適しています。
  #   - https://docs.aws.amazon.com/acm/latest/userguide/domain-validation.html
  validation_method = "DNS"

  # key_algorithm (Optional, Computed)
  # 設定内容: 証明書の公開鍵・秘密鍵ペアの生成に使用するアルゴリズムを指定します。
  # 設定可能な値:
  #   - "RSA_2048": 2048ビット RSA (デフォルト)
  #   - "EC_prime256v1": 256ビット楕円曲線 (ECDSA)
  #   - "EC_secp384r1": 384ビット楕円曲線 (ECDSA)
  # 関連機能: ACM 証明書のアルゴリズム
  #   暗号化の強度とパフォーマンスのトレードオフを考慮して選択。
  #   - https://docs.aws.amazon.com/acm/latest/userguide/acm-certificate-characteristics.html
  key_algorithm = "RSA_2048"

  #-------------------------------------------------------------
  # インポート証明書の設定
  #-------------------------------------------------------------

  # certificate_body (Optional)
  # 設定内容: インポートする証明書のPEM形式の公開鍵を指定します。
  # 設定可能な値: PEMエンコードされた証明書データ
  # 用途: 外部の証明書機関が発行した証明書をACMにインポートする場合に必須
  # 注意: private_keyと組み合わせて使用
  # 関連機能: ACM 証明書のインポート
  #   他のCAで発行した証明書をACMで管理可能。PEM形式が必須。
  #   - https://docs.aws.amazon.com/acm/latest/userguide/import-certificate.html
  certificate_body = null

  # private_key (Optional, Sensitive)
  # 設定内容: インポートする証明書のPEM形式の秘密鍵を指定します。
  # 設定可能な値: PEMエンコードされた秘密鍵データ
  # 用途: 外部の証明書機関が発行した証明書をACMにインポートする場合に必須
  # 注意: 機密情報のため、Terraformのstate内で暗号化されます
  # 関連機能: ACM 証明書のインポート
  #   秘密鍵は暗号化されて保存。AWSはこの鍵を使用してTLS通信を確立。
  #   - https://docs.aws.amazon.com/acm/latest/userguide/import-certificate.html
  private_key = null

  # certificate_chain (Optional)
  # 設定内容: インポートする証明書のPEM形式の証明書チェーンを指定します。
  # 設定可能な値: PEMエンコードされた証明書チェーン (中間証明書)
  # 用途: 証明書の信頼チェーンを確立するために使用
  # 省略時: 証明書が自己署名の場合、または中間証明書が不要な場合
  # 関連機能: ACM 証明書チェーン
  #   ルート証明書までの信頼の連鎖を確立。ブラウザが証明書を信頼するために必要。
  #   - https://docs.aws.amazon.com/acm/latest/userguide/import-certificate-format.html
  certificate_chain = null

  #-------------------------------------------------------------
  # プライベート証明書の設定
  #-------------------------------------------------------------

  # certificate_authority_arn (Optional)
  # 設定内容: プライベート証明書を発行するACM Private CA (PCA) のARNを指定します。
  # 設定可能な値: 有効なACM PCA のARN
  # 用途: プライベート証明書を作成する場合に必須
  # 関連機能: ACM Private Certificate Authority
  #   内部システム用のプライベート証明書を発行するためのCA。
  #   - https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-private.html
  certificate_authority_arn = null

  # early_renewal_duration (Optional)
  # 設定内容: 証明書の有効期限前に自動更新プロセスを開始するまでの期間を指定します。
  # 設定可能な値:
  #   - RFC 3339 duration形式 (年・月・日をサポート): 例: "P90D" (90日前)
  #   - 時間文字列: 例: "2160h" (90日 = 2160時間)
  # 省略時: 自動更新は行われません
  # 注意: 60日未満の値は効果がありません
  # 用途: プライベート証明書のマネージド更新に使用
  # 関連機能: ACM マネージド更新
  #   有効期限前に自動的に証明書を更新。ダウンタイムを防止。
  #   - https://docs.aws.amazon.com/acm/latest/userguide/managed-renewal.html
  early_renewal_duration = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: CloudFrontで使用する証明書は us-east-1 リージョンに作成する必要があります
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 証明書オプション
  #-------------------------------------------------------------

  # options (Optional)
  # 設定内容: 証明書の追加オプションを設定します。
  # 用途: 証明書の透過性ログやエクスポートオプションを制御
  options {
    # certificate_transparency_logging_preference (Optional)
    # 設定内容: 証明書透過性ログへの記録設定を指定します。
    # 設定可能な値:
    #   - "ENABLED" (デフォルト): 証明書を公開ログに記録。Google Chromeが信頼するために必須
    #   - "DISABLED": ログに記録しない (非推奨)
    # 関連機能: Certificate Transparency
    #   証明書の不正発行を検出するための公開ログシステム。
    #   - https://docs.aws.amazon.com/acm/latest/userguide/acm-bestpractices.html
    certificate_transparency_logging_preference = "ENABLED"

    # export (Optional, Computed)
    # 設定内容: 証明書のエクスポート可否を指定します。
    # 設定可能な値:
    #   - "ENABLED": 証明書のエクスポートを許可
    #   - "DISABLED": 証明書のエクスポートを禁止 (デフォルト)
    # 用途: AWS外部のサーバーで証明書を使用する場合に有効化
    # 注意: エクスポート可能な証明書は作成時に指定する必要があります
    export = null
  }

  #-------------------------------------------------------------
  # ドメイン検証オプション
  #-------------------------------------------------------------

  # validation_option (Optional)
  # 設定内容: 各ドメイン名の初期検証に関する情報を指定します。
  # 用途: EMAIL検証時に検証メールの送信先ドメインをカスタマイズする場合に使用
  validation_option {
    # domain_name (Required)
    # 設定内容: 検証するドメイン名を指定します。
    # 設定可能な値: 証明書に含まれるドメイン名
    domain_name = "example.com"

    # validation_domain (Required)
    # 設定内容: 検証メールの送信先となるドメインを指定します。
    # 設定可能な値: ドメイン名
    # 用途: サブドメインの検証メールを親ドメインで受信する場合などに使用
    # 例: testing.example.com の検証メールを example.com で受信
    validation_domain = "example.com"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/acm/latest/userguide/tags.html
  tags = {
    Name        = "example-certificate"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はARNと同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # ライフサイクル設定の推奨
  #-------------------------------------------------------------
  # Amazon発行証明書の場合、更新時にリソースが再作成されるため、
  # create_before_destroyの使用を推奨します:
  #
  # lifecycle {
  #   create_before_destroy = true
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 証明書のAmazon Resource Name (ARN)
#
# - domain_name: 証明書が発行されているドメイン名
#
# - domain_validation_options: 証明書検証を完了するために使用できる
#   ドメイン検証オブジェクトのセット。SANsが定義されている場合、
#   複数の要素を持つ可能性があります。DNS検証が使用された場合のみ設定されます。
#   各要素には以下が含まれます:
#   - domain_name: 検証するドメイン
#   - resource_record_name: 作成するDNSレコードの名前
#   - resource_record_type: 作成するDNSレコードのタイプ
#   - resource_record_value: DNSレコードに必要な値
#
# - not_after: 証明書の有効期限の日時
#
# - not_before: 証明書の有効期間の開始日時
#
# - pending_renewal: マネージド更新の対象となるプライベート証明書が
#   early_renewal_duration期間内にある場合はtrue
#
#---------------------------------------------------------------
