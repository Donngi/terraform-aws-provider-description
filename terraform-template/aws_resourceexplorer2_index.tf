#---------------------------------------------------------------
# AWS Resource Explorer Index
#---------------------------------------------------------------
#
# AWS Resource Explorerの現在のAWSリージョンにインデックスを管理するリソースです。
# Resource Explorerは、AWSアカウント全体のリソースを検索および発見するための
# サービスです。インデックスを作成することで、リソースを検索可能にし、
# 複数リージョンにわたるリソース管理を効率化できます。
#
# AWS公式ドキュメント:
#   - Resource Explorer概要: https://docs.aws.amazon.com/resource-explorer/latest/userguide/welcome.html
#   - LOCALとAGGREGATORの違い: https://docs.aws.amazon.com/resource-explorer/latest/userguide/manage-aggregator-region.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourceexplorer2_index
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_resourceexplorer2_index" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # type (Required)
  # 設定内容: インデックスのタイプを指定します。
  # 設定可能な値:
  #   - "LOCAL": ローカルインデックス - このリージョンのリソースのみをインデックス化
  #   - "AGGREGATOR": 集約インデックス - 全リージョンのローカルインデックスからリソース情報を集約
  # 注意:
  #   - LOCALインデックスは各リージョンに作成でき、そのリージョンのリソースのみを検索可能にします
  #   - AGGREGATORインデックスは1つのアカウントにつき1つのリージョンのみに作成でき、
  #     全リージョンのリソースを一元的に検索可能にします
  #   - AGGREGATORを使用する場合、他のリージョンにもLOCALインデックスが必要です
  # 関連機能: Resource Explorer インデックスタイプ
  #   - LOCALインデックスはリージョナルなリソース検索に適しています
  #   - AGGREGATORインデックスはマルチリージョン環境での一元管理に適しています
  #   - https://docs.aws.amazon.com/resource-explorer/latest/userguide/manage-aggregator-region.html
  type = "LOCAL"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1, eu-west-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意:
  #   - 各リージョンには1つのインデックスのみ作成できます
  #   - AGGREGATORインデックスは、全リージョンのリソース情報を集約するため、
  #     適切な中心リージョンを選択することを推奨します
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
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-resource-explorer-index"
    Environment = "production"
    Purpose     = "resource-discovery"
  }

  #-------------------------------------------------------------
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------
  # Resource Explorerインデックスの作成、更新、削除操作のタイムアウトを設定できます。

  # timeouts {
  #   # create (Optional)
  #   # 設定内容: インデックス作成操作のタイムアウト時間を指定します。
  #   # 設定可能な値: Go言語の時間表現（例: "30s", "2h45m", "10m"）
  #   # 単位: "s"（秒）、"m"（分）、"h"（時間）
  #   # 省略時: デフォルトのタイムアウト値が適用されます
  #   create = "10m"
  #
  #   # update (Optional)
  #   # 設定内容: インデックス更新操作のタイムアウト時間を指定します。
  #   # 設定可能な値: Go言語の時間表現（例: "30s", "2h45m", "10m"）
  #   # 単位: "s"（秒）、"m"（分）、"h"（時間）
  #   # 省略時: デフォルトのタイムアウト値が適用されます
  #   update = "10m"
  #
  #   # delete (Optional)
  #   # 設定内容: インデックス削除操作のタイムアウト時間を指定します。
  #   # 設定可能な値: Go言語の時間表現（例: "30s", "2h45m", "10m"）
  #   # 単位: "s"（秒）、"m"（分）、"h"（時間）
  #   # 注意: タイムアウトを設定できるのは、destroy操作前に状態に変更が保存される場合のみです
  #   # 省略時: デフォルトのタイムアウト値が適用されます
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Resource ExplorerインデックスのAmazon Resource Name (ARN)
#
# - id: (非推奨) インデックスのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# AGGREGATORインデックスを作成する場合の例です。
# 1つのアカウントにつき1つのリージョンにのみ作成できます。
#
# resource "aws_resourceexplorer2_index" "aggregator" {
#   type = "AGGREGATOR"
#
#   tags = {
#     Name        = "global-resource-explorer-aggregator"
#     Environment = "production"
#     Type        = "aggregator"
#   }
#---------------------------------------------------------------
