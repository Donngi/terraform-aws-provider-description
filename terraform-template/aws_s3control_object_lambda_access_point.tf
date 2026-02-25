#---------------------------------------------------------------
# S3 Control Object Lambda Access Point
#---------------------------------------------------------------
#
# S3 Object Lambdaアクセスポイントをプロビジョニングするリソースです。
# S3 Object Lambdaアクセスポイントは、通常のS3アクセスポイントにLambda関数を
# 関連付け、S3からオブジェクトを取得する際にLambda関数でデータを動的に変換します。
# データのフィルタリング、マスキング、変換などをアプリケーション側の変更なしに
# 実現できます。
#
# AWS公式ドキュメント:
#   - S3 Object Lambda概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/transforming-objects.html
#   - Object Lambdaアクセスポイントの作成: https://docs.aws.amazon.com/AmazonS3/latest/userguide/olap-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_object_lambda_access_point
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_object_lambda_access_point" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Object Lambdaアクセスポイントの名前を指定します。
  # 設定可能な値: 3-50文字の小文字英数字およびハイフン（先頭・末尾はハイフン不可）
  name = "example-olap"

  # account_id (Optional)
  # 設定内容: Object Lambdaアクセスポイントを作成するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーで自動的に決定されるアカウントIDを使用
  account_id = null

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Object Lambda設定
  #-------------------------------------------------------------

  # configuration (Required, 1件)
  # 設定内容: Object Lambdaアクセスポイントの動作設定を指定します。
  # 関連機能: Object Lambda設定
  #   関連付けるS3アクセスポイント、許可する拡張機能、Lambda変換設定などを定義します。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/olap-create.html
  configuration {
    # supporting_access_point (Required)
    # 設定内容: Object Lambdaアクセスポイントの基盤となるS3アクセスポイントのARNを指定します。
    # 設定可能な値: 有効なS3アクセスポイントのARN
    #   例: "arn:aws:s3:ap-northeast-1:123456789012:accesspoint/my-access-point"
    supporting_access_point = "arn:aws:s3:ap-northeast-1:123456789012:accesspoint/my-access-point"

    # allowed_features (Optional)
    # 設定内容: Object Lambdaアクセスポイントで有効にする拡張機能の一覧を指定します。
    # 設定可能な値:
    #   - "GetObject-Range": Range GETリクエストのLambda変換を有効化
    #   - "GetObject-PartNumber": GetObject PartNumberリクエストのLambda変換を有効化
    #   - "HeadObject-Range": Range HEADリクエストのLambda変換を有効化
    #   - "HeadObject-PartNumber": HeadObject PartNumberリクエストのLambda変換を有効化
    # 省略時: 拡張機能は有効化されません
    allowed_features = null

    # cloud_watch_metrics_enabled (Optional)
    # 設定内容: Object LambdaアクセスポイントのCloudWatchメトリクス収集を有効化するかを指定します。
    # 設定可能な値:
    #   - true: CloudWatchメトリクスを有効化する（追加料金が発生する場合があります）
    #   - false: CloudWatchメトリクスを無効化する
    # 省略時: false
    cloud_watch_metrics_enabled = false

    #-----------------------------------------------------------
    # Lambda変換設定
    #-----------------------------------------------------------

    # transformation_configuration (Required, 1件以上)
    # 設定内容: Object Lambdaアクセスポイントで適用するLambda変換の設定を指定します。
    # 関連機能: Lambda変換ルール
    #   S3のAPIアクション（GetObject, HeadObjectなど）とLambda関数の変換処理を
    #   紐付けるルールを定義します。複数ブロックで複数ルールを設定できます。
    #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/olap-writing-lambda.html
    transformation_configuration {
      # actions (Required)
      # 設定内容: このLambda変換を適用するS3 APIアクションの一覧を指定します。
      # 設定可能な値:
      #   - "GetObject": S3 GetObjectリクエストにLambda変換を適用する
      #   - "HeadObject": S3 HeadObjectリクエストにLambda変換を適用する
      #   - "ListObjects": S3 ListObjectsリクエストにLambda変換を適用する
      #   - "ListObjectsV2": S3 ListObjectsV2リクエストにLambda変換を適用する
      actions = ["GetObject"]

      #---------------------------------------------------------
      # コンテンツ変換設定
      #---------------------------------------------------------

      # content_transformation (Required, 1件)
      # 設定内容: Object Lambdaアクセスポイントで使用するLambda関数の設定を指定します。
      # 関連機能: Lambda関数変換
      #   S3からオブジェクトを取得する際に呼び出されるLambda関数を定義します。
      #   Lambda関数はS3からのレスポンスを受け取り、変換後のレスポンスを返します。
      #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/olap-writing-lambda.html
      content_transformation {
        # aws_lambda (Required, 1件)
        # 設定内容: Object Lambdaアクセスポイントで使用するAWS Lambda関数の詳細を指定します。
        aws_lambda {
          # function_arn (Required)
          # 設定内容: データ変換に使用するLambda関数のARNを指定します。
          # 設定可能な値: 有効なLambda関数ARN（バージョン・エイリアス指定も可）
          #   例: "arn:aws:lambda:ap-northeast-1:123456789012:function:my-transform-function"
          function_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:my-transform-function"

          # function_payload (Optional)
          # 設定内容: Lambda関数に渡す追加ペイロード（カスタムパラメータ）をJSON文字列で指定します。
          # 設定可能な値: JSON形式の文字列（最大1MB）
          # 省略時: 追加ペイロードなしでLambda関数が呼び出されます
          function_payload = null
        }
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWSアカウントIDとアクセスポイント名をコロンで結合した識別子
#       (形式: account_id:access_point_name)
#
# - alias: Object Lambdaアクセスポイントのエイリアス名
#
# - arn: Object LambdaアクセスポイントのAmazon Resource Name (ARN)
#---------------------------------------------------------------
