#---------------------------------------------------------------
# AWS Certificate Manager Private Certificate Authority
#---------------------------------------------------------------
#
# AWS Certificate Manager Private Certificate Authority (ACM PCA)の認証局を
# プロビジョニングするリソースです。プライベート証明書の発行・管理を行う
# ルートCAまたはサブCAを作成します。
#
# 注意: このリソースを作成すると、認証局は `PENDING_CERTIFICATE` ステータスのままとなり、
#       まだ証明書を発行できません。セットアップを完了するには、
#       `certificate_signing_request` 属性で利用可能なCA CSRに完全に署名する必要があります。
#       この目的には `aws_acmpca_certificate_authority_certificate` リソースを使用できます。
#
# AWS公式ドキュメント:
#   - ACM PCA 概要: https://docs.aws.amazon.com/privateca/latest/userguide/PcaWelcome.html
#   - プライベートCA作成: https://docs.aws.amazon.com/privateca/latest/userguide/create-CA.html
#   - CA設定: https://docs.aws.amazon.com/privateca/latest/APIReference/API_CertificateAuthorityConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acmpca_certificate_authority
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_acmpca_certificate_authority" "example" {
  #-------------------------------------------------------------
  # CA基本設定
  #-------------------------------------------------------------

  # type (Optional)
  # 設定内容: 認証局のタイプを指定します。
  # 設定可能な値:
  #   - "ROOT": ルートCA。自己署名証明書を持つ最上位のCA
  #   - "SUBORDINATE" (デフォルト): サブCA。上位CAによって署名されたCA
  # 省略時: "SUBORDINATE"
  # 参考: https://docs.aws.amazon.com/privateca/latest/userguide/PcaTerms.html
  type = "SUBORDINATE"

  # enabled (Optional)
  # 設定内容: 認証局を有効化するか無効化するかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): CA有効化
  #   - false: CA無効化
  # 省略時: true
  # 注意: CAが `ACTIVE` ステータスの場合のみ無効化できます。
  enabled = true

  # usage_mode (Optional)
  # 設定内容: CAが発行する証明書のタイプと失効メカニズムの要件を指定します。
  # 設定可能な値:
  #   - "GENERAL_PURPOSE" (デフォルト): 汎用証明書モード。失効メカニズムが必要な通常の証明書を発行
  #   - "SHORT_LIVED_CERTIFICATE": 短期証明書モード。7日以内の有効期間で失効を省略可能
  # 省略時: "GENERAL_PURPOSE"
  # 関連機能: 短期証明書モード
  #   有効期間が7日以内に制限されますが、失効メカニズムを省略でき、コストが低くなります。
  #   - https://docs.aws.amazon.com/privateca/latest/userguide/short-lived-certificates.html
  usage_mode = "GENERAL_PURPOSE"

  # key_storage_security_standard (Optional)
  # 設定内容: CAキーの処理と保護に使用される暗号鍵管理コンプライアンス標準を指定します。
  # 設定可能な値:
  #   - "FIPS_140_2_LEVEL_3_OR_HIGHER" (デフォルト): FIPS 140-2 Level 3以上のHSMを使用
  #   - "FIPS_140_2_LEVEL_2_OR_HIGHER": FIPS 140-2 Level 2以上のHSMを使用
  # 省略時: "FIPS_140_2_LEVEL_3_OR_HIGHER"
  # 注意: リージョンごとにサポートされる標準が異なります。
  # 参考: https://docs.aws.amazon.com/privateca/latest/userguide/data-protection.html#private-keys
  key_storage_security_standard = "FIPS_140_2_LEVEL_3_OR_HIGHER"

  # permanent_deletion_time_in_days (Optional)
  # 設定内容: CAが削除された後、復元可能にする日数を指定します。
  # 設定可能な値: 7から30の整数
  # 省略時: 30
  # 関連機能: CA削除保護期間
  #   削除されたCAは指定期間中、復元可能な状態で保持されます。
  permanent_deletion_time_in_days = 30

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # CA設定（必須ブロック）
  #-------------------------------------------------------------

  certificate_authority_configuration {
    # key_algorithm (Required)
    # 設定内容: CAが証明書を発行する際に使用する公開鍵アルゴリズムとキーペアのビットサイズを指定します。
    # 設定可能な値:
    #   - RSA系: "RSA_2048", "RSA_4096"
    #   - ECDSA系: "EC_prime256v1" (P-256), "EC_secp384r1" (P-384)
    # 注意: サブCAの場合、親CAのアルゴリズムファミリーと一致する必要があります。
    # 参考: https://docs.aws.amazon.com/privateca/latest/APIReference/API_CertificateAuthorityConfiguration.html
    key_algorithm = "RSA_4096"

    # signing_algorithm (Required)
    # 設定内容: プライベートCAが証明書リクエストに署名する際に使用するアルゴリズムを指定します。
    # 設定可能な値:
    #   - RSA系: "SHA256WITHRSA", "SHA384WITHRSA", "SHA512WITHRSA"
    #   - ECDSA系: "SHA256WITHECDSA", "SHA384WITHECDSA", "SHA512WITHECDSA"
    # 注意: key_algorithmのファミリーと一致する必要があります（RSA/ECDSAの組み合わせ）。
    # 参考: https://docs.aws.amazon.com/privateca/latest/APIReference/API_CertificateAuthorityConfiguration.html
    signing_algorithm = "SHA512WITHRSA"

    #-----------------------------------------------------------
    # サブジェクト設定（必須ネストブロック）
    #-----------------------------------------------------------

    subject {
      # common_name (Optional)
      # 設定内容: 証明書サブジェクトに関連付けられた完全修飾ドメイン名（FQDN）を指定します。
      # 設定可能な値: 64文字以下の文字列
      # 用途: CAの識別名として使用されます。
      common_name = "example.com"

      # organization (Optional)
      # 設定内容: 証明書サブジェクトが所属する組織の法的名称を指定します。
      # 設定可能な値: 64文字以下の文字列
      organization = "Example Organization"

      # organizational_unit (Optional)
      # 設定内容: 証明書サブジェクトが所属する組織の部門（営業、財務など）を指定します。
      # 設定可能な値: 64文字以下の文字列
      organizational_unit = "IT Department"

      # country (Optional)
      # 設定内容: 証明書サブジェクトが所在する国を指定します。
      # 設定可能な値: 2文字の国コード（ISO 3166-1 alpha-2）
      country = "US"

      # state (Optional)
      # 設定内容: 証明書サブジェクトが所在する州または都道府県を指定します。
      # 設定可能な値: 128文字以下の文字列
      state = "Washington"

      # locality (Optional)
      # 設定内容: 証明書サブジェクトが所在する地域（市町村など）を指定します。
      # 設定可能な値: 128文字以下の文字列
      locality = "Seattle"

      # distinguished_name_qualifier (Optional)
      # 設定内容: 証明書サブジェクトの識別子を明確にするための情報を指定します。
      # 設定可能な値: 64文字以下の文字列
      distinguished_name_qualifier = null

      # generation_qualifier (Optional)
      # 設定内容: 個人の名前に付加される修飾子を指定します。
      # 設定可能な値: 3文字以下の文字列（例: Jr., Sr., III）
      generation_qualifier = null

      # given_name (Optional)
      # 設定内容: 名（ファーストネーム）を指定します。
      # 設定可能な値: 16文字以下の文字列
      given_name = null

      # initials (Optional)
      # 設定内容: 名前のイニシャルを指定します。
      # 設定可能な値: 5文字以下の文字列
      # 用途: 通常、given_name、ミドルネーム、surnameの頭文字を連結したもの
      initials = null

      # pseudonym (Optional)
      # 設定内容: 名前の短縮形やニックネームを指定します。
      # 設定可能な値: 128文字以下の文字列
      # 例: Jonathan → John, Elizabeth → Beth
      pseudonym = null

      # surname (Optional)
      # 設定内容: 姓（ファミリーネーム）を指定します。
      # 設定可能な値: 40文字以下の文字列
      surname = null

      # title (Optional)
      # 設定内容: 証明書サブジェクトを正式に指すための敬称を指定します。
      # 設定可能な値: 64文字以下の文字列（例: Mr., Ms., Dr.）
      title = null
    }
  }

  #-------------------------------------------------------------
  # 失効設定（オプションブロック）
  #-------------------------------------------------------------

  revocation_configuration {
    #-----------------------------------------------------------
    # CRL（証明書失効リスト）設定
    #-----------------------------------------------------------

    crl_configuration {
      # enabled (Optional)
      # 設定内容: 証明書失効リスト（CRL）を有効にするかを指定します。
      # 設定可能な値:
      #   - true: CRLを有効化
      #   - false (デフォルト): CRLを無効化
      # 省略時: false
      # 注意: enabledをtrueにする場合、expiration_in_daysとs3_bucket_nameは必須です。
      enabled = true

      # expiration_in_days (Optional)
      # 設定内容: 証明書が失効するまでの日数を指定します。
      # 設定可能な値: 1から5000の整数
      # 注意: enabledがtrueの場合は必須です。
      expiration_in_days = 7

      # s3_bucket_name (Optional)
      # 設定内容: CRLを格納するS3バケット名を指定します。
      # 設定可能な値: 3から255文字の文字列
      # 注意: enabledがtrueの場合は必須です。ACM PCAがCRLを書き込めるようバケットポリシーを設定する必要があります。
      # 参考: custom_cnameを指定しない場合、S3バケット名が発行された証明書のCRL配布ポイント拡張に配置されます。
      s3_bucket_name = "my-acmpca-crl-bucket"

      # custom_cname (Optional)
      # 設定内容: CRL配布ポイントで使用するエイリアスのための証明書CRL配布ポイント拡張に挿入される名前を指定します。
      # 設定可能な値: 253文字以下の文字列
      # 用途: S3バケット名を公開したくない場合に使用します。
      custom_cname = "crl.example.com"

      # s3_object_acl (Optional)
      # 設定内容: CRLがパブリックに読み取り可能か、S3バケット内でプライベートに保持されるかを指定します。
      # 設定可能な値:
      #   - "PUBLIC_READ" (デフォルト): CRLをパブリックに読み取り可能にする
      #   - "BUCKET_OWNER_FULL_CONTROL": バケット所有者のみがアクセス可能
      # 省略時: "PUBLIC_READ"
      s3_object_acl = "PUBLIC_READ"
    }

    #-----------------------------------------------------------
    # OCSP（オンライン証明書ステータスプロトコル）設定
    #-----------------------------------------------------------

    ocsp_configuration {
      # enabled (Required)
      # 設定内容: カスタムOCSPレスポンダーを有効にするかを指定します。
      # 設定可能な値:
      #   - true: OCSPを有効化
      #   - false: OCSPを無効化
      # 注意: このブロックを使用する場合は必須です。
      enabled = false

      # ocsp_custom_cname (Optional)
      # 設定内容: カスタマイズされたOCSPドメインを指定するCNAMEを指定します。
      # 設定可能な値: 文字列
      # 注意: "http://" や "https://" などのプロトコルプレフィックスを含めてはいけません。
      ocsp_custom_cname = null
    }
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
  tags = {
    Name        = "example-private-ca"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されたタグを含むすべてのタグのマップを指定します。
  # 注意: 通常は明示的に設定する必要はありません。computed属性として自動的に設定されます。
  tags_all = null

  #-------------------------------------------------------------
  # Timeouts設定（オプション）
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 認証局のARN
#
# - arn: 認証局のAmazon Resource Name (ARN)
#
# - certificate: Base64エンコードされた認証局（CA）証明書
#              注意: CA証明書がインポートされた後にのみ利用可能です。
#
# - certificate_chain: 中間証明書を含み、プライベートCA証明書の署名に使用した
#                     オンプレミス証明書までチェーンする、Base64エンコードされた証明書チェーン
#                     注意: プライベートCA証明書は含まれません。CA証明書がインポートされた後にのみ利用可能です。
#
# - certificate_signing_request: プライベートCA証明書用のBase64 PEMエンコードされた
#                               証明書署名リクエスト（CSR）
#
# - not_after: 認証局が有効でなくなる日時
#             注意: CA証明書がインポートされた後にのみ利用可能です。
#
# - not_before: 認証局が有効になる日時
#              注意: CA証明書がインポートされた後にのみ利用可能です。
#
#---------------------------------------------------------------
