#---------------------------------------------------------------
# Amazon GuardDuty Detector
#---------------------------------------------------------------
#
# Amazon GuardDutyのディテクターリソースをプロビジョニングします。
# ディテクターはGuardDutyを有効にし、指定されたリージョンで脅威検出を
# 実行するために必要な基盤コンポーネントです。
#
# 注意事項:
# - このリソースを削除すると、そのリージョンでGuardDutyが「無効化」され、
#   既存のすべてのfindingsが削除されます
# - 監視を一時停止したい場合は、enable = false を設定してください
# - メンバーアカウントでは、finding_publishing_frequency は
#   プライマリアカウントで決定され、変更できません
#
# AWS公式ドキュメント:
#   - Suspending or Disabling GuardDuty: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_suspend-disable.html
#   - S3 Protection: https://docs.aws.amazon.com/guardduty/latest/ug/s3-protection.html
#   - EKS Protection: https://docs.aws.amazon.com/guardduty/latest/ug/kubernetes-protection.html
#   - Malware Protection: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_malware_protection-ebs-volume-data.html
#   - EventBridge Integration: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings_eventbridge.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_detector" "example" {
  # --------------------------------------------------
  # 基本設定
  # --------------------------------------------------

  # enable - (Optional) GuardDutyの監視とフィードバックレポートを有効化します
  # 説明:
  #   - false に設定すると、GuardDutyの監視が「一時停止」されます
  #   - 一時停止中も既存のfindingsは保持されます
  #   - 一時停止中はGuardDutyの課金は発生しません
  #   - デフォルト: true
  # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_suspend-disable.html
  enable = true

  # finding_publishing_frequency - (Optional) 後続のfinding発生時の通知頻度を指定します
  # 説明:
  #   - メンバーアカウントの場合、この値はプライマリアカウントで決定され変更不可
  #   - スタンドアロンおよびプライマリアカウントでは、ドリフト検出を有効にするために
  #     Terraformで設定が必要です
  #   - 有効な値: FIFTEEN_MINUTES, ONE_HOUR, SIX_HOURS
  #   - デフォルト: SIX_HOURS
  # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings_eventbridge.html
  finding_publishing_frequency = "SIX_HOURS"

  # region - (Optional) このリソースを管理するリージョンを指定します
  # 説明:
  #   - 指定しない場合、プロバイダー設定のリージョンが使用されます
  #   - GuardDutyはリージョンごとに有効化する必要があります
  #   - 各アカウントは1リージョンあたり1つのディテクターのみ持つことができます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # --------------------------------------------------
  # タグ設定
  # --------------------------------------------------

  # tags - (Optional) リソースに付与するタグのキー・バリューマップ
  # 説明:
  #   - プロバイダーのdefault_tags設定ブロックと併用可能
  #   - 同じキーのタグはこちらで上書きされます
  tags = {
    Name        = "example-guardduty-detector"
    Environment = "production"
  }

  # tags_all - (Optional) リソースに割り当てられたすべてのタグマップ
  # 説明:
  #   - プロバイダーのdefault_tagsから継承されたタグを含みます
  #   - 通常はTerraformによって自動管理されます
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags_all = {}

  # id - (Optional) GuardDutyディテクターのID
  # 説明:
  #   - 通常はTerraformによって自動生成されます
  #   - 明示的に指定することも可能ですが、推奨されません
  # id = null

  # --------------------------------------------------
  # データソース設定（非推奨）
  # --------------------------------------------------
  # 注意: datasourcesブロックは2023年3月から非推奨です
  # 代わりに aws_guardduty_detector_feature リソースの使用を推奨します
  # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-feature-object-api-changes-march2023.html

  # datasources - (Optional, Deprecated) ディテクターで有効化するデータソースを設定します
  # 説明:
  #   - このブロックは非推奨となり、aws_guardduty_detector_feature リソースへの
  #     移行が推奨されています
  #   - 既存の設定との互換性のために残されています
  #   - 各データソースは特定の脅威検出機能に対応しています:
  #     * s3_logs: S3バケットへの不審なアクセスを監視
  #     * kubernetes: EKSクラスターの監査ログを監視
  #     * malware_protection: EC2インスタンスのマルウェアスキャンを実行
  datasources {
    # --------------------------------------------------
    # S3 Protection設定
    # --------------------------------------------------
    # S3バケットへのデータ漏洩や破壊の試みを検出します
    # CloudTrailのS3データイベントを分析します
    # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/s3-protection.html
    s3_logs {
      # enable - (Required) S3 Protectionを有効化するかどうか
      # 説明:
      #   - S3オブジェクトレベルのAPI操作を監視します
      #   - 不正なアクセスやデータ漏洩の試みを検出します
      #   - デフォルト: true
      enable = true
    }

    # --------------------------------------------------
    # Kubernetes Protection設定
    # --------------------------------------------------
    # EKSクラスターへの脅威を検出します
    # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/kubernetes-protection.html
    kubernetes {
      # audit_logs - (Required) Kubernetes監査ログをデータソースとして設定します
      audit_logs {
        # enable - (Required) Kubernetes監査ログの監視を有効化するかどうか
        # 説明:
        #   - EKSクラスター内のユーザー活動、APIコール、コントロールプレーン操作を監視
        #   - 認証されていないユーザーによるリソース改ざんの試みを検出
        #   - デフォルト: true
        enable = false
      }
    }

    # --------------------------------------------------
    # Malware Protection設定
    # --------------------------------------------------
    # EC2インスタンスとコンテナワークロードのマルウェアを検出します
    # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_malware_protection-ebs-volume-data.html
    malware_protection {
      # scan_ec2_instance_with_findings - (Required) findingsを持つEC2インスタンスの
      # マルウェアスキャンを設定します
      scan_ec2_instance_with_findings {
        # ebs_volumes - (Required) EBSボリュームのスキャンを設定します
        ebs_volumes {
          # enable - (Required) EBSボリュームのマルウェアスキャンを有効化するかどうか
          # 説明:
          #   - GuardDutyがfindingsを生成した際に、関連するEBSボリュームを
          #     自動的にスキャンします
          #   - スキャンはエージェントレスで、EBSスナップショットを使用します
          #   - スキャン後、レプリカボリュームとスナップショットは自動削除されます
          #   - デフォルト: true
          enable = true
        }
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - account_id - GuardDutyディテクターのAWSアカウントID
# - arn - GuardDutyディテクターのAmazon Resource Name (ARN)
# - id - GuardDutyディテクターのID
# - tags_all - プロバイダーのdefault_tagsから継承されたタグを含む、
#              リソースに割り当てられたすべてのタグマップ
#
# 使用例:
#   output "detector_id" {
#     value = aws_guardduty_detector.example.id
#   }
#
#   output "detector_arn" {
#     value = aws_guardduty_detector.example.arn
#   }
#---------------------------------------------------------------
