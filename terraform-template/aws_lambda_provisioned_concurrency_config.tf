#---------------------------------------------------------------
# AWS Lambda Provisioned Concurrency Config
#---------------------------------------------------------------
#
# Lambda 関数のプロビジョニング済み同時実行数を設定するリソースです。
# プロビジョニング済み同時実行を使用することで、コールドスタートを排除し、
# 初期化済みの実行環境を事前に準備しておくことができます。
# 関数バージョンまたはエイリアスに対して適用します。
#
# AWS公式ドキュメント:
#   - プロビジョニング済み同時実行: https://docs.aws.amazon.com/lambda/latest/dg/provisioned-concurrency.html
#   - Lambda の同時実行: https://docs.aws.amazon.com/lambda/latest/dg/configuration-concurrency.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_provisioned_concurrency_config
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_provisioned_concurrency_config" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # function_name (Required)
  # 設定内容: プロビジョニング済み同時実行を設定する Lambda 関数の名前を指定します。
  # 設定可能な値:
  #   - 関数名: "my-function"
  #   - 関数 ARN: "arn:aws:lambda:ap-northeast-1:123456789012:function:my-function"
  # 注意: 指定した関数が存在しない場合、リソースの作成は失敗します。
  function_name = aws_lambda_function.example.function_name

  # qualifier (Required)
  # 設定内容: プロビジョニング済み同時実行を適用する関数バージョンまたはエイリアス名を指定します。
  # 設定可能な値:
  #   - バージョン番号: "1", "2" など（公開済みバージョン）
  #   - エイリアス名: "prod", "staging" など
  # 注意: "$LATEST" は指定できません。必ず公開済みバージョンまたはエイリアスを指定してください。
  qualifier = aws_lambda_alias.example.name

  # provisioned_concurrent_executions (Required)
  # 設定内容: 事前に初期化しておく同時実行数を指定します。
  # 設定可能な値: 1 以上の整数
  # 注意: アカウントおよびリージョンレベルの同時実行制限内で指定してください。
  #       設定した数だけ実行環境が常に準備された状態になります。
  # 参考: https://docs.aws.amazon.com/lambda/latest/dg/provisioned-concurrency.html
  provisioned_concurrent_executions = 1

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # skip_destroy (Optional)
  # 設定内容: Terraform destroy 時にプロビジョニング済み同時実行設定を削除しないかを指定します。
  # 設定可能な値:
  #   - true: destroy 時にリソースを削除せず、Terraform state からのみ削除します
  #   - false: destroy 時にリソースを削除します
  # 省略時: false（destroy 時にリソースを削除します）
  skip_destroy = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 注意: プロビジョニング済み同時実行の準備には時間がかかる場合があります。
  #       大きな同時実行数を指定する場合は、タイムアウトを長めに設定してください。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの Go 時間書式の文字列
    # 省略時: Terraform のデフォルトタイムアウトを使用します。
    create = "15m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの Go 時間書式の文字列
    # 省略時: Terraform のデフォルトタイムアウトを使用します。
    update = "15m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Terraform のリソース識別子
#       形式: "<function_name>:<qualifier>"
#---------------------------------------------------------------
