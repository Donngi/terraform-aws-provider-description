#---------------------------------------------------------------
# AWS CloudWatch Event Endpoint (EventBridge Global Endpoint)
#---------------------------------------------------------------
#
# Amazon EventBridge Global Endpointをプロビジョニングするリソースです。
# グローバルエンドポイントは、リージョン間でのイベントルーティングを可能にし、
# プライマリリージョンで障害が発生した場合にセカンダリリージョンへ
# 自動的にフェイルオーバーすることで、アプリケーションの耐障害性を向上させます。
#
# Note: EventBridgeは以前CloudWatch Eventsとして知られていました。機能は同一です。
#
# AWS公式ドキュメント:
#   - EventBridge Global Endpoints概要: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-global-endpoints.html
#   - グローバルエンドポイントの作成: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-ge-create-endpoint.html
#   - ベストプラクティス: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-ge-best-practices.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_event_endpoint" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: グローバルエンドポイントの名前を指定します。
  # 設定可能な値: 文字列（エンドポイントを一意に識別する名前）
  name = "my-global-endpoint"

  # description (Optional)
  # 設定内容: グローバルエンドポイントの説明を指定します。
  # 設定可能な値: 文字列
  description = "Global endpoint for cross-region event routing"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # role_arn (Optional)
  # 設定内容: イベントバス間のレプリケーションに使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 関連機能: EventBridge イベントレプリケーション
  #   イベントレプリケーションを有効にする場合は必須です。
  #   replication_config.stateがENABLEDの場合、このロールが使用されます。
  role_arn = "arn:aws:iam::123456789012:role/eventbridge-replication-role"

  #-------------------------------------------------------------
  # イベントバス設定
  #-------------------------------------------------------------
  # event_bus (Required)
  # 設定内容: 使用するイベントバスを指定します。
  # 要件:
  #   - 正確に2つのイベントバスを指定する必要があります
  #   - 各リージョンのイベントバス名は同一である必要があります
  #   - 最初のイベントバスがプライマリ、2番目がセカンダリとして扱われます

  # プライマリリージョンのイベントバス
  event_bus {
    # event_bus_arn (Required)
    # 設定内容: エンドポイントに関連付けるイベントバスのARNを指定します。
    # 設定可能な値: 有効なEventBusのARN
    event_bus_arn = "arn:aws:events:us-east-1:123456789012:event-bus/my-event-bus"
  }

  # セカンダリリージョンのイベントバス
  event_bus {
    # event_bus_arn (Required)
    # 設定内容: エンドポイントに関連付けるイベントバスのARNを指定します。
    # 設定可能な値: 有効なEventBusのARN
    event_bus_arn = "arn:aws:events:us-west-2:123456789012:event-bus/my-event-bus"
  }

  #-------------------------------------------------------------
  # レプリケーション設定
  #-------------------------------------------------------------

  # replication_config (Optional)
  # 設定内容: イベントレプリケーションのパラメータを指定します。
  # 関連機能: EventBridge イベントレプリケーション
  #   イベントレプリケーションを有効にすると、全てのカスタムイベントが
  #   プライマリとセカンダリの両リージョンに送信されます。
  #   これにより障害発生時の自動復旧が可能になります。
  replication_config {
    # state (Optional)
    # 設定内容: イベントレプリケーションの状態を指定します。
    # 設定可能な値:
    #   - "ENABLED": レプリケーションを有効化。role_arnの指定が必須です。
    #   - "DISABLED": レプリケーションを無効化。
    # 省略時: "ENABLED"（デフォルト）
    # 注意: ENABLEDを使用する場合はrole_arnを指定する必要があります。
    #       role_arnがない場合、またはレプリケーションを使用しない場合は
    #       DISABLEDに設定してください。
    state = "ENABLED"
  }

  #-------------------------------------------------------------
  # ルーティング設定
  #-------------------------------------------------------------

  # routing_config (Required)
  # 設定内容: ルーティングパラメータを指定します。
  # ヘルスチェックとセカンダリリージョンの設定を含みます。
  routing_config {
    # failover_config (Required)
    # 設定内容: フェイルオーバーのパラメータを指定します。
    # フェイルオーバーのトリガー条件と、トリガー時の動作を定義します。
    failover_config {
      # primary (Required)
      # 設定内容: プライマリリージョンのパラメータを指定します。
      primary {
        # health_check (Optional)
        # 設定内容: フェイルオーバーをトリガーするかどうかを判断するために
        #          エンドポイントが使用するヘルスチェックのARNを指定します。
        # 設定可能な値: 有効なRoute 53ヘルスチェックのARN
        # 関連機能: Route 53 ヘルスチェック
        #   ヘルスチェックが異常を検知すると、エンドポイントは
        #   イベントをセカンダリリージョンにルーティングします。
        #   RTO（目標復旧時間）とRPO（目標復旧時点）は最大420秒です。
        health_check = "arn:aws:route53:::healthcheck/12345678-1234-1234-1234-123456789012"
      }

      # secondary (Required)
      # 設定内容: セカンダリリージョンのパラメータを指定します。
      # フェイルオーバーがトリガーされた場合、またはイベントレプリケーションが
      # 有効な場合にイベントがルーティングされるリージョンです。
      secondary {
        # route (Optional)
        # 設定内容: セカンダリリージョンの名前を指定します。
        # 設定可能な値: 有効なAWSリージョンコード（例: us-west-2, eu-west-1）
        # 関連機能: EventBridge クロスリージョンルーティング
        #   プライマリリージョンで障害が発生した場合、イベントは
        #   このセカンダリリージョンにルーティングされます。
        route = "us-west-2"
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 作成されたエンドポイントのAmazon Resource Name (ARN)
#
# - endpoint_url: 作成されたエンドポイントのURL
#   PutEvents API呼び出し時にこのURLを使用してイベントを送信します。
#---------------------------------------------------------------
