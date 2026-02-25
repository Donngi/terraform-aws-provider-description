#---------------------------------------------------------------
# AWS Service Catalog Tag Option Resource Association
#---------------------------------------------------------------
#
# AWS Service CatalogのタグオプションとリソースのAssociationをプロビジョニングします。
# リソースとはService Catalogのポートフォリオまたは製品を指します。
# タグオプションを関連付けることで、製品起動時に一貫したタグ付けを強制できます。
#
# AWS公式ドキュメント:
#   - AWS Service Catalog TagOption Library: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/tagoptions.html
#   - Managing TagOptions: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/tagoptions-manage.html
#   - AssociateTagOptionWithResource API: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_AssociateTagOptionWithResource.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_tag_option_resource_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalog_tag_option_resource_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # resource_id (Required)
  # 設定内容: 関連付け対象のリソース識別子を指定します。
  # 設定可能な値: Service Catalogポートフォリオまたは製品のID文字列（例: prod-dnigbtea24ste）
  resource_id = "prod-dnigbtea24ste"

  # tag_option_id (Required)
  # 設定内容: 関連付けるタグオプションの識別子を指定します。
  # 設定可能な値: Service Catalog TagOptionのID文字列（例: tag-pjtvyakdlyo3m）
  tag_option_id = "tag-pjtvyakdlyo3m"

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
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト期間を指定します。
  # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
  timeouts {
    # create (Optional)
    # 設定内容: タグオプション関連付け作成操作のタイムアウト時間を指定します。
    # 省略時: デフォルトのタイムアウト値を使用
    create = null

    # read (Optional)
    # 設定内容: タグオプション関連付け読み取り操作のタイムアウト時間を指定します。
    # 省略時: デフォルトのタイムアウト値を使用
    read = null

    # delete (Optional)
    # 設定内容: タグオプション関連付け削除操作のタイムアウト時間を指定します。
    # 省略時: デフォルトのタイムアウト値を使用
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 関連付けの識別子
# - resource_arn: 関連付けられたリソースのARN
# - resource_created_time: リソースの作成日時
# - resource_description: リソースの説明
# - resource_name: リソースの名前
#---------------------------------------------------------------
