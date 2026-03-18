#---------------------------------------------------------------
# Amazon ARC Region Switch プラン
#---------------------------------------------------------------
#
# Amazon Application Recovery Controller (ARC) の Region Switch プランを
# プロビジョニングするリソースです。
# 複数リージョンにまたがるアプリケーションの復旧計画を定義し、
# リージョン障害時のフェイルオーバーをオーケストレーションします。
# ワークフローとステップにより、EC2 Auto Scaling、ECS、EKS、Aurora、
# DocumentDB、Route 53、Lambda カスタムアクションなどの復旧手順を構成できます。
#
# AWS公式ドキュメント:
#   - Region Switch 概要: https://docs.aws.amazon.com/r53recovery/latest/dg/region-switch.html
#   - Region Switch コンポーネント: https://docs.aws.amazon.com/r53recovery/latest/dg/components-rs.html
#   - Region Switch プランの作成: https://docs.aws.amazon.com/r53recovery/latest/dg/working-with-rs-create-plan.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/arcregionswitch_plan
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_arcregionswitch_plan" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: プランの名前を指定します。
  # 設定可能な値: アカウント内で一意の文字列
  name = "example-plan"

  # execution_role (Required)
  # 設定内容: ARC Region Switch がプランを実行する際に引き受ける IAM ロールの ARN を指定します。
  # 設定可能な値: 有効な IAM ロール ARN
  # 注意: arc-region-switch.amazonaws.com サービスからの sts:AssumeRole を許可するポリシーが必要
  execution_role = "arn:aws:iam::123456789012:role/arc-region-switch-role"

  # recovery_approach (Required)
  # 設定内容: プランの復旧アプローチを指定します。
  # 設定可能な値:
  #   - "activeActive": 両リージョンがトラフィックを処理するアクティブ/アクティブ構成
  #   - "activePassive": 片方のリージョンのみがトラフィックを処理するアクティブ/パッシブ構成
  recovery_approach = "activePassive"

  # regions (Required)
  # 設定内容: プランに含まれる AWS リージョンのリストを指定します。
  # 設定可能な値: 有効な AWS リージョンコードのリスト
  regions = ["us-east-1", "us-west-2"]

  #-------------------------------------------------------------
  # プラン詳細設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: プランの説明を指定します。
  # 設定可能な値: 任意の文字列
  description = null

  # primary_region (Optional)
  # 設定内容: プランのプライマリリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: us-east-1）
  primary_region = "us-east-1"

  # recovery_time_objective_minutes (Optional)
  # 設定内容: 復旧時間目標（RTO）を分単位で指定します。
  # 設定可能な値: 正の数値（分）
  recovery_time_objective_minutes = null

  #-------------------------------------------------------------
  # CloudWatch アラーム設定
  #-------------------------------------------------------------

  # associated_alarms (Optional)
  # 設定内容: プランに関連付ける CloudWatch アラームの設定ブロックです。
  #   アプリケーションの健全性監視やトリガー条件に使用します。
  #   複数指定可能。
  # associated_alarms {
  #   # map_block_key (Required)
  #   # 設定内容: アラームの名前を指定します。
  #   # 設定可能な値: 一意の文字列
  #   map_block_key = "application-health-alarm"
  #
  #   # alarm_type (Required)
  #   # 設定内容: アラームの種別を指定します。
  #   # 設定可能な値:
  #   #   - "applicationHealth": アプリケーション健全性アラーム
  #   #   - "trigger": トリガーアラーム
  #   alarm_type = "applicationHealth"
  #
  #   # resource_identifier (Required)
  #   # 設定内容: CloudWatch アラームのリソース識別子（ARN）を指定します。
  #   # 設定可能な値: 有効な CloudWatch アラーム ARN
  #   resource_identifier = "arn:aws:cloudwatch:us-east-1:123456789012:alarm:MyAlarm"
  #
  #   # cross_account_role (Optional)
  #   # 設定内容: クロスアカウントアクセス時に引き受ける IAM ロールの ARN を指定します。
  #   # 設定可能な値: 有効な IAM ロール ARN
  #   cross_account_role = null
  #
  #   # external_id (Optional)
  #   # 設定内容: クロスアカウントロール引き受け時の外部 ID を指定します。
  #   # 設定可能な値: 文字列
  #   external_id = null
  # }

  #-------------------------------------------------------------
  # ワークフロー設定
  #-------------------------------------------------------------

  # workflow (Required)
  # 設定内容: プランの実行ステップを定義するワークフローの設定ブロックです。
  #   各ワークフローはターゲットアクション（activate/deactivate）とリージョンを指定し、
  #   1つ以上のステップを含みます。複数指定可能。

  # アクティベーション用ワークフロー
  workflow {
    # workflow_target_action (Required)
    # 設定内容: ワークフローで実行するアクションを指定します。
    # 設定可能な値:
    #   - "activate": リージョンをアクティブにする
    #   - "deactivate": リージョンを非アクティブにする
    workflow_target_action = "activate"

    # workflow_target_region (Optional)
    # 設定内容: ワークフローのターゲットリージョンを指定します。
    # 設定可能な値: 有効な AWS リージョンコード
    workflow_target_region = "us-west-2"

    # workflow_description (Optional)
    # 設定内容: ワークフローの説明を指定します。
    # 設定可能な値: 任意の文字列
    workflow_description = null

    #-----------------------------------------------------------
    # ステップ設定
    #-----------------------------------------------------------

    # step (Optional)
    # 設定内容: ワークフロー内の実行ステップの設定ブロックです。
    #   execution_block_type に応じて対応する設定ブロックを指定します。
    #   複数指定可能。

    step {
      # name (Required)
      # 設定内容: ステップの名前を指定します。
      # 設定可能な値: 一意の文字列
      name = "manual-approval"

      # execution_block_type (Required)
      # 設定内容: 実行ブロックのタイプを指定します。
      # 設定可能な値:
      #   - "ARCRegionSwitchPlan": ネストされた Region Switch プラン
      #   - "ARCRoutingControl": ARC ルーティングコントロール
      #   - "AuroraGlobalDatabase": Aurora グローバルデータベース
      #   - "CustomActionLambda": Lambda カスタムアクション
      #   - "DocumentDb": DocumentDB グローバルクラスター
      #   - "EC2AutoScaling": EC2 Auto Scaling グループ
      #   - "ECSServiceScaling": ECS サービススケーリング
      #   - "EKSResourceScaling": EKS リソーススケーリング
      #   - "ManualApproval": 手動承認
      #   - "Parallel": 並列実行
      #   - "Route53HealthCheck": Route 53 ヘルスチェック
      execution_block_type = "ManualApproval"

      # description (Optional)
      # 設定内容: ステップの説明を指定します。
      # 設定可能な値: 任意の文字列
      description = null

      #---------------------------------------------------------
      # 手動承認設定 (ManualApproval)
      #---------------------------------------------------------

      # execution_approval_config (Optional)
      # 設定内容: 手動承認ステップの設定ブロックです。
      #   execution_block_type が "ManualApproval" の場合に使用します。
      execution_approval_config {
        # approval_role (Required)
        # 設定内容: 承認に使用する IAM ロールの ARN を指定します。
        # 設定可能な値: 有効な IAM ロール ARN
        approval_role = "arn:aws:iam::123456789012:role/arc-region-switch-role"

        # timeout_minutes (Optional)
        # 設定内容: 承認のタイムアウト時間を分単位で指定します。
        # 設定可能な値: 正の数値（分）
        timeout_minutes = 60
      }
    }
  }

  # デアクティベーション用ワークフロー
  workflow {
    workflow_target_action = "deactivate"
    workflow_target_region = "us-east-1"
    workflow_description   = null

    step {
      name                 = "manual-approval"
      execution_block_type = "ManualApproval"

      execution_approval_config {
        approval_role   = "arn:aws:iam::123456789012:role/arc-region-switch-role"
        timeout_minutes = 60
      }
    }
  }

  #-------------------------------------------------------------
  # Lambda カスタムアクション設定 (CustomActionLambda)
  #   execution_block_type = "CustomActionLambda" のステップで使用
  #-------------------------------------------------------------

  # custom_action_lambda_config の設定例（ワークフロー step 内で使用）:
  # step {
  #   name                 = "lambda-step"
  #   execution_block_type = "CustomActionLambda"
  #
  #   custom_action_lambda_config {
  #     # region_to_run (Required)
  #     # 設定内容: Lambda 関数を実行するリージョンを指定します。
  #     # 設定可能な値:
  #     #   - "activatingRegion": アクティベーション対象のリージョン
  #     #   - "deactivatingRegion": デアクティベーション対象のリージョン
  #     region_to_run = "activatingRegion"
  #
  #     # retry_interval_minutes (Required)
  #     # 設定内容: リトライ間隔を分単位で指定します。
  #     # 設定可能な値: 正の数値（分）
  #     retry_interval_minutes = 5.0
  #
  #     # timeout_minutes (Optional)
  #     # 設定内容: タイムアウト時間を分単位で指定します。
  #     # 設定可能な値: 正の数値（分）
  #     timeout_minutes = 30
  #
  #     # lambda (Required)
  #     # 設定内容: Lambda 関数の設定ブロックです。
  #     lambda {
  #       # arn (Required)
  #       # 設定内容: Lambda 関数の ARN を指定します。
  #       # 設定可能な値: 有効な Lambda 関数 ARN
  #       arn = "arn:aws:lambda:us-west-2:123456789012:function:my-function"
  #
  #       # cross_account_role (Optional)
  #       # 設定内容: クロスアカウントアクセス時に引き受ける IAM ロールの ARN を指定します。
  #       # 設定可能な値: 有効な IAM ロール ARN
  #       cross_account_role = null
  #
  #       # external_id (Optional)
  #       # 設定内容: クロスアカウントロール引き受け時の外部 ID を指定します。
  #       # 設定可能な値: 文字列
  #       external_id = null
  #     }
  #
  #     # ungraceful (Optional)
  #     # 設定内容: 非グレースフルモード時の動作設定ブロックです。
  #     # ungraceful {
  #     #   # behavior (Required)
  #     #   # 設定内容: 非グレースフルモード時の動作を指定します。
  #     #   # 設定可能な値: "skip"
  #     #   behavior = "skip"
  #     # }
  #   }
  # }

  #-------------------------------------------------------------
  # ARC ルーティングコントロール設定 (ARCRoutingControl)
  #   execution_block_type = "ARCRoutingControl" のステップで使用
  #-------------------------------------------------------------

  # arc_routing_control_config の設定例（ワークフロー step 内で使用）:
  # step {
  #   name                 = "routing-control-step"
  #   execution_block_type = "ARCRoutingControl"
  #
  #   arc_routing_control_config {
  #     # cross_account_role (Optional)
  #     # 設定内容: クロスアカウントアクセス時に引き受ける IAM ロールの ARN を指定します。
  #     # 設定可能な値: 有効な IAM ロール ARN
  #     cross_account_role = null
  #
  #     # external_id (Optional)
  #     # 設定内容: クロスアカウントロール引き受け時の外部 ID を指定します。
  #     # 設定可能な値: 文字列
  #     external_id = null
  #
  #     # timeout_minutes (Optional)
  #     # 設定内容: タイムアウト時間を分単位で指定します。
  #     # 設定可能な値: 正の数値（分）
  #     timeout_minutes = null
  #
  #     # region_and_routing_controls (Required)
  #     # 設定内容: リージョンとルーティングコントロールの設定ブロックです。複数指定可能。
  #     region_and_routing_controls {
  #       # region (Required)
  #       # 設定内容: AWS リージョンを指定します。
  #       # 設定可能な値: 有効な AWS リージョンコード
  #       region = "us-east-1"
  #
  #       # routing_control (Required)
  #       # 設定内容: ルーティングコントロールの設定ブロックです。複数指定可能。
  #       routing_control {
  #         # routing_control_arn (Required)
  #         # 設定内容: ルーティングコントロールの ARN を指定します。
  #         # 設定可能な値: 有効なルーティングコントロール ARN
  #         routing_control_arn = "arn:aws:route53-recovery-control::123456789012:controlpanel/abc/routingcontrol/def"
  #
  #         # state (Required)
  #         # 設定内容: ルーティングコントロールの状態を指定します。
  #         # 設定可能な値:
  #         #   - "On": 有効
  #         #   - "Off": 無効
  #         state = "On"
  #       }
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # Aurora グローバルデータベース設定 (AuroraGlobalDatabase)
  #   execution_block_type = "AuroraGlobalDatabase" のステップで使用
  #-------------------------------------------------------------

  # global_aurora_config の設定例（ワークフロー step 内で使用）:
  # step {
  #   name                 = "aurora-step"
  #   execution_block_type = "AuroraGlobalDatabase"
  #
  #   global_aurora_config {
  #     # behavior (Required)
  #     # 設定内容: グローバルデータベース操作の動作を指定します。
  #     # 設定可能な値:
  #     #   - "switchoverOnly": スイッチオーバーのみ（データ損失なし）
  #     #   - "failover": フェイルオーバー
  #     behavior = "switchoverOnly"
  #
  #     # global_cluster_identifier (Required)
  #     # 設定内容: グローバルクラスターの識別子を指定します。
  #     # 設定可能な値: 有効なグローバルクラスター識別子
  #     global_cluster_identifier = "my-global-cluster"
  #
  #     # database_cluster_arns (Required)
  #     # 設定内容: データベースクラスターの ARN リストを指定します。
  #     # 設定可能な値: 有効な Aurora クラスター ARN のリスト
  #     database_cluster_arns = [
  #       "arn:aws:rds:us-east-1:123456789012:cluster:my-cluster-1",
  #       "arn:aws:rds:us-west-2:123456789012:cluster:my-cluster-2"
  #     ]
  #
  #     # cross_account_role (Optional)
  #     # 設定内容: クロスアカウントアクセス時に引き受ける IAM ロールの ARN を指定します。
  #     # 設定可能な値: 有効な IAM ロール ARN
  #     cross_account_role = null
  #
  #     # external_id (Optional)
  #     # 設定内容: クロスアカウントロール引き受け時の外部 ID を指定します。
  #     # 設定可能な値: 文字列
  #     external_id = null
  #
  #     # timeout_minutes (Optional)
  #     # 設定内容: タイムアウト時間を分単位で指定します。
  #     # 設定可能な値: 正の数値（分）
  #     timeout_minutes = null
  #
  #     # ungraceful (Optional)
  #     # 設定内容: 非グレースフルモード時の動作設定ブロックです。
  #     # ungraceful {
  #     #   # ungraceful (Required)
  #     #   # 設定内容: 非グレースフルモード時の動作を指定します。
  #     #   # 設定可能な値: "failover"
  #     #   ungraceful = "failover"
  #     # }
  #   }
  # }

  #-------------------------------------------------------------
  # DocumentDB グローバルクラスター設定 (DocumentDb)
  #   execution_block_type = "DocumentDb" のステップで使用
  #-------------------------------------------------------------

  # document_db_config の設定例（ワークフロー step 内で使用）:
  # step {
  #   name                 = "documentdb-step"
  #   execution_block_type = "DocumentDb"
  #
  #   document_db_config {
  #     # behavior (Required)
  #     # 設定内容: グローバルクラスター操作の動作を指定します。
  #     # 設定可能な値:
  #     #   - "switchoverOnly": スイッチオーバーのみ
  #     #   - "failover": フェイルオーバー
  #     behavior = "switchoverOnly"
  #
  #     # global_cluster_identifier (Required)
  #     # 設定内容: DocumentDB グローバルクラスターの識別子を指定します。
  #     # 設定可能な値: 有効なグローバルクラスター識別子
  #     global_cluster_identifier = "my-docdb-global-cluster"
  #
  #     # database_cluster_arns (Required)
  #     # 設定内容: DocumentDB クラスターの ARN リストを指定します。
  #     # 設定可能な値: 有効な DocumentDB クラスター ARN のリスト
  #     database_cluster_arns = [
  #       "arn:aws:rds:us-east-1:123456789012:cluster:my-docdb-1",
  #       "arn:aws:rds:us-west-2:123456789012:cluster:my-docdb-2"
  #     ]
  #
  #     # cross_account_role (Optional)
  #     # 設定内容: クロスアカウントアクセス時に引き受ける IAM ロールの ARN を指定します。
  #     # 設定可能な値: 有効な IAM ロール ARN
  #     cross_account_role = null
  #
  #     # external_id (Optional)
  #     # 設定内容: クロスアカウントロール引き受け時の外部 ID を指定します。
  #     # 設定可能な値: 文字列
  #     external_id = null
  #
  #     # timeout_minutes (Optional)
  #     # 設定内容: タイムアウト時間を分単位で指定します。
  #     # 設定可能な値: 正の数値（分）
  #     timeout_minutes = null
  #
  #     # ungraceful (Optional)
  #     # 設定内容: 非グレースフルモード時の動作設定ブロックです。
  #     # ungraceful {
  #     #   # ungraceful (Required)
  #     #   # 設定内容: 非グレースフルモード時の動作を指定します。
  #     #   # 設定可能な値: "failover"
  #     #   ungraceful = "failover"
  #     # }
  #   }
  # }

  #-------------------------------------------------------------
  # EC2 Auto Scaling キャパシティ増加設定 (EC2AutoScaling)
  #   execution_block_type = "EC2AutoScaling" のステップで使用
  #-------------------------------------------------------------

  # ec2_asg_capacity_increase_config の設定例（ワークフロー step 内で使用）:
  # step {
  #   name                 = "asg-scaling-step"
  #   execution_block_type = "EC2AutoScaling"
  #
  #   ec2_asg_capacity_increase_config {
  #     # capacity_monitoring_approach (Required)
  #     # 設定内容: キャパシティ監視アプローチを指定します。
  #     # 設定可能な値:
  #     #   - "sampledMaxInLast24Hours": 過去24時間のサンプリング最大値
  #     #   - "autoscalingMaxInLast24Hours": 過去24時間の Auto Scaling 最大値
  #     capacity_monitoring_approach = "sampledMaxInLast24Hours"
  #
  #     # target_percent (Optional)
  #     # 設定内容: ターゲットキャパシティのパーセンテージを指定します。
  #     # 設定可能な値: 正の数値（パーセント）
  #     target_percent = 150
  #
  #     # timeout_minutes (Optional)
  #     # 設定内容: タイムアウト時間を分単位で指定します。
  #     # 設定可能な値: 正の数値（分）
  #     timeout_minutes = null
  #
  #     # asg (Required)
  #     # 設定内容: Auto Scaling グループの設定ブロックです。
  #     asg {
  #       # arn (Required)
  #       # 設定内容: Auto Scaling グループの ARN を指定します。
  #       # 設定可能な値: 有効な Auto Scaling グループ ARN
  #       arn = "arn:aws:autoscaling:us-west-2:123456789012:autoScalingGroup:id:autoScalingGroupName/my-asg"
  #
  #       # cross_account_role (Optional)
  #       # 設定内容: クロスアカウントアクセス時に引き受ける IAM ロールの ARN を指定します。
  #       # 設定可能な値: 有効な IAM ロール ARN
  #       cross_account_role = null
  #
  #       # external_id (Optional)
  #       # 設定内容: クロスアカウントロール引き受け時の外部 ID を指定します。
  #       # 設定可能な値: 文字列
  #       external_id = null
  #     }
  #
  #     # ungraceful (Optional)
  #     # 設定内容: 非グレースフルモード時の動作設定ブロックです。
  #     # ungraceful {
  #     #   # minimum_success_percentage (Required)
  #     #   # 設定内容: 最低成功パーセンテージを指定します。
  #     #   # 設定可能な値: 0〜100 の数値
  #     #   minimum_success_percentage = 80
  #     # }
  #   }
  # }

  #-------------------------------------------------------------
  # ECS サービスキャパシティ増加設定 (ECSServiceScaling)
  #   execution_block_type = "ECSServiceScaling" のステップで使用
  #-------------------------------------------------------------

  # ecs_capacity_increase_config の設定例（ワークフロー step 内で使用）:
  # step {
  #   name                 = "ecs-scaling-step"
  #   execution_block_type = "ECSServiceScaling"
  #
  #   ecs_capacity_increase_config {
  #     # capacity_monitoring_approach (Required)
  #     # 設定内容: キャパシティ監視アプローチを指定します。
  #     # 設定可能な値:
  #     #   - "sampledMaxInLast24Hours": 過去24時間のサンプリング最大値
  #     #   - "containerInsightsMaxInLast24Hours": 過去24時間の Container Insights 最大値
  #     capacity_monitoring_approach = "sampledMaxInLast24Hours"
  #
  #     # target_percent (Optional)
  #     # 設定内容: ターゲットキャパシティのパーセンテージを指定します。
  #     # 設定可能な値: 正の数値（パーセント）
  #     target_percent = 200
  #
  #     # timeout_minutes (Optional)
  #     # 設定内容: タイムアウト時間を分単位で指定します。
  #     # 設定可能な値: 正の数値（分）
  #     timeout_minutes = null
  #
  #     # service (Required)
  #     # 設定内容: ECS サービスの設定ブロックです。
  #     service {
  #       # cluster_arn (Required)
  #       # 設定内容: ECS クラスターの ARN を指定します。
  #       # 設定可能な値: 有効な ECS クラスター ARN
  #       cluster_arn = "arn:aws:ecs:us-west-2:123456789012:cluster/my-cluster"
  #
  #       # service_arn (Required)
  #       # 設定内容: ECS サービスの ARN を指定します。
  #       # 設定可能な値: 有効な ECS サービス ARN
  #       service_arn = "arn:aws:ecs:us-west-2:123456789012:service/my-cluster/my-service"
  #
  #       # cross_account_role (Optional)
  #       # 設定内容: クロスアカウントアクセス時に引き受ける IAM ロールの ARN を指定します。
  #       # 設定可能な値: 有効な IAM ロール ARN
  #       cross_account_role = null
  #
  #       # external_id (Optional)
  #       # 設定内容: クロスアカウントロール引き受け時の外部 ID を指定します。
  #       # 設定可能な値: 文字列
  #       external_id = null
  #     }
  #
  #     # ungraceful (Optional)
  #     # 設定内容: 非グレースフルモード時の動作設定ブロックです。
  #     # ungraceful {
  #     #   # minimum_success_percentage (Required)
  #     #   # 設定内容: 最低成功パーセンテージを指定します。
  #     #   # 設定可能な値: 0〜100 の数値
  #     #   minimum_success_percentage = 80
  #     # }
  #   }
  # }

  #-------------------------------------------------------------
  # EKS リソーススケーリング設定 (EKSResourceScaling)
  #   execution_block_type = "EKSResourceScaling" のステップで使用
  #-------------------------------------------------------------

  # eks_resource_scaling_config の設定例（ワークフロー step 内で使用）:
  # step {
  #   name                 = "eks-scaling-step"
  #   execution_block_type = "EKSResourceScaling"
  #
  #   eks_resource_scaling_config {
  #     # capacity_monitoring_approach (Required)
  #     # 設定内容: キャパシティ監視アプローチを指定します。
  #     # 設定可能な値:
  #     #   - "sampledMaxInLast24Hours": 過去24時間のサンプリング最大値
  #     #   - "autoscalingMaxInLast24Hours": 過去24時間の Auto Scaling 最大値
  #     capacity_monitoring_approach = "sampledMaxInLast24Hours"
  #
  #     # target_percent (Required)
  #     # 設定内容: ターゲットキャパシティのパーセンテージを指定します。
  #     # 設定可能な値: 正の数値（パーセント）
  #     target_percent = 150
  #
  #     # timeout_minutes (Optional)
  #     # 設定内容: タイムアウト時間を分単位で指定します。
  #     # 設定可能な値: 正の数値（分）
  #     timeout_minutes = null
  #
  #     # kubernetes_resource_type (Required)
  #     # 設定内容: Kubernetes リソースタイプの設定ブロックです。
  #     kubernetes_resource_type {
  #       # api_version (Required)
  #       # 設定内容: Kubernetes API バージョンを指定します。
  #       # 設定可能な値: 有効な API バージョン文字列（例: "apps/v1"）
  #       api_version = "apps/v1"
  #
  #       # kind (Required)
  #       # 設定内容: Kubernetes リソースの種別を指定します。
  #       # 設定可能な値: 有効なリソース種別（例: "Deployment"）
  #       kind = "Deployment"
  #     }
  #
  #     # eks_clusters (Optional)
  #     # 設定内容: EKS クラスターの設定ブロックです。複数指定可能。
  #     # eks_clusters {
  #     #   # cluster_arn (Required)
  #     #   # 設定内容: EKS クラスターの ARN を指定します。
  #     #   # 設定可能な値: 有効な EKS クラスター ARN
  #     #   cluster_arn = "arn:aws:eks:us-west-2:123456789012:cluster/my-eks-cluster"
  #     #
  #     #   # cross_account_role (Optional)
  #     #   # 設定内容: クロスアカウントアクセス時に引き受ける IAM ロールの ARN を指定します。
  #     #   # 設定可能な値: 有効な IAM ロール ARN
  #     #   cross_account_role = null
  #     #
  #     #   # external_id (Optional)
  #     #   # 設定内容: クロスアカウントロール引き受け時の外部 ID を指定します。
  #     #   # 設定可能な値: 文字列
  #     #   external_id = null
  #     # }
  #
  #     # scaling_resources (Optional)
  #     # 設定内容: スケーリング対象リソースの設定ブロックです。複数指定可能。
  #     # scaling_resources {
  #     #   # namespace (Required)
  #     #   # 設定内容: Kubernetes 名前空間を指定します。
  #     #   # 設定可能な値: 有効な名前空間文字列
  #     #   namespace = "default"
  #     #
  #     #   # resources (Required)
  #     #   # 設定内容: スケーリング対象リソースの設定ブロックです。複数指定可能。
  #     #   resources {
  #     #     # resource_name (Required)
  #     #     # 設定内容: リソースの名前を指定します。
  #     #     # 設定可能な値: 文字列
  #     #     resource_name = "my-deployment"
  #     #
  #     #     # name (Required)
  #     #     # 設定内容: Kubernetes オブジェクトの名前を指定します。
  #     #     # 設定可能な値: 文字列
  #     #     name = "my-deployment"
  #     #
  #     #     # namespace (Required)
  #     #     # 設定内容: Kubernetes 名前空間を指定します。
  #     #     # 設定可能な値: 有効な名前空間文字列
  #     #     namespace = "default"
  #     #
  #     #     # hpa_name (Optional)
  #     #     # 設定内容: Horizontal Pod Autoscaler の名前を指定します。
  #     #     # 設定可能な値: 有効な HPA 名
  #     #     hpa_name = null
  #     #   }
  #     # }
  #
  #     # ungraceful (Optional)
  #     # 設定内容: 非グレースフルモード時の動作設定ブロックです。
  #     # ungraceful {
  #     #   # minimum_success_percentage (Required)
  #     #   # 設定内容: 最低成功パーセンテージを指定します。
  #     #   # 設定可能な値: 0〜100 の数値
  #     #   minimum_success_percentage = 80
  #     # }
  #   }
  # }

  #-------------------------------------------------------------
  # Route 53 ヘルスチェック設定 (Route53HealthCheck)
  #   execution_block_type = "Route53HealthCheck" のステップで使用
  #-------------------------------------------------------------

  # route53_health_check_config の設定例（ワークフロー step 内で使用）:
  # step {
  #   name                 = "route53-health-check-step"
  #   execution_block_type = "Route53HealthCheck"
  #
  #   route53_health_check_config {
  #     # hosted_zone_id (Required)
  #     # 設定内容: Route 53 ホストゾーン ID を指定します。
  #     # 設定可能な値: 有効なホストゾーン ID
  #     hosted_zone_id = "Z1234567890ABCDEF"
  #
  #     # record_name (Required)
  #     # 設定内容: DNS レコード名を指定します。
  #     # 設定可能な値: 有効な DNS レコード名
  #     record_name = "api.example.com"
  #
  #     # cross_account_role (Optional)
  #     # 設定内容: クロスアカウントアクセス時に引き受ける IAM ロールの ARN を指定します。
  #     # 設定可能な値: 有効な IAM ロール ARN
  #     cross_account_role = null
  #
  #     # external_id (Optional)
  #     # 設定内容: クロスアカウントロール引き受け時の外部 ID を指定します。
  #     # 設定可能な値: 文字列
  #     external_id = null
  #
  #     # timeout_minutes (Optional)
  #     # 設定内容: タイムアウト時間を分単位で指定します。
  #     # 設定可能な値: 正の数値（分）
  #     timeout_minutes = null
  #
  #     # record_set (Optional)
  #     # 設定内容: レコードセットの設定ブロックです。複数指定可能。
  #     # record_set {
  #     #   # record_set_identifier (Required)
  #     #   # 設定内容: レコードセットの識別子を指定します。
  #     #   # 設定可能な値: 文字列
  #     #   record_set_identifier = "us-east-1"
  #     #
  #     #   # region (Required)
  #     #   # 設定内容: AWS リージョンを指定します。
  #     #   # 設定可能な値: 有効な AWS リージョンコード
  #     #   region = "us-east-1"
  #     # }
  #   }
  # }

  #-------------------------------------------------------------
  # ネストされた Region Switch プラン設定 (ARCRegionSwitchPlan)
  #   execution_block_type = "ARCRegionSwitchPlan" のステップで使用
  #-------------------------------------------------------------

  # region_switch_plan_config の設定例（ワークフロー step 内で使用）:
  # step {
  #   name                 = "nested-plan-step"
  #   execution_block_type = "ARCRegionSwitchPlan"
  #
  #   region_switch_plan_config {
  #     # arn (Required)
  #     # 設定内容: ネストされた Region Switch プランの ARN を指定します。
  #     # 設定可能な値: 有効な Region Switch プラン ARN
  #     arn = "arn:aws:arc-region-switch:us-east-1:123456789012:plan/nested-plan"
  #
  #     # cross_account_role (Optional)
  #     # 設定内容: クロスアカウントアクセス時に引き受ける IAM ロールの ARN を指定します。
  #     # 設定可能な値: 有効な IAM ロール ARN
  #     cross_account_role = null
  #
  #     # external_id (Optional)
  #     # 設定内容: クロスアカウントロール引き受け時の外部 ID を指定します。
  #     # 設定可能な値: 文字列
  #     external_id = null
  #   }
  # }

  #-------------------------------------------------------------
  # 並列実行設定 (Parallel)
  #   execution_block_type = "Parallel" のステップで使用
  #-------------------------------------------------------------

  # parallel_config の設定例（ワークフロー step 内で使用）:
  # step {
  #   name                 = "parallel-step"
  #   execution_block_type = "Parallel"
  #
  #   parallel_config {
  #     # step (Required)
  #     # 設定内容: 並列に実行するステップの設定ブロックです。
  #     #   通常のステップと同じスキーマですが parallel_config を含めることはできません。
  #     #   複数指定可能。
  #     step {
  #       name                 = "asg-scaling"
  #       execution_block_type = "EC2AutoScaling"
  #
  #       ec2_asg_capacity_increase_config {
  #         capacity_monitoring_approach = "sampledMaxInLast24Hours"
  #         target_percent              = 150
  #
  #         asg {
  #           arn = "arn:aws:autoscaling:us-west-2:123456789012:autoScalingGroup:id:autoScalingGroupName/my-asg"
  #         }
  #       }
  #     }
  #
  #     step {
  #       name                 = "ecs-scaling"
  #       execution_block_type = "ECSServiceScaling"
  #
  #       ecs_capacity_increase_config {
  #         capacity_monitoring_approach = "sampledMaxInLast24Hours"
  #         target_percent              = 200
  #
  #         service {
  #           cluster_arn = "arn:aws:ecs:us-west-2:123456789012:cluster/my-cluster"
  #           service_arn = "arn:aws:ecs:us-west-2:123456789012:service/my-cluster/my-service"
  #         }
  #       }
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # トリガー設定
  #-------------------------------------------------------------

  # triggers (Optional)
  # 設定内容: プランの自動実行トリガーの設定ブロックです。
  #   CloudWatch アラームの条件に基づいてプランを自動的に実行します。
  #   複数指定可能。
  # triggers {
  #   # action (Required)
  #   # 設定内容: トリガーで実行するアクションを指定します。
  #   # 設定可能な値:
  #   #   - "activate": リージョンをアクティブにする
  #   #   - "deactivate": リージョンを非アクティブにする
  #   action = "activate"
  #
  #   # target_region (Required)
  #   # 設定内容: トリガーのターゲットリージョンを指定します。
  #   # 設定可能な値: 有効な AWS リージョンコード
  #   target_region = "us-west-2"
  #
  #   # min_delay_minutes_between_executions (Required)
  #   # 設定内容: プラン実行間の最小遅延時間を分単位で指定します。
  #   # 設定可能な値: 正の数値（分）
  #   min_delay_minutes_between_executions = 30
  #
  #   # description (Optional)
  #   # 設定内容: トリガーの説明を指定します。
  #   # 設定可能な値: 任意の文字列
  #   description = null
  #
  #   # conditions (Required)
  #   # 設定内容: トリガー条件の設定ブロックです。複数指定可能。
  #   conditions {
  #     # associated_alarm_name (Required)
  #     # 設定内容: 関連付けるアラームの名前を指定します。
  #     # 設定可能な値: associated_alarms で定義したアラーム名
  #     associated_alarm_name = "application-health-alarm"
  #
  #     # condition (Required)
  #     # 設定内容: トリガーの条件を指定します。
  #     # 設定可能な値:
  #     #   - "red": アラームが ALARM 状態の場合
  #     #   - "green": アラームが OK 状態の場合
  #     condition = "red"
  #   }
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーの default_tags 設定ブロックで定義されたタグと
  #   同じキーを持つ場合、リソースレベルのタグが優先されます。
  tags = {
    Name        = "example-plan"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "10m", "2h" 等の時間文字列
    create = null

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "10m", "2h" 等の時間文字列
    update = null

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "10m", "2h" 等の時間文字列
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Region Switch プランの ARN
# - tags_all: プロバイダーの default_tags 設定から継承されたタグを含む全タグマップ
#---------------------------------------------------------------
