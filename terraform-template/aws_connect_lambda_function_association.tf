################################################################################
# Terraform Template: aws_connect_lambda_function_association
################################################################################
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# 注意事項:
# - このテンプレートは生成時点（2026-01-19）の情報に基づいています
# - 最新の仕様や利用可能なオプションについては、必ず公式ドキュメントをご確認ください
# - AWS Provider公式ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_lambda_function_association
################################################################################

################################################################################
# リソース概要
################################################################################
# Amazon Connect Lambda Function Associationを作成・管理します。
#
# このリソースは、Amazon ConnectインスタンスとAWS Lambda関数の関連付けを定義します。
# 関連付けることで、Connectフロー内でLambda関数を呼び出し、顧客データの取得や
# 外部システムとの連携などを実現できます。
#
# 参考資料:
# - Amazon Connect: Getting Started
#   https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html
# - Invoke AWS Lambda functions
#   https://docs.aws.amazon.com/connect/latest/adminguide/connect-lambda-functions.html
# - Flow block: AWS Lambda function
#   https://docs.aws.amazon.com/connect/latest/adminguide/invoke-lambda-function-block.html
################################################################################

resource "aws_connect_lambda_function_association" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # function_arn - Lambda関数のARN（必須）
  # Amazon Resource Name (ARN) of the Lambda Function.
  #
  # 重要: バージョンやエイリアス修飾子を含めないでください。
  # 例: arn:aws:lambda:us-west-2:123456789012:function:my-function
  #
  # この関数は、Connectフロー内で呼び出され、顧客情報の取得、データの検証、
  # 外部システムとの連携などに使用されます。
  #
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/connect-lambda-functions.html
  function_arn = "arn:aws:lambda:us-west-2:123456789012:function:my-connect-function"

  # instance_id - Amazon ConnectインスタンスID（必須）
  # The identifier of the Amazon Connect instance.
  #
  # ConnectインスタンスのARNからインスタンスIDを取得できます。
  # 例: ARNが arn:aws:connect:us-west-2:123456789012:instance/12345678-1234-1234-1234-123456789012
  # の場合、instance_idは "12345678-1234-1234-1234-123456789012" です。
  #
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html
  instance_id = "12345678-1234-1234-1234-123456789012"

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # id - リソース識別子（オプション、計算値）
  # The Amazon Connect instance ID and Lambda Function ARN separated by a comma.
  #
  # 形式: <instance_id>,<function_arn>
  # 通常、このパラメータは自動的に計算されるため、明示的に設定する必要はありません。
  # Terraform importコマンドを使用する際に、この形式でリソースを特定します。
  #
  # 例: 12345678-1234-1234-1234-123456789012,arn:aws:lambda:us-west-2:123456789012:function:my-function
  # id = "12345678-1234-1234-1234-123456789012,arn:aws:lambda:us-west-2:123456789012:function:my-function"

  # region - リソース管理リージョン（オプション、計算値）
  # Region where this resource will be managed.
  #
  # このパラメータを省略した場合、プロバイダー設定で指定されたリージョンが使用されます。
  # 特定のリージョンでリソースを明示的に管理したい場合に設定します。
  #
  # 参考:
  # - リージョンとエンドポイント
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - AWS Provider設定リファレンス
  #   https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  # region = "us-west-2"
}

################################################################################
# 使用例とベストプラクティス
################################################################################
# 1. Lambda関数のアクセス許可
#    Lambda関数には、Amazon Connectからの呼び出しを許可するリソースベースの
#    ポリシーが必要です。aws_lambda_permissionリソースを使用して設定します:
#
#    resource "aws_lambda_permission" "allow_connect" {
#      statement_id  = "AllowExecutionFromConnect"
#      action        = "lambda:InvokeFunction"
#      function_name = aws_lambda_function.example.function_name
#      principal     = "connect.amazonaws.com"
#      source_arn    = aws_connect_instance.example.arn
#    }
#
# 2. Lambda関数の応答形式
#    Lambda関数は、Connectフローで使用できる形式で応答を返す必要があります。
#    詳細は以下のドキュメントを参照してください:
#    https://docs.aws.amazon.com/connect/latest/adminguide/connect-lambda-functions.html
#
# 3. タイムアウト設定
#    Lambda関数のタイムアウトは、Connectフローのタイムアウト設定（最大8秒）
#    よりも短く設定することを推奨します。
#
# 4. インポート
#    既存のリソースをインポートする場合:
#    terraform import aws_connect_lambda_function_association.example <instance_id>,<function_arn>
#
# 参考資料:
# - Sample Lambda integration flow
#   https://docs.aws.amazon.com/connect/latest/adminguide/sample-lambda-integration.html
# - InvokeLambdaFunction API
#   https://docs.aws.amazon.com/connect/latest/APIReference/interactions-invokelambdafunction.html
################################################################################
