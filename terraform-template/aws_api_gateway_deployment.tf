#---------------------------------------------------------------
# AWS API Gateway Deployment
#---------------------------------------------------------------
#
# API Gateway REST APIのデプロイメントを管理するリソースです。
# デプロイメントはREST API設定のスナップショットであり、
# aws_api_gateway_stageリソースを通じて呼び出し可能なエンドポイントとして
# 公開できます。
#
# REST API設定を正しくキャプチャするには、リソース/パス、メソッド、
# 統合などを管理する全ての事前Terraformリソースに対する依存関係を
# 設定する必要があります。
#
# AWS公式ドキュメント:
#   - API Gatewayデプロイメント: https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-deploy-api.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/api_gateway_deployment
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       公式ドキュメントを確認した上でご利用ください。
#---------------------------------------------------------------

resource "aws_api_gateway_deployment" "example" {
  #-------
  # 基本設定
  #-------
  # 設定内容: デプロイ対象のREST APIのID
  # 必須項目: はい
  # 参照方法: aws_api_gateway_rest_api.example.id
  rest_api_id = aws_api_gateway_rest_api.example.id

  #-------
  # デプロイメント制御
  #-------
  # 設定内容: 再デプロイのトリガーとして使用する任意のキーと値のマップ
  # 設定可能な値: 任意の文字列キーと値のペア
  # 省略時: トリガーなし
  # 推奨設定: API設定変更を検知するためのハッシュ値を設定
  # 注意事項: OpenAPI仕様の場合はbodyのハッシュ、Terraformリソースの場合は関連リソースIDのハッシュを使用
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.example.body))
  }

  # 設定内容: デプロイメントの説明
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "API Gateway deployment for production"

  # 設定内容: 関連するステージに設定する変数のマップ
  # 設定可能な値: 任意の文字列キーと値のペア
  # 省略時: 変数なし
  # 注意事項: ステージ変数として使用可能
  variables = {
    environment = "production"
    version     = "v1"
  }

  #-------
  # リージョン設定
  #-------
  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョン
  region = "ap-northeast-1"

  #-------
  # ライフサイクル設定
  #-------
  # 注意事項: create_before_destroyの有効化を強く推奨
  # 理由: 削除前に新しいデプロイメントを作成することで、アクティブなステージが参照する
  #       デプロイメントの削除エラー（BadRequestException）を防ぎます
  lifecycle {
    create_before_destroy = true
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# これらの属性は、リソース作成後に参照可能です
#
# id
#   説明: デプロイメントのID
#   用途: aws_api_gateway_stageのdeployment_idとして使用
#   参照: aws_api_gateway_deployment.example.id
#
# created_date
#   説明: デプロイメントの作成日時
#   形式: RFC3339形式のタイムスタンプ
#   参照: aws_api_gateway_deployment.example.created_date
#
# execution_arn
#   説明: デプロイメントの実行ARN
#   用途: IAMポリシーでの権限設定に使用
#   参照: aws_api_gateway_deployment.example.execution_arn
#---------------------------------------
