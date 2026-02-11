#---------------------------------------------------------------
# AWS IoT Thing
#---------------------------------------------------------------
#
# AWS IoT Thingリソースを作成・管理します。
# IoT Thingは、AWS IoTに接続するデバイスやアプリケーションを表すレジストリエントリです。
# Thingには属性を付与でき、Thing Typeと関連付けることもできます。
#
# AWS公式ドキュメント:
#   - Managing devices with AWS IoT: https://docs.aws.amazon.com/iot/latest/developerguide/iot-thing-management.html
#   - Thing Registry: https://docs.aws.amazon.com/iot/latest/developerguide/thing-registry.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_thing
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_thing" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (必須) Thingの名前
  # - IoTレジストリ内で一意である必要があります
  # - 英数字、ハイフン、アンダースコアを使用可能
  # - 最大128文字
  name = "example-iot-thing"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (オプション) Thingの属性
  # - キーと値のペアのマップ
  # - デバイスのメタデータや追加情報を保存するために使用
  # - 最大50個の属性を設定可能
  # - 各属性値の最大長は800文字
  # 例:
  #   attributes = {
  #     SerialNumber = "ABC123456"
  #     Location     = "Building-A-Floor-3"
  #     Department   = "Manufacturing"
  #   }
  attributes = {
    First = "examplevalue"
  }

  # (オプション) Thing Typeの名前
  # - 事前に作成されたThing Type (aws_iot_thing_type) を指定
  # - Thing Typeは同じ特性を持つThingをグループ化するために使用
  # - Thing Type名を指定することで、そのTypeに定義された属性や設定を継承
  # - 一度設定すると変更できないため、注意が必要
  # 例: thing_type_name = "sensor-device-type"
  thing_type_name = null

  # (オプション) このリソースが管理されるAWSリージョン
  # - 明示的に指定しない場合、プロバイダー設定のリージョンが使用されます
  # - クロスリージョン管理が必要な場合に使用
  # 例: region = "us-west-2"
  region = null

  # (オプション) リソースID
  # - 通常は自動生成されるため、明示的な指定は不要
  # - インポート時やカスタムIDが必要な特殊なケースで使用
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference (Computed)
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動計算され、参照可能です。
# 設定ファイルには記載しませんが、他のリソースから参照できます。
#
# - arn: ThingのARN (Amazon Resource Name)
#   例: "arn:aws:iot:us-east-1:123456789012:thing/example-iot-thing"
#
# - default_client_id: デフォルトのクライアントID
#   MQTT接続時のデフォルトクライアントIDとして使用されます
#
# - version: Thingレコードの現在のバージョン
#   レジストリ内のThingレコードのバージョン番号
#
# 参照例:
#   aws_iot_thing.example.arn
#   aws_iot_thing.example.default_client_id
#   aws_iot_thing.example.version
#---------------------------------------------------------------
