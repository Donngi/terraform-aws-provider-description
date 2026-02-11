################################################################################
# AWS Connect Quick Connect
# Terraform Resource: aws_connect_quick_connect
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
#
# 注意: このテンプレートは生成時点(Provider v6.28.0)の情報に基づいています。
# 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_quick_connect
################################################################################

resource "aws_connect_quick_connect" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # Amazon Connect インスタンスの識別子
  # Quick Connect をホストする Amazon Connect インスタンスの ID を指定します
  # 例: "aaaaaaaa-bbbb-cccc-dddd-111111111111"
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html
  instance_id = "your-connect-instance-id"

  # Quick Connect の名前
  # Quick Connect を識別するための一意の名前を指定します
  # 最小長: 1文字、最大長: 127文字
  # 例: "Sales Team Quick Connect"
  # 参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_QuickConnectSummary.html
  name = "example-quick-connect"

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # Quick Connect の説明
  # Quick Connect の目的や用途を説明するテキストを指定します
  # 例: "Sales team phone number quick connect"
  description = "Example quick connect description"

  # リソースID
  # Terraform リソースの識別子を指定します
  # 指定しない場合、Instance ID と Quick Connect ID をコロンで結合した値が自動生成されます
  # 形式: "instance-id:quick-connect-id"
  # 通常は指定不要（自動計算されます）
  # id = "aaaaaaaa-bbbb-cccc-dddd-111111111111:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  # Quick Connect のタグ
  # リソース管理のためのタグを指定します
  # provider の default_tags と組み合わせて使用できます
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    Department  = "customer-service"
  }

  # 全タグ（tags + provider default_tags の統合）
  # tags と provider の default_tags を統合した全タグを指定します
  # 通常は指定不要（tags と default_tags から自動計算されます）
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags_all = {
  #   Environment = "production"
  #   Department  = "customer-service"
  #   ManagedBy   = "terraform"
  # }

  # リソース管理リージョン
  # このリソースが管理されるAWSリージョンを指定します
  # 指定しない場合、プロバイダー設定のリージョンが使用されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ============================================================================
  # Required Nested Block: quick_connect_config
  # ============================================================================
  # Quick Connect の設定情報を定義します
  # quick_connect_type に応じて、以下のいずれかの設定ブロックが必要です:
  # - phone_config: PHONE_NUMBER タイプの場合
  # - queue_config: QUEUE タイプの場合
  # - user_config: USER タイプの場合
  # 参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_QuickConnectConfig.html

  quick_connect_config {
    # Quick Connect のタイプ
    # 有効な値: "PHONE_NUMBER", "QUEUE", "USER"
    # - PHONE_NUMBER: 外部電話番号への転送
    # - QUEUE: キューへの転送（フローを経由）
    # - USER: ユーザー（エージェント）への転送（フローを経由）
    # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/quick-connects.html
    quick_connect_type = "PHONE_NUMBER"

    # ------------------------------------------------------------------------
    # Phone Configuration (PHONE_NUMBER タイプの場合に必須)
    # ------------------------------------------------------------------------
    # 外部電話番号への直接転送を設定します
    # フローを経由せず、キューの発信者ID設定が使用されます
    # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/how-quick-connects-work.html

    phone_config {
      # 電話番号 (E.164形式)
      # 国際電話番号形式で指定します（例: +12345678912）
      # E.164形式: +[国番号][市外局番][電話番号]
      # 参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_PhoneNumberQuickConnectConfig.html
      phone_number = "+12345678912"
    }

    # ------------------------------------------------------------------------
    # Queue Configuration (QUEUE タイプの場合に必須)
    # ------------------------------------------------------------------------
    # キューへの転送を設定します
    # エージェントがキューに転送すると、queue transfer フローが実行されます
    # 転送された通話は指定されたキューに配置され、キューのエージェントが応答できます
    # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/how-quick-connects-work.html

    # queue_config {
    #   # Contact Flow の識別子
    #   # キュー転送時に実行される Contact Flow の ID を指定します
    #   # 最大長: 500文字
    #   contact_flow_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    #
    #   # キューの識別子
    #   # 転送先キューの ID を指定します
    #   queue_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    # }

    # ------------------------------------------------------------------------
    # User Configuration (USER タイプの場合に必須)
    # ------------------------------------------------------------------------
    # ユーザー（エージェント）への転送を設定します
    # エージェントが別のエージェントに転送すると、agent transfer フローが実行されます
    # 転送先エージェントは通話を受け入れるか拒否するかを選択できます
    # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/how-quick-connects-work.html
    # 参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_UserQuickConnectConfig.html

    # user_config {
    #   # Contact Flow の識別子
    #   # ユーザー転送時に実行される Contact Flow の ID を指定します
    #   # "Transfer to Agent" タイプのフローである必要があります
    #   # 最大長: 500文字
    #   contact_flow_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    #
    #   # ユーザーの識別子
    #   # 転送先ユーザー（エージェント）の ID を指定します
    #   user_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    # }
  }
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# 以下の属性は Terraform によって自動的に設定され、参照のみ可能です:
#
# - arn: Quick Connect の Amazon Resource Name (ARN)
#   例: "arn:aws:connect:us-east-1:123456789012:instance/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/transfer-destination/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#   参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_QuickConnectSummary.html
#
# - quick_connect_id: Quick Connect の識別子
#   例: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#
# - id: Connect Instance ID と Quick Connect ID をコロンで結合した識別子
#   形式: "instance-id:quick-connect-id"
#   例: "aaaaaaaa-bbbb-cccc-dddd-111111111111:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#
# - tags_all: リソースに割り当てられた全タグ（provider の default_tags を含む）
#   参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
################################################################################

################################################################################
# 使用例
################################################################################
# 1. Phone Number Quick Connect（外部電話番号への転送）
#    - フローを経由せず直接接続
#    - 発信者IDはキューの設定から取得
#
# 2. Queue Quick Connect（キューへの転送）
#    - queue transfer フローを実行
#    - 通話をキューに配置し、キューのエージェントが応答
#
# 3. User Quick Connect（エージェント間転送）
#    - agent transfer フローを実行
#    - 転送先エージェントが受け入れ/拒否を選択可能
#
# Quick Connect を使用するには、適切なキューに追加する必要があります
# これにより、エージェントが Contact Control Panel (CCP) で Quick Connect を
# 利用できるようになります
# 参考: https://docs.aws.amazon.com/connect/latest/adminguide/quick-connects.html
################################################################################
