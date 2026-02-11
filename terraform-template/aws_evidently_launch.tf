#---------------------------------------------------------------
# Amazon CloudWatch Evidently Launch
#---------------------------------------------------------------
#
# CloudWatch Evidently Launchリソースを管理します。
# Launchは機能のバリエーションを段階的にロールアウトし、
# トラフィックの割合を時間経過とともに調整できる機能です。
#
# 【重要】このリソースは非推奨（deprecated）です。
# 新規実装ではAWS AppConfig Feature Flagsの使用を推奨します。
#
# AWS公式ドキュメント:
#   - CloudWatch Evidently (非推奨): https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Evidently.html
#   - AWS AppConfig Feature Flags: https://aws.amazon.com/blogs/mt/using-aws-appconfig-feature-flags/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/evidently_launch
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_evidently_launch" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # Launch名（必須）
  # - 最小長: 1文字
  # - 最大長: 127文字
  # - 用途: Launchを識別するための一意な名前
  name = "example-launch"

  # プロジェクト名またはARN（必須）
  # - 形式: プロジェクト名 または ARN
  # - 用途: このLaunchを含むEvidentlyプロジェクトを指定
  # - 例: "my-project" または "arn:aws:evidently:us-east-1:123456789012:project/my-project"
  project = "my-evidently-project"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # Launch説明（オプション）
  # - 用途: Launchの目的や内容を説明するテキスト
  # - ベストプラクティス: 明確な説明を記載することで管理性が向上
  description = "Example launch for feature rollout"

  # ランダム化ソルト（オプション）
  # - 用途: ユーザーセッションにバリエーションを割り当てる際の
  #         ランダム化IDの生成に使用される文字列
  # - 省略時: Launch名がランダム化ソルトとして使用される
  # - 用途例: 複数のLaunchで一貫したユーザー体験を提供する場合に
  #           同じソルト値を使用
  randomization_salt = "custom-randomization-salt"

  # リージョン（オプション）
  # - 用途: このリソースが管理されるAWSリージョンを指定
  # - 省略時: プロバイダー設定のリージョンが使用される
  # - 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # タグ（オプション）
  # - 用途: リソースの分類、コスト配分、アクセス制御などに使用
  # - 注意: provider default_tagsと重複するキーは上書きされる
  tags = {
    Environment = "production"
    Team        = "platform"
    Purpose     = "feature-rollout"
  }

  # リソースID（オプション、通常は指定不要）
  # - 用途: リソースの一意識別子
  # - 形式: "launch_name:project_name_or_arn"
  # - 注意: 通常はTerraformが自動生成するため、明示的な指定は不要
  # - 省略推奨: このパラメータは特殊なユースケース以外では使用しない
  # id = "example-launch:my-evidently-project"

  # 全タグ（オプション、通常は指定不要）
  # - 用途: リソースに割り当てられる全タグ（provider default_tagsを含む）
  # - 注意: 通常はTerraformとプロバイダーが自動管理するため、明示的な指定は不要
  # - 省略推奨: tagsパラメータを使用し、default_tagsはプロバイダーレベルで設定
  # tags_all = {
  #   Environment = "production"
  #   Team        = "platform"
  # }

  #---------------------------------------------------------------
  # グループ設定（必須ブロック）
  #---------------------------------------------------------------
  # - 最小: 1ブロック
  # - 最大: 5ブロック
  # - 用途: Launchで使用する機能とバリエーションを定義
  #---------------------------------------------------------------

  groups {
    # 機能名（必須）
    # - 用途: Launchで使用するEvidently機能の名前を指定
    feature = "example-feature"

    # グループ名（必須）
    # - 用途: Launchグループを識別する名前
    name = "Variation1"

    # バリエーション（必須）
    # - 用途: このLaunchグループで使用する機能バリエーションを指定
    # - 注意: 指定する機能に定義されているバリエーション名と一致する必要がある
    variation = "Variation1"

    # グループ説明（オプション）
    # - 用途: このLaunchグループの目的や特性を説明
    description = "First variation group"
  }

  # 複数グループの例（最大5グループまで）
  groups {
    feature     = "example-feature"
    name        = "Variation2"
    variation   = "Variation2"
    description = "Second variation group"
  }

  #---------------------------------------------------------------
  # メトリクスモニター設定（オプションブロック）
  #---------------------------------------------------------------
  # - 最大: 3ブロック
  # - 用途: Launchのパフォーマンスを監視するメトリクスを定義
  #---------------------------------------------------------------

  metric_monitors {
    metric_definition {
      # エンティティIDキー（必須）
      # - 用途: メトリクス値を記録する原因となるアクションを行う
      #         エンティティ（ユーザーやセッションなど）を指定
      # - 例: "userDetails.userID", "sessionId"
      entity_id_key = "userDetails.userID"

      # メトリクス名（必須）
      # - 用途: メトリクスを識別する名前
      name = "click-through-rate"

      # 値キー（必須）
      # - 用途: メトリクス値を生成するために追跡される値を指定
      # - 例: イベントデータ内のフィールド名
      value_key = "clickCount"

      # イベントパターン（オプション）
      # - 形式: EventBridge event pattern（JSON文字列）
      # - 用途: メトリクスの記録方法を定義するイベントパターン
      # - 例: 特定の条件（価格範囲など）を満たすイベントのみを対象
      event_pattern = jsonencode({
        Price = [{
          numeric = [">", 10, "<=", 100]
        }]
      })

      # 単位ラベル（オプション）
      # - 用途: メトリクスの測定単位を示すラベル
      # - 例: "clicks", "milliseconds", "errors"
      unit_label = "clicks"
    }
  }

  #---------------------------------------------------------------
  # スケジュール済み分割設定（オプションブロック）
  #---------------------------------------------------------------
  # - 最大: 1ブロック
  # - 用途: Launch中の各ステップでの機能バリエーション間の
  #         トラフィック配分割合を定義
  #---------------------------------------------------------------

  scheduled_splits_config {
    #---------------------------------------------------------------
    # ステップ設定（必須ブロック）
    #---------------------------------------------------------------
    # - 最小: 1ブロック
    # - 最大: 6ブロック
    # - 用途: 各ステップでのトラフィック配分と開始時刻を定義
    #---------------------------------------------------------------

    steps {
      # グループウェイト（必須）
      # - 形式: map[string]number
      # - 用途: 機能バリエーション間のトラフィック配分割合（パーセント）
      # - キー: バリエーション名（groupsブロックのnameと一致）
      # - 値: トラフィック割合（0-100）
      # - 注意: 全バリエーションの合計が100を超えることも可能
      #         （超過分は均等配分される）
      group_weights = {
        "Variation1" = 10
        "Variation2" = 20
      }

      # 開始時刻（必須）
      # - 形式: RFC3339形式のタイムスタンプ
      # - 用途: このステップの開始日時を指定
      # - 例: "2024-01-07T01:43:59Z" または "2024-01-07 01:43:59+00:00"
      start_time = "2024-01-07T10:00:00Z"

      #---------------------------------------------------------------
      # セグメントオーバーライド設定（オプションブロック）
      #---------------------------------------------------------------
      # - 最大: 6ブロック
      # - 用途: 特定のオーディエンスセグメントに対して
      #         異なるトラフィック分割を指定
      #---------------------------------------------------------------

      segment_overrides {
        # 評価順序（必須）
        # - 用途: 複数のセグメントオーバーライドがある場合の評価順序
        # - 値: 小さい数値が先に評価される
        evaluation_order = 1

        # セグメント名またはARN（必須）
        # - 用途: 使用するEvidentlyセグメントを指定
        # - 形式: セグメント名 または ARN
        segment = "premium-users"

        # ウェイト（必須）
        # - 形式: map[string]number
        # - 用途: このセグメントへのトラフィック配分
        # - 値: 1/1000パーセント単位で指定（50000 = 50%）
        # - 注意: segment_overridesではthousandths of percentで指定
        weights = {
          "Variation1" = 30000  # 30%
          "Variation2" = 70000  # 70%
        }
      }

      segment_overrides {
        evaluation_order = 2
        segment          = "beta-testers"
        weights = {
          "Variation2" = 100000  # 100%
        }
      }
    }

    # 複数ステップの例（段階的なロールアウト）
    steps {
      group_weights = {
        "Variation1" = 25
        "Variation2" = 50
      }
      start_time = "2024-01-08T10:00:00Z"
    }

    steps {
      group_weights = {
        "Variation1" = 50
        "Variation2" = 50
      }
      start_time = "2024-01-09T10:00:00Z"
    }
  }

  #---------------------------------------------------------------
  # タイムアウト設定（オプションブロック）
  #---------------------------------------------------------------

  timeouts {
    # 作成タイムアウト（オプション）
    # - デフォルト: 2分
    # - 用途: リソース作成操作のタイムアウト時間を指定
    create = "2m"

    # 更新タイムアウト（オプション）
    # - デフォルト: 2分
    # - 用途: リソース更新操作のタイムアウト時間を指定
    update = "2m"

    # 削除タイムアウト（オプション）
    # - デフォルト: 2分
    # - 用途: リソース削除操作のタイムアウト時間を指定
    delete = "2m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (Computed - 参照のみ)
#---------------------------------------------------------------
#
# 以下の属性はTerraformによって自動的に設定され、
# 参照のみ可能です（設定不可）。
#
# - arn
#     Launch ARN
#     例: "arn:aws:evidently:us-east-1:123456789012:project/my-project/launch/example-launch"
#
# - created_time
#     Launchが作成された日時（RFC3339形式）
#     例: "2024-01-07T01:43:59Z"
#
# - execution
#     Launchの開始および終了時刻を含むブロック
#     - started_time: Launchが開始された日時
#     - ended_time: Launchが終了した日時
#
# - id
#     リソースID（形式: "launch_name:project_name_or_arn"）
#     例: "example-launch:my-evidently-project"
#
# - last_updated_time
#     Launchが最後に更新された日時（RFC3339形式）
#     例: "2024-01-08T10:30:00Z"
#
# - status
#     Launchの現在の状態
#     有効値: "CREATED", "UPDATING", "RUNNING", "COMPLETED", "CANCELLED"
#
# - status_reason
#     Launchが停止された場合の理由
#     停止した人が入力した説明文字列
#
# - tags_all
#     リソースに割り当てられた全タグ（provider default_tagsを含む）
#
# - type
#     Launchのタイプ
#
#---------------------------------------------------------------
# 使用例の参照
#---------------------------------------------------------------
#
# output "launch_arn" {
#   description = "The ARN of the Evidently launch"
#   value       = aws_evidently_launch.example.arn
# }
#
# output "launch_status" {
#   description = "Current status of the launch"
#   value       = aws_evidently_launch.example.status
# }
#
# output "launch_execution" {
#   description = "Launch execution details"
#   value       = aws_evidently_launch.example.execution
# }
#
#---------------------------------------------------------------
