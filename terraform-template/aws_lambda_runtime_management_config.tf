#---------------------------------------------------------------
# AWS Lambda Runtime Management Config
#---------------------------------------------------------------
#
# Lambda関数のランタイム更新方法を制御するリソースです。
# このリソースを使用して、Lambda関数のランタイムを自動更新するか、
# 関数更新時に更新するか、または手動で管理するかを設定できます。
#
# 注意: このリソースを削除すると、ランタイム更新モードは「Auto」（デフォルト）に戻ります。
#       設定済みのランタイム管理オプションをそのままにする場合は、
#       destroy lifecycleをfalseに設定したremovedブロックを使用してください。
#
# AWS公式ドキュメント:
#   - ランタイム管理設定の構成: https://docs.aws.amazon.com/lambda/latest/dg/runtime-management-configure-settings.html
#   - ランタイムバージョン更新の仕組み: https://docs.aws.amazon.com/lambda/latest/dg/runtimes-update.html
#   - PutRuntimeManagementConfig API: https://docs.aws.amazon.com/lambda/latest/api/API_PutRuntimeManagementConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_runtime_management_config
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_runtime_management_config" "example" {
  #-------------------------------------------------------------
  # 対象関数設定
  #-------------------------------------------------------------

  # function_name (Required)
  # 設定内容: ランタイム管理設定を適用するLambda関数の名前またはARNを指定します。
  # 設定可能な値: Lambda関数名、または関数のARN文字列
  function_name = "my-lambda-function"

  # qualifier (Optional)
  # 設定内容: 設定を適用する関数のバージョンを指定します。
  # 設定可能な値:
  #   - "$LATEST": 未公開バージョン（デフォルト動作）
  #   - 公開済みバージョン番号（例: "1", "2"）
  # 省略時: $LATESTのランタイム設定を管理します。
  qualifier = null

  #-------------------------------------------------------------
  # ランタイム更新モード設定
  #-------------------------------------------------------------

  # update_runtime_on (Optional)
  # 設定内容: Lambda関数のランタイム更新モードを指定します。
  # 設定可能な値:
  #   - "Auto": 新しいランタイムバージョンが利用可能になると自動的に更新（デフォルト）
  #   - "FunctionUpdate": 関数が更新されたときに最新のランタイムバージョンへ更新
  #   - "Manual": runtime_version_arnで指定したバージョンのみ使用（手動管理）
  # 省略時: 関数作成時のデフォルト動作である "Auto" が適用されます。
  # 参考: https://docs.aws.amazon.com/lambda/latest/dg/runtimes-update.html
  update_runtime_on = "FunctionUpdate"

  # runtime_version_arn (Optional)
  # 設定内容: 使用するランタイムバージョンのARNを指定します。
  # 設定可能な値: ランタイムバージョンのARN文字列
  #   例: arn:aws:lambda:us-east-1::runtime:abcd1234...
  # 省略時: AWSが管理する最新のランタイムバージョンが使用されます。
  # 注意: update_runtime_on が "Manual" の場合のみ必須です。
  #       ランタイムバージョンARNはハッシュ値を含むため、AWSコンソールの
  #       「ランタイム設定」セクションから確認できます。
  # 参考: https://docs.aws.amazon.com/lambda/latest/api/API_PutRuntimeManagementConfig.html
  runtime_version_arn = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - function_arn: Lambda関数のARN
#---------------------------------------------------------------
