#---------------------------------------------------------------
# AWS Security Hub アカウント
#---------------------------------------------------------------
#
# AWS Security Hubをこのアカウントで有効化します。
# Security Hubは、AWSアカウントとリソースに対してセキュリティチェックを実行し、
# セキュリティベストプラクティスへの準拠状況を評価するサービスです。
#
# 重要: このリソースを削除すると、このアカウントでSecurity Hubが無効化されます。
#
# AWS公式ドキュメント:
#   - Security Hub ユーザーガイド: https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html
#   - Security Hub の有効化: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-enable.html
#   - コントロールの設定: https://docs.aws.amazon.com/securityhub/latest/userguide/controls-configure.html
#   - 統合コントロール検出結果: https://docs.aws.amazon.com/securityhub/latest/userguide/controls-findings-create-update.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_account
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_account" "example" {
  #---------------------------------------------------------------
  # デフォルトスタンダードの有効化
  #---------------------------------------------------------------
  # Security Hubが自動的に有効化するように指定したセキュリティスタンダードを
  # 有効にするかどうかを設定します。
  #
  # デフォルトで有効化されるスタンダード:
  #   - AWS Foundational Security Best Practices v1.0.0
  #   - CIS AWS Foundations Benchmark v1.2.0
  #
  # デフォルト値: true
  #
  # 使用例:
  #   - true: デフォルトスタンダードを自動的に有効化 (推奨)
  #   - false: スタンダードを手動で有効化する場合
  #
  # 注意:
  #   - スタンダードを有効化すると、関連するコントロールが自動的に有効になり、
  #     セキュリティチェックが実行されます
  #   - コントロールの検出結果を生成するには、AWS Configが有効で
  #     必要なリソースタイプの記録が有効化されている必要があります
  #
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/enable-standards.html
  #
  enable_default_standards = true

  #---------------------------------------------------------------
  # コントロール検出結果ジェネレーター
  #---------------------------------------------------------------
  # アカウントで統合コントロール検出結果を有効にするかどうかを設定します。
  #
  # 設定可能な値:
  #   - "SECURITY_CONTROL": 統合コントロール検出結果を有効化
  #     複数のスタンダードに適用されるコントロールのチェックに対して
  #     単一の検出結果を生成します。検出結果のノイズを削減できます。
  #
  #   - "STANDARD_CONTROL": 統合コントロール検出結果を無効化
  #     コントロールが複数のスタンダードに適用される場合、
  #     各スタンダードごとに個別の検出結果を生成します。
  #
  # デフォルト値: "SECURITY_CONTROL" (2023年2月23日以降にSecurity Hubを有効化した場合)
  #
  # 使用例:
  #   - "SECURITY_CONTROL": 検出結果を統合して管理 (推奨)
  #   - "STANDARD_CONTROL": スタンダードごとに個別の検出結果が必要な場合
  #
  # 注意:
  #   - Organizations環境の場合、管理アカウントでこの設定を変更すると、
  #     すべてのメンバーアカウントに適用されます
  #   - 設定を変更すると、新しい検出結果が生成され、既存の検出結果は
  #     アーカイブされるまで最大24時間かかる場合があります
  #
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/controls-findings-create-update.html#consolidated-control-findings
  #
  control_finding_generator = "SECURITY_CONTROL"

  #---------------------------------------------------------------
  # 新しいコントロールの自動有効化
  #---------------------------------------------------------------
  # 有効化されたスタンダードに新しいコントロールが追加された際に、
  # 自動的に有効化するかどうかを設定します。
  #
  # デフォルト値: true
  #
  # 使用例:
  #   - true: 新しいコントロールを自動的に有効化 (推奨)
  #     Security Hubが新しいコントロールをリリースした際に、
  #     自動的にセキュリティチェックが開始されます
  #
  #   - false: 新しいコントロールを手動で有効化
  #     新しいコントロールを慎重に評価してから有効化したい場合
  #
  # 注意:
  #   - 自動有効化された新しいコントロールは、処理中は一時的に
  #     "Disabled" ステータスとなり、数日以内に "Enabled" に変更されます
  #   - 処理中に手動でコントロールを有効化/無効化した場合、
  #     その設定が維持されます
  #   - この設定は、既に有効化されているスタンダードにのみ適用されます
  #
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/controls-auto-enable.html
  #
  auto_enable_controls = true

  #---------------------------------------------------------------
  # リージョン指定
  #---------------------------------------------------------------
  # このリソースが管理されるリージョンを指定します。
  #
  # デフォルト値: プロバイダー設定で指定されたリージョン
  #
  # 使用例:
  #   - "us-east-1": 特定のリージョンでSecurity Hubを有効化
  #   - 省略: プロバイダーのデフォルトリージョンを使用
  #
  # 注意:
  #   - Security Hubはリージョナルサービスです
  #   - マルチリージョン環境では、各リージョンで個別にSecurity Hubを有効化する必要があります
  #   - クロスリージョン集約機能を使用すると、複数リージョンの検出結果を
  #     単一のリージョンに集約できます
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # region = "us-east-1"

  #---------------------------------------------------------------
  # ID (Computed)
  #---------------------------------------------------------------
  # AWS アカウント ID。
  # このフィールドは自動的に設定されます (読み取り専用)。
  #
  # id = (computed)
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です:
#
# - id
#   説明: AWS アカウント ID
#   型: string
#   例: "123456789012"
#
# - arn
#   説明: アカウント内に作成された Security Hub ハブの ARN
#   型: string
#   例: "arn:aws:securityhub:us-east-1:123456789012:hub/default"
#   用途: IAMポリシーやリソースベースのポリシーで使用
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: 基本的な設定（デフォルト値を使用）
# resource "aws_securityhub_account" "basic" {}

# 例2: デフォルトスタンダードを無効化し、手動で管理
# resource "aws_securityhub_account" "manual_standards" {
#   enable_default_standards = false
# }

# 例3: 統合コントロール検出結果を無効化（スタンダードごとに個別の検出結果）
# resource "aws_securityhub_account" "standard_based_findings" {
#   control_finding_generator = "STANDARD_CONTROL"
# }

# 例4: 新しいコントロールの自動有効化を無効化
# resource "aws_securityhub_account" "manual_controls" {
#   auto_enable_controls = false
# }

# 例5: 特定のリージョンでSecurity Hubを有効化
# resource "aws_securityhub_account" "specific_region" {
#   region                   = "ap-northeast-1"
#   enable_default_standards = true
#   control_finding_generator = "SECURITY_CONTROL"
#   auto_enable_controls     = true
# }

# 例6: 完全にカスタマイズした設定
# resource "aws_securityhub_account" "custom" {
#   enable_default_standards  = false
#   control_finding_generator = "STANDARD_CONTROL"
#   auto_enable_controls      = false
# }

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
# Security Hubを完全に設定するには、以下のリソースも併せて使用してください:
#
# - aws_securityhub_standards_subscription
#   用途: 特定のセキュリティスタンダードを有効化
#   例: CIS AWS Foundations Benchmark, PCI DSS等
#
# - aws_securityhub_standards_control
#   用途: 個別のセキュリティコントロールの有効化/無効化
#
# - aws_securityhub_product_subscription
#   用途: サードパーティ製品との統合を有効化
#   例: GuardDuty, Inspector, Macie等
#
# - aws_securityhub_insight
#   用途: カスタムインサイトの作成
#
# - aws_securityhub_action_target
#   用途: カスタムアクションの作成
#
# - aws_securityhub_member
#   用途: メンバーアカウントの招待と管理
#
# - aws_securityhub_organization_admin_account
#   用途: Organizations統合での管理アカウントの設定
#
# - aws_securityhub_organization_configuration
#   用途: Organizations統合での組織全体の設定
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 前提条件
#---------------------------------------------------------------
# Security Hubを効果的に使用するには、以下の前提条件を満たす必要があります:
#
# 1. AWS Config の有効化
#    - ほとんどのセキュリティコントロールは AWS Config に依存しています
#    - 必要なリソースタイプの記録を有効化してください
#    参考: https://docs.aws.amazon.com/securityhub/latest/userguide/controls-config-resources.html
#
# 2. 適切な IAM 権限
#    - Security Hubを有効化するための権限
#    - AWS Configへのアクセス権限
#    - 統合サービス（GuardDuty、Inspector等）へのアクセス権限
#
# 3. サービスリンクロール
#    - Security Hubは自動的にサービスリンクロールを作成します
#    - arn:aws:iam::aws:policy/aws-service-role/SecurityHubServiceRolePolicy
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# ベストプラクティス
#---------------------------------------------------------------
# 1. デフォルトスタンダードの有効化
#    - enable_default_standards = true を推奨
#    - AWS Foundational Security Best Practices は広範な保護を提供
#
# 2. 統合コントロール検出結果の使用
#    - control_finding_generator = "SECURITY_CONTROL" を推奨
#    - 検出結果のノイズを削減し、管理を簡素化
#
# 3. 新しいコントロールの自動有効化
#    - auto_enable_controls = true を推奨
#    - 最新のセキュリティチェックを自動的に適用
#
# 4. マルチリージョン/マルチアカウント環境
#    - 各リージョンで個別にSecurity Hubを有効化
#    - Organizations統合を使用して一元管理
#    - クロスリージョン集約で検出結果を統合
#
# 5. AWS Configの設定
#    - Security Hubを有効化する前にAWS Configを設定
#    - 必要なリソースタイプの記録を有効化
#
# 6. コスト管理
#    - Security Hubは有効化されたコントロールの数に基づいて課金
#    - 不要なコントロールは無効化してコストを最適化
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# トラブルシューティング
#---------------------------------------------------------------
# 1. コントロールの検出結果が生成されない
#    - AWS Configが有効で、必要なリソースタイプが記録されているか確認
#    - コントロールが有効化されているか確認
#    - セキュリティスコアの生成には最大30分かかる場合があります
#
# 2. 統合コントロール検出結果の設定変更
#    - 設定変更後、新しい検出結果の生成とアーカイブに最大24時間かかります
#    - 変更中は統合された検出結果とスタンダード別の検出結果が混在する可能性
#
# 3. Organizations環境でのメンバーアカウント
#    - 管理アカウントの設定がメンバーアカウントに継承されます
#    - 中央設定を使用している場合、一部の設定はポリシーで管理されます
#
#---------------------------------------------------------------
