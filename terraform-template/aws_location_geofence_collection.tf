#---------------------------------------------------------------
# Amazon Location Service Geofence Collection
#---------------------------------------------------------------
#
# Amazon Location Service のジオフェンスコレクションをプロビジョニングするリソースです。
# ジオフェンスコレクションは地理的境界（ジオフェンス）の集合を管理します。
# デバイスがジオフェンスに入ったり出たりしたときにイベントをトリガーするために
# Amazon Location Tracker と組み合わせて使用されます。
# コレクションは複数のジオフェンス（ポリゴンで定義された地理的領域）を格納し、
# 位置情報サービスと統合したアプリケーション開発を可能にします。
#
# AWS公式ドキュメント:
#   - Amazon Location Service とは: https://docs.aws.amazon.com/location/latest/developerguide/what-is.html
#   - ジオフェンスの概要: https://docs.aws.amazon.com/location/latest/developerguide/geofence-tracker-concepts.html
#   - ジオフェンスコレクションの作成: https://docs.aws.amazon.com/location/latest/developerguide/geofence-tracker-concepts.html#geofence-collection
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/location_geofence_collection
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_location_geofence_collection" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # collection_name (Required)
  # 設定内容: ジオフェンスコレクションの名前を指定します。
  # 設定可能な値: 1〜100文字の英数字、ハイフン、アンダースコア、ピリオド
  # 省略時: 省略不可
  collection_name = "example-geofence-collection"

  # description (Optional)
  # 設定内容: ジオフェンスコレクションの説明を指定します。
  # 設定可能な値: 最大1000文字の文字列
  # 省略時: 説明なし
  description = "Example geofence collection for location tracking"

  # kms_key_id (Optional)
  # 設定内容: ジオフェンスデータの暗号化に使用する KMS キーの ID または ARN を指定します。
  # 設定可能な値: KMS キー ID、キー ARN、またはキーエイリアス
  # 省略時: AWS 管理キーによる暗号化（デフォルト）
  # 注意: カスタマー管理キーを使用する場合、Amazon Location Service が
  #       KMS キーへのアクセス権限を持つ必要があります。
  kms_key_id = null

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #           一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-geofence-collection"
    Environment = "production"
  }

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

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの時間文字列
    # 省略時: プロバイダーデフォルト値を使用
    update = "30m"

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
# - collection_arn: ジオフェンスコレクションの Amazon Resource Name (ARN)
# - create_time: ジオフェンスコレクションが作成された日時 (ISO 8601 形式)
# - id: ジオフェンスコレクション名 (collection_name と同一)
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
# - update_time: ジオフェンスコレクションが最後に更新された日時 (ISO 8601 形式)
#---------------------------------------------------------------
