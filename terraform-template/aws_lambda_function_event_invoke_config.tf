#---------------------------------------------------------------
# AWS Lambda Function Event Invoke Config
#---------------------------------------------------------------
#
# Lambda関数の非同期呼び出しに関するエラーハンドリングと宛先設定を
# 管理するリソースです。最大イベント有効期間、最大リトライ回数、
# および成功・失敗時の送信先（SQS、SNS、EventBridge、Lambda等）を
# 設定することができます。
#
# AWS公式ドキュメント:
#   - Lambda非同期呼び出し: https://docs.aws.amazon.com/lambda/latest/dg/invocation-async.html
#   - Lambda非同期呼び出しの宛先: https://docs.aws.amazon.com/lambda/latest/dg/invocation-async.html#invocation-async-destinations
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_event_invoke_config
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_function_event_invoke_config" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # function_name (Required)
  # 設定内容: 設定対象のLambda関数の名前またはARNを指定します。
  # 設定可能な値: Lambda関数名、またはARN（バージョン・エイリアス修飾子を含まないもの）
  # 注意: バージョンやエイリアスの修飾子はqualifier引数で指定します。
  function_name = "example-function"

  # qualifier (Optional)
  # 設定内容: 設定を適用するLambda関数のバージョン、エイリアス名、または$LATESTを指定します。
  # 設定可能な値:
  #   - Lambda関数のバージョン番号（例: "1", "2"）
  #   - Lambda関数エイリアス名（例: "production"）
  #   - "$LATEST": 最新の未発行バージョン
  # 省略時: 関数全体（修飾子なし）に設定が適用されます。
  qualifier = null

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
  # エラーハンドリング設定
  #-------------------------------------------------------------

  # maximum_event_age_in_seconds (Optional)
  # 設定内容: Lambdaが関数への処理のためにリクエストを送信する最大イベント有効期間（秒）を指定します。
  # 設定可能な値: 60〜21600（秒）の整数
  # 省略時: AWSのデフォルト値（21600秒 = 6時間）が適用されます。
  # 注意: 指定できる最小値は60秒です。
  maximum_event_age_in_seconds = 3600

  # maximum_retry_attempts (Optional)
  # 設定内容: 関数がエラーを返した場合の最大リトライ回数を指定します。
  # 設定可能な値: 0〜2の整数
  #   - 0: リトライなし
  #   - 1: 1回リトライ
  #   - 2: 2回リトライ（デフォルト）
  # 省略時: 2（デフォルト）が適用されます。
  maximum_retry_attempts = 2

  #-------------------------------------------------------------
  # 宛先設定
  #-------------------------------------------------------------

  # destination_config (Optional)
  # 設定内容: 非同期呼び出しの成功・失敗時の送信先を設定するブロックです。
  # 関連機能: Lambda 非同期呼び出し宛先
  #   非同期呼び出しの結果を指定した宛先に転送します。対応する宛先リソースタイプは
  #   SQSキュー、SNSトピック、EventBridgeイベントバス、Lambda関数です。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/invocation-async.html#invocation-async-destinations
  destination_config {

    #-------------------------------------------------------------
    # 失敗時の宛先設定
    #-------------------------------------------------------------

    # on_failure (Optional)
    # 設定内容: 非同期呼び出し失敗時の送信先を設定するブロックです。
    # 関連機能: Lambda 失敗時宛先
    #   最大リトライ回数を超えて失敗した場合に指定した宛先にイベントを転送します。
    #   - https://docs.aws.amazon.com/lambda/latest/dg/invocation-async.html#invocation-async-destinations
    on_failure {

      # destination (Required)
      # 設定内容: 失敗時の送信先リソースのARNを指定します。
      # 設定可能な値:
      #   - SQSキューのARN（例: arn:aws:sqs:ap-northeast-1:123456789012:my-dlq）
      #   - SNSトピックのARN（例: arn:aws:sns:ap-northeast-1:123456789012:my-topic）
      #   - EventBridgeイベントバスのARN（例: arn:aws:events:ap-northeast-1:123456789012:event-bus/my-bus）
      #   - Lambda関数のARN（例: arn:aws:lambda:ap-northeast-1:123456789012:function:my-function）
      # 注意: 送信先リソースへのアクセス権限をLambda実行ロールに付与する必要があります。
      # 参考: https://docs.aws.amazon.com/lambda/latest/dg/invocation-async.html#invocation-async-destinations
      destination = "arn:aws:sqs:ap-northeast-1:123456789012:example-dlq"
    }

    #-------------------------------------------------------------
    # 成功時の宛先設定
    #-------------------------------------------------------------

    # on_success (Optional)
    # 設定内容: 非同期呼び出し成功時の送信先を設定するブロックです。
    # 関連機能: Lambda 成功時宛先
    #   関数が正常に処理を完了した場合に指定した宛先にイベントを転送します。
    #   - https://docs.aws.amazon.com/lambda/latest/dg/invocation-async.html#invocation-async-destinations
    on_success {

      # destination (Required)
      # 設定内容: 成功時の送信先リソースのARNを指定します。
      # 設定可能な値:
      #   - SQSキューのARN（例: arn:aws:sqs:ap-northeast-1:123456789012:my-queue）
      #   - SNSトピックのARN（例: arn:aws:sns:ap-northeast-1:123456789012:my-topic）
      #   - EventBridgeイベントバスのARN（例: arn:aws:events:ap-northeast-1:123456789012:event-bus/my-bus）
      #   - Lambda関数のARN（例: arn:aws:lambda:ap-northeast-1:123456789012:function:my-function）
      # 注意: 送信先リソースへのアクセス権限をLambda実行ロールに付与する必要があります。
      # 参考: https://docs.aws.amazon.com/lambda/latest/dg/invocation-async.html#invocation-async-destinations
      destination = "arn:aws:sns:ap-northeast-1:123456789012:example-success-topic"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Lambda関数の完全修飾名またはARN。qualifierが指定されている場合は
#       <function_name>:<qualifier> の形式になります。
#---------------------------------------------------------------
