#---------------------------------------------------------------
# AWS GuardDuty Member Detector Feature
#---------------------------------------------------------------
#
# メンバーアカウントの単一のAmazon GuardDuty検出機能を管理するリソースです。
# このリソースを使用すると、GuardDuty組織の管理アカウントまたは委任管理者アカウントから
# メンバーアカウントの個別の検出機能（S3データイベント、EKS監査ログ、ランタイム監視など）を
# 有効化・無効化できます。
#
# AWS公式ドキュメント:
#   - GuardDuty 機能アクティベーションモデル: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-features-activation-model.html
#   - UpdateMemberDetectors API: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_UpdateMemberDetectors.html
#   - MemberFeaturesConfiguration API: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_MemberFeaturesConfiguration.html
#   - MemberAdditionalConfiguration API: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_MemberAdditionalConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_member_detector_feature
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 重要な注意事項:
#   - このリソースを削除してもメンバーアカウントの検出機能は無効化されません。
#     リソースは単にステートから削除されるだけです。
#   - メンバーアカウントの検出機能を管理するには、管理アカウントまたは
#     委任管理者アカウントから実行する必要があります。
#
#---------------------------------------------------------------

resource "aws_guardduty_member_detector_feature" "example" {
  #-------------------------------------------------------------
  # 基本設定 (Required)
  #-------------------------------------------------------------

  # detector_id (Required)
  # 設定内容: Amazon GuardDuty検出器IDを指定します。
  # 設定可能な値: 既存のGuardDuty検出器のID
  # 用途: どのGuardDuty検出器に関連付けられたメンバーアカウントの機能を
  #       管理するかを指定します。通常は aws_guardduty_detector リソースの
  #       id 属性を参照します。
  # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_managing_detector.html
  detector_id = null # 例: aws_guardduty_detector.example.id

  # account_id (Required)
  # 設定内容: 更新対象のメンバーアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 用途: GuardDuty組織内のどのメンバーアカウントの検出機能を管理するかを指定します。
  #       このアカウントは事前に aws_guardduty_member リソースで招待・承認されている
  #       必要があります。
  # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_accounts.html
  account_id = "123456789012"

  #-------------------------------------------------------------
  # 検出機能設定 (Required)
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 検出機能の名前を指定します。
  # 設定可能な値:
  #   - "S3_DATA_EVENTS": S3バケットへのデータアクセスイベントを監視
  #   - "EKS_AUDIT_LOGS": Amazon EKSクラスターの監査ログを監視
  #   - "EBS_MALWARE_PROTECTION": EBSボリュームのマルウェアスキャン
  #   - "RDS_LOGIN_EVENTS": RDSデータベースへのログインイベントを監視
  #   - "EKS_RUNTIME_MONITORING": EKSワークロードのランタイム動作を監視
  #   - "RUNTIME_MONITORING": EC2インスタンスとFargateタスクのランタイム監視
  #   - "LAMBDA_NETWORK_LOGS": Lambda関数のネットワークアクティビティログを監視
  # 機能の説明:
  #   - S3_DATA_EVENTS: S3バケットに対する不審なアクセスパターンや
  #     データ流出の兆候を検出します。CloudTrailデータイベントを使用します。
  #   - EKS_AUDIT_LOGS: Kubernetesの監査ログを分析し、EKSクラスター内の
  #     不正なアクティビティを検出します。
  #   - EBS_MALWARE_PROTECTION: EBSボリュームのスナップショットをスキャンし
  #     マルウェアの存在を検出します。
  #   - RDS_LOGIN_EVENTS: RDSデータベースへの疑わしいログイン試行や
  #     異常なアクセスパターンを検出します。
  #   - EKS_RUNTIME_MONITORING: EKSポッド内の実行時動作を監視し、
  #     不審なプロセス実行やファイルアクセスを検出します。
  #   - RUNTIME_MONITORING: EC2インスタンスやFargateタスクでのランタイム動作を
  #     監視し、不正なプロセスやネットワーク通信を検出します。
  #   - LAMBDA_NETWORK_LOGS: Lambda関数のVPCフローログを分析し、
  #     異常なネットワーク接続を検出します。
  # 注意事項:
  #   - 機能によっては追加料金が発生する場合があります。
  #   - EKS_RUNTIME_MONITORINGとRUNTIME_MONITORINGは重複する機能であり、
  #     同時に指定するとエラーになる可能性があります。
  # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-features-activation-model.html
  name = "S3_DATA_EVENTS"

  # status (Required)
  # 設定内容: 検出機能のステータスを指定します。
  # 設定可能な値:
  #   - "ENABLED": 検出機能を有効化
  #   - "DISABLED": 検出機能を無効化
  # 用途: メンバーアカウントで特定の検出機能を有効化または無効化します。
  #       組織全体で統一したセキュリティポリシーを適用する際に使用します。
  # 注意事項: 機能を有効化すると、関連する監視データの収集とスキャンが開始され、
  #           追加料金が発生する可能性があります。
  # 参考: https://aws.amazon.com/guardduty/pricing/
  status = "ENABLED"

  #-------------------------------------------------------------
  # 追加設定 (Optional)
  #-------------------------------------------------------------

  # additional_configuration (Optional)
  # 設定内容: 検出機能に対する追加の設定を指定します。
  # 用途: 特定の検出機能に対して、さらに細かい設定オプションを有効化・無効化します。
  #       例えば、EKS_RUNTIME_MONITORINGに対してEKS_ADDON_MANAGEMENTを有効化したり、
  #       RUNTIME_MONITORINGに対してECS_FARGATE_AGENT_MANAGEMENTを有効化できます。
  # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-features-activation-model.html
  additional_configuration {
    # name (Required)
    # 設定内容: 追加設定の名前を指定します。
    # 設定可能な値:
    #   - "EKS_ADDON_MANAGEMENT": EKSアドオンの自動管理を有効化
    #                             （EKS_RUNTIME_MONITORING機能に関連）
    #   - "ECS_FARGATE_AGENT_MANAGEMENT": ECS FargateタスクのGuardDutyエージェント
    #                                      自動管理を有効化（RUNTIME_MONITORING機能に関連）
    # 機能の説明:
    #   - EKS_ADDON_MANAGEMENT: GuardDutyセキュリティエージェントをEKSアドオンとして
    #     自動的にデプロイ・管理します。手動でのエージェント管理が不要になります。
    #   - ECS_FARGATE_AGENT_MANAGEMENT: Fargateタスクに対してGuardDutyエージェントを
    #     自動的にインジェクトして管理します。
    # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/runtime-monitoring.html
    name = "EKS_ADDON_MANAGEMENT"

    # status (Required)
    # 設定内容: 追加設定のステータスを指定します。
    # 設定可能な値:
    #   - "ENABLED": 追加設定を有効化
    #   - "DISABLED": 追加設定を無効化
    # 用途: 検出機能のサブ機能を個別に制御します。
    status = "ENABLED"
  }

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # 用途: マルチリージョン環境で、特定のリージョンのGuardDuty検出機能を
  #       管理する際に明示的に指定します。
  # 注意事項: GuardDutyはリージョナルサービスのため、各リージョンごとに
  #           設定が必要です。
  # 参考:
  #   - リージョナルエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #   - プロバイダー設定: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #   - GuardDutyリージョン一覧: https://docs.aws.amazon.com/general/latest/gr/guardduty.html
  # region = "us-east-1"
}

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# 以下は、GuardDuty検出器とメンバーアカウントを設定した上で、
# S3データイベント監視機能を有効化する例です。
#
# resource "aws_guardduty_detector" "example" {
#   enable = true
# }
#
# resource "aws_guardduty_member" "example" {
#   detector_id = aws_guardduty_detector.example.id
#   account_id  = "123456789012"
#   email       = "member@example.com"
#   invite      = true
# }
#
# resource "aws_guardduty_member_detector_feature" "s3_data_events" {
#   detector_id = aws_guardduty_detector.example.id
#   account_id  = aws_guardduty_member.example.account_id
#   name        = "S3_DATA_EVENTS"
#   status      = "ENABLED"
# }
#
# # EKSランタイム監視を有効化し、アドオン管理も有効化する例
# resource "aws_guardduty_member_detector_feature" "eks_runtime_monitoring" {
#   detector_id = aws_guardduty_detector.example.id
#   account_id  = aws_guardduty_member.example.account_id
#   name        = "EKS_RUNTIME_MONITORING"
#   status      = "ENABLED"
#
#   additional_configuration {
#     name   = "EKS_ADDON_MANAGEMENT"
#     status = "ENABLED"
#   }
# }
#
# # ランタイム監視を有効化し、Fargateエージェント管理も有効化する例
# resource "aws_guardduty_member_detector_feature" "runtime_monitoring" {
#   detector_id = aws_guardduty_detector.example.id
#   account_id  = aws_guardduty_member.example.account_id
#   name        = "RUNTIME_MONITORING"
#   status      = "ENABLED"
#
#   additional_configuration {
#     name   = "ECS_FARGATE_AGENT_MANAGEMENT"
#     status = "ENABLED"
#   }
# }
#
# # 複数の機能を同時に管理する例
# resource "aws_guardduty_member_detector_feature" "ebs_malware_protection" {
#   detector_id = aws_guardduty_detector.example.id
#   account_id  = aws_guardduty_member.example.account_id
#   name        = "EBS_MALWARE_PROTECTION"
#   status      = "ENABLED"
# }
#
# resource "aws_guardduty_member_detector_feature" "rds_login_events" {
#   detector_id = aws_guardduty_detector.example.id
#   account_id  = aws_guardduty_member.example.account_id
#   name        = "RDS_LOGIN_EVENTS"
#   status      = "ENABLED"
# }
#
# resource "aws_guardduty_member_detector_feature" "lambda_network_logs" {
#   detector_id = aws_guardduty_detector.example.id
#   account_id  = aws_guardduty_member.example.account_id
#   name        = "LAMBDA_NETWORK_LOGS"
#   status      = "ENABLED"
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: メンバー検出機能の識別子
#       形式: {detector_id}/{account_id}/{feature_name}
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のGuardDutyメンバー検出機能は以下の形式でインポートできます:
#
# terraform import aws_guardduty_member_detector_feature.example \
#   {detector_id}/{account_id}/{feature_name}
#
# 例:
# terraform import aws_guardduty_member_detector_feature.s3_data_events \
#   00b00fd5aecc0ab60a708659477e9617/123456789012/S3_DATA_EVENTS
#---------------------------------------------------------------
