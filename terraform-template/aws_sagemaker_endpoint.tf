#---------------------------------------------------------------
# AWS SageMaker Endpoint
#---------------------------------------------------------------
#
# Amazon SageMaker AIのエンドポイントをプロビジョニングするリソースです。
# エンドポイントは機械学習モデルをリアルタイム推論用にホストするための
# マネージドなインフラストラクチャを提供します。エンドポイント設定と
# 組み合わせて使用し、ブルー/グリーンデプロイやローリングデプロイなどの
# 高度なデプロイメント戦略をサポートします。
#
# AWS公式ドキュメント:
#   - SageMaker エンドポイント概要: https://docs.aws.amazon.com/sagemaker/latest/dg/realtime-endpoints.html
#   - デプロイメントガードレール: https://docs.aws.amazon.com/sagemaker/latest/dg/deployment-guardrails.html
#   - ブルー/グリーンデプロイ: https://docs.aws.amazon.com/sagemaker/latest/dg/deployment-guardrails-blue-green.html
#   - ローリングデプロイ: https://docs.aws.amazon.com/sagemaker/latest/dg/deployment-guardrails-rolling.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_endpoint" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # endpoint_config_name (Required)
  # 設定内容: このエンドポイントに使用するエンドポイント設定の名前を指定します。
  # 設定可能な値: 有効な aws_sagemaker_endpoint_configuration リソースの name
  endpoint_config_name = aws_sagemaker_endpoint_configuration.example.name

  # name (Optional)
  # 設定内容: エンドポイントの名前を指定します。
  # 設定可能な値: 1-63文字の英数字またはハイフン
  # 省略時: Terraformがランダムな一意の名前を自動生成します。
  name = "my-sagemaker-endpoint"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # デプロイメント設定
  #-------------------------------------------------------------

  # deployment_config (Optional)
  # 設定内容: エンドポイントのデプロイメント戦略とロールバック設定を定義するブロックです。
  # 設定可能な値: blue_green_update_policy または rolling_update_policy のいずれか一方を指定します。
  # 省略時: SageMakerはデフォルトのブルー/グリーンデプロイ（全トラフィック一括切り替え）を使用します。
  # 関連機能: SageMaker デプロイメントガードレール
  #   本番環境でのモデル更新を安全に管理するための機能。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/deployment-guardrails.html
  deployment_config {

    #-------------------------------------------------------------
    # ブルー/グリーンデプロイ設定
    #-------------------------------------------------------------

    # blue_green_update_policy (Optional)
    # 設定内容: ブルー/グリーンデプロイのトラフィック移行ポリシーを設定するブロックです。
    # 設定内容: デプロイ中に旧フリート（ブルー）を維持しながら新フリート（グリーン）を
    #   プロビジョニングし、指定のトラフィックルーティング設定に従ってトラフィックを切り替えます。
    # 注意: blue_green_update_policy と rolling_update_policy はどちらか一方のみ指定可能です。
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/deployment-guardrails-blue-green.html
    blue_green_update_policy {

      # maximum_execution_timeout_in_seconds (Optional)
      # 設定内容: デプロイメント全体の最大実行タイムアウト時間（秒）を指定します。
      # 設定可能な値: 600〜14400（秒）
      # 省略時: タイムアウト制限なしでデプロイを実行します。
      # 注意: termination_wait_in_seconds と wait_interval_in_seconds の合計よりも
      #       大きい値を設定する必要があります。
      maximum_execution_timeout_in_seconds = 3600

      # termination_wait_in_seconds (Optional)
      # 設定内容: エンドポイントデプロイ完了後、旧エンドポイントフリートを終了するまでの
      #   追加待機時間（秒）を指定します。
      # 設定可能な値: 0〜3600（秒）
      # 省略時: 0（デプロイ完了後すぐに旧フリートを終了）
      termination_wait_in_seconds = 0

      # traffic_routing_configuration (Required)
      # 設定内容: 旧フリートから新フリートへのトラフィック移行戦略を定義するブロックです。
      # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_TrafficRoutingConfig.html
      traffic_routing_configuration {

        # type (Required)
        # 設定内容: トラフィックルーティング戦略のタイプを指定します。
        # 設定可能な値:
        #   - "ALL_AT_ONCE": すべてのトラフィックを一度に新フリートへ切り替えます。
        #                    更新時間は最短ですが、全トラフィックに影響が及びます。
        #   - "CANARY": 2段階でトラフィックを移行します。最初に少量（カナリア）を
        #               移行し、問題がなければ残りを切り替えます。
        #   - "LINEAR": 固定ステップで段階的にトラフィックを移行します。
        #               リスクは低いですが更新時間とコストが増加します。
        type = "CANARY"

        # wait_interval_in_seconds (Required)
        # 設定内容: 新フリートへのトラフィック増加ステップ間の待機時間（秒）を指定します。
        #   このベイキング期間中にSageMakerはアラームを監視します。
        # 設定可能な値: 0〜3600（秒）
        wait_interval_in_seconds = 300

        # canary_size (Optional)
        # 設定内容: 最初のステップで新フリートに移行するトラフィック量（カナリアサイズ）を
        #   設定するブロックです。type が "CANARY" の場合に使用します。
        # 設定可能な値: バリアントの総インスタンス数の50%以下の値を指定します。
        canary_size {

          # type (Required)
          # 設定内容: カナリアサイズの容量タイプを指定します。
          # 設定可能な値:
          #   - "INSTANCE_COUNT": インスタンス数で容量を指定します。
          #   - "CAPACITY_PERCENT": 容量のパーセンテージで指定します。
          type = "INSTANCE_COUNT"

          # value (Required)
          # 設定内容: カナリアサイズの容量値を指定します。
          # 設定可能な値: type に応じたインスタンス数またはパーセンテージ（整数）
          value = 1
        }

        # linear_step_size (Optional)
        # 設定内容: 各ステップで新フリートに移行するトラフィック量を設定するブロックです。
        #   type が "LINEAR" の場合に使用します。
        # 設定可能な値: バリアントの総インスタンス数の10〜50%の値を指定します。
        linear_step_size {

          # type (Required)
          # 設定内容: リニアステップサイズの容量タイプを指定します。
          # 設定可能な値:
          #   - "INSTANCE_COUNT": インスタンス数で容量を指定します。
          #   - "CAPACITY_PERCENT": 容量のパーセンテージで指定します。
          type = "CAPACITY_PERCENT"

          # value (Required)
          # 設定内容: リニアステップサイズの容量値を指定します。
          # 設定可能な値: type に応じたインスタンス数またはパーセンテージ（整数）
          value = 10
        }
      }
    }

    #-------------------------------------------------------------
    # ローリングデプロイ設定
    #-------------------------------------------------------------

    # rolling_update_policy (Optional)
    # 設定内容: ローリングデプロイ戦略を設定するブロックです。
    # 設定内容: エンドポイントを段階的なバッチでインクリメンタルに更新します。
    #   ブルー/グリーンに比べてリソース消費を抑えながら安全に更新できます。
    # 注意: blue_green_update_policy と rolling_update_policy はどちらか一方のみ指定可能です。
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/deployment-guardrails-rolling.html
    rolling_update_policy {

      # wait_interval_in_seconds (Required)
      # 設定内容: 各バッチの新フリートに対してSageMakerがアラームを監視する
      #   ベイキング期間の長さ（秒）を指定します。
      # 設定可能な値: 0〜3600（秒）
      wait_interval_in_seconds = 300

      # maximum_execution_timeout_in_seconds (Optional)
      # 設定内容: デプロイメント全体のタイムアウト時間（秒）を指定します。
      # 設定可能な値: 600〜14400（秒）
      # 省略時: タイムアウト制限なしでデプロイを実行します。
      maximum_execution_timeout_in_seconds = 3600

      # maximum_batch_size (Required)
      # 設定内容: ローリングデプロイの各ステップで新フリートにプロビジョニングする
      #   キャパシティのバッチサイズを設定するブロックです。
      # 設定可能な値: バリアントの総インスタンス数の5〜50%の値を指定します。
      # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_RollingUpdatePolicy.html
      maximum_batch_size {

        # type (Required)
        # 設定内容: バッチサイズの容量タイプを指定します。
        # 設定可能な値:
        #   - "INSTANCE_COUNT": インスタンス数で容量を指定します。
        #   - "CAPACITY_PERCENT": 容量のパーセンテージで指定します。
        type = "CAPACITY_PERCENT"

        # value (Required)
        # 設定内容: バッチサイズの容量値を指定します。
        # 設定可能な値: type に応じたインスタンス数またはパーセンテージ（整数）
        value = 25
      }

      # rollback_maximum_batch_size (Optional)
      # 設定内容: ロールバック時に旧フリートへ戻すキャパシティのバッチサイズを
      #   設定するブロックです。
      # 省略時: 総キャパシティの100%（旧フリート全体を一度に復元）
      rollback_maximum_batch_size {

        # type (Required)
        # 設定内容: ロールバックバッチサイズの容量タイプを指定します。
        # 設定可能な値:
        #   - "INSTANCE_COUNT": インスタンス数で容量を指定します。
        #   - "CAPACITY_PERCENT": 容量のパーセンテージで指定します。
        type = "CAPACITY_PERCENT"

        # value (Required)
        # 設定内容: ロールバックバッチサイズの容量値を指定します。
        # 設定可能な値: type に応じたインスタンス数またはパーセンテージ（整数）
        value = 100
      }
    }

    #-------------------------------------------------------------
    # 自動ロールバック設定
    #-------------------------------------------------------------

    # auto_rollback_configuration (Optional)
    # 設定内容: デプロイメント失敗時の自動ロールバックを設定するブロックです。
    #   指定したCloudWatchアラームがトリガーされた場合、SageMakerが自動的に
    #   旧エンドポイントフリートへロールバックします。
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_AutoRollbackConfig.html
    auto_rollback_configuration {

      # alarms (Required)
      # 設定内容: デプロイメントを監視するCloudWatchアラームのリストを設定するブロックです。
      #   いずれかのアラームが発火した場合、SageMakerはデプロイをロールバックします。
      # 設定可能な値: 最大10件のアラームを指定可能です。
      alarms {

        # alarm_name (Required)
        # 設定内容: 監視するCloudWatchアラームの名前を指定します。
        # 設定可能な値: アカウント内に存在する有効なCloudWatchアラーム名
        alarm_name = "sagemaker-endpoint-error-rate-alarm"
      }
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-sagemaker-endpoint"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: エンドポイントのAmazon Resource Name (ARN)
#
# - name: エンドポイントの名前
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
