#-----------------------------------------------------------------------
# AWS DataExchange Revision Assets
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dataexchange_revision_assets
#
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dataexchange_revision_assets
# Generated: 2026-02-13
#
# NOTE: このテンプレートはAWS Provider 6.28.0のスキーマに基づいて生成されています。
#       実際の使用時は、必要な属性のみコメントを外して使用してください。
#-----------------------------------------------------------------------
# AWS Data Exchangeデータセットのリビジョンにアセット（S3オブジェクト等）を追加・管理するリソース。
# S3バケットからのインポート、データアクセスポイント経由の作成、SignedURLによるアップロードが可能。
# ドキュメント: https://docs.aws.amazon.com/data-exchange/
#
# 主な機能:
# - S3バケットからの単一オブジェクトインポート
# - S3データアクセスポイント経由のアセット作成（プレフィックス/キー指定）
# - SignedURLを使用したアセットインポート
# - リビジョンのファイナライズとバージョン管理
# - KMSキーによるアセット暗号化サポート
#
# 注意事項:
# - リビジョンファイナライズ後はアセット追加不可
# - force_destroy=trueでリビジョン削除時に全アセット削除
# - アセットタイプ（import_assets_from_s3 / create_s3_data_access_from_s3_bucket / import_assets_from_signed_url）は排他的
# - key_prefixesとkeysは同時指定不可（create_s3_data_access_from_s3_bucket内）
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------
resource "aws_dataexchange_revision_assets" "example" {
  #-----------------------------------------------------------------------
  # データセット識別
  #-----------------------------------------------------------------------
  # 設定内容: アセットを追加するData Exchangeデータセットの一意ID
  # 設定可能な値: データセットID（ds-xxxxxxxxxxxxx形式）
  data_set_id = "ds-1234567890abcdef0"

  #-----------------------------------------------------------------------
  # リビジョン制御
  #-----------------------------------------------------------------------
  # 設定内容: リビジョンの目的や変更内容を説明するメモ
  # 設定可能な値: 最大16384文字の文字列
  # 省略時: コメントなし
  comment = "2024年Q1データ更新 - 新規顧客セグメント追加"

  # 設定内容: リビジョンを確定してアセット追加を禁止するか
  # 設定可能な値: true（確定）/ false（編集可）
  # 省略時: false（編集可能状態）
  # 備考: ファイナライズ後は新規アセット追加不可、購読者への配信が可能になる
  finalized = true

  # 設定内容: リビジョン削除時に全アセットを強制削除するか
  # 設定可能な値: true（強制削除）/ false（保護）
  # 省略時: false（アセット存在時は削除エラー）
  # 備考: 本番環境では慎重に使用（誤削除防止）
  force_destroy = false

  #-----------------------------------------------------------------------
  # アセット定義（3種類のいずれか1つを使用）
  #-----------------------------------------------------------------------

  # パターン1: S3バケットからの単一オブジェクトインポート
  # ユースケース: 個別CSVファイルやParquetファイルをアセットとして追加
  asset {
    import_assets_from_s3 {
      asset_source {
        # 設定内容: アセットソースとなるS3バケットの名前
        bucket = "my-dataexchange-source-bucket"

        # 設定内容: インポートする個別オブジェクトのフルパス
        key = "datasets/customer-data/2024-Q1/customers.csv"
      }
    }
  }

  # パターン2: S3データアクセスポイント経由のアセット作成
  # ユースケース: プレフィックス単位で複数ファイルをまとめてアセット化
  # asset {
  #   create_s3_data_access_from_s3_bucket {
  #     asset_source {
  #       # 設定内容: Data Exchangeアクセスポイントを作成するバケット
  #       bucket = "my-dataexchange-source-bucket"
  #
  #       # 設定内容: アクセス対象とするプレフィックスのセット
  #       # 設定可能な値: 最大100個のプレフィックス文字列
  #       # 備考: keysとの同時指定不可
  #       key_prefixes = [
  #         "datasets/customer-data/2024-Q1/",
  #         "datasets/customer-data/2024-Q2/"
  #       ]
  #
  #       # 設定内容: アクセス対象とする個別オブジェクトキーのセット
  #       # 設定可能な値: 最大100個のオブジェクトキー
  #       # 備考: key_prefixesとの同時指定不可
  #       keys = [
  #         "datasets/summary/2024-annual-report.pdf",
  #         "datasets/summary/2024-quarterly-metrics.xlsx"
  #       ]
  #
  #       # KMSキー許可設定（暗号化バケット使用時）
  #       kms_keys_to_grant {
  #         # 設定内容: Data Exchange購読者に暗号化解除権限を付与するKMSキーのARN
  #         kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-b456-c789-d0123456789e"
  #       }
  #     }
  #   }
  # }

  # パターン3: SignedURL経由のアセットインポート
  # ユースケース: 外部システムからHTTPアップロードでアセット追加
  # asset {
  #   import_assets_from_signed_url {
  #     # 設定内容: アップロードされるファイルの名前（拡張子含む）
  #     filename = "external-data-feed.json"
  #   }
  # }

  # 複数アセット登録例（同一タイプのみ）
  # asset {
  #   import_assets_from_s3 {
  #     asset_source {
  #       bucket = "my-dataexchange-source-bucket"
  #       key = "datasets/product-catalog/products.parquet"
  #     }
  #   }
  # }
  #
  # asset {
  #   import_assets_from_s3 {
  #     asset_source {
  #       bucket = "my-dataexchange-source-bucket"
  #       key = "datasets/product-catalog/product-images.zip"
  #     }
  #   }
  # }

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------
  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョン
  # 備考: Data Exchangeは特定リージョンのみ利用可能（us-east-1等）
  region = "us-east-1"

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------
  # 設定内容: リビジョンに付与する任意のキーバリューペアタグ
  # 設定可能な値: タグキーと値のマップ
  # 省略時: タグなし
  # 備考: コスト配分、アクセス制御、運用管理に使用
  tags = {
    Name        = "customer-data-revision-2024q1"
    Environment = "production"
    DataOwner   = "analytics-team"
    Version     = "1.0.0"
    Compliance  = "GDPR"
  }

  #-----------------------------------------------------------------------
  # タイムアウト設定
  #-----------------------------------------------------------------------
  # 設定内容: リソース作成処理の最大待機時間
  # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
  # 省略時: Terraformデフォルト
  # 備考: 大容量アセットのインポート時は長めに設定
  timeouts {
    create = "10m"
  }
}

#-----------------------------------------------------------------------
# Attributes Reference（参照専用属性）
#-----------------------------------------------------------------------
# リビジョン属性:
#   arn         - リビジョンのARN
#   id          - リビジョンID（rev-xxxxxxxxxxxxx形式）
#   created_at  - リビジョン作成日時（RFC3339形式）
#   updated_at  - リビジョン最終更新日時
#   tags_all    - デフォルトタグとリソースタグのマージ結果
#
# アセット属性（各assetブロック内）:
#   arn        - アセットのARN
#   id         - アセットID（asset-xxxxxxxxxxxxx形式）
#   name       - アセット名（ファイル名やプレフィックス由来）
#   created_at - アセット作成日時
#   updated_at - アセット最終更新日時
#
# S3アクセスポイント属性（create_s3_data_access_from_s3_bucketブロック内）:
#   access_point_arn   - 作成されたS3アクセスポイントのARN
#   access_point_alias - アクセスポイントのエイリアス名
#-----------------------------------------------------------------------
