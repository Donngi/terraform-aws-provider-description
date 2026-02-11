################################################################################
# AWS SageMaker Endpoint
################################################################################
# SageMaker AI エンドポイントリソース
# 機械学習モデルをホスティングし、リアルタイム推論を実行するためのエンドポイントを作成します
#
# 主な用途:
# - リアルタイム推論エンドポイントのデプロイ
# - Blue/Green デプロイメント戦略の実装
# - ローリングアップデート戦略の実装
# - 自動ロールバック設定による障害時の復旧
#
# 関連リソース:
# - aws_sagemaker_endpoint_configuration: エンドポイントの設定を定義
# - aws_sagemaker_model: デプロイする機械学習モデル
# - aws_cloudwatch_alarm: デプロイメント監視用アラーム
#
# 参考リンク:
# - Terraform Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_endpoint
# - AWS API Reference: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateEndpoint.html
# - Deployment Guardrails: https://docs.aws.amazon.com/sagemaker/latest/dg/deployment-guardrails.html

resource "aws_sagemaker_endpoint" "example" {
  ################################################################################
  # 基本設定
  ################################################################################

  # エンドポイント名
  # - 省略時: Terraform がランダムな一意の名前を自動生成
  # - 形式: 最大63文字の英数字とハイフン
  # - 用途: エンドポイントの識別子として使用
  name = "my-sagemaker-endpoint"

  # エンドポイント設定名 (必須)
  # - aws_sagemaker_endpoint_configuration リソースで定義された設定を参照
  # - 設定にはデプロイするモデル、インスタンスタイプ、台数などが含まれる
  # - 変更時: エンドポイントが更新される
  endpoint_config_name = aws_sagemaker_endpoint_configuration.example.name

  # リージョン設定
  # - 省略時: プロバイダー設定のリージョンを使用
  # - 用途: エンドポイントを管理するリージョンを明示的に指定
  # region = "us-west-2"

  ################################################################################
  # デプロイメント設定 (オプション)
  ################################################################################
  # エンドポイントのデプロイメント戦略とロールバック設定を定義
  # - Blue/Green または Rolling Update のいずれか1つのみ指定可能
  # - 未指定時: Blue/Green デプロイメント (ALL_AT_ONCE) がデフォルト

  deployment_config {
    ############################################################################
    # Blue/Green デプロイメントポリシー
    ############################################################################
    # 新しいフリート (Green) を作成しながら、古いフリート (Blue) を維持する戦略
    # - トラフィックは指定された設定に従って新しいフリートに移行
    # - ローリングアップデートとは同時使用不可
    #
    # トラフィックシフトモード:
    # - ALL_AT_ONCE: 全トラフィックを一度に移行 (最短時間、100%影響)
    # - CANARY: 2段階で移行 (初回はカナリア、次回は残り全て)
    # - LINEAR: 複数段階で均等に移行 (リスク最小、時間とコスト増)

    blue_green_update_policy {
      # トラフィックルーティング設定 (必須)
      traffic_routing_configuration {
        # トラフィックシフト戦略のタイプ (必須)
        # - ALL_AT_ONCE: 1ステップで全トラフィックを新フリートに移行
        # - CANARY: 2ステップで移行 (カナリアサイズ + 残り)
        # - LINEAR: n ステップで段階的に移行 (線形ステップサイズ)
        type = "ALL_AT_ONCE"

        # ステップ間の待機時間 (秒) (必須)
        # - 範囲: 0-3600
        # - 用途: 各トラフィック増分後の評価期間 (ベーキング期間)
        # - ALL_AT_ONCE では実質的に影響なし
        wait_interval_in_seconds = 600

        # カナリアサイズ設定 (type="CANARY" の場合のみ)
        # 最初のステップで新フリートに移行するトラフィック量を定義
        # canary_size {
        #   # 容量タイプ (必須)
        #   # - INSTANCE_COUNT: インスタンス数で指定
        #   # - CAPACITY_PERCENT: 総容量のパーセンテージで指定
        #   type = "CAPACITY_PERCENT"
        #
        #   # 容量値 (必須)
        #   # - CAPACITY_PERCENT: 1-50% の範囲
        #   # - INSTANCE_COUNT: バリアントの総インスタンス数以下
        #   value = 10
        # }

        # 線形ステップサイズ設定 (type="LINEAR" の場合のみ)
        # 各ステップで新フリートに移行するトラフィック量を定義
        # linear_step_size {
        #   # 容量タイプ (必須)
        #   type = "CAPACITY_PERCENT"
        #
        #   # 容量値 (必須)
        #   # - CAPACITY_PERCENT: 10-50% の範囲
        #   # - INSTANCE_COUNT: バリアントの総インスタンス数の10-50%
        #   value = 25
        # }
      }

      # デプロイメント完了から古いフリート終了までの追加待機時間 (秒)
      # - 範囲: 0-3600
      # - デフォルト: 0
      # - 用途: トラフィック移行完了後の安定性確認期間
      termination_wait_in_seconds = 0

      # デプロイメントの最大実行タイムアウト (秒)
      # - 範囲: 600-14400
      # - 条件: termination_wait_in_seconds + wait_interval_in_seconds より大きい値
      # - 超過時: タイムアウトエラー
      # maximum_execution_timeout_in_seconds = 3600
    }

    ############################################################################
    # ローリングアップデートポリシー (Blue/Green と排他)
    ############################################################################
    # 段階的にエンドポイントを更新する戦略
    # - 新フリートに容量をプロビジョニングし、トラフィックをオンにする
    # - 同時に古いフリートの容量を終了する
    # - Blue/Green デプロイメントとは同時使用不可

    # rolling_update_policy {
    #   # 各ローリングステップの最大バッチサイズ (必須)
    #   maximum_batch_size {
    #     # 容量タイプ (必須)
    #     type = "CAPACITY_PERCENT"
    #
    #     # 容量値 (必須)
    #     # - 範囲: バリアントの総インスタンス数の5-50%
    #     value = 25
    #   }
    #
    #   # 各バッチのベーキング期間 (秒) (必須)
    #   # - 範囲: 0-3600
    #   # - 用途: SageMaker AI が新フリートの各バッチのアラームを監視する期間
    #   wait_interval_in_seconds = 600
    #
    #   # ロールバック時の最大バッチサイズ (オプション)
    #   # - 未指定時: デフォルトで総容量の100% (一度に全容量をロールバック)
    #   rollback_maximum_batch_size {
    #     type  = "CAPACITY_PERCENT"
    #     value = 50
    #   }
    #
    #   # デプロイメントの最大実行タイムアウト (秒)
    #   # - 範囲: 600-14400
    #   # maximum_execution_timeout_in_seconds = 3600
    # }

    ############################################################################
    # 自動ロールバック設定 (オプション)
    ############################################################################
    # デプロイメント障害時の自動ロールバックを設定
    # - CloudWatch アラームを監視し、トリガー時にロールバックを実行

    auto_rollback_configuration {
      # CloudWatch アラーム設定 (必須)
      # - 最大10個のアラームを指定可能
      # - いずれかのアラームがトリガーされるとロールバックを実行

      alarms {
        # アラーム名 (必須)
        # - アカウント内の CloudWatch アラーム名を指定
        # - 例: エンドポイントのエラー率、レイテンシ、モデル精度などを監視
        alarm_name = "sagemaker-endpoint-error-rate-high"
      }

      # 追加のアラーム
      # alarms {
      #   alarm_name = "sagemaker-endpoint-latency-high"
      # }
    }
  }

  ################################################################################
  # タグ設定
  ################################################################################

  tags = {
    Name        = "my-sagemaker-endpoint"
    Environment = "production"
    Project     = "ml-inference"
    ManagedBy   = "terraform"
  }

  # tags_all は provider の default_tags と統合されて自動的に計算される (computed)
}

################################################################################
# 出力値
################################################################################

output "sagemaker_endpoint_arn" {
  description = "SageMaker エンドポイントの ARN"
  value       = aws_sagemaker_endpoint.example.arn
}

output "sagemaker_endpoint_name" {
  description = "SageMaker エンドポイント名"
  value       = aws_sagemaker_endpoint.example.name
}

################################################################################
# 補足情報
################################################################################

# デプロイメント戦略の選択ガイド:
#
# 1. Blue/Green (ALL_AT_ONCE)
#    - 最短のデプロイメント時間
#    - 100%のトラフィックが影響を受ける
#    - 低リスク環境やステージング環境に適している
#
# 2. Blue/Green (CANARY)
#    - 2段階でのトラフィック移行
#    - 初回は少量 (カナリア)、問題なければ残り全て
#    - リグレッションの影響をカナリアフリートに限定
#    - 両フリートが同時稼働するため若干コスト増
#
# 3. Blue/Green (LINEAR)
#    - 複数段階で均等にトラフィック移行
#    - リスクを最小化、ただしデプロイメント時間とコスト増
#    - 本番環境で段階的なリスク管理が必要な場合に適している
#
# 4. Rolling Update
#    - ユーザー指定のバッチサイズで段階的に更新
#    - Blue/Green より細かい制御が可能
#    - インスタンス数が多い環境で効率的

# 自動ロールバック設定のベストプラクティス:
#
# - エンドポイントのエラー率を監視するアラーム
# - レイテンシを監視するアラーム
# - モデルの精度や出力品質を監視するカスタムメトリクスのアラーム
# - アラームの閾値は環境やモデルの要件に応じて調整
# - 複数のアラームを設定することで、多角的な監視が可能

# 注意事項:
#
# - deployment_config は endpoint_config_name の変更時に適用される
# - Blue/Green と Rolling Update は同時使用不可
# - 未指定時は Blue/Green (ALL_AT_ONCE) がデフォルト
# - CloudWatch アラームは事前に作成しておく必要がある
# - エンドポイントの更新中は古いバージョンと新しいバージョンが共存する期間がある
# - トラフィックシフト中の監視とアラート設定は必須
