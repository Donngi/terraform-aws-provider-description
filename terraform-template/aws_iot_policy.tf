#---------------------------------------------------------------
# AWS IoT Policy
#---------------------------------------------------------------
#
# AWS IoT Coreのポリシーリソース。IoTデバイスやアプリケーションが
# AWS IoT Coreのデータプレーンにアクセスする際の権限を制御する
# JSON形式のポリシードキュメントを定義します。
#
# ポリシーの更新時は新しいデフォルトバージョンが作成され、
# 最大バージョン数(5)を超える場合は最も古い非デフォルトバージョンが削除されます。
# ポリシーの変更はキャッシュの影響で反映まで6-8分かかります。
#
# AWS公式ドキュメント:
#   - AWS IoT Core policies: https://docs.aws.amazon.com/iot/latest/developerguide/iot-policies.html
#   - AWS IoT Core policy examples: https://docs.aws.amazon.com/iot/latest/developerguide/example-iot-policies.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_policy" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # ポリシーの名前
  # - IoTポリシーを識別するための一意の名前を指定します
  # - 命名規則: 英数字、ハイフン、アンダースコアが使用可能
  name = "example-iot-policy"

  # ポリシードキュメント(JSON形式)
  # - IAMポリシーと同じ構文規則に従ったJSON形式のポリシー定義
  # - Effect(Allow/Deny), Action, Resourceを含むStatementの配列で構成
  # - jsonencode関数を使用してTerraformの式を有効なJSON構文に変換可能
  #
  # ポリシードキュメントの構成要素:
  # - Version: ポリシー言語のバージョン(通常は"2012-10-17")
  # - Statement: 権限ステートメントの配列
  #   - Effect: "Allow" または "Deny"
  #   - Action: IoTアクション(例: "iot:Connect", "iot:Publish", "iot:Subscribe")
  #   - Resource: リソースARNまたはワイルドカード
  #
  # 参考:
  # - IoT Developer Guide: http://docs.aws.amazon.com/iot/latest/developerguide/iot-policies.html
  # - AWS IAM Policy Document Guide: https://learn.hashicorp.com/terraform/aws/iam-policy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iot:Connect",
          "iot:Publish",
          "iot:Subscribe",
          "iot:Receive"
        ]
        Resource = "*"
      }
    ]
  })

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # リージョン指定(オプション)
  # - このリソースを管理するAWSリージョンを指定
  # - 未指定の場合はプロバイダー設定のリージョンが使用されます
  # - リージョナルエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # リソースタグ
  # - ポリシーに付与するキー・バリュー形式のタグ
  # - プロバイダーのdefault_tags設定がある場合、同じキーのタグは上書きされます
  # - コスト配分、リソース管理、アクセス制御などに活用できます
  tags = {
    Environment = "production"
    Project     = "iot-application"
    ManagedBy   = "terraform"
  }

  #---------------------------------------------------------------
  # Timeouts (Optional)
  #---------------------------------------------------------------

  # タイムアウト設定
  # - リソース操作のタイムアウト時間をカスタマイズできます
  # timeouts {
  #   # ポリシー更新時のタイムアウト(デフォルト: 設定なし)
  #   # - 形式: "60s", "5m", "1h" など
  #   update = "5m"
  #
  #   # ポリシー削除時のタイムアウト(デフォルト: 設定なし)
  #   # - 形式: "60s", "5m", "1h" など
  #   delete = "5m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします(computed only):
#
# - arn
#   タイプ: string
#   説明: AWSによって割り当てられたポリシーのARN
#   例: arn:aws:iot:us-east-1:123456789012:policy/example-iot-policy
#
# - default_version_id
#   タイプ: string
#   説明: このポリシーのデフォルトバージョンID
#   例: 1, 2, 3 など
#
# - id
#   タイプ: string
#   説明: ポリシーの名前(Terraform内部識別子)
#
# これらの属性は読み取り専用で、他のリソースから参照する際に使用できます:
# 例: aws_iot_policy.example.arn
#---------------------------------------------------------------

#---------------------------------------------------------------
# Usage Examples
#---------------------------------------------------------------
#
# 基本的な使用例:
#
# # 1. デバイスが特定のトピックにのみPublish可能なポリシー
# resource "aws_iot_policy" "device_specific" {
#   name = "DeviceSpecificPolicy"
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = ["iot:Connect"]
#         Resource = "arn:aws:iot:us-east-1:123456789012:client/$${iot:Connection.Thing.ThingName}"
#       },
#       {
#         Effect = "Allow"
#         Action = ["iot:Publish"]
#         Resource = "arn:aws:iot:us-east-1:123456789012:topic/device/$${iot:Connection.Thing.ThingName}/*"
#       }
#     ]
#   })
# }
#
# # 2. Thing属性を使用したポリシー変数の活用
# resource "aws_iot_policy" "dynamic_policy" {
#   name = "DynamicThingPolicy"
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = ["iot:Connect"]
#         Resource = "*"
#         Condition = {
#           StringEquals = {
#             "iot:Connection.Thing.Attributes[envType]" = "production"
#           }
#         }
#       }
#     ]
#   })
# }
#
# # 3. 複数のアクションを許可する汎用ポリシー
# resource "aws_iot_policy" "full_access" {
#   name = "IoTFullAccessPolicy"
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "iot:Connect",
#           "iot:Publish",
#           "iot:Subscribe",
#           "iot:Receive",
#           "iot:GetThingShadow",
#           "iot:UpdateThingShadow"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
#
#   tags = {
#     Purpose = "Development"
#   }
# }
#
#---------------------------------------------------------------
