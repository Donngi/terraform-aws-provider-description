#---------------------------------------------------------------
# AWS Amplify Webhook
#---------------------------------------------------------------
#
# AWS Amplify Hostingのウェブフックをプロビジョニングするリソースです。
# ウェブフックを使用することで、外部システムからAmplifyアプリのビルドを
# トリガーできます。これにより、Gitプロバイダー以外のソースからの
# デプロイメントや、カスタムCI/CDパイプラインとの統合が可能になります。
#
# AWS公式ドキュメント:
#   - Amplify Hosting概要: https://docs.aws.amazon.com/amplify/latest/userguide/welcome.html
#   - Amplify Hosting ビルド設定: https://docs.aws.amazon.com/amplify/latest/userguide/build-settings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/amplify_webhook
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_amplify_webhook" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # app_id (Required)
  # 設定内容: Amplifyアプリの一意のIDを指定します。
  # 設定可能な値: 有効なAmplifyアプリID（aws_amplify_appリソースのid属性から取得可能）
  # 注意: このウェブフックが関連付けられるAmplifyアプリを特定します。
  app_id = aws_amplify_app.example.id

  # branch_name (Required)
  # 設定内容: Amplifyアプリの一部であるブランチ名を指定します。
  # 設定可能な値: 有効なブランチ名（aws_amplify_branchリソースで作成されたブランチ）
  # 注意: ウェブフックがトリガーされた際に、このブランチのビルドが開始されます。
  branch_name = aws_amplify_branch.main.branch_name

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ウェブフックの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: ウェブフックの目的や用途を識別するための説明を記載します。
  description = "Trigger build for main branch"

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
# - arn: ウェブフックのAmazon Resource Name (ARN)
#
# - url: ウェブフックのURL
#        このURLにHTTP POSTリクエストを送信することで、
#        関連付けられたブランチのビルドをトリガーできます。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 以下は、ウェブフックを使用するために必要な関連リソースの例です。
#
# resource "aws_amplify_app" "example" {
#   name = "my-app"
# }
#
# resource "aws_amplify_branch" "main" {
#   app_id      = aws_amplify_app.example.id
#   branch_name = "main"
# }
#---------------------------------------------------------------
