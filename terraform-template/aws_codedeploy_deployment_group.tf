#---------------------------------------------------------------
# AWS CodeDeploy Deployment Group
#---------------------------------------------------------------
#
# CodeDeployデプロイメントグループをプロビジョニングするリソースです。
# デプロイメントグループは、デプロイ先となるインスタンスまたはサービスの
# セットを定義し、デプロイ設定やロールバック設定などを管理します。
#
# AWS公式ドキュメント:
#   - CodeDeploy概要: https://docs.aws.amazon.com/codedeploy/latest/userguide/welcome.html
#   - デプロイメントグループの操作: https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_codedeploy_deployment_group" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # app_name (Required)
  # 設定内容: このデプロイメントグループが所属するCodeDeployアプリケーションの名前を指定します。
  # 設定可能な値: 既存のCodeDeployアプリケーション名
  app_name = "my-app"

  # deployment_group_name (Required)
  # 設定内容: デプロイメントグループの名前を指定します。
  # 設定可能な値: 1-100文字の文字列（英数字、ハイフン、アンダースコア）
  deployment_group_name = "my-deployment-group"

  # service_role_arn (Required)
  # 設定内容: CodeDeployがデプロイを実行する際に使用するIAMサービスロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 関連機能: CodeDeploy IAMサービスロール
  #   CodeDeployがユーザーに代わってAWSリソース（EC2インスタンス、Auto Scalingグループ、
  #   ロードバランサーなど）にアクセスするための権限を付与します。
  #   - https://docs.aws.amazon.com/codedeploy/latest/userguide/getting-started-create-service-role.html
  service_role_arn = "arn:aws:iam::123456789012:role/CodeDeployServiceRole"

  #-------------------------------------------------------------
  # デプロイ設定
  #-------------------------------------------------------------

  # deployment_config_name (Optional)
  # 設定内容: このデプロイメントグループで使用するデプロイ設定の名前を指定します。
  # 設定可能な値:
  #   - 定義済み設定: CodeDeployDefault.OneAtATime（デフォルト）、CodeDeployDefault.HalfAtATime、
  #     CodeDeployDefault.AllAtOnce など
  #   - カスタム設定: ユーザーが作成したカスタムデプロイ設定名
  # 省略時: "CodeDeployDefault.OneAtATime" が使用されます
  # 関連機能: デプロイ設定
  #   一度にデプロイするインスタンス数や、成功・失敗の条件を定義します。
  #   - https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-configurations.html
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  #-------------------------------------------------------------
  # Auto Scalingグループ設定
  #-------------------------------------------------------------

  # autoscaling_groups (Optional)
  # 設定内容: このデプロイメントグループに関連付けるAuto Scalingグループ名のリストを指定します。
  # 設定可能な値: Auto Scalingグループ名の配列
  # 関連機能: Auto Scalingグループとの統合
  #   Auto Scalingグループ内のインスタンスに自動的にデプロイを実行します。
  #   新しくスケールアウトしたインスタンスにも自動的にアプリケーションがデプロイされます。
  #   - https://docs.aws.amazon.com/codedeploy/latest/userguide/integrations-aws-auto-scaling.html
  autoscaling_groups = ["my-asg"]

  #-------------------------------------------------------------
  # インスタンス戦略設定
  #-------------------------------------------------------------

  # outdated_instances_strategy (Optional)
  # 設定内容: デプロイ途中に起動された新しいEC2インスタンスがデプロイされたアプリケーションリビジョンを
  #           受け取らなかった場合の動作を指定します。
  # 設定可能な値:
  #   - "UPDATE" (デフォルト): 新しいインスタンスにもデプロイを実行します
  #   - "IGNORE": 新しいインスタンスを無視します
  # 省略時: "UPDATE" が使用されます
  outdated_instances_strategy = "UPDATE"

  # termination_hook_enabled (Optional)
  # 設定内容: CodeDeployがAuto ScalingグループにTermination Hookをインストールするかを指定します。
  # 設定可能な値:
  #   - true: Termination Hookを有効化します
  #   - false: Termination Hookを無効化します
  # 関連機能: Auto Scaling Termination Hook
  #   インスタンスが終了される前にCodeDeployがクリーンアップ処理を実行できるようにします。
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/lifecycle-hooks.html
  termination_hook_enabled = true

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
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "my-deployment-group"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # アラーム設定
  #-------------------------------------------------------------

  # alarm_configuration (Optional, Max: 1)
  alarm_configuration {
    # alarms (Optional)
    # 設定内容: デプロイメントグループに関連付けるCloudWatchアラーム名のリストを指定します。
    # 設定可能な値: CloudWatchアラーム名の配列
    alarms = ["my-alarm-1", "my-alarm-2"]

    # enabled (Optional)
    # 設定内容: アラーム設定を有効にするかを指定します。
    # 設定可能な値:
    #   - true: アラーム監視を有効化します
    #   - false: アラーム監視を無効化します
    # 用途: 一時的にアラーム監視を無効にしたい場合、後で再度同じアラームを
    #       追加する必要なく設定を切り替えられます。
    enabled = true

    # ignore_poll_alarm_failure (Optional)
    # 設定内容: CloudWatchからアラームの現在の状態に関する情報を取得できない場合に
    #           デプロイを続行するかを指定します。
    # 設定可能な値:
    #   - true: アラーム状態を取得できなくてもデプロイを続行します
    #   - false (デフォルト): アラーム状態を取得できない場合はデプロイを停止します
    ignore_poll_alarm_failure = false
  }

  #-------------------------------------------------------------
  # 自動ロールバック設定
  #-------------------------------------------------------------

  # auto_rollback_configuration (Optional, Max: 1)
  auto_rollback_configuration {
    # enabled (Optional)
    # 設定内容: 自動ロールバックを有効にするかを指定します。
    # 設定可能な値:
    #   - true: 自動ロールバックを有効化します（少なくとも1つのイベントタイプを指定する必要があります）
    #   - false: 自動ロールバックを無効化します
    enabled = true

    # events (Optional)
    # 設定内容: ロールバックをトリガーするイベントタイプを指定します。
    # 設定可能な値:
    #   - "DEPLOYMENT_FAILURE": デプロイが失敗した場合
    #   - "DEPLOYMENT_STOP_ON_ALARM": CloudWatchアラームがトリガーされた場合
    #   - "DEPLOYMENT_STOP_ON_REQUEST": 手動でデプロイが停止された場合
    # 関連機能: 自動ロールバック
    #   指定されたイベントが発生した場合、以前に正常にデプロイされたリビジョンに
    #   自動的にロールバックします。
    #   - https://docs.aws.amazon.com/codedeploy/latest/userguide/deployments-rollback-and-redeploy.html
    events = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM"]
  }

  #-------------------------------------------------------------
  # Blue/Greenデプロイ設定
  #-------------------------------------------------------------

  # blue_green_deployment_config (Optional, Max: 1)
  blue_green_deployment_config {
    # deployment_ready_option (Optional, Max: 1)
    # 設定内容: Blue/Greenデプロイで新しくプロビジョニングされたインスタンスが
    #           トラフィックを受け取る準備ができたときのアクションを指定します。
    deployment_ready_option {
      # action_on_timeout (Optional)
      # 設定内容: タイムアウト時のトラフィック再ルーティング動作を指定します。
      # 設定可能な値:
      #   - "CONTINUE_DEPLOYMENT": 新しいアプリケーションリビジョンが置き換え環境の
      #     インスタンスにインストールされた直後に、ロードバランサーに新しいインスタンスを登録します
      #   - "STOP_DEPLOYMENT": トラフィックが手動で再ルーティングされない限り、
      #     新しいインスタンスをロードバランサーに登録しません。指定された待機時間内に
      #     トラフィックが手動で再ルーティングされない場合、デプロイステータスはStoppedに変更されます
      action_on_timeout = "CONTINUE_DEPLOYMENT"

      # wait_time_in_minutes (Optional)
      # 設定内容: トラフィックが手動で再ルーティングされない場合にBlue/Greenデプロイの
      #           ステータスがStoppedに変更されるまでの待機時間（分）を指定します。
      # 設定可能な値: 0-2880の整数（分）
      # 適用対象: action_on_timeoutが"STOP_DEPLOYMENT"の場合のみ
      wait_time_in_minutes = 60
    }

    # green_fleet_provisioning_option (Optional, Max: 1)
    # 設定内容: Blue/Greenデプロイで置き換え環境のインスタンスをどのようにプロビジョニングするかを指定します。
    green_fleet_provisioning_option {
      # action (Optional)
      # 設定内容: 置き換え環境へのインスタンス追加方法を指定します。
      # 設定可能な値:
      #   - "DISCOVER_EXISTING": 既に存在するインスタンスまたは手動で作成されるインスタンスを使用します
      #   - "COPY_AUTO_SCALING_GROUP": 指定されたAuto Scalingグループの設定を使用して、
      #     新しいAuto Scalingグループ内にインスタンスを定義・作成します。
      #     この場合、autoscaling_groupsで正確に1つのAuto Scalingグループを指定する必要があります。
      # 注意: COPY_AUTO_SCALING_GROUPを使用すると、CodeDeployが新しいASGを作成しますが、
      #       このASGはTerraformで管理されず、既存の設定や状態と競合する可能性があります。
      #       別のアプローチ（DISCOVER_EXISTINGなど）の使用を検討してください。
      action = "DISCOVER_EXISTING"
    }

    # terminate_blue_instances_on_deployment_success (Optional, Max: 1)
    # 設定内容: Blue/Greenデプロイが成功した後、元の環境のインスタンスをどのように
    #           終了するかを指定します。
    terminate_blue_instances_on_deployment_success {
      # action (Optional)
      # 設定内容: 元の環境のインスタンスに対するアクションを指定します。
      # 設定可能な値:
      #   - "TERMINATE": 指定された待機時間後にインスタンスを終了します
      #   - "KEEP_ALIVE": インスタンスをロードバランサーから登録解除し、
      #     デプロイメントグループから削除した後も、インスタンスを実行状態のままにします
      action = "TERMINATE"

      # termination_wait_time_in_minutes (Optional)
      # 設定内容: Blue/Greenデプロイが成功してから元の環境のインスタンスを
      #           終了するまでの待機時間（分）を指定します。
      # 設定可能な値: 0-2880の整数（分）
      termination_wait_time_in_minutes = 5
    }
  }

  #-------------------------------------------------------------
  # デプロイスタイル設定
  #-------------------------------------------------------------

  # deployment_style (Optional, Max: 1)
  deployment_style {
    # deployment_option (Optional)
    # 設定内容: デプロイトラフィックをロードバランサーの背後でルーティングするかを指定します。
    # 設定可能な値:
    #   - "WITH_TRAFFIC_CONTROL": ロードバランサーを使用してトラフィックを制御します
    #   - "WITHOUT_TRAFFIC_CONTROL" (デフォルト): ロードバランサーを使用しません
    deployment_option = "WITH_TRAFFIC_CONTROL"

    # deployment_type (Optional)
    # 設定内容: In-PlaceデプロイかBlue/Greenデプロイかを指定します。
    # 設定可能な値:
    #   - "IN_PLACE" (デフォルト): 既存のインスタンスでアプリケーションを更新します
    #   - "BLUE_GREEN": 新しいインスタンスセットを作成し、トラフィックを切り替えます
    # 関連機能: デプロイタイプ
    #   - In-Place: 既存インスタンスのアプリケーションを停止し、最新リビジョンをインストールして再起動
    #   - Blue/Green: 新しいインスタンス（Green）を起動し、準備完了後にトラフィックを旧インスタンス（Blue）から切り替え
    #   - https://docs.aws.amazon.com/codedeploy/latest/userguide/welcome.html#welcome-deployment-overview
    deployment_type = "BLUE_GREEN"
  }

  #-------------------------------------------------------------
  # EC2タグフィルター設定
  #-------------------------------------------------------------

  # ec2_tag_filter (Optional, Multiple allowed)
  # 設定内容: デプロイメントグループに関連付けるEC2インスタンスを識別するためのタグフィルターを指定します。
  # 注意: 複数のec2_tag_filterを指定した場合、少なくとも1つのタグフィルターに
  #       一致するインスタンスが選択されます（OR条件）。
  ec2_tag_filter {
    # key (Optional)
    # 設定内容: タグフィルターのキーを指定します。
    # 設定可能な値: 文字列
    key = "Environment"

    # type (Optional)
    # 設定内容: タグフィルターのタイプを指定します。
    # 設定可能な値:
    #   - "KEY_ONLY": キーのみでフィルタリングします
    #   - "VALUE_ONLY": 値のみでフィルタリングします
    #   - "KEY_AND_VALUE": キーと値の両方でフィルタリングします
    type = "KEY_AND_VALUE"

    # value (Optional)
    # 設定内容: タグフィルターの値を指定します。
    # 設定可能な値: 文字列
    value = "production"
  }

  #-------------------------------------------------------------
  # EC2タグセット設定
  #-------------------------------------------------------------

  # ec2_tag_set (Optional, Multiple allowed)
  # 設定内容: タググループとも呼ばれる、デプロイメントグループに関連付けるタグフィルターの
  #           設定ブロックを指定します。
  # 注意: ec2_tag_set内の複数のec2_tag_filterはAND条件で評価されます。
  #       複数のec2_tag_setがある場合はOR条件で評価されます。
  # 関連機能: タググループ
  #   より複雑なタグフィルタリング条件を作成できます。
  #   - https://docs.aws.amazon.com/codedeploy/latest/userguide/instances-tagging.html
  ec2_tag_set {
    ec2_tag_filter {
      # key (Optional)
      # 設定内容: タグフィルターのキーを指定します。
      key = "Environment"

      # type (Optional)
      # 設定内容: タグフィルターのタイプを指定します。
      # 設定可能な値: "KEY_ONLY", "VALUE_ONLY", "KEY_AND_VALUE"
      type = "KEY_AND_VALUE"

      # value (Optional)
      # 設定内容: タグフィルターの値を指定します。
      value = "production"
    }

    ec2_tag_filter {
      key   = "Application"
      type  = "KEY_AND_VALUE"
      value = "web"
    }
  }

  #-------------------------------------------------------------
  # ECSサービス設定
  #-------------------------------------------------------------

  # ecs_service (Optional, Max: 1)
  # 設定内容: デプロイメントグループのECSサービス設定を指定します。
  # 用途: ECSコンピュートプラットフォームを使用する場合に指定します。
  ecs_service {
    # cluster_name (Required)
    # 設定内容: ECSクラスターの名前を指定します。
    # 設定可能な値: 既存のECSクラスター名
    cluster_name = "my-ecs-cluster"

    # service_name (Required)
    # 設定内容: ECSサービスの名前を指定します。
    # 設定可能な値: 既存のECSサービス名
    service_name = "my-ecs-service"
  }

  #-------------------------------------------------------------
  # ロードバランサー設定
  #-------------------------------------------------------------

  # load_balancer_info (Optional, Max: 1)
  # 設定内容: Blue/Greenデプロイで使用するロードバランサーの設定を指定します。
  # 注意: elb_info、target_group_info、target_group_pair_infoは互いに排他的です。
  load_balancer_info {
    # elb_info (Optional, Multiple allowed)
    # 設定内容: Classic Elastic Load Balancerを使用する場合の設定です。
    # 競合: target_group_infoおよびtarget_group_pair_infoと競合します。
    elb_info {
      # name (Optional)
      # 設定内容: ロードバランサーの名前を指定します。
      # 設定可能な値: Classic ELB名
      # 用途:
      #   - Blue/Greenデプロイ: 元のインスタンスから置き換えインスタンスへ
      #     トラフィックをルーティングするために使用されます
      #   - In-Placeデプロイ: デプロイ中にインスタンスの登録解除・再登録に使用されます
      name = "my-elb"
    }

    # target_group_info (Optional, Multiple allowed)
    # 設定内容: Application/Network Load Balancerのターゲットグループを使用する場合の設定です。
    # 競合: elb_infoおよびtarget_group_pair_infoと競合します。
    target_group_info {
      # name (Optional)
      # 設定内容: ターゲットグループの名前を指定します。
      # 設定可能な値: ALB/NLBターゲットグループ名
      # 用途:
      #   - Blue/Greenデプロイ: 元の環境のインスタンスが登録解除され、
      #     置き換え環境のインスタンスが登録されます
      #   - In-Placeデプロイ: デプロイ中にインスタンスの登録解除・再登録に使用されます
      name = "my-target-group"
    }

    # target_group_pair_info (Optional, Max: 1)
    # 設定内容: Application/Network Load Balancerのターゲットグループペアを使用する場合の設定です。
    # 競合: elb_infoおよびtarget_group_infoと競合します。
    # 用途: ECS Blue/Greenデプロイで主に使用されます。
    target_group_pair_info {
      # prod_traffic_route (Required, Max: 1)
      # 設定内容: 本番トラフィックルートの設定を指定します。
      prod_traffic_route {
        # listener_arns (Required)
        # 設定内容: ロードバランサーリスナーのARNリストを指定します。
        # 設定可能な値: リスナーARNの配列（正確に1つのリスナーARNを含む必要があります）
        listener_arns = ["arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:listener/app/my-alb/1234567890abcdef/1234567890abcdef"]
      }

      # target_group (Required, Min: 1, Max: 2)
      # 設定内容: ターゲットグループの設定を指定します。
      # 注意: 1つまたは2つのターゲットグループを指定する必要があります。
      target_group {
        # name (Required)
        # 設定内容: ターゲットグループの名前を指定します。
        # 設定可能な値: ターゲットグループ名
        name = "my-blue-target-group"
      }

      target_group {
        name = "my-green-target-group"
      }

      # test_traffic_route (Optional, Max: 1)
      # 設定内容: テストトラフィックルートの設定を指定します。
      test_traffic_route {
        # listener_arns (Required)
        # 設定内容: ロードバランサーリスナーのARNリストを指定します。
        # 設定可能な値: リスナーARNの配列
        listener_arns = ["arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:listener/app/my-alb/1234567890abcdef/0987654321fedcba"]
      }
    }
  }

  #-------------------------------------------------------------
  # オンプレミスインスタンスタグフィルター設定
  #-------------------------------------------------------------

  # on_premises_instance_tag_filter (Optional, Multiple allowed)
  # 設定内容: デプロイメントグループに関連付けるオンプレミスインスタンスを
  #           識別するためのタグフィルターを指定します。
  # 関連機能: オンプレミスインスタンス
  #   オンプレミスのサーバーやVMにもCodeDeployでデプロイできます。
  #   - https://docs.aws.amazon.com/codedeploy/latest/userguide/instances-on-premises.html
  on_premises_instance_tag_filter {
    # key (Optional)
    # 設定内容: タグフィルターのキーを指定します。
    key = "Environment"

    # type (Optional)
    # 設定内容: タグフィルターのタイプを指定します。
    # 設定可能な値: "KEY_ONLY", "VALUE_ONLY", "KEY_AND_VALUE"
    type = "KEY_AND_VALUE"

    # value (Optional)
    # 設定内容: タグフィルターの値を指定します。
    value = "production"
  }

  #-------------------------------------------------------------
  # トリガー設定
  #-------------------------------------------------------------

  # trigger_configuration (Optional, Multiple allowed)
  # 設定内容: デプロイメントグループのトリガー設定を指定します。
  # 用途: デプロイイベントが発生したときにAmazon SNS通知を送信します。
  # 関連機能: デプロイメント通知
  #   デプロイの開始、成功、失敗などのイベントで通知を受け取れます。
  #   - https://docs.aws.amazon.com/codedeploy/latest/userguide/monitoring-sns-event-notifications.html
  trigger_configuration {
    # trigger_events (Required)
    # 設定内容: 通知をトリガーするイベントタイプを指定します。
    # 設定可能な値:
    #   - "DeploymentStart": デプロイ開始時
    #   - "DeploymentSuccess": デプロイ成功時
    #   - "DeploymentFailure": デプロイ失敗時
    #   - "DeploymentStop": デプロイ停止時
    #   - "DeploymentRollback": デプロイロールバック時
    #   - "InstanceStart": インスタンスデプロイ開始時
    #   - "InstanceSuccess": インスタンスデプロイ成功時
    #   - "InstanceFailure": インスタンスデプロイ失敗時
    # 参考: https://docs.aws.amazon.com/codedeploy/latest/userguide/monitoring-sns-event-notifications-create-trigger.html
    trigger_events = ["DeploymentStart", "DeploymentSuccess", "DeploymentFailure"]

    # trigger_name (Required)
    # 設定内容: 通知トリガーの名前を指定します。
    # 設定可能な値: 文字列
    trigger_name = "deployment-notifications"

    # trigger_target_arn (Required)
    # 設定内容: 通知を送信するSNSトピックのARNを指定します。
    # 設定可能な値: 有効なSNSトピックARN
    trigger_target_arn = "arn:aws:sns:ap-northeast-1:123456789012:deployment-notifications"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: CodeDeployデプロイメントグループのARN
#
# - compute_platform: デプロイの宛先プラットフォームタイプ
#   (Server, Lambda, ECS)
#
# - deployment_group_id: CodeDeployデプロイメントグループのID
#
# - id: アプリケーション名とデプロイメントグループ名
#   (形式: app_name:deployment_group_name)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
