#---------------------------------------------------------------
# Amazon Location Service ルート計算機
#---------------------------------------------------------------
#
# Amazon Location Serviceのルート計算機リソースを作成します。
# ルート計算機は、複数の地点間の最適な経路を計算し、移動時間や距離を算出します。
# 配送ルートの最適化、ライドシェアのマッチング、フリート管理など、
# さまざまなユースケースで活用できます。
#
# AWS公式ドキュメント:
#   - Calculate routes: https://docs.aws.amazon.com/location/latest/developerguide/calculate-routes.html
#   - Calculate route matrix: https://docs.aws.amazon.com/location/latest/developerguide/calculate-route-matrix.html
#   - API Reference - CalculateRouteMatrix: https://docs.aws.amazon.com/location/previous/APIReference/API_CalculateRouteMatrix.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/location_route_calculator
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_location_route_calculator" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # calculator_name - ルート計算機リソースの名前
  # 用途: ルート計算機を識別するための名前を指定します
  # 制約: 一意である必要があります
  # 例: "my-route-calculator", "delivery-optimizer"
  calculator_name = "example-calculator"

  # data_source - 交通および道路ネットワークデータのプロバイダー
  # 用途: ルート計算に使用するデータソースを指定します
  # 指定可能な値:
  #   - "Esri" - Esriのデータとサービスを使用（グローバルカバレッジ）
  #   - "Here" - HEREのデータとサービスを使用（グローバルカバレッジ）
  #   - "Grab" - Grabのデータを使用（東南アジア地域に特化）
  # 選択基準:
  #   - グローバル展開: "Esri" または "Here"
  #   - 東南アジア: "Grab"（より詳細なローカルデータ）
  #   - GIS機能重視: "Esri"（GISソフトウェアのリーダー）
  # 例: "Here", "Esri", "Grab"
  # 参考: https://aws.amazon.com/location/data-providers/
  data_source = "Here"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # description - ルート計算機リソースの説明
  # 用途: ルート計算機の目的や用途を記述します
  # 制約: オプション
  # 例: "配送ルート最適化用のルート計算機", "タクシー配車サービス用"
  description = "Example route calculator for demonstration purposes"

  # id - Terraformリソース識別子
  # 用途: リソースの明示的なIDを指定します（通常は自動生成されます）
  # デフォルト: 自動生成（通常はcalculator_nameと同じ値）
  # 制約: ほとんどの場合、この属性を明示的に設定する必要はありません
  # 例: "example-calculator"
  # id = null

  # region - このリソースが管理されるリージョン
  # 用途: リソースを作成するAWSリージョンを明示的に指定します
  # デフォルト: プロバイダー設定のリージョンを使用
  # 制約: リージョナルエンドポイントが必要な場合に指定
  # 例: "us-east-1", "ap-northeast-1", "eu-west-1"
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags - ルート計算機のキー・バリュータグ
  # 用途: リソースの分類、管理、コスト配分などに使用します
  # 制約: プロバイダーのdefault_tagsとマージされます
  # 例:
  #   Environment = "production"
  #   Project     = "logistics"
  #   CostCenter  = "delivery-ops"
  tags = {
    Name        = "example-route-calculator"
    Environment = "development"
  }

  # tags_all - すべてのタグのマップ（プロバイダーのdefault_tagsを含む）
  # 用途: リソースに割り当てるすべてのタグを明示的に指定します
  # デフォルト: tagsとプロバイダーのdefault_tagsがマージされます
  # 制約: 通常はtagsの使用を推奨。tags_allは特殊なユースケースのみ
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags_all = {
  #   Name        = "example-route-calculator"
  #   Environment = "development"
  #   ManagedBy   = "Terraform"
  # }

  #---------------------------------------------------------------
  # タイムアウト設定（オプション）
  #---------------------------------------------------------------

  # timeouts - リソース操作のタイムアウト設定
  # 用途: 作成、更新、削除操作のタイムアウト時間を制御します
  # デフォルト: Terraformのデフォルトタイムアウトを使用
  timeouts {
    # create - リソース作成のタイムアウト
    # デフォルト: 30分
    # 例: "30m", "1h"
    create = "30m"

    # update - リソース更新のタイムアウト
    # デフォルト: 30分
    # 例: "30m", "1h"
    update = "30m"

    # delete - リソース削除のタイムアウト
    # デフォルト: 30分
    # 例: "30m", "1h"
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします（computed属性）:
#
# - calculator_arn
#     ルート計算機リソースのAmazon Resource Name (ARN)
#     AWS全体でリソースを指定する際に使用します
#     例: "arn:aws:geo:us-east-1:123456789012:route-calculator/example-calculator"
#
# - create_time
#     ルート計算機リソースが作成されたタイムスタンプ（ISO 8601形式）
#     例: "2024-01-15T10:30:00.000Z"
#
# - update_time
#     ルート計算機リソースが最後に更新されたタイムスタンプ（ISO 8601形式）
#     例: "2024-01-20T14:45:00.000Z"
#
# - tags_all
#     リソースに割り当てられたすべてのタグのマップ
#     プロバイダーのdefault_tags設定ブロックから継承されたタグを含みます
#     参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
#
# - id
#     Terraformリソース識別子
#     通常はcalculator_nameと同じ値になります
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例と参考情報
#---------------------------------------------------------------
#
# ルート計算機は、以下のようなユースケースで活用できます:
#
# 1. 配送ルート最適化
#    - 複数の配送先への最適な経路を計算
#    - 移動時間とコストを最小化
#
# 2. ライドシェアのマッチング
#    - ドライバーと乗客の最適なマッチング
#    - 到着予定時間の計算
#
# 3. フリート管理
#    - 車両の効率的なルート計画
#    - リアルタイムの交通情報に基づく経路最適化
#
# APIの使用方法:
#   - CalculateRoute: 単一の経路を計算
#   - CalculateRouteMatrix: 複数の出発地と目的地間のマトリックスを計算
#
# 対応する移動モード:
#   - Car（自動車）
#   - Truck（トラック）
#   - Walking（徒歩）
#   - Bicycle（自転車）
#
# カスタマイズオプション:
#   - 有料道路の回避
#   - フェリーの回避
#   - 高速道路の回避
#   - 交通状況の考慮
#   - 最速または最短経路の最適化
#
#---------------------------------------------------------------
