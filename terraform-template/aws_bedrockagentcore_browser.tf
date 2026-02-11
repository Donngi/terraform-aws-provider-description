#---------------------------------------------------------------
# AWS Bedrock AgentCore Browser
#---------------------------------------------------------------
#
# Amazon Bedrock AgentCore Browserをプロビジョニングするリソースです。
# AIエージェントがWebアプリケーションと対話するためのセキュアなクラウドベースの
# ブラウザ機能を提供します。セッションの分離、ライブビュー、CloudTrailログ記録、
# セッションリプレイ機能を備えています。
#
# AWS公式ドキュメント:
#   - AgentCore Browser概要: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/browser-tool.html
#   - AgentCore Browserの開始: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/browser-onboarding.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagentcore_browser
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagentcore_browser" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ブラウザの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-browser"

  # description (Optional)
  # 設定内容: ブラウザの説明を指定します。
  # 設定可能な値: 文字列
  description = "Browser for web data extraction"

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
  # IAMロール設定
  #-------------------------------------------------------------

  # execution_role_arn (Optional)
  # 設定内容: ブラウザが実行時に引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 用途: ブラウザがAWSリソース（例: S3への録画保存）にアクセスする際の権限を付与
  # 関連機能: IAM信頼ポリシー
  #   IAMロールの信頼ポリシーでbedrock-agentcore.amazonaws.comを許可する必要があります。
  execution_role_arn = "arn:aws:iam::123456789012:role/bedrock-agentcore-browser-role"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # network_configuration (Required)
  # 設定内容: ブラウザのネットワーク設定を指定します。
  # 関連機能: AgentCore Browser ネットワークモード
  #   PUBLICまたはVPCモードを選択。VPCモードではセキュリティグループとサブネットの指定が必要。
  #   - https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/browser-tool.html
  network_configuration {
    # network_mode (Required)
    # 設定内容: ブラウザのネットワークモードを指定します。
    # 設定可能な値:
    #   - "PUBLIC": パブリックネットワークモード。インターネットに直接アクセス
    #   - "VPC": VPCネットワークモード。指定したVPC内で動作
    network_mode = "PUBLIC"

    # vpc_config (Optional)
    # 設定内容: network_modeが"VPC"の場合のVPC設定を指定します。
    # 注意: network_modeが"VPC"の場合は必須
    # vpc_config {
    #   # security_groups (Required)
    #   # 設定内容: VPC設定用のセキュリティグループIDのセットを指定します。
    #   # 設定可能な値: 有効なセキュリティグループIDのリスト
    #   security_groups = ["sg-12345678"]
    #
    #   # subnets (Required)
    #   # 設定内容: VPC設定用のサブネットIDのセットを指定します。
    #   # 設定可能な値: 有効なサブネットIDのリスト
    #   # 推奨: 高可用性のため複数のAZにまたがるサブネットを指定
    #   subnets = ["subnet-12345678", "subnet-87654321"]
    # }
  }

  #-------------------------------------------------------------
  # 録画設定
  #-------------------------------------------------------------

  # recording (Optional)
  # 設定内容: ブラウザセッションの録画設定を指定します。
  # 関連機能: AgentCore Browser セッション録画
  #   ブラウザセッションを録画しS3に保存。デバッグや監査目的に使用可能。
  #   - https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/browser-tool.html
  # recording {
  #   # enabled (Optional)
  #   # 設定内容: ブラウザセッションの録画を有効にするかを指定します。
  #   # 設定可能な値:
  #   #   - true: 録画を有効化
  #   #   - false (デフォルト): 録画を無効化
  #   enabled = true
  #
  #   # s3_location (Optional)
  #   # 設定内容: ブラウザセッションの録画を保存するS3ロケーションを指定します。
  #   # 注意: enabledがtrueの場合に設定を推奨
  #   # s3_location {
  #   #   # bucket (Required)
  #   #   # 設定内容: 録画を保存するS3バケット名を指定します。
  #   #   # 設定可能な値: 有効なS3バケット名
  #   #   bucket = "browser-recording-bucket"
  #   #
  #   #   # prefix (Required)
  #   #   # 設定内容: 録画ファイルのS3キープレフィックスを指定します。
  #   #   # 設定可能な値: 文字列（末尾にスラッシュを含めることを推奨）
  #   #   prefix = "browser-sessions/"
  #   # }
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのキーバリューマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-browser"
    Environment = "development"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を指定します。
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: リソース作成のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
  #   # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
  #   create = "30m"
  #
  #   # delete (Optional)
  #   # 設定内容: リソース削除のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
  #   # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - browser_arn: ブラウザのAmazon Resource Name (ARN)
#
# - browser_id: ブラウザの一意識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
