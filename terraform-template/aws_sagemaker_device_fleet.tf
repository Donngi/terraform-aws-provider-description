#---------------------------------------------------------------
# Amazon SageMaker Edge Manager デバイスフリート
#---------------------------------------------------------------
#
# Amazon SageMaker Edge Managerのデバイスフリートを管理するリソースです。
# デバイスフリートは、エッジデバイスをグループ化して管理するための単位です。
# SageMaker Edge Managerは、エッジデバイス上で機械学習モデルを最適化・
# デプロイ・監視するためのサービスです。
# デバイスフリートを作成してから、個々のデバイス (aws_sagemaker_device) を登録します。
#
# AWS公式ドキュメント:
#   - SageMaker Edge Manager概要: https://docs.aws.amazon.com/sagemaker/latest/dg/edge.html
#   - デバイスフリート作成ガイド: https://docs.aws.amazon.com/sagemaker/latest/dg/edge-device-fleet.html
#   - CreateDeviceFleet API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateDeviceFleet.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_device_fleet
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_device_fleet" "example" {
  #-------------------------------------------------------------
  # デバイスフリート基本設定
  #-------------------------------------------------------------

  # device_fleet_name (Required)
  # 設定内容: デバイスフリートの名前を指定します。
  # 設定可能な値: 1-63文字の文字列。パターン: [a-zA-Z0-9](-*[a-zA-Z0-9]){0,62}
  # 注意: フリート名はAWSアカウントおよびリージョン内で一意である必要があります。
  #       作成後は変更できません（変更には削除と再作成が必要です）。
  device_fleet_name = "my-device-fleet"

  # role_arn (Required)
  # 設定内容: デバイスフリートがAWSサービスにアクセスするために使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN（例: arn:aws:iam::123456789012:role/SageMakerEdgeRole）
  # 関連機能: IAMロール
  #   このロールには、S3バケットへの書き込み権限（モデルのデプロイ用）や
  #   IoT Coreへのアクセス権限など、Edge Managerが必要とする権限を付与します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/edge-device-fleet.html#edge-device-fleet-role
  role_arn = "arn:aws:iam::123456789012:role/SageMakerEdgeManagerRole"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: デバイスフリートの説明を指定します。
  # 設定可能な値: 任意の文字列（最大800文字）
  # 省略時: 説明なし
  description = "Production edge device fleet for image recognition models"

  # enable_iot_role_alias (Optional)
  # 設定内容: デバイスがAWS IoT Coreロールエイリアスを使用して認証するかどうかを指定します。
  # 設定可能な値: true / false
  # 省略時: false
  # 関連機能: AWS IoT Core ロールエイリアス
  #   有効にすると、デバイスはX.509証明書を使用してAWS IoT Coreに接続し、
  #   ロールエイリアスを通じてIAMロールの権限を取得します。
  #   この方法により、デバイスへの長期的なクレデンシャルの配布が不要になります。
  #   - https://docs.aws.amazon.com/iot/latest/developerguide/authorizing-direct-aws.html
  enable_iot_role_alias = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグのキーと値のマップを指定します。
  # 設定可能な値: 文字列キーと文字列値のマップ
  # 省略時: タグなし
  tags = {
    Name        = "my-device-fleet"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # 出力設定
  #-------------------------------------------------------------

  # output_config (Required, min_items: 1, max_items: 1)
  # 設定内容: デバイスフリートの出力先（S3バケット）を設定します。
  # 設定可能な値: output_configブロック（必須、1つのみ指定可能）
  # 関連機能: S3出力
  #   SageMaker Edge Managerは、デバイスのメトリクスやモデルのデプロイ結果を
  #   指定したS3バケットに書き込みます。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/edge-device-fleet.html#edge-device-fleet-s3
  output_config {
    # s3_output_location (Required)
    # 設定内容: 出力データを保存するS3バケットのURIを指定します。
    # 設定可能な値: S3 URI形式の文字列（例: s3://my-bucket/path/to/output）
    s3_output_location = "s3://my-sagemaker-edge-bucket/output"

    # kms_key_id (Optional)
    # 設定内容: S3に保存されるデータを暗号化するKMSキーのIDを指定します。
    # 設定可能な値: KMSキーID、キーARN、エイリアス名、またはエイリアスARN
    # 省略時: KMS暗号化なし（S3デフォルト暗号化が適用される場合があります）
    # 関連機能: AWS KMS統合
    #   機密性の高いモデルデータや推論結果を保護するために使用します。
    #   カスタマーマネージドキー（CMK）を指定することで、暗号化の制御が可能です。
    kms_key_id = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: デバイスフリートの名前（device_fleet_nameと同値）
#
# - arn: デバイスフリートのAmazon Resource Name (ARN)
#         例: arn:aws:sagemaker:us-east-1:123456789012:device-fleet/my-device-fleet
#
# - iot_role_alias: enable_iot_role_aliasが有効な場合に作成される
#                   AWS IoT Coreロールエイリアスの名前
#---------------------------------------------------------------
