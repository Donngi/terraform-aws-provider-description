#---------------------------------------------------------------
# AWS Step Functions State Machine Alias
#---------------------------------------------------------------
#
# AWS Step Functionsステートマシンのエイリアスをプロビジョニングするリソースです。
# エイリアスは同一ステートマシンの最大2つのバージョンへのポインタであり、
# トラフィックルーティングによる段階的デプロイやブルー/グリーンデプロイを実現します。
#
# AWS公式ドキュメント:
#   - ステートマシンエイリアス: https://docs.aws.amazon.com/step-functions/latest/dg/concepts-state-machine-alias.html
#   - バージョンとエイリアスによる継続的デプロイ: https://docs.aws.amazon.com/step-functions/latest/dg/concepts-cd-aliasing-versioning.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_alias
#
# Provider Version: 6.28.0
# Generated: 2026-02-08
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sfn_alias" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: エイリアスの名前を指定します。
  # 設定可能な値: 文字列
  # 注意: エイリアスARNはステートマシンARNとエイリアス名をコロン(:)で結合した形式になります。
  #       例: arn:aws:states:ap-northeast-1:123456789012:stateMachine:myStateMachine:myAlias
  # 注意: エイリアス名はステートマシンごとに一意である必要があります。
  name = "my_sfn_alias"

  # description (Optional)
  # 設定内容: エイリアスの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  description = "Production alias for my state machine"

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
  # ルーティング設定
  #-------------------------------------------------------------

  # routing_configuration (Required, min: 1)
  # 設定内容: エイリアスのトラフィックルーティング設定を指定します。
  # 最大2つのrouting_configurationブロックを指定でき、2つのバージョン間でトラフィックを分割できます。
  # 全routing_configurationブロックのweight合計は100になる必要があります。
  # 関連機能: Step Functions エイリアスルーティング設定
  #   エイリアスを使用して、2つのステートマシンバージョン間で実行トラフィックを
  #   ルーティングできます。段階的デプロイやブルー/グリーンデプロイに活用します。
  #   - https://docs.aws.amazon.com/step-functions/latest/dg/concepts-state-machine-alias.html

  routing_configuration {
    # state_machine_version_arn (Required)
    # 設定内容: ルーティング先のステートマシンバージョンのARNを指定します。
    # 設定可能な値: 有効なステートマシンバージョンARN
    #   形式: arn:aws:states:{region}:{account}:stateMachine:{name}:{version}
    # 注意: ステートマシンARNではなく、バージョンARNを指定する必要があります。
    #       バージョンは事前に公開されている必要があります。
    state_machine_version_arn = "arn:aws:states:ap-northeast-1:123456789012:stateMachine:myStateMachine:1"

    # weight (Required)
    # 設定内容: このバージョンにルーティングするトラフィックの割合(%)を指定します。
    # 設定可能な値: 0-100の数値
    # 注意: 全routing_configurationブロックのweight合計は100になる必要があります。
    weight = 100
  }

  # 2つのバージョン間でトラフィックを分割する場合の例:
  # routing_configuration {
  #   state_machine_version_arn = "arn:aws:states:ap-northeast-1:123456789012:stateMachine:myStateMachine:2"
  #   weight                    = 80
  # }
  #
  # routing_configuration {
  #   state_machine_version_arn = "arn:aws:states:ap-northeast-1:123456789012:stateMachine:myStateMachine:1"
  #   weight                    = 20
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトを使用
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトを使用
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトを使用
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ステートマシンエイリアスのAmazon Resource Name (ARN)
#        形式: arn:aws:states:{region}:{account}:stateMachine:{name}:{alias-name}
#        StartExecution API呼び出し時にこのARNを使用して、
#        エイリアス経由でステートマシンを実行できます。
#
# - creation_date: ステートマシンエイリアスが作成された日付
#---------------------------------------------------------------
