# Generated: 2026-01-18
# Provider Version: 6.28.0
# 注意: このテンプレートは生成時点の情報です。最新の仕様は公式ドキュメントを確認してください。

# Amazon Macie Findings Filterリソース
# Macieの検出結果をフィルタリングして自動的にアーカイブまたは処理するルールを作成します。
#
# 参考: https://docs.aws.amazon.com/macie/latest/APIReference/findingsfilters-id.html
# Terraform公式ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_findings_filter

resource "aws_macie2_findings_filter" "example" {
  # action - (Required) フィルタ条件を満たす検出結果に対して実行するアクション。
  # 有効な値:
  # - ARCHIVE: 検出結果を自動的にアーカイブ（非表示）にします
  # - NOOP: 検出結果に対してアクションを実行しません
  action = "ARCHIVE"

  # name - (Optional) フィルタのカスタム名。最低3文字、最大64文字。
  # 省略した場合、Terraformがランダムで一意な名前を割り当てます。name_prefixとは競合します。
  name = "example-findings-filter"

  # name_prefix - (Optional) 指定したプレフィックスで始まる一意な名前を作成します。
  # nameとは競合します。
  # name_prefix = "findings-filter-"

  # description - (Optional) フィルタのカスタム説明。最大512文字。
  description = "Filter to archive findings from specific regions"

  # position - (Optional) Amazon MacieコンソールのフィルタリストにおけるフィルタのCriteria。
  # この値は、他のフィルタとの相対的な、検出結果にフィルタが適用される順序も決定します。
  position = 1

  # region - (Optional) このリソースが管理されるリージョン。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  region = "us-east-1"

  # tags - (Optional) リソースに割り当てるタグのマップ。
  tags = {
    Environment = "production"
    Purpose     = "security-automation"
  }

  # finding_criteria - (Required) 検出結果をフィルタリングするための条件。
  finding_criteria {
    # criterion - (Optional) 結果をフィルタリングするために使用するプロパティ、演算子、および1つ以上の値を指定する条件。
    # 複数のcriterionブロックを指定できます。
    criterion {
      # field - (Required) 評価するフィールドの名前。
      # 例: "region", "severity.description", "type", "resourcesAffected.s3Bucket.name" など
      field = "region"

      # eq - (Optional) プロパティの値が指定された値と一致（等しい）します。
      # 複数の値を指定した場合、MacieはOR論理を使用して値を結合します。
      eq = ["us-east-1", "us-west-2"]

      # eq_exact_match - (Optional) プロパティの値がすべての指定された値と完全に一致します。
      # 複数の値を指定した場合、MacieはAND論理を使用して値を結合します。
      # eq_exact_match = ["exact-value"]

      # neq - (Optional) プロパティの値が指定された値と一致しない（等しくない）。
      # 複数の値を指定した場合、MacieはOR論理を使用して値を結合します。
      # neq = ["unwanted-value"]

      # gt - (Optional) プロパティの値が指定された値より大きい。
      # gt = "100"

      # gte - (Optional) プロパティの値が指定された値以上。
      # gte = "100"

      # lt - (Optional) プロパティの値が指定された値より小さい。
      # lt = "100"

      # lte - (Optional) プロパティの値が指定された値以下。
      # lte = "100"
    }

    # 追加のcriterionブロック例
    criterion {
      field = "severity.description"
      eq    = ["High", "Critical"]
    }
  }

  # timeouts - タイムアウト設定
  timeouts {
    # create - (Optional) リソース作成のタイムアウト。デフォルトは特に記載なし。
    create = "5m"
  }
}
