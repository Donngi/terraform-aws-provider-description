# ====================================================================================================
# Terraform AWS Provider Resource: aws_api_gateway_deployment
# Provider Version: 6.28.0
# Last Updated: 2026-01-22
# ====================================================================================================
#
# リソース概要:
# API Gateway REST APIデプロイメントを管理します。デプロイメントはREST API設定のスナップショットです。
# デプロイメント後、aws_api_gateway_stageリソースを通じて呼び出し可能なエンドポイントとして公開できます。
#
# 重要な注意事項:
# - REST API設定の全ての変更を適切にキャプチャするため、このリソースは全ての関連Terraformリソース
#   (リソース/パス、メソッド、統合など)に依存関係を持つ必要があります
# - OpenAPI仕様でAPIを設定する場合、特別な依存関係設定は不要です(rest_api.idの参照のみでOK)
# - Terraformリソースで設定する場合、triggersまたはdepends_onで依存関係を明示する必要があります
# - triggersの使用が推奨されます(設定変更時に自動的に再デプロイされます)
# - lifecycle { create_before_destroy = true } の設定が強く推奨されます
#   (これがないと、再作成時に "Active stages pointing to this deployment must be moved or deleted"
#    エラーが発生する可能性があります)
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-deploy-api.html
#
# Terraform公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment
# ====================================================================================================

# ====================================================================================================
# 例1: OpenAPI仕様を使用したデプロイメント
# ====================================================================================================
# OpenAPI仕様でAPIを定義する場合の推奨パターンです。
# bodyの変更を検出して自動的に再デプロイします。
# ====================================================================================================

resource "aws_api_gateway_rest_api" "openapi_example" {
  # OpenAPI仕様をJSONエンコードして設定
  # bodyの内容が変更されると、自動的にAPIが更新されます
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "example-api"
      version = "1.0"
    }
    paths = {
      "/path1" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
          }
        }
      }
    }
  })

  name = "example-openapi-api"
}

resource "aws_api_gateway_deployment" "openapi_example" {
  # ====================================================================================================
  # 必須パラメータ
  # ====================================================================================================

  # rest_api_id (Required: string)
  # デプロイ対象のREST APIのID
  # AWS公式ドキュメント: https://docs.aws.amazon.com/apigateway/latest/api/API_CreateDeployment.html#API_CreateDeployment_RequestSyntax
  rest_api_id = aws_api_gateway_rest_api.openapi_example.id

  # ====================================================================================================
  # オプションパラメータ
  # ====================================================================================================

  # description (Optional: string)
  # デプロイメントの説明
  # このデプロイメントの目的や変更内容を記述します
  # AWS公式ドキュメント: https://docs.aws.amazon.com/apigateway/latest/api/API_CreateDeployment.html#API_CreateDeployment_RequestSyntax
  description = "Deployment for OpenAPI-based REST API"

  # triggers (Optional: map(string))
  # 変更時に再デプロイをトリガーする任意のキーと値のマップ
  # OpenAPI仕様の場合、bodyのハッシュ値を使用するのが推奨パターンです
  # これにより、API定義の変更が自動的に検出され、再デプロイが実行されます
  # AWS公式ドキュメント: https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-deploy-api.html
  triggers = {
    # sha1でbodyのハッシュ値を計算し、変更を検出
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.openapi_example.body))
  }

  # variables (Optional: map(string))
  # 関連するステージに設定する変数のマップ
  # ステージ変数は、統合エンドポイントやLambda関数のエイリアスなどを動的に参照する際に使用します
  # 注意: この設定は非推奨です。代わりにaws_api_gateway_stageリソースのvariablesを使用してください
  # AWS公式ドキュメント: https://docs.aws.amazon.com/apigateway/latest/developerguide/stage-variables.html
  # variables = {
  #   "environment" = "production"
  # }

  # region (Optional: string)
  # このリソースが管理されるリージョン
  # デフォルトではプロバイダー設定のリージョンが使用されます
  # マルチリージョン構成の場合のみ明示的に指定します
  # AWS公式ドキュメント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ====================================================================================================
  # ライフサイクル設定
  # ====================================================================================================

  lifecycle {
    # create_before_destroy (Required for safe redeployment)
    # 再デプロイ時に新しいデプロイメントを先に作成してから古いものを削除します
    # これを設定しないと、アクティブなステージが参照しているデプロイメントの削除時にエラーが発生します
    # Terraform公式ドキュメント: https://www.terraform.io/language/meta-arguments/lifecycle#create_before_destroy
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "openapi_example" {
  # デプロイメントID
  # デプロイメントとステージは1対多の関係です
  deployment_id = aws_api_gateway_deployment.openapi_example.id

  # REST API ID
  rest_api_id   = aws_api_gateway_rest_api.openapi_example.id

  # ステージ名
  # URLパスの一部として使用されます: https://api-id.execute-api.region.amazonaws.com/stage-name/
  stage_name    = "production"
}

# ====================================================================================================
# 例2: Terraformリソースを使用したデプロイメント
# ====================================================================================================
# aws_api_gateway_resource、aws_api_gateway_method、aws_api_gateway_integrationなどの
# Terraformリソースを組み合わせてAPIを構築する場合のパターンです。
# triggersで依存関係を明示的に宣言することで、リソース変更時の自動再デプロイを実現します。
# ====================================================================================================

resource "aws_api_gateway_rest_api" "terraform_example" {
  name = "example-terraform-api"
}

resource "aws_api_gateway_resource" "terraform_example" {
  # 親リソースID(ルートリソースIDを指定)
  parent_id   = aws_api_gateway_rest_api.terraform_example.root_resource_id

  # パス部分(/exampleとなる)
  path_part   = "example"

  # REST API ID
  rest_api_id = aws_api_gateway_rest_api.terraform_example.id
}

resource "aws_api_gateway_method" "terraform_example" {
  # 認証タイプ(NONE, AWS_IAM, CUSTOM, COGNITO_USER_POOLSなど)
  authorization = "NONE"

  # HTTPメソッド(GET, POST, PUT, DELETEなど)
  http_method   = "GET"

  # リソースID
  resource_id   = aws_api_gateway_resource.terraform_example.id

  # REST API ID
  rest_api_id   = aws_api_gateway_rest_api.terraform_example.id
}

resource "aws_api_gateway_integration" "terraform_example" {
  # HTTPメソッド
  http_method = aws_api_gateway_method.terraform_example.http_method

  # リソースID
  resource_id = aws_api_gateway_resource.terraform_example.id

  # REST API ID
  rest_api_id = aws_api_gateway_rest_api.terraform_example.id

  # 統合タイプ(MOCK, HTTP, HTTP_PROXY, AWS, AWS_PROXYなど)
  # MOCKは開発・テスト用のモック統合です
  type        = "MOCK"
}

resource "aws_api_gateway_deployment" "terraform_example" {
  # REST API ID
  rest_api_id = aws_api_gateway_rest_api.terraform_example.id

  # デプロイメントの説明
  description = "Deployment for Terraform-based REST API"

  # triggers (重要)
  # TerraformリソースでAPIを構築する場合、triggersで依存関係を明示的に宣言します
  # 依存するリソースのIDを配列にしてハッシュ化することで、変更検出を実現します
  #
  # 注意事項:
  # - この設定は依存関係の順序は満たしますが、将来の全てのAPI変更を検出するわけではありません
  # - より高度なパターンとして、filesha1()関数でTerraformファイル自体のハッシュを計算する方法があります
  # - リソース全体をハッシュ化することも可能ですが、初回実装後に差分が表示されます
  #   (その後は実際の変更時のみ差分が表示されるようになります)
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.terraform_example.id,
      aws_api_gateway_method.terraform_example.id,
      aws_api_gateway_integration.terraform_example.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "terraform_example" {
  deployment_id = aws_api_gateway_deployment.terraform_example.id
  rest_api_id   = aws_api_gateway_rest_api.terraform_example.id
  stage_name    = "development"
}

# ====================================================================================================
# 例3: 複雑なAPI構成のデプロイメント(複数メソッド、統合、レスポンス)
# ====================================================================================================
# より複雑なAPI構成で、複数のリソース、メソッド、統合、レスポンスを含む場合の例です。
# すべての依存リソースをtriggersに含めることで、包括的な変更検出を実現します。
# ====================================================================================================

resource "aws_api_gateway_rest_api" "complex_example" {
  name = "complex-api"
}

resource "aws_api_gateway_resource" "users" {
  parent_id   = aws_api_gateway_rest_api.complex_example.root_resource_id
  path_part   = "users"
  rest_api_id = aws_api_gateway_rest_api.complex_example.id
}

resource "aws_api_gateway_resource" "user_id" {
  parent_id   = aws_api_gateway_resource.users.id
  path_part   = "{userId}"
  rest_api_id = aws_api_gateway_rest_api.complex_example.id
}

# GETメソッド
resource "aws_api_gateway_method" "get_user" {
  authorization = "AWS_IAM"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.user_id.id
  rest_api_id   = aws_api_gateway_rest_api.complex_example.id

  request_parameters = {
    "method.request.path.userId" = true
  }
}

resource "aws_api_gateway_integration" "get_user" {
  http_method             = aws_api_gateway_method.get_user.http_method
  resource_id             = aws_api_gateway_resource.user_id.id
  rest_api_id             = aws_api_gateway_rest_api.complex_example.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:123456789012:function:GetUser/invocations"
}

# POSTメソッド
resource "aws_api_gateway_method" "create_user" {
  authorization = "AWS_IAM"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.users.id
  rest_api_id   = aws_api_gateway_rest_api.complex_example.id
}

resource "aws_api_gateway_integration" "create_user" {
  http_method             = aws_api_gateway_method.create_user.http_method
  resource_id             = aws_api_gateway_resource.users.id
  rest_api_id             = aws_api_gateway_rest_api.complex_example.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:123456789012:function:CreateUser/invocations"
}

resource "aws_api_gateway_deployment" "complex_example" {
  rest_api_id = aws_api_gateway_rest_api.complex_example.id
  description = "Deployment for complex API with multiple resources and methods"

  # 全ての依存リソースをtriggersに含める
  # これにより、いずれかのリソースが変更された場合に自動的に再デプロイされます
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.users.id,
      aws_api_gateway_resource.user_id.id,
      aws_api_gateway_method.get_user.id,
      aws_api_gateway_integration.get_user.id,
      aws_api_gateway_method.create_user.id,
      aws_api_gateway_integration.create_user.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "complex_example" {
  deployment_id = aws_api_gateway_deployment.complex_example.id
  rest_api_id   = aws_api_gateway_rest_api.complex_example.id
  stage_name    = "v1"

  # ステージレベルの変数設定(推奨)
  variables = {
    "lambdaAlias" = "PROD"
    "environment" = "production"
  }
}

# ====================================================================================================
# 出力値(Attributes)
# ====================================================================================================
# デプロイメント作成後に取得できる属性値です。
# ====================================================================================================

output "deployment_id" {
  # id (Computed: string)
  # デプロイメントのID
  # ステージリソースなどで参照する際に使用します
  description = "Deployment ID"
  value       = aws_api_gateway_deployment.openapi_example.id
}

output "created_date" {
  # created_date (Computed: string)
  # デプロイメントの作成日時
  # RFC3339形式のタイムスタンプです
  description = "Deployment creation date"
  value       = aws_api_gateway_deployment.openapi_example.created_date
}

# ====================================================================================================
# ベストプラクティスと推奨事項
# ====================================================================================================
#
# 1. triggersの使用
#    - triggersを使用して依存リソースの変更を検出します
#    - depends_onよりもtriggersが推奨されます(変更検出と再デプロイの自動化)
#
# 2. lifecycle設定
#    - 必ず create_before_destroy = true を設定してください
#    - これにより、再デプロイ時のエラーを防止できます
#
# 3. デプロイメントの説明
#    - descriptionに変更内容や目的を記述することで、デプロイ履歴の追跡が容易になります
#
# 4. ステージ変数
#    - variablesパラメータではなく、aws_api_gateway_stageリソースのvariablesを使用してください
#
# 5. 依存関係の管理
#    - OpenAPI仕様: bodyのハッシュ値をtriggersに設定
#    - Terraformリソース: 全ての関連リソースIDをtriggersに含める
#
# 6. 再デプロイの強制実行
#    - triggersの値を変更せずに再デプロイが必要な場合:
#      terraform plan -replace="aws_api_gateway_deployment.example"
#      terraform apply -replace="aws_api_gateway_deployment.example"
#
# 7. マルチリージョン展開
#    - 必要に応じてregionパラメータを使用して明示的にリージョンを指定します
#
# 8. デプロイメント戦略
#    - Blue/Greenデプロイメント: ステージとデプロイメントを組み合わせて実現
#    - Canaryリリース: aws_api_gateway_stageのcanary_settingsを使用
#
# ====================================================================================================
# 関連リソース
# ====================================================================================================
#
# - aws_api_gateway_rest_api: REST APIの定義
# - aws_api_gateway_stage: デプロイメントを公開するステージ
# - aws_api_gateway_resource: APIリソース(パス)の定義
# - aws_api_gateway_method: HTTPメソッドの定義
# - aws_api_gateway_integration: バックエンド統合の設定
# - aws_api_gateway_method_response: メソッドレスポンスの設定
# - aws_api_gateway_integration_response: 統合レスポンスの設定
# - aws_api_gateway_base_path_mapping: カスタムドメインへのマッピング
# - aws_api_gateway_domain_name: カスタムドメインの設定
# - aws_api_method_settings: ステージレベルのメソッド設定
#
# ====================================================================================================
# トラブルシューティング
# ====================================================================================================
#
# 問題: "Active stages pointing to this deployment must be moved or deleted"
# 解決策: lifecycle { create_before_destroy = true } を設定してください
#
# 問題: API変更が反映されない
# 解決策: triggersに全ての依存リソースを含めているか確認してください
#
# 問題: 不要な再デプロイが発生する
# 解決策: triggersのハッシュ計算に含めるリソースを最小限に絞ってください
#
# ====================================================================================================

# ====================================================================================================
# Terraform AWS Provider Resource: aws_api_gateway_deployment
# Provider Version: 6.28.0
# Last Updated: 2026-01-22
# ====================================================================================================
#
# リソース概要:
# API Gateway REST APIデプロイメントを管理します。デプロイメントはREST API設定のスナップショットです。
# デプロイメント後、aws_api_gateway_stageリソースを通じて呼び出し可能なエンドポイントとして公開できます。
#
# 重要な注意事項:
# - REST API設定の全ての変更を適切にキャプチャするため、このリソースは全ての関連Terraformリソース
#   (リソース/パス、メソッド、統合など)に依存関係を持つ必要があります
# - OpenAPI仕様でAPIを設定する場合、特別な依存関係設定は不要です(rest_api.idの参照のみでOK)
# - Terraformリソースで設定する場合、triggersまたはdepends_onで依存関係を明示する必要があります
# - triggersの使用が推奨されます(設定変更時に自動的に再デプロイされます)
# - lifecycle { create_before_destroy = true } の設定が強く推奨されます
#   (これがないと、再作成時に "Active stages pointing to this deployment must be moved or deleted"
#    エラーが発生する可能性があります)
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-deploy-api.html
#
# Terraform公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment
# ====================================================================================================

# ====================================================================================================
# 例1: OpenAPI仕様を使用したデプロイメント
# ====================================================================================================
# OpenAPI仕様でAPIを定義する場合の推奨パターンです。
# bodyの変更を検出して自動的に再デプロイします。
# ====================================================================================================

resource "aws_api_gateway_rest_api" "openapi_example" {
  # OpenAPI仕様をJSONエンコードして設定
  # bodyの内容が変更されると、自動的にAPIが更新されます
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "example-api"
      version = "1.0"
    }
    paths = {
      "/path1" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
          }
        }
      }
    }
  })

  name = "example-openapi-api"
}

resource "aws_api_gateway_deployment" "openapi_example" {
  # ====================================================================================================
  # 必須パラメータ
  # ====================================================================================================

  # rest_api_id (Required: string)
  # デプロイ対象のREST APIのID
  # AWS公式ドキュメント: https://docs.aws.amazon.com/apigateway/latest/api/API_CreateDeployment.html#API_CreateDeployment_RequestSyntax
  rest_api_id = aws_api_gateway_rest_api.openapi_example.id

  # ====================================================================================================
  # オプションパラメータ
  # ====================================================================================================

  # description (Optional: string)
  # デプロイメントの説明
  # このデプロイメントの目的や変更内容を記述します
  # AWS公式ドキュメント: https://docs.aws.amazon.com/apigateway/latest/api/API_CreateDeployment.html#API_CreateDeployment_RequestSyntax
  description = "Deployment for OpenAPI-based REST API"

  # triggers (Optional: map(string))
  # 変更時に再デプロイをトリガーする任意のキーと値のマップ
  # OpenAPI仕様の場合、bodyのハッシュ値を使用するのが推奨パターンです
  # これにより、API定義の変更が自動的に検出され、再デプロイが実行されます
  # AWS公式ドキュメント: https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-deploy-api.html
  triggers = {
    # sha1でbodyのハッシュ値を計算し、変更を検出
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.openapi_example.body))
  }

  # variables (Optional: map(string))
  # 関連するステージに設定する変数のマップ
  # ステージ変数は、統合エンドポイントやLambda関数のエイリアスなどを動的に参照する際に使用します
  # 注意: この設定は非推奨です。代わりにaws_api_gateway_stageリソースのvariablesを使用してください
  # AWS公式ドキュメント: https://docs.aws.amazon.com/apigateway/latest/developerguide/stage-variables.html
  # variables = {
  #   "environment" = "production"
  # }

  # region (Optional: string)
  # このリソースが管理されるリージョン
  # デフォルトではプロバイダー設定のリージョンが使用されます
  # マルチリージョン構成の場合のみ明示的に指定します
  # AWS公式ドキュメント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ====================================================================================================
  # ライフサイクル設定
  # ====================================================================================================

  lifecycle {
    # create_before_destroy (Required for safe redeployment)
    # 再デプロイ時に新しいデプロイメントを先に作成してから古いものを削除します
    # これを設定しないと、アクティブなステージが参照しているデプロイメントの削除時にエラーが発生します
    # Terraform公式ドキュメント: https://www.terraform.io/language/meta-arguments/lifecycle#create_before_destroy
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "openapi_example" {
  # デプロイメントID
  # デプロイメントとステージは1対多の関係です
  deployment_id = aws_api_gateway_deployment.openapi_example.id

  # REST API ID
  rest_api_id   = aws_api_gateway_rest_api.openapi_example.id

  # ステージ名
  # URLパスの一部として使用されます: https://api-id.execute-api.region.amazonaws.com/stage-name/
  stage_name    = "production"
}

# ====================================================================================================
# 例2: Terraformリソースを使用したデプロイメント
# ====================================================================================================
# aws_api_gateway_resource、aws_api_gateway_method、aws_api_gateway_integrationなどの
# Terraformリソースを組み合わせてAPIを構築する場合のパターンです。
# triggersで依存関係を明示的に宣言することで、リソース変更時の自動再デプロイを実現します。
# ====================================================================================================

resource "aws_api_gateway_rest_api" "terraform_example" {
  name = "example-terraform-api"
}

resource "aws_api_gateway_resource" "terraform_example" {
  # 親リソースID(ルートリソースIDを指定)
  parent_id   = aws_api_gateway_rest_api.terraform_example.root_resource_id

  # パス部分(/exampleとなる)
  path_part   = "example"

  # REST API ID
  rest_api_id = aws_api_gateway_rest_api.terraform_example.id
}

resource "aws_api_gateway_method" "terraform_example" {
  # 認証タイプ(NONE, AWS_IAM, CUSTOM, COGNITO_USER_POOLSなど)
  authorization = "NONE"

  # HTTPメソッド(GET, POST, PUT, DELETEなど)
  http_method   = "GET"

  # リソースID
  resource_id   = aws_api_gateway_resource.terraform_example.id

  # REST API ID
  rest_api_id   = aws_api_gateway_rest_api.terraform_example.id
}

resource "aws_api_gateway_integration" "terraform_example" {
  # HTTPメソッド
  http_method = aws_api_gateway_method.terraform_example.http_method

  # リソースID
  resource_id = aws_api_gateway_resource.terraform_example.id

  # REST API ID
  rest_api_id = aws_api_gateway_rest_api.terraform_example.id

  # 統合タイプ(MOCK, HTTP, HTTP_PROXY, AWS, AWS_PROXYなど)
  # MOCKは開発・テスト用のモック統合です
  type        = "MOCK"
}

resource "aws_api_gateway_deployment" "terraform_example" {
  # REST API ID
  rest_api_id = aws_api_gateway_rest_api.terraform_example.id

  # デプロイメントの説明
  description = "Deployment for Terraform-based REST API"

  # triggers (重要)
  # TerraformリソースでAPIを構築する場合、triggersで依存関係を明示的に宣言します
  # 依存するリソースのIDを配列にしてハッシュ化することで、変更検出を実現します
  #
  # 注意事項:
  # - この設定は依存関係の順序は満たしますが、将来の全てのAPI変更を検出するわけではありません
  # - より高度なパターンとして、filesha1()関数でTerraformファイル自体のハッシュを計算する方法があります
  # - リソース全体をハッシュ化することも可能ですが、初回実装後に差分が表示されます
  #   (その後は実際の変更時のみ差分が表示されるようになります)
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.terraform_example.id,
      aws_api_gateway_method.terraform_example.id,
      aws_api_gateway_integration.terraform_example.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "terraform_example" {
  deployment_id = aws_api_gateway_deployment.terraform_example.id
  rest_api_id   = aws_api_gateway_rest_api.terraform_example.id
  stage_name    = "development"
}

# ====================================================================================================
# 例3: 複雑なAPI構成のデプロイメント(複数メソッド、統合、レスポンス)
# ====================================================================================================
# より複雑なAPI構成で、複数のリソース、メソッド、統合、レスポンスを含む場合の例です。
# すべての依存リソースをtriggersに含めることで、包括的な変更検出を実現します。
# ====================================================================================================

resource "aws_api_gateway_rest_api" "complex_example" {
  name = "complex-api"
}

resource "aws_api_gateway_resource" "users" {
  parent_id   = aws_api_gateway_rest_api.complex_example.root_resource_id
  path_part   = "users"
  rest_api_id = aws_api_gateway_rest_api.complex_example.id
}

resource "aws_api_gateway_resource" "user_id" {
  parent_id   = aws_api_gateway_resource.users.id
  path_part   = "{userId}"
  rest_api_id = aws_api_gateway_rest_api.complex_example.id
}

# GETメソッド
resource "aws_api_gateway_method" "get_user" {
  authorization = "AWS_IAM"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.user_id.id
  rest_api_id   = aws_api_gateway_rest_api.complex_example.id

  request_parameters = {
    "method.request.path.userId" = true
  }
}

resource "aws_api_gateway_integration" "get_user" {
  http_method             = aws_api_gateway_method.get_user.http_method
  resource_id             = aws_api_gateway_resource.user_id.id
  rest_api_id             = aws_api_gateway_rest_api.complex_example.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:123456789012:function:GetUser/invocations"
}

# POSTメソッド
resource "aws_api_gateway_method" "create_user" {
  authorization = "AWS_IAM"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.users.id
  rest_api_id   = aws_api_gateway_rest_api.complex_example.id
}

resource "aws_api_gateway_integration" "create_user" {
  http_method             = aws_api_gateway_method.create_user.http_method
  resource_id             = aws_api_gateway_resource.users.id
  rest_api_id             = aws_api_gateway_rest_api.complex_example.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:123456789012:function:CreateUser/invocations"
}

resource "aws_api_gateway_deployment" "complex_example" {
  rest_api_id = aws_api_gateway_rest_api.complex_example.id
  description = "Deployment for complex API with multiple resources and methods"

  # 全ての依存リソースをtriggersに含める
  # これにより、いずれかのリソースが変更された場合に自動的に再デプロイされます
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.users.id,
      aws_api_gateway_resource.user_id.id,
      aws_api_gateway_method.get_user.id,
      aws_api_gateway_integration.get_user.id,
      aws_api_gateway_method.create_user.id,
      aws_api_gateway_integration.create_user.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "complex_example" {
  deployment_id = aws_api_gateway_deployment.complex_example.id
  rest_api_id   = aws_api_gateway_rest_api.complex_example.id
  stage_name    = "v1"

  # ステージレベルの変数設定(推奨)
  variables = {
    "lambdaAlias" = "PROD"
    "environment" = "production"
  }
}

# ====================================================================================================
# 出力値(Attributes)
# ====================================================================================================
# デプロイメント作成後に取得できる属性値です。
# ====================================================================================================

output "deployment_id" {
  # id (Computed: string)
  # デプロイメントのID
  # ステージリソースなどで参照する際に使用します
  description = "Deployment ID"
  value       = aws_api_gateway_deployment.openapi_example.id
}

output "created_date" {
  # created_date (Computed: string)
  # デプロイメントの作成日時
  # RFC3339形式のタイムスタンプです
  description = "Deployment creation date"
  value       = aws_api_gateway_deployment.openapi_example.created_date
}

# ====================================================================================================
# ベストプラクティスと推奨事項
# ====================================================================================================
#
# 1. triggersの使用
#    - triggersを使用して依存リソースの変更を検出します
#    - depends_onよりもtriggersが推奨されます(変更検出と再デプロイの自動化)
#
# 2. lifecycle設定
#    - 必ず create_before_destroy = true を設定してください
#    - これにより、再デプロイ時のエラーを防止できます
#
# 3. デプロイメントの説明
#    - descriptionに変更内容や目的を記述することで、デプロイ履歴の追跡が容易になります
#
# 4. ステージ変数
#    - variablesパラメータではなく、aws_api_gateway_stageリソースのvariablesを使用してください
#
# 5. 依存関係の管理
#    - OpenAPI仕様: bodyのハッシュ値をtriggersに設定
#    - Terraformリソース: 全ての関連リソースIDをtriggersに含める
#
# 6. 再デプロイの強制実行
#    - triggersの値を変更せずに再デプロイが必要な場合:
#      terraform plan -replace="aws_api_gateway_deployment.example"
#      terraform apply -replace="aws_api_gateway_deployment.example"
#
# 7. マルチリージョン展開
#    - 必要に応じてregionパラメータを使用して明示的にリージョンを指定します
#
# 8. デプロイメント戦略
#    - Blue/Greenデプロイメント: ステージとデプロイメントを組み合わせて実現
#    - Canaryリリース: aws_api_gateway_stageのcanary_settingsを使用
#
# ====================================================================================================
# 関連リソース
# ====================================================================================================
#
# - aws_api_gateway_rest_api: REST APIの定義
# - aws_api_gateway_stage: デプロイメントを公開するステージ
# - aws_api_gateway_resource: APIリソース(パス)の定義
# - aws_api_gateway_method: HTTPメソッドの定義
# - aws_api_gateway_integration: バックエンド統合の設定
# - aws_api_gateway_method_response: メソッドレスポンスの設定
# - aws_api_gateway_integration_response: 統合レスポンスの設定
# - aws_api_gateway_base_path_mapping: カスタムドメインへのマッピング
# - aws_api_gateway_domain_name: カスタムドメインの設定
# - aws_api_method_settings: ステージレベルのメソッド設定
#
# ====================================================================================================
# トラブルシューティング
# ====================================================================================================
#
# 問題: "Active stages pointing to this deployment must be moved or deleted"
# 解決策: lifecycle { create_before_destroy = true } を設定してください
#
# 問題: API変更が反映されない
# 解決策: triggersに全ての依存リソースを含めているか確認してください
#
# 問題: 不要な再デプロイが発生する
# 解決策: triggersのハッシュ計算に含めるリソースを最小限に絞ってください
#
# ====================================================================================================

