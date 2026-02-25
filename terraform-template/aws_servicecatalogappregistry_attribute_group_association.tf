#---------------------------------------------------------------
# AWS Service Catalog AppRegistry Attribute Group Association
#---------------------------------------------------------------
#
# AWS Service Catalog AppRegistry のアプリケーションと属性グループを
# 関連付けるリソースです。アプリケーションにカスタムメタデータ（属性グループ）を
# 紐付けることで、アプリケーションに関する追加情報を構造化して管理できます。
#
# AWS公式ドキュメント:
#   - AWS Service Catalog AppRegistry: https://docs.aws.amazon.com/servicecatalog/latest/arguide/intro-app-registry.html
#   - 属性グループの管理: https://docs.aws.amazon.com/servicecatalog/latest/arguide/manage-attribute-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalogappregistry_attribute_group_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalogappregistry_attribute_group_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # application_id (Required)
  # 設定内容: 関連付け先のアプリケーションのIDを指定します。
  # 設定可能な値: 有効な AppRegistry アプリケーションID、またはアプリケーションARN
  application_id = aws_servicecatalogappregistry_application.example.id

  # attribute_group_id (Required)
  # 設定内容: アプリケーションに関連付ける属性グループのIDを指定します。
  # 設定可能な値: 有効な AppRegistry 属性グループID、または属性グループARN
  attribute_group_id = aws_servicecatalogappregistry_attribute_group.example.id

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
# - id: アプリケーションIDと属性グループIDをカンマ区切りで結合した識別子
#---------------------------------------------------------------
