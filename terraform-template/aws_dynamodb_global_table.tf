#---------------------------------------------------------------
# DynamoDB Global Table
#---------------------------------------------------------------
#
# DynamoDB Global Tables V1 (version 2017.11.29)を管理するリソースです。
# 既存のDynamoDBテーブルの上にレイヤーとして構築され、
# 複数のAWSリージョン間でDynamoDBテーブルを自動的にレプリケートします。
#
# 重要な注意事項:
#   - これはGlobal Tables V1 (2017.11.29)用のリソースです
#   - Global Tables V2 (2019.11.21)を使用する場合は、aws_dynamodb_tableリソースの
#     replica設定ブロックを使用してください
#   - グローバルテーブルを作成する前に、各リージョンに同名のDynamoDBテーブルが
#     存在している必要があります
#   - すべてのテーブルでストリームを有効化する必要があります
#
# AWS公式ドキュメント:
#   - DynamoDB Global Tables V1: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/globaltables.V1.html
#   - グローバルテーブルの要件: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/globaltables_reqs_bestpractices.html
#   - Global Tables V2への移行: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/globaltables.V2.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_global_table
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dynamodb_global_table" "example" {
  #-------------------------------------------------------------
  # グローバルテーブル名 (Required)
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: グローバルテーブルの名前を指定します。
  # 設定可能な値: 3〜255文字の文字列（英数字、ハイフン、アンダースコアのみ）
  # 制約: すべてのリージョンの基礎となるDynamoDBテーブルと同じ名前である必要があります。
  # 用途: グローバルテーブルの識別子として使用され、各リージョンのテーブルを
  #       統合的に管理するために使用されます。
  # 重要: この名前は作成後に変更できません。変更する場合は新しいリソースを
  #       作成する必要があります。
  name = "myTable"

  #-------------------------------------------------------------
  # レプリカリージョン設定 (Required)
  #-------------------------------------------------------------

  # replica (Required)
  # 設定内容: グローバルテーブルのレプリカリージョンを定義します。
  # 最小値: 最低1つのレプリカが必要です
  # 推奨事項: 高可用性とディザスタリカバリのために、最低2つ以上のリージョンを
  #           設定することを推奨します。
  # 前提条件: 各リージョンに同じ名前のDynamoDBテーブルが存在している必要があります。
  #           また、すべてのテーブルでstream_enabled = trueが設定されている必要があります。
  # 参考: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/globaltables_reqs_bestpractices.html
  replica {
    # region_name (Required)
    # 設定内容: レプリカDynamoDBテーブルのAWSリージョン名を指定します。
    # 設定可能な値: 有効なAWSリージョンコード
    #   例: us-east-1, us-west-2, eu-west-1, ap-northeast-1, ap-southeast-1
    # 制約: 指定したリージョンに同名のDynamoDBテーブルが存在している必要があります。
    # 用途: プライマリリージョンまたはメインのデータセンターリージョンを指定します。
    region_name = "us-east-1"
  }

  replica {
    # 2つ目のレプリカリージョン
    # マルチリージョンでの高可用性を実現するために追加のリージョンを設定します。
    # 地理的に分散したリージョンを選択することで、ディザスタリカバリ能力が向上します。
    region_name = "us-west-2"
  }

  # 追加のレプリカリージョン（必要に応じて）
  # グローバルな展開や、さらなる冗長性が必要な場合は3つ以上のリージョンを設定できます。
  # replica {
  #   region_name = "eu-west-1"
  # }
  #
  # replica {
  #   region_name = "ap-northeast-1"
  # }

  #-------------------------------------------------------------
  # リージョン管理設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード
  # 省略時: プロバイダー設定のリージョンがデフォルトで使用されます。
  # 用途: グローバルテーブルを管理する特定のリージョンを明示的に指定する場合に使用します。
  #       通常はプライマリリージョンを選択します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #-------------------------------------------------------------
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト時間を設定します。
  # 用途: グローバルテーブルの作成、更新、削除は複数リージョンにわたる操作のため、
  #       デフォルトのタイムアウト時間では不十分な場合があります。
  # 推奨事項: レプリカが多い場合やリージョン間の通信が遅い場合は、
  #           タイムアウト時間を長めに設定することを検討してください。
  timeouts {
    # create (Optional)
    # 設定内容: グローバルテーブル作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "5m", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 推奨値: 複数リージョンでのレプリケーション設定に時間がかかるため、
    #         "10m"以上を推奨します。
    create = "10m"

    # update (Optional)
    # 設定内容: グローバルテーブル更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "5m", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 推奨値: レプリカの追加や削除には時間がかかるため、"10m"以上を推奨します。
    update = "10m"

    # delete (Optional)
    # 設定内容: グローバルテーブル削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "5m", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 推奨値: すべてのリージョンからレプリカを削除するため、"10m"以上を推奨します。
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: DynamoDBグローバルテーブルの名前
#
# - arn: DynamoDBグローバルテーブルのARN
#       形式: arn:aws:dynamodb::123456789012:global-table/myTable
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例と前提条件
#---------------------------------------------------------------
# このリソースを使用する前に、以下の準備が必要です:
#
# 1. 各リージョン用のプロバイダー設定:
#    provider "aws" {
#      alias  = "us-east-1"
#      region = "us-east-1"
#    }
#
#    provider "aws" {
#      alias  = "us-west-2"
#      region = "us-west-2"
#    }
#
# 2. 各リージョンに基礎となるDynamoDBテーブルを作成:
#    resource "aws_dynamodb_table" "us_east_1" {
#      provider         = aws.us-east-1
#      name             = "myTable"
#      hash_key         = "myAttribute"
#      stream_enabled   = true
#      stream_view_type = "NEW_AND_OLD_IMAGES"
#      read_capacity    = 1
#      write_capacity   = 1
#
#      attribute {
#        name = "myAttribute"
#        type = "S"
#      }
#    }
#
#    resource "aws_dynamodb_table" "us_west_2" {
#      provider         = aws.us-west-2
#      name             = "myTable"
#      hash_key         = "myAttribute"
#      stream_enabled   = true
#      stream_view_type = "NEW_AND_OLD_IMAGES"
#      read_capacity    = 1
#      write_capacity   = 1
#
#      attribute {
#        name = "myAttribute"
#        type = "S"
#      }
#    }
#
# 3. depends_onを使用して依存関係を明示:
#    resource "aws_dynamodb_global_table" "example" {
#      depends_on = [
#        aws_dynamodb_table.us_east_1,
#        aws_dynamodb_table.us_west_2,
#      ]
#      provider = aws.us-east-1
#      name     = "myTable"
#      replica {
#        region_name = "us-east-1"
#      }
#      replica {
#        region_name = "us-west-2"
#      }
#    }
#
#---------------------------------------------------------------
# ベストプラクティス
#---------------------------------------------------------------
#
# 1. バージョンの選択:
#    - 新規プロジェクト: Global Tables V2を推奨
#      (aws_dynamodb_tableリソースのreplica設定を使用)
#    - Global Tables V1の使用ケース: 既存のテーブルをグローバル化する場合
#
# 2. ストリーム設定:
#    - すべての基礎テーブルでstream_enabled = trueが必須
#    - stream_view_type = "NEW_AND_OLD_IMAGES"を推奨
#      (レプリケーションに最適な設定)
#
# 3. キャパシティ管理:
#    - 初期設定では同じread_capacity/write_capacityを使用
#    - グローバルテーブル作成後、各リージョンで個別に調整可能
#    - Auto Scalingを使用する場合は各リージョンで個別に設定
#
# 4. セキュリティ:
#    - 各リージョンでKMS暗号化を有効化することを推奨
#    - IAMポリシーで適切なアクセス制御を設定
#    - VPCエンドポイント経由のアクセスを検討
#
# 5. 監視:
#    - CloudWatchメトリクスで各リージョンのパフォーマンスを監視
#    - ReplicationLatencyメトリクスでレプリケーション遅延を監視
#    - ConsumedReadCapacityUnits/ConsumedWriteCapacityUnitsを監視
#
# 6. コスト最適化:
#    - レプリカ数分のストレージとスループット料金が発生
#    - ストリーム料金も考慮（読み取りリクエストごとに課金）
#    - 必要最小限のレプリカ数で開始し、必要に応じて拡張
#
# 7. 制約事項:
#    - テーブル名はすべてのリージョンで同一である必要がある
#    - すべてのレプリカで同じキー構造（パーティションキー、ソートキー）が必要
#    - グローバルセカンダリインデックス（GSI）もすべてのリージョンで同一設定が必要
#
#---------------------------------------------------------------
# トラブルシューティング
#---------------------------------------------------------------
#
# エラー: "Stream must be enabled"
# 原因: 基礎テーブルでストリームが有効化されていません
# 解決策: すべての基礎テーブルでstream_enabled = trueを設定
#
# エラー: "Table names must match"
# 原因: リージョン間でテーブル名が一致していません
# 解決策: すべてのリージョンのテーブル名とグローバルテーブル名を一致させる
#
# エラー: "Replica already exists"
# 原因: 既にグローバルテーブルとして設定されているテーブルを再度追加している
# 解決策: terraform state rmで状態を削除してからインポートを検討
#
# レプリケーション遅延が大きい:
# 原因: ネットワーク遅延またはキャパシティ不足
# 解決策:
#   - CloudWatchメトリクスでReplicationLatencyを監視
#   - write_capacityを増やすことを検討
#   - リージョン間のネットワーク接続を確認
#
#---------------------------------------------------------------
