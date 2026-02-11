#---------------------------------------------------------------
# AWS AppConfig Application
#---------------------------------------------------------------
#
# AWS AppConfigのアプリケーションをプロビジョニングするリソースです。
# アプリケーションは、AWS AppConfigにおける設定管理の最上位の論理単位であり、
# 環境（Environment）、設定プロファイル（Configuration Profile）、
# デプロイ戦略（Deployment Strategy）を含む構成要素の親コンテナです。
#
# AWS公式ドキュメント:
#   - AWS AppConfig概要: https://docs.aws.amazon.com/appconfig/latest/userguide/what-is-appconfig.html
#   - アプリケーションの作成: https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-application.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_application
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appconfig_application" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: アプリケーションの名前を指定します。
  # 設定可能な値: 1〜64文字の文字列
  # 注意: AWS AppConfig内でアプリケーションを識別するために使用されます。
  name = "example-application"

  # description (Optional)
  # 設定内容: アプリケーションの説明を指定します。
  # 設定可能な値: 最大1024文字の文字列
  # 用途: アプリケーションの目的や用途を記述するために使用します。
  description = "Example AppConfig Application for configuration management"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-application"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AppConfigアプリケーションのAmazon Resource Name (ARN)
#
# - id: AppConfigアプリケーションID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
