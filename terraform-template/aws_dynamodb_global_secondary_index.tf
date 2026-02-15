#--------------------------------------------------------------
# DynamoDB Global Secondary Index
#--------------------------------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/dynamodb_global_secondary_index
#
# NOTE:
# DynamoDBテーブルにグローバルセカンダリインデックス（GSI）を追加
# 異なるパーティションキー/ソートキーで効率的なクエリを可能にする
#
# 主な機能:
# - テーブルとは異なるキースキーマの定義
# - 射影（Projection）による属性の選択的コピー
# - On-DemandまたはProvisionedスループットの個別設定
# - Warm Throughputによる事前ウォーミング対応
#
# 参考: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GSI.html
#--------------------------------------------------------------

resource "aws_dynamodb_global_secondary_index" "example" {
  #-------
  # 基本設定
  #-------
  # 設定内容: 対象となるDynamoDBテーブルの名前
  # 省略時: 省略不可（必須）
  table_name = "my-table"

  # 設定内容: グローバルセカンダリインデックスの名前
  # 省略時: 省略不可（必須）
  # 制約: 3〜255文字、テーブル内で一意である必要がある
  index_name = "my-gsi"

  #-------
  # キースキーマ設定
  #-------
  # 設定内容: インデックスのキースキーマを定義
  # 省略時: 省略不可（必須）
  # 構成: 1個以上のkey_schemaブロックが必要（パーティションキーは必須、ソートキーはオプション）
  key_schema {
    # 設定内容: キー属性の名前
    # 省略時: 省略不可（必須）
    attribute_name = "user_id"

    # 設定内容: 属性のデータ型
    # 省略時: 省略不可（必須）
    # 設定可能な値: S（文字列）、N（数値）、B（バイナリ）
    attribute_type = "S"

    # 設定内容: キーの種類
    # 省略時: 省略不可（必須）
    # 設定可能な値: HASH（パーティションキー）、RANGE（ソートキー）
    key_type = "HASH"
  }

  # ソートキーを追加する場合（オプション）
  # key_schema {
  #   attribute_name = "timestamp"
  #   attribute_type = "N"
  #   key_type       = "RANGE"
  # }

  #-------
  # 射影（Projection）設定
  #-------
  # 設定内容: インデックスにコピーする属性を指定
  # 省略時: 省略不可（必須）
  projection {
    # 設定内容: 射影タイプ
    # 省略時: 省略不可（必須）
    # 設定可能な値:
    # - ALL: テーブルのすべての属性をコピー（ストレージコスト増）
    # - KEYS_ONLY: キー属性のみコピー（ストレージコスト最小）
    # - INCLUDE: 指定した属性のみコピー（柔軟性とコストのバランス）
    projection_type = "ALL"

    # 設定内容: INCLUDEタイプ時に追加でコピーする属性のリスト
    # 省略時: projection_typeがINCLUDEの場合は必須、それ以外は不要
    # non_key_attributes = ["email", "created_at"]
  }

  #-------
  # スループット設定（On-Demand）
  #-------
  # 設定内容: オンデマンドスループットの最大値を設定
  # 省略時: provisioned_throughputを使用するか、テーブルの課金モードに従う
  # 注意: on_demand_throughputとprovisioned_throughputは同時に設定できない
  # on_demand_throughput {
  #   # 設定内容: 最大読み込みリクエストユニット数
  #   # 省略時: AWSが自動で管理
  #   max_read_request_units = 1000
  #
  #   # 設定内容: 最大書き込みリクエストユニット数
  #   # 省略時: AWSが自動で管理
  #   max_write_request_units = 1000
  # }

  #-------
  # スループット設定（Provisioned）
  #-------
  # 設定内容: プロビジョンドスループットの容量を設定
  # 省略時: on_demand_throughputを使用するか、テーブルの課金モードに従う
  # 注意: on_demand_throughputとprovisioned_throughputは同時に設定できない
  # provisioned_throughput {
  #   # 設定内容: プロビジョンド読み込みキャパシティユニット数
  #   # 省略時: AWSが自動で管理
  #   read_capacity_units = 5
  #
  #   # 設定内容: プロビジョンド書き込みキャパシティユニット数
  #   # 省略時: AWSが自動で管理
  #   write_capacity_units = 5
  # }

  #-------
  # Warm Throughput設定
  #-------
  # 設定内容: 事前ウォーミングによるスループットのベースライン設定
  # 省略時: 履歴ベースの自動調整のみ（追加料金なし）
  # 用途: ピークイベント前の事前準備、瞬時対応可能なリクエストレート向上
  warm_throughput = {
    # 設定内容: 秒あたりの読み込みユニット数
    # 省略時: 履歴データに基づく自動設定
    read_units_per_second = 1000

    # 設定内容: 秒あたりの書き込みユニット数
    # 省略時: 履歴データに基づく自動設定
    write_units_per_second = 1000
  }

  #-------
  # リージョン設定
  #-------
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  region = "ap-northeast-1"

  #-------
  # タイムアウト設定
  #-------
  # 設定内容: 各操作のタイムアウト時間
  # 省略時: デフォルトのタイムアウト値を使用
  # timeouts {
  #   # 設定内容: インデックス作成のタイムアウト
  #   # 省略時: デフォルト値
  #   # 設定可能な値: "30s"、"5m"、"1h" など（数値 + 単位）
  #   create = "10m"
  #
  #   # 設定内容: インデックス更新のタイムアウト
  #   # 省略時: デフォルト値
  #   # 設定可能な値: "30s"、"5m"、"1h" など（数値 + 単位）
  #   update = "10m"
  #
  #   # 設定内容: インデックス削除のタイムアウト
  #   # 省略時: デフォルト値
  #   # 設定可能な値: "30s"、"5m"、"1h" など（数値 + 単位）
  #   delete = "10m"
  # }
}

#--------------------------------------------------------------
# Attributes Reference
#--------------------------------------------------------------
# arn - インデックスのARN
