#---------------------------------------------------------------
# AWS Security Hub Standards Control
#---------------------------------------------------------------
#
# AWS Security Hubのセキュリティ基準（スタンダード）内の
# 個別コントロールを有効化/無効化するリソースです。
#
# このリソースの動作について:
#   - 通常のリソースとは異なり、Terraformはこのリソースを「作成」するのではなく、
#     既存のコントロールを「管理下に置く」（adopt）形で動作します
#   - リソース設定を削除すると、Terraformは管理から外すだけで、
#     コントロールの状態はそのまま残ります
#
# 前提条件:
#   - Security Hubが有効化されている必要があります（aws_securityhub_account）
#   - 対象のセキュリティ基準がサブスクライブされている必要があります
#     （aws_securityhub_standards_subscription）
#
# AWS公式ドキュメント:
#   - Security Hubコントロールの設定: https://docs.aws.amazon.com/securityhub/latest/userguide/controls-configure.html
#   - コントロールのリファレンス: https://docs.aws.amazon.com/securityhub/latest/userguide/controls-reference.html
#   - コントロールARNの取得方法: https://docs.aws.amazon.com/cli/latest/reference/securityhub/get-enabled-standards.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_control
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_standards_control" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # standards_control_arn (Required)
  # 設定内容: 管理対象とするセキュリティコントロールのARNを指定します。
  # 設定可能な値: Security Hubコントロールの有効なARN
  # ARN形式: arn:aws:securityhub:<region>:<account-id>:control/<standard>/<control-id>
  #
  # 例:
  #   - CIS AWS Foundations Benchmark v1.2.0のコントロール1.10:
  #     "arn:aws:securityhub:us-east-1:111111111111:control/cis-aws-foundations-benchmark/v/1.2.0/1.10"
  #   - AWS Foundational Security Best Practicesのコントロール:
  #     "arn:aws:securityhub:us-east-1:111111111111:control/aws-foundational-security-best-practices/v/1.0.0/IAM.1"
  #
  # ARNの取得方法:
  #   1. AWS CLIでget-enabled-standardsを実行し、有効な基準のARNを取得
  #      aws securityhub get-enabled-standards
  #
  #   2. describe-standards-controlsで個別コントロールのARNを取得
  #      aws securityhub describe-standards-controls \
  #        --standards-subscription-arn "arn:aws:securityhub:us-east-1:111111111111:subscription/cis-aws-foundations-benchmark/v/1.2.0"
  #
  # 参考: https://docs.aws.amazon.com/cli/latest/reference/securityhub/describe-standards-controls.html
  standards_control_arn = "arn:aws:securityhub:us-east-1:111111111111:control/cis-aws-foundations-benchmark/v/1.2.0/1.10"

  # control_status (Required)
  # 設定内容: コントロールの有効化/無効化ステータスを指定します。
  # 設定可能な値:
  #   - "ENABLED": コントロールを有効化
  #     セキュリティチェックが実行され、検出結果が生成されます
  #
  #   - "DISABLED": コントロールを無効化
  #     セキュリティチェックは実行されず、新しい検出結果は生成されません
  #     disabled_reason属性の指定が必要です
  #
  # 注意:
  #   - "DISABLED"を指定する場合、disabled_reasonを必ず指定してください
  #   - disabled_reasonを指定すると、control_statusは自動的に"DISABLED"に設定されます
  #   - 既存の検出結果はアーカイブされませんが、新しい検出結果は生成されません
  #
  # 使用例:
  #   - "ENABLED": デフォルトの推奨設定
  #   - "DISABLED": 環境に適用できないコントロールや、他の手段で管理している場合
  control_status = "DISABLED"

  # disabled_reason (Optional)
  # 設定内容: コントロールを無効化する理由を説明する文字列を指定します。
  # 設定可能な値: 512文字以内の任意の文字列
  # 省略時: control_statusが"DISABLED"の場合は必須
  #
  # 注意:
  #   - この属性を指定すると、control_statusは自動的に"DISABLED"に設定されます
  #   - 無効化の理由を明確にドキュメント化することで、
  #     セキュリティポリシーの透明性を向上させます
  #   - コンプライアンス監査時に無効化の正当性を示すために重要です
  #
  # 使用例:
  #   - "We handle password policies within Okta"
  #   - "Not applicable to our serverless architecture"
  #   - "Covered by enterprise IAM solution"
  #   - "Alternative control implemented via custom solution"
  #
  # ベストプラクティス:
  #   - 具体的で理解しやすい理由を記載する
  #   - 代替手段を実装している場合はその詳細を含める
  #   - 定期的にレビューし、無効化が依然として適切か確認する
  disabled_reason = "We handle password policies within Okta"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  #
  # 注意:
  #   - Security Hubはリージョナルサービスです
  #   - standards_control_arnのリージョンと一致させる必要があります
  #   - マルチリージョン環境では、各リージョンでコントロールを個別に管理します
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #-------------------------------------------------------------
  # 依存関係
  #-------------------------------------------------------------
  # このリソースは以下のリソースに依存します:
  #   1. aws_securityhub_account: Security Hubの有効化
  #   2. aws_securityhub_standards_subscription: セキュリティ基準のサブスクリプション
  #
  # depends_onを使用して、これらのリソースが作成された後に
  # このリソースが作成されるようにしてください。
  depends_on = [
    # aws_securityhub_account.example,
    # aws_securityhub_standards_subscription.example,
  ]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id
#   説明: セキュリティ基準コントロールのARN
#   型: string
#   例: "arn:aws:securityhub:us-east-1:111111111111:control/cis-aws-foundations-benchmark/v/1.2.0/1.10"
#   用途: Terraformの参照やデータソースでの利用
#
# - control_id
#   説明: セキュリティ基準コントロールの識別子
#   型: string
#   例: "1.10"（CIS AWS Foundations Benchmarkの場合）
#   用途: コントロールの識別、レポート生成
#
# - control_status_updated_at
#   説明: セキュリティ基準コントロールのステータスが最後に更新された日時
#   型: string (RFC3339形式)
#   例: "2024-01-15T10:30:00Z"
#   用途: 変更履歴の追跡、監査ログ
#
# - description
#   説明: コントロールの詳細説明。コントロールが何をチェックしているかを示します。
#   型: string
#   例: "Ensure IAM password policy prevents password reuse"
#   用途: コントロールの理解、ドキュメント化
#
# - related_requirements
#   説明: このコントロールに関連する要件のリスト
#   型: list of string
#   例: ["PCI DSS 8.2.5", "CIS AWS Foundations Benchmark 1.10"]
#   用途: コンプライアンスマッピング、要件追跡
#
# - remediation_url
#   説明: Security Hubユーザードキュメント内のコントロール修復情報へのリンク
#   型: string
#   例: "https://docs.aws.amazon.com/console/securityhub/standards-cis-1.10/remediation"
#   用途: 問題解決のための参照、チーム間での情報共有
#
# - severity_rating
#   説明: このセキュリティ基準コントロールから生成される検出結果の重要度
#   型: string
#   設定可能な値: "CRITICAL", "HIGH", "MEDIUM", "LOW", "INFORMATIONAL"
#   例: "HIGH"
#   用途: 優先順位付け、アラート設定、リスク評価
#
# - title
#   説明: セキュリティ基準コントロールのタイトル
#   型: string
#   例: "Ensure IAM password policy prevents password reuse"
#   用途: レポート、ダッシュボード表示
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: CIS AWS Foundations Benchmarkのコントロールを無効化
# resource "aws_securityhub_account" "example" {}
#
# resource "aws_securityhub_standards_subscription" "cis_aws_foundations_benchmark" {
#   standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
#   depends_on    = [aws_securityhub_account.example]
# }
#
# resource "aws_securityhub_standards_control" "ensure_iam_password_policy_prevents_password_reuse" {
#   standards_control_arn = "arn:aws:securityhub:us-east-1:111111111111:control/cis-aws-foundations-benchmark/v/1.2.0/1.10"
#   control_status        = "DISABLED"
#   disabled_reason       = "We handle password policies within Okta"
#
#   depends_on = [aws_securityhub_standards_subscription.cis_aws_foundations_benchmark]
# }

# 例2: AWS Foundational Security Best Practicesのコントロールを有効化
# resource "aws_securityhub_standards_control" "iam_root_access_key" {
#   standards_control_arn = "arn:aws:securityhub:us-east-1:111111111111:control/aws-foundational-security-best-practices/v/1.0.0/IAM.4"
#   control_status        = "ENABLED"
#
#   depends_on = [aws_securityhub_standards_subscription.fsbp]
# }

# 例3: 複数のコントロールを一括管理
# locals {
#   disabled_controls = {
#     "1.10" = "Password policies managed by Okta"
#     "1.14" = "Hardware MFA not required for this environment"
#     "2.6"  = "S3 bucket logging managed by centralized logging solution"
#   }
# }
#
# resource "aws_securityhub_standards_control" "cis_disabled" {
#   for_each = local.disabled_controls
#
#   standards_control_arn = "arn:aws:securityhub:us-east-1:111111111111:control/cis-aws-foundations-benchmark/v/1.2.0/${each.key}"
#   control_status        = "DISABLED"
#   disabled_reason       = each.value
#
#   depends_on = [aws_securityhub_standards_subscription.cis_aws_foundations_benchmark]
# }

# 例4: 特定のリージョンでコントロールを管理
# resource "aws_securityhub_standards_control" "tokyo_region" {
#   region                = "ap-northeast-1"
#   standards_control_arn = "arn:aws:securityhub:ap-northeast-1:111111111111:control/cis-aws-foundations-benchmark/v/1.2.0/1.10"
#   control_status        = "DISABLED"
#   disabled_reason       = "Regional exemption for development environment"
#
#   depends_on = [aws_securityhub_standards_subscription.cis_tokyo]
# }

# 例5: データソースと組み合わせた動的な管理
# data "aws_caller_identity" "current" {}
# data "aws_region" "current" {}
#
# resource "aws_securityhub_standards_control" "dynamic" {
#   standards_control_arn = "arn:aws:securityhub:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.10"
#   control_status        = "DISABLED"
#   disabled_reason       = "Managed by central security team"
# }

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
# Security Hubのコントロール管理を完全に設定するには、
# 以下のリソースも併せて使用してください:
#
# - aws_securityhub_account
#   用途: Security Hubの有効化
#   必須: はい
#
# - aws_securityhub_standards_subscription
#   用途: セキュリティ基準のサブスクリプション
#   必須: はい（コントロールが属する基準）
#
# - aws_securityhub_insight
#   用途: カスタムインサイトの作成
#   関連: コントロール検出結果のフィルタリングと可視化
#
# - aws_securityhub_action_target
#   用途: カスタムアクションの作成
#   関連: コントロール検出結果に対するアクション定義
#
# - aws_securityhub_finding_aggregator
#   用途: クロスリージョン検出結果の集約
#   関連: マルチリージョンでのコントロール検出結果の統合
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# ベストプラクティス
#---------------------------------------------------------------
# 1. コントロールの無効化
#    - 無効化する理由を必ず文書化（disabled_reason）
#    - 定期的にレビューし、無効化が依然として適切か確認
#    - 代替手段を実装している場合は、その詳細を記載
#
# 2. 依存関係の管理
#    - depends_onを使用してリソース作成順序を明示
#    - Security Hub有効化 → 基準サブスクリプション → コントロール設定の順序
#
# 3. コントロールARNの管理
#    - データソース（aws_caller_identity、aws_region）を活用した動的ARN生成
#    - ハードコードされたアカウントIDやリージョンの回避
#
# 4. マルチリージョン環境
#    - 各リージョンで個別にコントロールを管理
#    - リージョンごとの要件の違いを考慮
#    - 一元的な設定管理にはTerraform workspaceやmoduleを活用
#
# 5. コンプライアンス管理
#    - related_requirements属性を活用した要件マッピング
#    - コントロールの変更履歴を記録（Gitコミット履歴）
#    - 定期的なコンプライアンスレビューの実施
#
# 6. コスト最適化
#    - 不要なコントロールは無効化してコストを削減
#    - ただし、セキュリティ要件との適切なバランスを保つ
#    - 無効化の決定はセキュリティチームとの協議に基づく
#
# 7. 自動化とコード管理
#    - for_eachやcountを使用した複数コントロールの一括管理
#    - ローカル変数で無効化リストを定義し、管理を集中化
#    - 環境ごとの差分をvariablesで管理
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# トラブルシューティング
#---------------------------------------------------------------
# 1. コントロールが見つからない
#    - Security Hubが有効化されているか確認
#    - セキュリティ基準がサブスクライブされているか確認
#    - 正しいリージョンとアカウントIDがARNに含まれているか確認
#
# 2. コントロールの変更が反映されない
#    - depends_onで正しい依存関係が設定されているか確認
#    - リソース作成の完了を待ってから変更を適用
#    - コントロールステータスの更新には数分かかる場合があります
#
# 3. 無効化できないコントロール
#    - 一部のコントロールは組織レベルのポリシーで管理されている可能性
#    - Organizations管理アカウントの設定を確認
#    - セキュリティポリシーで無効化が禁止されていないか確認
#
# 4. ARNの形式エラー
#    - ARNの形式が正しいか確認
#      arn:aws:securityhub:<region>:<account-id>:control/<standard>/<control-id>
#    - リージョンコードが有効か確認
#    - アカウントIDが12桁の数字か確認
#
# 5. 依存関係エラー
#    - aws_securityhub_accountが作成されているか確認
#    - aws_securityhub_standards_subscriptionが作成されているか確認
#    - depends_onブロックで明示的に依存関係を定義
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# セキュリティに関する注意事項
#---------------------------------------------------------------
# 1. コントロールの無効化は慎重に
#    - セキュリティリスクを十分に評価してから無効化
#    - 無効化する場合は代替手段を実装
#    - セキュリティチームの承認を得る
#
# 2. 最小権限の原則
#    - コントロール管理に必要な最小限の権限のみを付与
#    - IAMポリシーで適切なアクセス制御を実装
#
# 3. 変更の監査
#    - コントロールの変更はすべて記録
#    - CloudTrailでAPI呼び出しを監視
#    - 定期的なセキュリティレビューを実施
#
# 4. コンプライアンス要件の確認
#    - 業界標準やコンプライアンス要件を確認
#    - 無効化が規制要件に違反しないか確認
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# コントロールARNの取得方法（AWS CLI）
#---------------------------------------------------------------
# # 1. 有効な基準のリストを取得
# aws securityhub get-enabled-standards
#
# # 2. 特定の基準のコントロール一覧を取得
# aws securityhub describe-standards-controls \
#   --standards-subscription-arn "arn:aws:securityhub:us-east-1:111111111111:subscription/cis-aws-foundations-benchmark/v/1.2.0"
#
# # 3. 特定のコントロールの詳細を取得
# aws securityhub describe-standards-controls \
#   --standards-subscription-arn "arn:aws:securityhub:us-east-1:111111111111:subscription/cis-aws-foundations-benchmark/v/1.2.0" \
#   --query 'Controls[?ControlId==`1.10`]'
#
# # 4. 無効化されているコントロールのリストを取得
# aws securityhub describe-standards-controls \
#   --standards-subscription-arn "arn:aws:securityhub:us-east-1:111111111111:subscription/cis-aws-foundations-benchmark/v/1.2.0" \
#   --query 'Controls[?ControlStatus==`DISABLED`].[ControlId,DisabledReason]' \
#   --output table
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 主要なセキュリティ基準とコントロール例
#---------------------------------------------------------------
# 1. CIS AWS Foundations Benchmark v1.2.0
#    ARN: arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0
#    主要コントロール:
#      - 1.10: IAMパスワードポリシーの再利用防止
#      - 1.14: ハードウェアMFAの有効化
#      - 2.1: CloudTrailの有効化
#      - 2.6: S3バケットのアクセスログ
#      - 4.1: セキュリティグループの制限されていないアクセス
#
# 2. AWS Foundational Security Best Practices v1.0.0
#    ARN: arn:aws:securityhub:::ruleset/aws-foundational-security-best-practices/v/1.0.0
#    主要コントロール:
#      - IAM.1: IAMポリシーでルートユーザーを使用しない
#      - IAM.4: IAMルートユーザーアクセスキーが存在しない
#      - EC2.1: EBS暗号化が有効
#      - S3.1: S3バケットのパブリックアクセスブロック
#      - RDS.1: RDS暗号化が有効
#
# 3. PCI DSS v3.2.1
#    ARN: arn:aws:securityhub:::ruleset/pci-dss/v/3.2.1
#    主要コントロール:
#      - PCI.CloudTrail.1: CloudTrail暗号化が有効
#      - PCI.EC2.1: EBSスナップショットがパブリックでない
#      - PCI.S3.1: S3バケットがパブリックでない
#
#---------------------------------------------------------------
