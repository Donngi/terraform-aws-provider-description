#---------------------------------------------------------------
# AWS IoT Policy
#---------------------------------------------------------------
#
# AWS IoTポリシーをプロビジョニングするリソースです。
# IoTポリシーはAWS IoT Coreへのアクセス許可を定義するJSONドキュメントであり、
# MQTT接続・発行・購読・受信などのIoTアクションを制御します。
# デバイス証明書やAmazon Cognito Identityにアタッチすることでデバイスの権限を管理します。
#
# AWS公式ドキュメント:
#   - IoT ポリシーの概要: https://docs.aws.amazon.com/iot/latest/developerguide/iot-policies.html
#   - IoT ポリシーアクション: https://docs.aws.amazon.com/iot/latest/developerguide/iot-policy-actions.html
#   - IoT ポリシー変数: https://docs.aws.amazon.com/iot/latest/developerguide/policy-variables.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iot_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_policy" "example" {
  #---------------------------------------------------------------
  # 名前設定
  #---------------------------------------------------------------

  # name (Required)
  # 設定内容: IoTポリシーの名前を指定します。
  # 設定可能な値: 英数字・ハイフン(-)・アンダースコア(_)・コロン(:)・スラッシュ(/)を含む文字列
  #   最大128文字
  # 省略時: 省略不可（必須）
  name = "example-iot-policy"

  #---------------------------------------------------------------
  # ポリシードキュメント設定
  #---------------------------------------------------------------

  # policy (Required)
  # 設定内容: IoTポリシーのドキュメントをJSON形式の文字列で指定します。
  #   MQTT接続・発行・購読・受信などのIoTアクションへのアクセス許可を定義します。
  # 設定可能な値: 有効なIoTポリシードキュメントのJSON文字列
  # 省略時: 省略不可（必須）
  # 注意: jsonencode() 関数の使用を推奨します。
  #   IoTポリシー変数（${iot:ClientId}等）を使用してデバイスごとのアクセス制御が可能です。
  # 参考: https://docs.aws.amazon.com/iot/latest/developerguide/iot-policies.html
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iot:Connect",
        ]
        Resource = "arn:aws:iot:*:*:client/$${iot:ClientId}"
      },
      {
        Effect = "Allow"
        Action = [
          "iot:Publish",
          "iot:Receive",
        ]
        Resource = "arn:aws:iot:*:*:topic/example/$${iot:ClientId}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "iot:Subscribe",
        ]
        Resource = "arn:aws:iot:*:*:topicfilter/example/$${iot:ClientId}/*"
      },
    ]
  })

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定で指定されたリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ。キー・値ともに文字列
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-iot-policy"
    Environment = "production"
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # update (Optional)
    # 設定内容: リソースの更新操作が完了するまでのタイムアウト時間を指定します。
    # 設定可能な値: Goの時間文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルト値
    update = "30m"

    # delete (Optional)
    # 設定内容: リソースの削除操作が完了するまでのタイムアウト時間を指定します。
    # 設定可能な値: Goの時間文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルト値
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: IoTポリシーの名前（name と同じ値）
#
# - arn: AWSによって付与されるIoTポリシーのARN
#
# - default_version_id: IoTポリシーのデフォルトバージョンID
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
