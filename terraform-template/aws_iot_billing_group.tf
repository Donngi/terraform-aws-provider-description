#---------------------------------------------------------------
# AWS IoT Billing Group
#---------------------------------------------------------------
#
# AWS IoT Billing Groupは、IoT Thingをグループ化してコスト配分とタグ付けを
# 行うためのリソースです。個々のThingに直接タグを適用することはできませんが、
# Billing Groupを通じてタグベースでコストと使用量データを割り当てることができます。
#
# 主な用途:
#   - IoT Thingのコスト追跡とコスト配分
#   - タグベースの使用量レポート作成
#   - ビジネスカテゴリ（コストセンター、アプリケーション名、所有者等）による
#     IoTデバイスの分類
#
# 注意事項:
#   - AWS IoT Core for LoRaWANリソース（ワイヤレスデバイス、ゲートウェイ）は
#     直接Billing Groupに追加できませんが、AWS IoT Thingと関連付けることで
#     間接的にBilling Groupに含めることができます
#   - コストと使用量データを正確に関連付けるには、デバイスまたはアプリケーションが
#     以下の要件を満たす必要があります:
#       * AWS IoTにThingとして登録されている
#       * Thing名をクライアントIDとして使用してMQTT経由で接続する
#       * Thingに関連付けられたクライアント証明書を使用して認証する
#
# AWS公式ドキュメント:
#   - CreateBillingGroup API: https://docs.aws.amazon.com/iot/latest/apireference/API_CreateBillingGroup.html
#   - Billing Groups: https://docs.aws.amazon.com/iot/latest/developerguide/tagging-iot-billing-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_billing_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_billing_group" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # name - (Required) Billing Groupの名前
  # Billing Groupに付ける一意の名前を指定します。
  #
  # 制約事項:
  #   - 長さ: 1～128文字
  #   - 使用可能文字: 英数字、アンダースコア(_)、コロン(:)、ハイフン(-)
  #   - パターン: [a-zA-Z0-9:_-]+
  #
  # 同じ名前と設定で複数回呼び出された場合、呼び出しは成功します。
  # 同じ名前で異なる設定で呼び出された場合、ResourceAlreadyExistsExceptionが
  # スローされます。
  name = "example-billing-group"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # region - (Optional) このリソースが管理されるリージョン
  # リソースをプロビジョニングするAWSリージョンを明示的に指定します。
  # 指定しない場合、プロバイダー設定で設定されたリージョンがデフォルトで使用されます。
  #
  # 参考:
  #   - AWS Regional Endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #   - Provider Configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # 例: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"

  # tags - (Optional) リソースタグのキー・バリューマッピング
  # Billing Groupに適用するタグを指定します。
  # タグを使用することで、ビジネスカテゴリ（コストセンター、アプリケーション名、
  # 所有者など）に基づいて複数のサービスにわたるコストを整理できます。
  #
  # AWSは、タグを適用すると、タグによって集約された使用量とコストを含む
  # コスト配分レポートをCSVファイルとして生成します。
  #
  # 参考:
  #   - Cost Allocation Tags: https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/cost-alloc-tags.html
  #
  # 例:
  # tags = {
  #   Environment = "production"
  #   CostCenter  = "engineering"
  #   Application = "iot-sensors"
  #   Owner       = "iot-team"
  # }
  tags = {
    terraform = "true"
  }

  #---------------------------------------------------------------
  # Nested Blocks
  #---------------------------------------------------------------

  # properties - (Optional) Billing Groupのプロパティ
  # Billing Groupに関する追加情報を設定します。
  properties {
    # description - (Optional) Billing Groupの説明
    # Billing Groupの目的や用途を説明する任意のテキストを指定します。
    # このフィールドは、billingGroupDescriptionとしてAPI経由で渡されます。
    #
    # 例: "Production IoT sensors for factory floor monitoring"
    description = "This is my billing group"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性は、リソース作成後に参照可能です（computed）。
# これらは設定ファイルで指定することはできません。
#
# - arn
#   Billing GroupのAmazon Resource Name（ARN）
#   形式: arn:aws:iot:region:account-id:billinggroup/billing-group-name
#
# - id
#   Billing GroupのID
#   制約: 長さ1～128文字、パターン [a-zA-Z0-9\-]+
#
# - metadata
#   Billing Groupのメタデータ情報
#   構造: list of objects containing:
#     - creation_date: Billing Groupの作成日時（文字列）
#
# - tags_all
#   デフォルトタグを含む、リソースに割り当てられた全てのタグのマップ
#   プロバイダーレベルのdefault_tagsと、リソース固有のtagsをマージしたもの
#
# - version
#   レジストリ内のBilling Groupレコードの現在のバージョン番号
#   このバージョンは、更新操作時の楽観的ロックに使用されます
#
# 使用例:
#   output "billing_group_arn" {
#     value = aws_iot_billing_group.example.arn
#   }
#
#   output "billing_group_id" {
#     value = aws_iot_billing_group.example.id
#   }
#
#   output "billing_group_version" {
#     value = aws_iot_billing_group.example.version
#   }
#---------------------------------------------------------------

#---------------------------------------------------------------
# Pricing Dimensions for Billing Groups
#---------------------------------------------------------------
# Billing Group内のThingの活動に基づいて、以下の料金ディメンションが利用可能です:
#
# 1. Connectivity (接続性)
#    - クライアントIDとして使用されるThing名に基づく
#
# 2. Messaging (メッセージング)
#    - ThingからのインバウンドメッセージとThingへのアウトバウンドメッセージに基づく
#    - MQTTのみ対象
#
# 3. Shadow operations (シャドウ操作)
#    - シャドウ更新をトリガーしたThingに基づく
#
# 4. Rules triggered (ルールのトリガー)
#    - ルールをトリガーしたインバウンドメッセージのThingに基づく
#    - MQTTライフサイクルイベントによってトリガーされるルールには適用されません
#
# 5. Thing index updates (Thingインデックスの更新)
#    - インデックスに追加されたThingに基づく
#
# 6. Remote actions (リモートアクション)
#    - 更新されたThingに基づく
#
# 7. AWS IoT Device Defender detect reports
#    - 活動が報告されたThingに基づく
#
# 以下の活動はタグベースのコストと使用量データに反映されません:
#   - Device registry operations（Thing、Thing Group、Thing Typeの更新を含む）
#   - Thing group index updates（Thing Groupの追加時）
#   - Index search queries
#   - Device provisioning
#   - AWS IoT Device Defender audit reports
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のBilling Groupは、Billing Group名を使用してインポートできます:
#
#   terraform import aws_iot_billing_group.example example-billing-group
#
#---------------------------------------------------------------
