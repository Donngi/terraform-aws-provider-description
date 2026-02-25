#---------------------------------------------------------------
# AWS Serverless Application Repository CloudFormation Stack
#---------------------------------------------------------------
#
# AWS Serverless Application Repository からアプリケーションをデプロイする
# CloudFormation スタックをプロビジョニングするリソースです。
# サーバーレスアプリケーションのテンプレートを利用して、Lambda関数や関連リソースを
# 一括でデプロイできます。
#
# AWS公式ドキュメント:
#   - AWS Serverless Application Repository とは: https://docs.aws.amazon.com/serverlessrepo/latest/devguide/what-is-serverlessrepo.html
#   - アプリケーションのデプロイ: https://docs.aws.amazon.com/serverlessrepo/latest/devguide/serverlessrepo-consuming-applications.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/serverlessapplicationrepository_cloudformation_stack
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_serverlessapplicationrepository_cloudformation_stack" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: CloudFormation スタックの名前を指定します。
  # 設定可能な値: 英字で始まり、英数字とハイフンのみを含む文字列
  name = "example-serverless-app-stack"

  # application_id (Required)
  # 設定内容: デプロイする SAR アプリケーションの ARN を指定します。
  # 設定可能な値: 有効な SAR アプリケーション ARN
  #   例: arn:aws:serverlessrepo:us-east-1:123456789012:applications/MyApp
  application_id = "arn:aws:serverlessrepo:us-east-1:123456789012:applications/ExampleApp"

  # capabilities (Required)
  # 設定内容: アプリケーションのデプロイに必要な IAM ケーパビリティのセットを指定します。
  #   アプリケーションが IAM リソースを作成する場合は適切なケーパビリティの指定が必要です。
  # 設定可能な値:
  #   - "CAPABILITY_IAM": 名前付きでない IAM リソースの作成を許可
  #   - "CAPABILITY_NAMED_IAM": カスタム名の IAM リソースの作成を許可
  #   - "CAPABILITY_AUTO_EXPAND": ネストされたスタックや Transform を含むテンプレートの利用を許可
  #   - "CAPABILITY_RESOURCE_POLICY": リソースベースのポリシーの作成を許可
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_AUTO_EXPAND"]

  #-------------------------------------------------------------
  # バージョン設定
  #-------------------------------------------------------------

  # semantic_version (Optional)
  # 設定内容: デプロイするアプリケーションのセマンティックバージョンを指定します。
  # 設定可能な値: セマンティックバージョン文字列（例: "1.0.0"）
  # 省略時: アプリケーションの最新バージョンを使用
  semantic_version = null

  #-------------------------------------------------------------
  # パラメーター設定
  #-------------------------------------------------------------

  # parameters (Optional)
  # 設定内容: アプリケーションに渡すパラメーターのキーと値のマップを指定します。
  #   SAR アプリケーションテンプレートで定義されているパラメーター名と値を指定します。
  # 設定可能な値: 文字列のキーバリューマップ
  # 省略時: アプリケーションのデフォルトパラメーター値を使用
  parameters = {}

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-serverless-app-stack"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: Terraform操作のタイムアウト時間の設定ブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration文字列
    # 省略時: プロバイダーデフォルト
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration文字列
    # 省略時: プロバイダーデフォルト
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration文字列
    # 省略時: プロバイダーデフォルト
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: CloudFormation スタックの ARN
# - outputs: スタックがエクスポートした出力値のキーと値のマップ
# - tags_all: プロバイダーの default_tags を含む全タグマップ
#---------------------------------------------------------------
