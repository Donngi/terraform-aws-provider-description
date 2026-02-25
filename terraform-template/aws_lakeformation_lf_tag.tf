#---------------------------------------------------------------
# AWS Lake Formation LF-Tag
#---------------------------------------------------------------
#
# AWS Lake FormationのLF-Tag（Lake Formationタグ）をプロビジョニングするリソースです。
# LF-Tagはキーと値のペアで構成され、データカタログリソース（データベース・テーブル・カラム）に
# 割り当てることで、タグベースのアクセス制御（LF-TBAC）を実現します。
# 各タグキーには最低1つの値が必要で、最大1000個の値を設定できます。
#
# AWS公式ドキュメント:
#   - LF-Tagの管理: https://docs.aws.amazon.com/lake-formation/latest/dg/managing-tags.html
#   - タグベースアクセス制御のベストプラクティス: https://docs.aws.amazon.com/lake-formation/latest/dg/lf-tag-considerations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_lf_tag
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lakeformation_lf_tag" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # key (Required)
  # 設定内容: LF-Tagのキー名を指定します。
  # 設定可能な値: 1〜128文字の文字列。LF-Tagキーと値は50文字以内が推奨されます。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/managing-tags.html
  key = "module"

  # values (Required)
  # 設定内容: LF-Tagが取り得る値のリストを指定します。
  # 設定可能な値: 文字列のセット。最大1000個の値を設定可能。各値は50文字以内が推奨されます。
  # 注意: データカタログリソースへの割り当て時は、このリストに含まれる値のいずれかが使用されます。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/managing-tags.html
  values = ["Orders", "Sales", "Customers"]

  #-------------------------------------------------------------
  # カタログ設定
  #-------------------------------------------------------------

  # catalog_id (Optional)
  # 設定内容: LF-Tagを作成するデータカタログのIDを指定します。
  # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
  # 省略時: プロバイダーに設定されたAWSアカウントIDが使用されます。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/managing-tags.html
  catalog_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: データカタログIDとLF-TagキーをコロンでつないだID（例: 123456789012:module）
#---------------------------------------------------------------
