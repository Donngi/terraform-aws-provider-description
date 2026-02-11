#-------
# API Gateway API Key
#-------
# Provider Version: 6.28.0
# Generated: 2026-02-11
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/api_gateway_api_key
#
# NOTE: 2016年8月11日以降、APIキーを使用するには使用量プランとの関連付けが必須です
#
# API Gatewayで使用するAPIキーを作成します。
# 使用量プランと組み合わせて、APIへのアクセス制御とレート制限を実装できます。
#
# 関連ドキュメント: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-key-source.html
#
# 注意事項:
# - APIキーの値は作成後に変更できません（再作成が必要）
# - デフォルトで有効化されますが、enabled = false で無効化できます
# - AWS Marketplaceと統合する場合はcustomer_idを指定します
#-------

resource "aws_api_gateway_api_key" "example" {
  #-------
  # 基本設定
  #-------
  # 設定内容: APIキーの名前
  # 設定可能な値: 任意の文字列
  # 省略時: 設定必須項目
  name = "my-api-key"

  #-------
  # 説明設定
  #-------
  # 設定内容: APIキーの説明
  # 設定可能な値: 任意の文字列
  # 省略時: "Managed by Terraform"
  description = "API key for production environment"

  #-------
  # キー有効化設定
  #-------
  # 設定内容: APIキーの有効/無効状態
  # 設定可能な値: true（有効）、false（無効）
  # 省略時: true
  enabled = true

  #-------
  # キー値設定
  #-------
  # 設定内容: APIキーの値
  # 設定可能な値: 20〜128文字の英数字文字列
  # 省略時: AWSが自動生成
  # value = "abcdefghij1234567890abcdefghij1234567890"

  #-------
  # Marketplace統合設定
  #-------
  # 設定内容: AWS Marketplace統合時の顧客識別子
  # 設定可能な値: AWS Marketplace顧客ID
  # 省略時: なし（Marketplace統合しない）
  # customer_id = "customer-12345"

  #-------
  # リージョン設定
  #-------
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: ap-northeast-1、us-east-1など
  # 省略時: プロバイダーのリージョン設定を継承
  # region = "ap-northeast-1"

  #-------
  # タグ設定
  #-------
  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値の文字列マップ
  # 省略時: タグなし
  tags = {
    Name        = "my-api-key"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

#-------
# Attributes Reference
#-------
# id - APIキーのID
# arn - APIキーのARN
# created_date - APIキーの作成日時
# last_updated_date - APIキーの最終更新日時
# tags_all - プロバイダーのdefault_tagsとリソースのtagsをマージした全タグ
