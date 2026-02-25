#-------------------------------------------------------------------------------------------
# AWS ECR Lifecycle Policy (aws_ecr_lifecycle_policy)
#-------------------------------------------------------------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-16
#
# ECRリポジトリのライフサイクルポリシーを管理するリソース。
# イメージの自動削除やアーカイブのルールを定義できます。
#
# 主な機能:
# - 古いイメージの自動削除（タグ付き/タグなしイメージ）
# - イメージのアーカイブストレージへの移行
# - イメージカウント・プッシュ日時・プル日時によるライフサイクル制御
#
# NOTE: 1つのECRリポジトリに対して1つのライフサイクルポリシーのみ設定可能。
#       複数のルールは policy JSON内で定義する必要がある。
#       rulePriorityの昇順でルールを定義しないと、リソースが再作成される可能性がある。
#
# 料金への影響:
# - ライフサイクルポリシー自体に追加料金なし
# - アーカイブストレージは標準ストレージより低コスト
#
# Terraformドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ecr_lifecycle_policy
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html
#-------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------
# 基本設定
#------------------------------------------------------------------------------------

resource "aws_ecr_lifecycle_policy" "example" {
  # 必須パラメータ

  # リポジトリ名
  # 設定内容: ライフサイクルポリシーを適用するECRリポジトリの名前
  # 設定可能な値: 既存のECRリポジトリ名
  # 注意事項: リポジトリ名を変更すると新しいポリシーが作成される
  repository = "example-repository"

  # ライフサイクルポリシードキュメント
  # 設定内容: イメージのライフサイクルルールを定義するJSON形式のポリシー
  # 設定可能な値: ECRライフサイクルポリシーの仕様に準拠したJSONドキュメント
  # 注意事項:
  #   - rulesは必須で、配列形式で複数ルールを定義可能
  #   - rulePriorityは昇順で定義すること（再作成を防ぐため）
  #   - aws_ecr_lifecycle_policy_documentデータソースの使用を推奨
  # ポリシーの主要要素:
  #   - rules[].rulePriority: ルールの優先順位（小さい値ほど高優先度）
  #   - rules[].description: ルールの説明
  #   - rules[].selection.tagStatus: "tagged", "untagged", "any"
  #   - rules[].selection.countType: "imageCountMoreThan", "sinceImagePushed", "sinceImagePulled", "sinceImageTransitioned"
  #   - rules[].selection.countNumber: カウント数値
  #   - rules[].selection.countUnit: "days" (countTypeがsince系の場合)
  #   - rules[].action.type: "expire" (削除) または "transition" (アーカイブ移行)
  # AWS公式ドキュメント: https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html#lifecycle_policy_parameters
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "タグなしイメージを14日後に削除"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 14
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

  #------------------------------------------------------------------------------------
  # リージョン設定（オプション）
  #------------------------------------------------------------------------------------

  # リソース管理リージョン
  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 用途: 特定のリージョンでのみリソースを管理したい場合に指定
  region = "ap-northeast-1"
}

#-------------------------------------------------------------------------------------------
# 出力値（Attributes Reference）
#-------------------------------------------------------------------------------------------
# このリソースから参照可能な属性
#
# - repository  : リポジトリ名
# - registry_id : リポジトリが作成されたレジストリID（AWSアカウントID）
# - id          : リソースの一意識別子（repositoryと同じ）
# - region      : リソースが管理されているリージョン
#-------------------------------------------------------------------------------------------
