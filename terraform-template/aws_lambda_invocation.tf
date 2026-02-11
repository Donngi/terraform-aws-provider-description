#---------------------------------------------------------------
# AWS Lambda Invocation
#---------------------------------------------------------------
#
# AWS Lambda関数を同期的に呼び出すリソース。RequestResponse呼び出しタイプを
# 使用してLambda関数を実行し、その結果をTerraform管理下で取得できます。
#
# このリソースはデフォルトではリソース作成時または置換時のみ関数を呼び出します。
# 引数が変更されない限り、再度のapplyでは関数は再実行されません。
# 動的な呼び出しには`triggers`属性を、常に実行する場合はデータソースの
# aws_lambda_invocationを使用してください。
#
# AWS公式ドキュメント:
#   - Lambda関数の呼び出し方法: https://docs.aws.amazon.com/lambda/latest/dg/lambda-invocation.html
#   - Invoke API: https://docs.aws.amazon.com/lambda/latest/api/API_Invoke.html
#   - 同期呼び出し: https://docs.aws.amazon.com/lambda/latest/dg/invocation-sync.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_invocation" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # 呼び出すLambda関数の名前
  # 完全な関数名またはARNを指定します
  function_name = "data_processor"

  # Lambda関数に渡すJSONペイロード
  # jsonencode()を使用してTerraformオブジェクトをJSON文字列に変換できます
  # 最大ペイロードサイズ: 同期呼び出しの場合6MB
  input = jsonencode({
    operation = "initialize"
    config = {
      environment = "production"
      debug       = false
    }
  })

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # リソースのライフサイクルスコープ
  # CREATE_ONLY: リソース作成または置換時のみ関数を呼び出す（デフォルト）
  # CRUD: 各ライフサイクルイベント（作成、更新、削除）で関数を呼び出す
  #       CRUDモードではinput JSONにライフサイクル情報が追加されます
  # lifecycle_scope = "CREATE_ONLY"

  # Lambda関数のクオリファイア（バージョンまたはエイリアス）
  # 特定のバージョンやエイリアスを指定して呼び出すことができます
  # デフォルトは$LATEST（最新の未発行バージョン）
  # qualifier = "$LATEST"

  # このリソースを管理するAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用されます
  # マルチリージョン構成で明示的に指定する場合に使用
  # region = "us-east-1"

  # 指定したテナントから呼び出しを提供するためのテナントID
  # マルチテナント環境で使用します
  # tenant_id = "tenant-123"

  # input JSONペイロード内でライフサイクル情報を格納するキー名
  # デフォルトは"tf"
  # lifecycle_scope = "CRUD"の場合のみ有効
  # terraform_key = "tf"

  # 変更時に再呼び出しをトリガーするための任意のキーと値のマップ
  # このマップ内の値が変更されると、Lambda関数が再度呼び出されます
  # キー/値を変更せずに強制的に再実行するには`terraform taint`コマンドを使用
  # triggers = {
  #   function_version = aws_lambda_function.example.version
  #   config_hash      = sha256(jsonencode(var.config))
  #   timestamp        = timestamp()
  # }

  # リソースID（オプション）
  # 通常は自動生成されますが、明示的に指定することも可能
  # id = "custom-invocation-id"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能です（computed）:
#
# - result (string)
#   Lambda関数呼び出しの結果文字列
#   関数がJSONを返す場合はjsondecode()で解析できます
#   例: jsondecode(aws_lambda_invocation.example.result)["status"]
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: 基本的な呼び出し
# resource "aws_lambda_invocation" "basic" {
#   function_name = aws_lambda_function.example.function_name
#
#   input = jsonencode({
#     operation = "initialize"
#   })
# }

# 例2: triggersを使用した動的呼び出し
# resource "aws_lambda_invocation" "dynamic" {
#   function_name = aws_lambda_function.example.function_name
#
#   triggers = {
#     function_version = aws_lambda_function.example.version
#     config_hash      = sha256(jsonencode(var.environment))
#   }
#
#   input = jsonencode({
#     operation   = "process_data"
#     environment = var.environment
#   })
# }

# 例3: CRUDライフサイクル管理
# resource "aws_lambda_invocation" "crud" {
#   function_name   = aws_lambda_function.example.function_name
#   lifecycle_scope = "CRUD"
#
#   input = jsonencode({
#     resource_name = "database_setup"
#     database_url  = aws_db_instance.example.endpoint
#   })
# }

# 例4: 結果の出力
# output "invocation_result" {
#   value = jsondecode(aws_lambda_invocation.example.result)
# }
