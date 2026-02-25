#---------------------------------------------------------------
# Amazon Location Service Tracker Association
#---------------------------------------------------------------
#
# Amazon Location Service のトラッカーとジオフェンスコレクションを関連付けるリソースです。
# トラッカーをジオフェンスコレクションに関連付けることで、デバイスがジオフェンスに
# 入ったり出たりしたときに自動的にイベントを評価し通知を送信できます。
# 1 つのトラッカーに複数のジオフェンスコレクションを関連付けることが可能です。
#
# AWS公式ドキュメント:
#   - Amazon Location Service とは: https://docs.aws.amazon.com/location/latest/developerguide/what-is.html
#   - トラッカーとジオフェンスコレクションの関連付け: https://docs.aws.amazon.com/location/latest/developerguide/geofence-tracker-concepts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/location_tracker_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_location_tracker_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # tracker_name (Required)
  # 設定内容: 関連付け対象のトラッカー名を指定します。
  # 設定可能な値: 既存の aws_location_tracker リソースの tracker_name
  # 省略時: 省略不可
  tracker_name = "example-tracker"

  # consumer_arn (Required)
  # 設定内容: 関連付けるジオフェンスコレクションの ARN を指定します。
  # 設定可能な値: aws_location_geofence_collection リソースの collection_arn
  # 省略時: 省略不可
  consumer_arn = "arn:aws:geo:ap-northeast-1:123456789012:geofence-collection/example-geofence-collection"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの時間文字列
    # 省略時: プロバイダーデフォルト値を使用
    create = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの時間文字列
    # 省略時: プロバイダーデフォルト値を使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: トラッカー名とジオフェンスコレクション ARN の組み合わせ
#       (tracker_name|consumer_arn の形式)
#---------------------------------------------------------------
