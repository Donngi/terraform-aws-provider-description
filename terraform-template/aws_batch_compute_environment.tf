#---------------------------------------------------------------
# AWS Batch Compute Environment
#---------------------------------------------------------------
#
# AWS Batchのコンピューティング環境をプロビジョニングするリソースです。
# コンピューティング環境には、コンテナ化されたバッチジョブの実行に使用される
# Amazon ECSコンテナインスタンスが含まれます。
#
# AWS公式ドキュメント:
#   - AWS Batchとは: https://docs.aws.amazon.com/batch/latest/userguide/what-is-batch.html
#   - コンピューティング環境: https://docs.aws.amazon.com/batch/latest/userguide/compute_environments.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_compute_environment
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 重要: 環境削除時の競合状態を防ぐため、関連するaws_iam_role_policy_attachmentに
#       depends_onを設定してください。設定しない場合、ポリシーが先に削除され
#       コンピューティング環境がDELETING状態でスタックする可能性があります。
#
#---------------------------------------------------------------

resource "aws_batch_compute_environment" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: コンピューティング環境の名前を指定します。
  # 設定可能な値: 最大128文字（大文字・小文字・数字・アンダースコア）
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  name = "my-batch-compute-environment"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: コンピューティング環境名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  # name_prefix = "my-batch-"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # type (Required)
  # 設定内容: コンピューティング環境のタイプを指定します。
  # 設定可能な値:
  #   - "MANAGED": AWS Batchがコンピューティングリソースを管理。スケーリング、インスタンス起動/終了を自動化
  #   - "UNMANAGED": ユーザーがコンピューティングリソースを管理。自分でECSクラスターを制御
  type = "MANAGED"

  # state (Optional)
  # 設定内容: コンピューティング環境の状態を指定します。
  # 設定可能な値:
  #   - "ENABLED" (デフォルト): キューからジョブを受け入れ、必要に応じて自動スケール
  #   - "DISABLED": キューからジョブを受け入れない
  state = "ENABLED"

  # service_role (Optional)
  # 設定内容: AWS Batchが他のAWSサービスを呼び出すために使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 推奨ポリシー: AWSBatchServiceRole マネージドポリシー
  # 注意: Fargateの場合、サービスリンクロールが自動的に使用されるため省略可能
  service_role = "arn:aws:iam::123456789012:role/aws_batch_service_role"

  #-------------------------------------------------------------
  # コンピューティングリソース設定 (compute_resources)
  #-------------------------------------------------------------
  # MANAGEDタイプの場合に必須。コンピューティング環境で使用する
  # インスタンスの詳細設定を行います。

  compute_resources {
    #-----------------------------------------------------------
    # 基本設定
    #-----------------------------------------------------------

    # type (Required)
    # 設定内容: コンピューティングリソースのタイプを指定します。
    # 設定可能な値:
    #   - "EC2": オンデマンドEC2インスタンス
    #   - "SPOT": EC2スポットインスタンス（コスト削減に有効）
    #   - "FARGATE": AWS Fargate（サーバーレス）
    #   - "FARGATE_SPOT": Fargateスポット（サーバーレス・コスト削減）
    type = "EC2"

    # subnets (Required)
    # 設定内容: コンピューティングリソースを起動するVPCサブネットのリストを指定します。
    # 設定可能な値: 有効なサブネットIDのリスト
    # 注意: 複数のアベイラビリティゾーンのサブネットを指定することで可用性向上
    subnets = [
      "subnet-12345678",
      "subnet-87654321",
    ]

    # max_vcpus (Required)
    # 設定内容: 環境が到達可能な最大vCPU数を指定します。
    # 設定可能な値: 正の整数
    # 注意: コスト管理のために適切な上限を設定してください
    max_vcpus = 16

    # min_vcpus (Optional)
    # 設定内容: 環境が維持する最小vCPU数を指定します。
    # 設定可能な値: 0以上の整数
    # 省略時: EC2/SPOTの場合は0が設定されます
    # 注意: Fargateリソースには適用されません
    min_vcpus = 0

    # desired_vcpus (Optional)
    # 設定内容: コンピューティング環境で希望するEC2 vCPU数を指定します。
    # 設定可能な値: min_vcpus以上、max_vcpus以下の整数
    # 注意: Fargateリソースには適用されません
    desired_vcpus = 4

    #-----------------------------------------------------------
    # セキュリティ設定
    #-----------------------------------------------------------

    # security_group_ids (Optional)
    # 設定内容: インスタンスに関連付けるEC2セキュリティグループのリストを指定します。
    # 設定可能な値: 有効なセキュリティグループIDのリスト
    # 注意: Fargateコンピューティング環境では必須
    security_group_ids = [
      "sg-12345678",
    ]

    #-----------------------------------------------------------
    # インスタンス設定（EC2/SPOT専用）
    #-----------------------------------------------------------

    # instance_type (Optional)
    # 設定内容: 起動可能なインスタンスタイプのリストを指定します。
    # 設定可能な値: 有効なEC2インスタンスタイプのリスト（例: "c4.large", "m5.xlarge"）
    #   - "optimal": AWS Batchがジョブ要件に基づいて最適なインスタンスを選択
    # 注意: Fargateリソースには適用されません
    instance_type = [
      "c4.large",
      "m5.large",
    ]

    # instance_role (Optional)
    # 設定内容: EC2インスタンスに適用するECSインスタンスロール（インスタンスプロファイル）のARNを指定します。
    # 設定可能な値: 有効なIAMインスタンスプロファイルARN
    # 推奨ポリシー: AmazonEC2ContainerServiceforEC2Role マネージドポリシー
    # 注意: Fargateリソースには適用されません
    instance_role = "arn:aws:iam::123456789012:instance-profile/ecsInstanceRole"

    # allocation_strategy (Optional)
    # 設定内容: 最適なインスタンスタイプが十分に確保できない場合の割り当て戦略を指定します。
    # 設定可能な値:
    #   - "BEST_FIT" (デフォルト): ジョブ要件に最も適合する低コストのインスタンスタイプを選択
    #   - "BEST_FIT_PROGRESSIVE": 追加の容量が必要な場合、追加のインスタンスタイプを選択
    #   - "SPOT_CAPACITY_OPTIMIZED": SPOTの場合、中断リスクが最も低いプールから選択
    #   - "SPOT_PRICE_CAPACITY_OPTIMIZED": SPOTの場合、価格と中断リスクの両方を考慮
    # 参考: https://docs.aws.amazon.com/batch/latest/APIReference/API_ComputeResource.html#Batch-Type-ComputeResource-allocationStrategy
    # 注意: Fargateリソースには適用されません
    allocation_strategy = "BEST_FIT_PROGRESSIVE"

    # image_id (Optional, 非推奨)
    # 設定内容: インスタンスで使用するAMI IDを指定します。
    # 注意: この引数は非推奨です。代わりにec2_configurationのimage_id_overrideを使用してください。
    # 注意: Fargateリソースには適用されません
    # image_id = "ami-12345678"

    # ec2_key_pair (Optional)
    # 設定内容: インスタンスに使用するEC2キーペアを指定します。
    # 設定可能な値: 有効なEC2キーペア名
    # 用途: インスタンスへのSSHアクセスが必要な場合に設定
    # 注意: Fargateリソースには適用されません
    ec2_key_pair = "my-key-pair"

    # placement_group (Optional)
    # 設定内容: コンピューティングリソースに関連付けるEC2プレイスメントグループを指定します。
    # 設定可能な値: 有効なプレイスメントグループ名
    # 用途: 低レイテンシのネットワーク通信が必要なジョブに有効
    # 注意: Fargateリソースには適用されません
    placement_group = "my-placement-group"

    #-----------------------------------------------------------
    # スポットインスタンス設定（SPOT専用）
    #-----------------------------------------------------------

    # bid_percentage (Optional)
    # 設定内容: オンデマンド価格に対するスポット価格の最大許容パーセンテージを指定します。
    # 設定可能な値: 1-100の整数
    # 省略時: オンデマンド価格の100%
    # 例: 20を指定した場合、スポット価格がオンデマンド価格の20%以下の場合のみ起動
    # 注意: Fargateリソースには適用されません
    bid_percentage = 100

    # spot_iam_fleet_role (Optional)
    # 設定内容: SPOTコンピューティング環境に適用するEC2スポットフリートIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 注意: SPOTコンピューティング環境では必須
    # 注意: Fargateリソースには適用されません
    spot_iam_fleet_role = "arn:aws:iam::123456789012:role/aws_ec2_spot_fleet_role"

    #-----------------------------------------------------------
    # EC2設定 (ec2_configuration)
    #-----------------------------------------------------------
    # AMI選択のカスタマイズに使用します。最大2つまで指定可能。
    # Fargateリソースには適用されません。

    ec2_configuration {
      # image_type (Optional)
      # 設定内容: インスタンスタイプに一致させるAMIのイメージタイプを指定します。
      # 設定可能な値:
      #   - "ECS_AL2" (デフォルト): Amazon Linux 2 ECS最適化AMI
      #   - "ECS_AL2023": Amazon Linux 2023 ECS最適化AMI
      #   - "ECS_AL2_NVIDIA": NVIDIA GPU用Amazon Linux 2 ECS最適化AMI
      #   - "ECS_AL2023_NVIDIA": NVIDIA GPU用Amazon Linux 2023 ECS最適化AMI
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
      image_type = "ECS_AL2"

      # image_id_override (Optional)
      # 設定内容: イメージタイプに一致するインスタンスで使用するAMI IDを指定します。
      # 設定可能な値: 有効なAMI ID
      # 省略時: 選択したimage_typeに対応する最新のAMIが使用されます
      # 用途: カスタムAMIを使用する場合に設定
      # image_id_override = "ami-12345678"

      # image_kubernetes_version (Optional)
      # 設定内容: EKSコンピューティング環境のKubernetesバージョンを指定します。
      # 設定可能な値: AWS Batchがサポートするバージョン
      # 参考: https://docs.aws.amazon.com/batch/latest/userguide/supported_kubernetes_version.html
      # 省略時: AWS Batchがサポートする最新バージョン
      # 注意: EKSコンピューティング環境でのみ使用
      # image_kubernetes_version = "1.28"
    }

    #-----------------------------------------------------------
    # 起動テンプレート設定 (launch_template)
    #-----------------------------------------------------------
    # カスタム起動テンプレートを使用してインスタンスをカスタマイズします。
    # Fargateリソースには適用されません。

    launch_template {
      # launch_template_id (Optional)
      # 設定内容: 起動テンプレートのIDを指定します。
      # 設定可能な値: 有効な起動テンプレートID
      # 注意: launch_template_nameと排他的（どちらか一方を指定）
      launch_template_id = "lt-12345678901234567"

      # launch_template_name (Optional)
      # 設定内容: 起動テンプレートの名前を指定します。
      # 設定可能な値: 有効な起動テンプレート名
      # 注意: launch_template_idと排他的（どちらか一方を指定）
      # launch_template_name = "my-launch-template"

      # version (Optional)
      # 設定内容: 起動テンプレートのバージョン番号を指定します。
      # 設定可能な値: バージョン番号（文字列）、"$Latest"、"$Default"
      # 省略時: 起動テンプレートのデフォルトバージョン
      version = "$Latest"
    }

    #-----------------------------------------------------------
    # タグ設定
    #-----------------------------------------------------------

    # tags (Optional)
    # 設定内容: コンピューティング環境で起動されるリソースに適用するタグを指定します。
    # 設定可能な値: キーと値のペアのマップ
    # 注意: Fargateリソースには適用されません
    tags = {
      Name = "batch-compute-resource"
    }
  }

  #-------------------------------------------------------------
  # EKS設定 (eks_configuration)
  #-------------------------------------------------------------
  # Amazon EKSクラスターをコンピューティング環境のバックエンドとして使用する場合に設定します。
  # compute_resourcesブロックと併用可能ですが、通常は別々のユースケースです。

  # eks_configuration {
  #   # eks_cluster_arn (Required)
  #   # 設定内容: コンピューティング環境をサポートするAmazon EKSクラスターのARNを指定します。
  #   # 設定可能な値: 有効なEKSクラスターARN
  #   eks_cluster_arn = "arn:aws:eks:ap-northeast-1:123456789012:cluster/my-eks-cluster"

  #   # kubernetes_namespace (Required)
  #   # 設定内容: AWS Batchがポッドを管理するKubernetes名前空間を指定します。
  #   # 設定可能な値: 有効なKubernetes名前空間名
  #   kubernetes_namespace = "batch"
  # }

  #-------------------------------------------------------------
  # 更新ポリシー設定 (update_policy)
  #-------------------------------------------------------------
  # コンピューティング環境のインフラ更新時の動作を制御します。

  update_policy {
    # job_execution_timeout_minutes (Optional)
    # 設定内容: インフラ更新時のジョブタイムアウト（分）を指定します。
    # 設定可能な値: 正の整数（分単位）
    # 用途: 更新中に実行中のジョブを待機する最大時間を設定
    job_execution_timeout_minutes = 30

    # terminate_jobs_on_update (Optional)
    # 設定内容: インフラ更新時にジョブを自動終了するかを指定します。
    # 設定可能な値:
    #   - true: 更新時に実行中のジョブを終了
    #   - false: 更新時にジョブの完了を待機（タイムアウトまで）
    terminate_jobs_on_update = false
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
    Name        = "my-batch-compute-environment"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されたタグを含む、すべてのタグのマップ。
  # 注意: 通常は直接設定せず、tagsとdefault_tagsから自動計算されます。

  #-------------------------------------------------------------
  # 依存関係
  #-------------------------------------------------------------
  # 重要: 競合状態を防ぐため、IAMロールポリシーアタッチメントへの依存関係を設定してください。
  # depends_on = [aws_iam_role_policy_attachment.aws_batch_service_role]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コンピューティング環境のAmazon Resource Name (ARN)
#
# - ecs_cluster_arn: コンピューティング環境で使用される基盤となる
#                    Amazon ECSクラスターのARN
#
# - status: コンピューティング環境の現在のステータス
#           例: CREATING, UPDATING, DELETING, DELETED, VALID, INVALID
#
# - status_reason: 現在のステータスに関する追加の詳細を提供する
#                  短い人間が読める文字列
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
