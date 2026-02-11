#---------------------------------------------------------------
# AWS API Gateway Method Settings
#---------------------------------------------------------------
#
# API GatewayのステージごとのメソッドレベルのCloudWatchログ記録、
# メトリクス、スロットリング、キャッシュ設定を管理するリソースです。
# ステージ内の全メソッドに対する設定と、個別メソッドに対する設定の
# 両方をサポートします。
#
# AWS公式ドキュメント:
#   - API Gateway ステージの設定: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-stages.html
#   - API Gateway キャッシュ設定: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-caching.html
#   - API Gateway スロットリング: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-request-throttling.html
#   - MethodSetting API リファレンス: https://docs.aws.amazon.com/apigateway/latest/api/API_MethodSetting.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_method_settings" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # rest_api_id (Required)
  # 設定内容: 設定を適用するREST APIのIDを指定します。
  # 設定可能な値: 有効なAPI Gateway REST API ID
  rest_api_id = aws_api_gateway_rest_api.example.id

  # stage_name (Required)
  # 設定内容: 設定を適用するステージの名前を指定します。
  # 設定可能な値: ステージ名の文字列
  # 注意: aws_api_gateway_deploymentのオプションのstage_name引数で管理される
  #       ステージではなく、aws_api_gateway_stageリソースと併用することを推奨。
  #       aws_api_gateway_deploymentで管理されるステージは再デプロイ時に再作成され、
  #       このリソースを再度適用する必要があるため。
  stage_name = aws_api_gateway_stage.example.stage_name

  # method_path (Required)
  # 設定内容: 設定を適用するメソッドパスを指定します。
  # 設定可能な値:
  #   - "*/*": ステージ内の全メソッドに設定を適用
  #   - "{resource_path}/{http_method}": 特定のメソッドに設定を適用
  #     例: "path1/GET", "users/POST", "items/{id}/DELETE"
  # 注意: パスの先頭のスラッシュは削除してください
  #       例: trimprefix(aws_api_gateway_resource.example.path, "/")
  method_path = "*/*"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # メソッド設定 (settings ブロック - Required)
  #-------------------------------------------------------------

  settings {
    #-----------------------------------------------------------
    # CloudWatch メトリクス・ロギング設定
    #-----------------------------------------------------------

    # metrics_enabled (Optional)
    # 設定内容: このメソッドのCloudWatchメトリクスを有効にするかを指定します。
    # 設定可能な値:
    #   - true: メトリクスを有効化（Count, Latency, IntegrationLatency等を収集）
    #   - false: メトリクスを無効化
    # 関連機能: API Gateway CloudWatch メトリクス
    #   API呼び出し数、レイテンシ、エラー率などをモニタリング可能。
    #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-metrics-and-dimensions.html
    metrics_enabled = true

    # logging_level (Optional)
    # 設定内容: CloudWatch Logsへのログレベルを指定します。
    # 設定可能な値:
    #   - "OFF": ロギングを無効化
    #   - "ERROR": エラーレベルのエントリのみを記録
    #   - "INFO": ERRORイベントに加えて追加の情報イベントも記録
    # 注意: ロギングを有効にするには、ステージにCloudWatch Logsロールの
    #       ARNを設定する必要があります（aws_api_gateway_account参照）
    logging_level = "ERROR"

    # data_trace_enabled (Optional)
    # 設定内容: データトレースロギングを有効にするかを指定します。
    # 設定可能な値:
    #   - true: リクエスト/レスポンスの本文全体をログに記録
    #   - false: データトレースロギングを無効化
    # 注意: APIのトラブルシューティングに有用ですが、機密データがログに
    #       記録される可能性があります。本番APIでは無効にすることを推奨。
    # 関連機能: API Gateway 実行ログ
    #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-stages.html
    data_trace_enabled = false

    #-----------------------------------------------------------
    # スロットリング設定
    #-----------------------------------------------------------

    # throttling_burst_limit (Optional)
    # 設定内容: スロットリングのバースト制限を指定します。
    # 設定可能な値: 整数値
    #   - -1: スロットリングを無効化（デフォルト）
    #   - 0以上: 許可する最大同時リクエスト数
    # 関連機能: API Gateway リクエストスロットリング
    #   トークンバケットアルゴリズムを使用。バースト制限はバケットサイズを
    #   定義し、一時的なリクエスト急増に対応可能な最大数を示します。
    #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-request-throttling.html
    throttling_burst_limit = -1

    # throttling_rate_limit (Optional)
    # 設定内容: スロットリングのレート制限（RPS）を指定します。
    # 設定可能な値: 数値（小数可）
    #   - -1: スロットリングを無効化（デフォルト）
    #   - 0以上: 1秒あたりの許可リクエスト数
    # 関連機能: API Gateway リクエストスロットリング
    #   定常状態でのリクエストレートを制御。アカウントレベルの制限を
    #   超えることはできません。
    #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-request-throttling.html
    throttling_rate_limit = -1

    #-----------------------------------------------------------
    # キャッシュ設定
    #-----------------------------------------------------------

    # caching_enabled (Optional)
    # 設定内容: レスポンスのキャッシュを有効にするかを指定します。
    # 設定可能な値:
    #   - true: キャッシュを有効化（ステージでキャッシュクラスタが有効な場合のみ機能）
    #   - false: キャッシュを無効化
    # 注意: キャッシュを使用するには、ステージレベルでキャッシュクラスタを
    #       有効にする必要があります（aws_api_gateway_stage.cache_cluster_enabled）
    # 関連機能: API Gateway キャッシュ
    #   エンドポイントへの呼び出し回数を削減し、APIへのリクエストのレイテンシを改善。
    #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-caching.html
    caching_enabled = false

    # cache_ttl_in_seconds (Optional)
    # 設定内容: キャッシュされたレスポンスのTTL（秒）を指定します。
    # 設定可能な値: 0〜3600の整数
    #   - 0: キャッシュを無効化
    #   - 300: デフォルト値（5分）
    #   - 3600: 最大値（1時間）
    # 注意: TTLが高いほど、レスポンスは長くキャッシュされます。
    # 関連機能: API Gateway キャッシュ
    #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-caching.html
    cache_ttl_in_seconds = 300

    # cache_data_encrypted (Optional)
    # 設定内容: キャッシュされたレスポンスを暗号化するかを指定します。
    # 設定可能な値:
    #   - true: キャッシュデータを暗号化
    #   - false: キャッシュデータを暗号化しない
    # 関連機能: API Gateway キャッシュ
    #   機密データをキャッシュする場合は暗号化を有効にすることを推奨。
    #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-caching.html
    cache_data_encrypted = false

    # require_authorization_for_cache_control (Optional)
    # 設定内容: キャッシュ無効化リクエストに認可を必要とするかを指定します。
    # 設定可能な値:
    #   - true: Cache-Control: max-age=0ヘッダーによるキャッシュ無効化に認可が必要
    #   - false: 認可なしでキャッシュ無効化が可能
    # 注意: falseの場合、クライアントがキャッシュを無効化できるため、
    #       キャッシュの効果が減少する可能性があります。
    # 関連機能: API Gateway キャッシュ無効化
    #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-caching.html
    require_authorization_for_cache_control = true

    # unauthorized_cache_control_header_strategy (Optional)
    # 設定内容: 認可されていないキャッシュ無効化リクエストの処理方法を指定します。
    # 設定可能な値:
    #   - "FAIL_WITH_403": 403 Forbiddenエラーを返す
    #   - "SUCCEED_WITH_RESPONSE_HEADER": リクエストを許可し、警告ヘッダーを追加
    #   - "SUCCEED_WITHOUT_RESPONSE_HEADER": リクエストを許可（ヘッダーなし）
    # 注意: require_authorization_for_cache_controlがtrueの場合にのみ適用
    # 関連機能: API Gateway キャッシュ無効化
    #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-caching.html
    unauthorized_cache_control_header_strategy = "FAIL_WITH_403"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは標準属性のみをエクスポートします:
#
# - id: リソースのID
#---------------------------------------------------------------
