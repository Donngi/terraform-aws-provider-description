#---------------------------------------------------------------
# Amazon EMR Security Configuration
#---------------------------------------------------------------
#
# Amazon EMR セキュリティ設定を管理するリソース。
# EMR クラスターの暗号化、認証、およびセキュリティ設定を定義します。
#
# 主な機能:
# - 保管時のデータ暗号化設定（S3およびローカルディスク）
# - 転送中のデータ暗号化設定（TLS/SSL）
# - Kerberos認証設定
# - EMRFS の IAM ロール設定
# - EC2インスタンスメタデータサービス（IMDS）設定
#
# AWS公式ドキュメント:
#   - セキュリティ設定の概要: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-security-configurations.html
#   - セキュリティ設定の作成: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-create-security-configuration.html
#   - データ暗号化: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-data-encryption.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/emr_security_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_emr_security_configuration" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # configuration - (必須) JSON形式のセキュリティ設定
  # EMRクラスターのセキュリティ設定をJSON形式で定義します。
  #
  # 設定可能な項目:
  # - EncryptionConfiguration: 暗号化設定
  #   - EnableAtRestEncryption: 保管時の暗号化を有効化
  #   - EnableInTransitEncryption: 転送中の暗号化を有効化
  #   - AtRestEncryptionConfiguration: 保管時の暗号化詳細
  #     - S3EncryptionConfiguration: S3データの暗号化
  #       - EncryptionMode: SSE-S3, SSE-KMS, CSE-KMS, CSE-Custom
  #       - AwsKmsKey: KMSキーのARN（SSE-KMS/CSE-KMSの場合）
  #     - LocalDiskEncryptionConfiguration: ローカルディスクの暗号化
  #       - EncryptionKeyProviderType: AwsKms または Custom
  #       - AwsKmsKey: KMSキーのARN（AwsKmsの場合）
  #       - EnableEbsEncryption: EBSボリュームの暗号化を有効化
  #   - InTransitEncryptionConfiguration: 転送中の暗号化詳細
  #     - TLSCertificateConfiguration: TLS証明書の設定
  #       - CertificateProviderType: PEM または Custom
  #       - S3Object: 証明書ファイルのS3パス
  # - AuthenticationConfiguration: Kerberos認証設定
  # - InstanceMetadataServiceConfiguration: IMDSの設定
  #
  # 例: SSE-S3とローカルディスクAWS KMS暗号化
  configuration = jsonencode({
    EncryptionConfiguration = {
      EnableAtRestEncryption = true
      EnableInTransitEncryption = false
      AtRestEncryptionConfiguration = {
        S3EncryptionConfiguration = {
          EncryptionMode = "SSE-S3"
        }
        LocalDiskEncryptionConfiguration = {
          EncryptionKeyProviderType = "AwsKms"
          AwsKmsKey = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
        }
      }
    }
  })

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # name - (オプション) セキュリティ設定の名前
  # セキュリティ設定を識別する名前を指定します。
  # 指定しない場合は、Terraformによって自動生成されます。
  # name_prefixとの併用はできません。
  #
  # 命名規則:
  # - 最大長: 255文字
  # - 使用可能文字: 英数字、ハイフン、アンダースコア
  # - 同じリージョン内で一意である必要があります
  #
  # デフォルト: Terraformが自動生成
  name = "emr-security-config-example"

  # name_prefix - (オプション) セキュリティ設定名のプレフィックス
  # 指定したプレフィックスで始まる一意の名前を自動生成します。
  # nameとの併用はできません。
  #
  # 用途:
  # - 同じ設定パターンの複数インスタンスを作成する場合
  # - 命名の一貫性を保ちながら一意性を確保する場合
  #
  # 例: "emr-sec-" → "emr-sec-20240115123456789012345678"
  #
  # デフォルト: なし
  # name_prefix = "emr-sec-"

  # region - (オプション) リソースを管理するAWSリージョン
  # このセキュリティ設定を作成するリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  #
  # 注意事項:
  # - セキュリティ設定とEMRクラスターは同じリージョンに配置する必要があります
  # - KMSキーを使用する場合、KMSキーも同じリージョンに存在する必要があります
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # デフォルト: プロバイダー設定のリージョン
  # region = "us-west-2"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only属性）:
#
# - id - セキュリティ設定のID（nameと同じ値）
# - creation_date - セキュリティ設定が作成された日時（RFC3339形式）
#
# これらの属性は他のリソースから参照可能です:
#   aws_emr_security_configuration.example.id
#   aws_emr_security_configuration.example.creation_date
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: SSE-KMSとローカルディスク暗号化、転送中の暗号化も有効
#---------------------------------------------------------------
# resource "aws_emr_security_configuration" "full_encryption" {
#   name = "emr-full-encryption"
#
#   configuration = jsonencode({
#     EncryptionConfiguration = {
#       EnableAtRestEncryption    = true
#       EnableInTransitEncryption = true
#       AtRestEncryptionConfiguration = {
#         S3EncryptionConfiguration = {
#           EncryptionMode = "SSE-KMS"
#           AwsKmsKey      = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
#         }
#         LocalDiskEncryptionConfiguration = {
#           EncryptionKeyProviderType = "AwsKms"
#           AwsKmsKey                 = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
#           EnableEbsEncryption       = true
#         }
#       }
#       InTransitEncryptionConfiguration = {
#         TLSCertificateConfiguration = {
#           CertificateProviderType = "PEM"
#           S3Object                = "s3://my-bucket/certificates/certs.zip"
#         }
#       }
#     }
#   })
# }

#---------------------------------------------------------------
# 使用例: CSE-KMSでクライアント側暗号化
#---------------------------------------------------------------
# resource "aws_emr_security_configuration" "cse_kms" {
#   name = "emr-cse-kms-encryption"
#
#   configuration = jsonencode({
#     EncryptionConfiguration = {
#       EnableAtRestEncryption = true
#       AtRestEncryptionConfiguration = {
#         S3EncryptionConfiguration = {
#           EncryptionMode = "CSE-KMS"
#           AwsKmsKey      = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
#         }
#         LocalDiskEncryptionConfiguration = {
#           EncryptionKeyProviderType = "AwsKms"
#           AwsKmsKey                 = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
#         }
#       }
#     }
#   })
# }

#---------------------------------------------------------------
# 使用例: カスタムキープロバイダーを使用
#---------------------------------------------------------------
# resource "aws_emr_security_configuration" "custom_provider" {
#   name = "emr-custom-encryption"
#
#   configuration = jsonencode({
#     EncryptionConfiguration = {
#       EnableAtRestEncryption    = true
#       EnableInTransitEncryption = true
#       AtRestEncryptionConfiguration = {
#         S3EncryptionConfiguration = {
#           EncryptionMode              = "CSE-Custom"
#           S3Object                    = "s3://my-bucket/providers/MyKeyProvider.jar"
#           EncryptionKeyProviderClass  = "com.example.MyS3KeyProvider"
#         }
#         LocalDiskEncryptionConfiguration = {
#           EncryptionKeyProviderType   = "Custom"
#           S3Object                    = "s3://my-bucket/providers/MyKeyProvider.jar"
#           EncryptionKeyProviderClass  = "com.example.MyDiskKeyProvider"
#         }
#       }
#       InTransitEncryptionConfiguration = {
#         TLSCertificateConfiguration = {
#           CertificateProviderType  = "Custom"
#           S3Object                 = "s3://my-bucket/providers/MyCertProvider.jar"
#           CertificateProviderClass = "com.example.MyCertProvider"
#         }
#       }
#     }
#   })
# }

#---------------------------------------------------------------
# 使用例: Kerberos認証を含む設定
#---------------------------------------------------------------
# resource "aws_emr_security_configuration" "with_kerberos" {
#   name = "emr-kerberos-config"
#
#   configuration = jsonencode({
#     AuthenticationConfiguration = {
#       KerberosConfiguration = {
#         Provider                    = "ClusterDedicatedKdc"
#         ClusterDedicatedKdcConfiguration = {
#           TicketLifetimeInHours = 24
#         }
#       }
#     }
#     EncryptionConfiguration = {
#       EnableAtRestEncryption = true
#       AtRestEncryptionConfiguration = {
#         S3EncryptionConfiguration = {
#           EncryptionMode = "SSE-S3"
#         }
#       }
#     }
#   })
# }

#---------------------------------------------------------------
# 使用例: IMDSv2を強制
#---------------------------------------------------------------
# resource "aws_emr_security_configuration" "imdsv2_required" {
#   name = "emr-imdsv2-required"
#
#   configuration = jsonencode({
#     InstanceMetadataServiceConfiguration = {
#       MinimumInstanceMetadataServiceVersion = 2
#       HttpPutResponseHopLimit               = 1
#     }
#     EncryptionConfiguration = {
#       EnableAtRestEncryption = false
#     }
#   })
# }

#---------------------------------------------------------------
# EMRクラスターでの使用例
#---------------------------------------------------------------
# resource "aws_emr_cluster" "example" {
#   name          = "example-cluster"
#   release_label = "emr-6.10.0"
#   applications  = ["Spark", "Hadoop"]
#
#   # セキュリティ設定を適用
#   security_configuration = aws_emr_security_configuration.example.name
#
#   ec2_attributes {
#     subnet_id                         = aws_subnet.example.id
#     emr_managed_master_security_group = aws_security_group.master.id
#     emr_managed_slave_security_group  = aws_security_group.slave.id
#     instance_profile                  = aws_iam_instance_profile.emr_profile.arn
#   }
#
#   master_instance_group {
#     instance_type = "m5.xlarge"
#   }
#
#   core_instance_group {
#     instance_type  = "m5.xlarge"
#     instance_count = 2
#   }
#
#   service_role = aws_iam_role.emr_service_role.arn
# }

#---------------------------------------------------------------
# 補足情報
#---------------------------------------------------------------
# 1. 暗号化モードの選択
#    - SSE-S3: Amazon S3管理のキー（最もシンプル）
#    - SSE-KMS: AWS KMS管理のキー（キーローテーション、監査ログ）
#    - CSE-KMS: クライアント側暗号化（KMS管理）
#    - CSE-Custom: クライアント側暗号化（カスタムキー）
#
# 2. KMSキーの要件
#    - EMRクラスターと同じリージョンに存在すること
#    - EMRサービスロールに適切な権限を付与すること
#    - キーポリシーでEMRサービスプリンシパルを許可すること
#
# 3. 転送中の暗号化証明書
#    - PEMファイルをZIP形式で用意
#    - 必須ファイル: privateKey.pem, certificateChain.pem
#    - オプション: trustedCertificates.pem
#
# 4. セキュリティ設定の適用
#    - セキュリティ設定はクラスター作成時にのみ適用可能
#    - 既存クラスターには適用できません
#    - クラスター削除後もセキュリティ設定は残ります
#
# 5. コスト
#    - KMSキーの使用には追加料金が発生します
#    - 詳細: https://aws.amazon.com/kms/pricing/
#
# 6. コンプライアンス
#    - PCI DSS, HIPAA等のコンプライアンス要件には暗号化が必須
#    - AWS Security Hubの推奨事項（EMR.3, EMR.4）に準拠
#---------------------------------------------------------------
