#---------------------------------------------------------------
# Amazon GameLift Game Server Group
#---------------------------------------------------------------
#
# Amazon GameLift FleetIQのゲームサーバーグループを管理するリソース。
# GameLift FleetIQは、EC2 Auto Scalingグループと連携し、ゲームサーバーの
# ホスティングを最適化します。スポットインスタンスとオンデマンドインスタンスの
# バランシング戦略を設定し、コスト効率の良いゲームサーバーフリートを構築できます。
#
# このリソースは以下を作成します：
# - GameLift FleetIQゲームサーバーグループ
# - EC2 Auto Scalingグループ（対応する設定で自動作成）
#
# AWS公式ドキュメント:
#   - GameLift FleetIQ Game Server Groups: https://docs.aws.amazon.com/gameliftservers/latest/fleetiqguide/gsg-integrate-gameservergroup.html
#   - CreateGameServerGroup API: https://docs.aws.amazon.com/gamelift/latest/apireference/API_CreateGameServerGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/gamelift_game_server_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_gamelift_game_server_group" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ゲームサーバーグループ名
  # GameLift FleetIQゲームサーバーグループとEC2 Auto Scalingグループの
  # ARN生成に使用される一意の名前。
  game_server_group_name = "example-game-server-group"

  # 最大インスタンス数
  # EC2 Auto Scalingグループで許可される最大インスタンス数。
  # 自動スケーリングイベント時、GameLift FleetIQとEC2はこの最大値を超えて
  # スケールアップしません。
  max_size = 10

  # 最小インスタンス数
  # EC2 Auto Scalingグループで許可される最小インスタンス数。
  # 自動スケーリングイベント時、GameLift FleetIQとEC2はこの最小値を下回って
  # スケールダウンしません。
  min_size = 1

  # IAMロールARN
  # Amazon GameLiftがEC2 Auto Scalingグループにアクセスするための
  # IAMロールのARN。GameLiftGameServerGroupPolicyポリシーがアタッチされた
  # ロールを指定する必要があります。
  # 例: arn:aws:iam::123456789012:role/GameLiftGSGRole
  role_arn = "arn:aws:iam::123456789012:role/gamelift-game-server-group-role"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # バランシング戦略
  # GameLift FleetIQがスポットインスタンスとオンデマンドインスタンスの
  # 使用をバランスする方法を指定します。
  # 有効な値:
  #   - SPOT_ONLY: スポットインスタンスのみ使用
  #   - SPOT_PREFERRED: スポットインスタンスを優先（デフォルト）
  #   - ON_DEMAND_ONLY: オンデマンドインスタンスのみ使用
  # デフォルト: SPOT_PREFERRED
  balancing_strategy = "SPOT_PREFERRED"

  # ゲームサーバー保護ポリシー
  # ゲームサーバーグループ内のインスタンスが早期終了から保護されるかどうかを指定。
  # 保護されていないインスタンスは、アクティブなゲームサーバーが実行中でも
  # スケールダウンイベント時に終了される可能性があり、プレイヤーがゲームから
  # 切断される原因となります。
  # 保護されたインスタンスは、強制的なゲームサーバーグループ削除を除き、
  # アクティブなゲームサーバーが実行中は終了できません。
  # 有効な値:
  #   - NO_PROTECTION: 保護なし（デフォルト）
  #   - FULL_PROTECTION: 完全保護
  # デフォルト: NO_PROTECTION
  game_server_protection_policy = "NO_PROTECTION"

  # リージョン
  # このリソースが管理されるAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 例: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"

  # タグ
  # リソースに適用するキーバリューマップ形式のタグ。
  # ゲームサーバーグループとAuto Scalingグループの両方にタグが適用されます。
  tags = {
    Name        = "example-game-server-group"
    Environment = "production"
    Game        = "example-game"
  }

  # VPCサブネット
  # ゲームサーバーグループのインスタンスで使用するVPCサブネットのリスト。
  # デフォルトでは、GameLift FleetIQがサポートするすべてのアベイラビリティゾーンが使用されます。
  # 複数のサブネットを指定することで、高可用性を実現できます。
  vpc_subnets = [
    "subnet-12345678",
    "subnet-87654321",
  ]

  #---------------------------------------------------------------
  # ネストブロック: Auto Scalingポリシー
  #---------------------------------------------------------------

  # Auto Scalingポリシー設定（オプション、最大1つ）
  # ターゲット追跡型の自動スケーリングポリシーを定義します。
  auto_scaling_policy {
    # インスタンスウォームアップ時間（秒）
    # 新しいインスタンスが新しいゲームサーバープロセスを起動し、
    # GameLift FleetIQに登録するまでにかかる時間（秒単位）。
    # ゲームサーバーの起動に時間がかかる場合、ウォームアップ時間を指定すると、
    # 新しいインスタンスの早期起動を回避できます。
    # デフォルト: 60
    estimated_instance_warmup = 60

    # ターゲット追跡設定（必須、1つのみ）
    # ゲームサーバーグループのターゲットベースのスケーリングポリシーで使用する
    # ターゲット値を定義します。
    target_tracking_configuration {
      # ターゲット値
      # ゲームサーバーグループのターゲットベースのスケーリングポリシーで使用する
      # 目標値。通常、GameLiftが推奨する使用率（66%など）を指定します。
      target_value = 66
    }
  }

  #---------------------------------------------------------------
  # ネストブロック: インスタンス定義（必須）
  #---------------------------------------------------------------

  # インスタンス定義（最低2つ、最大20個必須）
  # ゲームサーバーグループで使用するEC2インスタンスタイプとその重み付けを定義します。
  # 複数のインスタンスタイプを指定することで、スポットインスタンスの可用性を高め、
  # コスト最適化を実現できます。

  # インスタンス定義1
  instance_definition {
    # インスタンスタイプ（必須）
    # EC2インスタンスタイプ（例: c5.large, c5.xlarge, m5.large）
    instance_type = "c5.large"

    # 重み付け容量（オプション）
    # このインスタンスタイプがゲームサーバーグループの合計容量にどれだけ
    # 貢献するかを示す重み付け。
    # GameLift FleetIQは、インスタンスタイプの1時間あたりのコストを計算し、
    # 最もコスト効率の良いオプションを識別するためにインスタンスウェイトを使用します。
    weighted_capacity = "1"
  }

  # インスタンス定義2
  instance_definition {
    instance_type     = "c5.xlarge"
    weighted_capacity = "2"
  }

  # 追加のインスタンスタイプを定義する場合は、instance_definitionブロックを追加
  # instance_definition {
  #   instance_type     = "m5.large"
  #   weighted_capacity = "1"
  # }

  #---------------------------------------------------------------
  # ネストブロック: 起動テンプレート（必須）
  #---------------------------------------------------------------

  # 起動テンプレート設定（必須、1つのみ）
  # EC2インスタンスの起動に使用する起動テンプレートを指定します。
  # 起動テンプレートには、AMI、セキュリティグループ、ユーザーデータなどの
  # インスタンス設定が含まれます。
  launch_template {
    # 起動テンプレートID（オプション、idまたはnameのいずれかを指定）
    # 既存のEC2起動テンプレートの一意の識別子。
    # 例: lt-1234567890abcdef0
    id = "lt-1234567890abcdef0"

    # 起動テンプレート名（オプション、idまたはnameのいずれかを指定）
    # 既存のEC2起動テンプレートの読み取り可能な識別子。
    # idとnameのどちらかを指定する必要があります。
    # name = "example-game-server-launch-template"

    # バージョン（オプション）
    # 使用するEC2起動テンプレートのバージョン。
    # 指定しない場合、デフォルトは最初に作成されたバージョンが使用されます。
    # 特定のバージョン番号、または "$Latest" / "$Default" を指定できます。
    version = "$Latest"
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # リソース作成/削除のタイムアウト設定
  timeouts {
    # 作成タイムアウト（デフォルト: 該当なし）
    # ゲームサーバーグループの作成完了までの最大待機時間。
    # 例: "60m"（60分）
    create = "60m"

    # 削除タイムアウト（デフォルト: 該当なし）
    # ゲームサーバーグループの削除完了までの最大待機時間。
    # 例: "60m"（60分）
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします：
#
# - id
#     GameLiftゲームサーバーグループの名前。
#
# - arn
#     GameLiftゲームサーバーグループのARN。
#     例: arn:aws:gamelift:us-east-1:123456789012:gameservergroup/example-game-server-group
#
# - auto_scaling_group_arn
#     作成されたEC2 Auto ScalingグループのARN。
#     例: arn:aws:autoscaling:us-east-1:123456789012:autoScalingGroup:12345678-1234-1234-1234-123456789012:autoScalingGroupName/example-game-server-group
#
# - tags_all
#     デフォルトタグを含む、リソースに割り当てられたすべてのタグのマップ。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 1. 基本的な使用例:
#
# resource "aws_gamelift_game_server_group" "basic" {
#   game_server_group_name = "basic-game-server-group"
#   max_size               = 5
#   min_size               = 1
#   role_arn              = aws_iam_role.gamelift_role.arn
#
#   instance_definition {
#     instance_type = "c5.large"
#   }
#
#   instance_definition {
#     instance_type = "c5.xlarge"
#   }
#
#   launch_template {
#     id = aws_launch_template.game_server.id
#   }
# }
#
# 2. スポットインスタンスのみを使用する例:
#
# resource "aws_gamelift_game_server_group" "spot_only" {
#   game_server_group_name        = "spot-only-group"
#   max_size                      = 10
#   min_size                      = 2
#   role_arn                      = aws_iam_role.gamelift_role.arn
#   balancing_strategy            = "SPOT_ONLY"
#   game_server_protection_policy = "FULL_PROTECTION"
#
#   auto_scaling_policy {
#     estimated_instance_warmup = 120
#
#     target_tracking_configuration {
#       target_value = 75
#     }
#   }
#
#   instance_definition {
#     instance_type     = "c5.large"
#     weighted_capacity = "1"
#   }
#
#   instance_definition {
#     instance_type     = "c5.xlarge"
#     weighted_capacity = "2"
#   }
#
#   instance_definition {
#     instance_type     = "m5.large"
#     weighted_capacity = "1"
#   }
#
#   launch_template {
#     id      = aws_launch_template.game_server.id
#     version = "$Latest"
#   }
#
#   vpc_subnets = [
#     aws_subnet.private_a.id,
#     aws_subnet.private_b.id,
#     aws_subnet.private_c.id,
#   ]
#
#   tags = {
#     Name        = "spot-only-group"
#     Environment = "production"
#   }
# }
#
# 3. 必要なIAMロールの例:
#
# data "aws_partition" "current" {}
#
# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"
#
#     principals {
#       type = "Service"
#       identifiers = [
#         "autoscaling.amazonaws.com",
#         "gamelift.amazonaws.com",
#       ]
#     }
#
#     actions = ["sts:AssumeRole"]
#   }
# }
#
# resource "aws_iam_role" "gamelift_role" {
#   name               = "gamelift-game-server-group-role"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }
#
# resource "aws_iam_role_policy_attachment" "gamelift_policy" {
#   role       = aws_iam_role.gamelift_role.name
#   policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/GameLiftGameServerGroupPolicy"
# }
#
#---------------------------------------------------------------
