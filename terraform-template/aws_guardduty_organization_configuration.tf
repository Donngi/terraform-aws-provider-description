################################################################################
# AWS GuardDuty Organization Configuration
# Provider Version: 6.28.0
# Resource: aws_guardduty_organization_configuration
################################################################################
# AWS組織全体のGuardDuty設定を管理します。
# このリソースを使用するには、アカウントが組織の委任管理者として指定されている必要があります。
#
# 重要な注意事項:
# - これは高度なTerraformリソースであり、importなしで自動的に管理を開始します
# - Terraform設定から削除しても、実際のリソースに対するアクションは実行されません
# - GuardDutyは各AWSリージョンで個別に管理されます
#
# 公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration
################################################################################

resource "aws_guardduty_organization_configuration" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # detector_id - GuardDutyディテクターのID (必須)
  # 委任管理者アカウントのGuardDutyディテクターIDを指定します。
  # 通常は aws_guardduty_detector リソースのIDを参照します。
  detector_id = aws_guardduty_detector.example.id

  # auto_enable_organization_members - 組織メンバーの自動有効化設定 (必須)
  # 組織内のメンバーアカウントに対するGuardDutyの自動有効化を制御します。
  #
  # 設定可能な値:
  # - "ALL"  : すべての既存および新規メンバーアカウントでGuardDutyを自動有効化
  # - "NEW"  : 新規メンバーアカウントのみでGuardDutyを自動有効化
  # - "NONE" : 自動有効化を行わない
  #
  # 変更は最大24時間ですべてのメンバーアカウントに適用されます。
  auto_enable_organization_members = "ALL"

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # region - リソースを管理するAWSリージョン (オプション)
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # GuardDutyはリージョナルサービスのため、各リージョンで個別に設定が必要です。
  # region = "us-east-1"

  ################################################################################
  # datasources - データソースの設定 (オプション - 非推奨)
  ################################################################################
  # 注意: このブロックは非推奨です。
  # 2023年3月のAPI変更により、aws_guardduty_organization_configuration_feature
  # リソースの使用が推奨されています。
  #
  # 公式ドキュメント:
  # https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-feature-object-api-changes-march2023.html
  #
  # 組織全体で収集するデータソースを設定します。
  # 新しいメンバーアカウントが組織に参加した際の動作を制御します。

  datasources {
    ################################################################################
    # S3 Logs - S3データイベントログの監視設定
    ################################################################################
    # S3バケットに対するデータイベント（オブジェクトレベルのAPI操作）を監視します。
    # 不審なS3アクティビティや潜在的なデータ漏洩を検出できます。
    s3_logs {
      # auto_enable - S3ログの自動有効化 (オプション)
      # 新しいメンバーアカウントでS3データイベントログを自動的に有効にするかを指定します。
      # デフォルト: false
      auto_enable = true
    }

    ################################################################################
    # Kubernetes - Kubernetes監査ログの監視設定
    ################################################################################
    # Amazon EKSクラスターのKubernetes監査ログを監視します。
    # 不審なKubernetesアクティビティやコンテナセキュリティの脅威を検出します。
    #
    # Kubernetes保護の詳細:
    # https://docs.aws.amazon.com/guardduty/latest/ug/kubernetes-protection.html
    kubernetes {
      # audit_logs - 監査ログの設定 (必須)
      # Kubernetes監査ログの有効化を設定します。
      audit_logs {
        # enable - 監査ログの有効化 (必須)
        # Kubernetes監査ログをデータソースとして有効にするかを指定します。
        # デフォルト: true
        enable = true
      }
    }

    ################################################################################
    # Malware Protection - マルウェア保護の設定
    ################################################################################
    # EC2インスタンスに対するマルウェアスキャン機能を設定します。
    # GuardDutyの検出結果を持つEC2インスタンスのEBSボリュームを自動スキャンします。
    #
    # マルウェア保護の詳細:
    # https://docs.aws.amazon.com/guardduty/latest/ug/malware-protection.html
    malware_protection {
      # scan_ec2_instance_with_findings - 検出結果を持つEC2インスタンスのスキャン設定 (必須)
      # GuardDutyの検出結果があるEC2インスタンスに対するマルウェアスキャンの設定です。
      scan_ec2_instance_with_findings {
        # ebs_volumes - EBSボリュームのスキャン設定 (必須)
        # EC2インスタンスにアタッチされたEBSボリュームのスキャン設定です。
        ebs_volumes {
          # auto_enable - EBSボリュームスキャンの自動有効化 (必須)
          # 組織に参加する新しいメンバーアカウントでEBSボリュームのスキャンを
          # 自動的に有効にするかを指定します。
          # デフォルト: true
          auto_enable = true
        }
      }
    }
  }

  ################################################################################
  # 依存関係の管理
  ################################################################################
  # このリソースは委任管理者アカウントの設定後に作成する必要があります。
  # 必要に応じて depends_on を使用して依存関係を明示的に定義してください。
  #
  # 例:
  # depends_on = [
  #   aws_guardduty_organization_admin_account.example
  # ]
}

################################################################################
# 補足: 関連リソース
################################################################################
# このリソースと組み合わせて使用する主要なリソース:
#
# 1. aws_guardduty_detector
#    - GuardDutyを有効化し、ディテクターIDを取得するために必要
#
# 2. aws_guardduty_organization_admin_account
#    - 委任管理者アカウントを指定するために使用
#    - このリソースを使用する前に設定が必要
#
# 3. aws_guardduty_organization_configuration_feature (推奨)
#    - datasourcesブロックの代わりに、個別の保護機能を管理するために使用
#    - より柔軟で詳細な設定が可能
#
# 4. aws_guardduty_member
#    - 個別のメンバーアカウントを管理する場合に使用
#
# 基本的な使用例:
#
# resource "aws_guardduty_detector" "example" {
#   enable = true
# }
#
# resource "aws_guardduty_organization_admin_account" "example" {
#   admin_account_id = "123456789012"
# }
#
# resource "aws_guardduty_organization_configuration" "example" {
#   auto_enable_organization_members = "ALL"
#   detector_id = aws_guardduty_detector.example.id
#
#   depends_on = [aws_guardduty_organization_admin_account.example]
# }

################################################################################
# ベストプラクティス
################################################################################
# 1. 自動有効化設定の推奨
#    - "ALL"を使用して、すべてのメンバーアカウントで一貫したセキュリティ保護を確保
#    - 新規アカウントのみ保護する場合は"NEW"を使用
#
# 2. リージョン間の一貫性
#    - すべてのAWSリージョンで同じ委任管理者アカウントを使用
#    - 組織の管理アカウントを委任管理者として使用しないことを推奨
#
# 3. データソースの有効化
#    - S3 Logs: S3バケットへの不審なアクセスを検出するために有効化
#    - Kubernetes: EKSクラスターを使用している場合は必須
#    - Malware Protection: EC2インスタンスのセキュリティ強化のために推奨
#
# 4. 新しい機能設定方法への移行
#    - datasourcesブロックは非推奨のため、新規実装では
#      aws_guardduty_organization_configuration_feature を使用
#
# 5. メンバーアカウントの制限
#    - 1つの委任管理者アカウントで最大50,000のメンバーアカウントを管理可能
#
# 6. オプトインリージョンの考慮
#    - オプトインリージョンでは、メンバーアカウントがリージョンをオプトインした後に
#      組織に追加する必要があります
#
# 7. 変更の適用時間
#    - auto_enable設定の変更は最大24時間かかる場合があります
#    - 即座の変更が必要な場合は、個別のメンバーアカウント設定を検討

################################################################################
# トラブルシューティング
################################################################################
# 問題: メンバーアカウントでGuardDutyが有効化されない
# 解決策:
# - 委任管理者アカウントが正しく設定されているか確認
# - aws_guardduty_organization_admin_account リソースが作成済みか確認
# - auto_enable_organization_members が適切な値に設定されているか確認
# - 変更が適用されるまで最大24時間待機
#
# 問題: オプトインリージョンで設定が失敗する
# 解決策:
# - メンバーアカウントが対象リージョンをオプトインしているか確認
# - 委任管理者アカウントがオプトアウトしていないか確認
#
# 問題: datasources設定が反映されない
# 解決策:
# - datasourcesブロックは非推奨のため、
#   aws_guardduty_organization_configuration_feature への移行を検討
# - API経由で設定を確認し、実際の状態を把握
#
# 必要な権限:
# - guardduty:UpdateOrganizationConfiguration
# - guardduty:DescribeOrganizationConfiguration
# - organizations:DescribeOrganization
# - organizations:ListAccounts
# - organizations:DescribeAccount
