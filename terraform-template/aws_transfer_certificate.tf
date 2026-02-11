#---------------------------------------------------------------
# AWS Transfer Family AS2証明書
#---------------------------------------------------------------
#
# AWS Transfer FamilyのAS2プロトコルで使用する証明書リソースをプロビジョニングします。
# AS2では、暗号化と署名のために証明書を使用して安全なファイル転送を実現します。
# 証明書は、SIGNING（署名用）またはENCRYPTION（暗号化用）のいずれかの用途で使用できます。
#
# AWS公式ドキュメント:
#   - Manage AS2 certificates: https://docs.aws.amazon.com/transfer/latest/userguide/managing-as2-partners.html
#   - AS2 for AWS Transfer Family: https://docs.aws.amazon.com/transfer/latest/userguide/as2-for-transfer-family.html
#   - DescribedCertificate API Reference: https://docs.aws.amazon.com/transfer/latest/APIReference/API_DescribedCertificate.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_certificate" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # certificate - (Required, Sensitive) 転送に必要な有効な証明書ファイル
  # PEM形式の証明書の内容を指定します。
  # 通常はfile()関数を使用してファイルから読み込みます。
  # 例: file("${path.module}/example.com/example.crt")
  certificate = file("${path.module}/path/to/certificate.crt")

  # usage - (Required) 証明書の用途を指定します
  # 有効な値: "SIGNING" (署名用) または "ENCRYPTION" (暗号化用)
  # - SIGNING: メッセージの署名に使用する証明書
  # - ENCRYPTION: メッセージの暗号化に使用する証明書
  # 同じ証明書を両方の目的で使用することも、別々の証明書を使用することもできます。
  # セキュリティ強化のため、エスクロー管理されている暗号化キーとは別に署名キーを管理することが推奨されます。
  usage = "SIGNING"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # certificate_chain - (Optional, Sensitive) 証明書チェーンを構成する証明書のリスト
  # インポートする証明書のチェーンを構成する証明書のオプションリストです。
  # 自己署名証明書の場合は不要です。
  # 通常はfile()関数を使用してファイルから読み込みます。
  # 例: file("${path.module}/example.com/ca.crt")
  certificate_chain = file("${path.module}/path/to/certificate_chain.crt")

  # description - (Optional) 証明書を識別するための短い説明
  # 証明書の目的を説明に含めることで、管理が容易になります。
  # 例: "Production AS2 signing certificate for Partner XYZ"
  description = "AS2 certificate for example"

  # private_key - (Optional, Sensitive) インポートする証明書に関連付けられた秘密鍵
  # ローカル証明書（自社が所有する証明書）の場合に指定します。
  # パートナーの公開証明書をインポートする場合は指定しません。
  # PEM形式の秘密鍵の内容を指定します。
  # 例: file("${path.module}/example.com/example.key")
  # 注意: TLS証明書は、パートナーの公開証明書としてのみインポート可能です。
  private_key = file("${path.module}/path/to/private_key.key")

  # tags - (Optional) リソースに割り当てるタグのマップ
  # プロバイダーレベルでdefault_tagsが設定されている場合、
  # キーが一致するタグはプロバイダーレベルのタグを上書きします。
  tags = {
    Environment = "production"
    Partner     = "example-partner"
    Usage       = "AS2-signing"
  }

  #---------------------------------------------------------------
  # Optional + Computed Parameters
  #---------------------------------------------------------------

  # id - (Optional, Computed) リソースのID
  # 通常は指定不要です。Terraformが自動的に管理します。

  # region - (Optional, Computed) リソースを管理するリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 例: "us-east-1"
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags_all - (Optional, Computed) プロバイダーのdefault_tagsを含む全タグのマップ
  # 通常は指定不要です。Terraformが自動的に管理します。
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性は、このリソースによってエクスポートされます（computed only）:
#
# - arn (string)
#   証明書のAmazon Resource Name (ARN)
#
# - certificate_id (string)
#   AS2証明書の一意な識別子
#
# - active_date (string)
#   証明書がアクティブになる日付
#   証明機関(CA)が指定したNotBeforeDateと同じ値を取ります（明示的に指定しない場合）。
#   証明書のローテーション管理で使用されます。
#
# - inactive_date (string)
#   証明書が非アクティブになる日付
#   証明機関(CA)が指定したNotAfterDateと同じ値を取ります（明示的に指定しない場合）。
#   CloudWatchメトリクス「DaysUntilExpiry」は、現在の日付とこのInactiveDateの間の日数を示します。
#   証明書のローテーション管理で使用されます。
#
#---------------------------------------------------------------
# Usage Notes
#---------------------------------------------------------------
# 1. 証明書の鍵長は2048ビット以上4096ビット以下である必要があります。
#
# 2. 証明書のローテーション:
#    - 複数の証明書をプロファイルに指定することで、証明書のローテーションが可能です
#    - Active DateとInactive Dateを使用して、証明書の有効期間を管理します
#    - 古い証明書と新しい証明書の間にグレースピリオドを設けることが推奨されます
#
# 3. 証明書の用途:
#    - Inbound AS2: パートナーの署名用公開鍵、ローカルの暗号化・署名用秘密鍵
#    - Outbound AS2: パートナーの暗号化用公開鍵、ローカルの署名用秘密鍵
#
# 4. CloudWatch監視:
#    - Transfer Familyは証明書インポート後、CloudWatchメトリクス「DaysUntilExpiry」を発行します
#    - このメトリクスを使用してアラームを作成し、証明書の期限切れを監視できます
#
# 5. TLS証明書の制約:
#    - TLS証明書は、パートナーの公開証明書としてのみインポート可能です
#    - TLS証明書は自己署名証明書である必要があります
#
#---------------------------------------------------------------
