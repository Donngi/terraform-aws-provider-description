#---------------------------------------------------------------
# Amazon GuardDuty 組織設定機能
#---------------------------------------------------------------
#
# Amazon GuardDuty の組織設定において、個別の機能を組織メンバーアカウントに
# 対して自動有効化するかどうかを管理するリソースです。
# AWS Organizations と GuardDuty を連携させた際に、委任管理者アカウントが
# メンバーアカウントへの機能の自動展開ポリシーを制御します。
#
# 注意: このリソースを削除しても組織設定機能は無効化されません。
#       Terraformのステートから削除されるだけです。
#
# AWS公式ドキュメント:
#   - GuardDuty 機能の有効化モデル: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-features-activation-model.html
#   - DetectorFeatureConfiguration API: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_DetectorFeatureConfiguration.html
#   - DetectorAdditionalConfiguration API: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_DetectorAdditionalConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration_feature
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_organization_configuration_feature" "example" {
  #-------------------------------------------------------------
  # 検出器設定
  #-------------------------------------------------------------

  # detector_id (Required)
  # 設定内容: 委任管理者の GuardDuty 検出器の ID を指定します。
  # 設定可能な値: aws_guardduty_detector リソースの id 属性
  detector_id = aws_guardduty_detector.example.id

  #-------------------------------------------------------------
  # 機能設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 組織向けに設定する GuardDuty 機能の名前を指定します。
  #          EKS_RUNTIME_MONITORING と RUNTIME_MONITORING はどちらか一方のみ設定可能です。
  # 設定可能な値:
  #   - "S3_DATA_EVENTS"         : S3 データイベント保護
  #   - "EKS_AUDIT_LOGS"         : EKS 監査ログ保護
  #   - "EBS_MALWARE_PROTECTION" : EBS マルウェア保護
  #   - "RDS_LOGIN_EVENTS"       : RDS ログインイベント保護
  #   - "EKS_RUNTIME_MONITORING" : EKS ランタイムモニタリング（RUNTIME_MONITORING と排他）
  #   - "LAMBDA_NETWORK_LOGS"    : Lambda ネットワークログ保護
  #   - "RUNTIME_MONITORING"     : ランタイムモニタリング（EKS_RUNTIME_MONITORING と排他）
  name = "EKS_RUNTIME_MONITORING"

  # auto_enable (Required)
  # 設定内容: 組織内のメンバーアカウントに対してこの機能を自動的に有効化するかを指定します。
  # 設定可能な値:
  #   - "ALL" : 既存および新規のすべてのメンバーアカウントで自動有効化する
  #   - "NEW" : 新規に追加されたメンバーアカウントのみ自動有効化する
  #   - "NONE": 自動有効化しない（手動で個別に設定が必要）
  auto_enable = "ALL"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 追加設定
  #-------------------------------------------------------------

  # additional_configuration (Optional)
  # 設定内容: EKS_RUNTIME_MONITORING または RUNTIME_MONITORING の機能に対する
  #          サブ機能の自動有効化設定を指定するブロックです。
  # 注意: additional_configuration は EKS_RUNTIME_MONITORING または
  #       RUNTIME_MONITORING を name に指定した場合のみ使用できます。
  additional_configuration {
    # name (Required)
    # 設定内容: 追加設定（サブ機能）の名前を指定します。
    # 設定可能な値:
    #   - "EKS_ADDON_MANAGEMENT"         : EKS アドオン管理（EKS_RUNTIME_MONITORING 用）
    #   - "ECS_FARGATE_AGENT_MANAGEMENT" : ECS Fargate エージェント管理（RUNTIME_MONITORING 用）
    #   - "EC2_AGENT_MANAGEMENT"         : EC2 エージェント管理（RUNTIME_MONITORING 用）
    name = "EKS_ADDON_MANAGEMENT"

    # auto_enable (Required)
    # 設定内容: 追加設定をメンバーアカウントに対して自動的に有効化するかを指定します。
    # 設定可能な値:
    #   - "ALL" : 既存および新規のすべてのメンバーアカウントで自動有効化する
    #   - "NEW" : 新規に追加されたメンバーアカウントのみ自動有効化する
    #   - "NONE": 自動有効化しない
    auto_enable = "NEW"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 検出器 ID と機能名を組み合わせた識別子
#---------------------------------------------------------------
