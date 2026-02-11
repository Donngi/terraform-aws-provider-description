#---------------------------------------------------------------
# AWS AppSync Function
#---------------------------------------------------------------
#
# AWS AppSyncのパイプラインリゾルバーで使用される関数をプロビジョニングするリソースです。
# AppSync関数は、GraphQLリクエストを処理するためのロジックをカプセル化し、
# 複数のリゾルバー間で再利用可能なコンポーネントを定義します。
#
# AWS公式ドキュメント:
#   - AppSync JavaScript resolvers overview: https://docs.aws.amazon.com/appsync/latest/devguide/resolver-reference-overview-js.html
#   - Pipeline resolvers: https://docs.aws.amazon.com/appsync/latest/devguide/pipeline-resolvers-js.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appsync_function
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appsync_function" "example" {
  #-------------------------------------------------------------
  # 基本設定 (必須)
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: 関連付けるAppSync GraphQL APIのIDを指定します。
  # 設定可能な値: 有効なAppSync GraphQL APIのID
  api_id = aws_appsync_graphql_api.example.id

  # data_source (Required)
  # 設定内容: この関数が使用するデータソースの名前を指定します。
  # 設定可能な値: 同じAPIに関連付けられたAppSyncデータソースの名前
  data_source = aws_appsync_datasource.example.name

  # name (Required)
  # 設定内容: 関数の名前を指定します。
  # 設定可能な値: 文字列
  # 注意: 関数名は一意である必要はありません
  name = "example_function"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: 関数の説明を指定します。
  # 設定可能な値: 文字列
  description = "Example AppSync function for data processing"

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
  # JavaScript実行設定
  #-------------------------------------------------------------

  # code (Optional)
  # 設定内容: リクエスト関数とレスポンス関数を含む関数コードを指定します。
  # 設定可能な値: JavaScript形式のコード文字列
  # 注意: codeを使用する場合、runtimeブロックの指定が必須です。
  #       runtimeのnameはAPPSYNC_JSである必要があります。
  # 参考: https://docs.aws.amazon.com/appsync/latest/devguide/resolver-reference-overview-js.html
  code = <<-EOF
import { util } from '@aws-appsync/utils';

export function request(ctx) {
  return {
    operation: 'GetItem',
    key: util.dynamodb.toMapValues({ id: ctx.args.id }),
  };
}

export function response(ctx) {
  return ctx.result;
}
EOF

  #-------------------------------------------------------------
  # VTLマッピングテンプレート設定 (JavaScript runtimeと排他)
  #-------------------------------------------------------------

  # request_mapping_template (Optional)
  # 設定内容: 関数のリクエストマッピングテンプレートを指定します。
  # 設定可能な値: VTL (Velocity Template Language) 形式の文字列
  # 注意: 2018-05-29バージョンのリクエストマッピングテンプレートのみサポート。
  #       code属性を使用する場合は不要です。
  # request_mapping_template = <<-EOF
  # {
  #   "version": "2018-05-29",
  #   "operation": "GetItem",
  #   "key": {
  #     "id": $util.dynamodb.toDynamoDBJson($ctx.args.id)
  #   }
  # }
  # EOF
  request_mapping_template = null

  # response_mapping_template (Optional)
  # 設定内容: 関数のレスポンスマッピングテンプレートを指定します。
  # 設定可能な値: VTL (Velocity Template Language) 形式の文字列
  # 注意: code属性を使用する場合は不要です。
  # response_mapping_template = <<-EOF
  # #if($ctx.result.statusCode == 200)
  #   $ctx.result.body
  # #else
  #   $utils.appendError($ctx.result.body, $ctx.result.statusCode)
  # #end
  # EOF
  response_mapping_template = null

  #-------------------------------------------------------------
  # 関数バージョン設定
  #-------------------------------------------------------------

  # function_version (Optional)
  # 設定内容: リクエストマッピングテンプレートのバージョンを指定します。
  # 設定可能な値:
  #   - "2018-05-29": 現在サポートされているバージョン
  # 注意: code属性を指定する場合は適用されません。
  function_version = null

  #-------------------------------------------------------------
  # バッチ処理設定
  #-------------------------------------------------------------

  # max_batch_size (Optional)
  # 設定内容: リゾルバーの最大バッチサイズを指定します。
  # 設定可能な値: 0～2000の整数
  # 用途: DynamoDBなどのデータソースへのバッチリクエストサイズを制御
  max_batch_size = 0

  #-------------------------------------------------------------
  # ランタイム設定
  #-------------------------------------------------------------

  # runtime (Optional)
  # 設定内容: AppSyncパイプラインリゾルバーまたはAppSync関数で使用する
  #          ランタイムを記述します。
  # 注意: runtimeを指定する場合、codeも指定する必要があります。
  # 参考: https://docs.aws.amazon.com/appsync/latest/APIReference/API_AppSyncRuntime.html
  runtime {
    # name (Required)
    # 設定内容: 使用するランタイムの名前を指定します。
    # 設定可能な値:
    #   - "APPSYNC_JS": JavaScript ランタイム（現在サポートされている唯一の値）
    name = "APPSYNC_JS"

    # runtime_version (Required)
    # 設定内容: 使用するランタイムのバージョンを指定します。
    # 設定可能な値:
    #   - "1.0.0": 現在サポートされている唯一のバージョン
    runtime_version = "1.0.0"
  }

  #-------------------------------------------------------------
  # 同期設定 (コンフリクト解決)
  #-------------------------------------------------------------

  # sync_config (Optional)
  # 設定内容: リゾルバーの同期設定を記述します。
  # 用途: AppSync内のデータ競合を検出・解決するための設定
  # sync_config {
  #   # conflict_detection (Optional)
  #   # 設定内容: コンフリクト検出戦略を指定します。
  #   # 設定可能な値:
  #   #   - "NONE": コンフリクト検出を無効化
  #   #   - "VERSION": バージョンベースのコンフリクト検出を有効化
  #   conflict_detection = "VERSION"
  #
  #   # conflict_handler (Optional)
  #   # 設定内容: コンフリクト発生時の解決戦略を指定します。
  #   # 設定可能な値:
  #   #   - "NONE": コンフリクトハンドラーを使用しない
  #   #   - "OPTIMISTIC_CONCURRENCY": 楽観的並行性制御。最初の書き込みが優先
  #   #   - "AUTOMERGE": 自動マージ。競合するフィールドを自動的にマージ
  #   #   - "LAMBDA": Lambda関数によるカスタムコンフリクト解決
  #   conflict_handler = "OPTIMISTIC_CONCURRENCY"
  #
  #   # lambda_conflict_handler_config (Optional)
  #   # 設定内容: conflict_handlerが"LAMBDA"の場合のLambda関数設定
  #   # lambda_conflict_handler_config {
  #   #   # lambda_conflict_handler_arn (Optional)
  #   #   # 設定内容: コンフリクトハンドラーとして使用するLambda関数のARN
  #   #   # 設定可能な値: 有効なLambda関数のARN
  #   #   lambda_conflict_handler_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:conflict-handler"
  #   # }
  # }

  #-------------------------------------------------------------
  # ID設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 注意: 通常は自動生成されるため、明示的な指定は不要です。
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Function オブジェクトのARN
#
# - function_id: Function オブジェクトを表す一意のID
#
# - id: API Function ID (ApiId-FunctionId の形式)
#---------------------------------------------------------------
