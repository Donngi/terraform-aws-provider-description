################################################################################
# aws_dataexchange_revision
#
# Terraform AWS Provider リソース：aws_dataexchange_revision
# 生成日: 2026-01-19
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点での情報です。
# 最新の仕様は公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dataexchange_revision
################################################################################

resource "aws_dataexchange_revision" "example" {
  # ============================================================================
  # 必須パラメータ
  # ============================================================================

  # data_set_id - (必須) データセットのID
  # このリビジョンが属するデータセットのIDを指定します。
  # AWS Data Exchangeでは、データセットは関連するデータのコレクションを表し、
  # リビジョンはそのデータセットの更新やバージョンを表します。
  #
  # 参考: https://docs.aws.amazon.com/data-exchange/latest/userguide/data-sets.html
  data_set_id = "ds-1234567890abcdef0"

  # ============================================================================
  # オプションパラメータ
  # ============================================================================

  # comment - (オプション) リビジョンに関するオプションのコメント
  # リビジョンの目的や内容を説明するコメントを指定できます。
  # 履歴データを含むリビジョンの場合、コメントでリビジョンの目的を示すことが推奨されます。
  #
  # 参考: https://docs.aws.amazon.com/data-exchange/latest/userguide/dynamically-updated-products.html
  comment = "Initial revision with historical data"

  # id - (オプション) リソースID
  # Terraformによって自動的に管理されるリソースの一意識別子です。
  # 通常は明示的に設定する必要はありません。
  # 計算値: データセットのID
  # id = "example-id"

  # region - (オプション) リソースを管理するAWSリージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 未指定の場合、プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # AWS Data Exchangeは複数のリージョンで利用可能ですが、1つの製品内のすべてのデータセットは
  # 同じリージョンに存在する必要があります。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags - (オプション) リソースに割り当てるタグのマップ
  # キーと値のペアでリソースにメタデータを付与できます。
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーを持つタグはここで指定した値で上書きされます。
  #
  # 注意: 所有するデータセットとそのリビジョンにはタグを追加できますが、
  # エンタイトルされたデータセット（サブスクライブしたデータセット）にはタグを追加できません。
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-dataexchange-revision"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all - (オプション/計算値) リソースに割り当てられたすべてのタグ
  # プロバイダーの default_tags から継承されたタグを含む、すべてのタグのマップです。
  # この属性は自動的に管理されるため、通常は明示的に設定する必要はありません。
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags_all = {}

  # ============================================================================
  # 計算値属性（Computed Only - テンプレートでは設定不可）
  # ============================================================================
  # 以下の属性はAWSによって自動的に計算され、読み取り専用です。
  # Terraformの outputs や他のリソースの参照として利用できます。
  #
  # - arn: このデータセットのAmazon Resource Name (ARN)
  #   例: aws_dataexchange_revision.example.arn
  #
  # - revision_id: リビジョンのID
  #   例: aws_dataexchange_revision.example.revision_id
  #
  # 参考: https://docs.aws.amazon.com/data-exchange/latest/userguide/data-sets.html
}

################################################################################
# 使用例
################################################################################

# データセットの作成例
# resource "aws_dataexchange_data_set" "example" {
#   asset_type  = "S3_SNAPSHOT"
#   description = "Example data set for demonstrating revisions"
#   name        = "example-dataset"
# }

# リビジョンの作成
# resource "aws_dataexchange_revision" "example" {
#   data_set_id = aws_dataexchange_data_set.example.id
#   comment     = "First revision with baseline data"
#
#   tags = {
#     Name = "baseline-revision"
#   }
# }

################################################################################
# 補足情報
################################################################################

# AWS Data Exchangeの主要な構成要素:
# 1. Assets（アセット）: AWS Data Exchange内の実際のデータ
#    - ファイル、API、Amazon Redshift データセット、AWS Lake Formationデータ権限など
#
# 2. Revisions（リビジョン）: 1つ以上のアセットを含むコンテナ
#    - Amazon S3内のデータを更新するために使用
#    - データセットの特定のバージョンを表す
#
# 3. Data Sets（データセット）: 時間とともに変化する可能性のあるデータのコレクション
#    - Files、API、Amazon Redshift、S3 data access、AWS Lake Formationの各タイプが存在
#
# リビジョンの更新戦略:
# - 変更された項目のみを更新
# - 完全に更新されたファイルで更新
# - 全履歴と更新されたデータで更新
#
# 参考リンク:
# - AWS Data Exchange ユーザーガイド: https://docs.aws.amazon.com/data-exchange/latest/userguide/
# - リビジョンの公開: https://docs.aws.amazon.com/data-exchange/latest/userguide/dynamically-updated-products.html
# - データセットの管理: https://docs.aws.amazon.com/data-exchange/latest/userguide/data-sets.html
