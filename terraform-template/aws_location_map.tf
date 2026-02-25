#---------------------------------------------------------------
# AWS Location Service Map
#---------------------------------------------------------------
#
# Amazon Location Service のマップリソースをプロビジョニングします。
# マップリソースは、アプリケーションに地図タイル・スタイルを提供するために
# 使用されます。マップスタイルに応じて、異なるプロバイダーのデータを利用した
# ビジュアル表現（道路地図・衛星写真・ハイブリッドなど）が選択できます。
#
# 主なユースケース:
#   - Webアプリケーションやモバイルアプリへの地図表示機能の追加
#   - 配送・ルーティングアプリの地図ベースUI
#   - 資産追跡ダッシュボードの背景地図
#   - GIS（地理情報システム）アプリケーションの地図レイヤー
#
# 重要な注意事項:
#   - マップスタイルによって利用可能なデータプロバイダーが異なります
#   - style の変更はリソースの再作成を引き起こします
#   - 地図タイルのアクセスには別途 API キーまたは Cognito 認証が必要です
#
# AWS公式ドキュメント:
#   - Amazon Location Service: https://docs.aws.amazon.com/location/latest/developerguide/
#   - マップスタイル一覧: https://docs.aws.amazon.com/location/latest/developerguide/map-concepts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/location_map
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_location_map" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # map_name (Required)
  # 設定内容: マップリソースの名前を指定します。
  # 設定可能な値: 英数字、ハイフン(-)、アンダースコア(_)、ピリオド(.)を含む文字列。1〜100文字
  # 省略時: 省略不可
  map_name = "example-map"

  # description (Optional)
  # 設定内容: マップリソースの説明文を指定します。
  # 設定可能な値: 最大1000文字の文字列
  # 省略時: 説明なし
  description = "Example Amazon Location Service map"

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # マップスタイル設定
  #---------------------------------------------------------------

  # configuration ブロック (Required)
  # 設定内容: マップの表示スタイルを定義するブロックです。
  # 設定可能な値: style を必須属性として持つブロック
  # 省略時: 省略不可
  configuration {
    # style (Required)
    # 設定内容: マップのビジュアルスタイルを指定します。
    # 設定可能な値:
    #   VectorEsriDarkGrayCanvas    - Esri ダークグレーキャンバス（ベクター）
    #   VectorEsriImagery           - Esri イメージリ（ベクター）
    #   VectorEsriLightGrayCanvas   - Esri ライトグレーキャンバス（ベクター）
    #   VectorEsriNavigation        - Esri ナビゲーション（ベクター）
    #   VectorEsriStreets           - Esri ストリーツ（ベクター）
    #   VectorEsriTopographic       - Esri トポグラフィック（ベクター）
    #   VectorHereContrast          - HERE コントラスト（ベクター）
    #   VectorHereExplore           - HERE エクスプローラー（ベクター）
    #   VectorHereExploreTruck      - HERE エクスプローラートラック（ベクター）
    #   RasterHereExploreSatellite  - HERE エクスプロアサテライト（ラスター）
    #   HybridHereExploreSatellite  - HERE ハイブリッドサテライト（ハイブリッド）
    #   VectorOpenDataStandardLight - Open Data 標準ライト（ベクター）
    #   VectorOpenDataStandardDark  - Open Data 標準ダーク（ベクター）
    #   VectorOpenDataVisualizationLight - Open Data ビジュアライゼーションライト
    #   VectorOpenDataVisualizationDark  - Open Data ビジュアライゼーションダーク
    # 省略時: 省略不可
    style = "VectorEsriNavigation"
  }

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグをキーと値のペアで指定します。
  # 設定可能な値: 最大50個のキーと値のペア。キーは最大128文字、値は最大256文字
  # 省略時: タグなし
  tags = {
    Name        = "example-map"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - create_time
#     マップリソースが作成された日時（ISO 8601形式）
#
# - map_arn
#     マップリソースのARN
#     例: arn:aws:geo:us-east-1:123456789012:map/example-map
#
# - update_time
#     マップリソースが最後に更新された日時（ISO 8601形式）
#
# - id
#     マップ名（map_name と同一）
#
# - tags_all
#     プロバイダーのデフォルトタグを含む全タグのマップ
#
