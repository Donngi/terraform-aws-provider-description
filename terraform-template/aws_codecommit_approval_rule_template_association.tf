# ============================================================================
# AWS CodeCommit Approval Rule Template Association
# ============================================================================
# リソースタイプ: aws_codecommit_approval_rule_template_association
# Provider Version: 6.28.0
# 最終更新日: 2026-02-04
#
# 説明:
# CodeCommit承認ルールテンプレートをリポジトリに関連付けるリソースです。
# テンプレートがリポジトリに関連付けられると、そのリポジトリで作成される
# プルリクエストに対して、テンプレートの条件に一致する承認ルールが
# 自動的に作成されます。
#
# 主な用途:
# - プルリクエストの承認プロセスの標準化
# - 複数のリポジトリに統一された承認ルールを適用
# - ブランチ保護とコードレビューポリシーの実装
#
# 重要な注意事項:
# - 承認ルールテンプレートと同じAWSリージョンのリポジトリのみ関連付け可能
# - テンプレートを関連付けると、対象となるプルリクエストに自動的に適用される
# - 宛先参照が指定されていない場合、すべてのプルリクエストに適用される
#
# 参考ドキュメント:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_approval_rule_template_association
# - https://docs.aws.amazon.com/codecommit/latest/userguide/how-to-associate-template.html
# - https://docs.aws.amazon.com/codecommit/latest/APIReference/API_AssociateApprovalRuleTemplateWithRepository.html
# ============================================================================

resource "aws_codecommit_approval_rule_template_association" "example" {
  # --------------------------------------------------------------------------
  # 必須パラメータ
  # --------------------------------------------------------------------------

  # approval_rule_template_name - 承認ルールテンプレート名
  # 説明: 関連付ける承認ルールテンプレートの名前を指定します
  # 型: string
  # 必須: Yes
  #
  # 詳細:
  # - 既存の承認ルールテンプレートの名前を指定する必要があります
  # - テンプレート名は、aws_codecommit_approval_rule_templateリソースで定義
  # - テンプレートとリポジトリは同じAWSリージョンに存在する必要があります
  #
  # 使用例:
  # - "require-2-approvals-for-main"
  # - "security-team-review-template"
  # - "production-deployment-approval"
  approval_rule_template_name = aws_codecommit_approval_rule_template.example.name

  # repository_name - リポジトリ名
  # 説明: テンプレートを関連付けるリポジトリの名前を指定します
  # 型: string
  # 必須: Yes
  #
  # 詳細:
  # - CodeCommitリポジトリの名前を指定します
  # - aws_codecommit_repositoryリソースで作成したリポジトリを参照可能
  # - リポジトリ名は1〜100文字で、英数字、ハイフン、アンダースコアのみ使用可能
  # - 関連付け後、このリポジトリのプルリクエストに承認ルールが自動適用されます
  #
  # 使用例:
  # - "my-app-repository"
  # - "backend-service-repo"
  # - "infrastructure-as-code"
  repository_name = aws_codecommit_repository.example.repository_name

  # --------------------------------------------------------------------------
  # オプションパラメータ
  # --------------------------------------------------------------------------

  # region - リージョン
  # 説明: このリソースが管理されるAWSリージョンを指定します
  # 型: string
  # 必須: No
  # デフォルト: プロバイダー設定のリージョン
  #
  # 詳細:
  # - 明示的にリージョンを指定しない場合、プロバイダーの設定が使用されます
  # - 承認ルールテンプレートとリポジトリは同じリージョンに存在する必要があります
  # - マルチリージョン構成の場合、リソースごとにリージョンを明示することを推奨
  #
  # 使用例:
  # region = "us-east-1"
  # region = "ap-northeast-1"
  # region = "eu-west-1"
}

# ============================================================================
# 出力値の説明
# ============================================================================
#
# このリソースは以下の属性を出力します:
#
# - id
#   説明: 承認ルールテンプレート名とリポジトリ名をカンマで結合した文字列
#   型: string
#   形式: "approval_rule_template_name,repository_name"
#   用途: リソースの一意識別子として使用
#   例: "require-2-approvals,my-repository"
#
# ============================================================================
# 関連リソース
# ============================================================================
#
# このリソースは通常、以下のリソースと組み合わせて使用されます:
#
# 1. aws_codecommit_approval_rule_template
#    - 承認ルールテンプレートの定義
#    - 承認者の数、承認者プール、宛先参照などを設定
#
# 2. aws_codecommit_repository
#    - CodeCommitリポジトリの作成
#    - テンプレートを関連付ける対象リポジトリ
#
# 3. aws_iam_user / aws_iam_role
#    - 承認者として指定するIAMユーザーまたはロール
#
# ============================================================================
# インポート
# ============================================================================
#
# 既存のCodeCommit承認ルールテンプレート関連付けは、
# 承認ルールテンプレート名とリポジトリ名をカンマで区切った形式で
# インポートできます:
#
# terraform import aws_codecommit_approval_rule_template_association.example approval_rule_template_name,repository_name
#
# 例:
# terraform import aws_codecommit_approval_rule_template_association.example require-2-approvals,my-repository
#
# ============================================================================
# ベストプラクティス
# ============================================================================
#
# 1. テンプレートの命名規則
#    - テンプレート名は用途を明確に示す命名を使用
#    - 例: "require-2-approvals-for-production"
#
# 2. ブランチ保護
#    - 重要なブランチ(main, production等)には必ず承認ルールを適用
#    - テンプレートで宛先参照を指定して特定ブランチのみに適用可能
#
# 3. 承認者の設定
#    - 承認者プールには複数のユーザー/ロールを含めることを推奨
#    - チーム全体のバックアップ体制を確保
#
# 4. 複数リポジトリへの適用
#    - 同じ承認ポリシーを複数のリポジトリに適用する場合、
#      同じテンプレートを複数の関連付けリソースで参照
#
# 5. リージョン管理
#    - マルチリージョン構成の場合、各リージョンで個別にテンプレートを作成
#    - リソース定義で明示的にリージョンを指定することを推奨
#
# 6. 変更管理
#    - テンプレートの内容を変更すると、既存のプルリクエストには影響しない
#    - 新しく作成されるプルリクエストから新しいルールが適用される
#
# ============================================================================
# トラブルシューティング
# ============================================================================
#
# 1. ApprovalRuleTemplateDoesNotExistException
#    - 指定した承認ルールテンプレートが存在しない
#    - テンプレート名のスペルミスを確認
#    - テンプレートが同じリージョンに存在することを確認
#
# 2. RepositoryDoesNotExistException
#    - 指定したリポジトリが存在しない
#    - リポジトリ名のスペルミスを確認
#    - リポジトリが削除されていないか確認
#
# 3. MaximumRepositoryAssociationsExceededException
#    - 1つのテンプレートに関連付けられるリポジトリ数の上限に達した
#    - 新しいテンプレートを作成するか、不要な関連付けを削除
#
# 4. 承認ルールが適用されない
#    - テンプレートの宛先参照設定を確認
#    - プルリクエストのターゲットブランチが条件に一致しているか確認
#    - 関連付けが正しく作成されているかAWSコンソールで確認
#
# ============================================================================
# 使用例: 基本的な設定
# ============================================================================
#
# resource "aws_codecommit_approval_rule_template" "require_two_approvals" {
#   name        = "require-2-approvals"
#   description = "Require 2 approvals for pull requests"
#
#   content = jsonencode({
#     Version               = "2018-11-08"
#     DestinationReferences = ["refs/heads/main"]
#     Statements = [{
#       Type                    = "Approvers"
#       NumberOfApprovalsNeeded = 2
#       ApprovalPoolMembers     = [
#         "arn:aws:sts::123456789012:assumed-role/CodeCommitReview/*"
#       ]
#     }]
#   })
# }
#
# resource "aws_codecommit_repository" "app_repo" {
#   repository_name = "my-application"
#   description     = "Application repository"
# }
#
# resource "aws_codecommit_approval_rule_template_association" "app_repo_association" {
#   approval_rule_template_name = aws_codecommit_approval_rule_template.require_two_approvals.name
#   repository_name             = aws_codecommit_repository.app_repo.repository_name
# }
#
# ============================================================================
# 使用例: 複数リポジトリへの適用
# ============================================================================
#
# locals {
#   repository_names = ["backend-service", "frontend-app", "infrastructure"]
# }
#
# resource "aws_codecommit_repository" "repos" {
#   for_each = toset(local.repository_names)
#
#   repository_name = each.value
#   description     = "Repository for ${each.value}"
# }
#
# resource "aws_codecommit_approval_rule_template_association" "associations" {
#   for_each = aws_codecommit_repository.repos
#
#   approval_rule_template_name = aws_codecommit_approval_rule_template.require_two_approvals.name
#   repository_name             = each.value.repository_name
# }
#
# ============================================================================
