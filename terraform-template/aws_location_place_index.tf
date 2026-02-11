#---------------------------------------------------------------
# AWS Location Service Place Index
#---------------------------------------------------------------
#
# Amazon Location Serviceの場所インデックスリソースをプロビジョニングします。
# 場所インデックスは、住所や地点の検索・ジオコーディング（住所を座標に変換）・
# リバースジオコーディング（座標を住所に変換）機能を提供します。
# 世界108カ国にわたる4億以上の住所とポイント・オブ・インタレスト（POI）を
# 検索可能にし、ロケーションベースのアプリケーション構築を支援します。
#
# 主な用途:
#   - 住所や地名を地理座標（緯度・経度）に変換する
#   - 地理座標から人間が読める住所や地名を取得する
#   - 住所入力時のオートコンプリート機能を実装する
#   - ポイント・オブ・インタレスト（POI）を検索する
#   - テキストベースの場所検索を実装する
#
# AWS公式ドキュメント:
#   - Amazon Location Service Places: https://docs.aws.amazon.com/location/latest/developerguide/places.html
#   - CreatePlaceIndex API: https://docs.aws.amazon.com/location/latest/APIReference/API_CreatePlaceIndex.html
#   - Places機能概要: https://aws.amazon.com/location/places/
#   - データプロバイダー: https://aws.amazon.com/location/data-providers/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/location_place_index
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_location_place_index" "example" {
  #-------------------------------------------------------------
  # 基本設定 (Required)
  #-------------------------------------------------------------

  # data_source (Required)
  # 設定内容: 場所インデックスで使用する地理空間データプロバイダーを指定します。
  # 設定可能な値:
  #   - "Esri": Esri社の地理情報システム（GIS）データを使用
  #             - 世界的なリーダーによる高品質で権威あるデータ
  #             - 149カ国で住所とPOIの検索をサポート
  #             - ローカル言語と住所形式をサポート
  #   - "Here": HERE Technologies社のマップデータを使用
  #             - グローバルなマップとロケーションサービスプロバイダー
  #   - "Grab": Grab社の東南アジア特化データを使用
  #             - 東南アジアに特化した詳細なローカルデータ
  #             - Grabデータが必要な場合はPlaces API v1を継続使用
  # データプロバイダー選定基準:
  #   - 対象地域のカバレッジ
  #   - データの精度と更新頻度
  #   - 料金体系とコスト
  #   - 必要な機能（POIカテゴリ、言語サポート等）
  # 参考: https://aws.amazon.com/location/data-providers/
  data_source = "Here"

  # index_name (Required)
  # 設定内容: 場所インデックスリソースの名前を指定します。
  # 設定可能な値: 英数字、ハイフン（-）、ピリオド（.）、アンダースコア（_）を含む文字列
  # 命名規則:
  #   - AWSアカウント内で一意である必要があります
  #   - わかりやすく目的を表す名前を推奨（例: app-name-place-index）
  #   - 環境別に管理する場合は環境名を含める（例: production-place-index）
  # 文字制限: 1～100文字
  index_name = "example-place-index"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: 場所インデックスリソースの説明を指定します。
  # 設定可能な値: 任意の文字列（最大1000文字）
  # 用途: リソースの目的や用途を説明し、管理を容易にします
  # 推奨事項: どのアプリケーション/サービスで使用されるかを明記すると
  #           複数のインデックスを管理する際に便利です
  description = "Place index for address geocoding and POI search in example application"

  # region (Optional)
  # 設定内容: このリソースが管理されるAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: us-east-1, eu-west-1, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトで使用されます
  # 考慮事項:
  #   - データ保存場所のコンプライアンス要件
  #   - アプリケーションとの地理的近接性によるレイテンシ
  #   - 各リージョンでのサービス利用可能性
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # tags (Optional)
  # 設定内容: 場所インデックスリソースに付与するタグを指定します。
  # 設定可能な値: キー・バリューペアのマップ
  # 用途:
  #   - コスト配分とリソース管理
  #   - アクセス制御（タグベースのIAMポリシー）
  #   - 環境やプロジェクトの識別
  # タグ戦略例:
  #   - Environment: 環境識別（production/staging/development）
  #   - Project: プロジェクト名
  #   - ManagedBy: 管理ツール（terraform等）
  #   - CostCenter: コストセンターコード
  # 参考: プロバイダーのdefault_tagsと併用可能
  #       https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    Project     = "example-app"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # データソース設定 (Optional)
  #-------------------------------------------------------------

  # data_source_configuration (Optional)
  # 設定内容: Places APIの結果をどのように保存するかを設定します。
  # 用途: ジオコーディング結果やPOIデータの保存ポリシーを定義
  data_source_configuration {
    # intended_use (Optional)
    # 設定内容: API操作の結果を呼び出し元がどのように保存するかを指定します。
    # 設定可能な値:
    #   - "SingleUse" (デフォルト): 一時的な使用のみ。結果を永続的に保存しない
    #                                検索やジオコーディングの結果を即座に使用し、
    #                                保存しない場合に使用
    #   - "Storage": 結果を永続的に保存する
    #                データベースやストレージに保存して後で再利用する場合に使用
    # 料金への影響:
    #   - "Storage"を選択した場合、追加のデータ保存料金が発生する可能性があります
    #   - データプロバイダーのライセンス条件により異なる料金体系が適用されます
    # 選択基準:
    #   - 検索結果を毎回APIから取得する場合: SingleUse
    #   - 検索結果をキャッシュまたはDBに保存する場合: Storage
    # 注意事項:
    #   - データプロバイダーの利用規約を確認してください
    #   - Storageを選択する場合、データの更新頻度も考慮が必要です
    # 参考: https://docs.aws.amazon.com/location/latest/developerguide/places.html
    intended_use = "SingleUse"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 場所インデックスの識別子（index_nameと同じ値）
#
# - index_arn: 場所インデックスリソースのAmazon Resource Name (ARN)
#       形式: arn:aws:geo:region:account-id:place-index/index-name
#       用途: IAMポリシーやリソースベースのポリシーで使用
#       参考: resource.aws_location_place_index.example.index_arn
#
# - create_time: 場所インデックスリソースが作成されたタイムスタンプ（ISO 8601形式）
#       例: 2024-01-15T10:30:00Z
#       参考: resource.aws_location_place_index.example.create_time
#
# - update_time: 場所インデックスリソースが最後に更新されたタイムスタンプ（ISO 8601形式）
#       例: 2024-01-20T15:45:30Z
#       参考: resource.aws_location_place_index.example.update_time
#
# - tags_all: リソースに割り当てられたすべてのタグ（プロバイダーのdefault_tagsを含む）
#       プロバイダーレベルで設定されたデフォルトタグも含まれます
#       参考: resource.aws_location_place_index.example.tags_all
#---------------------------------------------------------------

#---------------------------------------------------------------
