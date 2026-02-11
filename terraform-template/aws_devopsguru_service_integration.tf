#---------------------------------------------------------------
# AWS DevOps Guru Service Integration
#---------------------------------------------------------------
#
# AWS DevOps Guruのサービスインテグレーションをプロビジョニングするリソースです。
# DevOps Guruは、機械学習を使用して運用上の問題を検出し、
# アプリケーションの可用性とパフォーマンスを向上させるサービスです。
#
# このリソースでは以下のサービス統合を管理できます:
#   - KMSサーバーサイド暗号化: DevOps GuruデータのKMS暗号化設定
#   - ログ異常検知: CloudWatch Logsでの異常検知設定
#   - OpsCenter: Systems Manager OpsCenterへのインサイト連携設定
#
# AWS公式ドキュメント:
#   - DevOps Guru概要: https://docs.aws.amazon.com/devops-guru/latest/userguide/welcome.html
#   - データ保護: https://docs.aws.amazon.com/devops-guru/latest/userguide/data-protection.html
#   - サービス統合API: https://docs.aws.amazon.com/devops-guru/latest/APIReference/API_ServiceIntegrationConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/devopsguru_service_integration
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 注意: アカウント全体の設定を意図せず削除することを防ぐため、
#       このリソースを破棄してもTerraformの状態から削除されるだけで、
#       AWS側の設定は削除されません。設定を無効にする場合は、
#       各opt_in_statusを明示的に "DISABLED" に設定してからapplyしてください。
#
#---------------------------------------------------------------

resource "aws_devopsguru_service_integration" "example" {
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
  # KMSサーバーサイド暗号化設定 (kms_server_side_encryption)
  #-------------------------------------------------------------
  # DevOps GuruがサーバーサイドデータをKMSで暗号化するかどうかの設定です。
  # カスタマーマネージドキーを使用することで、組織のコンプライアンスおよび
  # 規制要件を満たすための自己管理型のセキュリティレイヤーを追加できます。
  #
  # 参考: https://docs.aws.amazon.com/devops-guru/latest/APIReference/API_KMSServerSideEncryptionIntegrationConfig.html

  kms_server_side_encryption {
    # opt_in_status (Optional)
    # 設定内容: KMS統合が有効かどうかを指定します。
    # 設定可能な値:
    #   - "ENABLED": KMS暗号化を有効にする
    #   - "DISABLED": KMS暗号化を無効にする
    # 省略時: 現在の設定が維持されます
    opt_in_status = "ENABLED"

    # type (Optional)
    # 設定内容: 使用するKMSキーのタイプを指定します。
    # 設定可能な値:
    #   - "AWS_OWNED_KMS_KEY": DevOps Guruが管理するAWS所有のキーを使用
    #   - "CUSTOMER_MANAGED_KEY": ユーザーが作成・管理するカスタマーマネージドキーを使用
    # 省略時: 現在の設定が維持されます
    # 注意: CUSTOMER_MANAGED_KEYを選択した場合はkms_key_idの指定が必要です
    type = "AWS_OWNED_KMS_KEY"

    # kms_key_id (Optional)
    # 設定内容: 使用するKMSキーを指定します。
    # 設定可能な値:
    #   - キーID（例: "1234abcd-12ab-34cd-56ef-1234567890ab"）
    #   - キーARN（例: "arn:aws:kms:us-east-1:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"）
    #   - エイリアス名（例: "alias/my-key"）
    #   - エイリアスARN（例: "arn:aws:kms:us-east-1:123456789012:alias/my-key"）
    # 省略時: 現在の設定が維持されます
    # 注意:
    #   - typeが "CUSTOMER_MANAGED_KEY" の場合のみ必要です
    #   - エイリアス名を使用する場合は "alias/" プレフィックスが必要です
    #   - 別のAWSアカウントのKMSキーを指定する場合はキーARNまたはエイリアスARNを使用してください
    #   - 文字数制限: 1〜2048文字
    kms_key_id = null
  }

  #-------------------------------------------------------------
  # ログ異常検知設定 (logs_anomaly_detection)
  #-------------------------------------------------------------
  # DevOps GuruがAmazon CloudWatch Logsグループに対して
  # 異常検知を実行するかどうかの設定です。
  # 有効にすると、ログデータのパターンを分析し、
  # 通常とは異なる動作を自動的に検出します。

  logs_anomaly_detection {
    # opt_in_status (Optional)
    # 設定内容: CloudWatch Logsでの異常検知が有効かどうかを指定します。
    # 設定可能な値:
    #   - "ENABLED": ログ異常検知を有効にする
    #   - "DISABLED": ログ異常検知を無効にする
    # 省略時: 現在の設定が維持されます
    opt_in_status = "ENABLED"
  }

  #-------------------------------------------------------------
  # OpsCenter連携設定 (ops_center)
  #-------------------------------------------------------------
  # DevOps Guruが作成した各インサイトに対して、
  # AWS Systems Manager OpsCenterにOpsItemを作成するかどうかの設定です。
  # OpsItemを使用することで、運用上の問題を一元的に追跡・管理できます。
  #
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/OpsCenter.html

  ops_center {
    # opt_in_status (Optional)
    # 設定内容: OpsCenter連携が有効かどうかを指定します。
    # 設定可能な値:
    #   - "ENABLED": インサイト作成時にOpsItemを自動作成する
    #   - "DISABLED": OpsItemを自動作成しない
    # 省略時: 現在の設定が維持されます
    opt_in_status = "ENABLED"
  }
}

#---------------------------------------------------------------
# カスタマーマネージドKMSキーを使用する例
#---------------------------------------------------------------
# カスタマーマネージドキーを使用して暗号化する場合の設定例です。
# 自己管理型のセキュリティレイヤーを追加し、
# 組織のコンプライアンス要件を満たすことができます。
#
# resource "aws_kms_key" "devopsguru" {
#   description             = "KMS key for DevOps Guru encryption"
#   deletion_window_in_days = 7
#   enable_key_rotation     = true
# }
#
# resource "aws_devopsguru_service_integration" "with_cmk" {
#   kms_server_side_encryption {
#     kms_key_id    = aws_kms_key.devopsguru.arn
#     opt_in_status = "ENABLED"
#     type          = "CUSTOMER_MANAGED_KEY"
#   }
#
#   logs_anomaly_detection {
#     opt_in_status = "DISABLED"
#   }
#
#   ops_center {
#     opt_in_status = "DISABLED"
#   }
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWSリージョン（非推奨: deprecated）
#
#---------------------------------------------------------------
