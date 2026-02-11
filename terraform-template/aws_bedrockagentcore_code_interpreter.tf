#---------------------------------------------------------------
# AWS Bedrock AgentCore Code Interpreter
#---------------------------------------------------------------
#
# Amazon Bedrock AgentCore Code Interpreterをプロビジョニングするリソースです。
# Code InterpreterはAIエージェントがPythonコードを安全に実行できる環境を提供し、
# データ分析、計算、ファイル処理機能を実現します。サンドボックス環境で
# コードを実行することで、セキュリティリスクを軽減しながら複雑なタスクを
# 処理できます。
#
# AWS公式ドキュメント:
#   - AgentCore Code Interpreter概要: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/code-interpreter-tool.html
#   - Code Interpreterの作成: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/code-interpreter-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagentcore_code_interpreter
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagentcore_code_interpreter" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Code Interpreterの名前を指定します。
  # 設定可能な値: 一意の文字列
  name = "example-code-interpreter"

  # description (Optional)
  # 設定内容: Code Interpreterの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: Code Interpreterの目的や用途を記述
  description = "Code interpreter for data analysis"

  #-------------------------------------------------------------
  # 実行ロール設定
  #-------------------------------------------------------------

  # execution_role_arn (Optional)
  # 設定内容: Code Interpreterが実行時に引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: network_modeが"SANDBOX"の場合は必須
  # 関連機能: IAM実行ロール
  #   Code InterpreterがアクセスできるAWSリソースを定義するロール。
  #   bedrock-agentcore.amazonaws.comサービスがAssumeRoleできるように
  #   信頼ポリシーを設定する必要があります。
  execution_role_arn = "arn:aws:iam::123456789012:role/bedrock-agentcore-code-interpreter-role"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # network_configuration (Required)
  # 設定内容: Code Interpreterのネットワーク構成を指定します。
  # 関連機能: ネットワークモード
  #   Code Interpreterの実行環境のネットワークアクセスを制御します。
  #   セキュリティ要件に応じて適切なモードを選択してください。
  network_configuration {
    # network_mode (Required)
    # 設定内容: ネットワークモードを指定します。
    # 設定可能な値:
    #   - "PUBLIC": パブリックインターネットリソースへのアクセスを許可
    #   - "SANDBOX": 外部ネットワークアクセスが制限された環境
    #   - "VPC": VPC内でCode Interpreterを実行（vpc_configが必要）
    # 用途:
    #   PUBLIC - 外部APIやデータソースにアクセスする必要がある場合
    #   SANDBOX - セキュリティを重視し、外部アクセスを制限する場合
    #   VPC - プライベートネットワーク内のリソースにアクセスする場合
    network_mode = "PUBLIC"

    # vpc_config (Optional)
    # 設定内容: VPC構成を指定します。network_modeが"VPC"の場合に使用します。
    # 注意: network_modeが"VPC"の場合のみ有効
    # vpc_config {
    #   # security_groups (Required)
    #   # 設定内容: VPC構成に関連付けるセキュリティグループを指定します。
    #   # 設定可能な値: セキュリティグループIDのセット
    #   security_groups = ["sg-0123456789abcdef0"]
    #
    #   # subnets (Required)
    #   # 設定内容: VPC構成に関連付けるサブネットを指定します。
    #   # 設定可能な値: サブネットIDのセット
    #   # 注意: 可用性を高めるため、複数のAZにまたがるサブネットを推奨
    #   subnets = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
    # }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-code-interpreter"
    Environment = "development"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウトを指定します。
  # 関連機能: Terraformタイムアウト
  #   リソースの作成・削除操作の最大待機時間を設定できます。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h45m"）
    # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    create = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h45m"）
    # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    delete = "30m"
  }
}

#---------------------------------------------------------------
# IAM Role Example (参考)
#---------------------------------------------------------------
# Code Interpreterで使用するIAMロールの例です。
#
# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["bedrock-agentcore.amazonaws.com"]
#     }
#   }
# }
#
# resource "aws_iam_role" "code_interpreter" {
#   name               = "bedrock-agentcore-code-interpreter-role"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - code_interpreter_arn: Code InterpreterのAmazon Resource Name (ARN)
#
# - code_interpreter_id: Code Interpreterの一意識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
