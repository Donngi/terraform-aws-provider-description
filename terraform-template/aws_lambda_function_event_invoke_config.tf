#---------------------------------------------------------------
# Lambda Function Event Invoke Config
#---------------------------------------------------------------
#
# Lambda関数の非同期呼び出しに関するエラーハンドリング設定と
# 呼び出し先（destination）を管理するリソース。
# 非同期呼び出し時のリトライ動作、イベント保持期間、
# 成功/失敗時の通知先を設定できます。
#
# AWS公式ドキュメント:
#   - Invoking a Lambda function asynchronously: https://docs.aws.amazon.com/lambda/latest/dg/invocation-async.html
#   - Configuring error handling settings: https://docs.aws.amazon.com/lambda/latest/dg/invocation-async-configuring.html
#   - Capturing records of asynchronous invocations: https://docs.aws.amazon.com/lambda/latest/dg/invocation-async-retain-records.html
#   - PutFunctionEventInvokeConfig API: https://docs.aws.amazon.com/lambda/latest/api/API_PutFunctionEventInvokeConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_event_invoke_config
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_function_event_invoke_config" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # Lambda関数の名前またはARN（バージョンやエイリアスのqualifierは含めない）
  # 例: "my-function" または "arn:aws:lambda:us-east-1:123456789012:function:my-function"
  function_name = "my-function"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # Lambda関数のバージョン、$LATEST、またはエイリアス名を指定
  # 指定しない場合は$LATESTが対象となる
  # 例: "1" (バージョン), "$LATEST", "production" (エイリアス名)
  qualifier = null

  # イベントが非同期キューに保持される最大時間（秒）
  # Lambdaがこの時間を超えたイベントを破棄する前に処理する最大期間
  # 有効範囲: 60～21600秒（1分～6時間）
  # デフォルト: 21600秒（6時間）
  maximum_event_age_in_seconds = null

  # 関数がエラーを返した際の最大リトライ回数
  # 有効範囲: 0～2回
  # デフォルト: 2回
  # 0を指定するとリトライせず即座に失敗とする
  maximum_retry_attempts = null

  # このリソースが管理されるAWSリージョン
  # 指定しない場合はプロバイダー設定のリージョンがデフォルトで使用される
  # 通常は明示的に指定する必要はないが、マルチリージョン構成の場合に使用
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # ネストブロック: destination_config
  #---------------------------------------------------------------
  # 非同期呼び出しの成功時・失敗時の通知先（destination）を設定
  # 最大1ブロックまで指定可能

  destination_config {
    #---------------------------------------------------------------
    # on_failure - 失敗時の通知先設定
    #---------------------------------------------------------------
    # イベントが全てのリトライを使い果たしたか、最大保持期間を超えた場合に
    # 通知されるdestinationを設定
    # 最大1ブロックまで指定可能

    on_failure {
      # 失敗したイベントの送信先リソースのARN（必須）
      # サポートされるdestination:
      #   - Lambda関数
      #   - SQS標準キュー
      #   - S3バケット（失敗時のみサポート）
      #   - SNS標準トピック
      #   - EventBridgeイベントバス
      #
      # 注意:
      #   - FIFO SQSキューとFIFO SNSトピックはサポートされていません
      #   - S3をdestinationとして使用する場合、実行ロールに
      #     s3:PutObject, s3:ListBucket権限が必要
      #   - S3暗号化が有効な場合はkms:GenerateDataKey権限も必要
      #
      # 例: "arn:aws:sqs:us-east-1:123456789012:my-dlq"
      destination = "arn:aws:sqs:us-east-1:123456789012:lambda-failure-queue"
    }

    #---------------------------------------------------------------
    # on_success - 成功時の通知先設定
    #---------------------------------------------------------------
    # 関数が正常に非同期呼び出しを処理した際に通知されるdestinationを設定
    # 最大1ブロックまで指定可能

    on_success {
      # 成功したイベントの送信先リソースのARN（必須）
      # サポートされるdestination:
      #   - Lambda関数
      #   - SQS標準キュー
      #   - SNS標準トピック
      #   - EventBridgeイベントバス
      #
      # 注意:
      #   - S3バケットは成功時のdestinationとしてはサポートされていません
      #   - FIFO SQSキューとFIFO SNSトピックはサポートされていません
      #   - SNSの最大メッセージサイズは256KBのため、ペイロードが1MBに近い場合
      #     呼び出しレコードがSNSの制限を超えて配信失敗する可能性があります
      #     大きなペイロードの場合はSQSまたはS3の使用を検討してください
      #
      # 例: "arn:aws:sns:us-east-1:123456789012:lambda-success-topic"
      destination = "arn:aws:sns:us-east-1:123456789012:lambda-success-notifications"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# このリソースでは以下の属性をエクスポートします:
#
# - id: 完全修飾されたLambda関数名またはARN
#       例: "my-function" または "arn:aws:lambda:us-east-1:123456789012:function:my-function:production"
#
# これらの属性はcomputed（自動計算）されるため、
# リソース定義内で直接指定することはできません。
# 他のリソースから参照する際に使用します。
#
# 使用例:
#   resource.aws_lambda_function_event_invoke_config.example.id
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例とベストプラクティス
#---------------------------------------------------------------
#
# 1. 基本的なエラーハンドリング設定（失敗時のみ）:
#    - maximum_event_age_in_seconds: 300（5分）
#    - maximum_retry_attempts: 1（1回リトライ）
#    - destination_config.on_failure: SQSキューへ送信
#
# 2. 本番環境用の設定例:
#    - qualifier: "production"（エイリアス指定）
#    - maximum_event_age_in_seconds: 1800（30分）
#    - maximum_retry_attempts: 2（デフォルト）
#    - 成功と失敗の両方のdestinationを設定
#
# 3. 開発環境用の設定例（fail fast）:
#    - qualifier: "$LATEST"
#    - maximum_event_age_in_seconds: 120（2分）
#    - maximum_retry_attempts: 0（リトライなし）
#
# 4. IAM権限要件:
#    Lambda関数の実行ロールに以下の権限が必要:
#    - SQS destination: sqs:SendMessage
#    - SNS destination: sns:Publish
#    - S3 destination: s3:PutObject, s3:ListBucket
#    - Lambda destination: lambda:InvokeFunction
#    - EventBridge destination: events:PutEvents
#
# 5. セキュリティベストプラクティス（S3 destination使用時）:
#    実行ロールのs3:PutObject権限を自アカウント内のバケットに制限する
#    条件を追加することを推奨:
#    Condition: { "StringEquals": { "s3:ResourceAccount": "123456789012" } }
#
# 6. モニタリング:
#    Lambdaは設定したdestinationへのレコード送信に失敗した場合、
#    CloudWatchに"DestinationDeliveryFailures"メトリクスを送信します。
#    これは設定ミス（例: FIFOキューの指定）や権限エラー、
#    サイズ制限超過などで発生する可能性があります。
#
#---------------------------------------------------------------
