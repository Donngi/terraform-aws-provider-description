#---------------------------------------------------------------
# Lambda Function Recursion Config
#---------------------------------------------------------------
#
# Manages an AWS Lambda Function Recursion Config. Use this resource to control
# how Lambda handles recursive function invocations to prevent infinite loops.
#
# Recursive loops occur when a Lambda function writes an event to the same AWS
# service or resource that invokes it, creating an infinite loop. Lambda uses
# AWS X-Ray tracing headers to detect recursive loops and tracks the number of
# times an event has invoked a function. When a function is invoked approximately
# 16 times in the same chain of requests, Lambda stops the next invocation and
# notifies the account owner.
#
# AWS公式ドキュメント:
#   - Use Lambda recursive loop detection to prevent infinite loops: https://docs.aws.amazon.com/lambda/latest/dg/invocation-recursion.html
#   - PutFunctionRecursionConfig API: https://docs.aws.amazon.com/lambda/latest/api/API_PutFunctionRecursionConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_recursion_config
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_function_recursion_config" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # (Required) Name of the Lambda function.
  # Lambda関数の名前を指定します。この設定は、指定したLambda関数の
  # 再帰ループ検出動作を制御します。
  #
  # Type: string
  # Example: "my-function" or aws_lambda_function.example.function_name
  function_name = "my-function"

  # (Required) Lambda function recursion configuration.
  # Lambda関数の再帰ループ検出設定を指定します。
  #
  # Valid values:
  #   - "Allow": Lambda detects recursive loops but does not take any action.
  #              意図的な再帰処理を実装する場合に使用します。
  #   - "Terminate": Lambda detects and stops recursive loops automatically.
  #                  デフォルトの動作で、無限ループを防ぎます。
  #
  # Lambda detects recursion by tracking X-Ray tracing headers and counts the
  # number of times an event has invoked a function. When approximately 16
  # invocations occur in the same chain, Lambda stops the next invocation.
  #
  # When Lambda stops a recursive loop (Terminate mode):
  #   - Sends notifications via AWS Health Dashboard
  #   - Sends email notifications to account owner
  #   - Publishes CloudWatch metrics
  #   - Throws RecursiveInvocationException to the caller
  #
  # Supported services for recursion detection:
  #   - Amazon SQS
  #   - Amazon S3
  #   - Amazon SNS
  #   - Lambda functions (direct invocation)
  #
  # Type: string
  # Default: "Terminate" (on resource destruction)
  recursive_loop = "Terminate"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # (Optional) Region where this resource will be managed.
  # このリソースを管理するAWSリージョンを指定します。
  # 未指定の場合、プロバイダー設定のリージョンが使用されます。
  #
  # Type: string
  # Default: Provider configuration region
  # Example: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - function_name: Lambda関数の名前
# - recursive_loop: 現在の再帰ループ検出設定 ("Allow" or "Terminate")
# - region: リソースが管理されているリージョン
#
#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# Existing recursion configs can be imported using the function name:
#
# $ terraform import aws_lambda_function_recursion_config.example my-function
#
#---------------------------------------------------------------
# Important Notes
#---------------------------------------------------------------
#
# 1. Default Behavior:
#    - Destruction of this resource returns the recursive_loop configuration
#      back to the default value of "Terminate"
#
# 2. Minimum SDK Versions Required:
#    Recursive loop detection requires the following AWS SDK versions:
#    - Node.js: 2.1147.0
#    - Python (boto3): 1.24.46 / (botocore): 1.27.46
#    - Java 8/11/17/21: 2.17.135
#    - .NET: 3.7.293.0
#    - Ruby: 3.134.0
#    - PHP: 3.232.0
#    - Go (V2 SDK): 1.57.0
#
# 3. Regional Availability:
#    Recursive loop detection is supported in all commercial regions except:
#    - Mexico (Central)
#    - Asia Pacific (New Zealand)
#
# 4. When Lambda Stops a Loop:
#    Lambda sends notifications and stops the function after approximately
#    16 invocations in the same chain. To prevent reoccurrence:
#    - Reduce function concurrency
#    - Remove or disable triggers
#    - Identify and fix code defects
#    - Configure dead-letter queues (for SQS event sources)
#    - Add on-failure destinations (for SNS event sources)
#
# 5. Use Cases:
#    - Use "Terminate" (default) for production safety
#    - Use "Allow" only for intentional recursive designs
#
#---------------------------------------------------------------
