#---------------------------------------------------------------
# AWS Amplify Backend Environment
#---------------------------------------------------------------
#
# AWS Amplifyアプリケーションのバックエンド環境をプロビジョニングするリソースです。
# バックエンド環境は、Amplifyアプリに関連付けられたAWS CloudFormationスタックを
# 管理し、デプロイメントアーティファクトの格納場所を定義します。
# 開発、ステージング、本番など異なる環境を分離して管理できます。
#
# AWS公式ドキュメント:
#   - AWS Amplify概要: https://docs.aws.amazon.com/amplify/latest/userguide/welcome.html
#   - AWS Amplify Hosting: https://docs.aws.amazon.com/amplify/latest/userguide/getting-started.html
#   - AWS Amplifyエンドポイントとクォータ: https://docs.aws.amazon.com/general/latest/gr/amplify.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/amplify_backend_environment
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_amplify_backend_environment" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # app_id (Required)
  # 設定内容: AmplifyアプリケーションのユニークIDを指定します。
  # 設定可能な値: aws_amplify_appリソースから取得したIDまたは既存のAmplifyアプリID
  # 関連機能: AWS Amplifyアプリ
  #   Amplifyアプリは、フロントエンドWebおよびモバイルアプリケーションの
  #   ホスティングとCI/CDを提供します。
  #   - https://docs.aws.amazon.com/amplify/latest/userguide/welcome.html
  app_id = aws_amplify_app.example.id

  # environment_name (Required)
  # 設定内容: バックエンド環境の名前を指定します。
  # 設定可能な値: 文字列（例: "dev", "staging", "prod"）
  # 用途: 開発、ステージング、本番など異なる環境を識別するために使用
  environment_name = "dev"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # deployment_artifacts (Optional)
  # 設定内容: デプロイメントアーティファクトの名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: Amplifyが自動的にデプロイメントアーティファクト名を生成
  # 用途: バックエンド環境のデプロイメントアーティファクトを格納する
  #       S3バケットのプレフィックスとして使用されます
  deployment_artifacts = "app-example-deployment"

  # stack_name (Optional)
  # 設定内容: バックエンド環境のAWS CloudFormationスタック名を指定します。
  # 設定可能な値: 有効なCloudFormationスタック名
  # 省略時: Amplifyが自動的にスタック名を生成
  # 関連機能: AWS CloudFormation
  #   Amplifyはバックエンドリソース（認証、API、ストレージなど）を
  #   CloudFormationスタックとしてプロビジョニングします。
  #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html
  stack_name = "amplify-app-example"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Amplifyアプリの一部であるバックエンド環境のAmazon Resource Name (ARN)
#
# - id: Amplifyバックエンド環境のユニークID
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# resource "aws_amplify_app" "example" {
#   name = "example-app"
# }
#
# resource "aws_amplify_backend_environment" "dev" {
#   app_id           = aws_amplify_app.example.id
#   environment_name = "dev"
#
#   deployment_artifacts = "app-example-dev-deployment"
#   stack_name           = "amplify-app-example-dev"
# }
#
# resource "aws_amplify_backend_environment" "prod" {
#---------------------------------------------------------------
