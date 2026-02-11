#---------------------------------------------------------------
# CloudWatch Evidently Feature
#---------------------------------------------------------------
#
# CloudWatch Evidently Featureリソースをプロビジョニングします。
#
# 【重要】このリソースは非推奨（deprecated）です。
# AWS AppConfig Feature Flagsの使用が推奨されています。
# CloudWatch Evidentlyサービスは2025年10月17日にサポート終了予定です。
#
# CloudWatch Evidently Featureは、A/Bテストや段階的リリースのための
# フィーチャーフラグ機能を提供します。異なるバリエーション（variation）を
# 定義し、ユーザーやエンティティごとに異なる値を配信することができます。
#
# AWS公式ドキュメント:
#   - CloudWatch Evidently: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Evidently.html
#   - サポート終了のお知らせ: https://aws.amazon.com/blogs/mt/support-for-amazon-cloudwatch-evidently-ending-soon/
#   - 移行先 AWS AppConfig: https://docs.aws.amazon.com/appconfig/latest/userguide/what-is-appconfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/evidently_feature
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_evidently_feature" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # フィーチャーの名前
  # - 最小長: 1文字
  # - 最大長: 127文字
  # - フィーチャーの識別に使用される一意の名前
  name = "example-feature"

  # プロジェクトの名前またはARN
  # - このフィーチャーを含むEvidentlyプロジェクトを指定
  # - プロジェクト名またはARNのいずれかを指定可能
  project = "example-project"

  #---------------------------------------------------------------
  # バリエーション設定（必須ブロック）
  #---------------------------------------------------------------

  # フィーチャーの異なるバリエーションを定義
  # - 最小: 1個
  # - 最大: 5個のバリエーションを定義可能
  # - 各バリエーションは異なる設定値や動作を表現
  variations {
    # バリエーションの名前
    # - 最小長: 1文字
    # - 最大長: 127文字
    name = "Variation1"

    # バリエーションの値を定義
    # - 必須ブロック（1個のみ指定可能）
    # - 以下のいずれか1つの値タイプを指定
    value {
      # 文字列型の値
      # - 最小長: 0文字
      # - 最大長: 512文字
      # - string_value, bool_value, long_value, double_valueのいずれか1つを指定
      string_value = "example-value"

      # ブール型の値（オプション）
      # - string型として表現される点に注意
      # - string_valueと排他的に使用
      # bool_value = "true"

      # 長整数型の値（オプション）
      # - 最小値: -9007199254740991
      # - 最大値: 9007199254740991
      # - string_valueと排他的に使用
      # long_value = "12345"

      # 浮動小数点型の値（オプション）
      # - string型として表現される点に注意
      # - string_valueと排他的に使用
      # double_value = "3.14159"
    }
  }

  # 複数のバリエーション例（コメントアウト）
  # variations {
  #   name = "Variation2"
  #   value {
  #     string_value = "alternative-value"
  #   }
  # }

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # デフォルトバリエーション
  # - ユーザーが実験やローンチに割り当てられていない場合に配信されるバリエーション
  # - variationsブロックで定義されたバリエーション名を指定
  # - 省略時は最初に定義されたバリエーションがデフォルトになる
  default_variation = "Variation1"

  # フィーチャーの説明
  # - フィーチャーの目的や用途を記述
  description = "Example feature for A/B testing"

  # エンティティオーバーライド
  # - 特定のユーザーやエンティティに常に特定のバリエーションを配信
  # - キー: ユーザーID、アカウントID、その他の識別子
  # - 値: 配信するバリエーション名
  # - A/Bテスト中に特定ユーザーを固定の動作にする場合などに使用
  entity_overrides = {
    "user-123" = "Variation1"
    "user-456" = "Variation2"
  }

  # 評価戦略
  # - ALL_RULES: 実行中のローンチや実験で指定されたトラフィック割り当てを有効化
  # - DEFAULT_VARIATION: すべてのユーザーにデフォルトバリエーションを配信
  # - 実験の開始/停止を制御する際に使用
  evaluation_strategy = "ALL_RULES"

  # リソースID（通常は指定不要）
  # - Terraformが自動的に管理
  # - インポート時など特殊なケースでのみ使用
  # id = "example-project:example-feature"

  # リージョン指定
  # - このリソースを管理するAWSリージョン
  # - 省略時はプロバイダー設定のリージョンを使用
  # - クロスリージョン管理が必要な場合に指定
  # region = "us-east-1"

  # タグ
  # - リソースに付与するタグ
  # - コスト管理、リソース整理、アクセス制御などに使用
  tags = {
    Name        = "example-feature"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all（通常は指定不要）
  # - プロバイダーのdefault_tagsと統合されたタグ
  # - Terraformが自動的に管理するため、通常は明示的に指定しない
  # tags_all = {
  #   Name = "example-feature"
  # }

  #---------------------------------------------------------------
  # タイムアウト設定（オプション）
  #---------------------------------------------------------------

  timeouts {
    # 作成時のタイムアウト
    # - デフォルト値が使用されるため通常は指定不要
    # - 特別に長い作成時間が必要な場合に指定
    # create = "2m"

    # 更新時のタイムアウト
    # - デフォルト値が使用されるため通常は指定不要
    # update = "2m"

    # 削除時のタイムアウト
    # - デフォルト値が使用されるため通常は指定不要
    # delete = "2m"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用の属性）
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能ですが、設定はできません。
#
# - arn
#   - フィーチャーのARN（Amazon Resource Name）
#   - 例: arn:aws:evidently:us-east-1:123456789012:project/example-project/feature/example-feature
#
# - created_time
#   - フィーチャーが作成された日時
#   - RFC3339形式のタイムスタンプ
#
# - evaluation_rules
#   - このフィーチャーの評価ルール
#   - 実験やローンチに関連する自動生成ルール
#   - 各ルールには以下の属性が含まれる:
#     - name: 実験またはローンチの名前
#     - type: "aws.evidently.splits"（ローンチの場合）または
#             "aws.evidently.onlineab"（実験の場合）
#
# - id
#   - フィーチャーの一意識別子
#   - フォーマット: {project_name}:{feature_name}
#   - 例: example-project:example-feature
#
# - last_updated_time
#   - フィーチャーが最後に更新された日時
#   - RFC3339形式のタイムスタンプ
#
# - status
#   - フィーチャーの現在の状態
#   - 有効な値: AVAILABLE（利用可能）、UPDATING（更新中）
#
# - value_type
#   - フィーチャーバリエーションの値タイプ
#   - 有効な値: STRING, LONG, DOUBLE, BOOLEAN
#   - variationsブロックで指定した値タイプに基づき自動決定
#
#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# # ARNを参照
# output "feature_arn" {
#   value = aws_evidently_feature.example.arn
# }
#
# # バリエーションタイプを参照
# output "value_type" {
#   value = aws_evidently_feature.example.value_type
# }
#
# # 評価ルールを参照
# output "evaluation_rules" {
#   value = aws_evidently_feature.example.evaluation_rules
# }
#
#---------------------------------------------------------------
