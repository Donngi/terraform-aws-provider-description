#---------------------------------------------------------------
# AWS Service Catalog AppRegistry Application
#---------------------------------------------------------------
#
# AWS Service Catalog AppRegistry のアプリケーションをプロビジョニングするリソースです。
# アプリケーションはリソースとメタデータをグループ化する論理単位で、
# AWS Management Console の「MyApplications」として表示されます。
# アプリケーションに関連付けられたリソースには `awsApplication` タグが付与されます。
#
# AWS公式ドキュメント:
#   - AppRegistry アプリケーションの作成: https://docs.aws.amazon.com/servicecatalog/latest/arguide/create-apps.html
#   - AppRegistry の主要概念: https://docs.aws.amazon.com/servicecatalog/latest/arguide/overview-appreg.html
#   - awsApplication タグ: https://docs.aws.amazon.com/servicecatalog/latest/arguide/ar-user-tags.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalogappregistry_application
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalogappregistry_application" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: アプリケーションの名前を指定します。
  # 設定可能な値: AWSリージョン内で一意となる文字列
  # 参考: https://docs.aws.amazon.com/servicecatalog/latest/arguide/create-apps.html
  name = "example-app"

  # description (Optional)
  # 設定内容: アプリケーションの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example application managed by Terraform"

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
  # 省略時: タグなし
  # 注意: プロバイダーの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-app"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - application_tag: アプリケーションに関連付けるリソースへのタグ付けに使用する
#                    単一のキーバリューペアのマップ。キーは "awsApplication"。
#                    他のリソースの tags 引数に直接渡すか、既存のタグマップにマージして使用します。
#
# - arn: アプリケーションのARN (Amazon Resource Name)
#
# - id: アプリケーションの識別子
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
