#---------------------------------------------------------------
# AWS Main Route Table Association
#---------------------------------------------------------------
#
# VPC のメインルートテーブルを設定するリソースです。
# VPC 作成時にデフォルトで作成されるメインルートテーブルを、
# カスタムルートテーブルに置き換えることができます。
# サブネットが明示的にルートテーブルと関連付けられていない場合、
# メインルートテーブルが自動的に使用されます。
#
# 主な用途:
#   - VPC のデフォルトルーティング動作をカスタマイズ
#   - 明示的な関連付けを持たないサブネットのルーティングを一元管理
#   - セキュリティ要件に合わせたデフォルトルーティングポリシーの実装
#
# 注意事項:
#   - VPC ごとに 1 つのメインルートテーブルのみ設定可能
#   - メインルートテーブルの変更は既存の暗黙的な関連付けに影響を与えます
#   - 明示的にサブネットと関連付けられたルートテーブルには影響しません
#
# AWS公式ドキュメント:
#   - VPC ルートテーブル概要: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html
#   - メインルートテーブルの置き換え: https://docs.aws.amazon.com/vpc/latest/userguide/Route_Replacing_Main_Table.html
#   - ReplaceRouteTableAssociation API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ReplaceRouteTableAssociation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_main_route_table_association" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: メインルートテーブルを設定する VPC の ID を指定します。
  # 設定可能な値: VPC ID (例: "vpc-xxxxxxxxxxxxxxxxx")
  # 注意:
  #   - 指定した VPC に対してメインルートテーブルの関連付けが変更されます
  #   - VPC ごとに 1 つのメインルートテーブルのみ設定可能です
  # 関連リソース: aws_vpc
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/configure-your-vpc.html
  vpc_id = "vpc-xxxxxxxxxxxxxxxxx"

  # route_table_id (Required)
  # 設定内容: VPC のメインルートテーブルとして設定するルートテーブルの ID を指定します。
  # 設定可能な値: ルートテーブル ID (例: "rtb-xxxxxxxxxxxxxxxxx")
  # 動作:
  #   - 指定したルートテーブルが VPC の新しいメインルートテーブルになります
  #   - 明示的な関連付けを持たない全サブネットがこのルートテーブルを使用します
  # 注意:
  #   - このルートテーブルは同じ VPC 内に存在する必要があります
  #   - 変更は既存の暗黙的な関連付けに即座に影響します
  # 関連リソース: aws_route_table
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/WorkWithRouteTables.html
  route_table_id = "rtb-xxxxxxxxxxxxxxxxx"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースの一意な識別子です。
  # 動作: 通常は明示的に設定せず、Terraform が自動的に割り当てます。
  # 参照: このリソースの ID は他のリソースから参照可能です。
  # 例: aws_main_route_table_association.example.id
  # id = null

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意:
  #   - VPC が存在するリージョンと同じリージョンを指定する必要があります
  #   - リージョンの変更はリソースの再作成が必要です
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を指定します。
  # 用途: 大規模な VPC 環境や API レート制限が懸念される場合に調整します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: "5m" などの duration 文字列
    # デフォルト: Terraform のデフォルト値（通常 20 分）
    # 推奨値: 通常は 5 分で十分です
    create = "5m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウトを指定します。
    # 設定可能な値: "5m" などの duration 文字列
    # デフォルト: Terraform のデフォルト値（通常 20 分）
    # 推奨値: 通常は 5 分で十分です
    update = "5m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 設定可能な値: "5m" などの duration 文字列
    # デフォルト: Terraform のデフォルト値（通常 20 分）
    # 推奨値: 通常は 5 分で十分です
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: メインルートテーブル関連付けの ID
#       形式: "rtbassoc-xxxxxxxxxxxxxxxxx"
#       用途: 他のリソースから参照する際に使用
#
# - original_route_table_id: VPC の元のメインルートテーブルの ID
#       形式: "rtb-xxxxxxxxxxxxxxxxx"
#       用途: メインルートテーブルを変更する前の元のルートテーブル ID を保持
#       注意: この値を使用して、必要に応じて元の状態に戻すことができます
#
# - region: このリソースが管理されているリージョン
#       形式: AWS リージョンコード（例: "ap-northeast-1"）
#       用途: リソースのリージョンを動的に参照する際に使用
#

#---------------------------------------------------------------
# ユースケース例
#---------------------------------------------------------------
#
# 1. セキュアなデフォルトルーティング
#    - インターネットゲートウェイへのルートを含まないルートテーブルを
#---------------------------------------------------------------
