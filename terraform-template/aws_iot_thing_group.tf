#---------------------------------------------------------------
# AWS IoT Thing Group
#---------------------------------------------------------------
#
# AWS IoT Thing Groupは、IoTデバイス（Thing）を論理的にグループ化して
# 一括管理を可能にするリソースです。静的なグループとして機能し、
# 複数のThingをグループに追加して、グループ単位でポリシーの適用、
# ジョブの実行、ログ設定などを行うことができます。
#
# 主な用途:
# - デバイスの階層的な組織化（機能、セキュリティ要件などで分類）
# - グループ単位でのポリシー管理とアクセス制御
# - 一括デバイス登録とグループ設定
# - グループ全体へのジョブ送信とOTAアップデート
# - グループ属性によるデバイス情報の管理
#
# AWS公式ドキュメント:
#   - Static thing groups: https://docs.aws.amazon.com/iot/latest/developerguide/thing-groups.html
#   - Thing Group API Reference: https://docs.aws.amazon.com/iot/latest/apireference/API_ThingGroupDocument.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_thing_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_thing_group" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # Thing Groupの名前
  # - 最小長: 1文字、最大長: 128文字
  # - パターン: [a-zA-Z0-9:_-]+
  # - グループ名は作成後に変更できません
  # - 個人を特定できる情報（PII）は使用しないでください
  # - 国際文字（û、é、ñなど）は使用できません
  name = "example-thing-group"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # 親Thing Groupの名前
  # - Thing Groupは階層構造を持つことができます
  # - グループは最大1つの直接の親のみを持つことができます
  # - 親グループはこのグループの作成時に指定する必要があります
  #   （作成後に親を変更することはできません）
  # - 階層の最大深度には制限があります
  # - 親グループに適用されたポリシーは子グループに継承されます
  # - 例: parent_group_name = aws_iot_thing_group.parent.name
  parent_group_name = null

  # リージョン指定
  # - このリソースを管理するAWSリージョンを指定します
  # - 指定しない場合、プロバイダー設定のリージョンがデフォルトとして使用されます
  # - マルチリージョン構成で明示的にリージョンを分ける場合に使用します
  # - 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # リソースタグ
  # - Thing Groupに適用するキー/バリューペアのメタデータ
  # - コスト配分、リソース管理、アクセス制御などに使用できます
  # - タグは親グループには継承されません
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # すべてのタグ（プロバイダーレベルのデフォルトタグを含む）
  # - プロバイダー設定で定義されたdefault_tagsと、
  #   このリソース固有のtagsがマージされたものです
  # - 通常は明示的に設定する必要はありません（自動的に管理されます）
  # - タグポリシーで一貫性を保つために使用されます
  tags_all = null

  #---------------------------------------------------------------
  # Thing Group Properties（グループプロパティ）
  #---------------------------------------------------------------

  # Thing Groupのプロパティ設定
  # - グループの説明文と属性ペイロードを定義できます
  # - 属性はデバイス管理やクエリに使用できます
  # - 最大1つのpropertiesブロックのみ指定可能です
  properties {
    # グループの説明文
    # - 最大長: 2028文字
    # - パターン: [\p{Graph}\x20]*
    # - グループの目的や用途を説明するために使用します
    description = "Example IoT Thing Group for production devices"

    # 属性ペイロード
    # - Thing Groupに関連付けるカスタム属性を定義します
    # - 属性数には制限があります
    # - キーと値の長さにも制限があります（キー: 最大128文字、値: 最大800文字）
    attribute_payload {
      # カスタム属性のキー/バリューマップ
      # - デバイスの特性や設定情報を保存できます
      # - Fleet Indexingが有効な場合、属性で検索やフィルタリングが可能です
      # - 例: デバイスタイプ、ファームウェアバージョン、ロケーションなど
      attributes = {
        DeviceType       = "sensor"
        FirmwareVersion  = "1.0.0"
        Location         = "warehouse-1"
        MaintenanceLevel = "standard"
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference（読み取り専用の属性）
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、参照のみ可能です。
#
# - arn (string)
#   Thing GroupのAmazon Resource Name (ARN)
#   例: arn:aws:iot:us-west-2:123456789012:thinggroup/example-thing-group
#
# - id (string)
#   Thing GroupのID（通常は名前と同じ）
#   Terraform内で他のリソースから参照する際に使用します
#
# - metadata (list of object)
#   Thing Groupのメタデータ情報
#   - creation_date: グループの作成日時（UNIXタイムスタンプ）
#   - parent_group_name: 親グループの名前
#   - root_to_parent_groups: ルートから親までのグループ階層リスト
#     各要素は以下を含む:
#     - group_arn: グループのARN
#     - group_name: グループ名
#
# - version (number)
#   Thing Groupレコードの現在のバージョン番号
#   グループが更新されるたびにインクリメントされます
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 親グループの定義
# resource "aws_iot_thing_group" "parent" {
#   name = "parent-group"
#
#   properties {
#     description = "Parent thing group for all production devices"
#   }
#
#   tags = {
#     Environment = "production"
#   }
# }

# 子グループの定義（階層構造）
# resource "aws_iot_thing_group" "child" {
#   name              = "child-group"
#   parent_group_name = aws_iot_thing_group.parent.name
#
#   properties {
#     description = "Child thing group for specific device type"
#
#     attribute_payload {
#       attributes = {
#         DeviceCategory = "temperature-sensors"
#         AlertThreshold = "85"
#       }
#     }
#   }
#
#   tags = {
#     Environment = "production"
#     Category    = "sensors"
#   }
# }

# Thing Groupへのポリシーアタッチメント
# resource "aws_iot_policy_attachment" "group_policy" {
#   policy = aws_iot_policy.example.name
#   target = aws_iot_thing_group.example.arn
# }

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
# 1. グループ階層の制限:
#    - 1つのグループは最大1つの直接の親のみを持つことができます
#    - 直接の子グループ数には制限があります
#    - 階層の最大深度には制限があります
#    - グループの親は作成後に変更できません
#
# 2. Thingのグループメンバーシップ:
#    - 1つのThingは最大10個のグループに所属できます
#    - 同じ階層内の複数のグループには追加できません
#      （共通の親を持つ2つのグループには追加できません）
#
# 3. グループ名の制限:
#    - グループ名は作成後に変更できません（リソースの再作成が必要）
#    - 国際文字（非ASCII文字）は使用できません
#    - 個人を特定できる情報（PII）は使用しないでください
#
# 4. ポリシーの継承:
#    - 親グループに適用されたポリシーは子グループとその中の
#      すべてのThingに継承されます
#    - Thing Group PolicyはAWS IoT Greengrassのデータプレーン操作には
#      使用できません
#
# 5. 動的グループとの違い:
#    - 静的グループ（このリソース）はThingを明示的に追加します
#    - 動的グループはクエリに基づいて自動的にメンバーシップを管理します
#    - 動的グループにはポリシーを適用できません
#
# 6. 結果整合性:
#    - Thing Groupの操作（Thing追加、グループリストなど）は
#      結果整合性があります
#    - 変更が即座に反映されない場合があります
#
#---------------------------------------------------------------
