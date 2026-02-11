#---------------------------------------------------------------
# AWS S3 Tables - Table Replication
#---------------------------------------------------------------
#
# Amazon S3 Tablesのテーブルレプリケーション設定を管理するリソースです。
# S3 Tablesレプリケーションは、Apache Icebergテーブルを別のテーブルバケットに
# 自動的にレプリケートする機能で、同一リージョン内、複数リージョン間、
# 同一アカウント内、または別のAWSアカウントへのレプリケーションをサポートします。
#
# 主な機能:
# - 読み取り専用レプリカの作成
# - スナップショット、メタデータ、データファイルの一貫性保持
# - 複数のレプリケーション先(最大5つ)への対応
# - 独立したスナップショット保持期間の設定
# - 低コストのストレージティアでのレプリカテーブル維持
#
# ユースケース:
# - 地理的に近いリージョンで読み取りレプリカを維持してレイテンシーを最小化
# - コンプライアンス要件を満たすための特定リージョンやアカウントでのレプリカ維持
# - リージョン固有のデータセットを中央リージョンにレプリケートして分析を集約
# - テストや開発環境用の読み取りレプリカの作成
#
# AWS公式ドキュメント:
#   - S3 Tablesレプリケーション概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-replication-tables.html
#   - レプリケーション設定: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-replication-setting-up.html
#   - レプリケーションの仕組み: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-replication-how-replication-works.html
#   - API リファレンス: https://docs.aws.amazon.com/AmazonS3/latest/API/API_s3Buckets_TableReplicationConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3tables_table_replication
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3tables_table_replication" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # table_arn (Required, Forces new resource)
  # 設定内容: このレプリケーション設定を所有するテーブルのARNを指定します。
  # 設定可能な値: 有効なS3 TablesテーブルのARN
  # 形式: arn:aws:s3tables:region:account-id:bucket/table-bucket-name/table/table-name
  # 注意: リソース作成後の変更はできません（Forces new resource）
  table_arn = aws_s3tables_table.example.arn

  # role (Required)
  # 設定内容: S3がテーブルをレプリケートする際に引き受けるIAMロールのARNを指定します。
  # 設定可能な値: IAMロールのARN
  # 形式: arn:aws:iam::account-id:role/role-name
  # 長さ制約: 最小20文字、最大2048文字
  # パターン: arn:.+:iam::[0-9]{12}:role/.+
  # 必要な権限:
  #   - s3tables:GetTable
  #   - s3tables:GetTableMetadata
  #   - s3tables:GetTableMetadataLocation
  #   - s3tables:PutTable
  #   - s3tables:PutTableMetadata
  #   - s3tables:CreateTable (初回レプリケーション時)
  #   - s3:GetObject (ソーステーブルバケットから)
  #   - s3:PutObject (宛先テーブルバケットへ)
  # 関連機能: IAMロールとS3 Tablesレプリケーション
  #   レプリケーションロールは、ソーステーブルからデータを読み取り、
  #   宛先テーブルバケットにレプリカを作成するための権限が必要です。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-replication-setting-up.html#s3-tables-replication-iam-role
  role = aws_iam_role.example.arn

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: リージョナルエンドポイント
  #   S3 Tablesはリージョナルサービスで、テーブルは特定のリージョンに存在します。
  #   クロスリージョンレプリケーションを行う場合、各リージョンでリソースを管理します。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # レプリケーションルール設定
  #-------------------------------------------------------------

  # rule (Optional)
  # 設定内容: レプリケーションルールを定義するブロックです。
  # テーブルをどこにレプリケートするかを定義します。
  # 注意: 現在のS3 Tablesでは、1つのテーブルにつき1つのルールのみサポートされています。
  #       各ルールには最大5つの宛先テーブルバケットを指定できます。
  rule {
    #-----------------------------------------------------------
    # レプリケーション先設定 (destination)
    #-----------------------------------------------------------
    # 設定内容: レプリケーション先のテーブルバケットを指定します。
    # 注意: destinationブロックは1つのrule内に最大5つまで指定できます
    destination {
      # destination_table_bucket_arn (Required)
      # 設定内容: レプリカテーブルを作成する宛先テーブルバケットのARNを指定します。
      # 設定可能な値: S3 Tablesテーブルバケットの有効なARN
      # 形式: arn:aws:s3tables:region:account-id:bucket/table-bucket-name
      # 注意:
      #   - 宛先テーブルバケットは事前に作成されている必要があります
      #   - クロスアカウントレプリケーションの場合、宛先バケットポリシーで
      #     ソースアカウントからのアクセスを許可する必要があります
      #   - 同じリージョン、異なるリージョン、異なるアカウントへのレプリケーションが可能
      # 関連機能: S3 Tablesテーブルバケット
      #   テーブルバケットはApache Icebergテーブルのコンテナです。
      #   宛先テーブルバケットは、レプリカテーブルを格納するために使用されます。
      #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-buckets-overview.html
      destination_table_bucket_arn = aws_s3tables_table_bucket.target.arn
    }

    # 複数の宛先を設定する例（コメントアウト）
    # 注意: 最大5つまでの宛先を指定できます
    # destination {
    #   destination_table_bucket_arn = aws_s3tables_table_bucket.target_region_2.arn
    # }
    #
    # destination {
    #   destination_table_bucket_arn = aws_s3tables_table_bucket.target_cross_account.arn
    # }
  }
}

#---------------------------------------------------------------
# レプリケーションの仕組みと考慮事項
#---------------------------------------------------------------
#
# レプリケーション処理:
# - S3 Tablesは、テーブルスナップショット、メタデータ、削除ファイル、
#   テーブルメタデータをソーステーブルと同じ順序でレプリケートします
# - レプリカテーブルは読み取り専用で、任意のIceberg互換エンジンで
#   クエリできます
# - レプリケーションの更新は通常、ソースの更新から数分以内に行われます
#
# メタデータ処理:
# - テーブルメタデータ: 完全にレプリケートされます
# - テーブル設定: 一部の設定はレプリケートされません（タグ、ブランチなど）
# - レプリカ固有の状態: スナップショット保持期間は独立して設定可能
#
# サポートされる機能:
# - Apache Iceberg V2およびV3テーブル形式のレプリケーション
# - スナップショット履歴の維持（リージョン間でも維持）
# - カスタムスナップショット保持期間の設定
#
# 制限事項:
# - テーブルサイズに制限あり（大規模なテーブルは時間がかかる場合があります）
# - タグやブランチなどの一部機能はサポートされていません
# - レプリカテーブルでのコンパクションはサポートされていません
# - 500MBを超えるメタデータファイルはサポートされていません
# - V2からV3へのアップグレードはレプリケーションされません
# - Amazon S3 Metadataテーブルや他のAWS生成システムテーブルは
#   レプリケーションサポート対象外
#
# パフォーマンス考慮事項:
# - 初回レプリケーション（バックフィル）の時間はソーステーブルの
#   サイズに依存します
# - 大規模なテーブル更新のレプリケーションには時間がかかる場合があります
# - レプリケーションは非同期で行われ、最終的な一貫性を保証します
#
# コスト考慮事項:
# - 宛先テーブルのストレージコスト
# - レプリケーションPUTリクエストコスト
# - テーブル更新（コミット）コスト
# - レプリケートされたデータのオブジェクト監視コスト
# - クロスリージョンレプリケーションの場合、リージョン間データ転送コスト
# - S3 Intelligent-Tieringストレージクラスを使用してコスト最適化が可能
#
# セキュリティ考慮事項:
# - クロスアカウントレプリケーションの場合、宛先バケットポリシーで
#   適切なアクセス権限を設定する必要があります
# - 暗号化されたテーブルのレプリケーションには、宛先リージョンの
#   KMSキーとIAMロールへの権限が必要です
# - IAMロールには最小権限の原則を適用し、必要な権限のみを付与してください
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: テーブルのARN
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 依存リソース例
#---------------------------------------------------------------
#
# S3 Tablesテーブルレプリケーションを使用するには、以下のリソースが必要です:
#
# 1. ソーステーブル (aws_s3tables_table)
# resource "aws_s3tables_table" "example" {
#   name                  = "example-table"
#   namespace             = "example-namespace"
#   table_bucket_arn      = aws_s3tables_table_bucket.source.arn
#   format                = "ICEBERG"
# }
#
# 2. ソーステーブルバケット (aws_s3tables_table_bucket)
# resource "aws_s3tables_table_bucket" "source" {
#---------------------------------------------------------------
