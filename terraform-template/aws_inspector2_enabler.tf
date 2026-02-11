#---------------------------------------------------------------
# Amazon Inspector v2 Enabler
#---------------------------------------------------------------
#
# Amazon Inspector v2の脆弱性スキャンを有効化するリソースです。
# 指定されたAWSアカウント（組織の管理者アカウントまたはメンバーアカウント）に対して、
# EC2インスタンス、ECRコンテナイメージ、Lambda関数、Lambdaコード、
# コードリポジトリの脆弱性スキャンを有効化します。
#
# このリソースは組織の管理者アカウント（Administrator Account）で作成する必要があります。
#
# AWS公式ドキュメント:
#   - Activating a scan type: https://docs.aws.amazon.com/inspector/latest/user/activate-scans.html
#   - Amazon Inspector User Guide: https://docs.aws.amazon.com/inspector/latest/user/what-is-inspector.html
#   - Enable API: https://docs.aws.amazon.com/inspector/v2/APIReference/API_Enable.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector2_enabler
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_inspector2_enabler" "example" {

  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # account_ids - (Required) スキャンを有効化するAWSアカウントIDのセット
  #
  # 以下のいずれかを指定できます:
  #   - 組織の管理者アカウント（Administrator Account）
  #   - 1つ以上のメンバーアカウント
  #
  # 例:
  #   account_ids = ["123456789012"]
  #   account_ids = ["123456789012", "987654321098"]
  #
  # 現在のアカウントIDを使用する場合は data.aws_caller_identity を使用:
  #   data "aws_caller_identity" "current" {}
  #   account_ids = [data.aws_caller_identity.current.account_id]
  #
  # Type: set(string)
  account_ids = ["123456789012"]

  # resource_types - (Required) スキャンするリソースタイプのセット
  #
  # 有効な値:
  #   - "EC2"            : Amazon EC2インスタンスのパッケージ脆弱性とネットワーク到達可能性の問題をスキャン
  #   - "ECR"            : Amazon ECRコンテナイメージとリポジトリをスキャン
  #   - "LAMBDA"         : Lambda関数のソフトウェア脆弱性をスキャン（過去90日以内に呼び出しまたは更新された関数が対象）
  #   - "LAMBDA_CODE"    : Lambda関数内のカスタムアプリケーションコードの脆弱性をスキャン（LAMBDA標準スキャンも有効化する必要がある）
  #   - "CODE_REPOSITORY": コードリポジトリの脆弱性をスキャン（Amazon Inspector Code Security）
  #
  # 最低1つのアイテムが必要です。
  #
  # 注意:
  #   - LAMBDA_CODEを有効化する場合は、先にLAMBDAを有効化する必要があります
  #   - ECRスキャンを有効化すると、プライベートレジストリのスキャン設定が
  #     基本スキャンから拡張スキャンに変更されます
  #
  # 例:
  #   resource_types = ["EC2"]
  #   resource_types = ["ECR", "EC2"]
  #   resource_types = ["EC2", "ECR", "LAMBDA", "LAMBDA_CODE"]
  #
  # Type: set(string)
  resource_types = ["EC2"]

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # region - (Optional) このリソースが管理されるリージョン
  #
  # デフォルトでは、プロバイダー設定で設定されたリージョンが使用されます。
  # このパラメータを使用して、プロバイダーのリージョンとは異なるリージョンで
  # Inspector v2を有効化できます。
  #
  # リージョンエンドポイントの詳細:
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # 例:
  #   region = "us-east-1"
  #   region = "eu-west-1"
  #   region = "ap-northeast-1"
  #
  # Type: string
  # Default: プロバイダー設定のリージョン
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------

  # timeouts - (Optional) リソース操作のタイムアウト設定
  #
  # Amazon Inspector v2の有効化・無効化処理は、アカウント数やリージョン数に応じて
  # 時間がかかる場合があります。デフォルトのタイムアウト値で不足する場合に調整します。
  #
  # timeouts {
  #   # create - (Optional) リソース作成のタイムアウト時間
  #   # Type: string (例: "5m", "1h")
  #   # Default: タイムアウトなし
  #   create = "10m"
  #
  #   # update - (Optional) リソース更新のタイムアウト時間
  #   # Type: string (例: "5m", "1h")
  #   # Default: タイムアウトなし
  #   update = "10m"
  #
  #   # delete - (Optional) リソース削除のタイムアウト時間
  #   # Type: string (例: "5m", "1h")
  #   # Default: タイムアウトなし
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします（読み取り専用）:
#
# - id - リソースの一意識別子（computed）
#   Type: string
#
#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
#
# Inspector v2 Enablerはインポートをサポートしていません。
#
#---------------------------------------------------------------
