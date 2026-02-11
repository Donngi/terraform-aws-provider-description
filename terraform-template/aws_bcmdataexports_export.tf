#---------------------------------------------------------------
# AWS BCM Data Exports Export
#---------------------------------------------------------------
#
# AWS BCM Data Exportsのエクスポート設定をプロビジョニングするリソースです。
# Cost and Usage Report (CUR) 2.0データをS3バケットに定期的にエクスポートし、
# コスト分析・可視化・最適化に活用できます。
#
# AWS公式ドキュメント:
#   - AWS Data Exports概要: https://docs.aws.amazon.com/cur/latest/userguide/what-is-data-exports.html
#   - CUR 2.0テーブル辞書: https://docs.aws.amazon.com/cur/latest/userguide/table-dictionary-cur2.html
#   - データエクスポートの作成: https://docs.aws.amazon.com/cur/latest/userguide/cur-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bcmdataexports_export
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bcmdataexports_export" "example" {
  #-------------------------------------------------------------
  # エクスポート設定
  #-------------------------------------------------------------

  export {
    #-----------------------------------------------------------
    # 基本設定
    #-----------------------------------------------------------

    # name (Required)
    # 設定内容: データエクスポートの名前を指定します。
    # 設定可能な値: 一意の文字列
    # 用途: エクスポートを識別するための名前
    name = "my-cost-export"

    # description (Optional)
    # 設定内容: データエクスポートの説明を指定します。
    # 設定可能な値: 任意の文字列
    # 用途: エクスポートの目的や内容を記述
    description = "Daily cost and usage report export"

    #-----------------------------------------------------------
    # データクエリ設定
    #-----------------------------------------------------------

    data_query {
      # query_statement (Required)
      # 設定内容: エクスポートするデータを取得するSQLクエリを指定します。
      # 設定可能な値: SQL SELECT文。テーブル名は "COST_AND_USAGE_REPORT" を使用
      # 参考: 利用可能なカラム一覧は以下を参照
      #   - https://docs.aws.amazon.com/cur/latest/userguide/table-dictionary-cur2.html
      # 注意: CUR 2.0では125のカラムが利用可能で、13のカテゴリに分類されます
      #       (Bill, Cost category, Capacity reservation, Discount, Identity,
      #        Line item, Pricing, Product, Reservation, Resource tags,
      #        Savings plan, Split line item, Capacity Reservation)
      query_statement = "SELECT identity_line_item_id, identity_time_interval, line_item_product_code, line_item_unblended_cost FROM COST_AND_USAGE_REPORT"

      # table_configurations (Optional)
      # 設定内容: テーブル設定を指定します。クエリ実行前にデータやスキーマを変更できます。
      # 設定可能な値: テーブル名をキーとした設定のマップ
      # 設定項目:
      #   - TIME_GRANULARITY: 時間粒度 ("HOURLY", "DAILY", "MONTHLY")
      #   - INCLUDE_RESOURCES: リソースIDを含めるか ("TRUE", "FALSE")
      #   - INCLUDE_SPLIT_COST_ALLOCATION_DATA: 分割コスト配分データを含めるか ("TRUE", "FALSE")
      #   - INCLUDE_CAPACITY_RESERVATION_DATA: キャパシティ予約データを含めるか ("TRUE", "FALSE")
      #   - INCLUDE_MANUAL_DISCOUNT_COMPATIBILITY: 手動割引互換性を含めるか ("TRUE", "FALSE")
      #   - BILLING_VIEW_ARN: (必須) 請求ビューのARN
      # 参考: https://docs.aws.amazon.com/cur/latest/userguide/table-dictionary-cur2.html#cur2-table-configurations
      table_configurations = {
        COST_AND_USAGE_REPORT = {
          BILLING_VIEW_ARN                      = "arn:aws:billing::123456789012:billingview/primary"
          TIME_GRANULARITY                      = "HOURLY"
          INCLUDE_RESOURCES                     = "FALSE"
          INCLUDE_MANUAL_DISCOUNT_COMPATIBILITY = "FALSE"
          INCLUDE_SPLIT_COST_ALLOCATION_DATA    = "FALSE"
        }
      }
    }

    #-----------------------------------------------------------
    # 送信先設定
    #-----------------------------------------------------------

    destination_configurations {
      s3_destination {
        # s3_bucket (Required)
        # 設定内容: データエクスポートの送信先となるS3バケット名を指定します。
        # 設定可能な値: 有効なS3バケット名
        # 注意: バケットには適切なバケットポリシーが必要です
        s3_bucket = "my-cost-export-bucket"

        # s3_prefix (Required)
        # 設定内容: エクスポートファイル名の前に付加するS3プレフィックスを指定します。
        # 設定可能な値: 任意のパスプレフィックス文字列
        # 用途: エクスポートファイルの整理・分類に使用
        s3_prefix = "exports/cost-reports"

        # s3_region (Required)
        # 設定内容: S3バケットのリージョンを指定します。
        # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
        s3_region = "ap-northeast-1"

        #---------------------------------------------------------
        # S3出力設定
        #---------------------------------------------------------

        s3_output_configurations {
          # compression (Required)
          # 設定内容: データエクスポートの圧縮形式を指定します。
          # 設定可能な値:
          #   - "GZIP": GZIP圧縮
          #   - "PARQUET": Parquet形式（formatがPARQUETの場合に使用）
          compression = "GZIP"

          # format (Required)
          # 設定内容: データエクスポートのファイル形式を指定します。
          # 設定可能な値:
          #   - "TEXT_OR_CSV": テキスト/CSV形式
          #   - "PARQUET": Apache Parquet形式（カラムナ形式で効率的な分析向け）
          format = "TEXT_OR_CSV"

          # output_type (Required)
          # 設定内容: データエクスポートの出力タイプを指定します。
          # 設定可能な値:
          #   - "CUSTOM": カスタム出力（現在サポートされている唯一の値）
          output_type = "CUSTOM"

          # overwrite (Required)
          # 設定内容: データエクスポートファイルのバージョン管理ルールを指定します。
          # 設定可能な値:
          #   - "CREATE_NEW_REPORT": 新しいバージョンを作成（時系列での変化を追跡可能）
          #   - "OVERWRITE_REPORT": 既存レポートを上書き（S3ストレージコストを削減）
          # 用途: コストの変化を追跡したい場合はCREATE_NEW_REPORT、
          #       ストレージコストを抑えたい場合はOVERWRITE_REPORTを選択
          overwrite = "OVERWRITE_REPORT"
        }
      }
    }

    #-----------------------------------------------------------
    # 更新頻度設定
    #-----------------------------------------------------------

    refresh_cadence {
      # frequency (Required)
      # 設定内容: データエクスポートの更新頻度を指定します。
      # 設定可能な値:
      #   - "SYNCHRONOUS": ソースデータが更新されるたびにエクスポートを更新
      #                    （1日最大3回まで更新）
      # 関連機能: AWS Data Exports 更新頻度
      #   エクスポートはソースデータの更新に同期して更新されます。
      #   レポートの配信開始まで最大24時間かかる場合があります。
      frequency = "SYNCHRONOUS"
    }
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
    Name        = "my-cost-export"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    update = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: エクスポートのAmazon Resource Name (ARN)
#
# - export[0].export_arn: エクスポートのAmazon Resource Name (ARN)
#
# - id: (非推奨) エクスポートのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
