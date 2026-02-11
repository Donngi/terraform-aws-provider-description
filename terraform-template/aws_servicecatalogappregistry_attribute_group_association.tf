#---------------------------------------------------------------
# AWS Service Catalog AppRegistry Attribute Group Association
#---------------------------------------------------------------
#
# AWS Service Catalog AppRegistry の属性グループをアプリケーションに
# 関連付けるためのリソースです。
#
# このリソースを使用することで、アプリケーションのメタデータを属性グループの
# 属性で強化し、アプリケーションをユーザー定義の詳細情報（マシンリーダブルな形式）で
# 記述できるようになります。サードパーティー統合などに有用です。
#
# 関連リソース:
#   - aws_servicecatalogappregistry_application: AppRegistryアプリケーション
#   - aws_servicecatalogappregistry_attribute_group: AppRegistry属性グループ
#
# AWS公式ドキュメント:
#   - 属性グループの関連付け: https://docs.aws.amazon.com/servicecatalog/latest/arguide/associate-attr-groups.html
#   - AssociateAttributeGroup API: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_app-registry_AssociateAttributeGroup.html
#   - 属性グループの管理: https://docs.aws.amazon.com/servicecatalog/latest/arguide/associate-attributes.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalogappregistry_attribute_group_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalogappregistry_attribute_group_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # application_id (Required)
  # 設定内容: 属性グループを関連付けるアプリケーションのIDを指定します。
  # 設定可能な値: 有効なAppRegistryアプリケーションのID
  # 関連機能: AWS Service Catalog AppRegistry
  #   アプリケーションとその関連リソースを定義・管理するサービス。
  #   アプリケーションにメタデータを付与し、組織全体でアプリケーションを
  #   検索・管理できるようにします。
  #   - https://docs.aws.amazon.com/servicecatalog/latest/arguide/what-is-appregistry.html
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: AppRegistryはリージョナルサービスです。同じリージョン内のアプリケーションと
  #       属性グループのみ関連付けることができます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースはエクスポートする読み取り専用属性はありません。
#
# 注意: リソースのIDは "application_id,attribute_group_id" の形式で
#       生成されます。
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存の属性グループ関連付けは以下のコマンドでインポートできます:
#
# terraform import aws_servicecatalogappregistry_attribute_group_association.example application_id,attribute_group_id
#
# 例:
# terraform import aws_servicecatalogappregistry_attribute_group_association.example 0ars38r6btoohvpvd9gqrptt9l,04ko3y60k1iegltqzqcsss60h
#---------------------------------------------------------------

#---------------------------------------------------------------
# 以下は、アプリケーション、属性グループ、および関連付けを含む
# 完全な使用例です。
#
# resource "aws_servicecatalogappregistry_application" "example" {
#---------------------------------------------------------------
