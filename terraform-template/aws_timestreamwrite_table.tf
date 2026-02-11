#---------------------------------------------------------------
# Amazon Timestream for TimeSeries テーブル
#---------------------------------------------------------------
#
# Amazon Timestream for TimeSeriesのテーブルをプロビジョニングするリソースです。
# Timestreamテーブルは、時系列データを格納するためのコンテナであり、
# データの保持期間、パーティションキー、マグネティックストアへの書き込み設定などを
# 定義します。
#
# AWS公式ドキュメント:
#   - Amazon Timestream for TimeSeries: https://docs.aws.amazon.com/timestream/latest/developerguide/what-is-timestream.html
#   - テーブルの作成と使用: https://docs.aws.amazon.com/timestream/latest/developerguide/tables.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/timestreamwrite_table
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_timestreamwrite_table" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # database_name (Required)
  # 設定内容: Timestreamデータベースの名前を指定します。
  # 設定可能な値: 有効なTimestreamデータベース名
  # 関連機能: Timestream データベース
  #   テーブルを作成する親データベースを指定します。
  #   データベースは事前に作成されている必要があります。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/databases.html
  database_name = "example-database"

  # table_name (Required)
  # 設定内容: Timestreamテーブルの名前を指定します。
  # 設定可能な値: 3-256文字の英数字、ハイフン、アンダースコア
  # 関連機能: Timestream テーブル
  #   時系列データを格納するテーブルの名前を定義します。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/tables.html
  table_name = "example-table"

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
  # データ保持設定
  #-------------------------------------------------------------

  # retention_properties (Optional)
  # 設定内容: メモリストアとマグネティックストアのデータ保持期間を指定します。
  # 省略時: magnetic_store_retention_period_in_daysは73000日、
  #         memory_store_retention_period_in_hoursは6時間がデフォルト
  # 関連機能: Timestream データ保持ポリシー
  #   メモリストアは高速アクセス用、マグネティックストアは長期保存用です。
  #   データは自動的にメモリストアからマグネティックストアに移動されます。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/storage.html
  retention_properties {
    # memory_store_retention_period_in_hours (Required)
    # 設定内容: メモリストアにデータを保持する時間数を指定します。
    # 設定可能な値: 1-8766時間（1時間～約1年）
    # 関連機能: メモリストア保持期間
    #   リアルタイムクエリ用の高速ストレージの保持期間を設定します。
    #   - https://docs.aws.amazon.com/timestream/latest/developerguide/storage.html
    memory_store_retention_period_in_hours = 8

    # magnetic_store_retention_period_in_days (Required)
    # 設定内容: マグネティックストアにデータを保持する日数を指定します。
    # 設定可能な値: 1-73000日（約200年）
    # 関連機能: マグネティックストア保持期間
    #   長期保存用の低コストストレージの保持期間を設定します。
    #   - https://docs.aws.amazon.com/timestream/latest/developerguide/storage.html
    magnetic_store_retention_period_in_days = 30
  }

  #-------------------------------------------------------------
  # マグネティックストア書き込み設定
  #-------------------------------------------------------------

  # magnetic_store_write_properties (Optional)
  # 設定内容: マグネティックストアへの書き込みを有効にする際のプロパティを設定します。
  # 省略時: マグネティックストア書き込み設定は未構成
  # 関連機能: マグネティックストア書き込み
  #   マグネティックストアへの直接書き込みとエラー処理を制御します。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/magnetic-store-writes.html
  magnetic_store_write_properties {
    # enable_magnetic_store_writes (Optional)
    # 設定内容: マグネティックストアへの書き込みを有効にするフラグを指定します。
    # 設定可能な値:
    #   - true: マグネティックストア書き込みを有効化
    #   - false: マグネティックストア書き込みを無効化
    # 関連機能: マグネティックストア書き込み有効化
    #   メモリストア経由ではなく、マグネティックストアに直接データを書き込む機能です。
    #   - https://docs.aws.amazon.com/timestream/latest/developerguide/magnetic-store-writes.html
    enable_magnetic_store_writes = false

    # magnetic_store_rejected_data_location (Optional)
    # 設定内容: マグネティックストア書き込み時に非同期的に拒否されたレコードの
    #           エラーレポートを書き込む場所を指定します。
    # 省略時: エラーレポートの保存先は未構成
    # 関連機能: マグネティックストア書き込みエラー処理
    #   書き込みに失敗したレコードの詳細をS3に保存してデバッグを支援します。
    #   - https://docs.aws.amazon.com/timestream/latest/developerguide/magnetic-store-writes.html
    magnetic_store_rejected_data_location {
      # s3_configuration (Optional)
      # 設定内容: 非同期的に拒否されたレコードのエラーレポートを書き込むS3の設定を指定します。
      # 省略時: S3へのエラーレポート保存は未構成
      s3_configuration {
        # bucket_name (Optional)
        # 設定内容: 顧客のS3バケット名を指定します。
        # 設定可能な値: 有効なS3バケット名
        bucket_name = null

        # object_key_prefix (Optional)
        # 設定内容: 顧客のS3ロケーション用のオブジェクトキープレフィックスを指定します。
        # 設定可能な値: S3オブジェクトキープレフィックス文字列
        # 省略時: プレフィックスなし
        object_key_prefix = null

        # encryption_option (Optional)
        # 設定内容: 顧客のS3ロケーションの暗号化オプションを指定します。
        # 設定可能な値:
        #   - "SSE_S3": S3管理キーでのS3サーバー側暗号化
        #   - "SSE_KMS": KMS管理キーでのS3サーバー側暗号化
        # 関連機能: S3 暗号化
        #   エラーレポートファイルの暗号化方式を選択します。
        #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html
        encryption_option = null

        # kms_key_id (Optional)
        # 設定内容: KMS管理キーで暗号化する場合のKMSキーARNを指定します。
        # 設定可能な値: 有効なKMSキーARN
        # 注意: encryption_optionが"SSE_KMS"の場合に指定
        kms_key_id = null
      }
    }
  }

  #-------------------------------------------------------------
  # スキーマ設定
  #-------------------------------------------------------------

  # schema (Optional)
  # 設定内容: テーブルのスキーマを指定します。
  # 省略時: スキーマ定義なし（パーティションキーなし）
  # 関連機能: Timestream カスタムパーティションキー
  #   テーブルデータのパーティション方法を定義する属性を設定します。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/partition-keys.html
  schema {
    # composite_partition_key (Optional)
    # 設定内容: テーブルデータをパーティション化するための属性を定義する
    #           パーティションキーの空でないリストを指定します。
    # 注意: リストの順序によりパーティション階層が決定されます。
    #       テーブル作成後、各パーティションキーの名前、型、順序は変更できませんが、
    #       enforcement_levelは変更可能です。
    # 関連機能: 複合パーティションキー
    #   効率的なクエリとデータ管理のためにデータをパーティション化します。
    #   - https://docs.aws.amazon.com/timestream/latest/developerguide/partition-keys.html
    composite_partition_key {
      # type (Required)
      # 設定内容: パーティションキーのタイプを指定します。
      # 設定可能な値:
      #   - "DIMENSION": ディメンション属性をパーティションキーとして使用
      #   - "MEASURE": メジャー属性をパーティションキーとして使用
      # 関連機能: パーティションキータイプ
      #   ディメンションは通常のメタデータ属性、メジャーは測定値です。
      #   - https://docs.aws.amazon.com/timestream/latest/developerguide/writes.html
      type = "DIMENSION"

      # name (Optional)
      # 設定内容: ディメンションキーに使用される属性の名前を指定します。
      # 設定可能な値: ディメンション名またはメジャー名の文字列
      # 関連機能: パーティションキー名
      #   データ内の実際の属性名と一致する必要があります。
      #   - https://docs.aws.amazon.com/timestream/latest/developerguide/partition-keys.html
      name = null

      # enforcement_in_record (Optional)
      # 設定内容: 取り込まれるレコードにおけるディメンションキー指定の強制レベルを指定します。
      # 設定可能な値:
      #   - "REQUIRED": パーティションキーは必須（レコードに含まれていない場合エラー）
      #   - "OPTIONAL": パーティションキーは任意（レコードに含まれていなくても許可）
      # 省略時: REQUIRED（デフォルト）
      # 関連機能: パーティションキー強制
      #   データ品質とクエリパフォーマンスのバランスを制御します。
      #   - https://docs.aws.amazon.com/timestream/latest/developerguide/partition-keys.html
      enforcement_in_record = null
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
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-timestream-table"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: table_nameとdatabase_nameをコロン (:) で区切った形式の識別子
#
# - arn: このテーブルを一意に識別するARN
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
