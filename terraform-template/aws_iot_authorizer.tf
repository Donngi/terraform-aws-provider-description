#---------------------------------------------------------------
# AWS IoT Authorizer
#---------------------------------------------------------------
#
# AWS IoT Authorizerは、AWS IoT Coreへの接続時にカスタム認証・認可ロジックを
# 実装するためのリソースです。Lambda関数を使用してデバイスの認証を行い、
# きめ細かいアクセス制御を実現します。
#
# AWS公式ドキュメント:
#   - Custom Authentication Workflow: https://docs.aws.amazon.com/iot/latest/developerguide/custom-authorizer.html
#   - Creating and Managing Custom Authorizers: https://docs.aws.amazon.com/iot/latest/developerguide/config-custom-auth.html
#   - API Reference: https://docs.aws.amazon.com/iot/latest/apireference/API_AuthorizerDescription.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_authorizer
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_authorizer" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # (Required) Authorizerの名前
  # - 1〜128文字の英数字、アンダースコア、ハイフン、等号、カンマ、アットマークが使用可能
  # - パターン: [\\w=,@-]+
  # - AWS IoT Core内で一意である必要があります
  name = "example-authorizer"

  # (Required) 認証・認可ロジックを実装するLambda関数のARN
  # - このLambda関数はAWS IoT Coreから呼び出され、接続の認証と許可を判断します
  # - Lambda関数のタイムアウト制限は5秒です
  # - Lambda関数の実行回数と実行時間に基づいてAWS IoT Coreから課金されます
  # - AWS IoTにLambda関数の呼び出し権限を付与する必要があります
  #   (lambda:InvokeFunction permission)
  authorizer_function_arn = aws_lambda_function.example.arn

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # (Optional) HTTPキャッシングの有効化
  # - trueに設定すると、Lambda関数の結果がrefreshAfterInSecondsで指定された
  #   時間キャッシュされます
  # - デフォルト: false
  # - キャッシュを有効化することでLambda関数の呼び出し回数を削減できます
  enable_caching_for_http = false

  # (Optional) Authorizerのステータス
  # - 有効な値: "ACTIVE" または "INACTIVE"
  # - "ACTIVE": Authorizerが有効で、認証リクエストを処理します
  # - "INACTIVE": Authorizerが無効で、認証リクエストを処理しません
  # - デフォルト: "ACTIVE"
  status = "ACTIVE"

  # (Optional) トークン署名の検証を無効化
  # - trueに設定すると、AWS IoTは認証リクエストのトークン署名を検証しません
  # - デフォルト: false (署名検証が有効)
  # - 署名を有効にすることで、認識されていないクライアントによる
  #   Lambda関数の過度な呼び出しを防ぐことができます
  # - AWS Config規則 "iot-authorizer-token-signing-enabled" では、
  #   この値がtrueの場合、非準拠と判定されます
  signing_disabled = false

  # (Optional) HTTPヘッダーからトークンを抽出するためのキー名
  # - 1〜128文字の英数字、アンダースコア、ハイフンが使用可能
  # - パターン: [a-zA-Z0-9_-]+
  # - signing_disabledがfalseの場合、この値は必須です
  # - カスタム認証サービスから返されるトークンを抽出するために使用されます
  token_key_name = "Token-Header"

  # (Optional) トークン署名の検証に使用する公開鍵のマップ
  # - キー: 公開鍵の識別子 (パターン: [a-zA-Z0-9:_-]+)
  # - 値: PEM形式の公開鍵文字列 (最大5120文字)
  # - signing_disabledがfalseの場合、この値は必須です
  # - カスタム認証サービスから返されるデジタル署名を検証するために使用されます
  # - 機密情報として扱われます
  token_signing_public_keys = {
    Key1 = file("path/to/iot-authorizer-signing-key.pem")
  }

  # (Optional) リソースに割り当てるタグのマップ
  # - プロバイダーのdefault_tags設定ブロックで定義されたタグとマージされます
  # - 一致するキーを持つタグは、プロバイダーレベルで定義されたタグを上書きします
  tags = {
    Name        = "example-authorizer"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # (Optional) このリソースが管理されるAWSリージョン
  # - 指定しない場合、プロバイダー設定で設定されたリージョンがデフォルトで使用されます
  # - リージョン固有のエンドポイントについては、AWS公式ドキュメントを参照してください
  # region = "us-east-1"

  # (Optional) リソースの一意の識別子
  # - 通常は指定不要（Terraformが自動的に管理）
  # - インポート時やカスタムIDを使用する場合に指定します
  # id = "custom-id"

  # (Optional) プロバイダーのdefault_tagsを含む、リソースに割り当てられた
  # 全てのタグのマップ
  # - このフィールドは通常computed属性として自動的に設定されます
  # - 明示的に指定することも可能ですが、通常は不要です
  # tags_all = {}
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed-only）:
#
# - arn (string)
#   - Authorizerの Amazon Resource Name (ARN)
#   - 最大2048文字
#   - 他のリソースからAuthorizerを参照する際に使用します
#   - 例: aws_iot_authorizer.example.arn
#
# 以下の属性は入力と出力の両方で使用可能です（optional + computed）:
#
# - id (string)
#   - リソースの一意の識別子
#   - Terraformによって自動的に管理されます
#
# - region (string)
#   - このリソースが管理されるAWSリージョン
#   - 指定しない場合、プロバイダー設定のリージョンが使用されます
#
# - tags_all (map of string)
#   - プロバイダーのdefault_tagsを含む、全てのタグのマップ
#   - tagsとdefault_tagsがマージされた結果が格納されます
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: Lambda関数との統合
#---------------------------------------------------------------
# resource "aws_lambda_function" "example" {
#   filename      = "authorizer.zip"
#   function_name = "iot-authorizer-function"
#   role          = aws_iam_role.lambda_execution_role.arn
#   handler       = "index.handler"
#   runtime       = "python3.11"
#   timeout       = 5
# }
#
# resource "aws_lambda_permission" "allow_iot" {
#   statement_id  = "AllowExecutionFromIoT"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.example.function_name
#   principal     = "iot.amazonaws.com"
#   source_arn    = aws_iot_authorizer.example.arn
# }
#---------------------------------------------------------------
