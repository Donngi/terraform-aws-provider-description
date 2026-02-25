#---------------------------------------------------------------
# Amazon GameLift ゲームサーバーグループ
#---------------------------------------------------------------
#
# Amazon GameLift FleetIQ のゲームサーバーグループをプロビジョニングするリソースです。
# ゲームサーバーグループは、Amazon EC2 Auto Scaling グループと連携してゲームサーバーの
# インスタンスを管理し、コスト効率の高いスポットインスタンスを優先的に使用しながら
# 必要に応じてオンデマンドインスタンスにフォールバックします。
#
# AWS公式ドキュメント:
#   - GameLift FleetIQ ゲームサーバーグループ: https://docs.aws.amazon.com/gamelift/latest/fleetiqguide/gsg-intro.html
#   - ゲームサーバーグループの作成: https://docs.aws.amazon.com/gamelift/latest/fleetiqguide/gsg-create-game-server-group.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/gamelift_game_server_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_gamelift_game_server_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # game_server_group_name (Required)
  # 設定内容: ゲームサーバーグループの名前を指定します。
  # 設定可能な値: 1〜128文字の英字、数字、ハイフン、アンダースコア
  game_server_group_name = "example-game-server-group"

  # role_arn (Required)
  # 設定内容: GameLift FleetIQ が Auto Scaling グループを管理するために使用する
  #          IAM ロールの ARN を指定します。
  # 設定可能な値: IAM ロールの ARN
  # 注意: このロールには GameLift FleetIQ および EC2 Auto Scaling に対する
  #       適切なアクセス許可が必要です。
  role_arn = "arn:aws:iam::123456789012:role/GameLiftFleetIQRole"

  # min_size (Required)
  # 設定内容: Auto Scaling グループで維持するインスタンスの最小数を指定します。
  # 設定可能な値: 0 以上の整数
  # 注意: min_size は max_size 以下である必要があります。
  min_size = 1

  # max_size (Required)
  # 設定内容: Auto Scaling グループで維持するインスタンスの最大数を指定します。
  # 設定可能な値: 1 以上の整数
  max_size = 10

  #-------------------------------------------------------------
  # バランシング・保護設定
  #-------------------------------------------------------------

  # balancing_strategy (Optional)
  # 設定内容: スポットインスタンスとオンデマンドインスタンスのバランス方法を指定します。
  # 設定可能な値:
  #   - "SPOT_ONLY": スポットインスタンスのみを使用する
  #   - "SPOT_PREFERRED": スポットインスタンスを優先し、利用できない場合はオンデマンドインスタンスを使用する
  #   - "ON_DEMAND_ONLY": オンデマンドインスタンスのみを使用する
  # 省略時: "SPOT_PREFERRED"
  balancing_strategy = "SPOT_PREFERRED"

  # game_server_protection_policy (Optional)
  # 設定内容: アクティブなゲームセッションを実行しているゲームサーバーを保護するかどうかを指定します。
  # 設定可能な値:
  #   - "NO_PROTECTION": 保護なし（スケールダウン時にアクティブなゲームサーバーも終了する可能性あり）
  #   - "FULL_PROTECTION": アクティブなゲームセッションを実行しているゲームサーバーはスケールダウン対象外
  # 省略時: "NO_PROTECTION"
  game_server_protection_policy = "FULL_PROTECTION"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # vpc_subnets (Optional)
  # 設定内容: ゲームサーバーグループのインスタンスを配置する VPC サブネット ID のセットを指定します。
  # 設定可能な値: VPC サブネット ID のセット（最大 20 件）
  # 省略時: デフォルト VPC のサブネットが使用されます
  vpc_subnets = [
    "subnet-xxxxxxxx",
    "subnet-yyyyyyyy",
  ]

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-game-server-group"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # Auto Scaling ポリシー設定
  #-------------------------------------------------------------

  # auto_scaling_policy (Optional)
  # 設定内容: ゲームサーバーグループの Auto Scaling ポリシーを指定します。
  #          ターゲット追跡スケーリングポリシーを設定できます。
  auto_scaling_policy {
    # estimated_instance_warmup (Optional)
    # 設定内容: 新しいインスタンスが起動されてからスケーリングメトリクスに
    #          影響を与えるまでの推定ウォームアップ時間（秒）を指定します。
    # 設定可能な値: 1 以上の整数
    # 省略時: Auto Scaling のデフォルト値
    estimated_instance_warmup = 60

    # target_tracking_configuration (Required within auto_scaling_policy)
    # 設定内容: ターゲット追跡スケーリングポリシーの設定を指定します。
    target_tracking_configuration {
      # target_value (Required)
      # 設定内容: ターゲット追跡スケーリングポリシーのターゲット値を指定します。
      #          GameLift FleetIQ はこのターゲット値を維持するようにスケーリングします。
      # 設定可能な値: 0.0 より大きい数値
      target_value = 100
    }
  }

  #-------------------------------------------------------------
  # インスタンス定義設定
  #-------------------------------------------------------------

  # instance_definition (Required)
  # 設定内容: ゲームサーバーグループで使用するインスタンスタイプを指定します。
  #          2〜20 個のインスタンスタイプを指定できます。
  #          GameLift FleetIQ は指定された優先順位に従いコスト効率の高い
  #          インスタンスタイプを自動的に選択します。
  # 注意: 最低 2 つ、最大 20 つのインスタンスタイプを指定する必要があります。
  instance_definition {
    # instance_type (Required)
    # 設定内容: 使用する EC2 インスタンスタイプを指定します。
    # 設定可能な値: GameLift FleetIQ でサポートされている EC2 インスタンスタイプ
    #   （例: c5.large, c5.xlarge, m5.large, r5.large など）
    instance_type = "c5.large"

    # weighted_capacity (Optional)
    # 設定内容: このインスタンスタイプの相対的な重み付けを指定します。
    #          グループ内の希望インスタンス数の計算に使用されます。
    # 設定可能な値: 1〜999 の整数を文字列で指定
    # 省略時: "1"
    weighted_capacity = "1"
  }

  instance_definition {
    instance_type    = "c5.xlarge"
    weighted_capacity = "2"
  }

  #-------------------------------------------------------------
  # 起動テンプレート設定
  #-------------------------------------------------------------

  # launch_template (Required)
  # 設定内容: ゲームサーバーインスタンスの起動設定を定義する
  #          EC2 起動テンプレートを指定します。
  launch_template {
    # id (Optional)
    # 設定内容: 使用する EC2 起動テンプレートの ID を指定します。
    # 設定可能な値: EC2 起動テンプレートの ID
    # 注意: id または name のいずれか一方を指定する必要があります。
    # 省略時: name で指定された起動テンプレートを使用
    id = null

    # name (Optional)
    # 設定内容: 使用する EC2 起動テンプレートの名前を指定します。
    # 設定可能な値: EC2 起動テンプレート名
    # 注意: id または name のいずれか一方を指定する必要があります。
    # 省略時: id で指定された起動テンプレートを使用
    name = "example-launch-template"

    # version (Optional)
    # 設定内容: 使用する EC2 起動テンプレートのバージョンを指定します。
    # 設定可能な値: 起動テンプレートのバージョン番号（例: "1", "2"）
    # 省略時: 起動テンプレートのデフォルトバージョンを使用
    version = "$Latest"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソースの作成完了を待機する最大時間を指定します。
    # 設定可能な値: "30m", "1h" などの Go duration 形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウト
    create = "10m"

    # delete (Optional)
    # 設定内容: リソースの削除完了を待機する最大時間を指定します。
    # 設定可能な値: "30m", "1h" などの Go duration 形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウト
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ゲームサーバーグループの名前
#
# - arn: ゲームサーバーグループを識別する ARN
#
# - auto_scaling_group_arn: 関連付けられた Auto Scaling グループの ARN
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
