#---------------------------------------------------------------
# Spot Datafeed Subscription（スポットインスタンスデータフィード購読）
#---------------------------------------------------------------
#
# EC2スポットインスタンスの使用状況と料金情報を記録するデータフィードを
# 設定します。このデータフィードは指定したAmazon S3バケットに送信されます。
# アカウントごとに1つのサブスクリプションのみ作成可能です。
#
# AWS公式ドキュメント:
#   - CreateSpotDatafeedSubscription API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateSpotDatafeedSubscription.html
#   - Spot Instance データフィードの例: https://docs.aws.amazon.com/ec2/latest/devguide/example_ec2_CreateSpotDatafeedSubscription_section.html
#   - SpotDatafeedSubscription: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_SpotDatafeedSubscription.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/spot_datafeed_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_spot_datafeed_subscription" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # bucket - (Required) スポットインスタンスデータフィードを保存するAmazon S3バケット名
  #
  # データフィードには、スポットインスタンスの使用状況とメタデータが含まれます。
  # ファイル名の形式: <BucketName>.s3.amazonaws.com/<Prefix>/<OwnerID>.<Year>-<Month>-<Day>-<Hour>.<Number>.<Hash>.gz
  #
  # 例: "my-spot-datafeed-bucket"
  bucket = "my-spot-datafeed-bucket"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # prefix - (Optional) S3バケット内のデータフィードファイルを保存するフォルダパス
  #
  # データフィードファイルを整理するためのプレフィックス（接頭辞）を指定します。
  # プレフィックスを指定することで、バケット内のサブディレクトリにファイルを保存できます。
  #
  # 例: "spot-data/production/"
  # デフォルト: null（バケットのルートに保存）
  prefix = null

  # region - (Optional) このリソースを管理するAWSリージョン
  #
  # リソースを特定のリージョンで管理したい場合に指定します。
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  #
  # リージョンエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # プロバイダー設定: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # 例: "us-east-1"
  # デフォルト: プロバイダー設定のリージョン
  region = null
}

#---------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------------------------------
# このリソースのapply後に参照可能な属性:
#
# - id: リソースのID（自動生成）
#   例: output "datafeed_id" { value = aws_spot_datafeed_subscription.example.id }
#
