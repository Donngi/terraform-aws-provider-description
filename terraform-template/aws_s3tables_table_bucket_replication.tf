#---------------------------------------------------------------
# Amazon S3 Tables - Table Bucket Replication
#---------------------------------------------------------------
#
# Amazon S3 Tables のテーブルバケットレプリケーション設定を管理するリソースです。
# S3 Tables レプリケーションにより、テーブルの読み取り専用レプリカを
# 異なるAWSリージョンやアカウントのテーブルバケットに自動的に作成できます。
#
# 主な特徴:
#   - バケットレベルのレプリケーション設定（全テーブルに適用）
#   - 最大5つの宛先テーブルバケットへのレプリケーションをサポート
#   - Apache Iceberg V2 および V3 テーブル形式に対応
#   - レプリカテーブルは読み取り専用で、Iceberg互換エンジンからクエリ可能
#   - 親子スナップショット関係を保持
#
# AWS公式ドキュメント:
#   - S3 Tables レプリケーション概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-replication.html
#   - S3 Tables レプリケーションの設定: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-replication-setting-up.html
#   - API リファレンス: https://docs.aws.amazon.com/AmazonS3/latest/API/API_s3Buckets_TableBucketReplicationConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3tables_table_bucket_replication
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3tables_table_bucket_replication" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # table_bucket_arn (Required, Forces new resource)
  # 設定内容: レプリケーション設定を所有するソーステーブルバケットのARNを指定します。
  # 設定可能な値: 有効なS3 Tablesテーブルバケットの ARN
  # 注意: この値を変更するとリソースが再作成されます
  # 関連機能: S3 Tables テーブルバケット
  #   レプリケーション元のテーブルバケットを指定。バケット内の全テーブルがレプリケーション対象。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-replication-setting-up.html
  table_bucket_arn = aws_s3tables_table_bucket.source.arn

  # role (Required)
  # 設定内容: S3がテーブルをレプリケーションする際に引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールの ARN (パターン: arn:.+:iam::[0-9]{12}:role/.+)
  # 関連機能: S3 Tables レプリケーション用IAMロール
  #   レプリケーションに必要な権限を持つIAMロール。S3 Tablesサービスが
  #   ソースバケットからの読み取りと宛先バケットへの書き込みを行うために使用。
  #   信頼ポリシーで s3.amazonaws.com をプリンシパルとして許可する必要があります。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-replication-setting-up.html
  role = aws_iam_role.example.arn

  #-------------------------------------------------------------
  # レプリケーションルール設定
  #-------------------------------------------------------------

  # rule (Optional)
  # 設定内容: レプリケーションルールを定義します。
  # 用途: どの宛先テーブルバケットにレプリケーションするかを指定
  # 注意: 最大5つの宛先テーブルバケットを指定可能
  rule {
    # destination (Required)
    # 設定内容: レプリケーション先の宛先を指定します。
    destination {
      # destination_table_bucket_arn (Required)
      # 設定内容: レプリケーション先のテーブルバケットのARNを指定します。
      # 設定可能な値: 有効なS3 Tablesテーブルバケットの ARN
      # 注意: 同一リージョン内またはクロスリージョンのテーブルバケットを指定可能。
      #   クロスリージョンの場合、リージョン間データ転送料金が発生します。
      #   レプリカテーブルは宛先バケットに読み取り専用として作成されます。
      #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-replication-setting-up.html
      destination_table_bucket_arn = aws_s3tables_table_bucket.target.arn
    }
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - version_token: レプリケーション設定のバージョントークン。
#   レプリケーション設定の更新時に楽観的ロックに使用されます。
#---------------------------------------------------------------
