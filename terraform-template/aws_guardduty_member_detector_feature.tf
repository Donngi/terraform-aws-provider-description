#---------------------------------------------------------------
# AWS GuardDuty Member Detector Feature
#---------------------------------------------------------------
#
# Amazon GuardDutyのメンバーアカウントに対して、単一の検出機能（detector feature）を
# 管理するリソースです。管理者アカウントから、メンバーアカウントの各保護プランを
# 個別に有効化・無効化することができます。
#
# 注意: このリソースを削除してもメンバーアカウントの detector feature は無効化されません。
#       Terraform の state から除外されるのみです。
#
# AWS公式ドキュメント:
#   - GuardDuty features activation model: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-features-activation-model.html
#   - MemberFeaturesConfiguration API: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_MemberFeaturesConfiguration.html
#   - メンバーアカウントの管理: https://docs.aws.amazon.com/guardduty/latest/ug/maintaining-guardduty-organization-delegated-admin.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_member_detector_feature
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_member_detector_feature" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # detector_id (Required)
  # 設定内容: 管理者アカウントの GuardDuty 検出器 ID を指定します。
  # 設定可能な値: 有効な GuardDuty 検出器 ID（32文字の16進数文字列）
  detector_id = "abc123def456abc123def456abc12345"

  # account_id (Required)
  # 設定内容: 機能を設定するメンバーアカウントの AWS アカウント ID を指定します。
  # 設定可能な値: 12桁の AWS アカウント ID
  account_id = "123456789012"

  #-------------------------------------------------------------
  # 機能設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 設定する検出機能（保護プラン）の名前を指定します。
  # 設定可能な値:
  #   - "S3_DATA_EVENTS": S3 保護（S3 バケットへのアクセスを監視）
  #   - "EKS_AUDIT_LOGS": EKS 監査ログ保護（EKS クラスターの監査ログを分析）
  #   - "EBS_MALWARE_PROTECTION": EBS マルウェア保護（EBS ボリュームのマルウェアスキャン）
  #   - "RDS_LOGIN_EVENTS": RDS ログインアクティビティ保護（RDS ログインイベントを監視）
  #   - "EKS_RUNTIME_MONITORING": EKS ランタイムモニタリング（非推奨、RUNTIME_MONITORING を使用）
  #   - "RUNTIME_MONITORING": ランタイムモニタリング（EKS/ECS/EC2 のランタイム脅威検出）
  #   - "LAMBDA_NETWORK_LOGS": Lambda ネットワークアクティビティ保護（Lambda のネットワークアクティビティを監視）
  # 注意: "EKS_RUNTIME_MONITORING" と "RUNTIME_MONITORING" を同時に指定するとエラーになります。
  #       RUNTIME_MONITORING は EKS のランタイム脅威検出を含んでいるためです。
  name = "RUNTIME_MONITORING"

  # status (Required)
  # 設定内容: 検出機能の有効・無効を指定します。
  # 設定可能な値:
  #   - "ENABLED": 機能を有効化
  #   - "DISABLED": 機能を無効化
  status = "ENABLED"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 追加設定
  #-------------------------------------------------------------

  # additional_configuration (Optional)
  # 設定内容: 機能の追加設定ブロックを指定します。
  #           RUNTIME_MONITORING 機能を使用する場合、エージェント管理の設定が可能です。
  # 注意: このブロックは複数指定できます（list 型）。
  additional_configuration {
    # name (Required)
    # 設定内容: 追加設定の名前を指定します。
    # 設定可能な値:
    #   - "EKS_ADDON_MANAGEMENT": EKS 用 GuardDuty セキュリティエージェントの自動管理
    #   - "ECS_FARGATE_AGENT_MANAGEMENT": ECS Fargate 用 GuardDuty セキュリティエージェントの自動管理
    #   - "EC2_AGENT_MANAGEMENT": EC2 用 GuardDuty セキュリティエージェントの自動管理
    name = "EKS_ADDON_MANAGEMENT"

    # status (Required)
    # 設定内容: 追加設定の有効・無効を指定します。
    # 設定可能な値:
    #   - "ENABLED": 追加設定を有効化
    #   - "DISABLED": 追加設定を無効化
    status = "ENABLED"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Terraform が管理する内部 ID（detector_id, account_id, name の組み合わせ）
#---------------------------------------------------------------
