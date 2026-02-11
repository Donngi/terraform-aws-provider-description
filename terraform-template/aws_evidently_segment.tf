################################################################################
# AWS CloudWatch Evidently Segment
################################################################################
# テンプレート生成日: 2026-01-23
# AWS Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点の情報に基づいています。
#       最新の仕様や詳細は以下の公式ドキュメントを参照してください。
#
# [重要] このリソースは非推奨（Deprecated）です。
# AWS AppConfig Feature Flags の使用が推奨されています。
# 詳細: https://aws.amazon.com/blogs/mt/using-aws-appconfig-feature-flags/
#
# Terraform AWS Provider:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/evidently_segment
#
# AWS公式ドキュメント:
#   https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Evidently.html
#   https://docs.aws.amazon.com/cloudwatchevidently/latest/APIReference/API_CreateSegment.html
################################################################################

resource "aws_evidently_segment" "example" {
  # ========================================
  # 必須パラメータ
  # ========================================

  # セグメント名
  # - セグメントを識別する一意の名前
  # - 変更すると新しいリソースが作成されます（Forces new resource）
  name = "example-segment"

  # セグメントパターン
  # - セグメントに含めるユーザーを特定するためのルールパターン（JSON形式）
  # - 変更すると新しいリソースが作成されます（Forces new resource）
  # - パターン構文の詳細は以下を参照:
  #   https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Evidently-segments.html
  #
  # パターン例:
  # - 価格範囲フィルタ: {"Price":[{"numeric":[">",10,"<=",20]}]}
  # - ユーザー属性マッチング: {"userType":[{"string":"premium"}]}
  # - 複数条件の組み合わせも可能
  pattern = jsonencode({
    Price = [{
      numeric = [">", 10, "<=", 20]
    }]
  })

  # ========================================
  # オプションパラメータ
  # ========================================

  # セグメントの説明
  # - セグメントの目的や用途を説明するテキスト
  # - 変更すると新しいリソースが作成されます（Forces new resource）
  description = "Example segment for users with specific price range"

  # リージョン指定
  # - このリソースを管理するAWSリージョン
  # - 指定しない場合、プロバイダーの設定リージョンがデフォルトで使用されます
  # - 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # タグ
  # - リソースに付与するタグのマップ
  # - プロバイダーの default_tags 設定がある場合、一致するキーは上書きされます
  # - 詳細: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-segment"
    Environment = "production"
    Purpose     = "A/B testing"
  }

  # tags_all パラメータについて:
  # - このパラメータはTerraformによって自動的に管理されます
  # - プロバイダーレベルのdefault_tagsと個別のtagsをマージした結果が格納されます
  # - 通常、明示的に設定する必要はありません
}

################################################################################
# 補足情報
################################################################################

# Computed Attributes（参照のみ可能な属性）:
# - arn                 : セグメントのARN
# - id                  : セグメントのID（ARNと同じ値）
# - created_time        : セグメントが作成された日時
# - last_updated_time   : セグメントが最後に更新された日時
# - experiment_count    : このセグメントが使用されている実験の数（実行中のものを含む全て）
# - launch_count        : このセグメントが使用されているローンチの数（実行中のものを含む全て）

# パターンの記述方法:
# - JSON形式で記述する必要があります
# - Heredocやjsonencode()関数を使用すると可読性が向上します
# - 数値比較、文字列マッチング、複数条件の組み合わせが可能です

# 使用例（Heredocを使用した複数行パターン）:
# pattern = <<JSON
# {
#   "Price": [
#     {
#       "numeric": [">", 10, "<=", 20]
#     }
#   ]
# }
# JSON

# リソースの参照例:
# - ARNを参照: aws_evidently_segment.example.arn
# - IDを参照: aws_evidently_segment.example.id
# - 実験数を参照: aws_evidently_segment.example.experiment_count

# IAM権限:
# このリソースを作成・管理するには以下のIAM権限が必要です:
# - evidently:CreateSegment
# - evidently:DeleteSegment
# - evidently:GetSegment
# - evidently:UpdateSegment
# - evidently:TagResource
# - evidently:UntagResource
# 詳細: https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazoncloudwatchevidently.html
