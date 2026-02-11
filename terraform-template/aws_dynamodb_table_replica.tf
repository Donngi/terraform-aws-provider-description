#---------------------------------------------------------------
# AWS DynamoDB Table Replica
#---------------------------------------------------------------
#
# DynamoDB Global Tables V2 (version 2019.11.21) のテーブルレプリカを
# 管理するリソースです。メインテーブルを別のAWSリージョンにレプリケートし、
# グローバルに分散されたアプリケーションで低レイテンシーのデータアクセスを
# 実現します。
#
# 重要な注意事項:
#   - aws_dynamodb_table リソースの replica 設定ブロックと併用しないでください。
#     両者は相互に排他的です。
#   - 関連する aws_dynamodb_table の lifecycle で ignore_changes に replica を
#     追加してください。
#
# AWS公式ドキュメント:
#   - DynamoDB Global Tables: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/globaltables.V2.html
#   - Global Tables の管理: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/V2globaltables_HowItWorks.html
#   - DynamoDB API リファレンス: https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_replica
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dynamodb_table_replica" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # global_table_arn (Required)
  # 設定内容: レプリケートするメイン（グローバル）テーブルのARNを指定します。
  # 設定可能な値: 有効なDynamoDBテーブルのARN
  # 用途: このリソースがレプリカを作成する元となるテーブルを識別
  # 関連機能: DynamoDB Global Tables
  #   グローバルテーブルのソーステーブルを指定。ソーステーブルには
  #   ストリームが有効化されている必要があります (stream_enabled = true,
  #   stream_view_type = "NEW_AND_OLD_IMAGES")。
  #   - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/globaltables.V2.html
  global_table_arn = aws_dynamodb_table.example.arn

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このレプリカリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-2, eu-west-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 用途: レプリカを配置するリージョンを明示的に指定する場合に使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # deletion_protection_enabled (Optional, Computed)
  # 設定内容: テーブルレプリカの削除保護を有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: 削除保護を有効化。誤削除を防止
  #   - false: 削除保護を無効化
  # 省略時: メインテーブルの設定を継承
  # 関連機能: DynamoDB 削除保護
  #   本番環境では有効化を強く推奨。削除前に明示的に無効化が必要になります。
  #   - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/WorkingWithTables.Basics.html
  deletion_protection_enabled = false

  # kms_key_arn (Optional, Computed, Forces new resource)
  # 設定内容: レプリカテーブルの暗号化に使用するAWS KMSカスタマー管理キーのARNを指定します。
  # 設定可能な値: 有効なKMSキーのARN
  # 省略時: デフォルトのKMS管理DynamoDBキー (alias/aws/dynamodb) を使用
  # 注意:
  #   - この引数はデフォルトのKMS管理DynamoDBキーと異なるキーを使用する場合のみ指定
  #   - デフォルトキーの場合、この属性にはARNが設定されません
  #   - 変更するとリソースが再作成されます (Forces new resource)
  # 関連機能: DynamoDB 暗号化
  #   カスタマー管理キーを使用すると、キーのローテーションや
  #   アクセス制御をより細かく管理できます。
  #   - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/EncryptionAtRest.html
  kms_key_arn = null

  # point_in_time_recovery (Optional)
  # 設定内容: テーブルレプリカのポイントインタイムリカバリ (PITR) を有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: PITRを有効化。過去35日間の任意の時点にリストア可能
  #   - false: PITRを無効化
  # 省略時: false (PITRは無効)
  # 関連機能: DynamoDB Point-in-Time Recovery
  #   連続的なバックアップを取得し、誤操作やデータ破損からの復旧を可能にします。
  #   追加コストが発生します。
  #   - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/PointInTimeRecovery.html
  point_in_time_recovery = false

  # table_class_override (Optional, Forces new resource)
  # 設定内容: レプリカテーブルのストレージクラスを指定します。
  # 設定可能な値:
  #   - "STANDARD": 標準クラス。汎用的な使用に適合
  #   - "STANDARD_INFREQUENT_ACCESS": 低頻度アクセスクラス。アクセス頻度が低いデータ向け。ストレージコストが低い
  # 省略時: メインテーブルと同じクラスを使用
  # 注意: 変更するとリソースが再作成されます (Forces new resource)
  # 関連機能: DynamoDB テーブルクラス
  #   アクセスパターンに応じて最適なクラスを選択することでコストを最適化できます。
  #   - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.TableClasses.html
  table_class_override = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tagging.html
  tags = {
    Name        = "example-replica"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID
  # フォーマット: テーブル名とメインテーブルのリージョンをセミコロンで結合
  #   例: "TableName:us-east-1"
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 用途: 大規模なテーブルのレプリケーションや削除に時間がかかる場合に調整
  timeouts {
    # create (Optional)
    # 設定内容: レプリカテーブル作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "30m", "1h", "2h")
    # 省略時: デフォルトのタイムアウト値を使用
    # 用途: 大規模なテーブルのレプリケーション開始時に延長が必要な場合
    create = "30m"

    # update (Optional)
    # 設定内容: レプリカテーブル更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "30m", "1h", "2h")
    # 省略時: デフォルトのタイムアウト値を使用
    # 用途: 設定変更の適用に時間がかかる場合に延長
    update = "30m"

    # delete (Optional)
    # 設定内容: レプリカテーブル削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "30m", "1h", "2h")
    # 省略時: デフォルトのタイムアウト値を使用
    # 用途: レプリカの削除に時間がかかる場合に延長
    delete = "30m"
  }
}

#---------------------------------------------------------------
#
# # メインリージョンのプロバイダー
# provider "aws" {
#   alias  = "main"
#   region = "us-west-2"
# }
#
# # レプリカリージョンのプロバイダー
# provider "aws" {
#   alias  = "replica"
#   region = "us-east-2"
# }
#
# # メインテーブル (グローバルテーブル)
# resource "aws_dynamodb_table" "example" {
#   provider         = aws.main
#   name             = "example-table"
#   hash_key         = "id"
#   billing_mode     = "PAY_PER_REQUEST"
#   stream_enabled   = true                    # レプリケーションに必須
#   stream_view_type = "NEW_AND_OLD_IMAGES"    # レプリケーションに必須
#
#   attribute {
#     name = "id"
#     type = "S"
#   }
#
#   lifecycle {
#     ignore_changes = [replica]  # aws_dynamodb_table_replica との競合を防止
#   }
# }
#
# # レプリカテーブル
# resource "aws_dynamodb_table_replica" "example" {
#   provider         = aws.replica
#   global_table_arn = aws_dynamodb_table.example.arn
#
#   tags = {
#     Name = "example-table-replica"
#   }
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: テーブルレプリカのAmazon Resource Name (ARN)
#   レプリカリージョンでのテーブルのARNが返されます。
#
# - id: テーブル名とメインテーブルのリージョンをセミコロンで結合した識別子
#   例: "TableName:us-east-1"
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
