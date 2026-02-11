################################################################################
# AWS Connect Contact Flow - 解説付きテンプレート
################################################################################
# Generated: 2026-01-19
# Provider: hashicorp/aws v6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-19)の情報に基づいています。
# 最新の仕様については、以下の公式ドキュメントを参照してください:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_contact_flow
#
# AWS公式ドキュメント:
# - Amazon Connect Contact Flow: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html
# - Amazon Connect Flow Language: https://docs.aws.amazon.com/connect/latest/APIReference/flow-language.html
# - Contact Actions: https://docs.aws.amazon.com/connect/latest/APIReference/contact-actions.html
################################################################################

################################################################################
# Amazon Connect Contact Flow
################################################################################
# Amazon Connect コンタクトフローリソースを提供します。
# コンタクトフローは、Amazon Connect Contact Flow Language で JSON 形式で記述されます。
#
# 重要な注意事項:
# - コンソールからエクスポートされたコンタクトフローは Amazon Connect Contact Flow Language
#   形式ではないため、このリソースでは使用できません
# - AWS CLI の describe-contact-flow コマンドを使用して正しい形式を取得してください
#   例: aws connect describe-contact-flow --instance-id <id> --contact-flow-id <id>
#
# リファレンス:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_contact_flow
################################################################################

resource "aws_connect_contact_flow" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # instance_id - (Required) Amazon Connect インスタンスの識別子
  # Amazon Connect インスタンスの ID を指定します。
  # 形式: aaaaaaaa-bbbb-cccc-dddd-111111111111
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"

  # name - (Required) コンタクトフローの名前
  # コンタクトフローを識別するための一意な名前を指定します。
  name = "ExampleContactFlow"

  ################################################################################
  # オプションパラメータ - コンテンツ定義
  ################################################################################

  # content - (Optional) コンタクトフローのコンテンツ（JSON 形式）
  # Amazon Connect Contact Flow Language で記述された JSON 文字列を指定します。
  # このパラメータを使用する場合、filename パラメータは使用できません（排他的）。
  #
  # JSON 構造には以下を含む必要があります:
  # - Version: フローのバージョン（例: "2019-10-30"）
  # - StartAction: 開始アクションの識別子
  # - Actions: コンタクトフローのアクション配列
  #
  # 参考: https://docs.aws.amazon.com/connect/latest/APIReference/flow-language.html
  content = jsonencode({
    Version     = "2019-10-30"
    StartAction = "12345678-1234-1234-1234-123456789012"
    Actions = [
      {
        Identifier = "12345678-1234-1234-1234-123456789012"
        Type       = "MessageParticipant"
        Transitions = {
          NextAction = "abcdef-abcd-abcd-abcd-abcdefghijkl"
          Errors     = []
          Conditions = []
        }
        Parameters = {
          Text = "Thanks for calling!"
        }
      },
      {
        Identifier  = "abcdef-abcd-abcd-abcd-abcdefghijkl"
        Type        = "DisconnectParticipant"
        Transitions = {}
        Parameters  = {}
      }
    ]
  })

  # filename - (Optional) ローカルファイルシステム内のコンタクトフローソースのパス
  # コンタクトフローの JSON 定義を含むファイルのパスを指定します。
  # このパラメータは content パラメータと競合します（どちらか一方のみ使用可能）。
  #
  # 使用例:
  # filename = "${path.module}/contact_flows/my_flow.json"
  #
  # AWS CLI でコンタクトフローを取得する方法:
  # aws connect describe-contact-flow \
  #   --instance-id <instance-id> \
  #   --contact-flow-id <flow-id> \
  #   --region <region> | jq '.ContactFlow.Content | fromjson' > contact_flow.json
  # filename = "contact_flow.json"

  # content_hash - (Optional) 更新のトリガーに使用されるハッシュ値
  # filename で指定されたコンタクトフローソースの base64 エンコードされた SHA256 ハッシュ。
  # ファイルの内容が変更された場合に Terraform が更新を検出するために使用されます。
  #
  # 推奨される設定方法:
  # - Terraform 0.11.12 以降: filebase64sha256("mycontact_flow.json")
  # - Terraform 0.11.11 以前: base64sha256(file("mycontact_flow.json"))
  #
  # 使用例:
  # content_hash = filebase64sha256("${path.module}/contact_flows/my_flow.json")

  ################################################################################
  # オプションパラメータ - メタデータ
  ################################################################################

  # description - (Optional) コンタクトフローの説明
  # コンタクトフローの目的や用途を説明するテキストを指定します。
  description = "Example contact flow for demonstration purposes"

  # type - (Optional) コンタクトフローのタイプ
  # デフォルト: CONTACT_FLOW
  # このパラメータを変更すると、リソースの再作成が強制されます（Forces new resource）。
  #
  # 使用可能な値:
  # - CONTACT_FLOW: 標準的なコンタクトフロー（インバウンド/アウトバウンド）
  # - CUSTOMER_QUEUE: 顧客がキューで待機中に再生されるフロー
  # - CUSTOMER_HOLD: 顧客が保留中に再生されるフロー
  # - CUSTOMER_WHISPER: 通話接続前に顧客に再生されるフロー
  # - AGENT_HOLD: エージェントが保留中に再生されるフロー
  # - AGENT_WHISPER: 通話接続前にエージェントに再生されるフロー
  # - OUTBOUND_WHISPER: アウトバウンド通話でエージェントに再生されるフロー
  # - AGENT_TRANSFER: エージェント転送時に使用されるフロー
  # - QUEUE_TRANSFER: キュー転送時に使用されるフロー
  #
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/contact-initiation-methods.html
  type = "CONTACT_FLOW"

  ################################################################################
  # オプションパラメータ - リソース管理
  ################################################################################

  # region - (Optional) リソースが管理されるリージョン
  # デフォルト: プロバイダー設定のリージョンを使用
  # このリソースが管理される AWS リージョンを明示的に指定できます。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # id - (Optional) リソースの識別子
  # 形式: <instance_id>:<contact_flow_id>
  # 通常は Terraform が自動的に設定するため、明示的な指定は不要です。
  # インポート時などに使用される場合があります。
  # id = "aaaaaaaa-bbbb-cccc-dddd-111111111111:cccccccc-dddd-eeee-ffff-222222222222"

  ################################################################################
  # タグ
  ################################################################################

  # tags - (Optional) コンタクトフローに適用するタグ
  # リソースの分類や管理に使用するキーと値のペアを指定します。
  # プロバイダーの default_tags と併用可能で、同じキーの場合はこちらが優先されます。
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "ExampleContactFlow"
    Environment = "Production"
    Application = "CustomerService"
    ManagedBy   = "Terraform"
  }

  # tags_all - (Optional) すべてのタグ（プロバイダーの default_tags を含む）
  # このパラメータは Terraform によって自動的に管理されるため、通常は明示的な指定は不要です。
  # プロバイダーレベルの default_tags とリソースレベルの tags がマージされた結果が格納されます。
  # tags_all = {
  #   Name        = "ExampleContactFlow"
  #   Environment = "Production"
  #   ManagedBy   = "Terraform"
  #   Owner       = "TeamA"  # default_tags から継承
  # }
}

################################################################################
# 出力例
################################################################################
# このリソースから取得できる computed 属性（読み取り専用）:
#
# - arn: コンタクトフローの Amazon Resource Name (ARN)
#   形式: arn:aws:connect:region:account-id:instance/instance-id/contact-flow/contact-flow-id
#
# - contact_flow_id: コンタクトフローの一意な識別子
#   形式: cccccccc-dddd-eeee-ffff-222222222222
#
# - id: インスタンス ID とコンタクトフロー ID の組み合わせ
#   形式: instance-id:contact-flow-id
#
# - tags_all: リソースに割り当てられたすべてのタグ
#   （プロバイダーの default_tags を含む）

# 使用例:
# output "contact_flow_arn" {
#   description = "The ARN of the contact flow"
#   value       = aws_connect_contact_flow.example.arn
# }
#
# output "contact_flow_id" {
#   description = "The ID of the contact flow"
#   value       = aws_connect_contact_flow.example.contact_flow_id
# }
