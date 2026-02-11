################################################################################
# Terraform AWS Resource Template: aws_codecommit_approval_rule_template
#
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# このファイルは生成時点の情報を基にしています。
# 最新の仕様については公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_approval_rule_template
################################################################################

################################################################################
# AWS CodeCommit Approval Rule Template
#
# CodeCommit リポジトリに適用される承認ルールのテンプレートを作成します。
# このテンプレートをリポジトリに関連付けると、プルリクエストに対して
# 自動的に承認ルールが適用されます。
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/codecommit/latest/userguide/approval-rule-templates.html
# https://docs.aws.amazon.com/codecommit/latest/APIReference/API_CreateApprovalRuleTemplate.html
################################################################################
resource "aws_codecommit_approval_rule_template" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # name - (必須) 承認ルールテンプレートの名前
  # - 最大100文字
  # - テンプレートの目的がわかる説明的な名前を推奨
  # - 例: "Require-2-Approvers-For-Production"
  #
  # 参考: https://docs.aws.amazon.com/codecommit/latest/APIReference/API_CreateApprovalRuleTemplate.html
  name = "MyExampleApprovalRuleTemplate"

  # content - (必須) 承認ルールテンプレートの内容
  # - 最大3000文字
  # - JSON形式で承認ルールの構造を定義
  # - Version: 現在は "2018-11-08" を使用
  # - DestinationReferences: ルールを適用する対象ブランチのリスト
  #   - 例: ["refs/heads/main", "refs/heads/production"]
  #   - ワイルドカード使用可能（例: "refs/heads/prod-*"）
  # - Statements: 承認に関する要件を定義
  #   - Type: "Approvers" を指定
  #   - NumberOfApprovalsNeeded: 必要な承認数
  #   - ApprovalPoolMembers: 承認者のリスト（ARN形式）
  #     - IAM ユーザー: arn:aws:iam::123456789012:user/UserName
  #     - AssumedRole: arn:aws:sts::123456789012:assumed-role/RoleName/*
  #     - ワイルドカード使用可能（例: arn:aws:sts::123456789012:assumed-role/CodeCommitReview/*）
  #
  # 注意:
  # - クロスアカウントの承認はサポートされていません
  # - jsonencode() 関数を使用してTerraformのマップをJSON文字列に変換
  #
  # 参考: https://docs.aws.amazon.com/codecommit/latest/userguide/how-to-create-template.html
  content = jsonencode({
    Version               = "2018-11-08"
    DestinationReferences = ["refs/heads/main"]
    Statements = [{
      Type                    = "Approvers"
      NumberOfApprovalsNeeded = 2
      ApprovalPoolMembers = [
        "arn:aws:sts::123456789012:assumed-role/CodeCommitReview/*"
      ]
    }]
  })

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # description - (オプション) 承認ルールテンプレートの説明
  # - 最大1000文字
  # - テンプレートの目的を説明する詳細な説明を記載
  # - 他のユーザーがこのテンプレートが適切かどうかを判断するのに役立つ
  #
  # 参考: https://docs.aws.amazon.com/codecommit/latest/APIReference/API_CreateApprovalRuleTemplate.html
  description = "This approval rule template requires two approvers from the CodeCommit review team for pull requests to the main branch"

  # id - (オプション) リソースID
  # - Terraform によって自動的に計算される属性
  # - 明示的に指定することも可能（通常は不要）
  # - 指定しない場合は approval_rule_template_id と同じ値が設定される
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_approval_rule_template#id
  # id = "custom-id"

  # region - (オプション) このリソースが管理されるAWSリージョン
  # - 指定しない場合は、プロバイダー設定のリージョンがデフォルトとして使用される
  # - マルチリージョン構成で特定のリソースを異なるリージョンで管理する場合に使用
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  ################################################################################
  # 読み取り専用属性（Computed）
  # 以下の属性はTerraformによって自動的に計算され、参照可能です
  ################################################################################

  # approval_rule_template_id - 承認ルールテンプレートのID
  # 使用例: aws_codecommit_approval_rule_template.example.approval_rule_template_id

  # creation_date - テンプレートが作成された日時（RFC3339形式）
  # 使用例: aws_codecommit_approval_rule_template.example.creation_date

  # last_modified_date - テンプレートが最後に変更された日時（RFC3339形式）
  # 使用例: aws_codecommit_approval_rule_template.example.last_modified_date

  # last_modified_user - テンプレートを最後に変更したユーザーのARN
  # 使用例: aws_codecommit_approval_rule_template.example.last_modified_user

  # rule_content_sha256 - ルールコンテンツのSHA-256ハッシュ値
  # 使用例: aws_codecommit_approval_rule_template.example.rule_content_sha256
}

################################################################################
# 使用例: 複数ブランチに対する承認ルール
################################################################################
# resource "aws_codecommit_approval_rule_template" "multi_branch" {
#   name        = "Multi-Branch-Approval-Rule"
#   description = "Requires approval for production and staging branches"
#
#   content = jsonencode({
#     Version               = "2018-11-08"
#     DestinationReferences = [
#       "refs/heads/production",
#       "refs/heads/staging",
#       "refs/heads/release-*"  # ワイルドカード使用例
#     ]
#     Statements = [{
#       Type                    = "Approvers"
#       NumberOfApprovalsNeeded = 1
#       ApprovalPoolMembers = [
#         "arn:aws:iam::123456789012:user/SeniorDev1",
#         "arn:aws:iam::123456789012:user/SeniorDev2"
#       ]
#     }]
#   })
# }

################################################################################
# 使用例: 異なる承認者タイプの組み合わせ
################################################################################
# resource "aws_codecommit_approval_rule_template" "mixed_approvers" {
#   name        = "Mixed-Approvers-Rule"
#   description = "Approval rule with both IAM users and assumed roles"
#
#   content = jsonencode({
#     Version               = "2018-11-08"
#     DestinationReferences = ["refs/heads/main"]
#     Statements = [{
#       Type                    = "Approvers"
#       NumberOfApprovalsNeeded = 3
#       ApprovalPoolMembers = [
#         # 特定のIAMユーザー
#         "arn:aws:iam::123456789012:user/TechLead",
#         # AssumedRoleのワイルドカード（ロールを引き受けた全ユーザー）
#         "arn:aws:sts::123456789012:assumed-role/ReviewerRole/*",
#         # フェデレーションユーザー
#         "arn:aws:sts::123456789012:federated-user/ExternalReviewer"
#       ]
#     }]
#   })
# }

################################################################################
# テンプレートをリポジトリに関連付ける例
################################################################################
# resource "aws_codecommit_approval_rule_template_association" "example" {
#   approval_rule_template_name = aws_codecommit_approval_rule_template.example.name
#   repository_name             = aws_codecommit_repository.example.repository_name
# }
