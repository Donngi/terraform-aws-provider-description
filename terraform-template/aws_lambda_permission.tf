#---------------------------------------------------------------
# AWS Lambda Permission
#---------------------------------------------------------------
#
# Lambda関数のリソースベースポリシーにパーミッションステートメントを追加するリソースです。
# 外部のAWSサービスやアカウントが指定のLambda関数を呼び出すことを許可します。
#
# 主なユースケース:
#   - API Gatewayからのトリガー許可
#   - S3イベント通知からの呼び出し許可
#   - SNSサブスクリプションからの呼び出し許可
#   - CloudWatch Events / EventBridgeルールからの呼び出し許可
#   - ALBターゲットグループからの呼び出し許可
#   - Lambda Function URLの呼び出し許可
#
# 重要な注意事項:
#   - statement_id と statement_id_prefix は同時に指定できません
#   - source_arn または source_account を指定することで Confused Deputy 攻撃を防げます
#   - function_url_auth_type を設定する場合は invoked_via_function_url = true が必要です
#
# AWS公式ドキュメント:
#   - Lambda リソースベースポリシー: https://docs.aws.amazon.com/lambda/latest/dg/access-control-resource-based.html
#   - Lambda の権限: https://docs.aws.amazon.com/lambda/latest/dg/lambda-permissions.html
#   - Confused Deputy 問題: https://docs.aws.amazon.com/IAM/latest/UserGuide/confused-deputy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lambda_permission
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_permission" "example" {
  #---------------------------------------------------------------
  # 必須設定
  #---------------------------------------------------------------

  # action (Required)
  # 設定内容: 許可するLambda APIアクション（権限）を指定します。
  # 設定可能な値: "lambda:InvokeFunction"（最も一般的）、"lambda:GetFunction" など
  # 省略時: 省略不可
  #
  # 主な値:
  #   - "lambda:InvokeFunction": 関数の呼び出しを許可（最も一般的）
  #   - "lambda:InvokeFunctionUrl": Function URLを通じた呼び出しを許可
  action = "lambda:InvokeFunction"

  # function_name (Required)
  # 設定内容: パーミッションを追加するLambda関数の名前またはARNを指定します。
  # 設定可能な値: 関数名（例: "my-function"）、関数ARN、またはエイリアスARN
  # 省略時: 省略不可
  function_name = aws_lambda_function.example.function_name

  # principal (Required)
  # 設定内容: 関数の呼び出しを許可するAWSサービスまたはアカウントのプリンシパルを指定します。
  # 設定可能な値: AWSサービスドメイン（例: "apigateway.amazonaws.com"）または AWSアカウントID
  # 省略時: 省略不可
  #
  # 主なプリンシパル例:
  #   - "apigateway.amazonaws.com"      : API Gateway
  #   - "s3.amazonaws.com"              : S3 イベント通知
  #   - "sns.amazonaws.com"             : SNS
  #   - "events.amazonaws.com"          : CloudWatch Events / EventBridge
  #   - "elasticloadbalancing.amazonaws.com" : ALB
  #   - "lambda.amazonaws.com"          : Lambda（他のLambda関数）
  #   - "123456789012"                  : 特定のAWSアカウント
  principal = "apigateway.amazonaws.com"

  #---------------------------------------------------------------
  # ステートメントID設定
  #---------------------------------------------------------------

  # statement_id (Optional)
  # 設定内容: ポリシードキュメント内のステートメントを識別する一意のIDを指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  # 省略時: statement_id_prefix が未指定の場合、Terraformが一意のIDを自動生成します
  #
  # 注意: statement_id_prefix と同時に指定できません。どちらか一方のみ使用してください。
  statement_id = "AllowExecutionFromAPIGateway"

  # statement_id_prefix (Optional)
  # 設定内容: ステートメントIDのプレフィックスを指定します。Terraformが一意のサフィックスを付与します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  # 省略時: statement_id を使用
  #
  # 注意: statement_id と同時に指定できません。複数の同種パーミッションを作成する場合に便利です。
  statement_id_prefix = null

  #---------------------------------------------------------------
  # ソース制限設定（Confused Deputy 対策）
  #---------------------------------------------------------------

  # source_arn (Optional)
  # 設定内容: 呼び出しを許可するソースリソースのARNを指定します。
  # 設定可能な値: ARN文字列。ワイルドカード (*) も使用可能
  # 省略時: ソースARNによる制限なし
  #
  # セキュリティ推奨:
  #   - Confused Deputy 攻撃を防ぐため、source_arn または source_account の指定を強く推奨します
  #   - 例: "arn:aws:execute-api:ap-northeast-1:123456789012:abc123def/*"
  source_arn = null # aws_api_gateway_rest_api.example.execution_arn

  # source_account (Optional)
  # 設定内容: 呼び出しを許可するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID文字列
  # 省略時: ソースアカウントによる制限なし
  #
  # 用途:
  #   - S3などのサービスでは source_arn に加えて source_account を指定することを推奨します
  #   - 組織内の特定アカウントからの呼び出しのみを許可する場合に使用します
  source_account = null # "123456789012"

  #---------------------------------------------------------------
  # 組織・プリンシパル設定
  #---------------------------------------------------------------

  # principal_org_id (Optional)
  # 設定内容: 呼び出しを許可するAWS Organizationsの組織IDを指定します。
  # 設定可能な値: Organizationsの組織ID（例: "o-xxxxxxxxxxxx"）
  # 省略時: 組織IDによる制限なし
  #
  # 用途: 特定のAWS Organizations内の全アカウントからの呼び出しを許可する場合に使用します
  #   この場合、principal には "arn:aws:iam::*:root" などのワイルドカードを使用します
  principal_org_id = null # "o-xxxxxxxxxxxx"

  #---------------------------------------------------------------
  # 関数バージョン・エイリアス設定
  #---------------------------------------------------------------

  # qualifier (Optional)
  # 設定内容: パーミッションを適用するLambda関数のバージョンまたはエイリアスを指定します。
  # 設定可能な値: バージョン番号（例: "1"）、エイリアス名（例: "production"）、または "$LATEST"
  # 省略時: 関数全体（全バージョン・エイリアス）に適用
  #
  # 用途:
  #   - 特定のバージョンのみにパーミッションを付与したい場合
  #   - エイリアスを使ったトラフィック分散時に特定エイリアスに制限したい場合
  qualifier = null # "production"

  #---------------------------------------------------------------
  # Function URL設定
  #---------------------------------------------------------------

  # function_url_auth_type (Optional)
  # 設定内容: Lambda Function URLの認証タイプを指定します。
  # 設定可能な値: "NONE"（認証なし）、"AWS_IAM"（IAM認証）
  # 省略時: Function URLの設定なし
  #
  # 注意: この属性を使用する場合は invoked_via_function_url = true も必須です
  #   - "NONE": パブリックなFunction URLへのアクセスを許可
  #   - "AWS_IAM": IAM認証が必要なFunction URLへのアクセスを許可
  function_url_auth_type = null # "NONE"

  # invoked_via_function_url (Optional)
  # 設定内容: Lambda Function URLを通じた呼び出しかどうかを指定します。
  # 設定可能な値: true / false
  # 省略時: false（Function URL経由の呼び出しではない）
  #
  # 注意: function_url_auth_type を設定する場合は true を指定する必要があります
  invoked_via_function_url = null # true

  #---------------------------------------------------------------
  # Alexa設定
  #---------------------------------------------------------------

  # event_source_token (Optional)
  # 設定内容: Alexa Skills Kitからの呼び出しに使用するトークンを指定します。
  # 設定可能な値: 任意の文字列トークン
  # 省略時: トークンによる制限なし
  #
  # 用途: Alexa Skills Kitと連携する場合に使用します
  #   principal = "alexa-appkit.amazon.com" と組み合わせて使用します
  event_source_token = null # "AlexaSkillsKitTokenHere"

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンを使用
  region = null # "ap-northeast-1"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id
#     ステートメントID（statement_id の値）
#
