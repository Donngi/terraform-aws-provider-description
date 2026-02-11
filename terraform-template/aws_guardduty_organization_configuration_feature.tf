#---------------------------------------------------------------
# GuardDuty Organization Configuration Feature
#---------------------------------------------------------------
#
# Amazon GuardDutyの組織レベルでの機能設定を管理するリソース。
# 委任された管理者アカウントが、組織内のメンバーアカウントに対して
# GuardDutyの保護機能（S3 Protection、EKS Runtime Monitoring、
# RDS Login Events等）の自動有効化設定を制御する。
#
# AWS公式ドキュメント:
#   - GuardDuty features activation model: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-features-activation-model.html
#   - Managing GuardDuty with AWS Organizations: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_organizations.html
#   - OrganizationFeatureConfiguration API: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_OrganizationFeatureConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/guardduty_organization_configuration_feature
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_organization_configuration_feature" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # detector_id - (Required) GuardDutyディテクターのID
  # 組織の委任管理者アカウントで作成されたGuardDutyディテクターのIDを指定。
  # このディテクターを通じて組織全体の機能設定を管理する。
  detector_id = "12abc34d567e8fa901bc2d34e56789f0"

  # name - (Required) 組織に対して設定する機能の名前
  # 有効な値:
  #   - S3_DATA_EVENTS: S3バケットのデータイベント監視
  #   - EKS_AUDIT_LOGS: EKSクラスターのKubernetes監査ログ監視
  #   - EBS_MALWARE_PROTECTION: EBSボリュームのマルウェアスキャン
  #   - RDS_LOGIN_EVENTS: RDSインスタンスのログインイベント監視
  #   - EKS_RUNTIME_MONITORING: EKSワークロードのランタイム監視
  #   - LAMBDA_NETWORK_LOGS: Lambda関数のネットワークアクティビティ監視
  #   - RUNTIME_MONITORING: EC2/ECSワークロードのランタイム監視
  #
  # 注意: EKS_RUNTIME_MONITORINGとRUNTIME_MONITORINGは両方を同時に追加できない。
  # 詳細: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_DetectorFeatureConfiguration.html
  name = "EKS_RUNTIME_MONITORING"

  # auto_enable - (Required) 組織内のメンバーアカウントに対する機能の自動有効化設定
  # 有効な値:
  #   - NEW: 新規に組織に追加されるアカウントのみ自動有効化
  #   - ALL: 既存・新規を含む全メンバーアカウントで自動有効化
  #   - NONE: 自動有効化しない（手動での有効化が必要）
  auto_enable = "NEW"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # region - (Optional) このリソースを管理するAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用される。
  # GuardDutyはリージョナルサービスのため、各リージョンで個別に設定が必要。
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Nested Blocks
  #---------------------------------------------------------------

  # additional_configuration - (Optional) 追加の機能設定ブロック
  # EKS_RUNTIME_MONITORINGまたはRUNTIME_MONITORING機能に対する
  # 補完的な設定を追加する際に使用。
  #
  # 使用例: EKS_RUNTIME_MONITORING使用時にアドオン管理を自動有効化
  additional_configuration {
    # name - (Required) 追加設定の名前
    # 有効な値:
    #   - EKS_ADDON_MANAGEMENT: EKSアドオンとしてGuardDutyエージェントを管理
    #   - ECS_FARGATE_AGENT_MANAGEMENT: ECS Fargateタスクのエージェント管理
    #   - EC2_AGENT_MANAGEMENT: EC2インスタンスのエージェント管理
    # 詳細: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_DetectorAdditionalConfiguration.html
    name = "EKS_ADDON_MANAGEMENT"

    # auto_enable - (Required) 追加設定の自動有効化ステータス
    # 有効な値:
    #   - NEW: 新規メンバーアカウントのみ自動有効化
    #   - ALL: 全メンバーアカウントで自動有効化
    #   - NONE: 自動有効化しない
    auto_enable = "NEW"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id - リソースの一意な識別子（computed）
#   形式: detector_id/name
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のGuardDuty組織設定機能は以下の形式でインポート可能:
#
# terraform import aws_guardduty_organization_configuration_feature.example detector_id/name
#
# 例:
# terraform import aws_guardduty_organization_configuration_feature.example 12abc34d567e8fa901bc2d34e56789f0/EKS_RUNTIME_MONITORING
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Important Notes
#---------------------------------------------------------------
# 1. このリソースを削除してもGuardDutyの組織設定機能は無効化されない。
#    Terraformのstateから削除されるのみ。
#
# 2. GuardDutyはリージョナルサービスのため、マルチリージョン構成の場合は
#    各リージョンで個別にこのリソースを設定する必要がある。
#
# 3. 委任管理者アカウントでのみこのリソースを作成できる。
#    管理アカウントまたはメンバーアカウントでは操作不可。
#
# 4. EKS_RUNTIME_MONITORINGとRUNTIME_MONITORINGは排他的な機能であり、
#    両方を同時に有効化するとエラーになる。
#
#---------------------------------------------------------------
