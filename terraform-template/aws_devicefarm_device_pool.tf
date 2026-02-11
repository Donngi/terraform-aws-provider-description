#======================================================================================================
# AWS Device Farm Device Pool
#======================================================================================================
# Provides a resource to manage AWS Device Farm Device Pools.
# Device pools are collections of devices that you can use to run tests in AWS Device Farm.
#
# Generated: 2026-01-22
# Provider Version: 6.28.0
# Resource: aws_devicefarm_device_pool
#
# Note: この情報は生成時点（2026-01-22）のものです。
#       最新の仕様については公式ドキュメントを確認してください。
#
# References:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/devicefarm_device_pool
# - https://docs.aws.amazon.com/devicefarm/latest/developerguide/how-to-create-device-pool.html
# - https://docs.aws.amazon.com/devicefarm/latest/APIReference/API_CreateDevicePool.html
#======================================================================================================

resource "aws_devicefarm_device_pool" "example" {
  #------------------------------------------------------------------------------------------------------
  # Required Arguments
  #------------------------------------------------------------------------------------------------------

  # (Required) The name of the Device Pool
  # デバイスプールの名前。プロジェクト内でデバイスプールを識別するために使用されます。
  name = "example-device-pool"

  # (Required) The ARN of the project for the device pool.
  # このデバイスプールが属するDevice Farmプロジェクトのアマゾンリソースネーム（ARN）。
  # プロジェクトは事前に作成されている必要があります。
  # Example: arn:aws:devicefarm:us-west-2:123456789012:project:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  # Reference: https://docs.aws.amazon.com/devicefarm/latest/APIReference/API_Project.html
  project_arn = "arn:aws:devicefarm:us-west-2:123456789012:project:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  #------------------------------------------------------------------------------------------------------
  # Optional Arguments
  #------------------------------------------------------------------------------------------------------

  # (Optional) The device pool's description.
  # デバイスプールの説明。このプールの目的や使用方法を記載できます。
  description = "Example device pool for testing"

  # (Optional) The number of devices that Device Farm can add to your device pool.
  # Device Farmがこのデバイスプールに追加できるデバイスの最大数。
  # 設定しない場合、ルールに一致するすべてのデバイスが含まれます。
  # Note: 追加料金を避けるため、実際の並列実行数とデバイスの多様性要件に合わせて設定することを推奨します。
  # Reference: https://docs.aws.amazon.com/devicefarm/latest/developerguide/how-to-create-device-pool.html
  max_devices = 10

  # (Optional) Region where this resource will be managed.
  # このリソースが管理されるリージョン。指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # Note: Device Farmは特定のリージョンでのみ利用可能です（主にus-west-2）。
  # Reference: https://docs.aws.amazon.com/general/latest/gr/devicefarm.html
  region = "us-west-2"

  # (Optional) A map of tags to assign to the resource.
  # リソースに割り当てるタグのマップ。リソースの分類、コスト管理、アクセス制御などに使用できます。
  # If configured with a provider default_tags configuration block present,
  # tags with matching keys will overwrite those defined at the provider-level.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Environment = "development"
    Project     = "mobile-testing"
    ManagedBy   = "terraform"
  }

  # (Optional) A map of tags assigned to the resource, including those inherited from the provider.
  # プロバイダーレベルで設定されたdefault_tagsも含む、リソースに割り当てられたすべてのタグ。
  # Note: このフィールドは computed 属性でもあるため、通常は明示的に設定する必要はありません。
  # tags_all = {}

  #------------------------------------------------------------------------------------------------------
  # Nested Blocks
  #------------------------------------------------------------------------------------------------------

  # (Required) The device pool's rules. At least one rule is required.
  # デバイスプールのルール。デバイスプールに含めるデバイスを選択するための条件を定義します。
  # 複数のルールを指定でき、いずれかのルールに一致するデバイスがプールに含まれます（OR条件）。
  # Reference: https://docs.aws.amazon.com/devicefarm/latest/APIReference/API_Rule.html

  # Example 1: プラットフォームでフィルタリング（Androidデバイス）
  rule {
    # (Optional) The rule's stringified attribute.
    # ルールの属性。デバイスのどの特性を評価するかを指定します。
    # Valid values:
    # - ARN: デバイスのARN
    # - PLATFORM: プラットフォーム（ANDROID または IOS）
    # - FORM_FACTOR: フォームファクター（PHONE または TABLET）
    # - MANUFACTURER: 製造元（例: Apple, Samsung）
    # - REMOTE_ACCESS_ENABLED: リモートアクセスが有効か（TRUE または FALSE）
    # - REMOTE_DEBUG_ENABLED: リモートデバッグが有効か（TRUE または FALSE）※非推奨
    # - APPIUM_VERSION: Appiumのバージョン
    # - INSTANCE_ARN: デバイスインスタンスのARN
    # - INSTANCE_LABELS: インスタンスラベル
    # - FLEET_TYPE: フリートタイプ（PUBLIC または PRIVATE）
    # - OS_VERSION: OSバージョン（例: 10.3.2）
    # - MODEL: デバイスモデル（例: iPad Air 2, Pixel）
    # - AVAILABILITY: 利用可能性（AVAILABLE, HIGHLY_AVAILABLE, BUSY, TEMPORARY_NOT_AVAILABLE）
    # Reference: https://docs.aws.amazon.com/devicefarm/latest/APIReference/API_Rule.html
    attribute = "PLATFORM"

    # (Optional) Specifies how Device Farm compares the rule's attribute to the value.
    # Device Farmがルールの属性を値と比較する方法を指定します。
    # Valid operators:
    # - EQUALS: 等しい
    # - LESS_THAN: 未満
    # - LESS_THAN_OR_EQUALS: 以下
    # - GREATER_THAN: より大きい
    # - GREATER_THAN_OR_EQUALS: 以上
    # - IN: いずれかに含まれる
    # - NOT_IN: いずれにも含まれない
    # - CONTAINS: 含む
    # Note: 各属性でサポートされる演算子は異なります。詳細はAWS公式ドキュメントを参照してください。
    # Reference: https://docs.aws.amazon.com/devicefarm/latest/APIReference/API_Rule.html
    operator = "EQUALS"

    # (Optional) The rule's value.
    # ルールの値。attributeで指定した特性と比較する値を指定します。
    # Note: 値は文字列として指定します。複数の値を指定する場合（IN, NOT_IN）はJSON配列形式で指定します。
    value = "ANDROID"
  }

  # Example 2: OSバージョンでフィルタリング（Android 11以上）
  rule {
    attribute = "OS_VERSION"
    operator  = "GREATER_THAN_OR_EQUALS"
    value     = "11"
  }

  # Example 3: 利用可能性でフィルタリング（利用可能なデバイスのみ）
  rule {
    attribute = "AVAILABILITY"
    operator  = "EQUALS"
    value     = "AVAILABLE"
  }

  # Example 4: フォームファクターでフィルタリング（スマートフォンのみ）
  rule {
    attribute = "FORM_FACTOR"
    operator  = "EQUALS"
    value     = "PHONE"
  }

  # Example 5: 製造元でフィルタリング（複数の製造元）
  # Note: IN演算子を使用する場合、valueはJSON配列形式で指定します
  rule {
    attribute = "MANUFACTURER"
    operator  = "IN"
    value     = "[\"Samsung\",\"Google\"]"
  }

  # Example 6: モデル名でフィルタリング（部分一致）
  rule {
    attribute = "MODEL"
    operator  = "CONTAINS"
    value     = "Pixel"
  }

  # Example 7: リモートアクセス有効デバイスのみ
  rule {
    attribute = "REMOTE_ACCESS_ENABLED"
    operator  = "EQUALS"
    value     = "TRUE"
  }

  # Example 8: Appiumバージョンでフィルタリング
  rule {
    attribute = "APPIUM_VERSION"
    operator  = "CONTAINS"
    value     = "1.22"
  }

  # Example 9: フリートタイプでフィルタリング（パブリックデバイス）
  rule {
    attribute = "FLEET_TYPE"
    operator  = "EQUALS"
    value     = "PUBLIC"
  }

  # Example 10: 特定のデバイスARNを指定
  rule {
    attribute = "ARN"
    operator  = "EQUALS"
    value     = "arn:aws:devicefarm:us-west-2::device:12345EXAMPLE"
  }

  # Example 11: インスタンスラベルでフィルタリング
  rule {
    attribute = "INSTANCE_LABELS"
    operator  = "CONTAINS"
    value     = "high-performance"
  }
}

#======================================================================================================
# Computed Attributes (Read-Only)
#======================================================================================================
# 以下の属性はTerraformによって自動的に計算され、読み取り専用です。
# これらは output や data source での参照に使用できます。
#
# - arn (string)
#   The Amazon Resource Name of this Device Pool
#   このデバイスプールのAmazon Resource Name（ARN）。
#   Example: arn:aws:devicefarm:us-west-2:123456789012:devicepool:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
#
# - type (string)
#   The device pool type.
#   デバイスプールのタイプ（例: CURATED, PRIVATE）。
#
# - tags_all (map of string)
#   A map of tags assigned to the resource, including those inherited from the provider default_tags.
#   プロバイダーのdefault_tagsから継承されたタグを含む、リソースに割り当てられたすべてのタグ。
#======================================================================================================

#======================================================================================================
# Usage Notes
#======================================================================================================
# 1. デバイスプールは、テストを実行するデバイスのセットを定義します。
#    複数のruleブロックを使用して、柔軟なデバイス選択が可能です。
#
# 2. ruleブロックはOR条件で評価されます。いずれかのルールに一致するデバイスがプールに含まれます。
#
# 3. max_devicesを設定することで、コストを管理できます。設定しない場合、ルールに一致する
#    すべてのデバイスが含まれるため、想定外の料金が発生する可能性があります。
#
# 4. Device Farmは主にus-west-2リージョンで利用可能です。regionパラメータで明示的に指定することを推奨します。
#
# 5. REMOTE_DEBUG_ENABLEDフィルターは非推奨となっており、無視されます。
#
# 6. attributeとoperatorの組み合わせには制約があります。各属性でサポートされる演算子は
#    AWS公式ドキュメントを参照してください。
#
# 7. valueフィールドで複数の値を指定する場合（IN, NOT_IN演算子）は、JSON配列形式で記述します。
#    Example: value = "[\"value1\",\"value2\"]"
#======================================================================================================

