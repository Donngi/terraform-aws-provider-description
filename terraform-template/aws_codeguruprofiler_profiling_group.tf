# =============================================================================
# Terraform AWS Resource Template: aws_codeguruprofiler_profiling_group
# =============================================================================
# 生成日: 2026-01-19
# Provider Version: 6.28.0
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-19)の情報に基づいています
# - 最新の仕様については公式ドキュメントを必ず確認してください
# - AWS Provider公式ドキュメント:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeguruprofiler_profiling_group
# =============================================================================

# AWS CodeGuru Profiler Profiling Group
# プロファイリンググループは、1つ以上のアプリケーションをプロファイルし、
# グループ全体に基づいてデータを集約します。
# 公式ドキュメント: https://docs.aws.amazon.com/codeguru/latest/profiler-ug/working-with-profiling-groups.html
resource "aws_codeguruprofiler_profiling_group" "example" {
  # =========================================================================
  # 必須パラメータ
  # =========================================================================

  # プロファイリンググループの名前
  # - 1〜255文字の長さ
  # - パターン: [\w-]+
  # 公式ドキュメント: https://docs.aws.amazon.com/codeguru/latest/profiler-api/API_CreateProfilingGroup.html
  name = "example-profiling-group"

  # =========================================================================
  # オプションパラメータ
  # =========================================================================

  # コンピュートプラットフォーム
  # - アプリケーションが実行されるプラットフォームを指定
  # - 有効な値:
  #   - "Default": デフォルトプラットフォーム（EC2、オンプレミスなど）
  #   - "AWSLambda": AWS Lambda関数
  # - 省略した場合、"Default"が使用されます
  # 公式ドキュメント: https://docs.aws.amazon.com/codeguru/latest/profiler-api/API_ProfilingGroupDescription.html
  compute_platform = "Default"

  # リソースが管理されるリージョン
  # - 省略した場合、プロバイダー設定のリージョンが使用されます
  # - マルチリージョン構成で特定のリージョンにリソースを作成する場合に使用
  # 公式ドキュメント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null # 例: "us-east-1"

  # リソースに割り当てるタグ
  # - キーと値のマップ形式
  # - プロバイダーのdefault_tagsと統合されます
  # 公式ドキュメント: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # =========================================================================
  # ネストブロック
  # =========================================================================

  # エージェントオーケストレーション設定
  # - プロファイリングエージェントがプロファイリングデータを収集するかどうかを制御
  # - このブロックは必須です
  # 公式ドキュメント: https://docs.aws.amazon.com/codeguru/latest/profiler-api/API_AgentOrchestrationConfig.html
  agent_orchestration_config {
    # プロファイリングの有効化フラグ
    # - true: プロファイリングエージェントがデータを収集
    # - false: プロファイリングを無効化
    # - このパラメータは必須です
    profiling_enabled = true
  }

  # =========================================================================
  # 補足情報
  # =========================================================================
  #
  # CodeGuru Profilerについて:
  # - 本番環境で実行中のアプリケーションの動作を継続的に分析
  # - 最小限のオーバーヘッドでパフォーマンスの問題を特定
  # - CPU使用率の削減とコンピューティングコストの削減を支援
  # - インタラクティブなフレームグラフで最もリソースを消費するコードパスを可視化
  # - ヒープ使用量分析でメモリリークの可能性を特定
  #
  # プロファイリンググループの設定後:
  # 1. IAMロール/ユーザーにAmazonCodeGuruProfilerAgentAccessポリシーを追加
  # 2. アプリケーションでCodeGuru Profilerエージェントを起動
  # 3. JVMアプリケーションの場合、ヒープサマリーデータ収集が利用可能
  #
  # 参考リンク:
  # - プロファイリンググループの設定:
  #   https://docs.aws.amazon.com/codeguru/latest/profiler-ug/setting-up-long.html
  # - CodeGuru Profiler機能:
  #   https://aws.amazon.com/codeguru/profiler/features/
  # =========================================================================
}

# =========================================================================
# 出力例
# =========================================================================
# 以下の属性は自動的に計算され、出力として参照できます:
#
# - arn: プロファイリンググループのARN
#   例: aws_codeguruprofiler_profiling_group.example.arn
#
# - id: プロファイリンググループの名前（nameと同じ）
#   例: aws_codeguruprofiler_profiling_group.example.id
#
# - tags_all: プロバイダーのdefault_tagsとマージされたすべてのタグ
#   例: aws_codeguruprofiler_profiling_group.example.tags_all
# =========================================================================
