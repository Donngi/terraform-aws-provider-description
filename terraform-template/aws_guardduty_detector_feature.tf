#---------------------------------------------------------------
# Amazon GuardDuty 検出器機能
#---------------------------------------------------------------
#
# Amazon GuardDuty の検出器に対して個別の機能を有効化・無効化するリソースです。
# GuardDuty は脅威インテリジェンスを使用してAWSアカウント内の悪意のある活動や
# 不正な動作を継続的にモニタリングするセキュリティサービスです。
# このリソースにより、S3保護、EKS保護、RDS保護などの各種保護機能を
# 検出器ごとに細かく制御できます。
#
# AWS公式ドキュメント:
#   - Amazon GuardDuty 機能: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-features-activation-model.html
#   - GuardDuty 検出器: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_finding-types-active.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector_feature
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_detector_feature" "example" {
  #-------------------------------------------------------------
  # 検出器設定
  #-------------------------------------------------------------

  # detector_id (Required)
  # 設定内容: 機能を設定するGuardDuty検出器のIDを指定します。
  # 設定可能な値: aws_guardduty_detector リソースの id 属性
  detector_id = aws_guardduty_detector.example.id

  #-------------------------------------------------------------
  # 機能設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 有効化または無効化するGuardDuty機能の名前を指定します。
  # 設定可能な値:
  #   - "S3_DATA_EVENTS"          : S3データイベント保護
  #   - "EKS_AUDIT_LOGS"          : EKS監査ログ保護
  #   - "EBS_MALWARE_PROTECTION"  : EBSマルウェア保護
  #   - "RDS_LOGIN_EVENTS"        : RDSログインイベント保護
  #   - "EKS_RUNTIME_MONITORING"  : EKSランタイムモニタリング
  #   - "LAMBDA_NETWORK_LOGS"     : Lambdaネットワークログ保護
  #   - "RUNTIME_MONITORING"      : ランタイムモニタリング（EC2/ECS/EKS統合）
  name = "S3_DATA_EVENTS"

  # status (Required)
  # 設定内容: 機能の有効化状態を指定します。
  # 設定可能な値:
  #   - "ENABLED" : 機能を有効化する
  #   - "DISABLED": 機能を無効化する
  status = "ENABLED"

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
  # 追加設定
  #-------------------------------------------------------------

  # additional_configuration (Optional)
  # 設定内容: 機能に対する追加設定を指定するブロックです。
  #          EKSランタイムモニタリングやランタイムモニタリングなど
  #          特定の機能でサブ機能の有効化設定が必要な場合に使用します。
  # 注意: 対応する name の機能でのみ有効です
  additional_configuration {
    # name (Required)
    # 設定内容: 追加設定の名前を指定します。
    # 設定可能な値:
    #   - "EKS_ADDON_MANAGEMENT"         : EKS アドオン管理（EKS_RUNTIME_MONITORING 用）
    #   - "ECS_FARGATE_AGENT_MANAGEMENT" : ECS Fargate エージェント管理（RUNTIME_MONITORING 用）
    #   - "EC2_AGENT_MANAGEMENT"         : EC2 エージェント管理（RUNTIME_MONITORING 用）
    name = "EKS_ADDON_MANAGEMENT"

    # status (Required)
    # 設定内容: 追加設定の有効化状態を指定します。
    # 設定可能な値:
    #   - "ENABLED" : 追加設定を有効化する
    #   - "DISABLED": 追加設定を無効化する
    status = "ENABLED"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 検出器IDと機能名を組み合わせた識別子
#---------------------------------------------------------------
