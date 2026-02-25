#---------------------------------------------------------------
# AWS Neptune DB Parameter Group
#---------------------------------------------------------------
#
# Amazon NeptuneのDBパラメータグループをプロビジョニングするリソースです。
# DBパラメータグループはインスタンスレベルの設定を管理し、Neptuneグラフエンジンの
# 動作パラメータを制御します。クラスターレベルの設定には
# aws_neptune_cluster_parameter_group を使用してください。
#
# AWS公式ドキュメント:
#   - Neptune パラメータグループ: https://docs.aws.amazon.com/neptune/latest/userguide/parameter-groups.html
#   - Neptune パラメータ一覧: https://docs.aws.amazon.com/neptune/latest/userguide/parameters.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_parameter_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_parameter_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # family (Required)
  # 設定内容: DBパラメータグループが属するパラメータグループファミリーを指定します。
  # 設定可能な値:
  #   - "neptune1"  : Neptune エンジンバージョン 1.1.x 以前向け
  #   - "neptune1.2": Neptune エンジンバージョン 1.2.0.0 以降向け
  # 参考: https://docs.aws.amazon.com/neptune/latest/userguide/parameter-groups.html
  family = "neptune1.2"

  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: DBパラメータグループの名前を指定します。
  # 設定可能な値: 英数字、ハイフンを含む文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefix と排他的（どちらか一方のみ指定可能）
  name = "example-neptune-parameter-group"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: DBパラメータグループ名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 省略時: name が使用されます。
  # 注意: name と排他的（どちらか一方のみ指定可能）
  name_prefix = null

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: DBパラメータグループの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: "Managed by Terraform" が設定されます。
  description = "Neptune DB parameter group for example"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # パラメータ設定
  #-------------------------------------------------------------

  # parameter (Optional)
  # 設定内容: Neptune DBインスタンスに適用するパラメータの設定ブロックです。
  # 複数のパラメータを設定する場合は、ブロックを繰り返して記述します。
  # 参考: https://docs.aws.amazon.com/neptune/latest/userguide/parameters.html
  parameter {

    # name (Required)
    # 設定内容: Neptuneパラメータの名前を指定します。
    # 設定可能な値:
    #   インスタンスレベルのパラメータ名（例）:
    #   - "neptune_query_timeout"  : クエリのタイムアウト時間（ミリ秒）。デフォルト 120000
    #   - "neptune_dfe_query_engine": DFEクエリエンジンの使用方法。"enabled" または "viaQueryHint"
    #   - "neptune_result_cache"   : クエリ結果キャッシュの有効化。0（無効）または 1（有効）
    #   - "UndoLogPurgeConfig"     : UndoLogパージの動作。"default" または "aggressive"
    name = "neptune_query_timeout"

    # value (Required)
    # 設定内容: Neptuneパラメータの値を指定します。
    # 設定可能な値: パラメータに応じた値（文字列として指定）
    value = "25000"

    # apply_method (Optional)
    # 設定内容: パラメータ変更の適用タイミングを指定します。
    # 設定可能な値:
    #   - "immediate"     : パラメータ変更を即時適用します（動的パラメータのみ有効）
    #   - "pending-reboot": 次回の再起動時にパラメータ変更を適用します（静的パラメータに必要）
    # 省略時: "pending-reboot" が使用されます。
    # 注意: Neptuneのインスタンスレベルパラメータは現在すべて静的のため、
    #       変更を有効にするにはDBインスタンスの再起動が必要です。
    apply_method = "pending-reboot"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-neptune-parameter-group"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id      : DBパラメータグループの名前
# - arn     : DBパラメータグループのAmazon Resource Name (ARN)
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
