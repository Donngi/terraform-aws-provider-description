#---------------------------------------------------------------
# Amazon SageMaker Edge Manager デバイス
#---------------------------------------------------------------
#
# Amazon SageMaker Edge Managerにデバイスを登録するためのリソースです。
# SageMaker Edge Managerは、エッジデバイス上で機械学習モデルを管理・運用する
# ためのサービスで、デバイスの登録はEdge Managerを使用するための前提条件です。
#
# AWS公式ドキュメント:
#   - SageMaker Edge Manager概要: https://docs.aws.amazon.com/sagemaker/latest/dg/edge.html
#   - デバイス登録ガイド: https://docs.aws.amazon.com/sagemaker/latest/dg/edge-device-fleet-register.html
#   - RegisterDevices API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_RegisterDevices.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_device
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_device" "example" {
  #-------------------------------------------------------------
  # デバイスフリート設定
  #-------------------------------------------------------------

  # device_fleet_name (Required)
  # 設定内容: デバイスが所属するデバイスフリートの名前を指定します。
  # 設定可能な値: 1-63文字の文字列。パターン: [a-zA-Z0-9](-*[a-zA-Z0-9]){0,62}
  # 関連機能: SageMaker Edge Manager デバイスフリート
  #   Edge Managerでは、デバイスをフリート（デバイスのグループ）として管理します。
  #   デバイスフリートはモデルのデプロイや監視の単位となります。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/edge-device-fleet-register.html
  # 注意: デバイスを登録する前に、デバイスフリートを作成しておく必要があります。
  device_fleet_name = "my-device-fleet"

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
  # デバイス設定
  #-------------------------------------------------------------

  # device (Required)
  # 設定内容: SageMaker Edge Managerに登録するデバイスの詳細を定義します。
  # 設定可能な値: deviceブロック（単一のみ指定可能、min_items: 1, max_items: 1）
  # 関連機能: Edge Manager デバイス登録
  #   デバイス名、説明、IoT Thing名を指定してデバイスを登録します。
  #   AWS IoT Coreとの統合により、デバイスとクラウド間の接続を管理できます。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/edge-device-fleet-register.html
  device {
    # device_name (Required)
    # 設定内容: デバイスの名前を指定します。
    # 設定可能な値: 文字列（フリート内で一意である必要があります）
    # 注意: この名前はデバイスフリート内で一意である必要があります。
    #       デバイスIDの一部として使用されます（device-fleet-name/device-name）。
    device_name = "my-edge-device-001"

    # description (Optional)
    # 設定内容: デバイスの説明を指定します。
    # 設定可能な値: 任意の文字列
    # 省略時: 説明なし
    # 用途: デバイスの用途や設置場所などの補足情報を記載
    description = "Production edge device for image recognition"

    # iot_thing_name (Optional)
    # 設定内容: デバイスに関連付けるAWS IoT Thing オブジェクトの名前を指定します。
    # 設定可能な値: 既存のAWS IoT Thing名
    # 省略時: IoT Thingとの関連付けなし
    # 関連機能: AWS IoT Core統合
    #   SageMaker Edge Managerは、AWS IoT Coreサービスを活用してエッジデバイスと
    #   クラウド間の接続を管理します。IoT Thingオブジェクトを事前に作成し、
    #   証明書とIAMロールを設定することで、デバイス認証とセキュアな通信が可能になります。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/edge-getting-started-step3.html
    #   - https://docs.aws.amazon.com/iot/latest/developerguide/iot-gs-first-thing.html
    # 注意: IoT Thingオブジェクトは事前にAWS IoT Coreで作成しておく必要があります。
    iot_thing_name = "my-iot-thing-001"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースのID。フォーマット: device-fleet-name/device-name
#
# - arn: デバイスのAmazon Resource Name (ARN)
#
# - agent_version: デバイスにインストールされているEdge Managerエージェントの
#                  バージョン（デバイスがハートビートを送信した後に利用可能）
#---------------------------------------------------------------
