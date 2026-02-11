#---------------------------------------------------------------
# AWS CloudWatch Event API Destination
#---------------------------------------------------------------
#
# Amazon EventBridge（旧称 CloudWatch Events）のAPI Destinationリソースを
# プロビジョニングするリソースです。
# API Destinationを使用すると、EventBridgeからHTTPSエンドポイントを
# ターゲットとして呼び出すことができます。SaaSアプリケーション、
# 公開/非公開アプリケーションへのイベントルーティングに使用されます。
#
# AWS公式ドキュメント:
#   - API Destinations概要: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-api-destinations.html
#   - API Destination作成: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-api-destination-create.html
#   - CreateApiDestination API: https://docs.aws.amazon.com/eventbridge/latest/APIReference/API_CreateApiDestination.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_api_destination
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_event_api_destination" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: API Destinationの名前を指定します。
  # 設定可能な値: アカウント内で一意の名前。最大64文字。
  #   使用可能文字: 数字、大文字/小文字、.（ピリオド）、-（ハイフン）、_（アンダースコア）
  name = "my-api-destination"

  # description (Optional)
  # 設定内容: API Destinationの説明を指定します。
  # 設定可能な値: 最大512文字の文字列
  description = "API Destination for external webhook"

  #-------------------------------------------------------------
  # エンドポイント設定
  #-------------------------------------------------------------

  # invocation_endpoint (Required)
  # 設定内容: ターゲットとして呼び出すURLエンドポイントを指定します。
  # 設定可能な値: 有効なHTTPS URL
  #   - パートナーサービスが生成した有効なエンドポイント
  #   - パスパラメータのワイルドカードとして「*」を含めることが可能
  #     （TargetのHttpParametersから設定される）
  # 注意: プライベートエンドポイント（VPCエンドポイント等）はサポートされていません
  invocation_endpoint = "https://api.example.com/webhook/events"

  # http_method (Required)
  # 設定内容: エンドポイント呼び出し時に使用するHTTPメソッドを指定します。
  # 設定可能な値:
  #   - "GET": リソースの取得
  #   - "POST": リソースの作成
  #   - "PUT": リソースの更新（完全置換）
  #   - "PATCH": リソースの部分更新
  #   - "DELETE": リソースの削除
  #   - "HEAD": ヘッダー情報のみ取得
  #   - "OPTIONS": 通信オプションの確認
  http_method = "POST"

  #-------------------------------------------------------------
  # 接続設定
  #-------------------------------------------------------------

  # connection_arn (Required)
  # 設定内容: API Destinationに使用するEventBridge Connectionの
  #          ARN（Amazon Resource Name）を指定します。
  # 設定可能な値: 有効なEventBridge Connection ARN
  # 関連機能: EventBridge Connections
  #   API Destinationへの認証方法と認証情報を定義します。
  #   Connectionを作成すると、認証情報がSecrets Managerに保存されます。
  #   サポートされる認証タイプ: Basic認証、OAuth、APIキー
  #   - https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-api-destinations.html
  connection_arn = aws_cloudwatch_event_connection.example.arn

  #-------------------------------------------------------------
  # レート制限設定
  #-------------------------------------------------------------

  # invocation_rate_limit_per_second (Optional)
  # 設定内容: このAPI Destinationへの1秒あたりの最大呼び出し回数を指定します。
  # 設定可能な値: 0より大きい整数
  # 省略時: 300（デフォルト値）
  # 注意:
  #   - 設定値が生成されるイベント数より低い場合、24時間の再試行期間内に
  #     配信されないイベントが発生する可能性があります
  #   - 未配信イベントを処理するため、Dead Letter Queue (DLQ) の設定を推奨
  #   - API Destinationリクエストの最大クライアント実行タイムアウトは5秒です
  invocation_rate_limit_per_second = 300

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: API DestinationのAmazon Resource Name (ARN)
#
# - id: API Destinationの名前（nameと同じ値）
#---------------------------------------------------------------

#---------------------------------------------------------------
# 関連リソース例: EventBridge Connection
#---------------------------------------------------------------
# API Destinationには必ずConnectionが必要です。
# 以下は参考用のConnectionリソース例です。
#
# resource "aws_cloudwatch_event_connection" "example" {
#   name               = "my-connection"
#   description        = "Connection for API Destination"
#   authorization_type = "API_KEY"
#
#   auth_parameters {
#     api_key {
#       key   = "x-api-key"
#       value = "my-api-key-value"
#---------------------------------------------------------------
