#---------------------------------------------------------------
# AWS Neptune Cluster Parameter Group
#---------------------------------------------------------------
#
# Amazon Neptune DBクラスターパラメーターグループをプロビジョニングするリソースです。
# DBクラスターパラメーターグループはクラスター内のすべてのインスタンスに適用される
# データベースエンジンの設定パラメーターを管理します。Neptuneクラスターは必ず
# いずれかのDBクラスターパラメーターグループに関連付けられます。
#
# AWS公式ドキュメント:
#   - Amazon Neptuneパラメーターグループ: https://docs.aws.amazon.com/neptune/latest/userguide/parameter-groups.html
#   - CreateDBClusterParameterGroup API: https://docs.aws.amazon.com/neptune/latest/apiref/API_CreateDBClusterParameterGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster_parameter_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_cluster_parameter_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # family (Required)
  # 設定内容: Neptuneクラスターパラメーターグループのファミリー名を指定します。
  # 設定可能な値:
  #   - "neptune1": Neptune エンジンバージョン 1.1.x 以前に対応
  #   - "neptune1.2": Neptune エンジンバージョン 1.2.0.0 以降に対応
  #   - "neptune1.3": Neptune エンジンバージョン 1.3.x 以降に対応
  # 参考: https://docs.aws.amazon.com/neptune/latest/userguide/parameter-groups.html
  family = "neptune1.2"

  # name (Optional, Forces new resource)
  # 設定内容: Neptuneクラスターパラメーターグループの名前を指定します。
  # 設定可能な値: 1-255文字の英数字、ハイフンを使用した文字列。先頭は英字であること
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefix と排他的（どちらか一方のみ指定可能）
  name = "example-neptune-cluster-pg"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: Neptuneクラスターパラメーターグループ名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを付加します。
  # 省略時: name が指定された場合は無視されます。
  # 注意: name と排他的（どちらか一方のみ指定可能）
  name_prefix = null

  # description (Optional)
  # 設定内容: Neptuneクラスターパラメーターグループの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: "Managed by Terraform" が設定されます。
  description = "Neptune cluster parameter group managed by Terraform"

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
  # パラメーター設定
  #-------------------------------------------------------------

  # parameter (Optional)
  # 設定内容: Neptuneクラスターに適用するパラメーターの設定ブロックです。複数指定可能です。
  # 関連機能: Neptune パラメーター管理
  #   動的パラメーターは変更後すぐに反映されますが、静的パラメーターはDBインスタンスの
  #   再起動後に反映されます。現在、Neptuneのクラスターレベルの動的パラメーターは
  #   neptune_enable_slow_query_log と neptune_slow_query_log_threshold のみです。
  #   - https://docs.aws.amazon.com/neptune/latest/userguide/parameter-groups.html
  parameter {

    # name (Required)
    # 設定内容: 設定するNeptuneパラメーターの名前を指定します。
    # 設定可能な値: 有効なNeptuneクラスターパラメーター名
    #   例: neptune_enable_audit_log, neptune_enable_slow_query_log,
    #       neptune_slow_query_log_threshold, neptune_streams 等
    name = "neptune_enable_audit_log"

    # value (Required)
    # 設定内容: 設定するNeptuneパラメーターの値を指定します。
    # 設定可能な値: 各パラメーターに定義された有効な値
    #   例: neptune_enable_audit_log は 0 (無効) または 1 (有効)
    value = "1"

    # apply_method (Optional)
    # 設定内容: パラメーターの適用タイミングを指定します。
    # 設定可能な値:
    #   - "immediate": 変更を即座に適用します（動的パラメーターのみ有効）
    #   - "pending-reboot": 次回のDBインスタンス再起動時に適用します（静的パラメーターに必須）
    # 省略時: "pending-reboot" が設定されます。
    apply_method = "pending-reboot"
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
    Name        = "example-neptune-cluster-pg"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Neptuneクラスターパラメーターグループの名前
#
# - arn: Neptuneクラスターパラメーターグループの Amazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
