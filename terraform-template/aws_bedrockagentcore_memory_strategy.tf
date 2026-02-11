#---------------------------------------------------------------
# AWS Bedrock AgentCore Memory Strategy
#---------------------------------------------------------------
#
# Amazon Bedrock AgentCoreのメモリ戦略をプロビジョニングするリソースです。
# メモリ戦略は、エージェントがメモリ内の情報をどのように処理・整理するかを定義します。
# セマンティック理解、要約、カスタム処理ロジックなどの戦略を設定できます。
#
# 重要な制限事項:
#   - 各メモリには最大6つの戦略を設定可能
#   - 組み込み型（SEMANTIC, SUMMARIZATION, USER_PREFERENCE）は各メモリに1つずつのみ
#   - CUSTOM戦略は複数作成可能（合計6つの制限内）
#
# AWS公式ドキュメント:
#   - Bedrock AgentCore Memory概要: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/memory.html
#   - メモリ戦略: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/memory-strategies.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagentcore_memory_strategy
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagentcore_memory_strategy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: メモリ戦略の名前を指定します。
  # 設定可能な値: 文字列
  name = "example-memory-strategy"

  # memory_id (Required, Forces new resource)
  # 設定内容: この戦略を関連付けるメモリのIDを指定します。
  # 設定可能な値: 有効なメモリID
  # 注意: 変更すると新しいリソースが作成されます。
  memory_id = aws_bedrockagentcore_memory.example.id

  # type (Required, Forces new resource)
  # 設定内容: メモリ戦略のタイプを指定します。
  # 設定可能な値:
  #   - "SEMANTIC": セマンティック理解戦略。会話から事実情報や文脈知識を抽出
  #   - "SUMMARIZATION": 要約戦略。セッション内の会話を要約して保持
  #   - "USER_PREFERENCE": ユーザー嗜好戦略。ユーザーの好みや選択を追跡
  #   - "CUSTOM": カスタム戦略。configurationブロックと組み合わせて使用
  # 注意: 組み込み型（SEMANTIC, SUMMARIZATION, USER_PREFERENCE）は各メモリに1つのみ。
  #       変更すると新しいリソースが作成されます。
  type = "SEMANTIC"

  # namespaces (Required)
  # 設定内容: この戦略が適用される名前空間識別子のセットを指定します。
  # 設定可能な値: 文字列のセット
  # 用途: 名前空間はメモリコンテンツを整理・スコープするのに役立ちます。
  # 例: ["default"], ["{sessionId}"], ["preferences"]
  namespaces = ["default"]

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: メモリ戦略の説明を指定します。
  # 設定可能な値: 文字列
  description = "Semantic understanding strategy for extracting factual information"

  # memory_execution_role_arn (Optional)
  # 設定内容: メモリ実行用のIAMロールARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 用途: CUSTOM戦略でモデルを呼び出す際に必要なIAMロールを指定します。
  #       ロールには、指定したBedrock基盤モデルを呼び出す権限が必要です。
  # 参考: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/long-term-configuring-custom-strategies.html
  memory_execution_role_arn = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # カスタム戦略設定 (configurationブロック)
  #-------------------------------------------------------------
  # typeが"CUSTOM"の場合に必須。他のタイプでは省略してください。
  # カスタム戦略では、組み込み戦略のロジックをカスタムプロンプトで上書きできます。

  # configuration {
  #   # type (Required, Forces new resource)
  #   # 設定内容: カスタムオーバーライドのタイプを指定します。
  #   # 設定可能な値:
  #   #   - "SEMANTIC_OVERRIDE": セマンティック戦略をカスタマイズ
  #   #   - "SUMMARY_OVERRIDE": 要約戦略をカスタマイズ
  #   #   - "USER_PREFERENCE_OVERRIDE": ユーザー嗜好戦略をカスタマイズ
  #   # 注意: 変更すると新しいリソースが作成されます。
  #   type = "SEMANTIC_OVERRIDE"
  #
  #   #-----------------------------------------------------------
  #   # 抽出設定 (extractionブロック)
  #   #-----------------------------------------------------------
  #   # 関連情報を識別・抽出するための設定。
  #   # SUMMARY_OVERRIDEタイプでは使用できません。
  #   # 一度追加すると、リソースを再作成せずに削除できません。
  #
  #   extraction {
  #     # append_to_prompt (Required)
  #     # 設定内容: 抽出処理用のモデルプロンプトに追加するテキストを指定します。
  #     # 設定可能な値: 文字列
  #     append_to_prompt = "Extract and categorize semantic information"
  #
  #     # model_id (Required)
  #     # 設定内容: 抽出処理に使用する基盤モデルのIDを指定します。
  #     # 設定可能な値: 有効なBedrock基盤モデルID
  #     # 例: "anthropic.claude-3-haiku-20240307-v1:0"
  #     model_id = "anthropic.claude-3-haiku-20240307-v1:0"
  #   }
  #
  #   #-----------------------------------------------------------
  #   # 統合設定 (consolidationブロック)
  #   #-----------------------------------------------------------
  #   # メモリコンテンツを処理・整理するための設定。
  #   # 一度追加すると、リソースを再作成せずに削除できません。
  #
  #   consolidation {
  #     # append_to_prompt (Required)
  #     # 設定内容: 統合処理用のモデルプロンプトに追加するテキストを指定します。
  #     # 設定可能な値: 文字列
  #     append_to_prompt = "Focus on extracting key semantic relationships and concepts"
  #
  #     # model_id (Required)
  #     # 設定内容: 統合処理に使用する基盤モデルのIDを指定します。
  #     # 設定可能な値: 有効なBedrock基盤モデルID
  #     # 例: "anthropic.claude-3-sonnet-20240229-v1:0"
  #     model_id = "anthropic.claude-3-sonnet-20240229-v1:0"
  #   }
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts {
  #   # create (Optional)
  #   # 設定内容: 作成操作のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
  #   # 参考: https://pkg.go.dev/time#ParseDuration
  #   create = "30m"
  #
  #   # update (Optional)
  #   # 設定内容: 更新操作のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
  #   update = "30m"
  #
  #   # delete (Optional)
  #   # 設定内容: 削除操作のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
  #   # 注意: 削除操作のタイムアウトは、destroy操作前に変更がstateに保存される場合のみ適用されます。
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# CUSTOM戦略の例
#---------------------------------------------------------------
# 以下はCUSTOM戦略を使用する場合の例です。

# resource "aws_bedrockagentcore_memory_strategy" "custom_semantic" {
#   name                      = "custom-semantic-strategy"
#   memory_id                 = aws_bedrockagentcore_memory.example.id
#   memory_execution_role_arn = aws_bedrockagentcore_memory.example.memory_execution_role_arn
#   type                      = "CUSTOM"
#   description               = "Custom semantic processing strategy"
#   namespaces                = ["{sessionId}"]
#
#   configuration {
#     type = "SEMANTIC_OVERRIDE"
#
#     extraction {
#       append_to_prompt = "Extract and categorize semantic information"
#       model_id         = "anthropic.claude-3-haiku-20240307-v1:0"
#     }
#
#     consolidation {
#       append_to_prompt = "Focus on extracting key semantic relationships and concepts"
#       model_id         = "anthropic.claude-3-sonnet-20240229-v1:0"
#     }
#   }
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - memory_strategy_id: メモリ戦略の一意な識別子。
#                       これはAWS APIやCloudFormationの用語でstrategyIdに相当します。
#---------------------------------------------------------------
