#---------------------------------------
# aws_codecommit_approval_rule_template
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-12
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_approval_rule_template
#
# NOTE:
# AWS CodeCommitの承認ルールテンプレートを管理します
# このリソースは、複数のリポジトリに適用可能な承認ルールを定義し、プルリクエストのマージ前に必要な承認者数や条件を統一的に管理します
#
# 主な用途:
# - プルリクエストの承認プロセスの標準化
# - 複数リポジトリへの統一的な承認ルール適用
# - コードレビュー要件の組織的な管理
#
# 制約事項:
# - contentのJSON構造はCodeCommit承認ルール仕様に従う必要があります
# - テンプレート削除時は事前に全リポジトリとの関連付け解除が必要です
# - DestinationReferencesには必ず"refs/heads/"プレフィックスが必要です

#---------------------------------------
# リソース定義
#---------------------------------------

resource "aws_codecommit_approval_rule_template" "example" {

  #---------------------------------------
  # 基本設定
  #---------------------------------------

  # 設定内容: 承認ルールテンプレートの名前
  # 設定可能な値: 任意の文字列（1〜100文字）
  # 省略時: 設定必須
  name = "example-approval-rule-template"

  # 設定内容: 承認ルールの詳細設定（JSON形式）
  # 設定可能な値: CodeCommit承認ルール仕様に準拠したJSON文字列
  # 省略時: 設定必須
  content = jsonencode({
    Version               = "2018-11-08"
    DestinationReferences = ["refs/heads/main"]
    Statements = [
      {
        Type                    = "Approvers"
        NumberOfApprovalsNeeded = 2
        ApprovalPoolMembers     = ["arn:aws:sts::123456789012:assumed-role/CodeCommitReview/*"]
      }
    ]
  })

  #---------------------------------------
  # オプション設定
  #---------------------------------------

  # 設定内容: テンプレートの説明文
  # 設定可能な値: 任意の文字列（最大1000文字）
  # 省略時: 説明なし
  description = "Requires 2 approvals from CodeCommitReview role before merging to main branch"

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（us-east-1、ap-northeast-1等）
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# 以下の属性がリソース作成後に参照可能:
# - id: テンプレート名（nameと同じ値）
# - approval_rule_template_id: テンプレートのシステムID
# - creation_date: テンプレート作成日時（ISO8601形式）
# - last_modified_date: テンプレート最終更新日時（ISO8601形式）
# - last_modified_user: テンプレートを最後に更新したユーザーのARN
# - rule_content_sha256: 承認ルール内容のSHA256ハッシュ値
# - region: テンプレートが管理されているリージョン

#---------------------------------------
# 補足事項
#---------------------------------------
# JSON構造の詳細:
# - Version: 承認ルールのバージョン（現在は"2018-11-08"のみサポート）
# - DestinationReferences: 対象ブランチ（"refs/heads/"プレフィックス必須）
# - Statements.Type: "Approvers"（承認者要件を定義）
# - NumberOfApprovalsNeeded: 必要な承認者数（1以上の整数）
# - ApprovalPoolMembers: 承認可能なIAMユーザー/ロール/グループのARN配列
#
# 使用上の注意:
# - テンプレートは aws_codecommit_approval_rule_template_association で関連付け
# - 関連付けられたリポジトリでは自動的に承認ルールが適用される
# - 既存の承認ルールとの競合に注意
