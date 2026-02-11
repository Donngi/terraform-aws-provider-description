################################################################################
# AWS API Gateway Base Path Mapping
################################################################################
# Terraform Resource: aws_api_gateway_base_path_mapping
# Provider Version: 6.28.0
# Generated: 2026-01-22
#
# このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping
#
# 説明:
# カスタムドメイン名（aws_api_gateway_domain_nameで登録）とデプロイ済みAPIを接続し、
# カスタムドメイン名経由でAPIメソッドを呼び出せるようにします。
#
# 関連ドキュメント:
# - API Gateway Base Path Mapping API:
#   https://docs.aws.amazon.com/apigateway/latest/api/API_UpdateBasePathMapping.html
# - カスタムドメイン名のセットアップ:
#   https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-edge-optimized-custom-domain-name.html
################################################################################

resource "aws_api_gateway_base_path_mapping" "example" {
  ################################################################################
  # Required Parameters
  ################################################################################

  # (Required) 接続するAPIのID
  # REST APIまたはHTTP APIのIDを指定します
  # 参照: aws_api_gateway_rest_api.example.id
  api_id = "example-api-id"

  # (Required) 接続先のカスタムドメイン名
  # aws_api_gateway_domain_nameリソースで事前に登録したドメイン名を指定します
  # 例: "api.example.com"
  domain_name = "example.com"

  ################################################################################
  # Optional Parameters
  ################################################################################

  # (Optional) ベースパス
  # カスタムドメインのルートパス以下に配置する追加のパスセグメント
  # 省略した場合、APIはカスタムドメインのルート（/）で公開されます
  #
  # 例: base_path = "v1" の場合
  #   アクセスURL: https://api.example.com/v1/your-resource
  #
  # 空のベースパスを明示的に指定する場合は "(none)" を設定します
  #
  # 単一のカスタムドメイン名で複数のAPIを異なるベースパスで公開できます
  # 例:
  #   - api1: base_path = "api1" -> https://example.com/api1/*
  #   - api2: base_path = "api2" -> https://example.com/api2/*
  base_path = null

  # (Optional) ドメイン名リソースの識別子
  # プライベートカスタムドメイン名でのみサポートされます
  # パブリックカスタムドメイン名では不要です
  #
  # プライベートカスタムドメイン名を使用する場合に指定します
  # 参照: aws_api_gateway_domain_name.example.domain_name_id
  domain_name_id = null

  # (Optional) リソースID
  # Terraformによって自動計算される値です
  # 通常は明示的に設定する必要はありません
  #
  # import時やstate管理の特殊なケースでのみ使用します
  id = null

  # (Optional) リソースを管理するAWSリージョン
  # デフォルトではプロバイダー設定で指定されたリージョンが使用されます
  #
  # 特定のリージョンでリソースを管理する必要がある場合に明示的に指定します
  # 例: "us-east-1", "ap-northeast-1"
  #
  # 参照:
  # - AWSリージョナルエンドポイント:
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # (Optional) デプロイステージ名
  # 特定のデプロイステージをこのパスで公開する場合に指定します
  # 省略した場合、呼び出し側がベースパスの後にステージ名をパス要素として含めることで、
  # 任意のステージを選択できます
  #
  # 例1: stage_name = "prod" の場合
  #   固定URL: https://api.example.com/v1/resource (常にprodステージ)
  #
  # 例2: stage_name を省略した場合
  #   動的URL: https://api.example.com/v1/{stage}/resource
  #   - https://api.example.com/v1/dev/resource
  #   - https://api.example.com/v1/prod/resource
  #
  # 参照: aws_api_gateway_stage.example.stage_name
  stage_name = null
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# このリソースには出力専用の属性はありません。
# すべての属性は入力可能または入力可能かつ計算済み（computed）です。
################################################################################

################################################################################
# 使用例
################################################################################
# 完全な設定例:
#
# resource "aws_api_gateway_rest_api" "example" {
#   name        = "example-api"
#   description = "Example API"
# }
#
# resource "aws_api_gateway_deployment" "example" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   stage_name  = "prod"
# }
#
# resource "aws_api_gateway_stage" "example" {
#   deployment_id = aws_api_gateway_deployment.example.id
#   rest_api_id   = aws_api_gateway_rest_api.example.id
#   stage_name    = "prod"
# }
#
# resource "aws_api_gateway_domain_name" "example" {
#   domain_name              = "api.example.com"
#   regional_certificate_arn = aws_acm_certificate.example.arn
#
#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
# }
#
# resource "aws_api_gateway_base_path_mapping" "example" {
#   api_id      = aws_api_gateway_rest_api.example.id
#   stage_name  = aws_api_gateway_stage.example.stage_name
#   domain_name = aws_api_gateway_domain_name.example.domain_name
#   base_path   = "v1"
# }
#
# # 複数のAPIを単一ドメインで公開する例
# resource "aws_api_gateway_base_path_mapping" "api_v2" {
#   api_id      = aws_api_gateway_rest_api.api_v2.id
#   stage_name  = aws_api_gateway_stage.api_v2.stage_name
#   domain_name = aws_api_gateway_domain_name.example.domain_name
#   base_path   = "v2"
# }
################################################################################

################################################################################
# AWS API Gateway Base Path Mapping
################################################################################
# Terraform Resource: aws_api_gateway_base_path_mapping
# Provider Version: 6.28.0
# Generated: 2026-01-22
#
# このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping
#
# 説明:
# カスタムドメイン名（aws_api_gateway_domain_nameで登録）とデプロイ済みAPIを接続し、
# カスタムドメイン名経由でAPIメソッドを呼び出せるようにします。
#
# 関連ドキュメント:
# - API Gateway Base Path Mapping API:
#   https://docs.aws.amazon.com/apigateway/latest/api/API_UpdateBasePathMapping.html
# - カスタムドメイン名のセットアップ:
#   https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-edge-optimized-custom-domain-name.html
################################################################################

resource "aws_api_gateway_base_path_mapping" "example" {
  ################################################################################
  # Required Parameters
  ################################################################################

  # (Required) 接続するAPIのID
  # REST APIまたはHTTP APIのIDを指定します
  # 参照: aws_api_gateway_rest_api.example.id
  api_id = "example-api-id"

  # (Required) 接続先のカスタムドメイン名
  # aws_api_gateway_domain_nameリソースで事前に登録したドメイン名を指定します
  # 例: "api.example.com"
  domain_name = "example.com"

  ################################################################################
  # Optional Parameters
  ################################################################################

  # (Optional) ベースパス
  # カスタムドメインのルートパス以下に配置する追加のパスセグメント
  # 省略した場合、APIはカスタムドメインのルート（/）で公開されます
  #
  # 例: base_path = "v1" の場合
  #   アクセスURL: https://api.example.com/v1/your-resource
  #
  # 空のベースパスを明示的に指定する場合は "(none)" を設定します
  #
  # 単一のカスタムドメイン名で複数のAPIを異なるベースパスで公開できます
  # 例:
  #   - api1: base_path = "api1" -> https://example.com/api1/*
  #   - api2: base_path = "api2" -> https://example.com/api2/*
  base_path = null

  # (Optional) ドメイン名リソースの識別子
  # プライベートカスタムドメイン名でのみサポートされます
  # パブリックカスタムドメイン名では不要です
  #
  # プライベートカスタムドメイン名を使用する場合に指定します
  # 参照: aws_api_gateway_domain_name.example.domain_name_id
  #
  # 関連ドキュメント:
  # - Private custom domain names:
  #   https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-private-custom-domains.html
  domain_name_id = null

  # (Optional) リソースID
  # Terraformによって自動計算される値です
  # 通常は明示的に設定する必要はありません
  #
  # import時やstate管理の特殊なケースでのみ使用します
  id = null

  # (Optional) リソースを管理するAWSリージョン
  # デフォルトではプロバイダー設定で指定されたリージョンが使用されます
  #
  # 特定のリージョンでリソースを管理する必要がある場合に明示的に指定します
  # 例: "us-east-1", "ap-northeast-1"
  #
  # 参照:
  # - AWSリージョナルエンドポイント:
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # (Optional) デプロイステージ名
  # 特定のデプロイステージをこのパスで公開する場合に指定します
  # 省略した場合、呼び出し側がベースパスの後にステージ名をパス要素として含めることで、
  # 任意のステージを選択できます
  #
  # 例1: stage_name = "prod" の場合
  #   固定URL: https://api.example.com/v1/resource (常にprodステージ)
  #
  # 例2: stage_name を省略した場合
  #   動的URL: https://api.example.com/v1/{stage}/resource
  #   - https://api.example.com/v1/dev/resource
  #   - https://api.example.com/v1/prod/resource
  #
  # 参照: aws_api_gateway_stage.example.stage_name
  stage_name = null
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# このリソースには出力専用の属性はありません。
# すべての属性は入力可能または入力可能かつ計算済み（computed）です。
################################################################################

################################################################################
# 使用例
################################################################################
# 完全な設定例:
#
# resource "aws_api_gateway_rest_api" "example" {
#   name        = "example-api"
#   description = "Example API"
# }
#
# resource "aws_api_gateway_deployment" "example" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   stage_name  = "prod"
# }
#
# resource "aws_api_gateway_stage" "example" {
#   deployment_id = aws_api_gateway_deployment.example.id
#   rest_api_id   = aws_api_gateway_rest_api.example.id
#   stage_name    = "prod"
# }
#
# resource "aws_api_gateway_domain_name" "example" {
#   domain_name              = "api.example.com"
#   regional_certificate_arn = aws_acm_certificate.example.arn
#
#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
# }
#
# resource "aws_api_gateway_base_path_mapping" "example" {
#   api_id      = aws_api_gateway_rest_api.example.id
#   stage_name  = aws_api_gateway_stage.example.stage_name
#   domain_name = aws_api_gateway_domain_name.example.domain_name
#   base_path   = "v1"
# }
#
# # 複数のAPIを単一ドメインで公開する例
# resource "aws_api_gateway_base_path_mapping" "api_v2" {
#   api_id      = aws_api_gateway_rest_api.api_v2.id
#   stage_name  = aws_api_gateway_stage.api_v2.stage_name
#   domain_name = aws_api_gateway_domain_name.example.domain_name
#   base_path   = "v2"
# }
################################################################################

