#---------------------------------------------------------------
# Amazon GuardDuty Detector Feature
#---------------------------------------------------------------
#
# GuardDutyディテクターの個別機能（保護タイプ）を管理するリソース。
# S3保護、EKS監査ログ、EBSマルウェア保護、RDSログイン監視、
# ランタイム監視、Lambda Network Logsなどの機能を有効化・無効化します。
#
# 注意: このリソースを削除してもディテクターの機能は無効化されず、
#       Terraformのstateから削除されるのみです。
#
# AWS公式ドキュメント:
#   - DetectorFeatureConfiguration API: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_DetectorFeatureConfiguration.html
#   - DetectorAdditionalConfiguration API: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_DetectorAdditionalConfiguration.html
#   - GuardDuty Features: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-features-activation-model.html#guardduty-features
#   - Runtime Monitoring: https://docs.aws.amazon.com/guardduty/latest/ug/runtime-monitoring.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector_feature
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_detector_feature" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # detector_id: GuardDutyディテクターのID
  # GuardDutyディテクター（aws_guardduty_detector）のIDを指定します。
  # 機能を有効化する対象のディテクターを識別します。
  # Example: "12abc34d567e8f901gh2i34jk56l78m9"
  detector_id = aws_guardduty_detector.example.id

  # name: 機能名
  # 有効化・無効化する機能の名前を指定します。
  # 指定可能な値:
  #   - S3_DATA_EVENTS: S3データイベントの保護（不正なデータアクセスや設定変更を検出）
  #   - EKS_AUDIT_LOGS: EKS監査ログ（Kubernetes APIコールの脅威を検出）
  #   - EBS_MALWARE_PROTECTION: EBSマルウェア保護（EC2インスタンスのEBSボリュームをスキャン）
  #   - RDS_LOGIN_EVENTS: RDSログインイベント（AuroraやRDSへの不審なログインを検出）
  #   - EKS_RUNTIME_MONITORING: EKSランタイム監視（EKSクラスター内のOSレベル脅威を検出）
  #   - LAMBDA_NETWORK_LOGS: Lambdaネットワークログ（Lambda関数のVPCフローログを分析）
  #   - RUNTIME_MONITORING: ランタイム監視（EC2、ECS、EKS全般のOSレベル脅威を検出）
  #
  # 重要な注意事項:
  # EKS_RUNTIME_MONITORINGとRUNTIME_MONITORINGの両方を同時に指定することはできません。
  # RUNTIME_MONITORINGにはEKSのランタイム検出機能が既に含まれています。
  #
  # AWS API Reference: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_DetectorFeatureConfiguration.html
  name = "S3_DATA_EVENTS"

  # status: 機能のステータス
  # 機能を有効化するか無効化するかを指定します。
  # 指定可能な値:
  #   - ENABLED: 機能を有効化
  #   - DISABLED: 機能を無効化
  status = "ENABLED"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # region: リージョン
  # (Optional) このリソースを管理するAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  # マルチリージョン構成で特定のリージョンにリソースを作成する場合に使用します。
  # Example: "us-east-1", "ap-northeast-1"
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # ネストブロック: additional_configuration
  #---------------------------------------------------------------

  # additional_configuration: 追加設定
  # (Optional) ランタイム監視機能（EKS_RUNTIME_MONITORINGまたはRUNTIME_MONITORING）の
  # 追加設定ブロックです。エージェントの自動管理などを設定できます。
  # 複数の追加設定を指定可能です（set型）。
  #
  # API Reference: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_DetectorAdditionalConfiguration.html

  # additional_configuration {
  #   # name: 追加設定名
  #   # (Required) 追加設定の名前を指定します。
  #   # 指定可能な値:
  #   #   - EKS_ADDON_MANAGEMENT: EKSアドオンの自動管理
  #   #   - ECS_FARGATE_AGENT_MANAGEMENT: ECS Fargateエージェントの自動管理
  #   #   - EC2_AGENT_MANAGEMENT: EC2エージェントの自動管理
  #   #
  #   # AWS API Reference: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_DetectorAdditionalConfiguration.html
  #   name = "EKS_ADDON_MANAGEMENT"
  #
  #   # status: 追加設定のステータス
  #   # (Required) 追加設定を有効化するか無効化するかを指定します。
  #   # 指定可能な値:
  #   #   - ENABLED: 追加設定を有効化
  #   #   - DISABLED: 追加設定を無効化
  #   status = "ENABLED"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# このリソースでは以下の属性が読み取り専用として利用可能です:
#
# - id: リソースの一意な識別子（Computed）
#   GuardDutyディテクター機能のID
#   Format: "{detector_id}/{feature_name}"
#
#---------------------------------------------------------------
