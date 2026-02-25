#---------------------------------------------------------------
# AWS Resource Explorer View
#---------------------------------------------------------------
#
# AWS Resource Explorerのビューをプロビジョニングするリソースです。
# ビューは検索クエリで返されるリソースの範囲を定義し、
# 検索フィルターやオプション属性の設定によって検索結果を制御します。
# ビューはAWSリージョンごとに一意である必要があります。
#
# AWS公式ドキュメント:
#   - Resource Explorerビュー作成: https://docs.aws.amazon.com/resource-explorer/latest/userguide/configure-views-create.html
#   - 検索クエリ構文リファレンス: https://docs.aws.amazon.com/resource-explorer/latest/userguide/using-search-query-syntax.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourceexplorer2_view
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_resourceexplorer2_view" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ビューの名前を指定します。
  # 設定可能な値: 最大64文字。英字・数字・ハイフン（-）が使用可能。
  #               同一AWSリージョン内で一意である必要があります。
  name = "example-view"

  #-------------------------------------------------------------
  # デフォルトビュー設定
  #-------------------------------------------------------------

  # default_view (Optional)
  # 設定内容: このビューをAWSリージョンのデフォルトビューに設定するかを指定します。
  # 設定可能な値:
  #   - true: このビューをデフォルトビューとして設定
  #   - false: デフォルトビューとして設定しない
  # 省略時: false
  # 参考: https://docs.aws.amazon.com/resource-explorer/latest/userguide/manage-views-about.html#manage-views-about-default
  default_view = false

  #-------------------------------------------------------------
  # スコープ設定
  #-------------------------------------------------------------

  # scope (Optional)
  # 設定内容: ビューの検索対象スコープを指定します。
  # 設定可能な値:
  #   - AWSアカウントARN（例: arn:aws:iam::123456789012:root）: 単一アカウント
  #   - AWS Organizationsの組織ARN: 組織全体
  # 省略時: プロバイダーで設定されているアカウントのリソースのみが対象
  scope = null

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
  # フィルター設定
  #-------------------------------------------------------------

  # filters (Optional)
  # 設定内容: このビューを使用した検索クエリの結果に含めるリソースを絞り込むフィルターを指定します。
  # 検索クエリとフィルターは論理ANDで評価されます。
  # 関連機能: Resource Explorer 検索フィルター
  #   検索キーワード・プレフィックス・演算子を組み合わせて対象リソースを絞り込む機能。
  #   - https://docs.aws.amazon.com/resource-explorer/latest/userguide/using-search-query-syntax.html
  filters {

    # filter_string (Required)
    # 設定内容: 検索に含めるリソースを制御するキーワード・プレフィックス・演算子の文字列を指定します。
    # 設定可能な値: 0〜2048文字の検索クエリ文字列。
    #               フィルター名（例: resourcetype:, region:, tag:, service: 等）と値の組み合わせ
    # 参考: https://docs.aws.amazon.com/resource-explorer/latest/apireference/API_SearchFilter.html
    filter_string = "resourcetype:ec2:instance"
  }

  #-------------------------------------------------------------
  # 追加プロパティ設定
  #-------------------------------------------------------------

  # included_property (Optional)
  # 設定内容: このビューの検索結果に含めるオプションのリソース属性フィールドを指定します。
  # 複数のブロックを記述することで複数のプロパティを追加できます。
  included_property {

    # name (Required)
    # 設定内容: 検索結果に含めるプロパティ名を指定します。
    # 設定可能な値:
    #   - "tags": リソースに付与されたタグ情報を検索結果に含める
    name = "tags"
  }

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
    Name        = "example-view"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Resource ExplorerビューのAmazon Resource Name (ARN)
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
