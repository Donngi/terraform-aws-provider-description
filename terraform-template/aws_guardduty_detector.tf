#---------------------------------------------------------------
# Amazon GuardDuty Detector
#---------------------------------------------------------------
#
# Amazon GuardDuty の検出器（Detector）をプロビジョニングするリソースです。
# 検出器は、GuardDuty によるセキュリティ脅威の継続的なモニタリングと
# 検出結果のレポートを管理するコアコンポーネントです。
# このリソースを削除すると、対象リージョンの GuardDuty が無効化され、
# 既存の検出結果がすべて削除されます。モニタリングを一時停止するには
# enable = false を使用してください。
#
# AWS公式ドキュメント:
#   - Amazon GuardDuty とは: https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html
#   - 検出器の管理: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_suspend-disable.html
#   - 検出結果の CloudWatch 通知頻度: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings_cloudwatch.html#guardduty_findings_cloudwatch_notification_frequency
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_detector" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # enable (Optional)
  # 設定内容: モニタリングとフィードバックレポートを有効にするかを指定します。
  # 設定可能な値:
  #   - true: GuardDuty によるモニタリングを有効化
  #   - false: GuardDuty を「一時停止」状態にし、既存データを保持したままモニタリングを停止
  # 省略時: true
  # 注意: このリソースを削除するとリージョンの GuardDuty が無効化され全検出結果が削除されます。
  #       モニタリングを一時停止する場合は false を設定し、リソース自体は保持してください。
  enable = true

  #-------------------------------------------------------------
  # 検出結果通知設定
  #-------------------------------------------------------------

  # finding_publishing_frequency (Optional)
  # 設定内容: 同一の検出結果が繰り返し発生した場合の後続通知の送信頻度を指定します。
  # 設定可能な値:
  #   - "FIFTEEN_MINUTES": 15分ごとに通知（スタンドアロンおよびプライマリアカウントのみ）
  #   - "ONE_HOUR": 1時間ごとに通知（スタンドアロンおよびプライマリアカウントのみ）
  #   - "SIX_HOURS": 6時間ごとに通知（デフォルト）
  # 省略時: SIX_HOURS
  # 注意: GuardDuty メンバーアカウントの場合、この値はプライマリアカウントによって決定され
  #       変更できません。ドリフト検出を有効にするためには Terraform での設定が推奨されます。
  # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings_cloudwatch.html#guardduty_findings_cloudwatch_notification_frequency
  finding_publishing_frequency = "SIX_HOURS"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # データソース設定（非推奨）
  #-------------------------------------------------------------

  # datasources (Optional, Deprecated)
  # 設定内容: GuardDuty の検出器で有効にするデータソースを設定するブロックです。
  # 注意: このブロックは 2023年3月 より非推奨です。代わりに aws_guardduty_detector_feature
  #       リソースを使用してください。
  # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-feature-object-api-changes-march2023.html
  datasources {

    #-------------------------------------------------------------
    # S3保護設定
    #-------------------------------------------------------------

    # s3_logs (Optional)
    # 設定内容: S3 保護のデータソースを設定するブロックです。
    # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/s3-protection.html
    s3_logs {

      # enable (Required)
      # 設定内容: S3 保護を有効にするかを指定します。
      # 設定可能な値:
      #   - true: S3 保護を有効化
      #   - false: S3 保護を無効化
      enable = true
    }

    #-------------------------------------------------------------
    # Kubernetes保護設定
    #-------------------------------------------------------------

    # kubernetes (Optional)
    # 設定内容: Kubernetes 保護のデータソースを設定するブロックです。
    # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/kubernetes-protection.html
    kubernetes {

      # audit_logs (Required)
      # 設定内容: Kubernetes 監査ログをデータソースとして設定するブロックです。
      audit_logs {

        # enable (Required)
        # 設定内容: Kubernetes 監査ログを Kubernetes 保護のデータソースとして有効にするかを指定します。
        # 設定可能な値:
        #   - true: Kubernetes 監査ログを有効化
        #   - false: Kubernetes 監査ログを無効化
        enable = false
      }
    }

    #-------------------------------------------------------------
    # マルウェア保護設定
    #-------------------------------------------------------------

    # malware_protection (Optional)
    # 設定内容: マルウェア保護のデータソースを設定するブロックです。
    # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/malware-protection.html
    malware_protection {

      # scan_ec2_instance_with_findings (Required)
      # 設定内容: 検出結果のある EC2 インスタンスに対するマルウェア保護を設定するブロックです。
      scan_ec2_instance_with_findings {

        # ebs_volumes (Required)
        # 設定内容: 検出結果のあるインスタンスの EBS ボリュームスキャンを設定するブロックです。
        ebs_volumes {

          # enable (Required)
          # 設定内容: マルウェア保護として EBS ボリュームのスキャンを有効にするかを指定します。
          # 設定可能な値:
          #   - true: EBS ボリュームスキャンを有効化
          #   - false: EBS ボリュームスキャンを無効化
          enable = true
        }
      }
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-guardduty-detector"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - account_id: GuardDuty 検出器に関連付けられた AWS アカウント ID
# - arn: GuardDuty 検出器の Amazon Resource Name (ARN)
# - id: GuardDuty 検出器の ID
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
