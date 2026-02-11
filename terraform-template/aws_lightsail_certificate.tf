#---------------------------------------------------------------
# Amazon Lightsail SSL/TLS Certificate
#---------------------------------------------------------------
#
# Amazon Lightsail用のSSL/TLS証明書をプロビジョニングするリソースです。
# Lightsailのロードバランサー、CDNディストリビューション、コンテナサービスで
# カスタムドメインを使用する際に、HTTPS通信を有効化するために使用します。
# 証明書はAWS Certificate Manager (ACM) により発行されます。
#
# AWS公式ドキュメント:
#   - SSL/TLS certificates in Lightsail: https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-tls-ssl-certificates-in-lightsail-https.html
#   - Certificates FAQ: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-faq-certificates.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_certificate" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 証明書の名前を指定します。
  # 設定可能な値: 一意の証明書名（文字列）
  # 注意: 証明書作成後は変更できません。変更する場合は新しい証明書を作成する必要があります。
  name = "example-certificate"

  #-------------------------------------------------------------
  # ドメイン設定
  #-------------------------------------------------------------

  # domain_name (Optional)
  # 設定内容: 証明書を発行するドメイン名を指定します。
  # 設定可能な値: 有効なドメイン名（例: example.com）
  # 省略時: 指定なしでも証明書を作成できますが、実用上はドメイン名の指定が必要です
  # 注意: domain_nameはsubject_alternative_namesに自動的にSANとして追加されます
  # 関連機能: Domain Validation
  #   証明書の発行には、ドメインの所有権を証明するためにDNSレコード（CNAME）の追加が必要です。
  #   証明書作成後、domain_validation_options属性から取得したCNAMEレコードを
  #   ドメインのDNSゾーンに追加する必要があります。
  #   - https://docs.aws.amazon.com/lightsail/latest/userguide/verify-tls-ssl-certificate-using-dns-cname-https.html
  domain_name = "example.com"

  # subject_alternative_names (Optional)
  # 設定内容: 証明書のSubject Alternative Names (SANs) として追加するドメインのセットを指定します。
  # 設定可能な値: ドメイン名またはサブドメイン名の配列（最大10個まで）
  # 省略時: domain_nameのみが証明書に含まれます
  # 注意:
  #   - domain_name属性は自動的にSANとして追加されるため、ここに重複して指定する必要はありません
  #   - ワイルドカードドメイン（*.example.com）はサポートされていません
  #   - 証明書作成後にドメインを変更する場合は、証明書を再送信して再検証する必要があります
  # 関連機能: Subject Alternative Names (SANs)
  #   1つの証明書で複数のドメイン/サブドメインを保護できます。
  #   Lightsailは1つの証明書につき最大10個のドメイン/サブドメインをサポートします。
  #   - https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-faq-certificates.html
  subject_alternative_names = ["www.example.com"]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ID設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: 証明書の名前（name）が自動的にIDとして使用されます
  # 注意: 通常は省略し、Terraformに自動管理させることを推奨します
  id = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ。キーのみのタグを作成する場合は値に空文字列を使用します。
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-certificate"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: リソースに割り当てられる全てのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: tagsとプロバイダーのdefault_tagsが自動的にマージされます
  # 注意: 通常は省略し、tagsとdefault_tagsの自動マージに任せることを推奨します
  #       明示的に指定する場合は、プロバイダーのdefault_tagsを含む全てのタグを指定する必要があります
  tags_all = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下のcomputed属性をエクスポートします:
#
# - arn: 証明書のAmazon Resource Name (ARN)
#
# - created_at: 証明書が作成された日時
#
# - domain_validation_options: 証明書の検証を完了するために使用できる
#                               ドメイン検証オブジェクトのセット。
#                               SANが定義されている場合、複数の要素を持つ可能性があります。
#                               各要素には以下の属性が含まれます:
#   * domain_name: 証明書を発行するドメイン名
#   * resource_record_name: 証明書を検証するために作成するDNSレコードの名前
#   * resource_record_type: 証明書を検証するために作成するDNSレコードのタイプ
#   * resource_record_value: 証明書を検証するために作成するDNSレコードの値
#---------------------------------------------------------------
