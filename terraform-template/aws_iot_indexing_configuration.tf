#---------------------------------------------------------------
# AWS IoT Fleet Indexing Configuration
#---------------------------------------------------------------
#
# AWS IoTのフリートインデックス機能の設定を管理するリソース。
# Thing（デバイス）やThing Group（デバイスグループ）のインデックスを有効化し、
# レジストリデータ、Device Shadow、接続状態、Device Defenderの違反データなどを
# 検索・集約可能にします。
#
# AWS公式ドキュメント:
#   - Manage thing indexing: https://docs.aws.amazon.com/iot/latest/developerguide/managing-index.html
#   - Managing fleet indexing: https://docs.aws.amazon.com/iot/latest/developerguide/managing-fleet-index.html
#   - Fleet indexing: https://docs.aws.amazon.com/iot/latest/developerguide/iot-indexing.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_indexing_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_indexing_configuration" "example" {
  # =========================================================================
  # Top-level Attributes
  # =========================================================================

  # region - (Optional) リソースが管理されるAWSリージョンを指定します。
  # 指定しない場合はプロバイダー設定のリージョンが使用されます。
  # Type: string
  # Default: プロバイダー設定のリージョン
  # Example: "us-east-1"
  region = null

  # =========================================================================
  # Thing Group Indexing Configuration
  # =========================================================================

  # thing_group_indexing_configuration - (Optional) Thing Groupのインデックス設定。
  # Thing Groupに対してフリートインデックスを有効化し、グループ属性やメタデータを
  # 検索・集約できるようにします。
  # Max items: 1（最大1つのブロックのみ指定可能）
  thing_group_indexing_configuration {
    # thing_group_indexing_mode - (Required) Thing Groupインデックスモード。
    # - OFF: インデックスを無効化
    # - ON: Thing Groupのレジストリデータをインデックス
    # Type: string
    # Valid values: "OFF", "ON"
    thing_group_indexing_mode = "ON"

    # -----------------------------------------------------------------------
    # Custom Fields (Thing Group)
    # -----------------------------------------------------------------------

    # custom_field - (Optional) Thing Groupのカスタムフィールドのリスト。
    # Thing Groupの属性や拡張データを検索・集約クエリで使用できるようにします。
    # 管理フィールド（managed field）を含めることはできません。
    # 集約クエリで使用できるカスタムフィールドの最大数は5です。
    # Type: set of objects
    custom_field {
      # name - (Optional) フィールド名。Thing Groupの属性パスを指定します。
      # 例: "attributes.location", "attributes.version"
      # Type: string
      name = null

      # type - (Optional) フィールドのデータ型。
      # データ型に基づいて集約クエリが実行されます。
      # Type: string
      # Valid values: "Number", "String", "Boolean"
      type = null
    }

    # -----------------------------------------------------------------------
    # Managed Fields (Thing Group)
    # -----------------------------------------------------------------------

    # managed_field - (Optional) Thing Groupの管理フィールドのリスト。
    # フリートインデックスサービスによって既に型が認識されているフィールドを指定します。
    # Thing Group名、説明、属性などの標準的なメタデータが含まれます。
    # Type: set of objects
    managed_field {
      # name - (Optional) 管理フィールド名。
      # Type: string
      name = null

      # type - (Optional) フィールドのデータ型。
      # Type: string
      # Valid values: "Number", "String", "Boolean"
      type = null
    }
  }

  # =========================================================================
  # Thing Indexing Configuration
  # =========================================================================

  # thing_indexing_configuration - (Optional) Thingのインデックス設定。
  # デバイス（Thing）に対してフリートインデックスを有効化し、レジストリデータ、
  # Device Shadow、接続状態、Device Defenderの違反データを検索・集約できるようにします。
  # Max items: 1（最大1つのブロックのみ指定可能）
  thing_indexing_configuration {
    # thing_indexing_mode - (Required) Thingインデックスモード。
    # - OFF: インデックスを無効化
    # - REGISTRY: レジストリデータ（Thing属性など）のみインデックス
    # - REGISTRY_AND_SHADOW: レジストリとDevice Shadowの両方をインデックス
    # Type: string
    # Valid values: "REGISTRY", "REGISTRY_AND_SHADOW", "OFF"
    thing_indexing_mode = "REGISTRY_AND_SHADOW"

    # device_defender_indexing_mode - (Optional) Device Defenderインデックスモード。
    # Device Defenderによって検出されたセキュリティ違反データをインデックスします。
    # Type: string
    # Valid values: "VIOLATIONS", "OFF"
    # Default: "OFF"
    device_defender_indexing_mode = "VIOLATIONS"

    # named_shadow_indexing_mode - (Optional) Named Shadowインデックスモード。
    # 名前付きシャドウ（Named Shadow）をインデックスに含めるかどうかを制御します。
    # ONに設定する場合は、filterブロックでnamed_shadow_namesを指定する必要があります。
    # Type: string
    # Valid values: "ON", "OFF"
    # Default: "OFF"
    # Reference: https://docs.aws.amazon.com/iot/latest/developerguide/iot-device-shadows.html
    named_shadow_indexing_mode = "ON"

    # thing_connectivity_indexing_mode - (Optional) Thing接続状態インデックスモード。
    # デバイスの接続状態（オンライン/オフライン）をインデックスします。
    # Type: string
    # Valid values: "STATUS", "OFF"
    # Default: "OFF"
    thing_connectivity_indexing_mode = "STATUS"

    # -----------------------------------------------------------------------
    # Custom Fields (Thing)
    # -----------------------------------------------------------------------

    # custom_field - (Optional) Thingのカスタムフィールドのリスト。
    # Thing属性、Device Shadow、Device Defender違反データから特定のフィールドを
    # インデックスに追加し、検索・集約クエリで使用できるようにします。
    # 指定するフィールドパスは、選択したthingIndexingModeに依存します。
    # 例えば、REGISTRYモードではシャドウのフィールドは指定できません。
    # 集約クエリで使用できるカスタムフィールドの最大数は5です。
    # Type: set of objects
    custom_field {
      # name - (Optional) フィールド名。ピリオド区切りのパスで指定します。
      # 例:
      #   - "shadow.desired.power" - クラシックシャドウの desired.power
      #   - "attributes.version" - Thing属性の version
      #   - "shadow.name.thing1shadow.desired.DefaultDesired" - Named Shadowのフィールド
      #   - "deviceDefender.securityProfile1.NUMBER_VALUE_BEHAVIOR.lastViolationValue.number"
      # Type: string
      name = null

      # type - (Optional) フィールドのデータ型。
      # データ型に基づいて集約クエリが実行されます。
      # Type: string
      # Valid values: "Number", "String", "Boolean"
      type = null
    }

    # -----------------------------------------------------------------------
    # Filter Configuration
    # -----------------------------------------------------------------------

    # filter - (Optional) インデックスフィルター設定。
    # Named Shadowや位置情報データなど、追加でインデックスに含めるデータを選択します。
    # named_shadow_indexing_modeが"ON"の場合は必須です。
    # Max items: 1（最大1つのブロックのみ指定可能）
    filter {
      # named_shadow_names - (Optional) インデックスに含めるNamed Shadowの名前リスト。
      # named_shadow_indexing_modeが"ON"の場合に、どのNamed Shadowをインデックスに
      # 追加するかを指定します。
      # Type: set of strings
      # Example: ["thing1shadow", "locationShadow", "configShadow"]
      named_shadow_names = []
    }

    # -----------------------------------------------------------------------
    # Managed Fields (Thing)
    # -----------------------------------------------------------------------

    # managed_field - (Optional) Thingの管理フィールドのリスト。
    # フリートインデックスサービスによって既に型が認識されているフィールドを指定します。
    # Thing名、Thing Group、属性、接続状態、Device Defender違反データなどが含まれます。
    # Type: set of objects
    managed_field {
      # name - (Optional) 管理フィールド名。
      # Type: string
      name = null

      # type - (Optional) フィールドのデータ型。
      # Type: string
      # Valid values: "Number", "String", "Boolean"
      type = null
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed only）。

# id - リソースのID。regionと同じ値になります。
# Type: string
# Example: "us-east-1"
