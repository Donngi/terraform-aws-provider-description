#---------------------------------------------------------------
# Amazon GuardDuty 組織設定
#---------------------------------------------------------------
#
# Amazon GuardDuty の Organizations 統合における委任管理者アカウントの
# 組織全体設定を管理するリソースです。
# 組織内のメンバーアカウントに対して GuardDuty を自動的に有効化する方針を
# 設定できます。このリソースは委任管理者アカウントで適用する必要があります。
#
# AWS公式ドキュメント:
#   - GuardDuty Organizations 統合: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_organizations.html
#   - 委任管理者の設定: https://docs.aws.amazon.com/guardduty/latest/ug/admin-account-enable-gd.html
#   - メンバーアカウントの自動有効化: https://docs.aws.amazon.com/guardduty/latest/ug/administrative-account-add-auto-enable.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_organization_configuration" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # detector_id (Required)
  # 設定内容: 組織設定を適用する GuardDuty 検出器のIDを指定します。
  # 設定可能な値: aws_guardduty_detector リソースの id 属性
  detector_id = aws_guardduty_detector.example.id

  # auto_enable_organization_members (Required)
  # 設定内容: 組織内のメンバーアカウントに対して GuardDuty を自動的に有効化する方針を指定します。
  # 設定可能な値:
  #   - "ALL"     : 既存および新規のメンバーアカウントすべてに GuardDuty を自動有効化
  #   - "NEW"     : 新たに組織に追加されるメンバーアカウントのみに GuardDuty を自動有効化
  #   - "NONE"    : 自動有効化を行わない。手動でメンバーアカウントを有効化する必要あり
  auto_enable_organization_members = "NEW"

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
  # 設定内容: 組織内のメンバーアカウントで有効化するデータソースの自動設定を行うブロックです。
  # 注意: このブロックは非推奨です。代わりに aws_guardduty_organization_configuration_feature
  #       リソースを使用してください。
  # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-feature-object-api-changes-march2023.html
  datasources {

    #-----------------------------------------------------------
    # S3保護設定
    #-----------------------------------------------------------

    # s3_logs (Optional)
    # 設定内容: 組織のメンバーアカウントに対する S3 保護の自動有効化設定ブロックです。
    # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/s3-protection.html
    s3_logs {

      # auto_enable (Required)
      # 設定内容: 新規メンバーアカウントに対して S3 保護を自動的に有効化するかを指定します。
      # 設定可能な値:
      #   - true : S3 保護を自動有効化する
      #   - false: S3 保護を自動有効化しない
      auto_enable = true
    }

    #-----------------------------------------------------------
    # Kubernetes保護設定
    #-----------------------------------------------------------

    # kubernetes (Optional)
    # 設定内容: 組織のメンバーアカウントに対する Kubernetes 保護の自動有効化設定ブロックです。
    # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/kubernetes-protection.html
    kubernetes {

      # audit_logs (Required)
      # 設定内容: Kubernetes 監査ログの自動有効化を設定するブロックです。
      audit_logs {

        # enable (Required)
        # 設定内容: 新規メンバーアカウントに対して Kubernetes 監査ログを自動的に有効化するかを指定します。
        # 設定可能な値:
        #   - true : Kubernetes 監査ログを自動有効化する
        #   - false: Kubernetes 監査ログを自動有効化しない
        enable = false
      }
    }

    #-----------------------------------------------------------
    # マルウェア保護設定
    #-----------------------------------------------------------

    # malware_protection (Optional)
    # 設定内容: 組織のメンバーアカウントに対するマルウェア保護の自動有効化設定ブロックです。
    # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/malware-protection.html
    malware_protection {

      # scan_ec2_instance_with_findings (Required)
      # 設定内容: 検出結果のある EC2 インスタンスに対するマルウェアスキャンの自動有効化設定ブロックです。
      scan_ec2_instance_with_findings {

        # ebs_volumes (Required)
        # 設定内容: EBS ボリュームのマルウェアスキャンの自動有効化設定ブロックです。
        ebs_volumes {

          # auto_enable (Required)
          # 設定内容: 新規メンバーアカウントに対して EBS ボリュームのマルウェアスキャンを
          #          自動的に有効化するかを指定します。
          # 設定可能な値:
          #   - true : EBS ボリュームスキャンを自動有効化する
          #   - false: EBS ボリュームスキャンを自動有効化しない
          auto_enable = true
        }
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: GuardDuty 検出器の ID（detector_id と同一）
#---------------------------------------------------------------
