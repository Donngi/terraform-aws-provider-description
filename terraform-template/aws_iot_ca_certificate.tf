#---------------------------------------------------------------
# AWS IoT CA Certificate
#---------------------------------------------------------------
#
# AWS IoT CA Certificate リソースは、AWS IoT Core における CA（認証局）証明書を
# 作成および管理します。CA 証明書を登録することで、その CA によって署名された
# デバイス証明書を AWS IoT に接続できるようになります。
#
# 主な機能:
# - デバイス認証用の CA 証明書の登録
# - デバイス証明書の自動登録（Just-in-Time Provisioning: JITP / Just-in-Time Registration: JITR）
# - SNI ベースの証明書モード（複数アカウントでの CA 共有）
# - プロビジョニングテンプレートによる自動リソース作成
#
# AWS公式ドキュメント:
#   - RegisterCACertificate API: https://docs.aws.amazon.com/iot/latest/apireference/API_RegisterCACertificate.html
#   - Create your own client certificates: https://docs.aws.amazon.com/iot/latest/developerguide/device-certs-your-own.html
#   - Just-in-time registration (JITR): https://docs.aws.amazon.com/iot/latest/developerguide/auto-register-device-cert.html
#   - Just-in-time provisioning (JITP): https://docs.aws.amazon.com/iot/latest/developerguide/jit-provisioning.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_ca_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_ca_certificate" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # active - (Required) Boolean
  # CA 証明書をデバイス認証に対してアクティブにするかどうかを指定します。
  # - true: CA 証明書が有効化され、この CA で署名されたデバイス証明書を使用してデバイスが AWS IoT に接続できます
  # - false: CA 証明書が無効化され、この CA で署名されたデバイス証明書では接続できなくなります
  #
  # 注意: 証明書を無効化すると、その CA で署名された全てのデバイス証明書が使用できなくなります。
  active = true

  # allow_auto_registration - (Required) Boolean
  # デバイス証明書の自動登録を許可するかどうかを指定します。
  # - true: デバイスが初めて接続する際に、デバイス証明書を自動的に登録します（JITR: Just-in-Time Registration）
  # - false: デバイス証明書を事前に手動で登録する必要があります
  #
  # JITR を使用する場合:
  # - デバイスが初回接続時に TLS ハンドシェイク中にクライアント証明書を提示します
  # - AWS IoT は CA 証明書を認識し、クライアント証明書を PENDING_ACTIVATION 状態で登録します
  # - Lambda 関数と IoT Rule を使用して証明書を検証・有効化し、ポリシーをアタッチできます
  #
  # JITP (Just-in-Time Provisioning) を使用する場合は、registration_config も設定します。
  allow_auto_registration = true

  # ca_certificate_pem - (Required) String (Sensitive)
  # PEM エンコードされた CA 証明書を指定します。
  #
  # 要件:
  # - PEM 形式であること（-----BEGIN CERTIFICATE----- と -----END CERTIFICATE----- で囲まれている）
  # - CA 証明書として有効であること（is_ca_certificate = true で生成）
  # - X.509 証明書であること
  #
  # セキュリティ:
  # - この値は sensitive として扱われ、Terraform の出力やログに表示されません
  # - CA 証明書の秘密鍵は AWS に送信しないでください（秘密鍵はオンプレミスで安全に保管）
  #
  # 例:
  # ca_certificate_pem = file("path/to/ca-certificate.pem")
  # または
  # ca_certificate_pem = tls_self_signed_cert.ca.cert_pem
  ca_certificate_pem = file("${path.module}/certificates/ca-certificate.pem")

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # certificate_mode - (Optional) String
  # CA 証明書の登録モードを指定します。
  #
  # 有効な値:
  # - "DEFAULT": デフォルトモード。CA 証明書は 1 つのアカウントのリージョンにのみ登録可能
  #              このモードでは verification_certificate_pem が必須
  # - "SNI_ONLY": SNI（Server Name Indication）モード。複数のアカウントが同じ CA 証明書を登録可能
  #               デバイスは接続時に SNI 拡張を使用する必要があります
  #
  # デフォルト: "DEFAULT"
  #
  # SNI_ONLY モードの利点:
  # - 複数の AWS アカウントで同じ CA 証明書を共有できる
  # - 組織内で CA インフラを統一しながら、異なるアカウントでデバイスを管理できる
  #
  # 注意:
  # - SNI_ONLY モードでは、デバイスは TLS 接続時に SNI 拡張をサポートする必要があります
  # - DEFAULT モードで登録済みの CA は、他のアカウントで SNI_ONLY モードでも登録できません
  certificate_mode = "DEFAULT"

  # region - (Optional) String (Computed)
  # このリソースが管理されるリージョンを指定します。
  #
  # 動作:
  # - 指定しない場合: プロバイダー設定で指定されたリージョンが使用されます
  # - 指定した場合: そのリージョンで CA 証明書が登録されます
  #
  # 参考:
  # - Regional Endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - Provider Configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # 注意:
  # - 通常はプロバイダーレベルで region を設定することが推奨されます
  # - リソース単位でリージョンを指定する場合のみ使用してください
  # region = "us-east-1"

  # verification_certificate_pem - (Optional) String (Sensitive)
  # 登録コードの共通名を含む PEM エンコードされた検証証明書を指定します。
  #
  # 要件:
  # - certificate_mode が "DEFAULT" の場合は必須
  # - certificate_mode が "SNI_ONLY" の場合は不要
  #
  # 検証証明書の作成手順:
  # 1. AWS IoT から登録コードを取得（aws iot get-registration-code）
  # 2. 登録コードを Common Name とする CSR を作成
  # 3. CA の秘密鍵で CSR に署名して検証証明書を生成
  #
  # この証明書により、CA の秘密鍵を所有していることを証明します。
  #
  # セキュリティ:
  # - この値は sensitive として扱われ、Terraform の出力やログに表示されません
  #
  # 例:
  # verification_certificate_pem = tls_locally_signed_cert.verification.cert_pem
  #
  # 参考: https://docs.aws.amazon.com/iot/latest/developerguide/register-CA-cert.html
  verification_certificate_pem = file("${path.module}/certificates/verification-certificate.pem")

  # tags - (Optional) Map of String
  # CA 証明書に割り当てるタグの Key-Value ペアを指定します。
  #
  # タグの用途:
  # - リソースの分類と管理
  # - コスト配分の追跡
  # - アクセス制御（IAM ポリシーでのタグベースの条件）
  #
  # 注意:
  # - プロバイダーレベルの default_tags が設定されている場合、
  #   ここで指定したタグがプロバイダーのタグを上書きします
  # - 実際に適用される全てのタグは tags_all 属性で確認できます（computed）
  tags = {
    Name        = "example-ca-certificate"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all - (Optional) Map of String (Computed)
  # リソースに割り当てられる全てのタグを明示的に指定します。
  #
  # 動作:
  # - 指定しない場合: tags とプロバイダーの default_tags がマージされます（推奨）
  # - 指定した場合: ここで指定した値が全てのタグとなり、default_tags は無視されます
  #
  # 注意:
  # - 通常は tags のみを使用し、tags_all は Terraform に自動計算させることを推奨
  # - tags_all を明示的に指定すると、プロバイダーの default_tags が適用されなくなります
  # - このパラメータは主に参照用（computed）として使用されます
  #
  # 参考:
  # - default_tags: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags_all = {
  #   Name        = "example-ca-certificate"
  #   Environment = "production"
  #   ManagedBy   = "terraform"
  # }

  # id - (Optional) String (Computed)
  # リソースの一意な識別子を指定します。
  #
  # 動作:
  # - 指定しない場合: Terraform が自動的に AWS から返される ID を使用します（推奨）
  # - 指定した場合: インポート時などに使用されます
  #
  # 注意:
  # - 通常は指定する必要がありません
  # - このパラメータは主に terraform import 時や、既存リソースとの統合時に使用されます
  # - AWS が生成する CA 証明書 ID は 64 文字の16進数文字列です
  # id = "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef"

  #---------------------------------------------------------------
  # ネストブロック: registration_config
  #---------------------------------------------------------------
  # registration_config - (Optional) Block
  # Just-in-Time Provisioning (JITP) を使用する場合の登録設定を指定します。
  #
  # JITP とは:
  # - デバイスが初めて接続する際に、証明書の登録だけでなく、
  #   Thing、ポリシー、属性なども自動的にプロビジョニングする機能
  # - JITR との違い: JITR は証明書登録のみ、JITP は証明書+リソース作成
  #
  # 使用条件:
  # - allow_auto_registration が true である必要があります
  # - プロビジョニングテンプレート（template_body または template_name）を指定します
  # - AWS IoT がリソース作成を実行するための IAM ロール（role_arn）を指定します
  #
  # 最大 1 ブロックまで指定可能です。

  registration_config {
    # role_arn - (Optional) String
    # AWS IoT がプロビジョニング処理を実行する際に使用する IAM ロールの ARN を指定します。
    #
    # 必要な権限:
    # - iot:CreateThing - Thing リソースの作成
    # - iot:CreatePolicy - ポリシーの作成
    # - iot:AttachPolicy - 証明書へのポリシーのアタッチ
    # - iot:AttachThingPrincipal - Thing への証明書のアタッチ
    # - iot:UpdateCertificate - 証明書のステータス更新
    #
    # 信頼関係:
    # - Principal: iot.amazonaws.com
    #
    # 例:
    # role_arn = aws_iam_role.iot_provisioning.arn
    role_arn = "arn:aws:iam::123456789012:role/IoTProvisioningRole"

    # template_body - (Optional) String
    # プロビジョニングテンプレートの JSON 本文を直接指定します。
    #
    # テンプレート内で使用可能なパラメータ:
    # - AWS::IoT::Certificate::Country - 証明書の国コード
    # - AWS::IoT::Certificate::Organization - 証明書の組織名
    # - AWS::IoT::Certificate::OrganizationalUnit - 証明書の組織単位
    # - AWS::IoT::Certificate::DistinguishedNameQualifier - 証明書の識別子
    # - AWS::IoT::Certificate::StateName - 証明書の州名
    # - AWS::IoT::Certificate::CommonName - 証明書の Common Name
    # - AWS::IoT::Certificate::SerialNumber - 証明書のシリアル番号
    # - AWS::IoT::Certificate::Id - 証明書 ID
    #
    # テンプレートの構造:
    # {
    #   "Parameters": { ... },
    #   "Resources": {
    #     "thing": { ... },
    #     "certificate": { ... },
    #     "policy": { ... }
    #   }
    # }
    #
    # 注意:
    # - template_body と template_name は排他的です（どちらか一方のみ指定）
    # - テンプレートに必要な証明書プロパティが不足している場合、プロビジョニングは失敗します
    #
    # 参考: https://docs.aws.amazon.com/iot/latest/developerguide/jit-provisioning.html
    template_body = jsonencode({
      Parameters = {
        SerialNumber = {
          Type = "String"
        }
        CommonName = {
          Type = "String"
        }
      }
      Resources = {
        thing = {
          Type = "AWS::IoT::Thing"
          Properties = {
            ThingName = {
              Ref = "CommonName"
            }
            AttributePayload = {
              serialNumber = {
                Ref = "SerialNumber"
              }
            }
          }
        }
        certificate = {
          Type = "AWS::IoT::Certificate"
          Properties = {
            CertificateId = {
              Ref = "AWS::IoT::Certificate::Id"
            }
            Status = "Active"
          }
        }
        policy = {
          Type = "AWS::IoT::Policy"
          Properties = {
            PolicyName = "DefaultIoTPolicy"
          }
        }
      }
    })

    # template_name - (Optional) String
    # 事前に作成したプロビジョニングテンプレートの名前を指定します。
    #
    # 使用方法:
    # 1. aws_iot_provisioning_template リソースまたは AWS CLI/API で
    #    プロビジョニングテンプレートを事前に作成
    # 2. そのテンプレート名をここで参照
    #
    # 利点:
    # - テンプレートを複数の CA 証明書で再利用できる
    # - テンプレートの管理が容易（別リソースとして管理）
    #
    # 注意:
    # - template_body と template_name は排他的です（どちらか一方のみ指定）
    #
    # 例:
    # template_name = aws_iot_provisioning_template.example.name
    #
    # AWS CLI での作成例:
    # aws iot create-provisioning-template \
    #   --template-name MyTemplate \
    #   --template-body file://template.json \
    #   --provisioning-role-arn arn:aws:iam::123456789012:role/IoTProvisioningRole
    # template_name = "MyProvisioningTemplate"
  }
}

#---------------------------------------------------------------
# Attributes Reference (Computed のみ、入力不可)
#---------------------------------------------------------------
# 以下の属性は Terraform によって自動的に設定され、参照のみ可能です。

# id - String
# CA 証明書の内部 ID（AWS が割り当てた一意の識別子）
# 使用例: aws_iot_ca_certificate.example.id

# arn - String
# CA 証明書の ARN（Amazon Resource Name）
# 形式: arn:aws:iot:<region>:<account-id>:cacert/<certificate-id>
# 使用例: aws_iot_ca_certificate.example.arn

# customer_version - Number
# CA 証明書のカスタマーバージョン
# CA 証明書を更新するたびにインクリメントされます
# 使用例: aws_iot_ca_certificate.example.customer_version

# generation_id - String
# CA 証明書の世代 ID
# 証明書のライフサイクル管理に使用される内部識別子
# 使用例: aws_iot_ca_certificate.example.generation_id

# validity - List of Object
# CA 証明書の有効期限情報
# - not_after (String): 証明書が無効になる日時（RFC3339 形式）
# - not_before (String): 証明書が有効になる日時（RFC3339 形式）
# 使用例: aws_iot_ca_certificate.example.validity[0].not_after

# tags_all - Map of String
# リソースに割り当てられた全てのタグ
# プロバイダーの default_tags と、このリソースの tags をマージしたもの
# 使用例: aws_iot_ca_certificate.example.tags_all

#---------------------------------------------------------------
# 使用例とベストプラクティス
#---------------------------------------------------------------

# 完全な例（TLS プロバイダーを使用した CA 証明書の作成と登録）:
#
# # CA 用の秘密鍵を生成
# resource "tls_private_key" "ca" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }
#
# # 自己署名 CA 証明書を作成
# resource "tls_self_signed_cert" "ca" {
#   private_key_pem = tls_private_key.ca.private_key_pem
#
#   subject {
#     common_name  = "example.com"
#     organization = "ACME Examples, Inc"
#   }
#
#   validity_period_hours = 87600  # 10 years
#
#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "cert_signing",
#   ]
#
#   is_ca_certificate = true
# }
#
# # 検証用の秘密鍵を生成
# resource "tls_private_key" "verification" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }
#
# # AWS IoT 登録コードを取得
# data "aws_iot_registration_code" "example" {}
#
# # 登録コードを Common Name とする CSR を作成
# resource "tls_cert_request" "verification" {
#   private_key_pem = tls_private_key.verification.private_key_pem
#
#   subject {
#     common_name = data.aws_iot_registration_code.example.registration_code
#   }
# }
#
# # CA の秘密鍵で検証証明書に署名
# resource "tls_locally_signed_cert" "verification" {
#   cert_request_pem   = tls_cert_request.verification.cert_request_pem
#   ca_private_key_pem = tls_private_key.ca.private_key_pem
#   ca_cert_pem        = tls_self_signed_cert.ca.cert_pem
#
#   validity_period_hours = 87600
#
#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "server_auth",
#   ]
# }
#
# # CA 証明書を AWS IoT に登録
# resource "aws_iot_ca_certificate" "example" {
#   active                       = true
#   ca_certificate_pem           = tls_self_signed_cert.ca.cert_pem
#   verification_certificate_pem = tls_locally_signed_cert.verification.cert_pem
#   allow_auto_registration      = true
#   certificate_mode             = "DEFAULT"
#
#   tags = {
#     Name = "example-ca-certificate"
#   }
# }

#---------------------------------------------------------------
# セキュリティのベストプラクティス
#---------------------------------------------------------------
# 1. CA の秘密鍵は AWS に送信しないこと
#    - CA 証明書の公開鍵のみを AWS IoT に登録します
#    - 秘密鍵はオンプレミスの HSM や安全なストレージで管理
#
# 2. 証明書の有効期限を適切に設定
#    - CA 証明書は長期間有効（例: 10 年）
#    - デバイス証明書は短期間有効（例: 1-2 年）で定期的に更新
#
# 3. Just-in-Time Provisioning (JITP) を使用する場合
#    - IAM ロールに最小権限の原則を適用
#    - CloudWatch Logs でプロビジョニングプロセスを監視
#    - CloudTrail で API 呼び出しを監査
#
# 4. タグを活用したアクセス制御
#    - IAM ポリシーでタグベースの条件を使用
#    - Environment タグで本番環境と開発環境を分離
#
# 5. 証明書の無効化とローテーション
#    - 定期的に active = false に設定して古い CA を無効化
#    - 新しい CA 証明書に移行する前に、既存デバイスの影響を評価

#---------------------------------------------------------------
# トラブルシューティング
#---------------------------------------------------------------
# 1. CertificateValidationException
#    - CA 証明書が有効な PEM 形式であることを確認
#    - 証明書が CA 証明書として作成されていることを確認（is_ca_certificate = true）
#
# 2. RegistrationCodeValidationException
#    - 検証証明書の Common Name が AWS IoT 登録コードと一致することを確認
#    - 検証証明書が CA の秘密鍵で正しく署名されていることを確認
#
# 3. ResourceAlreadyExistsException
#    - 同じ CA 証明書が既に DEFAULT モードで登録されている
#    - SNI_ONLY モードを使用するか、別の CA 証明書を使用
#
# 4. デバイスが接続できない
#    - CA 証明書の active が true であることを確認
#    - デバイス証明書が CA によって正しく署名されていることを確認
#    - IoT ポリシーがデバイスに正しくアタッチされていることを確認
#
# 5. JITP/JITR が動作しない
#    - allow_auto_registration が true であることを確認
#    - JITP の場合: registration_config が正しく設定されていることを確認
#    - CloudWatch Logs で詳細なエラーメッセージを確認
