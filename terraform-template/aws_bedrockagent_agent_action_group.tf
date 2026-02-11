#---------------------------------------------------------------
# AWS Bedrock Agent Action Group
#---------------------------------------------------------------
#
# Amazon Bedrock Agents for Amazon Bedrockのアクショングループをプロビジョニングするリソースです。
# アクショングループは、エージェントがユーザーのためにアクションを実行する際に呼び出すことができる
# APIやLambda関数の集合を定義します。例えば、ホテル予約を行う「BookHotel」アクショングループでは、
# CreateBooking、GetBooking、CancelBookingなどのアクションを定義できます。
#
# AWS公式ドキュメント:
#   - Action Groups概要: https://docs.aws.amazon.com/bedrock/latest/userguide/agents-action-create.html
#   - Action Groupの追加: https://docs.aws.amazon.com/bedrock/latest/userguide/agents-action-add.html
#   - OpenAPIスキーマ: https://docs.aws.amazon.com/bedrock/latest/userguide/agents-api-schema.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_agent_action_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagent_agent_action_group" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # action_group_name (Required)
  # 設定内容: アクショングループの名前を指定します。
  # 設定可能な値: 1-100文字の文字列
  # 注意: Anthropic Claude 3.5 Sonnetを使用する場合、ツール名は
  #       httpVerb__actionGroupName__apiNameの形式になるため、
  #       actionGroupNameに二重アンダースコア '__' を含めないでください。
  action_group_name = "example-action-group"

  # agent_id (Required)
  # 設定内容: アクショングループを作成するエージェントの一意識別子を指定します。
  # 設定可能な値: エージェントID（例: GGRRAED6JP）
  agent_id = "GGRRAED6JP"

  # agent_version (Required)
  # 設定内容: アクショングループを作成するエージェントのバージョンを指定します。
  # 設定可能な値:
  #   - "DRAFT": ドラフトバージョン（開発・テスト用）
  # 注意: 現時点では "DRAFT" のみが有効な値です。
  agent_version = "DRAFT"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: アクショングループの説明を指定します。
  # 設定可能な値: 1-200文字の文字列
  # 用途: アクショングループの目的や機能を説明するために使用します。
  description = "Example action group for hotel booking operations"

  #-------------------------------------------------------------
  # アクショングループ状態設定
  #-------------------------------------------------------------

  # action_group_state (Optional)
  # 設定内容: エージェントがInvokeAgentリクエスト送信時にこのアクショングループを
  #          呼び出せるかどうかを指定します。
  # 設定可能な値:
  #   - "ENABLED": アクショングループを有効化し、エージェントが呼び出し可能
  #   - "DISABLED": アクショングループを無効化し、エージェントは呼び出し不可
  # 省略時: "ENABLED"
  # 関連機能: Action Group State
  #   アクショングループの有効/無効を切り替えることで、
  #   特定のアクションを一時的に無効化できます。
  action_group_state = "ENABLED"

  #-------------------------------------------------------------
  # 親アクショングループシグネチャ設定
  #-------------------------------------------------------------

  # parent_action_group_signature (Optional)
  # 設定内容: 組み込みアクションまたはコンピューター使用アクションを指定します。
  # 設定可能な値:
  #   - "AMAZON.UserInput": エージェントがタスク完了に必要な追加情報をユーザーに
  #                          リクエストできるようにします。この場合、description、
  #                          api_schema、action_group_executorは空にする必要があります。
  #   - "AMAZON.CodeInterpreter": コードインタープリターアクション
  #   - "ANTHROPIC.Computer": Anthropicコンピューター使用ツール
  #   - "ANTHROPIC.Bash": Anthropic Bashツール
  #   - "ANTHROPIC.TextEditor": Anthropicテキストエディターツール
  # 関連機能: Built-in Action Groups
  #   組み込みアクショングループを使用すると、カスタムLambda関数なしで
  #   特定の機能を有効化できます。
  parent_action_group_signature = null

  #-------------------------------------------------------------
  # エージェント準備設定
  #-------------------------------------------------------------

  # prepare_agent (Optional)
  # 設定内容: 作成または変更後にエージェントを準備するかどうかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): リソース作成/変更後にエージェントを自動的に準備
  #   - false: エージェントの準備をスキップ
  # 注意: 変更をテストする前にエージェントを準備する必要があります。
  prepare_agent = true

  #-------------------------------------------------------------
  # リソース使用中チェック設定
  #-------------------------------------------------------------

  # skip_resource_in_use_check (Optional)
  # 設定内容: アクショングループ削除時に使用中チェックをスキップするかどうかを指定します。
  # 設定可能な値:
  #   - true: 使用中チェックをスキップして削除を実行
  #   - false: 使用中チェックを行い、使用中の場合は削除をブロック
  # 用途: アクショングループがまだ使用されている可能性がある場合でも
  #       強制的に削除したい場合に使用します。
  skip_resource_in_use_check = true

  #-------------------------------------------------------------
  # アクショングループエグゼキューター設定
  #-------------------------------------------------------------
  # エージェントがアクションを呼び出すと判断した後、パラメータをどのように
  # 処理するかを定義します。Lambda関数を使用するか、制御をアプリケーションに
  # 返すかを選択できます。

  action_group_executor {
    # custom_control (Optional)
    # 設定内容: ユーザーから収集した情報を処理するカスタム制御方法を指定します。
    # 設定可能な値:
    #   - "RETURN_CONTROL": Lambda関数を使用せず、予測されたアクショングループと
    #                        パラメータをInvokeAgentレスポンスで返します。
    # 注意: lambdaとcustom_controlは排他的（どちらか一方のみ指定可能）
    # 関連機能: Return Control
    #   アプリケーション側でアクションの実行を制御したい場合に使用します。
    #   - https://docs.aws.amazon.com/bedrock/latest/userguide/agents-returncontrol.html
    custom_control = null

    # lambda (Optional)
    # 設定内容: アクション呼び出し時に実行されるビジネスロジックを含む
    #          Lambda関数のARNを指定します。
    # 設定可能な値: 有効なLambda関数ARN
    # 注意: custom_controlとlambdaは排他的（どちらか一方のみ指定可能）
    # 関連機能: Lambda Function Integration
    #   エージェントは予測したAPIまたは関数とパラメータをLambda関数に渡します。
    #   Lambda関数にはAmazon Bedrockサービスプリンシパルからのアクセスを
    #   許可するリソースベースポリシーをアタッチする必要があります。
    #   - https://docs.aws.amazon.com/bedrock/latest/userguide/agents-lambda.html
    lambda = "arn:aws:lambda:us-west-2:123456789012:function:example-function"
  }

  #-------------------------------------------------------------
  # APIスキーマ設定
  #-------------------------------------------------------------
  # OpenAPIスキーマを使用してアクショングループのAPI操作とパラメータを定義します。
  # payloadまたはs3のいずれか一方のみを指定できます。

  api_schema {
    # payload (Optional)
    # 設定内容: アクショングループのOpenAPIスキーマを定義するJSONまたはYAML形式の
    #          ペイロードを指定します。
    # 設定可能な値: JSON/YAML形式のOpenAPIスキーマ文字列
    # 注意: payloadとs3は排他的（どちらか一方のみ指定可能）
    # 関連機能: OpenAPI Schema
    #   OpenAPIスキーマでAPIの操作、パラメータ、レスポンスを定義します。
    #   - https://docs.aws.amazon.com/bedrock/latest/userguide/agents-api-schema.html
    payload = file("path/to/schema.yaml")

    # s3 (Optional)
    # 設定内容: OpenAPIスキーマが格納されているS3オブジェクトの詳細を指定します。
    # 注意: s3とpayloadは排他的（どちらか一方のみ指定可能）
    # s3 {
    #   # s3_bucket_name (Optional)
    #   # 設定内容: OpenAPIスキーマを格納しているS3バケットの名前を指定します。
    #   # 設定可能な値: 有効なS3バケット名
    #   s3_bucket_name = "example-bucket"
    #
    #   # s3_object_key (Optional)
    #   # 設定内容: OpenAPIスキーマを格納しているS3オブジェクトのキーを指定します。
    #   # 設定可能な値: 有効なS3オブジェクトキー
    #   s3_object_key = "path/to/schema.json"
    # }
  }

  #-------------------------------------------------------------
  # 関数スキーマ設定（Simplified Schema）
  #-------------------------------------------------------------
  # OpenAPIスキーマの代わりに、より簡易な方法でアクションとパラメータを定義できます。
  # 各関数はアクショングループ内の1つのアクションを表します。

  # function_schema {
  #   member_functions {
  #     functions {
  #       # name (Required)
  #       # 設定内容: 関数の名前を指定します。
  #       # 設定可能な値: 文字列
  #       name = "example-function"
  #
  #       # description (Optional)
  #       # 設定内容: 関数とその目的の説明を指定します。
  #       # 設定可能な値: 文字列
  #       # 用途: 基盤モデルがユーザーからパラメータを収集する方法を
  #       #       判断するのに役立ちます。
  #       description = "Example function for demonstration"
  #
  #       # parameters (Optional)
  #       # 設定内容: エージェントがユーザーから収集する関数のパラメータを定義します。
  #       # 最大5つのパラメータを定義できます。
  #       parameters {
  #         # map_block_key (Required)
  #         # 設定内容: パラメータの名前を指定します。
  #         # 設定可能な値: 文字列
  #         # 注意: "map_block_key"という名前はプロバイダーの後方互換性のためです。
  #         map_block_key = "param1"
  #
  #         # type (Required)
  #         # 設定内容: パラメータのデータ型を指定します。
  #         # 設定可能な値:
  #         #   - "string": 文字列
  #         #   - "number": 数値（浮動小数点）
  #         #   - "integer": 整数
  #         #   - "boolean": 真偽値
  #         #   - "array": 配列
  #         type = "string"
  #
  #         # description (Optional)
  #         # 設定内容: パラメータの説明を指定します。
  #         # 設定可能な値: 文字列
  #         # 用途: 基盤モデルがユーザーからパラメータを収集する方法を
  #         #       判断するのに役立ちます。
  #         description = "The first parameter"
  #
  #         # required (Optional)
  #         # 設定内容: エージェントがアクショングループの関数を完了するために
  #         #          このパラメータが必須かどうかを指定します。
  #         # 設定可能な値:
  #         #   - true: 必須パラメータ
  #         #   - false: オプションパラメータ
  #         required = true
  #       }
  #
  #       parameters {
  #         map_block_key = "param2"
  #         type          = "integer"
  #         description   = "The second parameter"
  #         required      = false
  #       }
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30s", "2h45m"）
    # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30s", "2h45m"）
    # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    update = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - action_group_id: アクショングループの一意識別子
#
# - id: アクショングループID、エージェントID、エージェントバージョンを
#       カンマ(,)で区切った値
#---------------------------------------------------------------
