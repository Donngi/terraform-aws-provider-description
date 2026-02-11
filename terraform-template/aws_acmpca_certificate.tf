#---------------------------------------------------------------
# AWS ACM PCA Certificate
#---------------------------------------------------------------
#
# AWS Certificate Manager Private Certificate Authority (ACM PCA)を使用して
# プライベート証明書を発行するリソースです。
# このリソースで作成した証明書は自動更新の対象外となり、
# 有効期限が切れる前に置き換える必要があります。
#
# 注意: 自動更新可能な証明書が必要な場合は、certificate_authority_arnパラメータを
#       指定したaws_acm_certificateリソースの使用を推奨します。
#
# AWS公式ドキュメント:
#   - ACM PCA証明書発行: https://docs.aws.amazon.com/privateca/latest/userguide/PcaIssueCert.html
#   - IssueCertificate API: https://docs.aws.amazon.com/privateca/latest/APIReference/API_IssueCertificate.html
#   - ACM PCAテンプレート: https://docs.aws.amazon.com/privateca/latest/userguide/UsingTemplates.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acmpca_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_acmpca_certificate" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # certificate_authority_arn (Required)
  # 設定内容: 証明書を発行するプライベート認証局(CA)のARNを指定します。
  # 設定可能な値: 有効なACM PCA証明書機関のARN
  # 形式: arn:aws:acm-pca:region:account:certificate-authority/12345678-1234-1234-1234-123456789012
  # 関連機能: AWS Certificate Manager Private Certificate Authority
  #   プライベートCAを使用して組織内のリソース用の証明書を発行します。
  #   - https://docs.aws.amazon.com/privateca/latest/userguide/PcaWelcome.html
  certificate_authority_arn = "arn:aws:acm-pca:ap-northeast-1:123456789012:certificate-authority/12345678-1234-1234-1234-123456789012"

  # certificate_signing_request (Required)
  # 設定内容: PEM形式の証明書署名要求(CSR)を指定します。
  # 設定可能な値: PEM形式のCSR文字列
  # 関連機能: Certificate Signing Request
  #   証明書発行に必要な公開鍵と主体情報を含むメッセージです。
  #   通常、tls_cert_requestリソースやOpenSSLなどのツールで生成します。
  #   - https://docs.aws.amazon.com/privateca/latest/userguide/PcaIssueCert.html
  certificate_signing_request = tls_cert_request.example.cert_request_pem

  # signing_algorithm (Required)
  # 設定内容: 証明書署名に使用するアルゴリズムを指定します。
  # 設定可能な値:
  #   - "SHA256WITHRSA": SHA-256ハッシュを使用するRSA署名
  #   - "SHA256WITHECDSA": SHA-256ハッシュを使用するECDSA署名
  #   - "SHA384WITHRSA": SHA-384ハッシュを使用するRSA署名
  #   - "SHA384WITHECDSA": SHA-384ハッシュを使用するECDSA署名
  #   - "SHA512WITHRSA": SHA-512ハッシュを使用するRSA署名
  #   - "SHA512WITHECDSA": SHA-512ハッシュを使用するECDSA署名
  # 注意: 指定する署名アルゴリズムファミリーは、CAの秘密鍵のアルゴリズムファミリーと
  #       一致する必要があります。
  # 関連機能: 署名アルゴリズムの互換性
  #   - https://docs.aws.amazon.com/privateca/latest/userguide/PCACertInstall.html
  signing_algorithm = "SHA256WITHRSA"

  #-------------------------------------------------------------
  # 有効期限設定 (Required)
  #-------------------------------------------------------------

  # validity (Required)
  # 設定内容: 証明書の有効期限を設定するブロックです。
  # 必須: min_items: 1, max_items: 1
  validity {
    # type (Required)
    # 設定内容: valueパラメータの解釈方法を指定します。
    # 設定可能な値:
    #   - "DAYS": 日数で相対的な有効期限を指定
    #   - "MONTHS": 月数で相対的な有効期限を指定
    #   - "YEARS": 年数で相対的な有効期限を指定
    #   - "ABSOLUTE": Unix エポックからの秒数で絶対的な有効期限を指定
    #   - "END_DATE": RFC 3339形式の日付で絶対的な有効期限を指定
    type = "YEARS"

    # value (Required)
    # 設定内容: typeで指定した形式に基づく有効期限の値を指定します。
    # 設定可能な値:
    #   - typeが"DAYS", "MONTHS", "YEARS"の場合: 相対的な期間を示す数値文字列
    #   - typeが"ABSOLUTE"の場合: Unixエポックからの秒数を示す数値文字列
    #   - typeが"END_DATE"の場合: RFC 3339形式の日付文字列 (例: 2025-12-31T23:59:59Z)
    # 注意: 証明書の有効期限は、CA階層内の親証明書に設定された制限を
    #       超えることはできません。
    value = "1"
  }

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # template_arn (Optional)
  # 設定内容: 証明書発行時に使用するテンプレートのARNを指定します。
  # 設定可能な値: 有効なACM PCAテンプレートのARN
  # 省略時: デフォルトのテンプレートが使用されます
  # 関連機能: ACM PCA Certificate Templates
  #   テンプレートを使用して、発行する証明書の構造と内容を制御できます。
  #   Base、CSRPassthrough、APIPassthrough、APICSRPassthrough の4種類があります。
  #   - https://docs.aws.amazon.com/privateca/latest/userguide/UsingTemplates.html
  #   - https://docs.aws.amazon.com/privateca/latest/userguide/template-varieties.html
  template_arn = null

  # api_passthrough (Optional)
  # 設定内容: 発行する証明書に含めるX.509証明書情報をJSON形式で指定します。
  # 設定可能な値: JSON形式の文字列
  # 注意: APIPassthroughテンプレートバリアント使用時のみ有効です。
  #       他のソースから競合・重複する証明書情報が提供された場合、
  #       ACM PCAは動作順序ルールを適用して使用する情報を決定します。
  # 関連機能: API Passthrough
  #   証明書のサブジェクト情報や拡張情報をカスタマイズできます。
  #   SubjectやExtensionsなどのX.509要素を指定可能です。
  #   - https://docs.aws.amazon.com/privateca/latest/APIReference/API_ApiPassthrough.html
  #   - https://docs.aws.amazon.com/privateca/latest/userguide/PcaIssueCert.html
  api_passthrough = null

  # id (Optional, Computed)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: 発行された証明書のARNが自動的に割り当てられます
  # 注意: 通常は明示的に指定する必要はありません。
  id = null

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: ap-northeast-1, us-east-1)
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 証明書のAmazon Resource Name (ARN)
#
# - certificate: PEM形式でエンコードされた証明書の値
#
# - certificate_chain: 中間証明書を含み、ルートCAまで連鎖する
#                      PEM形式でエンコードされた証明書チェーン
#---------------------------------------------------------------
