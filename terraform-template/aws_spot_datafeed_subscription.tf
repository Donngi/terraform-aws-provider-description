#---------------------------------------------------------------
# AWS EC2 Spot Instance Data Feed Subscription
#---------------------------------------------------------------
#
# Amazon EC2スポットインスタンスのデータフィードサブスクリプションをプロビジョニングするリソースです。
# スポットインスタンスの使用状況と料金を把握するために、Amazon EC2が提供するデータフィードを
# 指定したAmazon S3バケットへ送信するサブスクリプションを設定します。
# データフィードファイルは通常1時間ごとにバケットへ届き、gzip形式で圧縮されています。
#
# 注意: AWSアカウントごとに作成できるサブスクリプションは1つのみです。
#
# AWS公式ドキュメント:
#   - Spot Instanceデータフィード: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-data-feeds.html
#   - CreateSpotDatafeedSubscription API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateSpotDatafeedSubscription.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/spot_datafeed_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_spot_datafeed_subscription" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: スポットインスタンスのデータフィードを保存するAmazon S3バケット名を指定します。
  # 設定可能な値: 有効なS3バケット名文字列
  # 注意: バケットに対してFULL_CONTROL権限が必要です。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-data-feeds.html
  bucket = "my-spot-datafeed-bucket"

  # prefix (Optional)
  # 設定内容: データフィードファイルを保存するバケット内のフォルダパス（プレフィックス）を指定します。
  # 設定可能な値: 任意の文字列（例: "spot-data-feed", "logs/spot"）
  # 省略時: バケットのルートにデータフィードファイルが保存されます。
  # 参考: データフィードファイル名の形式は以下の通りです:
  #        <bucket-name>.s3.amazonaws.com/<prefix>/<aws-account-id>.YYYY-MM-DD-HH.n.<unique-id>.gz
  prefix = "spot-data-feed"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 注意: スポットインスタンスデータフィードは、中国（北京）、中国（寧夏）、
  #       AWS GovCloud (US)、およびデフォルトで無効なリージョンではサポートされていません。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: データフィードサブスクリプションのID（AWSアカウントIDと同一）
#---------------------------------------------------------------
